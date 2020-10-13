import 'package:flutter/material.dart';
import 'package:lupita_ft/pages/welcome.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(context) {
    return MaterialApp(
        home: Center(
      child: Welcome(),
    ));
  }
}
