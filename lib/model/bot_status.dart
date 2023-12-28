import 'dart:convert';

import 'package:http/http.dart' as http;

class BotStatus {
  static Future<String> getStatus() async {
    var url = "https://trade.hondamobilsalatiga.com/api/getstatus";
    http.Response response = await http.get(Uri.parse(url));
    var result = response.body;
    return result;
  }

  static Future updateStatus(String st) async {
    var url = "https://trade.hondamobilsalatiga.com/api/botstatus";
    await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      encoding: Encoding.getByName('utf-8'),
      body: {'id': 'idx', 'boot': st},
    );
  }
}
