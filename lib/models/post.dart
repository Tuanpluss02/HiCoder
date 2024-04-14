class PostModel {
  String? id;
  String? title;
  String? content;
  String? author;
  String? createdAt;
  String? mediaUrl;
  int? likesCount;
  int? commentsCount;

  PostModel(
      {this.id,
      this.title,
      this.content,
      this.author,
      this.createdAt,
      this.mediaUrl,
      this.likesCount,
      this.commentsCount});

  PostModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    author = json['author'];
    createdAt = json['createdAt'];
    mediaUrl = json['mediaUrl'];
    likesCount = json['likesCount'];
    commentsCount = json['commentsCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['content'] = content;
    data['author'] = author;
    data['createdAt'] = createdAt;
    data['mediaUrl'] = mediaUrl;
    data['likesCount'] = likesCount;
    data['commentsCount'] = commentsCount;
    return data;
  }
}
