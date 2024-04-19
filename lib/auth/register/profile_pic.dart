import 'package:flutter/material.dart';
import 'package:hicoder/view_models/user/user_view_model.dart';
import 'package:hicoder/widgets/indicators.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';

class ProfilePicture extends StatefulWidget {
  final UserModel? user;
  const ProfilePicture({super.key, this.user});

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  @override
  Widget build(BuildContext context) {
    UserViewModel viewModel = Provider.of<UserViewModel>(context);
    viewModel.setUser(widget.user!);
    return PopScope(
      onPopInvoked: (x) async {
        // viewModel.resetPost();
        // return true;
      },
      child: LoadingOverlay(
        progressIndicator: circularProgress(context),
        isLoading: viewModel.loading,
        child: Scaffold(
          key: viewModel.scaffoldKey,
          appBar: AppBar(
            title: const Text('Tell us about yourself'),
            centerTitle: true,
            automaticallyImplyLeading: false,
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            children: [
              InkWell(
                onTap: () => showImageChoices(context, viewModel),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width - 30,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: const BorderRadius.all(
                      Radius.circular(3.0),
                    ),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  child: viewModel.user!.avatarUrl == null
                      ? Stack(children: [
                          Center(
                            child: Text(
                              'Tap to add your profile picture',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ),
                          Image.network(
                            "http://api.stormx.space/files/cb3c6be6-1784-4ec6-a847-5d39919d9585",
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width - 30,
                            fit: BoxFit.cover,
                          ),
                        ])
                      : Image.network(
                          viewModel.user!.avatarUrl!,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width - 30,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(height: 10.0),
              Center(
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).colorScheme.secondary),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: Text('done'.toUpperCase()),
                    ),
                  ),
                  onPressed: () => {
                    viewModel.updateUser(context),
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
