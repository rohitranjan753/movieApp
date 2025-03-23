import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movieapp/constant/image_constant.dart';
import 'package:movieapp/constant/text_constant.dart';
import 'package:movieapp/provider/movie_provider.dart';
import 'package:movieapp/screens/details_screen.dart';
import 'package:movieapp/widgets/grid_view_shimmer.dart';
import 'package:provider/provider.dart';

/*
  This widget is used to display the search screen
  It takes the search query as input and displays the search results
*/
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          Provider.of<MovieProvider>(context, listen: false).searchMovies('');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(TextConstants.searchTitle),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            spacing: 20,
            children: [
              TextField(
                onChanged: (value) {
                  Provider.of<MovieProvider>(
                    context,
                    listen: false,
                  ).searchMovies(value);
                },
                decoration: InputDecoration(
                  hintText: TextConstants.searchHintText,
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              Consumer<MovieProvider>(
                builder: (
                  BuildContext context,
                  MovieProvider movieProvider,
                  Widget? child,
                ) {
                  final movies = movieProvider.getMovies('search');
                  // First check if the movies list is empty and the search query is not empty
                  // If the movies list is empty and the search query is not empty, then display the loading shimmer
                  if (movies.isEmpty &&
                      movieProvider.searchStringQuery.isNotEmpty) {
                    if (movieProvider.isLoading) {                                       // If the api is in loading state, display the shimmer
                      return GridViewShimmer();
                    }else if(movieProvider.errorString.isNotEmpty){                     // If there is an error, display the error message
                      return Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error,
                              size: 50,
                            ),
                            Text(
                              movieProvider.errorString,
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      );

                    }
                    // If there are no movies found, display the no movie found image
                    return Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            ImageConstant.noMovie,
                            height: 250,
                            width: 250,
                          ),
                          Text(
                            TextConstants.noMovieFoundText,
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    );
                  }

                  // If the movies list is not empty, display the movies
                  // Movies list will be displayed in a grid view
                  return Expanded(
                    child: GridView.builder(
                      itemCount: movies.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionsBuilder: (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) {
                                  return ScaleTransition(
                                    scale: Tween<double>(
                                      begin: 0.0,
                                      end: 1.0,
                                    ).animate(animation),
                                    child: child,
                                  );
                                },
                                pageBuilder: (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                ) {
                                  return DetailsScreen(movie: movies[index]);
                                },
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              errorWidget: (context, url, error) {
                                return Image.asset(
                                  ImageConstant.moviePlaceholder,
                                  fit: BoxFit.cover,
                                );
                              },
                              imageUrl:
                                  '${TextConstants.imageUrl}${movies[index].posterPath}',
                            ),
                          ),
                        );
                      },
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 0.7,
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 15,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
