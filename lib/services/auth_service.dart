import 'package:hicoder/services/api_service.dart';

import '../models/authentication.dart';
import '../utils/shared_pref.dart';

class AuthService {
  Future<bool> createUser(
      {required String email,
      required String password,
      String? role,
      String? adminKey}) async {
    try {
      final responseData = await ApiService().registerUser(
          authentication: Authentication(
              email: email,
              password: password,
              role: role,
              adminKey: adminKey));
      String accessToken = responseData.data['body']['access_token'];
      String refreshToken = responseData.data['body']['refresh_token'];
      setToken(accessToken, TokenType.access);
      setToken(refreshToken, TokenType.refresh);
      return true;
    } catch (e) {
      return false;
    }
  }

//this will save the details inputted by the user to firestore.
  // saveUserToFirestore(
  //     String name, User user, String email, String country) async {
  //   await usersRef.doc(user.uid).set({
  //     'username': name,
  //     'email': email,
  //     'time': Timestamp.now(),
  //     'id': user.uid,
  //     'bio': "",
  //     'country': country,
  //     'photoUrl': user.photoURL ?? '',
  //     'gender': '',
  //   });
  // }

  Future<bool> loginUser(
      {required String email, required String password}) async {
    try {
      final responseData = await ApiService().loginUser(
          authentication: Authentication(email: email, password: password));
      String accessToken = responseData.data['body']['access_token'];
      String refreshToken = responseData.data['body']['refresh_token'];
      setToken(accessToken, TokenType.access);
      setToken(refreshToken, TokenType.refresh);
      return true;
    } catch (e) {
      return false;
    }
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
  }
}
