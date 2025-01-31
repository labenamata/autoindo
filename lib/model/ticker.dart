import 'dart:convert';

import 'package:http/http.dart' as http;

class Ticker {
  String high;
  String low;
  String last;

  Ticker({
    required this.high,
    required this.low,
    required this.last,
  });

  factory Ticker.fromJson(Map<String, dynamic> json) {
    return Ticker(
      high: json['high'],
      low: json['low'],
      last: json['last'],
    );
  }

  static Future<Ticker> getTicker({required String koinId}) async {
    String pair = koinId.replaceAll('_', '');
    var url = "https://indodax.com/api/ticker/$pair";
    http.Response response = await http.get(Uri.parse(url));
    var result = jsonDecode(response.body);
    Ticker tick = Ticker.fromJson(result['ticker']);
    return tick;
  }
}
