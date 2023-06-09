import 'dart:convert';

import 'package:basededatos/ciudades.dart';
import 'package:basededatos/registro.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class InicioSesion extends StatefulWidget {
  const InicioSesion({Key? key}) : super(key: key);

  @override
  State<InicioSesion> createState() => _InicioSesionState();
}

class _InicioSesionState extends State<InicioSesion> {

  var c_correo = TextEditingController();
  var c_pass = TextEditingController();

  String correo = '';
  String pass = '';

  Future<void> guardar_datos(String correo, String pass) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('correo', correo);
    await prefs.setString('pass', pass);
  }

  Future<void> enviar_datos() async{
    var url = Uri.parse('https://xstracel.com.mx/basededatos/iniciar_sesion.php');
    var response = await http.post(url, body: {
      'correo': correo,
      'pass': pass
    }).timeout(Duration(seconds: 90));

    var respuesta = jsonDecode(response.body);

    if(respuesta["respuesta"] == '1'){
      SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setString('id', respuesta['id'].toString());

      guardar_datos(correo, pass);

      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context){
            return Ciudades();
          }));
    }else{
      print(response.body);
    }
  }

  Future<void> ver_datos() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    correo = (await prefs.getString('correo'))!;
    pass = (await prefs.getString('pass'))!;

    if(correo != null){
      if(correo != '' ){
        enviar_datos();
      }
    }
  }

  mostrar_alerta(mensaje){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Ciudades'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text(mensaje),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: (){
                Navigator.of(context).pop();
              }, child: Text('Aceptar')),
            ],
          );
        }
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ver_datos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(30),
            child: Column(
              children: [
                Center(
                  child: Text("¿Ya tienes una cuenta?",
                    style: TextStyle(fontSize: 25),),
                ),
                Center(
                  child: Text("Inicia Sesión",
                    style: TextStyle(fontSize: 25),),
                ),
                SizedBox(height: 20,),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Correo',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  controller: c_correo,
                ),
                SizedBox(height: 30,),
                TextField(
                  decoration: InputDecoration(
                    hintText: "contraseña"
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  controller: c_pass,
                ),
                SizedBox(height: 15,),
                ElevatedButton(onPressed: (){

                  correo = c_correo.text;
                  pass = c_pass.text;

                  if ( correo == '' || pass == '' ){
                    mostrar_alerta("Uno de los campos está vacio complétalos");
                  }else{
                    enviar_datos();
                  }
                }, child: Text("Enviar")),
                SizedBox(height: 15,),
                ElevatedButton(onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context){
                        return Registro();
                      }));
                }, child: Text("Registrarse"))
              ],
            ),
          )
        ],
      ),
    );
  }
}
