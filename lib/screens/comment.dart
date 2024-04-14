// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:ionicons/ionicons.dart';
// import 'package:like_button/like_button.dart';
// import 'package:hicoder/components/stream_comments_wrapper.dart';
// import 'package:hicoder/models/comments.dart';
// import 'package:hicoder/models/post.dart';
// import 'package:hicoder/models/user.dart';
// import 'package:hicoder/services/post_service.dart';
// import 'package:hicoder/utils/firebase.dart';
// import 'package:hicoder/widgets/cached_image.dart';
// import 'package:timeago/timeago.dart' as timeago;

// class Comments extends StatefulWidget {
//   final PostModel? post;

//   const Comments({super.key, this.post});

//   @override
//   _CommentsState createState() => _CommentsState();
// }

// class _CommentsState extends State<Comments> {
//   UserModel? user;

//   PostService services = PostService();
//   final DateTime timestamp = DateTime.now();
//   TextEditingController commentsTEC = TextEditingController();

//   currentUserId() {
//     return firebaseAuth.currentUser!.uid;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: GestureDetector(
//           onTap: () {
//             Navigator.pop(context);
//           },
//           child: const Icon(
//             CupertinoIcons.xmark_circle_fill,
//           ),
//         ),
//         centerTitle: true,
//         title: const Text('Comments'),
//       ),
//       body: SizedBox(
//         height: MediaQuery.of(context).size.height,
//         child: Column(
//           children: [
//             Flexible(
//               child: ListView(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                     child: buildFullPost(),
//                   ),
//                   const Divider(thickness: 1.5),
//                   Flexible(
//                     child: buildComments(),
//                   )
//                 ],
//               ),
//             ),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).primaryColor,
//                   ),
//                   constraints: const BoxConstraints(
//                     maxHeight: 190.0,
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: <Widget>[
//                       Flexible(
//                         child: ListTile(
//                           contentPadding: const EdgeInsets.all(0),
//                           title: TextField(
//                             textCapitalization: TextCapitalization.sentences,
//                             controller: commentsTEC,
//                             style: TextStyle(
//                               fontSize: 15.0,
//                               color:
//                                   Theme.of(context).textTheme.titleLarge!.color,
//                             ),
//                             decoration: InputDecoration(
//                               contentPadding: const EdgeInsets.all(10.0),
//                               focusedBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(5.0),
//                                 borderSide: BorderSide(
//                                   color:
//                                       Theme.of(context).colorScheme.secondary,
//                                 ),
//                               ),
//                               focusedErrorBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(5.0),
//                                 borderSide: BorderSide(
//                                   color:
//                                       Theme.of(context).colorScheme.secondary,
//                                 ),
//                               ),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(5.0),
//                                 borderSide: BorderSide(
//                                   color:
//                                       Theme.of(context).colorScheme.secondary,
//                                 ),
//                               ),
//                               enabledBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                   color:
//                                       Theme.of(context).colorScheme.secondary,
//                                 ),
//                                 borderRadius: BorderRadius.circular(5.0),
//                               ),
//                               hintText: "Write your comment...",
//                               hintStyle: TextStyle(
//                                 fontSize: 15.0,
//                                 color: Theme.of(context)
//                                     .textTheme
//                                     .titleLarge!
//                                     .color,
//                               ),
//                             ),
//                             maxLines: null,
//                           ),
//                           trailing: GestureDetector(
//                             onTap: () async {
//                               await services.uploadComment(
//                                 currentUserId(),
//                                 commentsTEC.text,
//                                 widget.post!.postId!,
//                                 widget.post!.ownerId!,
//                                 widget.post!.mediaUrl!,
//                               );
//                               commentsTEC.clear();
//                             },
//                             child: Padding(
//                               padding: const EdgeInsets.only(right: 10.0),
//                               child: Icon(
//                                 Icons.send,
//                                 color: Theme.of(context).colorScheme.secondary,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   buildFullPost() {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SizedBox(
//           height: 350.0,
//           width: MediaQuery.of(context).size.width - 20.0,
//           child: cachedNetworkImage(widget.post!.mediaUrl!),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Row(
//             children: [
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     widget.post!.description!,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.w800,
//                     ),
//                   ),
//                   const SizedBox(height: 4.0),
//                   Row(
//                     children: [
//                       Text(
//                         timeago.format(widget.post!.timestamp!.toDate()),
//                         style: const TextStyle(),
//                       ),
//                       const SizedBox(width: 3.0),
//                       StreamBuilder(
//                         stream: likesRef
//                             .where('postId', isEqualTo: widget.post!.postId)
//                             .snapshots(),
//                         builder:
//                             (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                           if (snapshot.hasData) {
//                             QuerySnapshot snap = snapshot.data!;
//                             List<DocumentSnapshot> docs = snap.docs;
//                             return buildLikesCount(context, docs.length ?? 0);
//                           } else {
//                             return buildLikesCount(context, 0);
//                           }
//                         },
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               const Spacer(),
//               buildLikeButton(),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   buildComments() {
//     return CommentsStreamWrapper(
//       shrinkWrap: true,
//       // padding: const EdgeInsets.symmetric(horizontal: 20.0),
//       stream: commentRef
//           .doc(widget.post!.postId)
//           .collection('comments')
//           .orderBy('timestamp', descending: true)
//           .snapshots(),
//       physics: const NeverScrollableScrollPhysics(),
//       itemBuilder: (_, DocumentSnapshot snapshot) {
//         CommentModel comments =
//             CommentModel.fromJson(snapshot.data() as Map<String, dynamic>);
//         // return Column(
//         //   crossAxisAlignment: CrossAxisAlignment.start,
//         //   mainAxisAlignment: MainAxisAlignment.start,
//         //   children: [
//         //     ListTile(
//         //       contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
//         //       leading: CircleAvatar(
//         //         radius: 20.0,
//         //         backgroundImage: NetworkImage(comments.userDp!),
//         //       ),
//         //       title: Text(
//         //         comments.username!,
//         //         style: TextStyle(fontWeight: FontWeight.w700),
//         //       ),
//         //       subtitle: Text(
//         //         timeago.format(comments.timestamp!.toDate()),
//         //         style: TextStyle(fontSize: 12.0),
//         //       ),
//         //     ),
//         //     Padding(
//         //       padding: const EdgeInsets.symmetric(horizontal: 20.0),
//         //       child: Text(
//         //         comments.comment!,
//         //         style: TextStyle(fontWeight: FontWeight.w400),
//         //       ),
//         //     ),
//         //     Divider()
//         //   ],
//         // );
//         return Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   CircleAvatar(
//                     radius: 20.0,
//                     backgroundImage:
//                         CachedNetworkImageProvider(comments.userDp!),
//                   ),
//                   const SizedBox(width: 10.0),
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         comments.username!,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 14.0,
//                         ),
//                       ),
//                       Text(
//                         timeago.format(comments.timestamp!.toDate()),
//                         style: const TextStyle(fontSize: 10.0),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 50.0),
//                 child: Text(comments.comment!.trim()),
//               ),
//               const SizedBox(height: 10.0),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   buildLikeButton() {
//     return StreamBuilder(
//       stream: likesRef
//           .where('postId', isEqualTo: widget.post!.postId)
//           .where('userId', isEqualTo: currentUserId())
//           .snapshots(),
//       builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//         if (snapshot.hasData) {
//           List<QueryDocumentSnapshot> docs = snapshot.data?.docs ?? [];
//           // return IconButton(
//           //   onPressed: () {
//           //     if (docs.isEmpty) {
//           //       likesRef.add({
//           //         'userId': currentUserId(),
//           //         'postId': widget.post!.postId,
//           //         'dateCreated': Timestamp.now(),
//           //       });
//           //       addLikesToNotification();
//           //     } else {
//           //       likesRef.doc(docs[0].id).delete();
//           //
//           //       removeLikeFromNotification();
//           //     }
//           //   },
//           //   icon: docs.isEmpty
//           //       ? Icon(
//           //           CupertinoIcons.heart,
//           //         )
//           //       : Icon(
//           //           CupertinoIcons.heart_fill,
//           //           color: Colors.red,
//           //         ),
//           // );
//           ///added animated like button
//           Future<bool> onLikeButtonTapped(bool isLiked) async {
//             if (docs.isEmpty) {
//               likesRef.add({
//                 'userId': currentUserId(),
//                 'postId': widget.post!.postId,
//                 'dateCreated': Timestamp.now(),
//               });
//               addLikesToNotification();
//               return !isLiked;
//             } else {
//               likesRef.doc(docs[0].id).delete();
//               removeLikeFromNotification();
//               return isLiked;
//             }
//           }

//           return LikeButton(
//             onTap: onLikeButtonTapped,
//             size: 25.0,
//             circleColor: const CircleColor(
//                 start: Color(0xffFFC0CB), end: Color(0xffff0000)),
//             bubblesColor: const BubblesColor(
//                 dotPrimaryColor: Color(0xffFFA500),
//                 dotSecondaryColor: Color(0xffd8392b),
//                 dotThirdColor: Color(0xffFF69B4),
//                 dotLastColor: Color(0xffff8c00)),
//             likeBuilder: (bool isLiked) {
//               return Icon(
//                 docs.isEmpty ? Ionicons.heart_outline : Ionicons.heart,
//                 color: docs.isEmpty ? Colors.grey : Colors.red,
//                 size: 25,
//               );
//             },
//           );
//         }
//         return Container();
//       },
//     );
//   }

//   buildLikesCount(BuildContext context, int count) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 7.0),
//       child: Text(
//         '$count likes',
//         style: const TextStyle(
//           fontWeight: FontWeight.bold,
//           fontSize: 10.0,
//         ),
//       ),
//     );
//   }

//   addLikesToNotification() async {
//     bool isNotMe = currentUserId() != widget.post!.ownerId;

//     if (isNotMe) {
//       DocumentSnapshot doc = await usersRef.doc(currentUserId()).get();
//       user = UserModel.fromJson(doc.data() as Map<String, dynamic>);
//       notificationRef
//           .doc(widget.post!.ownerId)
//           .collection('notifications')
//           .doc(widget.post!.postId)
//           .set({
//         "type": "like",
//         "username": user!.username!,
//         "userId": currentUserId(),
//         "userDp": user!.photoUrl!,
//         "postId": widget.post!.postId,
//         "mediaUrl": widget.post!.mediaUrl,
//         "timestamp": timestamp,
//       });
//     }
//   }

//   removeLikeFromNotification() async {
//     bool isNotMe = currentUserId() != widget.post!.ownerId;

//     if (isNotMe) {
//       DocumentSnapshot doc = await usersRef.doc(currentUserId()).get();
//       user = UserModel.fromJson(doc.data() as Map<String, dynamic>);
//       notificationRef
//           .doc(widget.post!.ownerId)
//           .collection('notifications')
//           .doc(widget.post!.postId)
//           .get()
//           .then((doc) => {
//                 if (doc.exists) {doc.reference.delete()}
//               });
//     }
//   }
// }
