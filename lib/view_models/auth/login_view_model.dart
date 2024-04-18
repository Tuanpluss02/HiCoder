import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hicoder/screens/mainscreen.dart';
import 'package:hicoder/services/auth_service.dart';

class LoginViewModel extends ChangeNotifier {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool validate = false;
  bool loading = false;
  bool obscureText = true;
  String? email, password;
  FocusNode emailFN = FocusNode();
  FocusNode passFN = FocusNode();
  AuthService auth = AuthService();

  login(BuildContext context) async {
    FormState form = formKey.currentState!;
    form.save();
    if (!form.validate()) {
      validate = true;
      notifyListeners();
      showInSnackBar(
          'Please fix the errors in red before submitting.', context);
    } else {
      loading = true;
      notifyListeners();
      try {
        await AuthService().loginUser(
          email: email!,
          password: password!,
        );
        if (context.mounted) {
          Navigator.of(context).pushReplacement(
              CupertinoPageRoute(builder: (_) => const TabScreen()));
        }
      } on Exception catch (e) {
        loading = false;
        notifyListeners();
        debugPrint(e.toString());
        if (context.mounted) {
          showInSnackBar(e.toString().split(':')[1], context);
        }
      }
      loading = false;
      notifyListeners();
    }
  }

  setEmail(val) {
    email = val;
    notifyListeners();
  }

  toggleObscureText() {
    obscureText = !obscureText;
    notifyListeners();
  }

  setPassword(val) {
    password = val;
    notifyListeners();
  }

  void showInSnackBar(String value, context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }
}
