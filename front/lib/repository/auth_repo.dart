//lib/repository/auth_repo.dart
import 'package:http/http.dart' as http;
import 'dart:convert';


class AuthRepository {
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      var res = await http.post(
        Uri.parse("http://192.168.1.220:8080/auth/login"),
        headers: {},
        body: {"email": email, "password": password},
      );
      final data = json.decode(res.body);
      if (data['message'] == "admin logged in" || data['message'] == "user logged in") {
        return data;
      } else {
        return {"error": "Authentication problem"};
      }
    } catch (e) {
      return {"error": "An error occurred: $e"};
    }
  }

  Future<Map<String, dynamic>> signUp(
    String name,
    String email,
    String password,
    int type,
  ) async {
    try {
      var res = await http.post(
        Uri.parse("http://192.168.1.220:8080/auth/signup"),
        headers: {},
        body: {
          "name": name,
          "email": email,
          "password": password,
          "type": type.toString(),
        },
      );
      final data = json.decode(res.body);
      if (data['message'] == "admin signed up" || data['message'] == "user signed up") {
        return data;
      } else {
        return {"error": "Authentication problem"};
      }
    } catch (e) {
      return {"error": "An error occurred: $e"};
    }
  }
}


