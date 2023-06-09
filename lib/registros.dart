class Registros{

  String? id;
  String? nombre;
  String? precio;
  String? descripcion;

  Registros(this.id, this.nombre, this.precio, this.descripcion);

  Registros.fromJson(Map<String, dynamic> json){
    id = json["id"].toString();
    nombre = json["nombre"].toString();
    precio = json["precio"].toString();
    descripcion = json["descripcion"].toString();
  }
}