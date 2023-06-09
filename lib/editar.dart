import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class Editar extends StatefulWidget {
  String id;
  Editar(this.id, {Key? key}) : super(key: key);


  @override
  State<Editar> createState() => _EditarState();
}

class _EditarState extends State<Editar> {

  var c_nombre = new TextEditingController();
  var c_precio = new TextEditingController();
  var c_descripcion = new TextEditingController();

  String? nombre = "";
  String? precio = "";
  String? descripcion = "";

  editar_producto() async {
    //print('Lista: '+nombre!+'--'+precio!+'--'+descripcion!);
    var url = Uri.parse('https://xstracel.com.mx/basededatos/editar_producto.php');
    var response = await http.post(url, body: {
      'id' : widget.id,
      'nombre': nombre,
      'precio': precio,
      'descripcion': descripcion
    }).timeout(Duration(seconds: 90));

    if (response.body == '1'){
      Navigator.of(context).pop();
      mostrar_alerta("Se editó el producto correctamente");
      c_nombre.text = "";
      c_precio.text = "";
      c_descripcion.text = "";
    }else{
      mostrar_alerta(response.body);
    }
  }

  mostrar_alerta(mensaje){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("Amazon"),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text(mensaje),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
                child: Text("Aceptar"),
              ),
            ],
          );
        }
    );
  }

  Future mostrar_datos() async{
    var url = Uri.parse('https://xstracel.com.mx/basededatos/ver_producto.php');
    var response = await http.post(url, body: {
      'id': widget.id
    }).timeout(Duration(seconds: 90));

    var datos = jsonDecode(response.body);

    c_nombre.text = datos['nombre'];
    c_precio.text = datos['precio'].toString();
    c_descripcion.text = datos['descripcion'];
  }

  void _showLoading() async {
    setState(() {
      SmartDialog.showLoading();
    });
    editar_producto().then((value){
      setState(() {
        SmartDialog.dismiss();
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mostrar_datos();
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){

        final FocusScopeNode focus = FocusScope.of(context);
        if(!focus.hasPrimaryFocus && focus.hasFocus){
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: Container(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Editar Productos"),
          ),
          body: ListView(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                child: Column(
                  children: [
                    TextField(
                      controller: c_nombre,
                      decoration: InputDecoration(
                        hintText: "Nombre de Producto",
                      ),
                    ),
                    SizedBox(height: 20,),
                    TextField(
                      controller: c_precio,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Precio",
                      ),
                    ),
                    SizedBox(height: 20,),
                    TextField(
                      controller: c_descripcion,
                      decoration: InputDecoration(
                        hintText: "Descripción",
                      ),
                    ),
                    SizedBox(height: 30,),
                    ElevatedButton(
                        onPressed: (){

                          nombre = c_nombre.text;
                          precio = c_precio.text;
                          descripcion = c_descripcion.text;

                          if (nombre == "" || precio == "" || descripcion == ""){
                            mostrar_alerta("Debes llenar todos los datos");
                          }else{
                            editar_producto();
                            _showLoading();
                          }
                        },
                        child: Text("Editar")),

                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
