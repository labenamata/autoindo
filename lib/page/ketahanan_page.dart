import 'package:auto_indo/bloc/pair_bloc.dart';
import 'package:auto_indo/model/ketahanan.dart';
import 'package:auto_indo/model/pair.dart';
import 'package:auto_indo/model/ticker.dart';
import 'package:auto_indo/page/ketahanan_list.dart';
import 'package:dropdown_search/dropdown_search.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InputFormPage extends StatefulWidget {
  const InputFormPage({super.key});

  @override
  State<InputFormPage> createState() => _InputFormPageState();
}

class _InputFormPageState extends State<InputFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _ketahananController = TextEditingController();
  final TextEditingController _selisihController = TextEditingController();
  final TextEditingController _marginController = TextEditingController();
  final TextEditingController _indikatorController = TextEditingController();
  final TextEditingController _modalController = TextEditingController();
  final TextEditingController _kenaikanController = TextEditingController();

  String _selectedCurrency = 'IDR';
  String _selectedKoin = '';
  Pair? selectedItem;
  String _selectedMode = 'Rata';
  bool _isEnabled = false;

  @override
  void dispose() {
    _ketahananController.dispose();
    _selisihController.dispose();
    _marginController.dispose();
    _indikatorController.dispose();
    _modalController.dispose();
    super.dispose();
  }

  static Future<List<Pair>> filterPair(String currency, String name) async {
    return Pair.filterPair(currency: currency, name: name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('Ketahanan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: LayoutBuilder(builder: (context, constraints) {
            double lebar = double.infinity;
            MainAxisAlignment alignment = MainAxisAlignment.start;

            if (constraints.maxWidth > 600) {
              lebar = 500;
              alignment = MainAxisAlignment.center;
            }
            if (constraints.maxWidth > 600) {
              lebar = 500;
            }
            return Center(
              child: SizedBox(
                width: lebar,
                child: Column(
                  mainAxisAlignment: alignment,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedCurrency,
                            decoration: InputDecoration(
                              labelText: 'Currency',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            items: ['IDR', 'USDT']
                                .map((currency) => DropdownMenuItem(
                                      value: currency,
                                      child: Text(currency),
                                    ))
                                .toList(),
                            onChanged: (value) async {
                              setState(() {
                                PairBloc pairBloc =
                                    BlocProvider.of<PairBloc>(context);
                                pairBloc.add(PairGet(current: value!));

                                setState(() {
                                  selectedItem = Pair(
                                    name: '',
                                  );
                                  _selectedCurrency = value;
                                  _indikatorController.text = '';
                                  _selisihController.text = '';
                                  _marginController.text = '';
                                  _modalController.text = '';
                                  _kenaikanController.text = '';
                                });
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: DropdownSearch<Pair>(
                            onChanged: (item) {
                              Future<Ticker> tik;
                              tik = Ticker.getTicker(koinId: item!.koinId!);
                              tik.then(
                                (value) {
                                  _indikatorController.text = value.last;
                                },
                              );
                              setState(() {
                                _selectedKoin = item.ticker!;
                              });
                            },
                            selectedItem: selectedItem,
                            items: (f, cs) => filterPair(_selectedCurrency, f),
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
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ListTile(
                                        leading: Image(
                                            image: NetworkImage(item.image!)),
                                        selected: isSelected,
                                        title: Text(item.name!),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                        // Expanded(
                        //   child: DropdownButtonFormField<String>(
                        //     value: _selectedKoin,
                        //     decoration: InputDecoration(
                        //       labelText: 'Koin',
                        //       border: OutlineInputBorder(
                        //         borderRadius: BorderRadius.circular(8),
                        //       ),
                        //     ),
                        //     items: _koinList
                        //         .map((koin) => DropdownMenuItem(
                        //               value: koin,
                        //               child: Text(koin),
                        //             ))
                        //         .toList(),
                        //     onChanged: (value) {
                        //       setState(() {
                        //         _selectedKoin = value!;
                        //       });
                        //     },
                        //   ),
                        // ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _ketahananController,
                            decoration: InputDecoration(
                              labelText: 'Ketahanan',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  int.tryParse(value) == null) {
                                return 'Please enter a valid integer value';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _selisihController,
                            decoration: InputDecoration(
                              labelText: 'Selisih',
                              prefixText: '%',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  double.tryParse(value) == null) {
                                return 'Please enter a valid number';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _marginController,
                            decoration: InputDecoration(
                              labelText: 'Margin',
                              prefixText: '%',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  double.tryParse(value) == null) {
                                return 'Please enter a valid number';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _indikatorController,
                      decoration: InputDecoration(
                        labelText: 'Indikator',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _modalController,
                      decoration: InputDecoration(
                        labelText: 'Modal',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedMode,
                            decoration: InputDecoration(
                              labelText: 'Mode',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            items: ['Rata', 'Piramid']
                                .map((mode) => DropdownMenuItem(
                                      value: mode,
                                      child: Text(mode),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _isEnabled = value == 'Rata' ? false : true;
                                _selectedMode = value!;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            enabled: _isEnabled,
                            controller: _kenaikanController,
                            decoration: InputDecoration(
                              labelText: 'Kenaikan',
                              prefixText: '%',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            validator: (value) {
                              if (_selectedMode == 'Piramid') {
                                if (value == null ||
                                    value.isEmpty ||
                                    double.tryParse(value) == null) {
                                  return 'Please enter a valid number';
                                }
                              }

                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
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
                            if (_formKey.currentState!.validate()) {
                              Ketahanan record = Ketahanan(
                                  koinId: _selectedKoin,
                                  ketahanan: _ketahananController.text,
                                  selisih: _selisihController.text,
                                  margin: _marginController.text,
                                  indikator: _indikatorController.text,
                                  modal: _modalController.text,
                                  mode: _selectedMode,
                                  kenaikan: _kenaikanController.text);
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return KetahananList(
                                  ketahanan: record,
                                  currency: _selectedCurrency,
                                );
                              }));
                              // Process form data
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   SnackBar(content: Text('Data Saved Successfully')),
                              // );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text('Konfirmasi'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
