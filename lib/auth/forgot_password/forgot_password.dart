import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hicoder/components/text_form_builder.dart';
import 'package:hicoder/services/auth_service.dart';
import 'package:hicoder/widgets/snack_bar.dart';
import 'package:ionicons/ionicons.dart';

import '../../utils/validation.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
                height: 200.0,
                width: 200,
                child: Image(image: AssetImage('assets/images/forgot.png'))),
            const SizedBox(height: 20.0),
            const Text(
              'FORGOT PASSWORD?',
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15.0),
            const Text(
              'Don\'t worry! Enter your email below and we will email you with instructions on how to reset your password.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 15.0),
            Form(
              key: formKey,
              child: TextFormBuilder(
                  controller: emailController,
                  prefix: Ionicons.mail_outline,
                  hintText: "Email",
                  textInputAction: TextInputAction.next,
                  validateFunction: Validations.validateEmail,
                  onSaved: (String val) {
                    emailController.text = val;
                  },
                  submitAction: () => {}),
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              height: 45.0,
              width: 180.0,
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).colorScheme.secondary),
                ),
                child: const Text(
                  'SEND',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () =>
                    sendMail(emailController.text, formKey, context),
              ),
            ),
          ],
        ),
      )),
    );
  }

  sendMail(String email, GlobalKey<FormState> formKey, BuildContext context) {
    if (!formKey.currentState!.validate()) {
      showInSnackBar(
          "Please fix the errors in red before submitting.", context);
      return;
    }
    try {
      AuthService().forgotPassword(email: email);
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.scale,
        title: 'Success',
        desc: 'Password reset instructions sent to your email.',
        btnOkOnPress: () {
          Navigator.pop(context);
        },
      ).show();
    } on Exception catch (e) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.scale,
        title: 'Error',
        desc: e.toString(),
        btnOkOnPress: () {
          Navigator.pop(context);
        },
      ).show();
    }
  }
}
