import 'package:auto_indo/model/keys.dart';
import 'package:auto_indo/service/auth_service.dart';
import 'package:auto_indo/utama.dart';
import 'package:flutter/material.dart';

class SetKeys extends StatefulWidget {
  const SetKeys({super.key});

  @override
  State<SetKeys> createState() => _SetKeysState();
}

class _SetKeysState extends State<SetKeys> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _keyController = TextEditingController();
  final TextEditingController _secretController = TextEditingController();

  void _saveKeys() async {
    if (_formKey.currentState!.validate()) {
      String key = _keyController.text.trim();
      String secret = _secretController.text.trim();

      final saved = await Keys.updateKeys(key, secret);

      if (saved) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Utama(),
            ),
          );
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Registration failed')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setting Key dan Secret'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
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
                controller: _secretController,
                decoration: InputDecoration(
                  labelText: 'secret',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                obscureText: true,
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
  }
}
