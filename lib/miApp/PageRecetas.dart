import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'miApp.dart';

int totals = 1;
bool isChecked = false;

class Receta extends StatefulWidget {
  int index;

  Receta(
    this.index,
  ); // recogemos el index que le pasamos de miApp

  @override
  State<Receta> createState() => _RecetaState();
}

class _RecetaState extends State<Receta> {
  List recetas = [];
  List cu = [];
  List pasos = [];
  bool selected = false;
  List<bool> checkFalse = []; // creamos un array

  Future<void> readJson() async {
    final String resultado =
        await rootBundle.loadString("assets/Recetas.json"); // cargamos el Json
    final data = await jsonDecode(resultado);
    setState(() {
      recetas = data["recetas"];
      cu = data["recetas"][widget.index]["ingredientes"];
      pasos = data["recetas"][widget.index]["Elaboracion"];
      checkFalse.add(false); // añadimos todos los valores a false
    });
  }

  @override
  Widget build(BuildContext context) {
    readJson();
    String titulo = recetas[widget.index]["nombre"];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(titulo),
        backgroundColor: Colors.green[400],
        actions: [
          IconButton(
            onPressed: () {
              scheduleMicrotask(
                () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => miApp(),
                  ),
                ),
              );
            },
            icon: Icon(Icons.home),
          )
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          
          Container(
              padding: EdgeInsets.all(30),
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.all(1)),
                  ListTile(
                    title: Text(
                      recetas[widget.index]["nombre"],
                    ),
                    subtitle: Text(
                        "Dificultad: " + recetas[widget.index]["dificultad"]),
                  ),
                  
                  Image.asset(recetas[widget.index]["imagen"]),
                  Column(
                    children: [
                      ListTile(
                        title: Text("INGREDIENTES"),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              if (totals >= 2) {
                                totals--;
                              }
                            },
                            icon: Icon(Icons.remove),
                          ),
                          IconButton(
                            onPressed: () {
                              if (totals <= 4) {
                                totals++;
                              }
                            },
                            icon: Icon(Icons.add),
                          ),
                          Text('Para ${totals} '),
                          Icon(Icons.person),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    height: 450,
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: cu.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        launch(cu[index]["link"]);
                                      },
                                      icon: Icon(Icons.shopping_cart_outlined),
                                    )
                                  ],
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(cu[index]["Nombre"]),
                                    ],
                                  ),
                                ),
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text((cu[index]["Cantidad"] * totals)
                                        .toString()),
                                  ],
                                )),
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                        ("   " + cu[index]["tipo"]).toString()),
                                  ],
                                )),
                              ],
                            )
                          ],
                        );
                      },
                    ),
                  )
                ],
              )),
          Container(
              height: 1200,
              margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
              child: ListView.builder(
                // physics: NeverScrollableScrollPhysics(),
                itemCount: pasos.length,
                itemBuilder: (BuildContext context, int index) {
                  checkFalse[
                      index]; // le pasamos el index es decir todas las posiciones para  utilizarlas
                  return Container(
                    padding: EdgeInsets.all(20),
                    // width: EdgeInsets.all(20);
                    child: Column(
                      children: [
                        SizedBox(
                          width: 40,
                        ),
                        Divider(
                          thickness: 5,
                        ),
                        Text(
                          ' Paso: ${index}',
                          textScaleFactor: 1.7,
                        ),
                        Text(
                          pasos[index]["paso"],
                          textScaleFactor: 1.3,
                        ),
                        Checkbox(
                          checkColor: Colors.white,
                          value: checkFalse[
                              index], // recorremos el index para recoger un valor solo.
                          onChanged: (value) {
                            setState(() {
                              checkFalse[index] =
                                  !checkFalse[index]; // y cambiamos valor.
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              )),
          ListTile(
            
            title: Text("OTRAS RECETAS", textScaleFactor: 1.8,),
          ),
          Column(
            children: [
              if (recetas.isNotEmpty)
                SizedBox(
                  height: 500,
                  width: 500,
                  child: PageView.builder(
                      controller: PageController(viewportFraction: 1.1),
                      itemCount: recetas.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: EdgeInsets.fromLTRB(40, 40, 40, 0),
                          child: InkWell(
                            onTap: () {
                              final router = MaterialPageRoute(
                                builder: (context) {
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
                                    Image.asset(
                                      recetas[index]["imagen"],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                )
            ],
          ),
        ],
      )),
    );
  }
}
