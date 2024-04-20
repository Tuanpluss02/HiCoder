import 'package:hicoder/models/user.dart';

class PostModel {
  String? id;
  String? content;
  UserModel? author;
  String? createdAt;
  String? mediaUrl;
  int? likesCount;
  int? commentsCount;
  bool? liked;

  PostModel(
      {this.id,
      this.content,
      this.author,
      this.createdAt,
      this.mediaUrl,
      this.likesCount,
      this.commentsCount,
      this.liked});

  PostModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    author = json['author'] != null ? UserModel.fromJson(json['author']) : null;
    createdAt = json['createdAt'];
    mediaUrl = json['mediaUrl'];
    likesCount = json['likesCount'];
    commentsCount = json['commentsCount'];
    liked = json['liked'];
  }

  int get getLikesCount => likesCount!;
  int get getCommentsCount => commentsCount!;
  bool get getLiked => liked!;
  set setLiked(bool value) => liked = value;
  set setLikesCount(int value) => likesCount = value;
  set setCommentsCount(int value) => commentsCount = value;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['content'] = content;
    if (author != null) {
      data['author'] = author!.toJson();
    }
    data['createdAt'] = createdAt;
    data['mediaUrl'] = mediaUrl;
    data['likesCount'] = likesCount;
    data['commentsCount'] = commentsCount;
    data['liked'] = liked;
    return data;
  }
}
