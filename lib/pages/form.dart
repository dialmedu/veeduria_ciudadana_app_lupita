import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lupita_ft/components/button_components.dart';
import 'package:lupita_ft/model/denuncia.dart';
import 'package:lupita_ft/model/municipio.dart';
import 'package:lupita_ft/pages/from_message.dart';

class FormPage extends StatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  Denuncia denuncia = new Denuncia(1, 'Los patios');
  bool _continuar = false;
  bool _guardando = false;

  TextEditingController _descripcion, _nombre, _documento;
  DatabaseReference _firebase;

  @override
  void initState() {
    super.initState();
    initList();
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
          LButtons.buttonPrimary("Guardar Denuncia", saveDenuncia, context)
        ],
      ),
    ));
  }

  Future<void> saveDenuncia() async {
    // todo save on firebase
    String nombres = _nombre.text;
    String documento = _documento.text;
    String descripcion = _descripcion.text;
    DateTime today = new DateTime.now();
    String dateSlug =
        "${today.year.toString()}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";

    Map<String, String> denuncia = {
      'nombres': nombres,
      'documento': documento,
      'descripcion': descripcion,
      'municipio': _selectedMunicipio.name,
      'municipio_id': _selectedMunicipio.id.toString(),
      'fecha': dateSlug,
      'user': 'anonimo'
    };

    _firebase.push().set(denuncia).then((value) {
      goToFormMessagePage();
    });
  }

  void goToFormMessagePage() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => FormMessagePage()),
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
}
