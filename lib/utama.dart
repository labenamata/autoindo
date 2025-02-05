import 'package:auto_indo/bloc/bstate_bloc.dart';
import 'package:auto_indo/bloc/info_bloc.dart';
import 'package:auto_indo/bloc/jaring_bloc.dart';
import 'package:auto_indo/bloc/pair_bloc.dart';
import 'package:auto_indo/constants.dart';
import 'package:auto_indo/komponen/drawer.dart';
import 'package:auto_indo/komponen/jaring_list.dart';
import 'package:auto_indo/model/jaring.dart';
import 'package:auto_indo/page/jaring_satuan.dart';
import 'package:auto_indo/page/ketahanan_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          body: Container(
              padding: const EdgeInsets.only(
                  top: 8, left: 15, right: 15, bottom: 20),
              child: RefreshIndicator(
                onRefresh: () async {
                  JaringBloc jaringBloc = BlocProvider.of<JaringBloc>(context);
                  jaringBloc.add(JaringGet());
                  InfoBloc infoBloc = BlocProvider.of<InfoBloc>(context);
                  infoBloc.add(InfoGet());
                  await Future.delayed(const Duration(seconds: 2));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 9),
                      child: Text(
                        'List Jaring',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Expanded(
                      child: BlocBuilder<JaringBloc, JaringState>(
                          builder: (context, state) {
                        if (state is JaringUnitialized) {
                          return Expanded(
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.red,
                              ),
                            ),
                          );
                        } else if (state is JaringLoading) {
                          return Expanded(
                            child: Center(
                              child: CircularProgressIndicator(
                                color: primaryColor,
                              ),
                            ),
                          );
                        } else {
                          JaringLoaded jaringLoaded = state as JaringLoaded;
                          return FutureBuilder<List<Jaring>>(
                            future: jaringLoaded.jaring,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return LayoutBuilder(
                                    builder: (context, constraints) {
                                  // double lebar = double.infinity;

                                  int crossAxisCount = 1;
                                  double childAspectRatio = 2;

                                  if (constraints.maxWidth > 600) {
                                    crossAxisCount = 2;
                                    childAspectRatio = 1.5;
                                  }
                                  if (constraints.maxWidth > 900) {
                                    crossAxisCount = 4;
                                    childAspectRatio = 2.5;
                                  }
                                  return GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: crossAxisCount,
                                      crossAxisSpacing: 20,
                                      mainAxisSpacing: 10,
                                      childAspectRatio: childAspectRatio,
                                    ),
                                    itemCount: snapshot.data!.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return jaringList(
                                          currency: snapshot
                                              .data![index].pair!.curreny!,
                                          img: snapshot
                                              .data![index].pair!.image!,
                                          id: snapshot.data![index].id
                                              .toString(),
                                          buy: snapshot.data![index].buy!,
                                          koinName:
                                              snapshot.data![index].pair!.name!,
                                          sell: snapshot.data![index].sell!,
                                          context: context,
                                          modal: snapshot.data![index].modal!,
                                          status: snapshot.data![index].status!,
                                          profit: snapshot.data![index].profit!,
                                          koinId:
                                              snapshot.data![index].koinId!);
                                    },
                                    // separatorBuilder:
                                    //     (BuildContext context, int index) {
                                    //   return const SizedBox(
                                    //     height: 10,
                                    //   );
                                    // },
                                  );
                                });
                              } else {
                                return Expanded(
                                  child: Center(
                                    child: Icon(LineIcons.dochub),
                                  ),
                                );
                              }
                            },
                          );
                        }
                      }),
                    ),
                    SizedBox(
                      height: 80,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        color: Colors.white,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Center(
                            child: Row(
                              children: [
                                BlocBuilder<BstateBloc, BstateState>(
                                    builder: (context, state) {
                                  if (state is BstateUnitialized) {
                                    return Text('Status : ...');
                                  }
                                  if (state is BstateLoading) {
                                    return Text('Status :....');
                                  }
                                  BstateLoaded bstateLoaded =
                                      state as BstateLoaded;
                                  return FutureBuilder(
                                    future: bstateLoaded.userBstate,
                                    builder: (context, snapshot) {
                                      return Text(
                                        'Status : ${snapshot.data?.state}',
                                        style: TextStyle(
                                            color: snapshot.data?.state == 'off'
                                                ? Colors.red
                                                : Colors.green),
                                      );
                                    },
                                  );
                                }),
                                const Spacer(),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    maximumSize: const Size(90, 50),
                                    backgroundColor: Colors.amber,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          6), // Set radius here
                                    ),
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Tambah Jaring'),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ListTile(
                                                leading: Icon(LineIcons.check),
                                                title: Text('Satuan'),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  Navigator.push(context,
                                                      MaterialPageRoute(builder:
                                                          (BuildContext
                                                              context) {
                                                    return JaringSatuan();
                                                  }));
                                                },
                                              ),
                                              ListTile(
                                                leading:
                                                    Icon(LineIcons.doubleCheck),
                                                title: Text('Ketahanan'),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  Navigator.push(context,
                                                      MaterialPageRoute(builder:
                                                          (BuildContext
                                                              context) {
                                                    return InputFormPage();
                                                  }));
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Text('Tambah'),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
