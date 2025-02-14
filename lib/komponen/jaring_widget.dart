import 'package:auto_indo/bloc/bstate_bloc.dart';
import 'package:auto_indo/bloc/info_bloc.dart';
import 'package:auto_indo/bloc/jaring_bloc.dart';
import 'package:auto_indo/bloc/ohcl_bloc.dart';
import 'package:auto_indo/constants.dart';
import 'package:auto_indo/komponen/candle_chart.dart';
import 'package:auto_indo/komponen/jaring_list.dart';
import 'package:auto_indo/model/jaring.dart';
import 'package:auto_indo/model/jarings.dart';
import 'package:auto_indo/model/pair.dart';
import 'package:auto_indo/model/ticker.dart';
import 'package:auto_indo/page/jaring_satuan.dart';
import 'package:auto_indo/page/ketahanan_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';

var f = NumberFormat("#,###", "en_US");

class JaringWidget extends StatelessWidget {
  const JaringWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        int crossAxisCount = 1;
        int crossAxisCountKat = 1;
        int crossAxisCountSingle = 1;

        if (constraints.maxWidth > 600) {
          crossAxisCount = 2;

          crossAxisCountKat = 2;
          crossAxisCountSingle = 4;
        }
        if (constraints.maxWidth > 900) {
          crossAxisCount = 2;
          crossAxisCountKat = 2;
          crossAxisCountSingle = 4;
        }
        return Container(
            padding: const EdgeInsets.all(15),
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
                  SizedBox(
                    height: 80,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Center(
                        child: Row(
                          children: [
                            BlocBuilder<BstateBloc, BstateState>(
                                builder: (context, state) {
                              if (state is BstateUnitialized) {
                                return Text(
                                  'Status : ...',
                                  style: TextStyle(fontSize: 18),
                                );
                              }
                              if (state is BstateLoading) {
                                return Text('Status :....',
                                    style: TextStyle(fontSize: 18));
                              }
                              BstateLoaded bstateLoaded = state as BstateLoaded;
                              return FutureBuilder(
                                future: bstateLoaded.userBstate,
                                builder: (context, snapshot) {
                                  return Text(
                                    'Status : ${snapshot.data?.state}',
                                    style: TextStyle(
                                        fontSize: 20,
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
                                minimumSize: const Size(120, 60),
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
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      title: Text(
                                        'Tambah Jaring',
                                      ),
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
                                                      (BuildContext context) {
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
                                                      (BuildContext context) {
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
                              child: Text('Tambah',
                                  style: TextStyle(fontSize: 18)),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'List Jaring',
                          style: TextStyle(fontSize: 18),
                        ),
                        Row(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.rectangle,
                                  size: 20,
                                  color:
                                      Colors.redAccent.withValues(alpha: 0.2),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text('Pending')
                              ],
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.rectangle,
                                  size: 20,
                                  color:
                                      Colors.greenAccent.withValues(alpha: 0.2),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text('Place Buy')
                              ],
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Row(
                              children: [
                                Icon(Icons.rectangle,
                                    size: 20,
                                    color:
                                        Colors.blueGrey.withValues(alpha: 0.2)),
                                SizedBox(
                                  width: 10,
                                ),
                                Text('Place Sell')
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  BlocBuilder<JaringBloc, JaringState>(
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

                      return FutureBuilder<List<Jarings>>(
                        future: jaringLoaded.jaring,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            int dataCount = snapshot.data!.length;
                            return Expanded(
                                child: MasonryGridView.count(
                              itemCount: dataCount,
                              crossAxisCount:
                                  dataCount > 1 ? crossAxisCount : 1,
                              crossAxisSpacing: 10,
                              itemBuilder: (context, index) {
                                Pair pair = snapshot.data![index].pair!;

                                List<Jaring?> jaring =
                                    snapshot.data![index].jaring!;

                                Future<Ticker> tik;
                                tik = Ticker.getTicker(koinId: pair.koinId!);
                                double totalProfit = snapshot
                                    .data![index].jaring!
                                    .fold(0, (c, p) {
                                  double total = c + double.parse(p!.profit!);
                                  return total;
                                });
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(
                                                8,
                                              ),
                                              topRight: Radius.circular(8)),
                                          color: Colors.white),
                                      padding: const EdgeInsets.all(15),
                                      child: Row(
                                        children: [
                                          Image(
                                              width: 50,
                                              height: 50,
                                              image: NetworkImage(pair.image!)),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${pair.name!}/${pair.curreny?.toUpperCase()}',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              FutureBuilder<Ticker>(
                                                future: tik,
                                                builder: (context, snapshot) {
                                                  String lastPrice;

                                                  if (snapshot.hasData) {
                                                    if (pair.curreny == 'idr') {
                                                      lastPrice = f.format(
                                                          double.parse(snapshot
                                                              .data!.last));
                                                    } else {
                                                      lastPrice =
                                                          snapshot.data!.last;
                                                    }
                                                    return Text(
                                                      lastPrice,
                                                      style: const TextStyle(
                                                          color: textBold,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    );
                                                  } else {
                                                    return Container();
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                          Spacer(),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                'Total Profit',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                snapshot.data![index].pair!
                                                            .curreny ==
                                                        'idr'
                                                    ? f.format(
                                                        totalProfit.toInt())
                                                    : totalProfit.toString(),
                                                style: TextStyle(
                                                    color: textBold,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          ElevatedButton(
                                              onPressed: () {
                                                var pairs = pair.koinId!
                                                    .replaceAll('_', '');

                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      OhclBloc ohclBloc =
                                                          BlocProvider.of<
                                                                  OhclBloc>(
                                                              context);
                                                      ohclBloc.add(OhclGet(
                                                          pair: pairs,
                                                          timeFrame: '15'));
                                                      return CandleChart(
                                                        pair: pair,
                                                      );
                                                    });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                minimumSize: Size(70, 50),
                                                backgroundColor:
                                                    Colors.greenAccent,
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: Text('Chart'))
                                        ],
                                      ),
                                    ),
                                    Container(
                                        padding: EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(8),
                                                bottomLeft: Radius.circular(8),
                                                bottomRight:
                                                    Radius.circular(8))),
                                        child: StaggeredGrid.count(
                                          crossAxisCount: dataCount > 1
                                              ? crossAxisCountKat
                                              : crossAxisCountSingle,
                                          crossAxisSpacing: 10,
                                          mainAxisSpacing: 10,
                                          children: jaring.map((item) {
                                            return jaringList(
                                                jaring: item!,
                                                currency: pair.curreny!,
                                                context: context);
                                          }).toList(),
                                        )),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                );
                              },
                            ));
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
                ],
              ),
            ));
      },
    );
  }
}
