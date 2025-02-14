import 'package:auto_indo/bloc/ohcl_bloc.dart';
import 'package:auto_indo/constants.dart';
import 'package:auto_indo/function/calculate_rsi.dart';
import 'package:auto_indo/model/pair.dart';
import 'package:auto_indo/model/ticker.dart';
import 'package:candlesticks/candlesticks.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

var f = NumberFormat("#,###", "en_US");

class CandleChart extends StatefulWidget {
  const CandleChart({super.key, required this.pair});
  final Pair pair;
  @override
  State<CandleChart> createState() => _CandleChartState();
}

class _CandleChartState extends State<CandleChart> {
  String selectedItem = '15';
  @override
  Widget build(BuildContext context) {
    Future<Ticker> tik;
    tik = Ticker.getTicker(koinId: widget.pair.koinId!);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: SizedBox(
          width: 700,
          height: 800,
          child: Column(
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
                child: Row(
                  children: [
                    Image(
                        width: 50,
                        height: 50,
                        image: NetworkImage(widget.pair.image!)),
                    SizedBox(
                      width: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.pair.name!}/${widget.pair.curreny?.toUpperCase()}',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        FutureBuilder<Ticker>(
                          future: tik,
                          builder: (context, snapshot) {
                            String lastPrice;

                            if (snapshot.hasData) {
                              if (widget.pair.curreny == 'idr') {
                                lastPrice =
                                    f.format(double.parse(snapshot.data!.last));
                              } else {
                                lastPrice = snapshot.data!.last;
                              }
                              return Text(
                                lastPrice,
                                style: const TextStyle(
                                    color: textBold,
                                    fontWeight: FontWeight.bold),
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        OhclBloc ohclBloc = BlocProvider.of<OhclBloc>(context);
                        ohclBloc.add(OhclGet(
                            pair: widget.pair.koinId!.replaceAll('_', ''),
                            timeFrame: '5'));
                        setState(() {
                          selectedItem = '5';
                        });
                      },
                      style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          backgroundColor: selectedItem == '5'
                              ? Colors.amberAccent
                              : Colors.white),
                      child: Text('5'),
                    ),
                    TextButton(
                        onPressed: () {
                          OhclBloc ohclBloc =
                              BlocProvider.of<OhclBloc>(context);
                          ohclBloc.add(OhclGet(
                              pair: widget.pair.koinId!.replaceAll('_', ''),
                              timeFrame: '15'));
                          setState(() {
                            selectedItem = '15';
                          });
                        },
                        style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            backgroundColor: selectedItem == '15'
                                ? Colors.amberAccent
                                : Colors.white),
                        child: Text('15')),
                    TextButton(
                        onPressed: () {
                          OhclBloc ohclBloc =
                              BlocProvider.of<OhclBloc>(context);
                          ohclBloc.add(OhclGet(
                              pair: widget.pair.koinId!.replaceAll('_', ''),
                              timeFrame: '30'));
                          setState(() {
                            selectedItem = '30';
                          });
                        },
                        style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            backgroundColor: selectedItem == '30'
                                ? Colors.amberAccent
                                : Colors.white),
                        child: Text('30')),
                    TextButton(
                        onPressed: () {
                          OhclBloc ohclBloc =
                              BlocProvider.of<OhclBloc>(context);
                          ohclBloc.add(OhclGet(
                              pair: widget.pair.koinId!.replaceAll('_', ''),
                              timeFrame: '60'));
                          setState(() {
                            selectedItem = '60';
                          });
                        },
                        style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            backgroundColor: selectedItem == '60'
                                ? Colors.amberAccent
                                : Colors.white),
                        child: Text('60')),
                    TextButton(
                        onPressed: () {
                          OhclBloc ohclBloc =
                              BlocProvider.of<OhclBloc>(context);
                          ohclBloc.add(OhclGet(
                              pair: widget.pair.koinId!.replaceAll('_', ''),
                              timeFrame: '1D'));
                          setState(() {
                            selectedItem = '1H';
                          });
                        },
                        style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            backgroundColor: selectedItem == '1H'
                                ? Colors.amberAccent
                                : Colors.white),
                        child: Text('1H')),
                  ],
                ),
              ),
              Expanded(
                child:
                    BlocBuilder<OhclBloc, OhclState>(builder: (context, state) {
                  if (state is OhclUnitialized) {
                    return Center(
                      child: Text('Pilih Pair'),
                    );
                  }
                  if (state is OhclLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  OhclLoaded ohclLoaded = state as OhclLoaded;
                  return FutureBuilder(
                    future: ohclLoaded.ohcl,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<double> rsiValues =
                            calculateRSI(snapshot.data!, 14);
                        double latestRSI = rsiValues.last;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Candlesticks(
                                  candles: snapshot.data!.reversed
                                      .map((item) => Candle(
                                          date: DateTime
                                              .fromMillisecondsSinceEpoch(
                                                  (item.time!.toInt()) * 1000),
                                          high: item.high!,
                                          low: item.low!,
                                          open: item.open!,
                                          close: item.close!,
                                          volume: item.volume!))
                                      .toList()),
                            ),
                            Divider(),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: Row(
                                children: [
                                  Text('RSI Graph'),
                                  Spacer(),
                                  Text('RSI Value : ${latestRSI.toInt()}')
                                ],
                              ),
                            ),
                            Expanded(
                                child: LineChart(
                              LineChartData(
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: List.generate(
                                        rsiValues.length,
                                        (index) => FlSpot(index.toDouble(),
                                            rsiValues[index])),
                                    isCurved: true,
                                    color: Colors.blue,
                                    dotData: FlDotData(show: false),
                                  ),
                                ],
                                titlesData: FlTitlesData(
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    )),
                              ),
                            )),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child:
                                  Text('RSI<30 = OVERSOLD, RSI>70 = OVERBUY'),
                            )
                          ],
                        );
                      }
                      return Container();
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
