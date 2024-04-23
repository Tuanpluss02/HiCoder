import 'package:flutter/material.dart';
import 'package:hicoder/services/auth_service.dart';
import 'package:hicoder/views/auth/register/more_info.dart';

class RegisterViewModel extends ChangeNotifier {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool validate = false;
  bool loading = false;
  String? email, password, cPassword;
  bool obscureText = true;
  FocusNode emailFN = FocusNode();
  FocusNode passFN = FocusNode();
  FocusNode cPassFN = FocusNode();

  register(BuildContext context) async {
    FormState form = formKey.currentState!;
    form.save();
    if (!form.validate()) {
      validate = true;
      notifyListeners();
      showInSnackBar(
          'Please fix the errors in red before submitting.', context);
      return;
    }
    loading = true;
    notifyListeners();
    try {
      await AuthService().createUser(
        email: email!,
        password: password!,
      );
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const MoreInfo(),
          ),
        );
      }
    } on Exception catch (e) {
      loading = false;
      notifyListeners();
      debugPrint(e.toString());
      if (context.mounted) showInSnackBar(e.toString().split(':')[1], context);
    }
    loading = false;
    notifyListeners();
  }

  toggleObscureText() {
    obscureText = !obscureText;
    notifyListeners();
  }

  setEmail(val) {
    email = val;
    notifyListeners();
  }

  setPassword(val) {
    password = val;
    notifyListeners();
  }

  setConfirmPass(val) {
    cPassword = val;
    notifyListeners();
  }

  void showInSnackBar(String value, context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }
}
