import 'package:flutter/material.dart';
import 'package:student_app/my_lessons.dart';

class MyDebts extends StatefulWidget {
  const MyDebts({super.key});

  @override
  State<MyDebts> createState() => _MyDebtsState();
}

class _MyDebtsState extends State<MyDebts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Text(sectionname)),
    );
  }
}
