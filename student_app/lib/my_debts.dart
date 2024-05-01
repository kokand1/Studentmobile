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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child:
            isLoading // Display CircularProgressIndicator if isLoading is true
                ? CircularProgressIndicator()
                : hasError // Display error message if there is an error
                    ? Text(
                        'An error occurred while fetching data',
                        style: TextStyle(fontSize: 16),
                      )
                    : debtList
                            .isEmpty // Display text message if debtList is empty
                        ? Container(
                    height: 260,
                    width: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(22)),
                      color: AppColors.yashil,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset("asset/zo'r.json"),
                        SizedBox(
                          height: 10,
                        ),
                        // Icon(
                        //   Icons.thumb_up_alt,
                        //   size: 50,
                        //   color: AppColors.oq,
                        // ),
                        Text(
                          "Qarzdorlik yo'q",
                          style: TextStyle(fontSize: 20 , color: AppColors.oq),
                        )
                      ],
                    ),
                  ) // Xatolik
                        : ListView.builder(
                            itemCount: debtList.length,
                            itemBuilder: (context, index) {
                              final debt = debtList[index];
                              return ListTile(
                                title: Container(
                                    height: 260,
                                   
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(22)),
                                      color: AppColors.yashil,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                            width: 100,
                                            height: 100,
                                            child: Lottie.asset(
                                                "asset/xafa.json")),
                                        Text(
                                          "Qarzingiz:",
                                          style: TextStyle(fontSize: 22),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              debt['sum'].toString(),
                                              style: TextStyle(
                                                  color: AppColors.qizil,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              "0",
                                              style: TextStyle(
                                                  color: AppColors.qizil,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              " so'm",
                                            )
                                          ],
                                        ),
                                      ],
                                    )),
                                // Add more widgets here to display additional data
                              );
                            },
                          ),
      ),
    );
  }
}
