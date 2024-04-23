import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hicoder/models/post.dart';
import 'package:hicoder/services/post_service.dart';
import 'package:hicoder/services/user_service.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/media_service.dart';
import '../../views/components/snack_bar.dart';

class PostsViewModel extends ChangeNotifier {
  //Services
  UserService userService = UserService();
  PostService postService = PostService();

  //Keys
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //Variables
  bool loading = false;
  PostModel? post;
  final picker = ImagePicker();
  //Functions
  pickImage({bool camera = false, required BuildContext context}) async {
    loading = true;
    notifyListeners();
    try {
      XFile? pickedFile = await picker.pickImage(
          source: camera ? ImageSource.camera : ImageSource.gallery,
          imageQuality: 50);
      File mediaFile = File(pickedFile!.path);
      post!.mediaUrl = await MediaService().uploadMedia(mediaFile);
      loading = false;
      notifyListeners();
    } catch (e) {
      loading = false;
      notifyListeners();
      if (context.mounted) showInSnackBar('Cancelled', context);
    }
  }

  uploadPosts(BuildContext context) async {
    try {
      loading = true;
      notifyListeners();
      if (post!.mediaUrl == null) {
        await postService.createPost(content: post!.content!);
      } else {
        await postService.createPost(
            content: post!.content!, mediaUrl: post!.mediaUrl!);
      }
      loading = false;
      resetPost();
      notifyListeners();
      if (context.mounted) showInSnackBar('Uploaded successfully!', context);
    } on Exception catch (e) {
      debugPrint(e.toString());
      loading = false;
      resetPost();
      if (context.mounted) showInSnackBar(e.toString().split(':')[1], context);
      notifyListeners();
    }
  }

  resetPost() {
    post = PostModel();
    notifyListeners();
  }

  setContent(String val) {
    post!.content = val;
    notifyListeners();
  }

  void toggleLikePost(PostModel postModel) async {
    postModel.setLiked = !postModel.getLiked;
    if (postModel.getLiked) {
      postModel.setLikesCount = postModel.getLikesCount + 1;
    } else {
      postModel.setLikesCount = postModel.getLikesCount - 1;
    }
    await postService.likePostToggle(postId: postModel.id!);
    notifyListeners();
  }
}
