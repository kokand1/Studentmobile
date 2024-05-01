import 'package:flutter/material.dart';
import 'package:student_app/color.dart';
import 'package:student_app/my_lessons.dart';

class My_Lesson2 extends StatefulWidget {
  const My_Lesson2({super.key});

  @override
  State<My_Lesson2> createState() => _My_Lesson2State();
}

class _My_Lesson2State extends State<My_Lesson2> {
  List l = [
    // "Bo'lim nomi:  $sectionname",
    // "Dars kunlari: $datetimes",
    // "boshlanish sanasi: $startdate",
    // " tugash sanasi: $enddate",
    // "xona nomi: $roomidroomname",
    // "O'qituvchi: $staffidfullname",
    O(text:"Bo'lim nomi:", uzgaruvchi: sectionname ) ,
    O(text:"Dars kunlari:", uzgaruvchi: datetimes ),
    O(text:"boshlanish sanasi:", uzgaruvchi: startdate ),
    O(text:"tugash sanasi:", uzgaruvchi: enddate ),
    O(text:"O'qituvchi:", uzgaruvchi: staffidfullname ),
    O(text:"xona nomi:", uzgaruvchi: roomidroomname )                 
  ];
  Widget t(ll) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, 5, 0, 5),
      margin: EdgeInsets.fromLTRB(10, 0, 10, 5),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(ll.text),
          Text(ll.uzgaruvchi,style: TextStyle(color:AppColors.oq ),),
        ],
      ),
      color: AppColors.yashil,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(), body: Column(children: l.map((e) => t(e)).toList()));
  }
}

class O {
  String? text;
  String? uzgaruvchi;
    O({this.text,this.uzgaruvchi});

}
