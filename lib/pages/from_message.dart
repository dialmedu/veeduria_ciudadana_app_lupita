import 'package:flutter/material.dart';
import 'package:lupita_ft/components/button_components.dart';
import 'package:lupita_ft/model/complaint.dart';

import 'Home.dart';

class FormMessagePage extends StatefulWidget {
  @override
  _FormMessagePageState createState() => _FormMessagePageState();
}

class _FormMessagePageState extends State<FormMessagePage> {
  Complaint denuncia = new Complaint(1, 'Los patios');
  bool _continuar = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Center(
              child: _continuar == false
                  ? Container(
                      width: MediaQuery.of(context).size.width - 100,
                      child: Image.asset('images/denunciar.jpg'),
                    )
                  : Container(
                      width: MediaQuery.of(context).size.width - 50,
                      child: Image.asset('images/save.jpg'),
                    ),
            ),
            Center(
              child: Text('Hemos recibido tu denuncia'),
            ),
            SizedBox(
              height: 50.0,
            ),
            _continuar == false
                ? Center(
                    child: Text(
                        'Verifica tu conexion a internet y vuelve a intentarlo'),
                  )
                : Center(
                    child:
                        Text('Gracias por ser parte de la veeduría ciudadana'),
                  ),
            SizedBox(
              height: 50.0,
            ),
            LButtons.buttonPrimary("Continuar", goToHomePage, context)
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
