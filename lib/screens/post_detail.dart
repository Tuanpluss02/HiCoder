import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hicoder/models/post.dart';
import 'package:hicoder/models/user.dart';
import 'package:ionicons/ionicons.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';

import '../components/custom_image.dart';
import '../utils/constants.dart';
import '../view_models/post/posts_view_model.dart';
import '../widgets/time_ago.dart';

class PostDetail extends StatefulWidget {
  final PostModel? post;

  const PostDetail({super.key, this.post});

  @override
  State<PostDetail> createState() => _PostDetailState();
}

final DateTime timestamp = DateTime.now();

UserModel? user;

class _PostDetailState extends State<PostDetail> {
  @override
  Widget build(BuildContext context) {
    PostsViewModel viewModel = Provider.of<PostsViewModel>(context);
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Post of @${widget.post?.author?.username ?? ""}",
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge!.color,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              buildPostWidget(viewModel), buildDivider(),
              // FutureBuilder(future: , builder: builder)
            ],
          ),
        ));
  }

  buildPostWidget(PostsViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: widget.post?.mediaUrl != null &&
                  widget.post!.mediaUrl!.isNotEmpty,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
                child: CustomImage(
                  imageUrl: widget.post?.mediaUrl,
                  height: 350.0,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 3.0),
              child: Text(
                textAlign: TextAlign.start,
                widget.post?.content ?? "",
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodySmall!.color,
                  fontSize: 15.0,
                ),
                maxLines: 2,
              ),
            ),
            const SizedBox(height: 3.0),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 3.0, vertical: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildUserWithTime(
                      context: context, user: widget.post!.author!),
                  Row(
                    children: [
                      buildLikeWidget(context: context, viewModel: viewModel),
                      const SizedBox(width: 10.0),
                      buildConmmentWidget(
                          context: context, viewModel: viewModel),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildDivider() {
    return const Row(
      children: [
        Expanded(
          child: Divider(
              color: Colors.black, thickness: 1, indent: 8, endIndent: 8),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2),
          child: Text("Comments on this post"),
        ),
        Expanded(
          child: Divider(
              color: Colors.black, thickness: 1, indent: 8, endIndent: 8),
        ),
      ],
    );
  }

  buildLikeWidget(
      {required BuildContext context, required PostsViewModel viewModel}) {
    Future<bool> onLikeButtonTapped(bool isLiked) async {
      viewModel.toggleLikePost(widget.post!);
      return !isLiked;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        LikeButton(
          onTap: onLikeButtonTapped,
          size: 25.0,
          circleColor: const CircleColor(
              start: Color(0xffFFC0CB), end: Color(0xffff0000)),
          bubblesColor: const BubblesColor(
              dotPrimaryColor: Color(0xffFFA500),
              dotSecondaryColor: Color(0xffd8392b),
              dotThirdColor: Color(0xffFF69B4),
              dotLastColor: Color(0xffff8c00)),
          likeBuilder: (bool isLiked) {
            return Icon(
              widget.post!.liked! ? Ionicons.heart : Ionicons.heart_outline,
              color: !widget.post!.liked!
                  ? Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black
                  : Colors.red,
              size: 25,
            );
          },
        ),
        buildLikesCount(context, widget.post!.likesCount!),
      ],
    );
  }

  buildLikesCount(BuildContext context, int count) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 7.0),
        child: Text(
          '$count likes',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  buildConmmentWidget(
      {required BuildContext context, required PostsViewModel viewModel}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(10.0),
          onTap: () {},
          child: const Icon(
            CupertinoIcons.chat_bubble,
            size: 25.0,
          ),
        ),
        buildCommentsCount(context, widget.post!.commentsCount!),
      ],
    );
  }

  buildDevider() {
    return Row(
      children: [
        Divider(
          color: Colors.black,
          thickness: 1,
          indent: MediaQuery.of(context).size.width * .1,
          endIndent: MediaQuery.of(context).size.width * .1,
        ),
        // Text("Comments on this post"),
        // Divider(
        //   color: Colors.black,
        //   thickness: 1,
        //   indent: 10,
        //   endIndent: 10,
        // ),
      ],
    );
  }

  buildCommentsCount(BuildContext context, int count) {
    return Padding(
      padding: const EdgeInsets.only(top: 0.5),
      child: Text(
        '$count comments',
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  buildUserWithTime({required BuildContext context, required UserModel user}) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 15.0,
              backgroundImage: CachedNetworkImageProvider(
                  user.avatarUrl ?? Constants.defaultAvatar),
            ),
            const SizedBox(width: 7.0),
            Column(
              children: [
                Text("@${user.username}",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodySmall!.color,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    )),
                textTimeAgo(
                    dateTime: DateTime.parse(widget.post!.createdAt!),
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodySmall!.color,
                      fontSize: 10.0,
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
