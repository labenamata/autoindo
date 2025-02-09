import 'dart:convert';
import 'package:auto_indo/constants.dart';
import 'package:auto_indo/model/jaring.dart';
import 'package:auto_indo/model/pair.dart';
import 'package:auto_indo/service/auth_service.dart';
import 'package:http/http.dart' as http;

final AuthService _authService = AuthService();

class Jarings {
  Pair? pair;
  List<Jaring?>? jaring;

  Jarings({this.jaring, this.pair});

  factory Jarings.fromJson(Map<String, dynamic> json) {
    var data = json['jaring'] as List;
    return Jarings(
        pair: Pair.fromJson(json['pairs']),
        jaring: data.map((item) => Jaring.fromJson(item)).toList());
  }

  static Future<List<Jarings>> getJarings() async {
    final token = await _authService.getToken();

    var uri = "$url/jaring";
    http.Response response = await http.get(
      Uri.parse(uri),
      headers: {
        "Authorization": "Bearer $token",
      },
    );
    var result = jsonDecode(response.body);
    var data = result['data'] as List;
    //await helper.insert(PairQuery.tableName, result);
    List<Jarings> listJarings =
        data.map((item) => Jarings.fromJson(item)).toList();

    return listJarings;
  }

  static Future<void> hapusJarings(String id) async {
    final token = await _authService.getToken();

    var uri = "$url/jaring?id=$id";
    await http.delete(Uri.parse(uri), headers: {
      "Authorization": "Bearer $token",
    });
  }

  static Future tambahJarings({
    required String koinId,
    required String modal,
    required String buy,
    required String sell,
    required String status,
  }) async {
    final token = await _authService.getToken();

    var uri = "$url/jaring";
    final body = {
      'koin_id': koinId,
      'modal': modal,
      'buy': buy,
      'sell': sell,
    };
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

  static Future jaringsBatch({
    required List<Jaring> jarings,
  }) async {
    final token = await _authService.getToken();

    List<Map<String, dynamic>> data =
        jarings.map((item) => item.toJson()).toList();

    var uri = "$url/jaring/batch";
    final body = {
      'jarings': data,
    };

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
