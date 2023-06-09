import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Ciudades extends StatefulWidget {
  const Ciudades({Key? key}) : super(key: key);

  @override
  State<Ciudades> createState() => _CiudadesState();
}

class _CiudadesState extends State<Ciudades> {

  var c_ciudad = new TextEditingController();

  String? ciudad;
  String? id_usuario;

  Future<void> tomar_datos() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      id_usuario = prefs.getString('id');
      print(id_usuario);
    });

  }

  Future<void> guardar() async{
    var url = Uri.parse("https://xstracel.com.mx/basededatos/save_city.php");
    var response = await http.post(url, body: {
      'ciudad': ciudad,
      'usuario': id_usuario
    }).timeout(Duration(seconds: 90));

    if(response.body == '1'){
      print('Se subió correctamente');
      c_ciudad.text = "";
    }else{
      print(response.body);
    }

  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tomar_datos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ciudades"),
      ),
      body: ListView(
        padding: EdgeInsets.all(50),
        children: [
          SizedBox(height: 50,),
          TextField(
            controller: c_ciudad,
          ),
          SizedBox(height: 40,),
          ElevatedButton(onPressed: (){
            ciudad = c_ciudad.text;
            guardar();
          }, child: Text("Guardar")),
          ElevatedButton(onPressed: (){

          }, child: Text("Ver ciudades"))
        ],
      ),
    );
  }
}
