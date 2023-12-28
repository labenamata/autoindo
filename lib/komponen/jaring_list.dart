import 'package:flutter/material.dart';
import 'package:auto_indo/komponen/svgicon.dart';
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
    required BuildContext context}) {
  var f = NumberFormat("#,###.0#", "en_US");
  return Container(
    //height: 45,
    height: 80,
    margin: const EdgeInsets.only(top: 8),
    decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: const BorderRadius.all(Radius.circular(2))),
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Center(
      child: Table(
        //border: TableBorder.all(),
        // columnWidths: const <int, TableColumnWidth>{
        //   0: FixedColumnWidth(64),
        //   1: FlexColumnWidth(),
        //   2: FixedColumnWidth(64),
        // },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: <TableRow>[
          TableRow(
            children: <Widget>[
              Row(
                children: [
                  svgicon(url: img),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        koinName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Text(
                        'modal',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.2), fontSize: 14),
                      ),
                      Text(
                        f.format(double.parse(modal)),
                        style: const TextStyle(fontSize: 17),
                      )
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    status.toUpperCase(),
                    style: TextStyle(
                        color: status.toUpperCase() == 'BUY'
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '$buy/$sell',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.2), fontSize: 14),
                  ),
                ],
              ),
              // TableCell(
              //   verticalAlignment: TableCellVerticalAlignment.top,
              //   child: Container(
              //     height: 32,
              //     width: 32,
              //     color: Colors.red,
              //   ),
              // ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'profit',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.2), fontSize: 14),
                  ),
                  Text(
                    f.format(double.parse(profit)),
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    ),
  );
}
