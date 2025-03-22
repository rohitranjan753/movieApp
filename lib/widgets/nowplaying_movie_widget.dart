import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movieapp/constant/text_constant.dart';
import 'package:movieapp/provider/movie_provider.dart';
import 'package:movieapp/screens/details_screen.dart';
import 'package:movieapp/widgets/movie_card_shimmer.dart';
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
          return SizedBox(
            height: 200,
            child: MovieCardShimmer());
        }
        return Consumer<MovieProvider>(
          builder: (context, movieProvider, child) {
            final movies = movieProvider.getMovies('now_playing');
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 10,left: 10,right: 10),
                  child: Text(
                    TextConstants.nowPlayingMovies,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                CarouselSlider.builder(
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailsScreen(movie: movie),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl:
                              '${TextConstants.imageUrl}${movie.posterPath}',
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
