import 'dart:io';

import 'package:hicoder/services/api_service.dart';

class MediaService {
  Future<String> uploadMedia(File inp) async {
    return await ApiService().uploadMedia(inp);
  }
}
