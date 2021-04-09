import 'package:flutter/material.dart';
import 'publicaciones.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nubimetrics',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: Publicaciones(),
    );
  }
}


