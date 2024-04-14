// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
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
  String? username;
  String? mediaUrl;
  final picker = ImagePicker();
  Position? position;
  Placemark? placemark;
  String? bio;
  String? content;
  String? title;
  String? email;
  String? commentData;
  String? ownerId;
  String? userId;
  String? type;
  File? userDp;
  String? imgLink;
  bool edit = false;
  String? id;

  //controllers
  TextEditingController locationTEC = TextEditingController();

  //Setters
  setEdit(bool val) {
    edit = val;
    notifyListeners();
  }

  setPost(PostModel post) {
    title = post.title;
    content = post.content;
    imgLink = post.mediaUrl;
    edit = true;
    edit = false;
    notifyListeners();
  }

  setUsername(String val) {
    debugPrint('SetName $val');
    username = val;
    notifyListeners();
  }

  setContent(String val) {
    debugPrint('setContent $val');
    content = val;
    notifyListeners();
  }

  setTitle(String val) {
    debugPrint('setContent $val');
    title = val;
    notifyListeners();
  }

  setBio(String val) {
    debugPrint('SetBio $val');
    bio = val;
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
      mediaUrl = await MediaService().uploadMedia(mediaFile);
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
      await postService.createPost(
          title: title!, content: content!, mediaUrl: mediaUrl!);
      loading = false;
      resetPost();
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
      loading = false;
      resetPost();
      showInSnackBar('Uploaded successfully!', context);
      notifyListeners();
    }
  }

  uploadProfilePicture(BuildContext context) async {
    if (mediaUrl == null) {
      showInSnackBar('Please select an image', context);
    } else {
      try {
        loading = true;
        notifyListeners();
        await userService.updateAvatar(mediaUrl!);
        loading = false;
        Navigator.of(context).pushReplacement(
            CupertinoPageRoute(builder: (_) => const TabScreen()));
        notifyListeners();
      } catch (e) {
        debugPrint(e.toString());
        loading = false;
        showInSnackBar('Uploaded successfully!', context);
        notifyListeners();
      }
    }
  }

  resetPost() {
    mediaUrl = null;
    content = null;
    title = null;
    edit = false;
    notifyListeners();
  }

  void showInSnackBar(String value, BuildContext context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }
}
