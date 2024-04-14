class Authentication {
  String? email;
  String? password;
  String? role;
  String? adminKey;

  Authentication({this.email, this.password, this.role, this.adminKey});

  Authentication.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
    role = json['role'];
    adminKey = json['adminKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['password'] = password;
    data['role'] = role;
    data['adminKey'] = adminKey;
    return data;
  }
}
