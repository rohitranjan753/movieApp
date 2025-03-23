import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movieapp/constant/text_constant.dart';
import 'package:movieapp/models/movie_model.dart';

/*This widget is used to display the details of the movie
  It takes the movie object as a parameter and displays the details of the movie
  The details include the movie poster, overview, release date, and rating */
class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key, required this.movie});

  final MovieModel movie;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            expandedHeight: 500,
            pinned: true,
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              background: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                child: CachedNetworkImage(
                  imageUrl: '${TextConstants.imageUrl}${movie.posterPath}',
                  errorWidget: (context, url, error) {
                    return const Icon(Icons.error);
                  },
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(TextConstants.overViewText,style: TextStyle(fontSize: 20),),
                  const SizedBox(height: 16),
                  Text(movie.overview),
                  const SizedBox(height: 16),
                  SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Text(TextConstants.releaseDateText),
                              Text(movie.releaseDate),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Text(TextConstants.ratingText),
                              Icon(Icons.star, color: Colors.amber),
                              Text(
                                '${movie.voteAverage.toStringAsFixed(1)}/10',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
