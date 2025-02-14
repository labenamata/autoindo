import 'package:auto_indo/bloc/info_bloc.dart';
import 'package:auto_indo/model/info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';

Widget balanceWidget() {
  return BlocBuilder<InfoBloc, InfoState>(builder: (context, state) {
    if (state is InfoUnitialized) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is InfoLoading) {
      return const Center(child: CircularProgressIndicator());
    } else {
      InfoLoaded infoLoaded = state as InfoLoaded;
      return FutureBuilder<Info?>(
        future: infoLoaded.userInfo,
        builder: (context, snapshot) {
          var f = NumberFormat("#,###.0#", "en_US");
          if (snapshot.hasData) {
            return UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.amber,
                ),
                accountName: Text(snapshot.data!.name!),
                accountEmail:
                    Text('IDR ${f.format(int.parse(snapshot.data!.balance!))}'),
                currentAccountPicture: snapshot.data!.img != '' &&
                        snapshot.data?.img != null
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(
                          snapshot.data!.img!, // Replace with your image URL
                        ),
                        radius: 30,
                      )
                    : CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 30,
                        child: Icon(
                          LineIcons.userAstronaut,
                          size: 30,
                        ),
                      ));
          } else {
            return UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.amber,
                ),
                accountName: Text('Tidak bisa memuat profile'),
                accountEmail: Text('Cek Internet atau key anda'),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(
                    '', // Replace with your image URL
                  ),
                  radius: 30,
                ));
          }
        },
      );
    }
  });
}
