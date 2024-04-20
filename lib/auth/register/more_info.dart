import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:hicoder/components/text_form_builder.dart';
import 'package:hicoder/screens/mainscreen.dart';
import 'package:hicoder/view_models/user/user_view_model.dart';
import 'package:hicoder/widgets/indicators.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

import '../../utils/validation.dart';
import '../../widgets/snack_bar.dart';

class MoreInfo extends StatefulWidget {
  const MoreInfo({super.key});

  @override
  State<MoreInfo> createState() => _MoreInfoState();
}

class _MoreInfoState extends State<MoreInfo> {
  TextEditingController dobController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    UserViewModel viewModel = Provider.of<UserViewModel>(context);
    return PopScope(
      onPopInvoked: (x) async {},
      child: LoadingOverlay(
        progressIndicator: circularProgress(context),
        isLoading: viewModel.loading,
        child: Scaffold(
          appBar: AppBar(
              title: const Text('Tell us about yourself'),
              centerTitle: true,
              automaticallyImplyLeading: false,
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => const HomeScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'SKIP',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                      ),
                    ))
              ]),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * .5,
                    height: MediaQuery.of(context).size.width * .5,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black54, width: 2),
                    ),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      onTap: () => showImageChoices(context, viewModel),
                      child: viewModel.avatarUrl == null
                          ? const Center(
                              child: Column(
                                children: [
                                  SizedBox(height: 20.0),
                                  Icon(
                                    Ionicons.person_outline,
                                    size: 100.0,
                                  ),
                                  Text(
                                    'Tap to add photo',
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ClipOval(
                              child: Image.network(
                                viewModel.avatarUrl!,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Divider(
                    color: Colors.black,
                    thickness: 1,
                    indent: MediaQuery.of(context).size.width * .1,
                    endIndent: MediaQuery.of(context).size.width * .1,
                  ),
                  const SizedBox(height: 20.0),
                  TextFormBuilder(
                    enabled: !viewModel.loading,
                    prefix: Ionicons.person_outline,
                    hintText: "Full Name",
                    textInputAction: TextInputAction.next,
                    validateFunction: Validations.validateFullName,
                    onSaved: (String val) {
                      viewModel.setFullName(val);
                    },
                  ),
                  const SizedBox(height: 15.0),
                  TextFormBuilder(
                    enabled: !viewModel.loading,
                    controller: dobController,
                    prefix: Ionicons.calendar_outline,
                    hintText: "Date of Birth",
                    suffix: GestureDetector(
                      onTap: () async {
                        final DateTime? picked = await showDatePickerDialog(
                          splashColor: Theme.of(context).colorScheme.secondary,
                          highlightColor:
                              Theme.of(context).colorScheme.secondary,
                          slidersColor: Theme.of(context).colorScheme.secondary,
                          leadingDateTextStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          context: context,
                          initialDate: DateTime.now(),
                          minDate: DateTime(1900, 1, 1),
                          maxDate: DateTime.now(),
                          currentDate: DateTime.now(),
                          selectedDate: DateTime.now(),
                          currentDateDecoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            border: Border.fromBorderSide(
                              BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                            ),
                          ),
                          initialPickerType: PickerType.days,
                          selectedCellDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(45),
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          slidersSize: 20,
                          splashRadius: 40,
                          centerLeadingDate: true,
                        );
                        if (picked != null) {
                          dobController.text =
                              picked.toString().split(" ").first;
                        }
                      },
                      child: const Icon(Ionicons.calendar_outline),
                    ),
                    textInputAction: TextInputAction.next,
                    validateFunction: Validations.validateDate,
                    onSaved: (String val) {
                      viewModel.setDateOfBirth(val);
                    },
                  ),
                  const SizedBox(height: 15.0),
                  TextFormBuilder(
                    enabled: !viewModel.loading,
                    prefix: Ionicons.pencil_outline,
                    hintText: "About You",
                    textInputAction: TextInputAction.next,
                    onSaved: (String val) {
                      viewModel.setAbout(val);
                    },
                  ),
                  const SizedBox(height: 20.0),
                  Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).colorScheme.secondary),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(45.0),
                          ),
                        ),
                      ),
                      onPressed: () => onSubmit(viewModel, context),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                          child: Text('Continue'.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                              )),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  onSubmit(UserViewModel viewModel, BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      showInSnackBar(
          'Please fix the errors in red before submitting.', context);
      return;
    }
    viewModel.updateUser(context);
    if (context.mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );
    }
  }

  showImageChoices(BuildContext context, UserViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: .6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  'Select from'.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Ionicons.camera_outline),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  viewModel.pickImage(camera: true, context: context);
                },
              ),
              ListTile(
                leading: const Icon(Ionicons.image),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  viewModel.pickImage(context: context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
