import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hicoder/models/user.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/media_service.dart';
import '../../services/user_service.dart';
import '../../widgets/snack_bar.dart';

class UserViewModel extends ChangeNotifier {
  UserService userService = UserService();

  //Keys
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool loading = false;
  UserModel? user;
  final picker = ImagePicker();

  setUser(UserModel user) {
    this.user = user;
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
      user!.mediaUrl = await MediaService().uploadMedia(mediaFile);
      loading = false;
      notifyListeners();
    } catch (e) {
      loading = false;
      notifyListeners();
      if (context.mounted) showInSnackBar('Cancelled', context);
    }
  }

  updateUser(BuildContext context) async {
    try {
      loading = true;
      notifyListeners();
      await userService.updateProfile(user: user!);
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
