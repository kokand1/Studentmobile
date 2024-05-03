//main class
// import 'dart:convert';
// import 'package:bcrypt/bcrypt.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:student_app/asosiy.dart';
// import 'package:flutter_session_manager/flutter_session_manager.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:lottie/lottie.dart';

// void main() {
//   runApp(MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: FutureBuilder<bool>(
//       future: checkLoginCredentials(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           // While waiting for the future to complete, show a loading indicator
//           return CircularProgressIndicator();
//         } else {
//           // Once the future completes, decide whether to navigate to login or main screen
//           if (snapshot.data == true) {
//             return Asosiy(); // Navigate to main screen
//           } else {
//             return Login(); // Navigate to login screen
//           }
//         }
//       },
//     ),
//   ));
// }

// Future<bool> checkLoginCredentials() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String? username = prefs.getString('username');
//   String? password = prefs.getString('password');
//   return (username != null && password != null);
// }

// class Login extends StatefulWidget {
//   const Login({Key? key}) : super(key: key);

//   @override
//   State<Login> createState() => _LoginState();
// }

// class _LoginState extends State<Login> {
//   //saqlab qolish login parol
//   late SharedPreferences _prefsSaqla;
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   bool remember = false; //saqlash uchun
//   bool _isLoading = false; //kutidh uchun

//   @override
//   void initState() {
//     super.initState();
//     _loadPreferences();
//   }

//   Future<void> _loadPreferences() async {
//     _prefsSaqla = await SharedPreferences.getInstance();
//     _loadSavedData();
//   }

//   void _loadSavedData() {
//     final savedUsername = _prefsSaqla.getString("username");
//     final savedPassword = _prefsSaqla.getString("password");
//     if (savedUsername != null && savedPassword != null) {
//       _usernameController.text = savedUsername;
//       _passwordController.text = savedPassword;
//       setState(() {
//         remember = true;
//       });

//       // Login uchun kerakli funksiya
//       // login(savedUsername);
//     }
//   }

//   void _saveCredentials() {
//     if (remember) {
//       _prefsSaqla.setString('username', _usernameController.text);
//       _prefsSaqla.setString('password', _passwordController.text);
//     } else {
//       _prefsSaqla.remove('username');
//       _prefsSaqla.remove('password');
//     }
//   }

//   //login parol saqlab qolish tugadi
//   List<Map<String, dynamic>> data = [];
//   dynamic nomid = "";
//   late String parol = '';
//   late String user = '';
//   late String name = '';
//   late String fulname = '';

//   Future<void> login(String user) async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final response = await http.get(
//         Uri.parse(
//             'https://dash.vips.uz/api/2/3/159?status=1&username=$user'),
//       );

//       if (response.statusCode == 200) {
//         final List<dynamic> jsonData = jsonDecode(response.body);

//         for (var item in jsonData) {
//           data.add(Map<String, dynamic>.from(item));
//           parol = (item["password"]);
//           name = (item["username"]);
//           await SessionManager().set('nomid', (item["id"]));
//           nomid = await SessionManager().get("nomid");
//         }

//         user = _usernameController.text;
//         final bool correctPassword = parol.isNotEmpty &&
//             await BCrypt.checkpw(_passwordController.text, parol);

//         if (correctPassword) {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => const Asosiy()),
//           );
//         } else {
//           setState(() {
//             _isLoading = false;
//           });
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text("Username or password error"),
//               backgroundColor: Color.fromARGB(255, 21, 187, 2),
//             ),
//           );
//         }
//       } else {
//         setState(() {
//           _isLoading = false;
//         });
//         throw Exception('API\'den veri yüklenemedi');
//       }
//     } catch (e) {
//       print("Hata: $e");
//       setState(() {
//         _isLoading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Bağlantı hatası")),
//       );
//     }

//     setState(() {
//       _isLoading = false;
//     });
//   }

