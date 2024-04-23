import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import 'package:hicoder/utils/shared_pref.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
      baseUrl: "http://api.stormx.space/api/v1",
      followRedirects: false,
      validateStatus: (status) {
        return status! < 500;
      }));

  Dio get getDio {
    _dio.interceptors.add(RetryInterceptor(
      dio: _dio,
      logPrint: debugPrint,
      retries: 3,
      retryDelays: const [
        Duration(seconds: 1),
        Duration(seconds: 2),
        Duration(seconds: 3),
      ],
    ));
    _dio.interceptors
        .add(QueuedInterceptorsWrapper(onRequest: (options, handler) async {
      if (options.path == "/auth/refresh-token") {
        return handler.next(options);
      }
      options.headers["Content-Type"] = "application/json";
      String accessToken = await getToken(TokenType.access);
      if (accessToken != "") {
        options.headers["Authorization"] = "Bearer $accessToken";
      }
      return handler.next(options);
    }, onResponse: (response, handler) async {
      if (response.statusCode == 401) {
        final refreshToken = await getToken(TokenType.refresh);
        Response response = await _dio.get("/auth/refresh-token",
            options:
                Options(headers: {"Authorization": "Bearer $refreshToken"}));
        if (response.statusCode == 200) {
          await setToken(
            response.data["body"]["access_token"],
            TokenType.access,
          );
          response.requestOptions.headers["Authorization"] =
              "Bearer ${response.data["body"]["access_token"]}";
          return handler.resolve(await _dio.fetch(response.requestOptions));
        }
      }
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("Response: ${response.data}");
      }
      return handler.next(response);
    }, onError: (e, handler) async {
      if (e.response!.statusCode == 401) {
        final refreshToken = await getToken(TokenType.refresh);
        Response response = await _dio.get("/auth/refresh-token",
            options:
                Options(headers: {"Authorization": "Bearer $refreshToken"}));
        if (response.statusCode == 200) {
          await setToken(
            response.data["body"]["access_token"],
            TokenType.access,
          );
          response.requestOptions.headers["Authorization"] =
              "Bearer ${response.data["body"]["access_token"]}";
          return handler.resolve(await _dio.fetch(response.requestOptions));
        }
      } else {
        return handler.next(e);
      }
    }));
    return _dio;
  }
}
