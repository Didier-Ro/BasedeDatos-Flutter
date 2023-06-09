import 'dart:convert';
import 'package:basededatos/editar.dart';
import 'package:basededatos/registros.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Productos extends StatefulWidget {
  const Productos({Key? key}) : super(key: key);

  @override
  State<Productos> createState() => _ProductosState();
}

class _ProductosState extends State<Productos> {

  bool loading = true;

  List<Registros> reg = [];

  Future<List<Registros>> mostrar_productos() async{

    var url = Uri.parse('https://xstracel.com.mx/basededatos/mostrar_productos.php');
    var response = await http.post(url).timeout(Duration(seconds: 90));

    //print(response.body);
    final datos = jsonDecode(response.body);

    List<Registros> registros = [];

   for(var dato in datos){
      registros.add(Registros.fromJson(dato));
    }

    return registros;
  }

  msm_eliminar(id, nombre){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("Amazon"),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text("Realmente quieres eliminar?"),
                  Text(nombre),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
                child: Text("Cancelar"),
              ),
              TextButton(
                onPressed: (){
                  Navigator.of(context).pop();
                  eliminar_producto(id);
                },
                child: Text("Aceptar"),
              ),
            ],
          );
        }
    );
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

  Future eliminar_producto(id) async{

    var url = Uri.parse("https://xstracel.com.mx/basededatos/eliminar_productos.php");
    var response = await http.post(url, body: {"id": id}).timeout(Duration(seconds: 90));

    if(response.body == '1'){
      mostrar_alerta("Tu producto se eliminó correctamente");
      setState(() {
        loading = true;
        reg = [];
        mostrar_productos().then((value){
          setState(() { //funciona para recargar las variables
            reg.addAll(value);
            loading = false;
          });
        });
      });
    }else{
      mostrar_alerta(response.body);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mostrar_productos().then((value){
      setState(() {//funciona para recargar las variables
        reg.addAll(value);
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Productos"),
      ),
      body: loading == true ?
          const Center(
            child: CircularProgressIndicator(),
          )
          : reg.isEmpty ?
          Center(
            child: Text("No tienes ningun producto registrado"),
          )
          :ListView.builder(

          itemCount: reg.length,
          itemBuilder: (BuildContext context, int index){
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
                    child: Text(reg[index].nombre!, style: TextStyle(
                      fontSize: 16,
                    ),),
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context){
                            return Editar(reg[index].id!);
                          }
                      )).then((value){
                        setState(() {
                          loading = true;
                          reg = [];
                          mostrar_productos().then((value){
                            setState(() { //funciona para recargar las variables
                              reg.addAll(value);
                              loading = false;
                            });
                          });
                        });
                      });
                    },
                    child: Icon(Icons.edit, color: Colors.amber,),
                  ),
                  SizedBox(width: 12,),
                  InkWell(
                    onTap: (){
                      msm_eliminar(reg[index].id, reg[index].nombre);
                    },
                    child: Icon(Icons.delete, color: Colors.red,),
                  )
                ],
              ),
            ),
          );
      }
      )
    );
  }
}
