import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lupita_ft/model/NotificationItem.dart';
import 'package:lupita_ft/model/township.dart';
import 'package:lupita_ft/pages/form.dart';
import 'package:lupita_ft/pages/report.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../model/township.dart';

class Home extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
  double _size_box = 150.0;
  double _size_box_image = 150.0;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  Widget _buildDialog(BuildContext context, NotificationItem item) {
    return AlertDialog(
      content: Text("${item.matchteam} with score: ${item.score}"),
      actions: <Widget>[
        FlatButton(
          child: const Text('CLOSE'),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        FlatButton(
          child: const Text('SHOW'),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ],
    );
  }

  final Map<String, NotificationItem> _items = <String, NotificationItem>{};
  NotificationItem _itemForMessage(Map<String, dynamic> message) {
    final dynamic data = message['data'] ?? message;
    final String itemId = data['id'];
    final NotificationItem item = _items.putIfAbsent(itemId, () => NotificationItem(itemId: itemId))
      ..matchteam = data['matchteam']
      ..score = data['score'];
    return item;
  }

  void _showItemDialog(Map<String, dynamic> message) {
    showDialog<bool>(
      context: context,
      builder: (_) => _buildDialog(context, _itemForMessage(message)),
    ).then((bool shouldNavigate) {
      if (shouldNavigate == true) {
        _navigateToItemDetail(message);
      }
    });
  }

  void _navigateToItemDetail(Map<String, dynamic> message) {
    final NotificationItem item = _itemForMessage(message);
    // Clear away dialogs
    Navigator.popUntil(context, (Route<dynamic> route) => route is PageRoute);
    if (!item.route.isCurrent) {
      Navigator.push(context, item.route);
    }
  }

  @override
  void initState() {
    super.initState();
    initFirebaseMessage();
  }

  void initFirebaseMessage(){
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        _showItemDialog(message);
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        _navigateToItemDetail(message);
      },
    );

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
                sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);

      print("Push Messaging token: $token");
    });
    _firebaseMessaging.subscribeToTopic("matchscore");
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
      MaterialPageRoute(builder: (context) => ReportPage(), settings: RouteSettings(
        arguments: _selectedMunicipio,
      )),
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

  List<Township> _municipios;
  List<DropdownMenuItem<int>> _dropdownMenuItems;
  Township _selectedMunicipio;

  initList() {
      _dropdownMenuItems = buildDropdownMenuItems(_municipios);
      if(_selectedMunicipio == null){
          _selectedMunicipio = _municipios.firstWhere((element) => element.id == _dropdownMenuItems[0].value);
      }
  }

  onChangeMunicipioItem(int selectedMunicipio) {
    setState(() {
      _selectedMunicipio = _municipios.firstWhere((element) => element.id == selectedMunicipio);
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
              _municipios = snapshot.data.docs.map((e) => new Township(e.data()['municipio_id'], e.data()['nombre'])).toList();
              _dropdownMenuItems = buildDropdownMenuItems(_municipios);
              if(_selectedMunicipio == null){
                _selectedMunicipio = _municipios.firstWhere((element) => element.id == _dropdownMenuItems[0].value);
              }
              return  DropdownButton(
                value: _selectedMunicipio.id,
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

// ignore: missing_return
Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }
  // Or do other work.
}
