import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:moviesapp/src/models/actor_movie.dart';
import 'dart:convert';
import 'package:moviesapp/src/models/movie_model.dart';

class MoviesProvider {
  // --------------------------------------------------------------------------------------------------- //

  String _apikey = 'YOUR_API_KEY'; // llave
  String _url = 'api.themoviedb.org'; // centraliza las peticiones
  String _language = 'es-ES'; // lenguaje en el que se va a visualizar

  bool _loadingPopularMovies =
      false; // variable que determina el estado de carga de las películas

  int _pagePopularMovies = 0; // declaro la variable que controla la paginación

  // --------------------------------------------------------------------------------------------------- //

  List<Movie> _movies = new List(); // lista de películas populares

  final _moviesStreamController =
      StreamController<List<Movie>>.broadcast(); // flujo de películas

  Function(List<Movie>) get popularMoviesSink =>
      _moviesStreamController.sink.add;

  Stream<List<Movie>> get popularMoviesStream => _moviesStreamController.stream;

  void disposeStreams() {
    _moviesStreamController?.close();
  }

  Future<List<Movie>> _makeAnAnswer(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final movies = new Movies.fromJsonList(decodedData['results']);

    return movies.movies;
  }

  Future<List<Movie>> getNowPlaying() async {
    final url = Uri.https(_url, '3/movie/now_playing',
        {'api_key': _apikey, 'language': _language});

    return await _makeAnAnswer(url);

    // final resp = await http.get(url);
    // final decodedData = json.decode( resp.body );

    // // print( decodedData[ 'results' ] );

    // final movies = new Movies.fromJsonList(decodedData[ 'results' ]);

    // return movies.movies;
  }

  Future<List<Movie>> getPopularMovies() async {
    if (_loadingPopularMovies) return [];

    _loadingPopularMovies = true;

    _pagePopularMovies++;

    print("Next Movies...");

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key': _apikey,
      'language': _language,
      'page': _pagePopularMovies.toString()
    });

    final resp = await _makeAnAnswer(url);

    _movies.addAll(resp);
    popularMoviesSink(_movies);

    _loadingPopularMovies = false;

    return resp;
  }

  Future<List<Actor>> getCast(String movieId) async {
    final url = Uri.https(_url, '3/movie/$movieId/credits',
        {'api_key': _apikey, 'language': _language});

    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);

    final cast = new Cast.fromJsonList(decodedData['cast']);

    return cast.actors;
  }

  Future<List<Movie>> searchMovie(String query) async {
    final url = Uri.https(_url, '3/search/movie',
        {'api_key': _apikey, 'language': _language, 'query': query});

    return await _makeAnAnswer(url);
  }
}
