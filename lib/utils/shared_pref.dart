import 'package:shared_preferences/shared_preferences.dart';

enum TokenType { access, refresh }

Future<void> setUserId(String userId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("userId", userId);
}

Future<String> getUserId() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("userId") ?? "";
}

Future<bool> setToken(String token, TokenType type) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  if (type == TokenType.access) {
    return prefs.setString("Access_token", token);
  } else {
    return prefs.setString("Refresh_token", token);
  }
}

Future<String> getToken(TokenType type) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  if (type == TokenType.access) {
    return prefs.getString("Access_token") ?? "";
  } else {
    return prefs.getString("Refresh_token") ?? "";
  }
}

Future<bool> removeToken(TokenType tokenType) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  if (tokenType == TokenType.access) {
    return prefs.remove("Access_token");
  } else {
    return prefs.remove("Refresh_token");
  }
}
