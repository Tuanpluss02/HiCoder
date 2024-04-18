import 'package:dio/dio.dart';

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
}
