import 'package:flutter/material.dart';
import 'package:movieapp/constant/text_constant.dart';
import 'package:movieapp/provider/movie_provider.dart';
import 'package:movieapp/widgets/movie_card.dart';
import 'package:movieapp/widgets/movie_card_shimmer.dart';
import 'package:provider/provider.dart';

/*
  This is a PopularMovieWidget Widget.
  This widget is used to show popular movies in home screen.
  We will use this widget in home screen to show popular movies.
*/
class PopularMovieWidget extends StatelessWidget {
  const PopularMovieWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return 
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 10,left: 10,right: 10),
          child: Text(TextConstants.popularMovies, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 200,
          child: FutureBuilder(
            future: Provider.of<MovieProvider>(context, listen: false).fetchMovies('popular'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {                                // Show the shimmer if the data is loading
                return MovieCardShimmer();
              }
              return Consumer<MovieProvider>(
                builder: (context, movieProvider, child) {
                  final movies = movieProvider.getMovies('popular');
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      return MovieCard(movie: movies[index]);
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
