import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hicoder/models/user.dart';
import 'package:hicoder/services/user_service.dart';
import 'package:image_picker/image_picker.dart';

import '../../widgets/snack_bar.dart';

class EditProfileViewModel extends ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool validate = false;
  bool loading = false;
  UserService userService = UserService();
  final picker = ImagePicker();
  UserModel? user;
  File? image;

  editProfile(BuildContext context) async {
    FormState form = formKey.currentState!;
    form.save();
    if (!form.validate()) {
      validate = true;
      notifyListeners();
      showInSnackBar(
          'Please fix the errors in red before submitting.', context);
    } else {
      try {
        loading = true;
        notifyListeners();
      } catch (e) {
        loading = false;
        notifyListeners();
      }
      loading = false;
      notifyListeners();
    }
  }

  pickImage({bool camera = false, required BuildContext context}) async {
    loading = true;
    notifyListeners();
    try {
      XFile? pickedFile = await picker.pickImage(
        source: camera ? ImageSource.camera : ImageSource.gallery,
      );
      image = File(pickedFile!.path);
      loading = false;
      notifyListeners();
    } catch (e) {
      loading = false;
      notifyListeners();
      if (context.mounted) showInSnackBar('Cancelled', context);
    }
  }

  uploadProfilePicture(BuildContext context) async {
    if (user!.avatarUrl == null) {
      showInSnackBar('Please select an image', context);
    } else {
      try {
        loading = true;
        notifyListeners();
        await userService.updateAvatar(avatarUrl: user!.avatarUrl!);
        loading = false;
        notifyListeners();
        if (context.mounted) showInSnackBar('Uploaded successfully!', context);
      } catch (e) {
        debugPrint(e.toString());
        loading = false;
        if (context.mounted) {
          showInSnackBar(e.toString().split(':')[1], context);
        }
        notifyListeners();
      }
    }
  }

  clear() {
    image = null;
    notifyListeners();
  }
}
