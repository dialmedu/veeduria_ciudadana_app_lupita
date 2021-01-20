import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class Township {
  int id;
  String name;

  Township(this.id, this.name);

  static Stream<QuerySnapshot> getTownships() {
    return FirebaseFirestore.instance.collection("municipios").snapshots();
  }
}
