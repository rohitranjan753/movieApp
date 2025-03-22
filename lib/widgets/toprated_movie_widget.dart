import 'package:flutter/material.dart';
import 'package:movieapp/constant/text_constant.dart';
import 'package:movieapp/provider/movie_provider.dart';
import 'package:movieapp/widgets/movie_card.dart';
import 'package:movieapp/widgets/movie_card_shimmer.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class TopRatedMovieWidget extends StatelessWidget {
  const TopRatedMovieWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 10,left: 10,right: 10),
          child: Text(
            TextConstants.topRatedMovies,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 200,
          child: FutureBuilder(
            future: Provider.of<MovieProvider>(
              context,
              listen: false,
            ).fetchMovies('top_rated'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return MovieCardShimmer();
              }
              return Consumer<MovieProvider>(
                builder: (context, movieProvider, child) {
                  final movies = movieProvider.getMovies('top_rated');
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
