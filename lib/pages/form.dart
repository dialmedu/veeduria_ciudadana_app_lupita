import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lupita_ft/components/button_components.dart';
import 'package:lupita_ft/model/complaint.dart';
import 'package:lupita_ft/model/town.dart';
import 'package:lupita_ft/pages/from_message.dart';

class FormPage extends StatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  Complaint denuncia = new Complaint(1, 'Los patios');
  bool _continuar = false;
  bool _guardando = false;

  TextEditingController _descripcion, _nombre, _documento;
  DatabaseReference _firebase;

  @override
  void initState() {
    super.initState();
    initControllers();
    initFirebase();
  }

  void initFirebase() {
    _firebase = FirebaseDatabase.instance.reference().child("Denuncias");
  }

  void initControllers() {
    _descripcion = new TextEditingController();
    _nombre = new TextEditingController();
    _documento = new TextEditingController();
  }

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
                      width: MediaQuery.of(context).size.width < 320
                          ? MediaQuery.of(context).size.width * 0.6
                          : MediaQuery.of(context).size.width * 0.8,
                      child: Image.asset('images/denunciar.jpg'),
                    )
                  : SizedBox(
                      height: 50.0,
                    ),
            ),
            Center(
              child: Text('Realizar Denuncia'),
            ),
            buildSelect(),
            SizedBox(
              height: 50.0,
            ),
            _continuar == false
                ? LButtons.buttonPrimary('Continuar',
                    () => {setState(() => _continuar = true)}, context)
                : buildForm(),
          ],
        ),
      ),
    );
  }

  InputDecoration decorationTextField({String hintText}) {
    return new InputDecoration(
        border: new OutlineInputBorder(
          borderSide: new BorderSide(color: Colors.teal),
        ),
        hintText: hintText);
  }

  Widget buildForm() {
    return Container(
        child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Descripción:', textAlign: TextAlign.left),
          TextField(
            controller: _descripcion,
            decoration: decorationTextField(
                hintText: 'Agrega una descripción de tu denuncia'),
            maxLines: 8,
          ),
          SizedBox(
            height: 50.0,
          ),
          Text('Tu nombre:', textAlign: TextAlign.left),
          TextField(
            controller: _nombre,
            maxLines: 1,
            decoration:
                decorationTextField(hintText: 'Ingrese nombres y apellidos'),
          ),
          SizedBox(
            height: 50.0,
          ),
          Text('Tu documento:', textAlign: TextAlign.left),
          TextField(
            controller: _documento,
            maxLines: 1,
            decoration:
                decorationTextField(hintText: 'Ingrese numero de documento'),
          ),
          SizedBox(
            height: 50.0,
          ),
          LButtons.buttonPrimary("Guardar Denuncia", saveComplaint, context)
        ],
      ),
    ));
  }

  Future<void> saveComplaint() async {
    // todo save on firebase
    String name = _nombre.text;
    String document = _documento.text;
    String description = _descripcion.text;
    DateTime today = new DateTime.now();
    String dateSlug =
        "${today.year.toString()}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    Map<String, String> complaint = {
      'nombres': name,
      'documento': document,
      'descripcion': description,
      'municipio': _selectedTown.name,
      'municipio_id': _selectedTown.id.toString(),
      'fecha': dateSlug,
      'user': 'anonimo'
    };

    _firebase.push().set(complaint).then((value) {
      goToFormMessagePage();
    });
  }

  void goToFormMessagePage() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => FormMessagePage()),
    );
  }

  List<Town> _town;
  List<DropdownMenuItem<int>> _dropdownMenuItems;
  Town _selectedTown;


  onChangeMunicipioItem(int selectedMunicipio) {
    setState(() {
      _selectedTown = _town.firstWhere((element) => element.number == selectedMunicipio);
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
                  _town = snapshot.data.docs.map((e) {
                    Town t = new Town.fromData(e.id, e.data());
                    return t;
                  }).toList();
                  _dropdownMenuItems = buildDropdownMenuItems(_town);
                  if(_selectedTown == null){
                    _selectedTown = _town.firstWhere((element) => element.number == _dropdownMenuItems[0].value);
                  }
                  return  DropdownButton(
                    value: _selectedTown.number,
                    items: _dropdownMenuItems,
                    onChanged: onChangeMunicipioItem,
                    style: TextStyle(color: Colors.black87, fontSize: 24.0),
                  );
                }),
            SizedBox(
              height: 5.0,
            ),
            Text('Actualmente: ${_selectedTown == null ? '' : _selectedTown.name}',
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
}
