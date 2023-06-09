import 'package:flutter/material.dart';
import 'productos.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class Alta_Productos extends StatefulWidget {
  const Alta_Productos({Key? key}) : super(key: key);

  @override
  State<Alta_Productos> createState() => _Alta_ProductosState();
}

class _Alta_ProductosState extends State<Alta_Productos> {

  var c_nombre = new TextEditingController();
  var c_precio = new TextEditingController();
  var c_descripcion = new TextEditingController();

  String? nombre = "";
  String? precio = "";
  String descripcion = "";

  subir_producto() async {
    //print('Lista: '+nombre!+'--'+precio!+'--'+descripcion!);

    var url = Uri.parse('https://xstracel.com.mx/basededatos/guardar_productor.php');
    var response = await http.post(url, body: {
      'nombre': nombre,
      'precio': precio,
      'descripcion': descripcion
    }).timeout(Duration(seconds: 90));

    if (response.body == '1'){
      mostrar_alerta("Se guardó el producto correctamente");
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

  void _showLoading() async {
    setState(() {
      SmartDialog.showLoading();
    });
    subir_producto().then((value){
      setState(() {
        SmartDialog.dismiss();
      });
    });
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
            title: Text("Alta Productos"),
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
                            _showLoading();
                          }
                        },
                        child: Text("Guardar")),
                    SizedBox(height: 30,),
                    ElevatedButton(onPressed: (){
                      Navigator .of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context){
                            return Productos();
                        }
                        )
                      );
                    }, child: Text("Ver Productos"))
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