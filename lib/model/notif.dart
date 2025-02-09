import 'dart:convert';

import 'package:auto_indo/constants.dart';
import 'package:auto_indo/service/auth_service.dart';
import 'package:http/http.dart' as http;

final AuthService _authService = AuthService();

class NotifList {
  int? count;
  List<Notif>? notif;
  NotifList({this.count, this.notif});

  factory NotifList.fromJson(Map<String, dynamic> json) {
    var data = json['Notification'] as List;
    return NotifList(
      count: json['jml'],
      notif: data.map((item) => Notif.fromJson(item)).toList(),
    );
  }

  static Future<NotifList?> getNotif() async {
    final token = await _authService.getToken();

    var uri = "$url/notif";
    try {
      http.Response response = await http.get(
        Uri.parse(uri),
        headers: {
          "Authorization": "Bearer $token",
        },
      );
      var result = jsonDecode(response.body);
      //await helper.insert(PairQuery.tableid, result);
      NotifList userNotif = NotifList.fromJson(result);

      return userNotif;
    } catch (e) {
      return null;
    }
  }

  static Future<NotifList?> readNotif() async {
    final token = await _authService.getToken();

    var uri = "$url/notif";
    try {
      http.Response response = await http.get(
        Uri.parse(uri),
        headers: {
          "Authorization": "Bearer $token",
        },
      );
      var result = jsonDecode(response.body);
      //await helper.insert(PairQuery.tableid, result);
      NotifList userNotif = NotifList.fromJson(result);

      return userNotif;
    } catch (e) {
      return null;
    }
  }
}

class Notif {
  int? id;
  String? read;
  String? notification;
  String? date;

  Notif({this.id, this.read, this.notification, this.date});

  factory Notif.fromJson(Map<String, dynamic> json) {
    return Notif(
      id: json['id'],
      read: json['read'],
      notification: json['notification'],
      date: json['created_at'],
    );
  }
}
