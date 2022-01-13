import 'package:flutter/material.dart';
import 'package:moviesapp/src/models/movie_model.dart';

class LateralCardsWidget extends StatelessWidget {
  // const LateralCardsWidget({Key key}) : super(key: key);

  final List<Movie> movies; // declaro una lista de películas

  final Function nextPage;

  LateralCardsWidget({@required this.movies, @required this.nextPage});

  final _pageController =
      new PageController(initialPage: 1, viewportFraction: 0.3);

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context)
        .size; // obtengo el valor del tamaño de la pantalla

    _pageController.addListener(() {
      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent - 200) {
        nextPage();
      }
    });

    return Container(
      height: _screenSize.height *
          0.25, // ocupo el 20% del contenido de la pantalla

      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        itemCount: movies.length,
        itemBuilder: (context, i) => _renderingCard(context, movies[i]),

        //children: _cards( context ),
      ),
    );
  }

  Widget _renderingCard(BuildContext context, Movie movie) {
    movie.uniqueId = ' ${movie.id}-popular ';

    final card = Container(
      margin: EdgeInsets.only(
          right: 15.0), // separación, hacia la derecha, de 15px entre cartas
      child: Column(children: <Widget>[
        Hero(
          tag: movie.uniqueId,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              placeholder: AssetImage('assets/img/loading.gif'),
              image: NetworkImage(movie.getPosterImg()),
              fit: BoxFit.cover,
              height: 160.0,
            ),
          ),
        ),
        SizedBox(height: 5.0),
        Text(
          movie.title,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.caption,
        )
      ]),
    );

    return GestureDetector(
      child: card,
      onTap: () {
        Navigator.pushNamed(context, 'detail', arguments: movie);
      },
    );
  }

  // List<Widget> _cards ( context ) {

  //   return movies.map( ( movie ) {

  //     return Container(

  //       margin: EdgeInsets.only( right: 15.0 ), // separación, hacia la derecha, de 15px entre cartas
  //       child: Column(
  //         children: <Widget> [

  //           ClipRRect(
  //             borderRadius: BorderRadius.circular( 20.0 ),
  //             child: FadeInImage(
  //               placeholder: AssetImage( 'assets/img/loading.gif' ),
  //               image: NetworkImage( movie.getPosterImg() ),
  //               fit: BoxFit.cover,
  //               height: 160.0,
  //             ),
  //           ),

  //           SizedBox( height: 5.0 ),
  //           Text(
  //             movie.title,
  //             overflow: TextOverflow.ellipsis,
  //             style: Theme.of(context).textTheme.caption,
  //           )

  //         ]
  //       ),
  //     );

  //   }).toList();

  // }

}
