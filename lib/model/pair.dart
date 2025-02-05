import 'dart:convert';

import 'package:auto_indo/constants.dart';
import 'package:http/http.dart' as http;

class Pair {
  String? koinId;
  String? name;
  String? curreny;
  String? image;
  String? fee;
  String? ticker;

  Pair({
    this.name,
    this.koinId,
    this.curreny,
    this.image,
    this.fee,
    this.ticker,
  });

  factory Pair.fromJson(Map<String, dynamic> json) {
    return Pair(
      name: json['name'],
      koinId: json['koin_id'],
      curreny: json['currency'],
      image: json['image'],
      fee: json['fee'],
      ticker: json['ticker'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'koinId': koinId,
      'curreny': curreny,
      'image': image,
      'fee': fee,
      'ticker': ticker,
    };
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['name'] = name;
    data['koinId'] = koinId;
    data['name'] = name;
    data['image'] = image;
    data['fee'] = fee;
    data['ticker'] = ticker;

    return data;
  }

  static Future<List<Pair>> getPair({required String currency}) async {
    var uri = "$url/koin/$currency";
    http.Response response = await http.get(Uri.parse(uri));
    var result = jsonDecode(response.body) as List;
    //await helper.insert(PairQuery.tableName, result);
    List<Pair> listPair = result.map((item) => Pair.fromJson(item)).toList();

    return listPair;
  }

  static Future<List<Pair>> filterPair(
      {required String currency, required String name}) async {
    String nama = 'all';
    if (name != '') {
      nama = name;
    }
    var uri = "$url/koin/$currency/$nama";
    http.Response response = await http.get(Uri.parse(uri));
    var result = jsonDecode(response.body) as List;
    //await helper.insert(PairQuery.tableName, result);
    List<Pair> listPair = result.map((item) => Pair.fromJson(item)).toList();

    return listPair;
  }
}
