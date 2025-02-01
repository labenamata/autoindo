import 'package:auto_indo/bloc/jaring_bloc.dart';
import 'package:auto_indo/constants.dart';
import 'package:auto_indo/model/ticker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

Widget jaringList(
    {required String img,
    required String id,
    required String koinId,
    required String buy,
    required String sell,
    required String koinName,
    required String modal,
    required String status,
    required String profit,
    required String currency,
    required BuildContext context}) {
  var f = NumberFormat("#,###", "en_US");

  Future<Ticker> tik = Ticker.getTicker(koinId: koinId);

  return Container(
      //height: 45,
      height: 200,
      //margin: const EdgeInsets.only(top: 8),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '$koinName($koinId)',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16, color: textBold),
              ),
              const SizedBox(
                width: 10,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: status.toUpperCase() == 'BUY'
                        ? Colors.green[50]
                        : Colors.red[50],
                    borderRadius: const BorderRadius.all(Radius.circular(6))),
                child: Text(
                  status.toUpperCase(),
                  style: TextStyle(
                      color: status.toUpperCase() == 'BUY'
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const Spacer(),
              FutureBuilder<Ticker>(
                future: tik,
                builder: (context, snapshot) {
                  String lastPrice;

                  if (snapshot.hasData) {
                    if (currency == 'idr') {
                      lastPrice = f.format(double.parse(snapshot.data!.last));
                    } else {
                      lastPrice = snapshot.data!.last;
                    }
                    return Text(
                      lastPrice,
                      style: const TextStyle(
                          color: textBold, fontWeight: FontWeight.bold),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Expanded(
                  child: Text(
                'Modal',
                style: TextStyle(color: textColor),
              )),
              Expanded(
                  child: Text(
                currency == 'idr' ? f.format(double.parse(modal)) : modal,
                style: const TextStyle(color: textColor),
              ))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Expanded(
                  child: Text(
                'Buy',
                style: TextStyle(color: textColor),
              )),
              Expanded(
                  child: Text(
                maxLines: 1,
                overflow: TextOverflow.clip,
                currency == 'idr' ? f.format(double.parse(buy)) : buy,
                style: const TextStyle(color: textColor),
              ))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Expanded(
                  child: Text(
                'Sell',
                style: TextStyle(color: textColor),
              )),
              Expanded(
                  child: Text(
                maxLines: 1,
                overflow: TextOverflow.clip,
                currency == 'idr' ? f.format(double.parse(sell)) : sell,
                style: const TextStyle(color: textColor),
              ))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Expanded(
                  child: Text(
                'Profit',
                style: TextStyle(color: textColor),
              )),
              Expanded(
                  child: Text(
                maxLines: 1,
                overflow: TextOverflow.clip,
                currency == 'idr' ? f.format(double.parse(profit)) : profit,
                style: const TextStyle(color: textColor),
              ))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Spacer(),
              TextButton(
                style: TextButton.styleFrom(
                  maximumSize: const Size(90, 50),
                  backgroundColor: Colors.red[300],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6), // Set radius here
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Konfirmasi"),
                        content: const Text("Yakin akan menghapus jaring?"),
                        actions: [
                          TextButton(
                            child: const Text("Tidak"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: const Text(
                              "Ya",
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () {
                              JaringBloc jaringBloc =
                                  BlocProvider.of<JaringBloc>(context);
                              jaringBloc.add(JaringHapus(id));
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Hapus'),
              ),
            ],
          )
        ],
      ));
}
