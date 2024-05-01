import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;

import 'package:student_app/my_lessons2.dart';

String sectionname='';
String datetimes ="";
String roomidroomname = "";
String startdate = '';
String enddate = "";
String staffidfullname = "";
String r = "";

 List nomlist = [];
class MyLesson extends StatefulWidget {
  const MyLesson({Key? key}) : super(key: key);

  @override
  State<MyLesson> createState() => _MyLessonState();
}

class _MyLessonState extends State<MyLesson> {
 
 
//darslar uchun 
  Future<void> fetchLessonData() async {
    try {
      dynamic apiget = await SessionManager().get("nomid");
      
      final response = await http.get(Uri.parse(
        //shu urldan olingan studentcontract  https://dash.vips.uz/a/2/3/162
          "https://dash.vips.uz/api/2/3/162?studentid=$apiget"
        
          ));
      print(apiget);

      if (response.statusCode == 200) {
        final List<dynamic> listnomi = jsonDecode(response.body);

        if (listnomi.isNotEmpty) {
         
          setState(() {
            nomlist.clear();
              for (var item in listnomi) {
            Map<String, dynamic> lessonData = Map<String, dynamic>.from(item);
     
            String bulim = lessonData['sectionid'];
            
            
            OddiyClass oddiy = OddiyClass(bulim:bulim);
           
              nomlist.add(oddiy); 
             // Add the object to the list
            
          }
          });
        }
      } else {
        // Handle API error
        print('API request failed with status code: ${response.statusCode}');
        // You can set appropriate values or show an error message to the user
      }
    } catch (error) {
      print("Error: $error");
      // Handle other errors here
    }
  }
//dars kunlari xona nomi 
  Future<void> fetchLessonData12(String aa) async {
    try {
      dynamic apiget = await SessionManager().get("nomid");
      
      final response = await http.get(Uri.parse(
          //section   https://dash.vips.uz/a/2/3/149
        "https://dash.vips.uz/api/2/3/149?id=$aa"
          ));
      print(apiget);

      if (response.statusCode == 200) {
        final List<dynamic> listnomi = jsonDecode(response.body);

        if (listnomi.isNotEmpty) {
          for (var item in listnomi) {
            Map<String, dynamic> lessonData = Map<String, dynamic>.from(item);
            sectionname = lessonData['sectionname'];
            startdate = lessonData["startdate"];
            enddate = lessonData["enddate"];
            datetimes = lessonData["datetimes"];
            roomidroomname =lessonData["roomidroomname"];
            staffidfullname = lessonData["staffidfullname"];
            

            
           setState(() {
             Navigator.push(context, MaterialPageRoute(builder: (context)=> My_Lesson2()));
           });
           
          }
          setState(() {
            r = "${listnomi.length}"; // Assuming 'debt' is a valid key in your response
          });
        }
      } else {
        // Handle API error
        print('API request failed with status code: ${response.statusCode}');
        // You can set appropriate values or show an error message to the user
      }
    } catch (error) {
      print("Error: $error");
      // Handle other errors here
    }
  }

  Widget template (oddiy){
      return InkWell(
        onTap: () {
          fetchLessonData12(oddiy.bulim);
        },
        child: Container(
          decoration: BoxDecoration(
           color: Color.fromARGB(255, 21, 187, 2),
            borderRadius: BorderRadius.all(Radius.circular(12))
          ),
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(5),
          width: double.infinity,
         
          
          child: ListTile(
              title:  Text("Bo'limlarim: ${oddiy.bulim ?? 'bulim'}"),
              
              
            ),
        ),
      );
  }
  @override
  void initState() {
    super.initState();
    fetchLessonData();
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text("Darslarim"),centerTitle: true,),
    body: ListView.builder(
      itemCount: nomlist.length,
      itemBuilder: (context, index) {
        OddiyClass currentItem = nomlist[index];
        return template(currentItem);
      },
    ),
  );
}
}
class OddiyClass{
  
  String? bulim;

  OddiyClass({this.bulim});
}
