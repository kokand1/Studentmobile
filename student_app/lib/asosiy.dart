import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_app/color.dart';
import 'package:student_app/drawer.dart';
import 'main.dart'; // Import the login class to use its methods

List<Map<String, dynamic>> data1 = [];

class Asosiy extends StatefulWidget {
  const Asosiy({super.key});

  @override
  State<Asosiy> createState() => _AsosiyState();
}

class _AsosiyState extends State<Asosiy> {
  List lnom = [
    oddiyclas(
        rasm:
            "https://img.freepik.com/free-photo/happy-young-female-student-holding-notebooks-from-courses-smiling-camera-standing-spring-clothes-against-blue-background_1258-70161.jpg?size=626&ext=jpg&ga=GA1.1.553209589.1714089600&semt=sph",
        tuliqIsm: "Nodirova Nargiz",
        manzil: "Shaldiramoq 1",
        tel: "90 222-22-22",
        yosh: "18"), oddiyclas(
        rasm:
            "https://t4.ftcdn.net/jpg/04/24/15/27/360_F_424152729_5jNBK6XVjsoWvTtGEljfSCOWv4Taqivl.jpg",
        tuliqIsm: "Nodirova Nargiz",
        manzil: "pomir 33",
        tel: "90 222-44-23",
        yosh: "23"), oddiyclas(
        rasm:
            "https://upsa.edu.gh/wp-content/uploads/2021/10/Ernest-Mawuli-1.jpg",
        tuliqIsm: "joe jonas",
        manzil: "Shaldiramoq 1",
        tel: "90 222-22-22",
        yosh: "18"), oddiyclas(
        rasm:
            "https://img.freepik.com/free-photo/front-view-male-student-wearing-black-backpack-holding-copybooks-smiling-blue-wall_140725-42653.jpg",
        tuliqIsm: "Nodirova Nargiz",
        manzil: "Shaldiramoq 1",
        tel: "90 222-22-22",
        yosh: "18"),
         oddiyclas(
        rasm:
            "https://img.freepik.com/free-photo/happy-young-female-student-holding-notebooks-from-courses-smiling-camera-standing-spring-clothes-against-blue-background_1258-70161.jpg?size=626&ext=jpg&ga=GA1.1.553209589.1714089600&semt=sph",
        tuliqIsm: "Nodirova Nargiz",
        manzil: "Shaldiramoq 1",
        tel: "90 222-22-22",
        yosh: "18"),
         oddiyclas(
        rasm:
            "https://img.freepik.com/free-photo/happy-young-female-student-holding-notebooks-from-courses-smiling-camera-standing-spring-clothes-against-blue-background_1258-70161.jpg?size=626&ext=jpg&ga=GA1.1.553209589.1714089600&semt=sph",
        tuliqIsm: "Nodirova Nargiz",
        manzil: "Shaldiramoq 1",
        tel: "90 222-22-22",
        yosh: "18")
  ];
  Widget template(a) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.yashil,
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
         ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: NetworkImage(a.rasm),fit: BoxFit.cover),
               
                borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
            height: 120,
            width: double.infinity,

          ),
          Container(
           padding: EdgeInsets.only(top: 5, left: 10),
            width: 200,
            height: 100,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(a.tuliqIsm),
                Text(a.yosh),
                Text(a.manzil),
                Text(a.tel),
              ],
            ),
          )
        ],
      ),
    );
  }

  dynamic nom = "";
  String fullname = "";
  String birthdate = "";
  String rasm = "";
  String id = "";

  Future<void> nomvoid() async {
    nom = await SessionManager().get("nomid");
    final response =
        await http.get(Uri.parse('https://dash.vips.uz/api/2/3/159?id=$nom'));

    if (response.statusCode == 200) {
      final List<dynamic> responsdata = jsonDecode(response.body);

      for (var item in responsdata) {
        data1.add(Map<String, dynamic>.from(item));
        fullname = item["fullname"];
        birthdate = item["birthdate"];
        rasm = item["photo"];
        id = item['id'];
        
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
              return Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 180,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: AppColors.yashil),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(fullname),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(birthdate),
                                     Text("studentid: $id"),
                                    SizedBox(
                                      height: 25,
                                    ),
                                   
                                    Container(
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromARGB(255, 51, 50, 46),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      padding:
                                          EdgeInsets.fromLTRB(15, 5, 15, 5),
                                      child: Text(
                                        "see more",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                              child: Container(
                            height: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.horizontal(
                                    right: Radius.circular(20)),
                                image: DecorationImage(
                                    image: NetworkImage(
                                      rasm,
                                    ),
                                    fit: BoxFit.cover)),
                          ))
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Sheriklarim"),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Container(
                        child: GridView(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                     mainAxisExtent: 250,
                                     crossAxisSpacing: 5,
                                     mainAxisSpacing: 5,
                                    crossAxisCount: 2),
                            children: lnom.map((e) => template(e)).toList()),
                      ),
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
      drawer: DrawerList(),
    );
  }
}

class oddiyclas {
  String? rasm;
  String? tuliqIsm;
  String? tel;
  String? manzil;
  String? yosh;
  oddiyclas({this.rasm, this.tuliqIsm, this.tel, this.manzil, this.yosh});
}
