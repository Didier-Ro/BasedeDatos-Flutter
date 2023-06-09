import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:image_cropper/image_cropper.dart';

class Camara extends StatefulWidget {
  const Camara({Key? key}) : super(key: key);

  @override
  State<Camara> createState() => _CamaraState();
}

class _CamaraState extends State<Camara> {

  File? imagen = null;
  final picker = ImagePicker();
  Dio dio = new Dio();



  selinmagen(opc) async{
    var pickedFile;

    if(opc ==1){
      pickedFile = await picker.pickImage(source: ImageSource.camera);
    }else{
      pickedFile = await picker.pickImage(source: ImageSource.gallery);
    }

    setState(() {
      if(pickedFile != null){
        imagen = File(pickedFile.path);
      }else{
        print("No se encontró nada");
      }
    });
  }

  Future<void> subirImagen()async{
    try{
      String filename = imagen!.path.split('/').last;

      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          imagen!.path, filename: filename
        )
      });

      await dio.post('https://xstracel.com.mx/basededatos/subir_imagen.php',
      data: formData).then((value){
        if(value.toString() == '1'){
          print("Se subió la imagen correctamente");
        }else{
          print(value.toString());
        }
      });

    }catch(e){
      print(e.toString());
    }
  }

  seleccionar(){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            contentPadding: EdgeInsets.all(0),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  InkWell(
                    onTap: (){
                      selinmagen(1);
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(width: 1, color: Colors.grey)
                          )
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text('Tomar una foto', style: TextStyle(
                                fontSize: 16
                            ),),
                          ),
                          Icon(Icons.camera_alt, color: Colors.blue,)
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      selinmagen(2);
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(width: 1, color: Colors.grey)
                          )
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text('Seleccionar de Galeria', style: TextStyle(
                                fontSize: 16
                            ),),
                          ),
                          Icon(Icons.image, color: Colors.blue,)
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: EdgeInsets.all(20),
                      color: Colors.red,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Tomar una foto', style: TextStyle(
                              fontSize: 16,
                              color: Colors.white
                          ),),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camara'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            SizedBox(height: 30,),
            ElevatedButton(
              onPressed:() {
                seleccionar();
              },
              child: Text('Tomar Foto'),
            ),
            SizedBox(height: 20,),
            ElevatedButton(
              onPressed:() {

              },
              child: Text('Subir Foto'),
            ),
            SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }
}
