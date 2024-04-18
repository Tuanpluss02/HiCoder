import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hicoder/utils/shared_pref.dart';

import '../models/authentication.dart';

class ApiService {
  Dio dio = Dio(BaseOptions(
    baseUrl: "http://api.stormx.space/api/v1",
  ));
  Future<Response> registerUser(
      {required Authentication authentication}) async {
    Response response = await dio.post("/auth/register", data: {
      "email": authentication.email,
      "password": authentication.password,
      "role": authentication.role,
      "adminKey": authentication.adminKey,
    });
    debugPrint(response.data.toString());
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception(response.data["message"]);
    }
  }

  Future<Response> loginUser({required Authentication authentication}) async {
    Response response = await dio.post("/auth/login", data: {
      "email": authentication.email,
      "password": authentication.password,
      "role": authentication.role,
      "adminKey": authentication.adminKey,
    });
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception(response.data["message"]);
    }
  }

  Future<Response> fetchUser() async {
    String accessToken = await getToken(TokenType.access);
    dio.options.headers["Authorization"] = "Bearer $accessToken";
    Response response = await dio.get("/user/me");
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception(response.data["message"]);
    }
  }

  Future<Response> fetchPosts() async {
    String accessToken = await getToken(TokenType.access);
    dio.options.headers["Authorization"] = "Bearer $accessToken";
    Response response = await dio.get("/post/newsfeed");
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception(response.data["message"]);
    }
  }

  Future<Response> createPost(
      {String? title, String? content, String? mediaUrl}) async {
    String accessToken = await getToken(TokenType.access);
    dio.options.headers["Authorization"] = "Bearer $accessToken";
    Response response = await dio.post("/post", data: {
      "description": content,
      "mediaUrl": mediaUrl,
    });
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception(response.data["message"]);
    }
  }

  Future<dynamic> uploadMedia(File file) async {
    String accessToken = await getToken(TokenType.access);
    dio.options.headers["Authorization"] = "Bearer $accessToken";
    String fileName = file.path.split('/').last;
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(file.path, filename: fileName),
    });
    Response response = await dio.post("/media/upload", data: formData);
    if (response.statusCode == 200) {
      return response.data["body"];
    } else {
      throw Exception(response.data["message"]);
    }
  }

  Future<Response> updateAvatar({required String avatarUrl}) async {
    String accessToken = await getToken(TokenType.access);
    dio.options.headers["Authorization"] = "Bearer $accessToken";
    Response response = await dio.put("/user/update/avatar", data: {
      "avatarUrl": avatarUrl,
    });
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception(response.data["message"]);
    }
  }
}
