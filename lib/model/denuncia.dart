import 'dart:io';

class Denuncia {
  int id;
  String municipio;
  String descripcion;
  String documento;
  String nombre;
  String fecha;
  List<String> archivos;
  List<File> uploads;

  Denuncia(this.id, this.municipio);

  static List<Denuncia> getDenuncias() {
    return <Denuncia>[
      Denuncia(1, 'Los Patios'),
      Denuncia(2, 'Villa del Rosario'),
      Denuncia(3, 'Cucuta'),
      Denuncia(4, 'San Calletano'),
      Denuncia(5, 'Buscarasica'),
    ];
  }
}
