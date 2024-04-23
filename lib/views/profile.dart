import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hicoder/models/user.dart';
import 'package:hicoder/services/user_service.dart';
import 'package:hicoder/utils/constants.dart';
import 'package:hicoder/views/components/snack_bar.dart';

import 'components/indicators.dart';

class UserProfile extends StatefulWidget {
  final String? userId;
  const UserProfile({super.key, this.userId});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: circularProgress(context),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          UserModel user = snapshot.data as UserModel;
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text("@${user.username!}"),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.width * 0.2,
                          child: CircleAvatar(
                            radius: 15.0,
                            backgroundImage: CachedNetworkImageProvider(
                                user.avatarUrl ?? Constants.defaultAvatar),
                          ),
                        ),
                        const SizedBox(width: 7.0),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user.displayName ?? "${user.username}",
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .color,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                )),
                            Text("@${user.username}",
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .color,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<UserModel> fetchUser() async {
    try {
      if (widget.userId == null) {
        return await UserService().getCurrentUser();
      }
      return await UserService().getUserById(userId: widget.userId!);
    } catch (e) {
      showInSnackBar(e.toString(), context);
      return UserModel();
    }
  }
}
