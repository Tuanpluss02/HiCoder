// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hicoder/models/post.dart';
import 'package:hicoder/services/post_service.dart';
import 'package:hicoder/services/user_service.dart';
import 'package:image_picker/image_picker.dart';

import '../../screens/mainscreen.dart';
import '../../services/media_service.dart';

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

  TextEditingController locationTEC = TextEditingController();

  setPost(PostModel post) {
    this.post = post;
    notifyListeners();
  }

  //Functions
  pickImage({bool camera = false, required BuildContext context}) async {
    loading = true;
    notifyListeners();
    try {
      XFile? pickedFile = await picker.pickImage(
          source: camera ? ImageSource.camera : ImageSource.gallery,
          imageQuality: 50);
      // CroppedFile? croppedFile = await ImageCropper().cropImage(
      //   sourcePath: pickedFile!.path,
      //   aspectRatioPresets: [
      //     CropAspectRatioPreset.square,
      //     CropAspectRatioPreset.ratio3x2,
      //     CropAspectRatioPreset.original,
      //     CropAspectRatioPreset.ratio4x3,
      //     CropAspectRatioPreset.ratio16x9
      //   ],
      //   uiSettings: [
      //     AndroidUiSettings(
      //       toolbarTitle: 'Crop Image',
      //       toolbarColor: Constants.lightAccent,
      //       toolbarWidgetColor: Colors.white,
      //       initAspectRatio: CropAspectRatioPreset.original,
      //       lockAspectRatio: false,
      //     ),
      //     IOSUiSettings(
      //       minimumAspectRatio: 1.0,
      //     ),
      //   ],
      // );
      File mediaFile = File(pickedFile!.path);
      post!.mediaUrl = await MediaService().uploadMedia(mediaFile);
      loading = false;
      notifyListeners();
    } catch (e) {
      loading = false;
      notifyListeners();
      showInSnackBar('Cancelled', context);
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
      showInSnackBar('Uploaded successfully!', context);
    } on Exception catch (e) {
      debugPrint(e.toString());
      loading = false;
      resetPost();
      showInSnackBar(e.toString().split(':')[1], context);
      notifyListeners();
    }
  }

  uploadProfilePicture(BuildContext context) async {
    if (post!.mediaUrl == null) {
      showInSnackBar('Please select an image', context);
    } else {
      try {
        loading = true;
        notifyListeners();
        await userService.updateAvatar(avatarUrl: post!.mediaUrl!);
        loading = false;
        Navigator.of(context).pushReplacement(
            CupertinoPageRoute(builder: (_) => const TabScreen()));
        notifyListeners();
        showInSnackBar('Uploaded successfully!', context);
      } catch (e) {
        debugPrint(e.toString());
        loading = false;
        showInSnackBar(e.toString().split(':')[1], context);
        notifyListeners();
      }
    }
  }

  resetPost() {
    post = PostModel();
    notifyListeners();
  }

  void showInSnackBar(String value, BuildContext context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }

  setContent(String val) {
    post!.content = val;
    notifyListeners();
  }
}
