import 'package:auto_indo/bloc/jaring_bloc.dart';
import 'package:auto_indo/constants.dart';
import 'package:auto_indo/model/jaring.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

Widget jaringList(
    {required Jaring jaring,
    required String currency,
    required BuildContext context}) {
  var f = NumberFormat("#,###", "en_US");

  return Container(
      //height: 45,
      height: 200,
      //margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
          color: jaring.status!.toUpperCase() == 'BUY'
              ? Colors.greenAccent.withValues(alpha: 0.2)
              : jaring.status!.toUpperCase() == 'SELL'
                  ? Colors.blueGrey.withValues(alpha: 0.2)
                  : Colors.redAccent.withValues(alpha: 0.2),
          borderRadius: BorderRadius.all(Radius.circular(8))),
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Buy@',
                    style: TextStyle(
                        color: jaring.status!.toUpperCase() == 'BUY'
                            ? Colors.greenAccent
                            : textColor,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    currency == 'idr'
                        ? f.format(double.parse(jaring.buy!))
                        : jaring.buy!,
                    style: const TextStyle(color: textColor),
                  )
                ],
              ),
              Spacer(),
              // Container(
              //   padding:
              //       const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              //   decoration: BoxDecoration(
              //       color: jaring.status!.toUpperCase() == 'BUY'
              //           ? Colors.green[50]
              //           : Colors.red[50],
              //       borderRadius: const BorderRadius.all(Radius.circular(6))),
              //   child: Text(
              //     jaring.status!.toUpperCase(),
              //     style: TextStyle(
              //         color: jaring.status!.toUpperCase() == 'BUY'
              //             ? Colors.green
              //             : Colors.red,
              //         fontWeight: FontWeight.bold),
              //   ),
              // ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sell@',
                    style: TextStyle(
                        color: jaring.status!.toUpperCase() == 'SELL'
                            ? Colors.redAccent
                            : textColor,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    currency == 'idr'
                        ? f.format(double.parse(jaring.sell!))
                        : jaring.sell!,
                    style: const TextStyle(color: textColor),
                  )
                ],
              ),

              // FutureBuilder<Ticker>(
              //   future: tik,
              //   builder: (context, snapshot) {
              //     String lastPrice;

              //     if (snapshot.hasData) {
              // if (currency == 'idr') {
              //   lastPrice = f.format(double.parse(snapshot.data!.last));
              // } else {
              //   lastPrice = snapshot.data!.last;
              // }
              //       return Text(
              //         lastPrice,
              //         style: const TextStyle(
              //             color: textBold, fontWeight: FontWeight.bold),
              //       );
              //     } else {
              //       return Container();
              //     }
              //   },
              // ),
            ],
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Profit',
                    style: TextStyle(
                        fontSize: 20,
                        color: textColor,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    currency == 'idr'
                        ? f.format(double.parse(jaring.profit!))
                        : jaring.profit!,
                    style: const TextStyle(fontSize: 20, color: textColor),
                  )
                ],
              ),
            ],
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Modal',
                    style: TextStyle(
                        color: textColor, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    currency == 'idr'
                        ? f.format(double.parse(jaring.modal!))
                        : jaring.modal!,
                    style: const TextStyle(color: textColor),
                  )
                ],
              ),
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
                              jaringBloc.add(JaringHapus(jaring.id!));
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
