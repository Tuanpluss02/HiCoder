class UserModel {
  String? id;
  String? username;
  String? email;
  String? role;
  String? displayName;
  String? avatarUrl;
  String? about;
  String? birthday;

  UserModel(
      {this.id,
      this.username,
      this.email,
      this.role,
      this.displayName,
      this.avatarUrl,
      this.about,
      this.birthday});
  set mediaUrl(String? mediaUrl) {
    avatarUrl = mediaUrl;
  }

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    role = json['role'];
    displayName = json['displayName'];
    avatarUrl = json['avatarUrl'];
    about = json['about'];
    birthday = json['birthday'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['email'] = email;
    data['role'] = role;
    data['displayName'] = displayName;
    data['avatarUrl'] = avatarUrl;
    data['about'] = about;
    data['birthday'] = birthday;
    return data;
  }
}
