import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class Municipio {
  int id;
  String name;

  Municipio(this.id, this.name);

  static Stream<QuerySnapshot> getMunicipios() {
    return FirebaseFirestore.instance.collection("municipios").snapshots();
  }
}
