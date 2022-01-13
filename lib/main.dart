import 'package:flutter/material.dart';
import 'package:moviesapp/src/pages/home_page.dart';
import 'package:moviesapp/src/pages/movieDetail_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // remueve banner debug
      title: 'Movies App', // Título de la aplicación
      initialRoute: '/', // Ruta inicial
      routes: {
        '/': (BuildContext context) => HomePage(), // ruta home_page
        'detail': (BuildContext context) =>
            MovieDetail(), // ruta movieDetail_page
      },
    );
  }
}
