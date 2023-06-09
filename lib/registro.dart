import 'dart:convert';

import 'package:basededatos/ciudades.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Registro extends StatefulWidget {
  const Registro({Key? key}) : super(key: key);

  @override
  State<Registro> createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {

  var c_usuario = TextEditingController();
  var c_correo = TextEditingController();
  var c_pass = TextEditingController();

  String? usuario = '';
  String correo = '';
  String pass = '';

  Future<void> guardar_datos(String correo, String pass) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('correo', correo);
    await prefs.setString('pass', pass);
  }

  Future<void> registrarme() async{
    var url = Uri.parse('https://xstracel.com.mx/basededatos/registrar_usuario.php');

    print(usuario);
    print(correo);
    print(pass);

    var response = await http.post(url, body: {
      'usuario': usuario,
      'correo': correo,
      'pass': pass
    }).timeout(Duration(seconds: 90));

    var respuesta = jsonDecode(response.body);

    print(response.body);

    if (respuesta["respuesta"] == '1'){

      SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setString('id', respuesta['id'].toString());

      guardar_datos(correo, pass);

      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context){
            return Ciudades();
          }));
    }else{
      print(respuesta["respuesta"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registro"),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(30),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Usuario'
                  ),
                  controller: c_usuario,
                ),
                SizedBox(height: 15,),
                TextField(
                    decoration: InputDecoration(
                      hintText: 'Correo',
                    ),
                  controller: c_correo,
                ),
                SizedBox(height: 15,),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Password',
                  ),
                  controller: c_pass,
                ),
                SizedBox(height: 15,),
                ElevatedButton(
                    onPressed: (){
                      usuario = c_usuario.text;
                      correo = c_correo.text;
                      pass = c_pass.text;


                      if (usuario == '' || correo == '' || pass == ''){
                        print("Debes llenar todos los datos");
                      }else{
                        registrarme();
                      }
                    },
                    child: Text("Registrarme"))
              ],
            ),
          )
        ],
      ),
    );
  }
}
