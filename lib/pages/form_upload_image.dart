import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lupita_ft/components/button_components.dart';
import 'package:lupita_ft/model/complaint.dart';
import 'package:lupita_ft/model/township.dart';
import 'package:lupita_ft/pages/from_message.dart';
import 'package:path/path.dart' as p;

class FormPage extends StatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  Complaint denuncia = new Complaint(1, 'Los patios');
  bool _continuar = false;
  bool _guardando = false;

  TextEditingController _descripcion, _nombre, _documento, _image;
  DatabaseReference _firebase;
  StorageReference _firebaseStorage;

  File _imageFile;
  final picker = new ImagePicker();

  @override
  void initState() {
    super.initState();
    initList();
    initControllers();
    initFirebase();
  }

  void initFirebase() {
    _firebase = FirebaseDatabase.instance.reference().child("Denuncias");
    _firebaseStorage = FirebaseStorage.instance.ref();
  }

  void initControllers() {
    _descripcion = new TextEditingController();
    _nombre = new TextEditingController();
    _documento = new TextEditingController();
  }

  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }

  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = p.basename(_imageFile.path);
    var mountainImagesRef  = _firebaseStorage.child('uploads/$fileName');
    StorageUploadTask uploadTask = mountainImagesRef.putFile(_imageFile);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    taskSnapshot.ref.getDownloadURL().then(
          (value)  {
            _image.text = value.toString();
            print("Done: $value");
          }
    );
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
          SizedBox(height: 20.0),
          Expanded(
            child: Stack(
              children: <Widget>[
                Container(
                  height: double.infinity,
                  margin: const EdgeInsets.only(
                      left: 30.0, right: 30.0, top: 10.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: _imageFile != null
                        ? Image.file(_imageFile)
                        : FlatButton(
                      child: Icon(
                        Icons.add_a_photo,
                        color: Colors.green[600],
                        size: 50,
                      ),
                      onPressed: pickImage,
                    ),
                  ),
                ),
              ],
            ),
          ),
          LButtons.buttonSecundary("Agregar Imagen", uploadImageToFirebase, context),
          LButtons.buttonPrimary("Guardar Denuncia", saveComplaint, context)
        ],
      ),
    ));
  }

  Widget uploadImageButton(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            padding:
            const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
            margin: const EdgeInsets.only(
                top: 30, left: 20.0, right: 20.0, bottom: 20.0),
            decoration: BoxDecoration(
                color: Colors.green[600],
                borderRadius: BorderRadius.circular(30.0)),
            child: FlatButton(
              onPressed: () => uploadImageToFirebase(context),
              child: Text(
                "Agregar Imagen",
                style: TextStyle(fontSize: 20,color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
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
      'municipio': _selectedTownship.name,
      'municipio_id': _selectedTownship.id.toString(),
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

  List<Township> _township;
  List<DropdownMenuItem<int>> _dropdownMenuItems;
  Township _selectedTownship;

  initList() {
    _dropdownMenuItems = buildDropdownMenuItems(_township);
    if(_selectedTownship == null){
      _selectedTownship = _township.firstWhere((element) => element.id == _dropdownMenuItems[0].value);
    }
  }

  onChangeMunicipioItem(int selectedMunicipio) {
    setState(() {
      _selectedTownship = _township.firstWhere((element) => element.id == selectedMunicipio);
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
                stream: Township.getTownships(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                  if (!snapshot.hasData) {
                    return Text('Cargando Municipios...');
                  }
                  _township = snapshot.data.docs.map((e) => new Township(e.data()['municipio_id'], e.data()['nombre'])).toList();
                  _dropdownMenuItems = buildDropdownMenuItems(_township);
                  if(_selectedTownship == null){
                    _selectedTownship = _township.firstWhere((element) => element.id == _dropdownMenuItems[0].value);
                  }
                  return  DropdownButton(
                    value: _selectedTownship.id,
                    items: _dropdownMenuItems,
                    onChanged: onChangeMunicipioItem,
                    style: TextStyle(color: Colors.black87, fontSize: 18.0),
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
    for (Township municipio in municipios) {
      items.add(
        DropdownMenuItem(
          value: municipio.id,
          child: Text(municipio.name),
        ),
      );
    }
    return items;
  }
}
