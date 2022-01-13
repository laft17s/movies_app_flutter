import 'package:flutter/material.dart';
import 'package:moviesapp/src/models/actor_movie.dart';
import 'package:moviesapp/src/models/movie_model.dart';
import 'package:moviesapp/src/providers/movies_provider.dart';

class MovieDetail extends StatefulWidget {
  // MovieDetail({Key key}) : super(key: key);

  @override
  _MovieDetailState createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  @override
  Widget build(BuildContext context) {
    final Movie movie = ModalRoute.of(context)
        .settings
        .arguments; // recibe argumentos de la página anterior

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _createAppBar(context, movie),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(height: 10.0), // separación
              _posterTitleMovie(movie),
              _descriptionMovie(movie),
              _castingMovie(movie),
            ]),
          )
        ],
      ),
    );
  }

  Widget _createAppBar(BuildContext context, Movie movie) {
    return SliverAppBar(
      elevation: 2.0, //
      backgroundColor: Colors.indigoAccent, // color de fondo
      expandedHeight: 200.0, // expansión
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          movie.title, // título de la película
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
        background: FadeInImage(
          image: NetworkImage(movie.getBackDropImg()),
          placeholder: AssetImage('assets/img/loading.gif'),
          fadeInDuration: Duration(milliseconds: 20),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _posterTitleMovie(Movie movie) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: <Widget>[
          Hero(
            tag: movie.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image(
                image: NetworkImage(movie.getPosterImg()),
                height: 150.0,
              ),
            ),
          ),
          SizedBox(width: 20.0),
          Flexible(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                movie.title,
                style: Theme.of(context).textTheme.headline6,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                movie.originalTitle,
                style: Theme.of(context).textTheme.subtitle1,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                children: <Widget>[
                  Icon(Icons.star_border),
                  Text(movie.voteAverage.toString())
                ],
              )
            ],
          ))
        ],
      ),
    );
  }

  Widget _descriptionMovie(Movie movie) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Text(
        movie.overview,
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _castingMovie(Movie movie) {
    final movieProvider = new MoviesProvider();

    return FutureBuilder(
        future: movieProvider.getCast(movie.id.toString()),
        builder: (context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasData) {
            return _actorsPageView(snapshot.data);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget _actorsPageView(List<Actor> actors) {
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        pageSnapping: false,
        controller: PageController(initialPage: 1, viewportFraction: 0.3),
        itemCount: actors.length,
        itemBuilder: (context, i) => _actorCard(actors[i]),
      ),
    );
  }

  Widget _actorCard(Actor actor) {
    return Container(
      child: Column(children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: FadeInImage(
            placeholder: AssetImage('assets/img/loading.gif'),
            image: NetworkImage(actor.getActorImg()),
            height: 150.0,
            fit: BoxFit.cover,
          ),
        ),
        Text(
          actor.name,
          overflow: TextOverflow.ellipsis,
        ),
      ]),
    );
  }
}

// Slivers reaccionan al hacer scroll
