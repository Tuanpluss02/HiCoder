import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hicoder/components/text_form_builder.dart';
import 'package:hicoder/utils/validation.dart';
import 'package:hicoder/view_models/auth/register_view_model.dart';
import 'package:hicoder/widgets/indicators.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    RegisterViewModel viewModel = Provider.of<RegisterViewModel>(context);
    return LoadingOverlay(
      progressIndicator: circularProgress(context),
      isLoading: viewModel.loading,
      child: Scaffold(
        key: viewModel.scaffoldKey,
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
          children: [
            SizedBox(height: MediaQuery.of(context).size.height / 10),
            Text(
              'Welcome to HiCoder\nCreate a new account and connect with friends',
              style: GoogleFonts.nunitoSans(
                fontWeight: FontWeight.bold,
                fontSize: 25.0,
              ),
            ),
            const SizedBox(height: 30.0),
            buildForm(viewModel, context),
            const SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already have an account  ',
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  buildForm(RegisterViewModel viewModel, BuildContext context) {
    return Form(
      key: viewModel.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormBuilder(
            enabled: !viewModel.loading,
            prefix: Ionicons.mail_outline,
            hintText: "Email",
            textInputAction: TextInputAction.next,
            validateFunction: Validations.validateEmail,
            onSaved: (String val) {
              viewModel.setEmail(val);
            },
            focusNode: viewModel.emailFN,
            nextFocusNode: viewModel.passFN,
          ),
          const SizedBox(height: 20.0),
          TextFormBuilder(
            enabled: !viewModel.loading,
            prefix: Ionicons.lock_closed_outline,
            suffix: GestureDetector(
              onTap: () => viewModel.toggleObscureText(),
              child: Icon(
                viewModel.obscureText
                    ? Ionicons.eye_outline
                    : Ionicons.eye_off_outline,
                size: 15.0,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            hintText: "Password",
            textInputAction: TextInputAction.next,
            validateFunction: Validations.validatePassword,
            obscureText: viewModel.obscureText,
            onSaved: (String val) {
              viewModel.setPassword(val);
            },
            focusNode: viewModel.passFN,
            nextFocusNode: viewModel.cPassFN,
          ),
          const SizedBox(height: 20.0),
          TextFormBuilder(
            enabled: !viewModel.loading,
            prefix: Ionicons.lock_open_outline,
            suffix: GestureDetector(
              onTap: () => viewModel.toggleObscureText(),
              child: Icon(
                viewModel.obscureText
                    ? Ionicons.eye_outline
                    : Ionicons.eye_off_outline,
                size: 15.0,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            hintText: "Confirm Password",
            textInputAction: TextInputAction.done,
            validateFunction: (String? val) =>
                Validations.validateConfirmPassword(viewModel.password!, val!),
            submitAction: () => viewModel.register(context),
            obscureText: viewModel.obscureText,
            onSaved: (String val) {
              viewModel.setConfirmPass(val);
            },
            focusNode: viewModel.cPassFN,
          ),
          const SizedBox(height: 25.0),
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
              child: Text(
                'sign up'.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () => viewModel.register(context),
            ),
          ),
        ],
      ),
    );
  }
}
