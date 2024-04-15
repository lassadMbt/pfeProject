// lib/repository/auth_repo.dart

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:tataguid/repository/AuthResponse.dart';
import '../storage/token_storage.dart';

class AuthRepository {
  final TokenStorage tokenStorage = TokenStorage();

  Future<AuthResponse> login(String email, String password) async {
  try {
    var res = await http.post(
      Uri.parse("http://localhost:8080/auth/login"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    ).timeout(Duration(seconds: 10)); // Adjust timeout duration as needed

    final data = json.decode(res.body);
    if (data['token'] != null) {
      return AuthResponse.fromJson(data); // Use constructor to create object
    } else if (data['message'] != null) {
      throw new Exception(data['message']);
    } else {
      throw new Exception('Failed to login!');
    }
  } catch (e) {
    rethrow; // Rethrow the exception for handling in the UI
  }
}


  Future<Map<String, dynamic>> signUp(
    String name,
    String agencyName,
    String email,
    String password,
    String type,
    String language,
    String country,
    String location,
    String description,
  ) async {
    try {
      var res = await http.post(
        Uri.parse("http://localhost:8080/auth/signup"),
        headers: {},
        body: {
          "name": name,
          "agencyName": agencyName,
          "email": email,
          "password": password,
          "type": type,
          "language": language,
          "country": country,
          "location": location,
          "description": description,
        },
      ).timeout(Duration(seconds: 10)); // Adjust timeout duration as needed

      final data = json.decode(res.body);
      if (data['message'] == "User created successfully" ||
          data['message'] == "Agency created successfully") {
        // Store token for later use
        await TokenStorage.storeToken(data['token']);
        return data;
      } else {
        return {"error": "Authentication problem"};
      }
    } catch (e) {
      return {"error": "An error occurred: $e"};
    }
  }

  Future<String?> getToken() async {
    return await TokenStorage.getToken();
  }
}
