import 'dart:convert';
import 'package:auto_indo/model/pair.dart';
import 'package:http/http.dart' as http;

class Jaring {
  String? id;
  String? koinId;
  String? modal;
  String? buy;
  String? sell;
  String? get;
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
      pair: Pair.fromJson(json['pair']),
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
    var url = "https://trade.hondamobilsalatiga.com/api/getjaring";
    http.Response response = await http.get(Uri.parse(url));
    var result = jsonDecode(response.body) as List;
    //await helper.insert(PairQuery.tableName, result);
    List<Jaring> listJaring =
        result.map((item) => Jaring.fromJson(item)).toList();

    return listJaring;
  }

  static Future<Jaring> detailJaring(String id) async {
    var url = "https://trade.hondamobilsalatiga.com/api/detailjaring/$id";
    http.Response response = await http.get(Uri.parse(url));
    var result = jsonDecode(response.body);
    //await helper.insert(PairQuery.tableName, result);
    Jaring listJaring = Jaring.fromJson(result);

    return listJaring;
  }

  static Future<List<Jaring>> hapusJaring(String id) async {
    var url = "https://trade.hondamobilsalatiga.com/api/hapusjaring/$id";
    http.Response response = await http.get(Uri.parse(url));
    var result = jsonDecode(response.body) as List;
    //await helper.insert(PairQuery.tableName, result);
    List<Jaring> listJaring =
        result.map((item) => Jaring.fromJson(item)).toList();

    return listJaring;
  }

  static Future<List<Jaring>> tambahJaring({
    required String koinId,
    required String modal,
    required String buy,
    required String sell,
    required String status,
  }) async {
    var url = "https://trade.hondamobilsalatiga.com/api/addjaring";
    http.Response response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      encoding: Encoding.getByName('utf-8'),
      body: {
        'koin_id': koinId,
        'modal': modal,
        'buy': buy,
        'sell': sell,
        'status': status
      },
    );
    var result = jsonDecode(response.body) as List;
    //await helper.insert(PairQuery.tableName, result);
    List<Jaring> listJaring =
        result.map((item) => Jaring.fromJson(item)).toList();

    return listJaring;
  }
}
