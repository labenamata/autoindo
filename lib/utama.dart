import 'package:auto_indo/bloc/info_bloc.dart';
import 'package:auto_indo/bloc/jaring_bloc.dart';
import 'package:auto_indo/bloc/pair_bloc.dart';
import 'package:auto_indo/constants.dart';
import 'package:auto_indo/komponen/drawer.dart';
import 'package:auto_indo/komponen/jaring_list.dart';
import 'package:auto_indo/model/bot_status.dart';
import 'package:auto_indo/model/jaring.dart';
import 'package:auto_indo/page/detail_jaring.dart';
import 'package:auto_indo/page/tambah_jaring.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  String botStatus = '';
  @override
  void initState() {
    Future<String> stat;
    super.initState();
    stat = BotStatus.getStatus();
    stat.then((value) {
      setState(() {
        botStatus = value;
      });
    });

    JaringBloc jaringBloc = BlocProvider.of<JaringBloc>(context);
    InfoBloc infoBloc = BlocProvider.of<InfoBloc>(context);
    PairBloc pairBloc = BlocProvider.of<PairBloc>(context);
    jaringBloc.add(JaringGet());
    infoBloc.add(InfoGet());
    pairBloc.add(PairGet());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          key: _key,
          backgroundColor: backgroundColor,
          drawer: menuDrawer(),
          appBar: AppBar(
            backgroundColor: backgroundColor,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              'AutoIndo',
              style: TextStyle(color: textBold, fontWeight: FontWeight.bold),
            ),
            leading: Container(
              padding: const EdgeInsets.all(5),
              child: GestureDetector(
                onTap: () {
                  _key.currentState!.openDrawer();
                },
                child: const CircleAvatar(
                  backgroundColor: backgroundColor,
                  child: Icon(
                    LineIcons.bars,
                    color: textBold,
                  ),
                ),
              ),
            ),
            actions: [
              Container(
                padding: const EdgeInsets.all(5),
                child: GestureDetector(
                  onTap: () {
                    if (botStatus == 'on') {
                      Fluttertoast.showToast(msg: 'Stop Bot Terlebih Dahulu');
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const TambahJaring();
                          });
                    }
                  },
                  child: const CircleAvatar(
                    backgroundColor: backgroundColor,
                    child: Icon(
                      LineIcons.plus,
                      color: textBold,
                    ),
                  ),
                ),
              ),
            ],
            // actions: [
            //   ToggleButtons(
            //     direction: Axis.horizontal,
            //     onPressed: (int index) {
            //       if (index == 1) {
            //         BotStatus.updateStatus('off');
            //         setState(() {
            //           // The button that is tapped is set to true, and the others to false.

            //           botStatus = 'off';
            //         });

            //         Fluttertoast.showToast(msg: 'Bot Di Stop');
            //       } else {
            //         BotStatus.updateStatus('on');
            //         setState(() {
            //           // The button that is tapped is set to true, and the others to false.

            //           botStatus = 'on';
            //         });
            //         Fluttertoast.showToast(msg: 'Bot Di Start');
            //       }
            //     },
            //     constraints: const BoxConstraints(
            //       minHeight: 30.0,
            //       minWidth: 60.0,
            //     ),
            //     borderRadius: const BorderRadius.all(Radius.circular(8)),
            //     selectedBorderColor: Colors.blue[700],
            //     selectedColor: Colors.white,
            //     fillColor: Colors.blue[200],
            //     color: Colors.blue[400],
            //     isSelected: _runBot,
            //     children: icons,
            //   ),
            // ],
          ),
          //Body
          //
          //
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // balanceWidget(),
                // Divider(
                //   color: Colors.white.withOpacity(0.2),
                // ),
                // const Padding(
                //   padding: EdgeInsets.symmetric(vertical: 9),
                //   child: Text(
                //     'List Jaring',
                //     style: TextStyle(color: Colors.white, fontSize: 16),
                //   ),
                // ),
                BlocBuilder<JaringBloc, JaringState>(builder: (context, state) {
                  if (state is JaringUnitialized) {
                    return const Expanded(
                        child: Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    ));
                  } else if (state is JaringLoading) {
                    return const Expanded(
                        child: Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    ));
                  } else {
                    JaringLoaded jaringLoaded = state as JaringLoaded;
                    return FutureBuilder<List<Jaring>>(
                      future: jaringLoaded.jaring,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Expanded(
                            child: RefreshIndicator(
                              onRefresh: () async {
                                JaringBloc jaringBloc =
                                    BlocProvider.of<JaringBloc>(context);
                                jaringBloc.add(JaringGet());
                                InfoBloc infoBloc =
                                    BlocProvider.of<InfoBloc>(context);
                                infoBloc.add(InfoGet());
                                await Future.delayed(
                                    const Duration(seconds: 2));
                              },
                              child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 8,
                                        mainAxisSpacing: 4),
                                itemCount: snapshot.data!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return DetailJaring(
                                              id: snapshot.data![index].id
                                                  .toString(),
                                              koinId:
                                                  snapshot.data![index].koinId!,
                                              name: snapshot
                                                  .data![index].pair!.name!,
                                              modal:
                                                  snapshot.data![index].modal!,
                                              buy: snapshot.data![index].buy!,
                                              sell: snapshot.data![index].sell!,
                                              status:
                                                  snapshot.data![index].status!,
                                              image: snapshot
                                                  .data![index].pair!.image!,
                                            );
                                          });
                                    },
                                    child: jaringList(
                                        img: snapshot.data![index].pair!.image!,
                                        id: snapshot.data![index].id.toString(),
                                        buy: snapshot.data![index].buy!,
                                        koinName:
                                            snapshot.data![index].pair!.name!,
                                        sell: snapshot.data![index].sell!,
                                        context: context,
                                        modal: snapshot.data![index].modal!,
                                        status: snapshot.data![index].status!,
                                        profit: snapshot.data![index].profit!,
                                        koinId: snapshot.data![index].koinId!),
                                  );
                                },
                              ),
                            ),
                          );
                        } else {
                          return const Expanded(
                              child: Center(
                            child: CircularProgressIndicator(),
                          ));
                        }
                      },
                    );
                  }
                }),
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Builder(
            builder: (context) {
              if (botStatus == 'on') {
                return FloatingActionButton.extended(
                    elevation: 0,
                    backgroundColor: Colors.red,
                    onPressed: () {
                      BotStatus.updateStatus('off');
                      setState(() {
                        botStatus = 'off';
                      });

                      Fluttertoast.showToast(msg: 'Bot Telah Dihentikan');
                    },
                    icon: const Icon(
                      LineIcons.stopCircle,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Stop Bot',
                      style: TextStyle(color: Colors.white),
                    ));
              } else {
                return FloatingActionButton.extended(
                    elevation: 0,
                    backgroundColor: Colors.green,
                    onPressed: () {
                      BotStatus.updateStatus('on');
                      setState(() {
                        botStatus = 'on';
                      });

                      Fluttertoast.showToast(msg: 'Bot Dijalankan');
                    },
                    icon: const Icon(
                      LineIcons.playCircle,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Start Bot',
                      style: TextStyle(color: Colors.white),
                    ));
              }
            },
          )
          //Floating Action Button
          //
          //
          // floatingActionButton: FloatingActionButton(
          //   backgroundColor: Colors.blue,
          //   onPressed: () {
          //     //Fluttertoast.showToast(msg: botStatus);
          //     if (botStatus == 'on') {
          //       Fluttertoast.showToast(msg: 'Stop Bot Terlebih Dahulu');
          //     } else {
          //       showDialog(
          //           context: context,
          //           builder: (BuildContext context) {
          //             return const TambahJaring();
          //           });
          //     }
          //   },
          //   child: const Icon(
          //     Icons.add,
          //     color: Colors.white,
          //     size: 40,
          //   ),
          // ),
          ),
    );
  }
}
