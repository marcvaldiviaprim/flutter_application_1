/*
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class inicio extends StatefulWidget {
  inicio({Key? key}) : super(key: key);

  @override
  State<inicio> createState() => _inicioState();
}

class _inicioState extends State<inicio> {
  List recetas = [];
  Future<void> readJson() async {
    final String resultado = await rootBundle.loadString("/Recetas.json");
    final data = await jsonDecode(resultado);
    setState(() {
      recetas = data["recetas"];
    });
    
    @override
    Widget build(BuildContext context) {
      return _inicioState;
    }

Widget card1(recetas) {
  var heading = 'Nombre Receta';

  return Scaffold(
    body: Column(
      children: [
       
      ],
    ),

  );





  // return Card(
  //   elevation: 4.0,
  //   child: InkWell(
  //     onTap: () => {},
  //     child: Column(
  //       children: [
  //         ListTile(
  //           title: Text(heading),
  //         ),
  //         Container(
  //           height: 200.0,
  //           child: Ink.image(
  //             image: cardImage,
  //             fit: BoxFit.cover,
  //           ),
  //         ),
  //       ],
  //     ),
  //   ),
  // );
}*/