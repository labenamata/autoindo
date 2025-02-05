import 'dart:convert';

import 'package:auto_indo/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<String?> registerUser(
      String name, String email, String password) async {
    final String apiUrl = "$url/register";
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['token']; // Assuming token is in 'token' field
      } else {
        if (kDebugMode) {
          print('Registration failed: ${response.body}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during registration: $e');
      }
      return null;
    }
  }

  Future<String?> loginUser(String email, String password) async {
    final String apiUrl = "$url/login";
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['token']; // Assuming token is in 'token' field
      } else {
        if (kDebugMode) {
          print('login failed: ${response.statusCode}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during login: $e');
      }
      return null;
    }
  }

  Future<void> logout() async {
    final String apiUrl = "$url/logout";
    try {
      await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error during login: $e');
      }
    }
    deleteToken();
  }

  Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<void> deleteToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> saveAddress(String address) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('server_address', address);
  }

  Future<String?> getAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('server_address');
  }
}
