import 'package:auto_indo/bloc/jaring_bloc.dart';
import 'package:auto_indo/bloc/pair_bloc.dart';
import 'package:auto_indo/model/pair.dart';
import 'package:auto_indo/model/ticker.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JaringSatuan extends StatefulWidget {
  const JaringSatuan({super.key});

  @override
  State<JaringSatuan> createState() => _JaringSatuanState();
}

class _JaringSatuanState extends State<JaringSatuan> {
  final List<String> currencies = ['IDR', 'USDT'];
  final List<String> koinList = ['BTC', 'TEN'];
  String? selectedCurrency = 'IDR';
  String? selectedKoin = '';
  Pair? selectedItem;
  final TextEditingController modalController = TextEditingController();
  final TextEditingController buyController = TextEditingController();
  final TextEditingController sellController = TextEditingController();
  final TextEditingController hargaController = TextEditingController();
  final _dropdownSearchKey = GlobalKey<DropdownSearchState<String>>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('Tambah Jaring'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Currency Dropdown
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Currency',
                border: OutlineInputBorder(),
              ),
              value: selectedCurrency,
              onChanged: (value) {
                PairBloc pairBloc = BlocProvider.of<PairBloc>(context);
                pairBloc.add(PairGet(current: value!));
                _dropdownSearchKey.currentState?.clear();
                setState(() {
                  selectedItem = Pair(
                    name: '',
                  );
                  selectedCurrency = value;
                  hargaController.text = '';
                });
              },
              items: currencies.map((currency) {
                return DropdownMenuItem(
                  value: currency,
                  child: Text(currency),
                );
              }).toList(),
            ),
            SizedBox(height: 16),

            // Koin Dropdown
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child:
                        //idKoin = snapshot.data!.first.koinId!;
                        DropdownSearch<Pair>(
                      key: _dropdownSearchKey,
                      onChanged: (item) {
                        Future<Ticker> tik;
                        tik = Ticker.getTicker(koinId: item!.koinId!);
                        tik.then(
                          (value) {
                            hargaController.text = value.last;
                          },
                        );
                        setState(() {
                          selectedKoin = item.ticker;
                        });
                      },
                      selectedItem: selectedItem,
                      items: (f, cs) =>
                          Pair.filterPair(currency: selectedCurrency!, name: f),
                      compareFn: (item, selectedItem) =>
                          item.koinId == selectedItem.koinId,
                      dropdownBuilder: (context, selectedItem) {
                        if (selectedItem == null) {
                          return SizedBox.shrink();
                        }
                        return DropdownMenuItem(
                          value: selectedItem.ticker,
                          child: Text(selectedItem.name!),
                        );
                        // return Text(selectedItem.name!);
                      },
                      popupProps: PopupProps.modalBottomSheet(
                        modalBottomSheetProps: ModalBottomSheetProps(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8))),

                        disableFilter:
                            true, //data will be filtered by the backend
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps(
                            decoration: InputDecoration(
                          labelText: 'Cari',
                          border: OutlineInputBorder(),
                        )),
                        itemBuilder: (ctx, item, isDisabled, isSelected) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  leading:
                                      Image(image: NetworkImage(item.image!)),
                                  selected: isSelected,
                                  title: Text(item.name!),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )),
                SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    enabled: false,
                    controller: hargaController,
                    decoration: InputDecoration(
                      labelText: 'Harga',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Modal Field
            TextField(
              controller: modalController,
              decoration: InputDecoration(
                labelText: 'Modal',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),

            // Buy and Sell Fields
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: buyController,
                    decoration: InputDecoration(
                      labelText: 'Buy',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: sellController,
                    decoration: InputDecoration(
                      labelText: 'Sell',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            SizedBox(height: 32),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle Batal action
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Batal'),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    if (modalController.text.isNotEmpty &&
                        sellController.text.isNotEmpty &&
                        buyController.text.isNotEmpty) {
                      JaringBloc jaringBloc =
                          BlocProvider.of<JaringBloc>(context);
                      jaringBloc.add(JaringAdd(
                          koinId: selectedKoin!,
                          modal: modalController.text,
                          sell: sellController.text,
                          buy: buyController.text,
                          status: 'pending'));
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Simpan'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
