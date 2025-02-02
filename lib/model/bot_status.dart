import 'dart:convert';
import 'package:auto_indo/constants.dart';
import 'package:auto_indo/service/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

final AuthService _authService = AuthService();

class BotStatus {
  String? email;
  String? state;

  BotStatus({this.email, this.state});

  factory BotStatus.fromJson(Map<String, dynamic> json) {
    return BotStatus(email: json['email'], state: json['state']);
  }

  static Future<BotStatus?> getStatus() async {
    final token = await _authService.getToken();
    try {
      var uri = "$url/bstate";
      http.Response response = await http.get(
        Uri.parse(uri),
        headers: {
          "Authorization": "Bearer $token",
        },
      );
      var result = jsonDecode(response.body);

      BotStatus botInfo = BotStatus.fromJson(result);

      return botInfo;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  static Future updateStatus(String st) async {
    final token = await _authService.getToken();
    var uri = "$url/bstate";
    final body = {'state': st, '_method': 'put'};
    await http.post(
      Uri.parse(uri),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      encoding: Encoding.getByName('utf-8'),
      body: jsonEncode(body),
    );
  }
}
