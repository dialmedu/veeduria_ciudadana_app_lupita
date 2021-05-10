import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lupita_ft/components/button_components.dart';
import 'package:lupita_ft/model/town.dart';
import 'package:lupita_ft/pages/form.dart';
import 'package:lupita_ft/pages/home.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';

class TownPage extends StatefulWidget {
  @override
  _TownPage createState() => _TownPage();
}

class _TownPage extends State<TownPage> {
  DatabaseReference _firebase;
  final List<Map<dynamic, dynamic>> lists = new List<Map<dynamic, dynamic>>();
  int _isLoadingViewFile = -1;
  int _isChargeViewFile = -1;
  PDFDocument documentPdf;

  @override
  void initState() {
    super.initState();
    initFirebase();
  }

  void initFirebase() {
    _firebase = FirebaseDatabase.instance.reference().child("Denuncias");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: _isChargeViewFile != -1 ?

      Row(children: [
        SizedBox(
          height: 25.0,
        ),
        FloatingActionButton(
            tooltip: "Regresar",
            child: Icon(Icons.arrow_back),
            onPressed: () {
              setState(() {
                _isChargeViewFile = -1;
              });
            })
      ],) : Text(""),
      body:  _isChargeViewFile != -1 ? PDFViewer(document: documentPdf) :
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 25.0,
              ),
              buildSelect(),
              Center(
                  child:
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 30),
                      child:  Text(_selectedTownship != null ? _selectedTownship.summary ?? '' : '', style: TextStyle(fontSize: 18),))

              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                child: StreamBuilder(
                    stream: search(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot != null && snapshot.hasData) {
                        lists.clear();
                        List<Map<String, dynamic>> values = snapshot.data.docs.map((e) {
                          return e.data();
                        }).toList();
                        if (values.length > 0) {

                        } else {
                          return new Container(
                            width: 250,
                            child: Column(
                              children: [
                                Container(
                                  width: 150,
                                  child: Image.asset('images/denunciar.jpg'),
                                ),
                                Text('No se encontraron más detalles para este municipio.')
                              ],
                            ),
                          );
                        }
                        return new ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: values.length,
                            itemBuilder: (BuildContext context, int index) {
                              bool isLoadingPdf = false;
                              bool isChargePdf = false;
                              PDFDocument documentPdf;
                              return Card(
                                clipBehavior: Clip.antiAlias,
                                margin: EdgeInsets.symmetric(vertical: 5.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    ListTile(
                                      leading: Icon(Icons.arrow_drop_down_circle),
                                      title: SelectableText(values[index]["nombre"], style: TextStyle(fontSize: 24),),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                                        child: SelectableText(
                                          values[index]["descripcion"].toString().replaceAll('\n', '\n').replaceAll('/n', '\n').replaceAll('  ', '\n'),
                                          style: TextStyle(
                                              color: Colors.black, fontSize: 16),
                                        )
                                    ),
                                    values[index]["archivo"] != null && values[index]["archivo"].toString().isNotEmpty ? ButtonBar(
                                      alignment: MainAxisAlignment.start,
                                      children: [
                                        _isLoadingViewFile == index ? Center(child: CircularProgressIndicator())
                                            :
                                        LButtons.buttonPrimary("Leer archivo PDF", () => chargeDocument(index, values[index]["archivo"].toString()), context),
                                      ],
                                    ) : Text(""),
                                  ],
                                ),
                              );
                            });
                      }
                      if(_selectedTownship == null){
                        return Text('Seleccione Municipio');
                      } else {
                        return CircularProgressIndicator();
                      }
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

  Future<bool> chargeDocument(int index, String url) async {
    setState(() {
      _isChargeViewFile = -1;
      _isLoadingViewFile = index;
    });
    documentPdf = await PDFDocument.fromURL(url);
    setState(() {
      _isLoadingViewFile = -1;
      _isChargeViewFile = index;
    });
    return true;
  }

  void goToHomePage() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => Home()),
    );
  }

  List<Town> _townships;
  List<DropdownMenuItem<int>> _dropdownMenuItems;
  Town _selectedTownship;

  onChangeMunicipioItem(int selectedMunicipio) {
    setState(() {
      _selectedTownship = _townships.firstWhere((element) => element.number == selectedMunicipio);
    });
  }

  Widget buildSelect() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Busca tu Municipio"),
            SizedBox(
              height: 5.0,
            ),
            StreamBuilder(
                stream: Town.getTowns(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                  if (!snapshot.hasData) {
                    return Text('Cargando Municipios...');
                  }
                  _townships = snapshot.data.docs.map((e) => new Town.fromData(e.id, e.data())).toList();
                  _dropdownMenuItems = buildDropdownMenuItems(_townships);
                  if(_selectedTownship == null){
                    _selectedTownship = _townships.firstWhere((element) => element.number == _dropdownMenuItems[0].value);
                  }
                  return  DropdownButton(
                    value: _selectedTownship.number,
                    items: _dropdownMenuItems,
                    onChanged: onChangeMunicipioItem,
                    style: TextStyle(color: Colors.black87, fontSize: 24.0),
                  );
                }),
            SizedBox(
              height: 5.0,
            ),
            Text('Actualmente: ${_selectedTownship == null ? '' : _selectedTownship.name}',
                style: TextStyle(
                  fontSize: 16.0,
                  fontStyle: FontStyle.italic,
                  color: Colors.black45,
                )),
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<int>> buildDropdownMenuItems(List municipios) {
    List<DropdownMenuItem<int>> items = List();
    if(municipios != null){
      for (Town municipio in municipios) {
        items.add(
          DropdownMenuItem(
            value: municipio.number,
            child: Text(municipio.name),
          ),
        );
      }
    }
    return items;
  }

  Stream<QuerySnapshot> search() {
    try {
      if(_selectedTownship == null){
        _selectedTownship = ModalRoute.of(context).settings.arguments;
      }
      return _selectedTownship.getTownPage();
    } on PlatformException catch (e) {
      return null;
    }
  }
}
