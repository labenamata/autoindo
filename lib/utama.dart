import 'package:auto_indo/bloc/bstate_bloc.dart';
import 'package:auto_indo/bloc/info_bloc.dart';
import 'package:auto_indo/bloc/jaring_bloc.dart';
import 'package:auto_indo/bloc/pair_bloc.dart';
import 'package:auto_indo/constants.dart';
import 'package:auto_indo/komponen/drawer.dart';
import 'package:auto_indo/komponen/jaring_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:line_icons/line_icons.dart';

const List<Widget> icons = <Widget>[
  Icon(Icons.play_arrow_rounded),
  Icon(Icons.stop_rounded),
];

final GlobalKey<ScaffoldState> _key = GlobalKey();

class Utama extends StatefulWidget {
  const Utama({super.key});

  @override
  State<Utama> createState() => _UtamaState();
}

class _UtamaState extends State<Utama> {
  String? botStatus = '';
  String? token;
  var f = NumberFormat("#,###", "en_US");
  @override
  void initState() {
    // Future<BotStatus?> stat;
    super.initState();
    // stat = BotStatus.getStatus();
    // _getToken();
    // stat.then((value) {
    //   setState(() {
    //     botStatus = value!.state;
    //   });
    // });

    JaringBloc jaringBloc = BlocProvider.of<JaringBloc>(context);
    jaringBloc.add(JaringGet());

    PairBloc pairBloc = BlocProvider.of<PairBloc>(context);
    pairBloc.add(PairGet(current: 'idr'));

    InfoBloc infoBloc = BlocProvider.of<InfoBloc>(context);
    infoBloc.add(InfoGet());

    BstateBloc bstateBloc = BlocProvider.of<BstateBloc>(context);
    bstateBloc.add(BstateGet());
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
            key: _key,
            backgroundColor: backgroundColor,
            drawer: menuDrawer(context),
            appBar: AppBar(
              backgroundColor: Colors.amber,
              elevation: 0,
              centerTitle: true,
              title: const Text(
                'AutoIndo',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: Container(
                padding: const EdgeInsets.all(5),
                child: GestureDetector(
                  onTap: () {
                    _key.currentState!.openDrawer();
                  },
                  child: Icon(
                    LineIcons.bars,
                  ),
                ),
              ),
            ),
            body: JaringWidget()),
      ),
    );
  }
}
