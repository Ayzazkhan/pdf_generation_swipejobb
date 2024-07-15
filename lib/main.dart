import 'package:flutter/material.dart';
import 'layout/LayoutPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter PDF Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: InputForm(),
    );
  }
}

