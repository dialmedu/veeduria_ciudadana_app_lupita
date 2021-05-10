

import 'package:cloud_firestore/cloud_firestore.dart';

class Town {
  int number;
  String id;
  String name;
  String summary;
  List cards;

  Town(this.number, this.name,this.summary);
  Town.fromData(String id, Map<String, dynamic> data){
    if(data != null){
      this.number = data['numero'] ?? 0;
      this.name = data['nombre'] ?? '';
      this.summary = data['descripcion'] ?? '';
      this.cards = data['datos'] ?? List.empty(growable: true);
      this.id = id;
    }
  }

  static Stream<QuerySnapshot> getTowns() {
    return FirebaseFirestore.instance.collection("municipios").snapshots();
  }

  Stream<QuerySnapshot> getTownPage() {
    return FirebaseFirestore.instance.collection("municipios").doc(this.id).collection("pagina").orderBy("numero", descending: true).snapshots();
  }
}
