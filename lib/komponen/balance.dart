import 'package:auto_indo/bloc/info_bloc.dart';
import 'package:auto_indo/model/info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

Widget balanceWidget() {
  return SizedBox(
    height: 100,
    width: double.infinity,
    //padding: const EdgeInsets.all(15),
    child: BlocBuilder<InfoBloc, InfoState>(builder: (context, state) {
      if (state is InfoUnitialized) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is InfoLoading) {
        return const Center(child: CircularProgressIndicator());
      } else {
        InfoLoaded infoLoaded = state as InfoLoaded;
        return FutureBuilder<Info>(
          future: infoLoaded.userInfo,
          builder: (context, snapshot) {
            var f = NumberFormat("#,###.0#", "en_US");
            if (snapshot.hasData) {
              return Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.2)),
                        ),
                        Text(
                          snapshot.data!.name!,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Balance',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.2)),
                        ),
                        Text(
                          'IDR ${f.format(int.parse(snapshot.data!.balance!))}',
                          style: const TextStyle(fontSize: 20),
                        )
                      ],
                    )
                  ],
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        );
      }
    }),
  );
}
