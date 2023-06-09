import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'registros_ciudad.dart';

class Mostrar_Ciudades extends StatefulWidget {
  const Mostrar_Ciudades({Key? key}) : super(key: key);

  @override
  State<Mostrar_Ciudades> createState() => _Mostrar_CiudadesState();
}

class _Mostrar_CiudadesState extends State<Mostrar_Ciudades> {

  bool loading = true;
  String? usuario;

  List<RegistrosCiudades> reg = [];

  Future<void> tomar_datos() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      usuario = prefs.getString('id');
      print(usuario);
    });
  }

  Future<List<RegistrosCiudades>> mostrar_ciudad() async{

    var url = Uri.parse('https://xstracel.com.mx/basededatos/mostrar_ciudad.php');
    var response = await http.post(url, body: {
      'usuario': usuario
    }).timeout(Duration(seconds: 90));

    final datos = jsonDecode(response.body);
    List<RegistrosCiudades> registros = [];

    for(var dato in datos){
      registros.add(RegistrosCiudades.fromJson(dato));
    }
    return registros;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tomar_datos().then((value) => mostrar_ciudad());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ciudades"),
      ),
      body: loading == true ?
          const Center(
            child: CircularProgressIndicator(),
          )
          :reg.isEmpty?
          Center(
            child: Text("No tienes Ciudades guardadas"),
          )
          :ListView.builder(
        itemCount: reg.length,
        itemBuilder: (BuildContext contextn, int index){
          return Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 1, color: Colors.grey,)
                )
            ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(reg[index].ciudad!, style: TextStyle(
                      fontSize: 16,
                    ),),
                  ),
                ],
              ),
            ),
          );
        },
      )
    );
  }
}
