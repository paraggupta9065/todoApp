import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/home.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo ',
      home: MyHomePage(),
    );
  }
}
