// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_session_manager/flutter_session_manager.dart';
// import 'dart:convert';

// class MyDebts extends StatefulWidget {
//   const MyDebts({Key? key}) : super(key: key);

//   @override
//   State<MyDebts> createState() => _MyDebtsState();
// }

// class _MyDebtsState extends State<MyDebts> {
//   List<Map<String, dynamic>> nomlist = [];
//   String sum = "";
//   bool isLoading = true;
//   bool hasError = false;

//   @override
//   void initState() {
//     super.initState();
//     nomvoid();
//   }

//   Future<void> nomvoid() async {
//     try {
//       dynamic apiget = await SessionManager().get("nomid");

//       final response = await http.get(Uri.parse(
//           "https://dash.vips.uz/api/2/3/163?studentid=$apiget&paiddate=NULL"));

//       if (response.statusCode == 200) {
//         final List<dynamic> listnom = jsonDecode(response.body);

//         if (listnom.isNotEmpty) {
//           setState(() {
//             nomlist = List<Map<String, dynamic>>.from(listnom);
//             sum = calculateTotalSum().toString(); // Assign total sum value
//             isLoading = false; // Set isLoading to false when data is fetched
//           });
//         } else {
//           setState(() {
//             isLoading = false; // Set isLoading to false if no data is available
//           });
//         }
//       } else {
//         setState(() {
//           isLoading = false; // Set isLoading to false if there is an error
//           hasError = true; // Set hasError to true to handle error case
//         });
//         print('Failed to load data: ${response.statusCode}');
//       }
//     } catch (error) {
//       setState(() {
//         isLoading = false; // Set isLoading to false if there is an error
//         hasError = true; // Set hasError to true to handle error case
//       });
//       print("Error: $error");
//     }
//   }


//   int calculateTotalSum() {
//     int sum = 0;
//     for (var item in nomlist) {
//       try {
//         sum += double.parse(item["sum"]).toInt(); // Parse as double first to handle decimal values
//       } catch (e) {
//         print("Error parsing sum: $e");
//       }
//     }
//     return sum;
//   }
// @override
// Widget build(BuildContext context) {
//   int totalSum = calculateTotalSum(); // Calculate total sum
//   return Scaffold(
//     appBar: AppBar(),
//     body: Column(
//       children: [
//         Text(
//           "Total Sum: $totalSum", // Display total sum
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//         ),
//         Expanded(
//           child: ListView.builder(
//             itemCount: nomlist.length,
//             itemBuilder: (context, index) {
//               final item = nomlist[index];
//               return ListTile(
//                 title: Text(item["sum"].toString()),
//               );
//             },
//           ),
//         ),
//       ],
//     ),
//   );
// }
// }

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_session_manager/flutter_session_manager.dart';
// import 'dart:convert';
// import 'package:lottie/lottie.dart';
// import 'package:student_app/color.dart';
// import 'package:student_app/my_lessons.dart';

// class MyDebts extends StatefulWidget {
//   const MyDebts({Key? key}) : super(key: key);

//   @override
//   State<MyDebts> createState() => _MyDebtsState();
// }

// class _MyDebtsState extends State<MyDebts> {
//   List<Map<String, dynamic>> debtList = [];
//   bool isLoading = true;
//   bool hasError = false;
//   String sum ="";
//   @override
//   void initState() {
//     super.initState();
//     fetchLessonDataqarz();
//   }

//   Future<void> fetchLessonDataqarz() async {
//     try {
//       dynamic apiget = await SessionManager().get("nomid");

//       final response = await http.get(Uri.parse(
//           "https://dash.vips.uz/api/2/3/163?studentid=$apiget&paiddate=NULL"));

//       print(apiget);

//       if (response.statusCode == 200) {
//         final List<dynamic> listnom = jsonDecode(response.body);

//         if (listnom.isNotEmpty) {
//           setState(() {
//             debtList = List<Map<String, dynamic>>.from(listnom);
//              sum = calculateTotalSum().toString(); 
//             isLoading = false; // Set isLoading to false when data is fetched
//           });
//         } else {
//           setState(() {
//             isLoading = false; // Set isLoading to false if no data is available
//           });
//         }
//       }
//     } catch (error) {
//       setState(() {
//         isLoading = false; // Set isLoading to false if there is an error
//         hasError = true; // Set hasError to true to handle error case
//       });
//       print("Error: $error");
//     }
//   }