//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           toolbarHeight: 40,
//           title: Text('Bato Student'),
//           backgroundColor: Color.fromARGB(255, 21, 187, 2),
//           centerTitle: true,
//         ),
//         body: Container(
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                       color: Color.fromARGB(255, 21, 187, 2),
//                       borderRadius:
//                           BorderRadius.only(bottomRight: Radius.circular(75))),
//                   width: double.infinity,
//                   height: 160,
//                   child: Lottie.asset('asset/bato-logo.json'),
//                 ),
//                 Container(
//                   color: Color.fromARGB(255, 21, 187, 2),
//                   child: Container(
//                     height: MediaQuery.of(context).size.height * 0.7,
//                     decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius:
//                             BorderRadius.only(topLeft: Radius.circular(75))),
//                     width: double.infinity,
//                     child: Padding(
//                       padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
//                       child: Form(
//                         key: _formKey,
//                         child: Column(
//                           children: [
//                             TextFormField(
//                               controller: _usernameController,
//                               decoration: InputDecoration(
//                                 labelText: 'Isername',
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(
//                                       10.0), // Burchaklarni o'zgartiring
//                                 ),
//                               ),
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter your username';
//                                 }
//                                 return null;
//                               },
//                             ),
//                             SizedBox(height: 16.0),
//                             TextFormField(
//                               controller: _passwordController,
//                               obscureText: true,
//                               decoration: InputDecoration(
//                                 labelText: 'Password',
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(
//                                       10.0), // Burchaklarni o'zgartiring
//                                 ),
//                               ),
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter your password';
//                                 }
//                                 return null;
//                               },
//                             ),
//                             SizedBox(height: 16.0),
//                             Row(
//                               children: [
//                                 Checkbox(
//                                   mouseCursor:
//                                       MaterialStateMouseCursor.clickable,
//                                   value: remember,
//                                   onChanged: (value) {
//                                     setState(() {
//                                       remember = value!;
//                                     });
//                                   },
//                                   fillColor:
//                                       MaterialStateProperty.resolveWith<Color>(
//                                     (Set<MaterialState> states) {
//                                       if (states.contains(MaterialState.selected)) {
//                                         return Color.fromARGB(
//                                             255, 21, 187, 2); // Tanlandi
//                                       }
//                                       return Colors.white; // Tanlanmagan
//                                     },
//                                   ),
//                                 ),
//                                 Text('Remember me'),
//                               ],
//                             ),
//                             Container(
//                                 height: 40,
//                                 child: Center(
//                                   child: _isLoading
//                                       ? CircularProgressIndicator()
//                                       : Text(""),
//                                 )),
//                             SizedBox(height: 12.0),
//                             ElevatedButton(
//                               onPressed: () {
//                                 if (_formKey.currentState!.validate()) {
//                                   _saveCredentials();
//                                   login(_usernameController.text);
//                                 }
//                               },
//                               child: Text("Login"),
//                             ),
//                             Container(
//                               margin: EdgeInsets.only(top: 10),
//                               height: 50,
//                               child: Row(
//                                 children: [
//                                   Text("Parolni unuttinggizmi"),
//                                   InkWell(
//                                       onTap: () {},
//                                       child: Text(
//                                         " BATO ",
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                             color: Color.fromARGB(
//                                                 255, 171, 87, 240)),
//                                       )),
//                                   Text("ga murojat qiling")
//                                 ],
//                               ),
//                             ),
//                             Container(
//                               width: double.infinity,
//                               height: 50,
//                               child: Text("Bu ilova faqat Bato studentlari uchun"),
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   width: double.infinity,
//                 ),
//                 Container(
//                     width: double.infinity, height: 4, color: Colors.white)
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

//asosiy class 
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_session_manager/flutter_session_manager.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:student_app/drawer.dart';
// import 'main.dart'; // Import the login class to use its methods

// class Asosiy extends StatefulWidget {
//   const Asosiy({super.key});

//   @override
//   State<Asosiy> createState() => _AsosiyState();
// }

// class _AsosiyState extends State<Asosiy> {
//   List<Map<String, dynamic>> data1 = [];
//   dynamic nom = "";
//   String fullname = "";
//   String birthdate = "";
//   String id = "";
//   Future<void> nomvoid() async {
//     nom = await SessionManager().get("nomid");
//     final response =
//         await http.get(Uri.parse('https://dash.vips.uz/api/2/3/159?id=$nom'));

//     if (response.statusCode == 200) {
//       final List<dynamic> listnom = jsonDecode(response.body);

//       for (var item in listnom) {
//         data1.add(Map<String, dynamic>.from(item));
//         fullname = item["fullname"];
//         birthdate = item["birthdate"];
//         id = item['id'];
//         print(fullname);
//       }
//     }
//   }

//   Future<void> clearLoginData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.remove('username');
//     await prefs.remove('password');
//   }

//   @override
//   void initState() {
//     super.initState();
//     nomvoid().then((_) {
//       // This block will be executed after nomvoid completes
//       print(birthdate);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//           IconButton(
//               onPressed: () async {
//                 await clearLoginData(); // Clear the saved login data
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => Login()),
//                 );
//               },
//               icon: Icon(Icons.logout))
//         ],
//       ),
//       body: Center(
//         child: FutureBuilder(
//           future: nomvoid(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return CircularProgressIndicator(); // Show a loading indicator while fetching data
//             } else if (snapshot.hasError) {
//               return Text("Error fetching data");
//             } else {
//               return Column(
//                 children: [
//                   Text(fullname),
//                   Text(birthdate),
//                   Text(id),
//                 ],
//               );
//             }
//           },
//         ),
//       ),
//       drawer: DrawerList(),
//     );
//   }
// }
//asosiy
// import 'dart:convert';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_session_manager/flutter_session_manager.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:student_app/drawer.dart';
// import 'main.dart'; // Import the login class to use its methods

// List<Map<String, dynamic>> data1 = [];

// class Asosiy extends StatefulWidget {
//   const Asosiy({super.key});

//   @override
//   State<Asosiy> createState() => _AsosiyState();
// }

// class _AsosiyState extends State<Asosiy> {
//   List lnom = [
//     oddiyclas(
//         rasm:
//             "https://img.freepik.com/free-photo/happy-young-female-student-holding-notebooks-from-courses-smiling-camera-standing-spring-clothes-against-blue-background_1258-70161.jpg?size=626&ext=jpg&ga=GA1.1.553209589.1714089600&semt=sph",
//         tuliqIsm: "Nodirova Nargiz",
//         manzil: "Shaldiramoq 1",
//         tel: "90 222-22-22",
//         yosh: "18"), oddiyclas(
//         rasm:
//             "https://t4.ftcdn.net/jpg/04/24/15/27/360_F_424152729_5jNBK6XVjsoWvTtGEljfSCOWv4Taqivl.jpg",
//         tuliqIsm: "Nodirova Nargiz",
//         manzil: "Shaldiramoq 1",
//         tel: "90 222-22-22",
//         yosh: "18"), oddiyclas(
//         rasm:
//             "https://img.freepik.com/free-photo/happy-young-female-student-holding-notebooks-from-courses-smiling-camera-standing-spring-clothes-against-blue-background_1258-70161.jpg?size=626&ext=jpg&ga=GA1.1.553209589.1714089600&semt=sph",
//         tuliqIsm: "Nodirova Nargiz",
//         manzil: "Shaldiramoq 1",
//         tel: "90 222-22-22",
//         yosh: "18"), oddiyclas(
//         rasm:
//             "https://img.freepik.com/free-photo/happy-young-female-student-holding-notebooks-from-courses-smiling-camera-standing-spring-clothes-against-blue-background_1258-70161.jpg?size=626&ext=jpg&ga=GA1.1.553209589.1714089600&semt=sph",
//         tuliqIsm: "Nodirova Nargiz",
//         manzil: "Shaldiramoq 1",
//         tel: "90 222-22-22",
//         yosh: "18"),
//          oddiyclas(
//         rasm:
//             "https://img.freepik.com/free-photo/happy-young-female-student-holding-notebooks-from-courses-smiling-camera-standing-spring-clothes-against-blue-background_1258-70161.jpg?size=626&ext=jpg&ga=GA1.1.553209589.1714089600&semt=sph",
//         tuliqIsm: "Nodirova Nargiz",
//         manzil: "Shaldiramoq 1",
//         tel: "90 222-22-22",
//         yosh: "18"),
//          oddiyclas(
//         rasm:
//             "https://img.freepik.com/free-photo/happy-young-female-student-holding-notebooks-from-courses-smiling-camera-standing-spring-clothes-against-blue-background_1258-70161.jpg?size=626&ext=jpg&ga=GA1.1.553209589.1714089600&semt=sph",
//         tuliqIsm: "Nodirova Nargiz",
//         manzil: "Shaldiramoq 1",
//         tel: "90 222-22-22",
//         yosh: "18")
//   ];
//   Widget template(a) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Color.fromARGB(255, 21, 187, 2),
//           borderRadius: BorderRadius.all(
//             Radius.circular(15),
//           ),
//          ),
//       child: Column(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               image: DecorationImage(image: NetworkImage(a.rasm),fit: BoxFit.cover),
               
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
//             height: 120,
//             width: double.infinity,

//           ),
//           Container(
           
//             width: 200,
//             height: 100,
//             child: Column(
//               children: [
//                 Text(a.tuliqIsm),
//                 Text(a.yosh),
//                 Text(a.manzil),
//                 Text(a.tel),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   dynamic nom = "";
//   String fullname = "";
//   String birthdate = "";
//   String rasm = "";
//   String id = "";

//   Future<void> nomvoid() async {
//     nom = await SessionManager().get("nomid");
//     final response =
//         await http.get(Uri.parse('https://dash.vips.uz/api/2/3/159?id=$nom'));

//     if (response.statusCode == 200) {
//       final List<dynamic> responsdata = jsonDecode(response.body);

//       for (var item in responsdata) {
//         data1.add(Map<String, dynamic>.from(item));
//         fullname = item["fullname"];
//         birthdate = item["birthdate"];
//         rasm = item["photo"];
//         id = item['id'];
        
//       }
//     }
//   }

//   Future<void> clearLoginData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.remove('username');
//     await prefs.remove('password');
//   }

//   @override
//   void initState() {
//     super.initState();
//     nomvoid().then((_) {
//       // This block will be executed after nomvoid completes
//       print(birthdate);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//           IconButton(
//               onPressed: () async {
//                 await clearLoginData(); // Clear the saved login data
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => Login()),
//                 );
//               },
//               icon: Icon(Icons.logout))
//         ],
//       ),
//       body: Center(
//         child: FutureBuilder(
//           future: nomvoid(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return CircularProgressIndicator(); // Show a loading indicator while fetching data
//             } else if (snapshot.hasError) {
//               return Text("Error fetching data");
//             } else {
//               return Padding(
//                 padding: const EdgeInsets.only(left: 20, right: 20),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       width: double.infinity,
//                       height: 180,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.all(Radius.circular(20)),
//                           color: Color.fromARGB(255, 21, 187, 2)),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: Container(
//                               child: Padding(
//                                 padding: const EdgeInsets.only(left: 10),
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   crossAxisAlignment:
//                                       CrossAxisAlignment.start,
//                                   children: [
//                                     Text(fullname),
//                                     SizedBox(
//                                       height: 5,
//                                     ),
//                                     Text(birthdate),
//                                     SizedBox(
//                                       height: 25,
//                                     ),
//                                     Container(
//                                       decoration: BoxDecoration(
//                                           color:
//                                               Color.fromARGB(255, 51, 50, 46),
//                                           borderRadius: BorderRadius.all(
//                                               Radius.circular(5))),
//                                       padding:
//                                           EdgeInsets.fromLTRB(15, 5, 15, 5),
//                                       child: Text(
//                                         "see more",
//                                         style: TextStyle(color: Colors.white),
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                               child: Container(
//                             height: double.infinity,
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.horizontal(
//                                     right: Radius.circular(20)),
//                                 image: DecorationImage(
//                                     image: NetworkImage(
//                                       rasm,
//                                     ),
//                                     fit: BoxFit.cover)),
//                           ))
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Text("Sheriklarim"),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Expanded(
//                       child: Container(
//                         child: GridView(
//                             gridDelegate:
//                                 SliverGridDelegateWithFixedCrossAxisCount(
//                                      mainAxisExtent: 250,
//                                      crossAxisSpacing: 5,
//                                      mainAxisSpacing: 5,
//                                     crossAxisCount: 2),
//                             children: lnom.map((e) => template(e)).toList()),
//                       ),
//                     )
//                   ],
//                 ),
//               );
//             }
//           },
//         ),
//       ),
//       drawer: DrawerList(),
//     );
//   }
// }

// class oddiyclas {
//   String? rasm;
//   String? tuliqIsm;
//   String? tel;
//   String? manzil;
//   String? yosh;
//   oddiyclas({this.rasm, this.tuliqIsm, this.tel, this.manzil, this.yosh});
// }

//qarzlarim

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'dart:convert';
import 'package:lottie/lottie.dart';
import 'package:student_app/color.dart';

class MyDebts extends StatefulWidget {
  const MyDebts({Key? key}) : super(key: key);

  @override
  State<MyDebts> createState() => _MyDebtsState();
}

class _MyDebtsState extends State<MyDebts> {
  List<Map<String, dynamic>> debtList = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchLessonDataqarz();
  }

  Future<void> fetchLessonDataqarz() async {
    try {
      dynamic apiget = await SessionManager().get("nomid");

      final response = await http.get(Uri.parse(
          "https://dash.vips.uz/api/2/3/163?studentid=$apiget&paiddate=NULL"));

      print(apiget);

      if (response.statusCode == 200) {
        final List<dynamic> listnom = jsonDecode(response.body);

        if (listnom.isNotEmpty) {
          setState(() {
            debtList = List<Map<String, dynamic>>.from(listnom);
            isLoading = false; // Set isLoading to false when data is fetched
          });
        } else {
          setState(() {
            isLoading = false; // Set isLoading to false if no data is available
          });
        }
      }
    } catch (error) {
      setState(() {
        isLoading = false; // Set isLoading to false if there is an error
        hasError = true; // Set hasError to true to handle error case
      });
      print("Error: $error");
    }
  }

  bool _isDueDatePassed(String dueDateString) {
    DateTime dueDate = DateTime.parse(dueDateString);
    return dueDate.isBefore(DateTime.now()) ||
        dueDate.isAtSameMomentAs(DateTime.now());
  }

  bool _anyDueDatePassed() {
    for (var debt in debtList) {
      if (_isDueDatePassed(debt['due'])) {
        return true;
      }
    }
    return false;
  }

  Widget _buildNoDebtUI() {
    bool noDebtAndNoDueDatesPassed = debtList.isEmpty && !_anyDueDatePassed();
    return Container(
      height: 260,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            child: noDebtAndNoDueDatesPassed
                ? Lottie.asset("asset/zo'r.json")
                : Lottie.asset("asset/xafa.json"),
          ),
          Text(
            noDebtAndNoDueDatesPassed
                ? "xamma qarz to'langan"
                : 'Another message when there are debts or some due dates have passed',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget vaqt_kelmasa() {
    return Container(
        margin: EdgeInsets.all(30),
        decoration: BoxDecoration(color: AppColors.yashil, borderRadius: BorderRadius.all(Radius.circular(22))),
        height: 200,
        child: Column(
          children: [
            Text(
              "qarzdorlik topilmadi",
              style: TextStyle(color: AppColors.oq, fontSize: 16),
            ),
          ],
        ));
  }

  Widget _buildDebtListUI() {
    return ListView.builder(
      itemCount: debtList.length,
      itemBuilder: (context, index) {
        final debt = debtList[index];
        if (_isDueDatePassed(debt['due'])) {
          return _buildDebtItem(debt);
        }
       
        // Hozirgi vaqtdan o'tib ketmagan holat
        return SizedBox.shrink();
      },
    );
  }

  Widget _buildDebtItem(Map<String, dynamic> debt) {
    return ListTile(
      key: UniqueKey(),
      title: Container(
        height: 260,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(22)),
          color: AppColors.yashil,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              child: Lottie.asset("asset/xafa.json"),
            ),
            Text(
              "Qarzingiz:",
              style: TextStyle(fontSize: 22),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${debt['sum']}0 so\'m',
                  style: TextStyle(
                    color: AppColors.qizil,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text(
              "Muddat: ${debt['due']}",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : hasError
                ? Text(
                    'An error occurred while fetching data',
                    style: TextStyle(fontSize: 16),
                  )
                : debtList.isEmpty
                    ? _buildNoDebtUI()
                    : _buildDebtListUI(),
      ),
    );
  }
}
