import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lupita_ft/components/button_components.dart';
import 'package:lupita_ft/model/municipio.dart';
import 'package:lupita_ft/pages/form.dart';
import 'package:lupita_ft/pages/home.dart';

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  DatabaseReference _firebase;
  final List<Map<dynamic, dynamic>> lists = new List<Map<dynamic, dynamic>>();

  @override
  void initState() {
    super.initState();
    initList();
    initFirebase();
  }

  void initFirebase() {
    _firebase = FirebaseDatabase.instance.reference().child("Denuncias");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Column(
            children: <Widget>[
              Container(
                width: 200,
                child: Image.asset('images/leer.jpg'),
              ),
              Center(
                child: Text('Infórmate del Municipio'),
              ),
              buildSelect(),
              SizedBox(
                height: 25.0,
              ),
              LButtons.buttonPrimary('Buscar', () => {}, context),
              SizedBox(
                height: 50.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder(
                    future: search(),
                    builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
                      if (snapshot != null && snapshot.hasData) {
                        lists.clear();
                        Map<dynamic, dynamic> values = snapshot.data.value;
                        if (values != null && values.length > 0) {
                          values.forEach((key, values) {
                            lists.add(values);
                          });
                        } else {
                          return new Container(
                            width: 250,
                            child: Column(
                              children: [
                                Container(
                                  width: 150,
                                  child: Image.asset('images/denunciar.jpg'),
                                ),
                                Text('No se encontraron denuncias'),
                                LButtons.buttonPrimary(
                                    'Crear Denuncia', goToFormPage, context)
                              ],
                            ),
                          );
                        }
                        return new ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: lists.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                margin: EdgeInsets.symmetric(vertical: 5.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Fecha: " + lists[index]["fecha"],
                                      style: TextStyle(
                                          color: Colors.black45, fontSize: 12),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      lists[index]["descripcion"],
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                    ),
                                    Text(
                                      "Municipio: " + lists[index]["municipio"],
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              );
                            });
                      }
                      return CircularProgressIndicator();
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void goToFormPage() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => FormPage()),
    );
  }

  InputDecoration decorationTextField({String hintText}) {
    return new InputDecoration(
        border: new OutlineInputBorder(
          borderSide: new BorderSide(color: Colors.teal),
        ),
        hintText: hintText);
  }

  void goToHomePage() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => Home()),
    );
  }

  List<Municipio> _municipios;
  List<DropdownMenuItem<Municipio>> _dropdownMenuItems;
  Municipio _selectedMunicipio;

  initList() async {
    _dropdownMenuItems = buildDropdownMenuItems(_municipios);
    _selectedMunicipio = _dropdownMenuItems[0].value;
  }

  onChangeDropdownItem(Municipio selectedMunicipio) {
    setState(() {
      _selectedMunicipio = selectedMunicipio;
    });
  }

  Widget buildSelect() {
    return Container(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Seleccione Municipio"),
            SizedBox(
              height: 5.0,
            ),
            DropdownButton(
              value: _selectedMunicipio,
              items: _dropdownMenuItems,
              onChanged: onChangeDropdownItem,
            ),
            SizedBox(
              height: 5.0,
            ),
            Text('Actualmente: ${_selectedMunicipio.name}'),
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<Municipio>> buildDropdownMenuItems(List municipios) {
    List<DropdownMenuItem<Municipio>> items = List();
    for (Municipio municipio in municipios) {
      items.add(
        DropdownMenuItem(
          value: municipio,
          child: Text(municipio.name),
        ),
      );
    }
    return items;
  }

  Future<DataSnapshot> search() async  {
    try {
      return _firebase
          .orderByChild('municipio')
          .equalTo(_selectedMunicipio.name)
          .limitToFirst(20)
          .once();
    } on PlatformException catch (e) {
      return null;
    }
  }
}
