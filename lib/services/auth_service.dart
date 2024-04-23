import 'package:dio/dio.dart';
import 'package:hicoder/services/api_service.dart';

import '../utils/shared_pref.dart';

class AuthService {
  Future<void> createUser(
      {required String email,
      required String password,
      String? role,
      String? adminKey}) async {
    Response response = await ApiService().getDio.post("/auth/register", data: {
      "email": email,
      "password": password,
      "role": role,
      "adminKey": adminKey,
    });
    if (response.statusCode != 200) {
      throw Exception(response.data['message']);
    }
    String accessToken = response.data['body']['access_token'];
    String refreshToken = response.data['body']['refresh_token'];
    String userId = response.data['body']['user_id'];
    setUserId(userId);
    setToken(accessToken, TokenType.access);
    setToken(refreshToken, TokenType.refresh);
  }

  Future<void> loginUser(
      {required String email, required String password}) async {
    Response response = await ApiService()
        .getDio
        .post("/auth/login", data: {"email": email, "password": password});
    if (response.statusCode != 200) {
      throw Exception(response.data['message']);
    }
    String accessToken = response.data['body']['access_token'];
    String refreshToken = response.data['body']['refresh_token'];
    String userId = response.data['body']['user_id'];
    setUserId(userId);
    setToken(accessToken, TokenType.access);
    setToken(refreshToken, TokenType.refresh);
  }

  Future<bool> isLoggedIn() async {
    String? token = await getToken(TokenType.access);
    if (token != "") {
      return true;
    } else {
      return false;
    }
  }

  Future<void> logout() async {
    await removeToken(TokenType.access);
    await removeToken(TokenType.refresh);
    await ApiService().getDio.post("/auth/logout");
  }

  Future<void> forgotPassword({required String email}) async {
    Response response = await ApiService()
        .getDio
        .post("/auth/reset-password", data: {"email": email});
    if (response.statusCode != 200) {
      throw Exception(response.data['message']);
    }
  }
}
