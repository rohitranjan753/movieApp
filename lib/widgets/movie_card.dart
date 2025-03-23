import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movieapp/constant/text_constant.dart';
import 'package:movieapp/models/movie_model.dart';
import 'package:movieapp/screens/details_screen.dart';

/*
  This is a MovieCard Widget.
  This widget is used to show movie card in home screen.
  We will use this widget in home screen to show movie card.
*/
class MovieCard extends StatelessWidget {
  final MovieModel movie;
  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, 
        PageRouteBuilder(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return ScaleTransition(
              scale: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
              child: child,
            );
          },
          pageBuilder: (context, animation, secondaryAnimation) {
          return DetailsScreen(movie: movie);
        })
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        width: 130,
        child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: '${TextConstants.imageUrl}${movie.posterPath}',
                fit: BoxFit.cover,
              ),
            ),
      ),
    );
  }
}