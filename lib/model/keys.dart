import 'dart:convert';

import 'package:auto_indo/constants.dart';
import 'package:auto_indo/service/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

final AuthService _authService = AuthService();

class Keys {
  String? key;
  String? secret;

  Keys({this.key, this.secret});

  factory Keys.fromJson(Map<String, dynamic> json) {
    return Keys(
      key: json['key'] ?? '',
      secret: json['secret'] ?? '',
    );
  }

  static Future<Keys?> getKeys() async {
    final token = await _authService.getToken();

    var uri = "$url/kredentials";
    try {
      http.Response response = await http.get(
        Uri.parse(uri),
        headers: {
          "Authorization": "Bearer $token",
        },
      );
      var result = jsonDecode(response.body);
      //await helper.insert(PairQuery.tablekey, result);
      Keys userKeys = Keys.fromJson(result);

      return userKeys;
    } catch (e) {
      if (kDebugMode) {
        print('Error during login: $e');
      }
      return null;
    }
  }

  static Future<bool> saveKeys(String key, String secret) async {
    final token = await _authService.getToken();

    var uri = "$url/kredentials";
    try {
      http.Response response = await http.post(
        Uri.parse(uri),
        headers: {
          "Authorization": "Bearer $token",
        },
        encoding: Encoding.getByName('utf-8'),
        body: {
          'key': key,
          'modal': secret,
        },
      );
      var result = jsonDecode(response.body);
      if (result['message'] == 'Kredential created successfully') {
        return true;
      }

      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Error during login: $e');
      }
      return false;
    }
  }

  static Future<bool> updateKeys(String key, String secret) async {
    final token = await _authService.getToken();

    var uri = "$url/kredentials";
    try {
      final body = {
        'key': key,
        'secret': secret,
        '_method': 'put',
      };
      http.Response response = await http.post(Uri.parse(uri),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
          encoding: Encoding.getByName('utf-8'),
          body: jsonEncode(body));
      var result = jsonDecode(response.body);
      if (kDebugMode) {
        print(result);
      }
      if (result['message'] == 'Kredential updated successfully') {
        return true;
      }

      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Error during login: $e');
      }
      return false;
    }
  }
}
