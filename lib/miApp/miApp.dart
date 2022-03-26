import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'PageRecetas.dart';


 bool cambio =false;
class miApp extends StatelessWidget {
  
  const miApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      title: "App de rectas",     
      debugShowCheckedModeBanner: false,
      color: Colors.red,
      home: inicio(),
    );
  }
}

_theme(cambio) {
  debugPrint("----------"+cambio.toString());
  }


class inicio extends StatefulWidget {
  inicio({Key? key}) : super(key: key);
   

  @override
  State<inicio> createState() => _inicioState();
}

class _inicioState extends State<inicio> {

  List recetas = [];
  Future<void> readJson() async {
    final String resultado = await rootBundle.loadString("assets/Recetas.json");
    final data = await jsonDecode(resultado);
    setState(() {
      recetas = data["recetas"];
      
    });
  }

  @override
  Widget build(BuildContext context) {
    readJson();

    return Scaffold(
      appBar: AppBar(
        title: Text("Recetas"),
        actions: [
          IconButton(onPressed:(){
              cambio =! cambio;
          _theme(cambio);
            debugPrint(cambio.toString());
          }, icon: Icon(Icons.accessible_forward_rounded) ,)          
        ],
        
      ),
      body: Column(
        children: [
          if (recetas.isNotEmpty)
            Expanded(
              child: ListView.builder(
                  itemCount: recetas.length,
                  itemBuilder: (context, index) {
                    return Card(

                      margin: EdgeInsets.all(50),                       
                      child: InkWell(
                        onTap: () {
                        final router = MaterialPageRoute(
                          builder:(context){
                            return new Receta(index);
                        },
                        );
                        Navigator.push(context, router);
                        },
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(recetas[index]["nombre"]),
                              subtitle: Text(recetas[index]["dificultad"]),
                            ),
                            Column(
                              children: [
                                Image.asset(recetas[index]["imagen"]),
                              ],
                            )
                          ],
                        ),
                      ),
                      
                    );
                  }),
            )
        ],
      ),
    );
  }
  
}
