class RegistrosCiudades{

  String? id;
  String? usuario;
  String? ciudad;

  RegistrosCiudades(this.id, this.usuario, this.ciudad);

  RegistrosCiudades.fromJson(Map<String, dynamic> json){
    id = json["id"].toString();
    usuario =json['usuario'];
    ciudad = json['ciudad'];
  }
}