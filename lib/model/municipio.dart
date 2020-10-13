class Municipio {
  int id;
  String name;

  Municipio(this.id, this.name);

  static List<Municipio> getMunicipios() {
    return <Municipio>[
      Municipio(1, 'Los Patios'),
      Municipio(2, 'Villa del Rosario'),
      Municipio(3, 'Cucuta'),
      Municipio(4, 'San Calletano'),
      Municipio(5, 'Buscarasica'),
    ];
  }
}
