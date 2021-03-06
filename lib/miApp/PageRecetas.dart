import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'miApp.dart';

int totals = 1;
bool isChecked = false;

class Receta extends StatefulWidget {
  final int index;
  
  const Receta(this.index); // recogemos el index que le pasamos de miApp

  @override
  State<Receta> createState() => _RecetaState();
}

class _RecetaState extends State<Receta> {
  List recetas = []; // creamos los arrays para poder recorrer la receta los pasos y los ingredientes
  List ingredientes = [];
  List pasos = [];
  bool selected = false;
  List<bool> checkFalse = []; // creamos un array
  bool mostrarVideo = false;
  bool mostrarFoto = true;
  

  late VideoPlayerController _controller;

  @override
  void initState() {
    
    
    _controller = VideoPlayerController.asset('assets/mi.mp4');

    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {}));
    _controller.pause();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> readJson() async {
    final String resultado =
        await rootBundle.loadString("assets/Recetas.json"); // cargamos el Json
    final data = await jsonDecode(resultado);
    setState(() {
      recetas = data["recetas"];
      ingredientes = data["recetas"][widget.index]["ingredientes"]; // accede a la descodificacion del json que se llama data 
      // y accede al array de recetas en la posicion que le indicamos y dentro de esta posicion esta ingredientes que nos permite acceder a los ingredientes 
      // que mostramos en pantalla a los "hijos de ingredientes"
      pasos = data["recetas"][widget.index]["Elaboracion"]; // lo mismo que ingredientes pero con elaboracion
      checkFalse.add(false); // añadimos todos los valores a false
    });
  }

  @override
  Widget build(BuildContext context) {
    readJson();
    String titulo = recetas[widget.index]["nombre"];

    return Scaffold(
        appBar: AppBar(
          centerTitle: true, // para centrar el titulo
          title: Text(titulo),
          backgroundColor: Colors.green[400], // le damos color al appbar para diferenciar aun mas el cambio de psetaña
          actions: [
            IconButton(
              onPressed: () {
                scheduleMicrotask( // para ir a la pagina de inicio es decir a miApp
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
            child: Column(children: [
          Column(children:[
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
                        "dificultad: " + recetas[widget.index]["dificultad"]), 
                  ),
                  Column(
                    children: [
                      Visibility( // ocultamos el contenido con visibility 
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(top: 20.0),
                            ),
                            Container(
                              padding: const EdgeInsets.all(20),
                              child: AspectRatio(
                                aspectRatio: _controller.value.aspectRatio,
                                child: Stack(
                                  alignment: Alignment.bottomCenter, // para que este centrado el video
                                  children:[
                                    VideoPlayer(_controller),
                                    ClosedCaption(
                                        text: _controller.value.caption.text),
                                    VideoProgressIndicator(_controller,
                                        allowScrubbing: true), // para indicar por donde esta el video
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              children: [

                             IconButton(
                          onPressed: () { // icono para poder ocultar el video y que se muestre la foto 
                            mostrarVideo = false;
                            mostrarFoto = true;
                            _controller.pause(); // para no reproducir el video en segundo plano
                          },
                          icon: Icon(Icons.exit_to_app)),
                           IconButton(
                          onPressed: () { // Pause
                            _controller.pause(); // para no reproducir el video en segundo plano
                          },
                          icon: Icon(Icons.pause)),
                             IconButton(
                          onPressed: () { // Play
                            _controller.play(); // para no reproducir el video en segundo plano
                          },
                          icon: Icon(Icons.play_arrow_outlined)),
                              ],
                            )
                          ],
                          
                        ),
                        visible: mostrarVideo, // para poder ocutar el video 
                      ),
                    
                      Visibility(
                        child: Column(
                          children: [
                            Image.asset(recetas[widget.index]["imagen"]),
                              IconButton(
                          onPressed: () { // para mostrar el video y que se ponga en play y ocultar la foto
                            mostrarVideo = true;
                            mostrarFoto = false;
                            _controller.play();
                          },
                          icon: Icon(Icons.play_arrow)),
                          ],
                        ),
                        visible: mostrarFoto,
                      ),
                      Column(
                        children: [
                          ListTile(
                            tileColor: Colors.green[200],
                            title: Text("INGREDIENTES"),
                          ),
                          Row(
                            children: [ // mientras le des clik va a restar una variable para poder multiplicar el resultado 
                              IconButton(
                                onPressed: () {
                                  if (totals >= 2) {
                                    totals--;
                                  }
                                },
                                icon: Icon(Icons.remove),
                              ),
                              IconButton( // suma una variable hasta un maximo de 5
                                onPressed: () {
                                  if (totals <= 4) {
                                    totals++;
                                  }
                                },
                                icon: Icon(Icons.add),
                              ),
                              Text('Para ${totals} '),// mostramos el resultado para que el usuario sepa para cuantas personas son esas recetas
                              Icon(Icons.person), 
                            ],
                          ),
                        ],
                      ),
                      Container(
                        height: 570,
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: ingredientes.length,
                          itemBuilder: (BuildContext context, int index) { // es basicamente la misma funcion que miApp pero un poco diferente
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween, // agregamos espacio
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start, //para que este al principio
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            launch(ingredientes[index]["link"]); // para que vaya a comprar el ingrediente con el icono
                                          },
                                          icon: Icon(
                                              Icons.shopping_cart_outlined),
                                        )
                                      ],
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start, // estarà al lado de el icon de comprar el ingrediente
                                        children: [
                                          Text(ingredientes[index]["Nombre"]), // mostramos el nombre del ingrediente.
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text((ingredientes[index]["Cantidad"] * totals)
                                            .toString()),
                                      ],
                                    )),
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(("   " + ingredientes[index]["tipo"])
                                            .toString()),
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
                  ),
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
                                  ' Paso: ${index +1}',
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
                                      checkFalse[index] = !checkFalse[
                                          index]; // y cambiamos valor.
                                    });
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      )),
                  ListTile(
                    title: Text(
                      "OTRAS RECETAS",
                      textScaleFactor: 1.8,
                    ),
                  ),
                  Column(
                    children: [
                      if (recetas.isNotEmpty)
                        SizedBox(
                          height: 300,
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
                                          subtitle: Text(
                                              recetas[index]["dificultad"]),
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
              ),
            )
          ])
        ])));
  }
}
