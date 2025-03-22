import 'package:flutter/material.dart';
import 'package:movieapp/main.dart';
import 'package:movieapp/provider/movie_provider.dart';
import 'package:provider/provider.dart';

class PopularMoviesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return 
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text('Popular Movies', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        Container(
          height: 200,
          child: FutureBuilder(
            future: Provider.of<MovieProvider>(context, listen: false).fetchMovies('popular'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
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
