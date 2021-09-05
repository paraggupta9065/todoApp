import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todoapp/home.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initHives();
  }

  initHives() async {
    await Hive.initFlutter();
    await Hive.openBox('todo');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo ',
      home: MyHomePage(),
    );
  }
}
