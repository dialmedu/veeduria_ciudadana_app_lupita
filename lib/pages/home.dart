import 'package:flutter/material.dart';
import 'package:lupita_ft/model/municipio.dart';
import 'package:lupita_ft/pages/form.dart';
import 'package:lupita_ft/pages/report.dart';

class Home extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
  double _size_box = 150.0;
  double _size_box_image = 150.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Text(
                  'Hola',
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
              ),
              buildSelect(),
              SizedBox(
                height: 5.0,
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: _buildCard(
                      'images/denunciar.jpg',
                      'Se parte de la veeduria ciudadana, reporte en LUPITA los casos de tu municipio',
                      'Denunciar',
                      goToFormPage,
                      Colors.green[100])),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: _buildCard(
                      'images/leer.jpg',
                      'Informate de las denuncias y noticias de tu municipio',
                      'Leer',
                      goToReportPage,
                      Colors.yellow[200])),
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
        ),
      ),
    );
  }

  void goToFormPage() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => FormPage()),
    );
  }

  void goToReportPage() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => ReportPage()),
    );
  }

  Widget _buildCard(String imagePatch, String text, String action,
      Function callback, Color boxColor) {
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
          height: MediaQuery.of(context).size.height / 3 > 250
              ? MediaQuery.of(context).size.height / 3
              : 180,
          width: MediaQuery.of(context).size.width * 0.9,
          child: Row(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.35,
                child: Image.asset(
                  imagePatch,
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                ),
              ),
              Container(
                decoration: BoxDecoration(color: boxColor),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.50,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(text,
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.black54,
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        color: Colors.green[600],
                      ),
                      width: _size_box,
                      height: 30,
                      child: Center(
                        child: Text(
                          action,
                          style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
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

  initList() async {
      setState(() {
        _dropdownMenuItems = buildDropdownMenuItems(_municipios);
        _selectedMunicipio = _dropdownMenuItems[0].value;
      });
  }

  onChangeMunicipioItem(Municipio selectedMunicipio) {
    setState(() {
      _selectedMunicipio = selectedMunicipio;
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
              stream: Municipio.getMunicipios(),
              builder: (context, snapshot){
              if (snapshot == null && !snapshot.hasData) {
                  return Text('Cargando Municipios...');
              }
              dynamic data = snapshot.data;
              // _municipios
              initList();
              return  DropdownButton(
                value: _selectedMunicipio == null ? new Municipio(0,'Seleccione Municipio') : _selectedMunicipio,
                items: _dropdownMenuItems,
                onChanged: onChangeMunicipioItem,
                style: TextStyle(color: Colors.black87, fontSize: 24.0),
              );
            }),
            SizedBox(
              height: 5.0,
            ),
            Text('Actualmente: ${_selectedMunicipio == null ? '' : _selectedMunicipio.name}',
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
