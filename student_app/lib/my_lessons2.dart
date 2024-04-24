import 'package:flutter/material.dart';
import 'package:student_app/my_lessons.dart';

class My_Lesson2 extends StatefulWidget {
  const My_Lesson2({super.key});

  @override
  State<My_Lesson2> createState() => _My_Lesson2State();
}

class _My_Lesson2State extends State<My_Lesson2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
                decoration: BoxDecoration(
       color: Colors.grey,
       borderRadius: BorderRadius.all(Radius.circular(12))
                ),
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(5),
                width: double.infinity,
               
                
                child: Column(
                 
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
       Text("sectionname: $sectionname"),
       SizedBox(height: 10,),
       Text("datetimes: $datetimes"),
       SizedBox(height: 10,),
       Text("startdate: $startdate"),
       SizedBox(height: 10,),
       Text("enddate: $enddate "),
       SizedBox(height: 10,),
       Text("roomid: $roomid")
                ],)
         
       
              ),
      
    );
  }
}
