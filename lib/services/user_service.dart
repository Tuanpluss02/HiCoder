import 'package:flutter/material.dart';

import 'api_service.dart';

class UserService {
  Future<void> updateAvatar(String avatarUrl) async {
    try {
      await ApiService().updateAvatar(avatarUrl: avatarUrl);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
