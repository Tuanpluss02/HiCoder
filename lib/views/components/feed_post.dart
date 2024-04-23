import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hicoder/models/post.dart';
import 'package:hicoder/models/user.dart';
import 'package:hicoder/view_models/post/posts_view_model.dart';
import 'package:hicoder/views/components/custom_card.dart';
import 'package:hicoder/views/components/custom_image.dart';
import 'package:hicoder/views/posts/post_detail.dart';
import 'package:ionicons/ionicons.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';

import '../../utils/constants.dart';
import 'time_ago.dart';

class FeedPost extends StatelessWidget {
  final PostModel? post;

  const FeedPost({super.key, this.post});

  @override
  Widget build(BuildContext context) {
    PostsViewModel viewModel = Provider.of<PostsViewModel>(context);
    return CustomCard(
      onTap: () {},
      borderRadius: BorderRadius.circular(10.0),
      child: OpenContainer(
        transitionType: ContainerTransitionType.fadeThrough,
        openBuilder: (BuildContext context, VoidCallback _) {
          return PostDetail(post: post);
        },
        closedElevation: 0.0,
        closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        onClosed: (v) {},
        closedColor: Theme.of(context).cardColor,
        closedBuilder: (BuildContext context, VoidCallback openContainer) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: post?.mediaUrl != null && post!.mediaUrl!.isNotEmpty,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                  child: CustomImage(
                    imageUrl: post?.mediaUrl,
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
                  post?.content ?? "",
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
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    buildUserWithTime(context: context, user: post!.author!),
                    // const Spacer(),
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
              )
            ],
          );
        },
      ),
    );
  }

  buildLikeWidget(
      {required BuildContext context, required PostsViewModel viewModel}) {
    Future<bool> onLikeButtonTapped(bool isLiked) async {
      viewModel.toggleLikePost(post!);
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
              post!.liked! ? Ionicons.heart : Ionicons.heart_outline,
              color: !post!.liked!
                  ? Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black
                  : Colors.red,
              size: 25,
            );
          },
        ),
        buildLikesCount(context, post!.likesCount!),
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
          onTap: () {
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (_) => Comments(post: post),
            //   ),
            // );
          },
          child: const Icon(
            CupertinoIcons.chat_bubble,
            size: 25.0,
          ),
        ),
        buildCommentsCount(context, post!.commentsCount!),
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
                    dateTime: DateTime.parse(post!.createdAt!),
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
