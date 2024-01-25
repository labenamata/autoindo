import 'package:auto_indo/bloc/info_bloc.dart';
import 'package:auto_indo/model/info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

Widget balanceWidget() {
  return BlocBuilder<InfoBloc, InfoState>(builder: (context, state) {
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
            if (kDebugMode) {
              print(snapshot.data!.img!);
            }
            return Column(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //const Spacer(),
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Image(
                    image: NetworkImage(snapshot.data!.img!),
                    width: 70,
                    height: 70,
                  ),
                ),
                const Spacer(),
                Text(
                  snapshot.data!.name!,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                Text(
                  'IDR ${f.format(int.parse(snapshot.data!.balance!))}',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                )
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      );
    }
  });
}
