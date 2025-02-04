import 'dart:convert';
import 'package:auto_indo/constants.dart';
import 'package:auto_indo/model/pair.dart';
import 'package:auto_indo/service/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

final AuthService _authService = AuthService();

class Jaring {
  String? id;
  String? koinId;
  String? modal;
  String? buy;
  String? sell;
  String? profit;
  String? status;
  Pair? pair;

  Jaring(
      {this.id,
      this.koinId,
      this.modal,
      this.buy,
      this.sell,
      this.profit,
      this.status,
      this.pair});

  factory Jaring.fromJson(Map<String, dynamic> json) {
    return Jaring(
      id: json['id'].toString(),
      koinId: json['koin_id'],
      modal: json['modal'],
      buy: json['buy'],
      sell: json['sell'],
      profit: json['profit'] ?? '0',
      status: json['status'],
      pair: Pair.fromJson(json['pairs']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'koin_id': koinId,
      'modal': modal,
      'buy': buy,
      'sell': sell,
      'profit': profit,
      'status': status,
    };
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['koin_id'] = koinId;
    data['modal'] = modal;
    data['buy'] = buy;
    data['sell'] = sell;
    data['status'] = status;
    return data;
  }

  static Future<List<Jaring>> getJaring() async {
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
    List<Jaring> listJaring =
        data.map((item) => Jaring.fromJson(item)).toList();

    return listJaring;
  }

  static Future<Jaring> detailJaring(String id) async {
    final token = await _authService.getToken();

    var uri = "$url/jaring/$id";
    http.Response response = await http.get(
      Uri.parse(uri),
      headers: {
        "Authorization": "Bearer $token",
      },
    );
    var result = jsonDecode(response.body);
    //await helper.insert(PairQuery.tableName, result);
    Jaring listJaring = Jaring.fromJson(result);

    return listJaring;
  }

  static Future<void> hapusJaring(String id) async {
    final token = await _authService.getToken();

    var uri = "$url/jaring?id=$id";
    await http.delete(Uri.parse(uri), headers: {
      "Authorization": "Bearer $token",
    });
  }

  static Future tambahJaring({
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

  static Future jaringBatch({
    required List<Jaring> jarings,
  }) async {
    final token = await _authService.getToken();

    List<Map<String, dynamic>> data =
        jarings.map((item) => item.toJson()).toList();

    var uri = "$url/jaring/batch";
    final body = {
      'jarings': data,
    };

    if (kDebugMode) {
      print(jsonEncode(body));
    }
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
