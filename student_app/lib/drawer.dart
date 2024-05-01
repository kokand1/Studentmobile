import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:student_app/my_debts.dart';
import 'package:student_app/my_lessons.dart';

class DrawerList extends StatefulWidget {
  const DrawerList({Key? key}) : super(key: key);

  @override
  State<DrawerList> createState() => _DrawerListState();
}

class _DrawerListState extends State<DrawerList> {
  String rasm = "";
  String fulname = "";
  String username = "";
  bool isLoading = true;

  Future<void> fetchData() async {
    try {
      // Fetch user id from session
      dynamic userId = await SessionManager().get("nomid");

      final response = await http
          .get(Uri.parse('https://dash.vips.uz/api/2/3/159?id=$userId'));

      if (response.statusCode == 200) {
        final List<dynamic> listNom = jsonDecode(response.body);

        if (listNom.isNotEmpty) {
          // Take the first item from the list
          Map<String, dynamic> item = Map<String, dynamic>.from(listNom[0]);
          setState(() {
            rasm = item['photo'];
            fulname = item['fullname'];
            username = item["username"];
            isLoading = false;
          });
        }
      } else {
        // Handle API error
        print('API request failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle other errors
      print('An error occurred: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(color: Colors.grey),
                  accountName: Text("Fulname: $fulname"),
                  accountEmail: Text("Username: $username"),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: NetworkImage(rasm),
                  ),
                ),
                ListTile(
                  leading: CircleAvatar(child: Icon(Icons.play_lesson)),
                  title: Text('Darslarim'),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyLesson()));
                  },
                ),
                ListTile(
                  leading:
                      CircleAvatar(child: Icon(Icons.account_balance_outlined)),
                  title: Text('Qarzlarim'),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyDebts()));
                  },
                ),
                ListTile(
                  leading:
                      CircleAvatar(child: Icon(Icons.add_task_outlined)),
                  title: Text("Bo'lim %"),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyDebts()));
                  },
                ),
              ],
            ),

      // Other ListTiles...
    );
  }
}
