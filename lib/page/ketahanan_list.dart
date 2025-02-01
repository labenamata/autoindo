import 'package:auto_indo/bloc/jaring_bloc.dart';
import 'package:auto_indo/model/jaring.dart';
import 'package:auto_indo/model/ketahanan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class KetahananList extends StatefulWidget {
  const KetahananList(
      {super.key, required this.ketahanan, required this.currency});
  final Ketahanan ketahanan;
  final String currency;

  @override
  State<KetahananList> createState() => _KetahananListState();
}

class _KetahananListState extends State<KetahananList> {
  List<Jaring> jaringList = [];
  var f = NumberFormat("#,###", "en_US");
  double totalModal = 0;
  void _makeJaring() {
    double buy = 0;
    double sell = 0;
    double modal = double.parse(widget.ketahanan.modal!);

    for (var i = 0; i < int.parse(widget.ketahanan.ketahanan!); i++) {
      if (widget.ketahanan.mode == 'Piramid') {
        modal =
            modal + modal * double.parse(widget.ketahanan.kenaikan!) / 100 * i;
      }
      totalModal = modal + totalModal;
      buy = double.parse(widget.ketahanan.indikator!) -
          double.parse(widget.ketahanan.indikator!) *
              (double.parse(widget.ketahanan.selisih!) / 100 * (i + 1));
      sell = buy + buy * double.parse(widget.ketahanan.margin!) / 100;
      Jaring jarings = Jaring(
          buy: widget.currency == 'IDR'
              ? buy.toInt().toString()
              : buy.toString(),
          sell: widget.currency == 'IDR'
              ? sell.toInt().toString()
              : sell.toString(),
          modal: widget.currency == 'IDR'
              ? modal.toInt().toString()
              : modal.toString(),
          koinId: widget.ketahanan.koinId);

      jaringList.add(jarings);
    }
  }

  @override
  void initState() {
    super.initState();
    _makeJaring();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ketahanan List'),
        backgroundColor: Colors.amber,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('Currency'),
                        const Spacer(),
                        Text(widget.currency)
                      ],
                    ),
                    Row(
                      children: [
                        Text('Koin'),
                        const Spacer(),
                        Text(widget.ketahanan.koinId!)
                      ],
                    ),
                    Row(
                      children: [
                        Text('indikator'),
                        const Spacer(),
                        Text(widget.currency == 'IDR'
                            ? f.format(int.parse(widget.ketahanan.indikator!))
                            : widget.ketahanan.indikator!)
                      ],
                    ),
                    Row(
                      children: [
                        Text('Ketahanan'),
                        const Spacer(),
                        Text(widget.ketahanan.ketahanan!)
                      ],
                    ),
                    Row(
                      children: [
                        Text('Selisih'),
                        const Spacer(),
                        Text('${widget.ketahanan.selisih!} %')
                      ],
                    ),
                    Row(
                      children: [
                        Text('Margin'),
                        const Spacer(),
                        Text('${widget.ketahanan.margin!} %')
                      ],
                    ),
                    Row(
                      children: [
                        Text('Modal'),
                        const Spacer(),
                        Text(widget.currency == 'IDR'
                            ? f.format(int.parse(widget.ketahanan.modal!))
                            : widget.ketahanan.modal!)
                      ],
                    ),
                    Row(
                      children: [
                        Text('Mode'),
                        const Spacer(),
                        Text(widget.ketahanan.mode!)
                      ],
                    ),
                    Row(
                      children: [
                        Text('Kenaikan'),
                        const Spacer(),
                        Text('${widget.ketahanan.kenaikan!} %')
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: jaringList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text('Modal'),
                                Spacer(),
                                Text(widget.currency == 'IDR'
                                    ? f.format(
                                        int.parse(jaringList[index].modal!))
                                    : jaringList[index].modal!)
                              ],
                            ),
                            Row(
                              children: [
                                Text('Buy'),
                                Spacer(),
                                Text(widget.currency == 'IDR'
                                    ? f.format(
                                        int.parse(jaringList[index].buy!))
                                    : jaringList[index].buy!)
                              ],
                            ),
                            Row(
                              children: [
                                Text('Sell'),
                                Spacer(),
                                Text(widget.currency == 'IDR'
                                    ? f.format(
                                        int.parse(jaringList[index].sell!))
                                    : jaringList[index].sell!)
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            ),
            SizedBox(
              height: 80,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Center(
                    child: Row(
                      children: [
                        Text(
                            'Total Modal : ${widget.currency == 'IDR' ? f.format(totalModal) : totalModal}'),
                        const Spacer(),
                        TextButton(
                          style: TextButton.styleFrom(
                            maximumSize: const Size(90, 50),
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(6), // Set radius here
                            ),
                          ),
                          onPressed: () {
                            JaringBloc jaringBloc =
                                BlocProvider.of<JaringBloc>(context);
                            jaringBloc.add(JaringBatch(data: jaringList));
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                          },
                          child: Text('Simpan'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
