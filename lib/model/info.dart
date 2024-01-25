import 'dart:convert';

import 'package:http/http.dart' as http;

class Info {
  String? name;
  String? balance;
  String? img;

  Info({this.name, this.balance, this.img});

  factory Info.fromJson(Map<String, dynamic> json) {
    return Info(
      name: json['name'],
      balance: json['balance']['idr'].toString(),
      img: json['profile_picture'],
    );
  }

  static Future<Info> getInfo() async {
    var url = "https://trade.hondamobilsalatiga.com/api/info";
    http.Response response = await http.get(Uri.parse(url));
    var result = jsonDecode(response.body);
    //await helper.insert(PairQuery.tableName, result);
    Info userInfo = Info.fromJson(result);

    return userInfo;
  }
}
