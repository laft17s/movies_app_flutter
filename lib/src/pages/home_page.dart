import 'package:flutter/material.dart';
import 'package:moviesapp/src/providers/movies_provider.dart';
import 'package:moviesapp/src/search/search_delegate.dart';
import 'package:moviesapp/src/widgets/card_swiper_widget.dart';
import 'package:moviesapp/src/widgets/lateral_cards_widget.dart';

class HomePage extends StatelessWidget {
  // const HomePage({Key key}) : super(key: key);

  final moviesProvider = new MoviesProvider();

  @override
  Widget build(BuildContext context) {
    moviesProvider.getPopularMovies();

    return Scaffold(
      /** APP BAR */
      appBar: AppBar(
        centerTitle: false, // no centra el texto
        title: Text('Películas en cines'), // título del app bar
        backgroundColor: Colors.red, // añade color de relleno al app bar
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search), // ícono de búsqueda
            onPressed: () {
              showSearch(
                context: context,
                delegate: DataSearch(),
                query: 'Busque su película...',
              );
            }, // acción al presionar
          )
        ],
      ),

      /** BODY */
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[_cardsSwiper(), _footer(context)],
        ),
      ),

      /** CÓDIGO COMENTADO NO USADO EN EL DESARROLLO */
      /*body: SafeArea(
        child: Text( ' Hola Mundo!! ' ), // imprime texto hola mundo
      )*/
    );
  }

  // MÉTODO _CARDSSWIPER
  Widget _cardsSwiper() {
    return FutureBuilder(
      future: moviesProvider.getNowPlaying(),
      // initialData: InitialData,
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return CardSwiperWidget(movies: snapshot.data);
        } else {
          return Container(
            height: 400.0,
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );

    //moviesProvider.getNowPlaying();
  }

  Widget _footer(BuildContext context) {
    return Container(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(left: 20.0),
                child: Text('Populares',
                    style: Theme.of(context).textTheme.subtitle1)),
            SizedBox(height: 5.0),
            StreamBuilder(
              stream: moviesProvider
                  .popularMoviesStream, // se obtiene las películas populares del flujo
              //initialData: InitialData,
              builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                if (snapshot.hasData) {
                  return LateralCardsWidget(
                    movies: snapshot.data,
                    nextPage: moviesProvider.getPopularMovies,
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }

                // si existe data en snapshot entonces se va a imprimir el título de cada
                // película existente dentro de la categoría populares.
                // snapshot.data?.forEach( ( element ) => print( element.title ) );

                // return Container();
              },
            ),
          ],
        ));
  }
}

/** COMENTARIOS ADICIONALES */

/**
 * SafeArea : Acomoda los widgets de manera que estén en un área visible en el 
 *            dispositivo.
 * 
 * La palabra BUILD en Flutter se puede asociar con la construcción de un 
 * WIDGET.
 * 
 * 
 * 
 */
