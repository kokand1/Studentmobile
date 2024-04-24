import 'dart:convert';
import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:student_app/asosiy.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); //oxiri qo'shilga widget
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: FutureBuilder<bool>(
      future: checkLoginCredentials(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While waiting for the future to complete, show a loading indicator
          return CircularProgressIndicator();
        } else {
          // Once the future completes, decide whether to navigate to login or main screen
          if (snapshot.data == true) {
            return Asosiy(); // Navigate to main screen
          } else {
            return Login(); // Navigate to login screen
          }
        }
      },
    ),
  ));
}

Future<bool> checkLoginCredentials() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? username = prefs.getString('username');
  String? password = prefs.getString('password');
  return (username != null && password != null);
}

List<Map<String, dynamic>> data = [];

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //saqlab qolish login parol
  late SharedPreferences _prefsSaqla;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool remember = false; //saqlash uchun
  bool _isLoading = false; //kutidh uchun
  bool kurish = false; //input pasword

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    _prefsSaqla = await SharedPreferences.getInstance();
    _loadSavedData();
  }

  void _loadSavedData() {
    final savedUsername = _prefsSaqla.getString("username");
    final savedPassword = _prefsSaqla.getString("password");
    if (savedUsername != null && savedPassword != null) {
      _usernameController.text = savedUsername;
      _passwordController.text = savedPassword;
      setState(() {
        remember = true;
      });

      // Login uchun kerakli funksiya
      // login(savedUsername);
    }
  }

  void _saveCredentials() {
    if (remember) {
      _prefsSaqla.setString('username', _usernameController.text);
      _prefsSaqla.setString('password', _passwordController.text);
    } else {
      _prefsSaqla.remove('username');
      _prefsSaqla.remove('password');
    }
  }

  //login parol saqlab qolish tugadi

  dynamic nomid = "";
  late String parol = '';
  late String user = '';
  late String name = '';
  late String fulname = '';

  Future<void> login(String user) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        // shu urldan olingan student https://dash.vips.uz/a/2/3/159
        Uri.parse('https://dash.vips.uz/api/2/3/159?status=1&username=$user'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);

        for (var item in jsonData) {
          data.add(Map<String, dynamic>.from(item));
          parol = (item["password"]);
          name = (item["username"]);
          await SessionManager().set('nomid', (item["id"]));
          nomid = await SessionManager().get("nomid");
        }

        user = _usernameController.text;
        final bool correctPassword = parol.isNotEmpty &&
            await BCrypt.checkpw(_passwordController.text, parol);

        if (correctPassword) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Asosiy()),
          );
        } else {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Username or password error"),
              backgroundColor: Color.fromARGB(255, 21, 187, 2),
            ),
          );
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        throw Exception('API\'den veri yüklenemedi');
      }
    } catch (e) {
      print("Hata: $e");
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Internetga ulanganinggizni tekshiring",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Color.fromARGB(255, 253, 2, 2),
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 40,
          title: Text('Bato Student'),
          backgroundColor: Color.fromARGB(255, 21, 187, 2),
          centerTitle: true,
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 21, 187, 2),
                      borderRadius:
                          BorderRadius.only(bottomRight: Radius.circular(75))),
                  width: double.infinity,
                  height: 160,
                  child: Lottie.asset('asset/bato-logo.json'),
                ),
                Container(
                  color: const Color.fromARGB(255, 21, 187, 2),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.only(topLeft: Radius.circular(75))),
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                labelText: 'Username',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Burchaklarni o'zgartiring
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your username';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16.0),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: !kurish,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      kurish = !kurish;
                                    });
                                  },
                                  icon: Icon(
                                    kurish
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                ),
                                labelText: 'Password',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Burchaklarni o'zgartiring
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16.0),
                            Row(
                              children: [
                                Checkbox(
                                  mouseCursor:
                                      MaterialStateMouseCursor.clickable,
                                  value: remember,
                                  onChanged: (value) {
                                    setState(() {
                                      remember = value!;
                                    });
                                  },
                                  fillColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.selected)) {
                                        return Color.fromARGB(
                                            255, 21, 187, 2); // Tanlandi
                                      }
                                      return Colors.white; // Tanlanmagan
                                    },
                                  ),
                                ),
                                Text('Remember me'),
                              ],
                            ),
                            Container(
                                height: 40,
                                child: Center(
                                  child: _isLoading
                                      ? CircularProgressIndicator()
                                      : Text(""),
                                )),
                            SizedBox(height: 12.0),
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _saveCredentials();
                                  login(_usernameController.text);
                                }
                              },
                              child: Text("Login"),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              height: 50,
                              child: Row(
                                children: [
                                  Text("Parolni unuttinggizmi"),
                                  InkWell(
                                      onTap: () {
                                        launch("https://bato.uz");
                                      },
                                      child: Text(
                                        " BATO ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(
                                                255, 171, 87, 240)),
                                      )),
                                  Text("ga murojat qiling")
                                ],
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: 50,
                              child:
                                  Text("Bu ilova faqat Bato studentlari uchun"),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  width: double.infinity,
                ),
                Container(
                    width: double.infinity, height: 4, color: Colors.white)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
