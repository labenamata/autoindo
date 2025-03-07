import 'package:auto_indo/page/register_page.dart';
import 'package:auto_indo/service/auth_service.dart';
import 'package:auto_indo/utama.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final AuthService _authService = AuthService();

  Future<bool> _loginUser() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      final token = await _authService.loginUser(email, password);

      if (token != null) {
        await _authService.saveToken(token);
        return true;
        // Navigate to MainPage without using context in async
      }
    }
    return false;
  }

  void checkLoginStatus() async {
    String? token = await _authService.getToken();
    if (token != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.loaderOverlay.hide();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Utama(),
          ),
        );
      });
    }
  }

  void checkAddress() async {
    String? address = await _authService.getAddress();
    if (address != null) {
      setState(() {
        _addressController.text = address;
      });
      checkLoginStatus();
    }
  }

  // Future<bool> _saveAddress() async {
  //   if (_addressController.text.isNotEmpty) {
  //     await _authService.saveAddress(_addressController.text);

  //     return true;
  //   }
  //   return false;
  // }

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        //backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,

        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: LayoutBuilder(builder: (context, constraints) {
            double lebar = double.infinity;

            if (constraints.maxWidth > 600) {
              lebar = 500;
            }

            return Center(
              child: SizedBox(
                width: lebar,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    const Spacer(),
                    Text(
                      'Login',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'You must login into your account to continue',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildTextField(
                              'E-Mail', Icons.email, _emailController),
                          const SizedBox(height: 16),
                          _buildTextField(
                              'Password', Icons.lock, _passwordController,
                              obscureText: true),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          FocusScope.of(context).unfocus();
                          context.loaderOverlay.show();
                          final logins = await _loginUser();
                          if (logins) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              context.loaderOverlay.hide();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Utama(),
                                ),
                              );
                            });
                          } else {
                            Fluttertoast.showToast(msg: 'Login Failed');

                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              context.loaderOverlay.hide();
                              //Fluttertoast.showToast(msg: 'Login Failed');
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Text('Login'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('or'),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return RegisterPage();
                        }));
                      },
                      child: const Text(
                        'Not Registered? Register',
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    const Spacer()
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String hint, IconData icon, TextEditingController controller,
      {bool obscureText = false}) {
    return TextFormField(
      obscureText: obscureText,
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
