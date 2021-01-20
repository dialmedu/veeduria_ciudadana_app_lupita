import 'dart:io';

class Complaint {
  int id;
  String municipio;
  String descripcion;
  String documento;
  String nombre;
  String fecha;
  List<String> archivos;
  List<File> uploads;

  Complaint(this.id, this.municipio);
}
