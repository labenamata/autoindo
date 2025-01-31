import 'dart:convert';

import 'package:auto_indo/constants.dart';
import 'package:auto_indo/service/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

final AuthService _authService = AuthService();

class Info {
  String? name;
  String? balance;
  String? img;

  Info({this.name, this.balance, this.img});

  factory Info.fromJson(Map<String, dynamic> json) {
    return Info(
      name: json['return']['name'],
      balance: json['return']['balance']['idr'].toString(),
      img: json['return']['profile_picture'],
    );
  }

  static Future<Info?> getInfo() async {
    final token = await _authService.getToken();

    var uri = "$url/profile";
    try {
      http.Response response = await http.get(
        Uri.parse(uri),
        headers: {
          "Authorization": "Bearer $token",
        },
      );
      var result = jsonDecode(response.body);
      //await helper.insert(PairQuery.tableName, result);
      Info userInfo = Info.fromJson(result);

      return userInfo;
    } catch (e) {
      if (kDebugMode) {
        print('Error during login: $e');
      }
      return null;
    }
  }
}
