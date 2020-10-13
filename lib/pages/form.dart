import 'dart:io';

import 'package:file_picker/file_picker.dart';
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
                : buildFomr(),
          ],
        ),
      ),
    );
  }

  void _addFiles() async {
    FilePickerResult result =
        await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      File file = File(result.files.single.path);
      setState(() => denuncia.uploads.add(file));
    }
  }

  InputDecoration decorationTextField({String hintText}) {
    return new InputDecoration(
        border: new OutlineInputBorder(
          borderSide: new BorderSide(color: Colors.teal),
        ),
        hintText: hintText);
  }

  Widget buildFomr() {
    return Container(
        child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Descripción:', textAlign: TextAlign.left),
          TextField(
            decoration: decorationTextField(
                hintText: 'Agrega una descripción de tu denuncia'),
            maxLines: 8,
          ),
          SizedBox(
            height: 50.0,
          ),
          Text('Tu nombre:', textAlign: TextAlign.left),
          TextField(
            maxLines: 1,
            decoration:
                decorationTextField(hintText: 'Ingrese nombres y apellidos'),
          ),
          SizedBox(
            height: 50.0,
          ),
          Text('Tu documento:', textAlign: TextAlign.left),
          TextField(
            maxLines: 1,
            decoration:
                decorationTextField(hintText: 'Ingrese numero de documento'),
          ),
          SizedBox(
            height: 50.0,
          ),
          LButtons.buttonPrimary(
              "Guardar Denuncia", goToFormMessagePage, context)
        ],
      ),
    ));
  }

  void goToFormMessagePage() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => FormMessagePage()),
    );
  }

  List<Widget> _getList() {
    List<Widget> list = new List();
    if (denuncia.uploads != null) {
      denuncia.uploads.forEach((File file) {
        final tempWidget = ListTile(
          title: Text(file.path.split('/').last),
          leading: Icon(Icons.label),
          trailing: Radio(
            value: 1,
            groupValue: 0,
            onChanged: (value) {
              // Update value.
              final index = denuncia.uploads.indexOf(file);
              setState(() => denuncia.uploads.removeAt(index));
            },
          ),
        );
        list.add(tempWidget);
      });
    }
    return list;
  }

  List<Municipio> _municipios;
  List<DropdownMenuItem<Municipio>> _dropdownMenuItems;
  Municipio _selectedMunicipio;

  initList() {
    _municipios = Municipio.getMunicipios();
    _dropdownMenuItems = buildDropdownMenuItems(_municipios);
    _selectedMunicipio = _dropdownMenuItems[0].value;
  }

  onChangeDropdownItem(Municipio selectedMunicipio) {
    setState(() {
      _selectedMunicipio = selectedMunicipio;
    });
  }

  Widget buildSelect() {
    initList();
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
            Text('actualmente: ${_selectedMunicipio.name}'),
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
