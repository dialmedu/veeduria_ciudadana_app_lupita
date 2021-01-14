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
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25.0),
        child: Column(
          children: [
            RichText(
              text: TextSpan(children: <TextSpan>[
                TextSpan(
                    text: '¡Hola!',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                        fontWeight: FontWeight.bold))
              ]),
            ),
            SizedBox(
              height: 15.0,
            ),
            RichText(
              text: TextSpan(children: <TextSpan>[
                TextSpan(
                    text: ' soy',
                    style: TextStyle(color: Colors.black, fontSize: 28)),
                TextSpan(
                    text: ' App-Lupita',
                    style: TextStyle(color: Colors.green, fontSize: 28))
              ]),
            ),
            SizedBox(
              height: 25.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width < 320
                  ? MediaQuery.of(context).size.width * 0.9
                  : MediaQuery.of(context).size.width * 0.6,
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Text(
                  'Soy una aplicación para el control y la veeduría ciudadana en Norte de Santander',
                  style: TextStyle(
                    fontSize: 24,
                    fontStyle: FontStyle.italic,
                    color: Colors.black45,
                  )),
            ),
            SizedBox(
              height: 10.0,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: LButtons.buttonPrimary('Continuar', goToHomePage, context),
            ),
          ],
        ),
      ),
    );
  }

  void goToHomePage() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => Home()),
    );
  }
}
