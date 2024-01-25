import 'package:auto_indo/bloc/jaring_bloc.dart';
import 'package:auto_indo/bloc/pair_bloc.dart';
import 'package:auto_indo/constants.dart';
import 'package:auto_indo/model/pair.dart';
import 'package:auto_indo/model/ticker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';

class TambahJaring extends StatefulWidget {
  const TambahJaring({super.key});

  @override
  State<TambahJaring> createState() => _TambahJaringState();
}

class _TambahJaringState extends State<TambahJaring> {
  String idKoin = '';
  String harga = '';

  TextEditingController hargaController = TextEditingController();
  TextEditingController modalController = TextEditingController();
  TextEditingController buyController = TextEditingController();
  TextEditingController sellController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Center(
              child: Text(
                'Tambah Jaring Baru',
                style: TextStyle(
                    color: textBold, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                BlocBuilder<PairBloc, PairState>(builder: (context, state) {
                  if (state is PairLoading) {
                    return const CircularProgressIndicator();
                  } else {
                    PairLoaded pairLoaded = state as PairLoaded;
                    return FutureBuilder<List<Pair>>(
                      future: pairLoaded.pair,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          //idKoin = snapshot.data!.first.koinId!;
                          return Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                        icon: const Icon(LineIcons.angleDown),
                                        isExpanded: true,
                                        value: idKoin == ''
                                            ? snapshot.data!.first.koinId!
                                            : idKoin,
                                        items: snapshot.data!.map((item) {
                                          return DropdownMenuItem(
                                            value: item.koinId,
                                            child: Text(item.name!),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          Future<Ticker> tik;
                                          tik =
                                              Ticker.getTicker(koinId: value!);
                                          tik.then(
                                            (value) {
                                              hargaController.text = value.last;
                                            },
                                          );
                                          setState(() {
                                            idKoin = value;
                                          });
                                        }),
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: TextField(
                                    enabled: false,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.all(8),
                                      border: InputBorder.none,
                                      hintText: 'Harga Terakhir',
                                    ),
                                    controller: hargaController,
                                  ),
                                )
                              ],
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    );
                  }
                }),
                // const SizedBox(
                //   width: 10,
                // ),
              ],
            ),
            const Divider(
              color: primaryColor,
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  isDense: true,
                  //contentPadding: EdgeInsets.all(10),
                  border:
                      UnderlineInputBorder(borderSide: BorderSide(width: 1)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 1, color: primaryColor)),
                  hintText: 'Modal',
                  hintStyle: TextStyle(color: textColor),
                  labelText: 'Modal',
                  labelStyle: TextStyle(color: primaryColor)),
              controller: modalController,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      isDense: true,
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(width: 1)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: primaryColor)),
                      hintText: 'Buy',
                      labelText: 'Buy',
                      labelStyle: TextStyle(color: primaryColor),
                    ),
                    controller: buyController,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      isDense: true,
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(width: 1)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: primaryColor)),
                      hintText: 'Sell',
                      labelText: 'Sell',
                      labelStyle: TextStyle(color: primaryColor),
                    ),
                    controller: sellController,
                  ),
                )
              ],
            ),

            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                    child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: textBold,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Batal'),
                )),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                    child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (modalController.text.isNotEmpty &&
                        sellController.text.isNotEmpty &&
                        buyController.text.isNotEmpty) {
                      JaringBloc jaringBloc =
                          BlocProvider.of<JaringBloc>(context);
                      jaringBloc.add(JaringAdd(
                          koinId: idKoin,
                          modal: modalController.text,
                          sell: sellController.text,
                          buy: buyController.text,
                          status: 'pending'));
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Simpan'),
                )),
              ],
            )
            // BlocBuilder<PairBloc, PairState>(builder: (context, state) {}),
          ],
        ),
      ),
    );
  }
}
