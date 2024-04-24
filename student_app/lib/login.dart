// import 'package:flutter/material.dart';
// import 'package:student_app/asosiy.dart';

// class Login extends StatefulWidget {
//   const Login({super.key});

//   @override
//   State<Login> createState() => _LoginState();
// }

// class _LoginState extends State<Login> {
//    String username = "aziz";
//     String password = '123456';
//     String date = '';

//     TextEditingController a = TextEditingController();
//     TextEditingController b = TextEditingController();
//     void nomvoid(){
//      setState(() {
//                   String username_1 = a.text;
//                   String password_2 = b.text;
//                   if (username == username_1 && password == password_2) {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => const Asosiy()),
//                     );
                  
                   
//                   } else {
//                     date = "parol yoki logindi tekshiring!!!";
//                   }
//                 });
//     }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.fromLTRB(30, 50, 30, 20),
//         child: Column(children: [
         
//           TextField(
//             controller: a,
//             keyboardType: TextInputType.emailAddress,
//             decoration: const InputDecoration(
//                 hintText: "UserName",
//                 prefixIcon: Icon(
//                   Icons.email,
//                   color: Colors.black,
//                 ),
//                 border: OutlineInputBorder()),
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           TextField(
//             controller: b,
//             obscureText: true,
//             decoration: const InputDecoration(
//                 hintText: "Password",
//                 prefixIcon: Icon(
//                   Icons.security,
//                   color: Colors.black,
//                 ),
//                 border: OutlineInputBorder()),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
//             child: ElevatedButton(
//               onPressed: () {
               
//                nomvoid();
//               },
//               child: Text('next'),
              
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 30),
//             child: Text('$date',style: TextStyle(color: Colors.red),),
//           ),
//         ]),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:student_app/asosiy.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  List<Map<String, dynamic>> data = [];
  var nom = "";
  var parol = '';
  var user = "";
  var name = "";
  var date = "";

  void login(String user) async {
    try {
      final response = await http.get(Uri.parse(
          'https://dash.univ.uz/api/17/177/6185?status=1&username=$user'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = List<dynamic>.from(jsonDecode(response.body));

        for (var item in jsonData) {
          data.add(Map<String, dynamic>.from(item));
          parol = item["password"];

          name = item["username"];
          nom = item["birthdate"];
          
          // Assuming _usernameController and _passwordController are declared somewhere
          if (name == _usernameController.text && parol == _passwordController.text) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Asosiy()),
            );
            _usernameController.text = '';
            _passwordController.text = '';
            date = "";
          } else {
            date = "bu malumot yo'q";
          }
        }
        
      } else {
        throw Exception('Failed to load data from the API');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    login(_usernameController.text);
    login(_passwordController.text);
  }

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: "UserName",
                prefixIcon: Icon(
                  Icons.email,
                  color: Colors.black,
                ),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: "Password",
                prefixIcon: Icon(
                  Icons.security,
                  color: Colors.black,
                ),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () async {
                  login(_usernameController.text);
                  login(_passwordController.text);
                setState(() {});
              },
              child: Text("login"),
            ),
          
          ],
        ),
      ),
    );
  }
}
