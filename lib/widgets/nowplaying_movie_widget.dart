import 'package:flutter/material.dart';
import 'package:movieapp/constant/text_constant.dart';
import 'package:movieapp/provider/movie_provider.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

class NowPlayingMovieWidget extends StatelessWidget {
  const NowPlayingMovieWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<MovieProvider>(
        context,
        listen: false,
      ).fetchMovies('now_playing'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        return Consumer<MovieProvider>(
          builder: (context, movieProvider, child) {
            final movies = movieProvider.getMovies('now_playing');
            return CarouselSlider.builder(
              options: CarouselOptions(
                height: 280,
                autoPlay: true,
                viewportFraction: 0.5,
                pageSnapping: true,
                enlargeCenterPage: true,
                autoPlayCurve: Curves.easeInOutCubicEmphasized,
                autoPlayAnimationDuration: const Duration(seconds: 2),
              ),
              itemCount: movies.length,
              itemBuilder: (context, index, realIndex) {
                final movie = movies[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/details', arguments: movie);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      '${TextConstants.imageUrl}${movie['poster_path']}',
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
