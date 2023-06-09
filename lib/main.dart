import 'package:basededatos/camara.dart';
import 'package:basededatos/inicio_sesion.dart';
import 'package:basededatos/registro.dart';
import 'package:flutter/material.dart';
import 'alta_productos.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: InicioSesion(),
      navigatorObservers: [FlutterSmartDialog.observer],
      builder: FlutterSmartDialog.init(),
    );
  }
}
