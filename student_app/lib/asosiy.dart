import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_app/drawer.dart';
import 'main.dart'; // Import the login class to use its methods

List<Map<String, dynamic>> data1 = [];

class Asosiy extends StatefulWidget {
  const Asosiy({super.key});

  @override
  State<Asosiy> createState() => _AsosiyState();
}

class _AsosiyState extends State<Asosiy> {
  dynamic nom = "";
  String fullname = "";
  String birthdate = "";
  String id = "";
  Future<void> nomvoid() async {
    nom = await SessionManager().get("nomid");
    final response =
        await http.get(Uri.parse('https://dash.vips.uz/api/2/3/159?id=$nom'));

    if (response.statusCode == 200) {
      final List<dynamic> listnom = jsonDecode(response.body);

      for (var item in listnom) {
        data1.add(Map<String, dynamic>.from(item));
        fullname = item["fullname"];
        birthdate = item["birthdate"];
        id = item['id'];
        print(fullname);
      }
    }
  }

  Future<void> clearLoginData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('password');
  }

  @override
  void initState() {
    super.initState();
    nomvoid().then((_) {
      // This block will be executed after nomvoid completes
      print(birthdate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                await clearLoginData(); // Clear the saved login data
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: FutureBuilder(
          future: nomvoid(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Show a loading indicator while fetching data
            } else if (snapshot.hasError) {
              return Text("Error fetching data");
            } else {
              return Column(
                children: [
                  Text(fullname),
                  Text(birthdate),
                  Text(id),
                ],
              );
            }
          },
        ),
      ),
      drawer: DrawerList(),
    );
  }
}
