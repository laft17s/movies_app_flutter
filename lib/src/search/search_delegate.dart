import 'package:flutter/material.dart';
import 'package:moviesapp/src/models/movie_model.dart';
import 'package:moviesapp/src/providers/movies_provider.dart';

class DataSearch extends SearchDelegate {
  String movieSelected = '';

  final moviesProvider = new MoviesProvider();

  final movies = [
    'The Batman',
    'Superman: Man of Steel',
    'Wonder Woman',
    'Batman v Superman: Down of Justice',
    'Justice League',
    'Aquaman'
  ];

  final lastMovies = ['The Batman', 'Batman v Superman: Down of Justice'];

  @override
  List<Widget> buildActions(BuildContext context) {
    // Acciones de mi AppBar

    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Ícono a la izquierda del AppBar

    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados a mostrar

    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.blueAccent,
        child: Text(movieSelected),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Sugerencias que aparecen al escribir

    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder(
      future: moviesProvider.searchMovie(query),
      // initialData: InitialData,
      builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
        if (snapshot.hasData) {
          final movies = snapshot.data;

          return ListView(
            children: movies.map((movie) {
              return ListTile(
                leading: FadeInImage(
                  image: NetworkImage(movie.getPosterImg()),
                  placeholder: AssetImage('assets/img/loading.gif'),
                  width: 50.0,
                  fit: BoxFit.contain,
                ),
                title: Text(movie.title),
                subtitle: Text(movie.originalTitle),
                onTap: () {
                  close(context, null);
                  movie.uniqueId = '';
                  Navigator.pushNamed(context, 'detail', arguments: movie);
                },
              );
            }).toList(),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  // @override
  // Widget buildSuggestions(BuildContext context) {
  //   // Sugerencias que aparecen al escribir

  //   final suggestList = (query.isEmpty)
  //       ? lastMovies
  //       : movies
  //           .where((m) => m.toLowerCase().startsWith(query.toLowerCase()))
  //           .toList();

  //   return ListView.builder(
  //       itemCount: suggestList.length,
  //       itemBuilder: (context, i) {
  //         return ListTile(
  //           leading: Icon(Icons.movie),
  //           title: Text(suggestList[i]),
  //           onTap: () {
  //             movieSelected = suggestList[i];
  //             showResults(context);
  //           },
  //         );
  //       });
  // }
}
