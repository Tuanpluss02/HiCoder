import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hicoder/services/api_service.dart';

class MediaService {
  Future<String> uploadMedia(File file) async {
    String fileName = file.path.split('/').last;
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(file.path, filename: fileName),
    });
    Response response =
        await ApiService().getDio.post("/media/upload", data: formData);
    if (response.statusCode == 200) {
      return response.data["body"];
    } else {
      throw Exception(response.data["message"]);
    }
  }
}
