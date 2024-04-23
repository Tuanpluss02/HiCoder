import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hicoder/models/user.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/media_service.dart';
import '../../services/user_service.dart';
import '../../views/components/snack_bar.dart';

class UserViewModel extends ChangeNotifier {
  // final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  // final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  UserService userService = UserService();
  MediaService mediaService = MediaService();

  bool loading = false;
  UserModel? user;
  final picker = ImagePicker();
  String? fullName;
  String? avatarUrl;
  String? dateOfBirth;
  String? about;

  setUser(UserModel user) {
    this.user = user;
    notifyListeners();
  }

  setFullName(String fullName) {
    this.fullName = fullName;
    notifyListeners();
  }

  setAbout(String about) {
    this.about = about;
    notifyListeners();
  }

  setDateOfBirth(String dateOfBirth) {
    this.dateOfBirth = dateOfBirth;
    notifyListeners();
  }

  pickImage({bool camera = false, required BuildContext context}) async {
    loading = true;
    notifyListeners();
    try {
      XFile? pickedFile = await picker.pickImage(
          source: camera ? ImageSource.camera : ImageSource.gallery,
          imageQuality: 50);
      File mediaFile = File(pickedFile!.path);
      UserModel loadedUser = await userService.getCurrentUser();
      avatarUrl = await mediaService.uploadMedia(mediaFile);
      loadedUser.avatarUrl = avatarUrl;
      user = loadedUser;
      loading = false;
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
      loading = false;
      notifyListeners();
      if (context.mounted) {
        showInSnackBar('Upload avatar failed, please try again', context);
      }
    }
  }

  updateUser(BuildContext context) async {
    try {
      loading = true;
      notifyListeners();
      await userService.updateProfile(
          displayName: fullName!,
          avatarUrl: avatarUrl!,
          birthday: dateOfBirth!,
          about: about!);
      loading = false;
      notifyListeners();
      if (context.mounted) {
        showInSnackBar('Profile updated successfully!', context);
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
      loading = false;
      notifyListeners();
      if (context.mounted) showInSnackBar(e.toString(), context);
    }
  }
}
