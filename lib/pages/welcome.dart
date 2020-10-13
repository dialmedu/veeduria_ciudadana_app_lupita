import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lupita_ft/components/button_components.dart';
import 'package:lupita_ft/pages/home.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<Welcome> {
  final opciones = ['Uno', 'Dos', 'Tres', 'Cuatro'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          RichText(
            text: TextSpan(children: <TextSpan>[
              TextSpan(text: 'Hola soy', style: TextStyle(color: Colors.black)),
              TextSpan(
                  text: ' App Lupita', style: TextStyle(color: Colors.green))
            ]),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            width: 320,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            child: Text(
                'Soy una aplicación para el control y la veeduría ciudadana en Norte de Santander'),
          ),
          SizedBox(
            height: 10.0,
          ),
          Center(
              child:
                  LButtons.buttonPrimary('Continuar', goToHomePage, context)),
        ],
      ),
    );
  }

  void goToHomePage() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => Home()),
    );
  }
}
