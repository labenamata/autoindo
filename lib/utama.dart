import 'package:auto_indo/bloc/info_bloc.dart';
import 'package:auto_indo/bloc/jaring_bloc.dart';
import 'package:auto_indo/bloc/pair_bloc.dart';
import 'package:auto_indo/constants.dart';
import 'package:auto_indo/komponen/balance.dart';
import 'package:auto_indo/komponen/drawer.dart';
import 'package:auto_indo/komponen/jaring_list.dart';
import 'package:auto_indo/model/bot_status.dart';
import 'package:auto_indo/model/jaring.dart';
import 'package:auto_indo/page/tambah_jaring.dart';
import 'package:auto_indo/service/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:line_icons/line_icons.dart';

const List<Widget> icons = <Widget>[
  Icon(Icons.play_arrow_rounded),
  Icon(Icons.stop_rounded),
];

final GlobalKey<ScaffoldState> _key = GlobalKey();
final AuthService _authService = AuthService();

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
    _getToken();
    // stat.then((value) {
    //   setState(() {
    //     botStatus = value!.state;
    //   });
    // });

    JaringBloc jaringBloc = BlocProvider.of<JaringBloc>(context);
    jaringBloc.add(JaringGet());

    PairBloc pairBloc = BlocProvider.of<PairBloc>(context);
    pairBloc.add(PairGet());

    InfoBloc infoBloc = BlocProvider.of<InfoBloc>(context);
    infoBloc.add(InfoGet());
  }

  Future<void> _getToken() async {
    final tokens = await _authService.getToken();

    setState(() {
      token = tokens;
      if (kDebugMode) {
        print(token);
      }
    });
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
        ),
        //Body
        //
        //
        body: Container(
            padding:
                const EdgeInsets.only(top: 8, left: 15, right: 15, bottom: 20),
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
                  // balanceWidget(),
                  // Divider(
                  //   color: Colors.white.withValues(alpha: 0.2),
                  // ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 9),
                    child: Text(
                      'List Jaring',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  BlocBuilder<JaringBloc, JaringState>(
                      builder: (context, state) {
                    if (state is JaringUnitialized) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.red,
                        ),
                      );
                    } else if (state is JaringLoading) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      );
                    } else {
                      JaringLoaded jaringLoaded = state as JaringLoaded;
                      return FutureBuilder<List<Jaring>>(
                        future: jaringLoaded.jaring,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Expanded(
                              child: ListView.separated(
                                // gridDelegate:
                                //     const SliverGridDelegateWithFixedCrossAxisCount(
                                //         crossAxisCount: 2,
                                //         crossAxisSpacing: 8,
                                //         mainAxisSpacing: 4),
                                itemCount: snapshot.data!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return jaringList(
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
                                      koinId: snapshot.data![index].koinId!);
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const SizedBox(
                                    height: 10,
                                  );
                                },
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      );
                    }
                  }),
                  SizedBox(
                    height: 80,
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Center(
                        child: Row(
                          children: [
                            Text('Status :'),
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
                                      return const TambahJaring();
                                    });
                              },
                              child: Text('Tambah'),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        // floatingActionButton: Builder(
        //   builder: (context) {
        //     if (botStatus == 'on') {
        //       return FloatingActionButton.extended(
        //           elevation: 0,
        //           backgroundColor: Colors.red,
        //           onPressed: () async {
        //             String? token = await _authService.getToken();
        //             BotStatus.updateStatus('off', token!);
        //             setState(() {
        //               botStatus = 'off';
        //             });
        //           },
        //           icon: const Icon(
        //             LineIcons.stopCircle,
        //             color: Colors.white,
        //           ),
        //           label: const Text(
        //             'Stop Bot',
        //             style: TextStyle(color: Colors.white),
        //           ));
        //     } else {
        //       return FloatingActionButton.extended(
        //           elevation: 0,
        //           backgroundColor: Colors.green,
        //           onPressed: () async {
        //             // String? token = await _authService.getToken();
        //             // BotStatus.updateStatus('on', token!);
        //             // setState(() {
        //             //   botStatus = 'on';
        //             // });
        //             Future<List<Jaring>> jaring;
        //             // emit(JaringLoading());
        //             jaring = Jaring.getJaring();
        //             if (kDebugMode) {
        //               print(jaring);
        //             }
        //           },
        //           icon: const Icon(
        //             LineIcons.playCircle,
        //             color: Colors.white,
        //           ),
        //           label: const Text(
        //             'Start Bot',
        //             style: TextStyle(color: Colors.white),
        //           ));
        //     }
        //   },
        // )
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
