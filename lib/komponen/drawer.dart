import 'package:auto_indo/constants.dart';
import 'package:auto_indo/komponen/balance.dart';
import 'package:flutter/material.dart';

Widget menuDrawer() {
  return Drawer(
    backgroundColor: backgroundColor,
    child: ListView(children: [
      DrawerHeader(
        decoration: const BoxDecoration(color: primaryColor),
        child: balanceWidget(),
      )
    ]),
  );
}
