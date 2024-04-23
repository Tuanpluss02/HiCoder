import 'package:flutter/material.dart';
import 'package:hicoder/view_models/post/posts_view_model.dart';
import 'package:hicoder/widgets/indicators.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  @override
  Widget build(BuildContext context) {
    PostsViewModel viewModel = Provider.of<PostsViewModel>(context);
    return PopScope(
      onPopInvoked: (x) async {
        await viewModel.resetPost();
        // return true;
      },
      child: LoadingOverlay(
        progressIndicator: circularProgress(context),
        isLoading: viewModel.loading,
        child: Scaffold(
          key: viewModel.scaffoldKey,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Ionicons.close_outline),
              onPressed: () {
                viewModel.resetPost();
                Navigator.pop(context);
              },
            ),
            title: Text('HiCoder'.toUpperCase()),
            centerTitle: true,
            actions: [
              GestureDetector(
                onTap: () async {
                  await viewModel.uploadPosts(context);
                  if (context.mounted) Navigator.pop(context);
                  viewModel.resetPost();
                },
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Post'.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              )
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            children: [
              const SizedBox(height: 15.0),
              // StreamBuilder(
              //   stream: usersRef.doc(currentUserId()).snapshots(),
              //   builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              //     if (snapshot.hasData) {
              //       UserModel user = UserModel.fromJson(
              //         snapshot.data!.data() as Map<String, dynamic>,
              //       );
              //       return ListTile(
              //         leading: CircleAvatar(
              //           radius: 25.0,
              //           backgroundImage: NetworkImage(user.photoUrl!),
              //         ),
              //         title: Text(
              //           user.username!,
              //           style: const TextStyle(fontWeight: FontWeight.bold),
              //         ),
              //         subtitle: Text(
              //           user.email!,
              //         ),
              //       );
              //     }
              //     return Container();
              //   },
              // ),
              InkWell(
                onTap: () => showImageChoices(context, viewModel),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width - 30,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: const BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  child: viewModel.post!.mediaUrl == null
                      ? Center(
                          child: Text(
                            'Upload a Photo',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        )
                      : Image.network(
                          viewModel.post!.mediaUrl!,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width - 30,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(height: 20.0),
              Text(
                'Content'.toUpperCase(),
                style: const TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextFormField(
                initialValue: viewModel.post!.content!,
                decoration: const InputDecoration(
                  hintText: 'Eg. I love Flutter!',
                  focusedBorder: UnderlineInputBorder(),
                ),
                maxLines: null,
                onChanged: (val) => viewModel.setContent(val),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showImageChoices(BuildContext context, PostsViewModel viewModel) {
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
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  'Select Image',
                  style: TextStyle(
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
