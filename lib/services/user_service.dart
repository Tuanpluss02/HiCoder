import 'package:dio/dio.dart';
import 'package:hicoder/models/user.dart';

import 'api_service.dart';

class UserService {
  Future<void> updateAvatar({required String avatarUrl}) async {
    Response response =
        await ApiService().getDio.put("/user/update/avatar", data: {
      "avatarUrl": avatarUrl,
    });
    if (response.statusCode != 200) {
      throw Exception(response.data["message"]);
    }
  }

  Future<UserModel> getCurrentUser() async {
    Response response = await ApiService().getDio.get("/user/me");
    if (response.statusCode != 200) {
      throw Exception(response.data["message"]);
    }
    return UserModel.fromJson(response.data["body"]);
  }

  Future<void> updateProfile(
      {required String displayName,
      required String avatarUrl,
      required String birthday,
      required String about}) async {
    Response response = await ApiService().getDio.put("/user/update", data: {
      "displayName": displayName,
      "avatarUrl": avatarUrl,
      "birthday": birthday,
      "about": about,
    });
    if (response.statusCode != 200) {
      throw Exception(response.data["message"]);
    }
  }

  Future<UserModel> getUserById({required String userId}) async {
    Response response = await ApiService().getDio.get("/user/$userId");
    if (response.statusCode != 200) {
      throw Exception(response.data["message"]);
    }
    return UserModel.fromJson(response.data["data"]);
  }
}
