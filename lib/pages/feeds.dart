import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hicoder/auth/login/login.dart';
import 'package:hicoder/services/auth_service.dart';
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
              //   CupertinoPageRoute(
              //     builder: (_) => Chats(),
              //   ),
              // );
            },
          ),
          IconButton(
            onPressed: () {
              AuthService().logout();
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (_) => const Login(),
                ),
              );
            },
            icon: const Icon(
              Ionicons.log_out,
              size: 30.0,
            ),
          ),
          const SizedBox(width: 20.0),
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
                  future: PostService().fetchPosts(),
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
}