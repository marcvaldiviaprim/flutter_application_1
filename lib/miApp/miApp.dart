
// importamos las librerias necesarias
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'PageRecetas.dart';

 bool _isDark = false; // methodo para saber si esta modo oscuro o no
 

class miApp extends StatelessWidget {
  
  const miApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(  // creamos un materialApp
      title: "App de rectas", 
      debugShowCheckedModeBanner: false,
      color: Colors.red,
      home: inicio(),
    );
  }
}


class inicio extends StatefulWidget {
  inicio({Key? key}) : super(key: key);
 
  @override
  State<inicio> createState() => _inicioState();
}

class _inicioState extends State<inicio> { 
    // para cambiar el thema cremoas un themedata que sea modo oscuro y light con sus colores.

  ThemeData _light = ThemeData.light().copyWith(
    primaryColor: Colors.green[400],
  );
  ThemeData _dark = ThemeData.dark().copyWith(
    primaryColor: Colors.red,
  );
  List recetas = []; // creamos una lista recetas para el json
  
  Future<void> readJson() async { // cremos un future para leer el json
    final String resultado = await rootBundle.loadString("assets/Recetas.json"); // archivo donde esta el json
    final data = await jsonDecode(resultado); // descodificamos el json
    setState(() {
      recetas = data["recetas"]; // guardamos el resultado de la descodificacion del json a una variable recetas el 
      // Data["recetas"] coge el valor de recetas es decir todo el json

      
    });
  }

  @override
  Widget build(BuildContext context) { 
    readJson();

    return MaterialApp( // creamos un materialApp
       darkTheme: _dark, // le decimos si es modo oscuro o 
      theme: _light,// modo normal "sin modo oscuro" 
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light, // cambiamos si es true la variable _isDark si esta en un modo o en otro
      debugShowCheckedModeBanner: false,
      home: Scaffold( // creamos un scaffold con un appbar
      
      appBar: AppBar(
        backgroundColor: Colors.green[400], // añadimos color
    
        title: Text("Recetas"), 
        actions: [
          // en esta funcion se cambia el valor de true a false el _isDark con un botton
            CupertinoSwitch(
                  value: _isDark,
                  onChanged: (v) {
                    setState(() {
                      _isDark = !_isDark;
                    });
                  },
                ),         
        ],
        
      ),
   
      body: Column( // aqui esta todo el cuerpo de la pagina 
        children: [ // creamos un children para poder crear diferentes widgets dentro de column
          
          if (recetas.isNotEmpty) // mientras no sea null repitelo 
            Expanded(
              child: ListView.builder( // creamos un linstViewBuilder para que si hay muchas cards no se corte la imagen 
                  itemCount: recetas.length, // tiene 2 valores obligatorios itemCount y itemBuilder
                  // recetas.lenght miramos la largada que tiene recetas si tiene 4 repetira 4 veces 
                  itemBuilder: (context, index) { // le pasamos un context y un index para saber la posicion que esta repitiendo index = 0 , 1, 2, 3 ejemplo 
                    return Card(
                      color: Colors.green[400], // le damos colores a la card
                      shape: RoundedRectangleBorder( // con borde redondo
                      borderRadius: BorderRadius.circular(20)),
                      margin: EdgeInsets.fromLTRB(40, 15, 40, 0), //un margen Left top right buttom                   
                      child: InkWell( // un inkWell para poder hacer click en la targeta
                           splashColor: Colors.blue[200], // añadimos un color cuando estas punsando
                        onTap: () { // funcion para clicar
                        Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Receta(index),
                                  ),
                                ); // aqui estamos creando una receta y le pasamos el index para poder saber que receta hay que mostrar
                        },
                        child: 
                           Column(
                          children: [
                            ListTile( //list que creamos contiene el json descodificado.
                              title: Text(recetas[index]["nombre"]), // recogemos el index que al ser la pimera vez sera 0 y recoge el nombre del json
                              subtitle: Text( "Dificultad: " + recetas[index]["dificultad"]), // lo mismo con dificultad
                            ),
                            Column(
                              children: [
                                Image.asset(recetas[index]["imagen"],),                                
                              ],
                            ),
                            
                          ],
                        ),

                        ));
                        },
                     
                      ),
                    )
        ],
      ),
      )
    );
  }
  
}
