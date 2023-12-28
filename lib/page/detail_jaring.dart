import 'package:auto_indo/bloc/jaring_bloc.dart';
import 'package:auto_indo/komponen/svgicon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DetailJaring extends StatelessWidget {
  final String id;
  final String koinId;
  final String name;
  final String modal;
  final String buy;
  final String sell;
  final String status;
  final String image;

  const DetailJaring(
      {super.key,
      required this.id,
      required this.koinId,
      required this.name,
      required this.modal,
      required this.buy,
      required this.sell,
      required this.status,
      required this.image});

  @override
  Widget build(BuildContext context) {
    var f = NumberFormat("#,###.0#", "en_US");
    return Dialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  svgicon(url: image),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(name)
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [const Text('Id'), Text(id)],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [const Text('Koin Id'), Text(koinId)],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Modal'),
                  Text(f.format(double.parse(modal)))
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [const Text('Buy'), Text(buy)],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [const Text('Sell'), Text(sell)],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [const Text('Status'), Text(status)],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.red[900],
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        JaringBloc jaringBloc =
                            BlocProvider.of<JaringBloc>(context);
                        jaringBloc.add(JaringHapus(id));
                        Navigator.pop(context);
                      },
                      child: const Text('Hapus'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