//   bool _isDueDatePassed(String dueDateString) {
//     DateTime dueDate = DateTime.parse(dueDateString);
//     return dueDate.isBefore(DateTime.now()) ||
//         dueDate.isAtSameMomentAs(DateTime.now());
//   }

//   bool _anyDueDatePassed() {
//     for (var debt in debtList) {
//       if (_isDueDatePassed(debt['due'])) {
//         return true;
//       }
//     }
//     return false;
//   }
//   int calculateTotalSum() {
//     int sum = 0;
//     for (var item in nomlist) {
//       try {
//         sum += double.parse(item["sum"]).toInt(); // Parse as double first to handle decimal values
//       } catch (e) {
//         print("Error parsing sum: $e");
//       }
//     }
//     return sum;
//   }
//   Widget _buildNoDebtUI() {
//     bool noDebtAndNoDueDatesPassed = debtList.isEmpty && !_anyDueDatePassed();
//     return Container(
//       height: 260,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             width: 100,
//             height: 100,
//             child: noDebtAndNoDueDatesPassed
//                 ? Lottie.asset("asset/zo'r.json")
//                 : Lottie.asset("asset/xafa.json"),
//           ),
//           Text(
//             noDebtAndNoDueDatesPassed
//                 ? "xamma qarz to'langan"
//                 : 'Another message when there are debts or some due dates have passed',
//             style: TextStyle(fontSize: 16),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget vaqt_kelmasa() {
//     return Container(
//         margin: EdgeInsets.all(30),
//         decoration: BoxDecoration(color: AppColors.yashil, borderRadius: BorderRadius.all(Radius.circular(22))),
//         height: 200,
//         child: Column(
//           children: [
//             Text(
//               "qarzdorlik topilmadi",
//               style: TextStyle(color: AppColors.oq, fontSize: 16),
//             ),
//           ],
//         ));
//   }

//   Widget _buildDebtListUI() {
//     return ListView.builder(
//       itemCount: debtList.length,
//       itemBuilder: (context, index) {
//         final debt = debtList[index];
//         if (_isDueDatePassed(debt['due'])) {
//           return _buildDebtItem(debt);
//         }
       
//         // Hozirgi vaqtdan o'tib ketmagan holat
//         return SizedBox.shrink();
//       },
//     );
//   }

//   Widget _buildDebtItem(Map<String, dynamic> debt) {
//      int totalSum = calculateTotalSum();
//     return Column(
//       children: [
//         ListTile(title: Text("$totalSum"),),
//         ListTile(
//           key: UniqueKey(),
//           title: Container(
//             height: 260,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.all(Radius.circular(22)),
//               color: AppColors.yashil,
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   width: 100,
//                   height: 100,
//                   child: Lottie.asset("asset/xafa.json"),
//                 ),
//                 Text(
//                   "Qarzingiz:",
//                   style: TextStyle(fontSize: 22),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       '${debt['sum']}0 so\'m',
//                       style: TextStyle(
//                         color: AppColors.qizil,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Text(
//                   "Muddat: ${debt['due']}",
//                   style: TextStyle(fontSize: 16),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Center(
//         child: isLoading
//             ? CircularProgressIndicator()
//             : hasError
//                 ? Text(
//                     'An error occurred while fetching data',
//                     style: TextStyle(fontSize: 16),
//                   )
//                 : debtList.isEmpty
//                     ? _buildNoDebtUI()
//                     : _buildDebtListUI(),
//       ),
//     );
//   }
// }
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
  bool  rejaQarz = true;
  String sum = "";

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
            sum = calculateTotalSum().toString();
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

  int calculateTotalSum() {
    int sum = 0;
    for (var item in debtList) {
      try {
        sum += double.parse(item["sum"]).toInt(); // Parse as double first to handle decimal values
      } catch (e) {
        print("Error parsing sum: $e");
      }
    }
    return sum;
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

  Widget _buildTotalSum() {
     bool reja = debtList.isEmpty && !_anyDueDatePassed();
    return Container(
      padding: EdgeInsets.all(10),
      child: reja?Text(
        "Qarzingiz yo'q",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ):Text(
        "Rejalashtirilgan qarz: $sum.000",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
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
      body: Column(
        children: [
          _buildTotalSum(),
          Expanded(
            child: Center(
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
          ),
        ],
      ),
    );
  }
}
