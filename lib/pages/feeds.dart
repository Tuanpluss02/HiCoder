import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hicoder/auth/login/login.dart';
import 'package:hicoder/services/auth_service.dart';
import 'package:hicoder/widgets/snack_bar.dart';
import 'package:ionicons/ionicons.dart';

import '../models/post.dart';
import '../services/post_service.dart';
import '../utils/constants.dart';
import '../widgets/indicators.dart';
import '../widgets/userpost.dart';

class Feeds extends StatefulWidget {
  const Feeds({super.key});

  @override
  State<Feeds> createState() => _FeedsState();
}

class _FeedsState extends State<Feeds> with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  int page = 5;
  bool loadingMore = false;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          page = page + 5;
          loadingMore = true;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          Constants.appName,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Ionicons.chatbubble_ellipses,
              size: 30.0,
            ),
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (_) => Chats(),
              //   ),
              // );
            },
          ),
          IconButton(
            onPressed: () {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.warning,
                animType: AnimType.scale,
                title: 'Logout',
                desc: 'Are you sure you want to logout?',
                btnCancelOnPress: () {},
                btnOkOnPress: () {
                  AuthService().logout();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const Login(),
                    ),
                  );
                },
              ).show();
            },
            icon: Icon(
              Ionicons.log_out,
              size: 30.0,
              color: Colors.red.shade400,
            ),
          ),
          // const SizedBox(width: 20.0),
        ],
      ),
      body: RefreshIndicator(
        color: Theme.of(context).colorScheme.secondary,
        onRefresh: () {
          setState(() {
            page = 5;
          });
          return Future.value();
        },
        //     postRef.orderBy('timestamp', descending: true).limit(page).get(),
        child: SingleChildScrollView(
          controller: scrollController,
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const StoryWidget(),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: FutureBuilder(
                  future: fetchPosts(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var snap = snapshot.data;
                      if (snap!.isEmpty) {
                        return const Center(
                          child: Text(
                            'No Feeds',
                            style: TextStyle(
                              fontSize: 26.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      } else {
                        return ListView.builder(
                          controller: scrollController,
                          itemCount: snap.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            PostModel posts = snap[index];
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: UserPost(post: posts),
                            );
                          },
                        );
                      }
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return circularProgress(context);
                    } else {
                      return const Center(
                        child: Text(
                          'No Feeds',
                          style: TextStyle(
                            fontSize: 26.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Future<List<PostModel>> fetchPosts() async {
    try {
      return await PostService().fetchPosts();
    } on Exception catch (e) {
      log(e.toString());
      if (context.mounted) showInSnackBar(e.toString(), context);
      return [];
    }
  }
}
