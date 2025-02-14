import 'package:http/http.dart' as http;
import 'dart:convert';

class Ohcl {
  double? time;
  double? open;
  double? high;
  double? low;
  double? close;
  double? volume;

  Ohcl({
    this.time,
    this.open,
    this.high,
    this.low,
    this.close,
    this.volume,
  });

  factory Ohcl.fromJson(Map<String, dynamic> json) {
    return Ohcl(
      time: double.parse(json['Time'].toString()),
      open: double.parse(json['Open'].toString()),
      high: double.parse(json['High'].toString()),
      low: double.parse(json['Low'].toString()),
      close: double.parse(json['Close'].toString()),
      volume: double.parse(json['Volume'].toString()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Time': time,
      'Open': open,
      'High': high,
      'Low': low,
      'Close': close,
      'Volume': volume,
    };
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['Time'] = time;
    data['Open'] = open;
    data['HIgh'] = high;
    data['Low'] = low;
    data['Close'] = close;
    data['Volume'] = volume;

    return data;
  }

  static Future<List<Ohcl>> fetchData(
      {required String pair, required String timeFrame}) async {
    // var to = DateTime.now().millisecondsSinceEpoch / 1000;
    // var from =
    //     DateTime.now().subtract(Duration(days: 3)).millisecondsSinceEpoch /
    //         1000;
    var uri = "https://autoindo.my.id/api/market";
    // var uri =
    //     "https://indodax.com/tradingview/history_v2?from=${from.toInt()}&symbol=$pair&tf=$timeFrame&to=${to.toInt()}";
    final body = {
      'pair': pair,
      'tf': timeFrame,
    };
    http.Response response = await http.post(Uri.parse(uri),
        headers: {
          "Content-Type": "application/json",
        },
        encoding: Encoding.getByName('utf-8'),
        body: jsonEncode(body));
    var result = jsonDecode(response.body) as List;
    List<Ohcl> listOhcl = result.map((item) => Ohcl.fromJson(item)).toList();

    return listOhcl;

    // http.Response response = await http.post(Uri.parse(uri));

    // var result = jsonDecode(response.body) as List;

    // //await helper.insert(PairQuery.tableName, result);
    // List<Ohcl> datas = result.map((item) {
    //   if (kDebugMode) {
    //     print(item);
    //   }
    //   return Ohcl.fromJson(item);
    // }).toList();

    // return datas;
  }
}
