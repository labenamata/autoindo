import 'package:auto_indo/model/keys.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SetKeys extends StatefulWidget {
  const SetKeys({super.key});

  @override
  State<SetKeys> createState() => _SetKeysState();
}

class _SetKeysState extends State<SetKeys> {
  late final Keys? kunci;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _keyController = TextEditingController();
  final TextEditingController _secretController = TextEditingController();

  void _getKey() async {
    Keys? kuncis = await Keys.getKeys();
    _keyController.text = kuncis?.key ?? '';
    _secretController.text = kuncis?.secret ?? '';

    setState(() {
      kunci = kuncis;
    });
  }

  @override
  void initState() {
    super.initState();
    _getKey();
  }

  void _saveKeys() async {
    if (_formKey.currentState!.validate()) {
      String key = _keyController.text.trim();
      String secret = _secretController.text.trim();

      final saved = await Keys.updateKeys(key, secret);

      if (saved) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        });
      } else {
        Fluttertoast.showToast(msg: 'Registration failed');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('Setting Key dan Secret'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(builder: (context, constraints) {
          double lebar = double.infinity;
          MainAxisAlignment alignment = MainAxisAlignment.start;

          if (constraints.maxWidth > 600) {
            lebar = 500;
            alignment = MainAxisAlignment.center;
          }

          return Center(
            child: SizedBox(
              width: lebar,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: alignment,
                  children: [
                    TextFormField(
                      maxLines: 2,
                      controller: _keyController,
                      decoration: InputDecoration(
                        labelText: 'key',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your key';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      maxLines: 5,
                      controller: _secretController,
                      decoration: InputDecoration(
                        labelText: 'secret',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your secret';
                        } else if (value.length < 6) {
                          return 'secret must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _saveKeys,
                      child: Text('Simpan'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
