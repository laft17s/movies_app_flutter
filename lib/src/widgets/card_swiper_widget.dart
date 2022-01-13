import 'package:flutter/material.dart';

import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:moviesapp/src/models/movie_model.dart';

class CardSwiperWidget extends StatelessWidget {
  //const CardSwiper({Key key}) : super(key: key);

  final List<Movie> movies;

  CardSwiperWidget({@required this.movies});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: 10.0),

      /** SWIPER */
      child: Swiper(
        layout: SwiperLayout.STACK,

        itemWidth: _screenSize.width * 0.70,
        itemHeight: _screenSize.height * 0.50,
        itemBuilder: (BuildContext context, int index) {
          movies[index].uniqueId = ' ${movies[index].id}-card ';

          return Hero(
            tag: movies[index].uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, 'detail',
                    arguments: movies[index]),
                child: FadeInImage(
                  placeholder: AssetImage('assets/img/loading.gif'),
                  image: NetworkImage(movies[index].getPosterImg()),
                  fit: BoxFit.cover,
                ),
              ),
              // child: Image.network("http://via.placeholder.com/350x150",fit: BoxFit.cover),
            ),
          );
        },
        itemCount: movies.length,
        // pagination: new SwiperPagination(),
        // control: new SwiperControl(),
      ),
    );
  }
}
