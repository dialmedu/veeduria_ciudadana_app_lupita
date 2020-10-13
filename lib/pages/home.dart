import 'package:flutter/material.dart';
import 'package:lupita_ft/model/municipio.dart';
import 'package:lupita_ft/pages/form.dart';

class Home extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
  double _size_box = 150.0;
  double _size_box_image = 200.0;

  @override
  void initState() {
    super.initState();
    initList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          RichText(
            text: TextSpan(children: <TextSpan>[
              TextSpan(text: 'Hola', style: TextStyle(color: Colors.black))
            ]),
          ),
          buildSelect(),
          SizedBox(
            height: 5.0,
          ),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: _buildCard(
                  'images/denunciar.jpg',
                  'Se parte de la veeduria ciudadana',
                  'Denunciar',
                  goToFormPage)),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: _buildCard(
                  'images/leer.jpg', 'Hacer Denuncia', 'Leer', _showDialog)),
          Center(
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(),
            ),
          ),
        ],
      ),
    );
  }

  void goToFormPage() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => FormPage()),
    );
  }

  Widget _buildCard(
      String imagePatch, String text, String action, Function callback) {
    return Padding(
      padding: EdgeInsets.only(top: 15.0, bottom: 5.0, left: 5.0, right: 5.0),
      child: InkWell(
        onTap: callback,
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 5.0),
            ],
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
          ),
          height: MediaQuery.of(context).size.height / 3,
          width: MediaQuery.of(context).size.width - 50,
          child: Row(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                height: _size_box,
                width: _size_box_image,
                child: Image.asset(
                  imagePatch,
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 5.0, vertical: 15.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: _size_box,
                        height: 150,
                        child: Text(text),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          color: Colors.greenAccent,
                        ),
                        width: _size_box,
                        height: 30,
                        child: Center(
                          child: Text(
                            'Continuar',
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
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

// user defined function
  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Mensaje"),
          content: new Text(
              "Este función se encuentra en desarrollo, vuelve más tarde."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Cerrar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
