class UserModel {
  String? username;
  String? email;
  String? avatarUrl;
  String? about;
  String? id;

  UserModel({
    this.username,
    this.email,
    this.id,
    this.avatarUrl,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['email'] = email;
    data['id'] = id;
    return data;
  }
}
