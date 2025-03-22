import 'package:flutter/material.dart';
import 'package:movieapp/constant/text_constant.dart';
import 'package:movieapp/provider/movie_provider.dart';
import 'package:movieapp/screens/details_screen.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          Provider.of<MovieProvider>(
            context,
            listen: false,
          ).searchMovies('');
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(TextConstants.searchTitle),centerTitle: true,),
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
                  return 
                      Expanded(
                        child: GridView.builder(
                          itemCount: movies.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                // Add navigation to movie details screen here
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailsScreen(movie: movies[index])));
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  '${TextConstants.imageUrl}${movies[index].posterPath}',
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset('assets/movie_placeholder.jpg',fit: BoxFit.cover,);
                                  },
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
