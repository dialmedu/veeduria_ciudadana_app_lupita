import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lupita_ft/pages/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
