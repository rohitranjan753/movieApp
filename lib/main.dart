import 'package:flutter/material.dart';
import 'package:movieapp/constant/text_constant.dart';
import 'package:movieapp/provider/auth_provider.dart';
import 'package:movieapp/provider/movie_provider.dart';
import 'package:movieapp/widgets/nowplaying_movie_widget.dart';
import 'package:movieapp/widgets/popular_movie_widget.dart';
import 'package:movieapp/widgets/toprated_movie_widget.dart';
import 'package:movieapp/widgets/upcoming_movie_widget.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MovieProvider()),
      ],
      child: MaterialApp(
        title: 'TMDB Movies',
        theme: ThemeData.dark(),
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return authProvider.isAuthenticated ? HomeScreen() : LoginScreen();
          },
        ),
        routes: {
          '/search': (context) => SearchScreen(),
          '/details': (context) => DetailsScreen(),
        },
      ),
    );
  }
}



class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Provider.of<AuthProvider>(context, listen: false).login(
                  emailController.text,
                  passwordController.text,
                );
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

// home_screen.dart

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Movies')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             NowPlayingMovieWidget(), // Carousel for Now Playing movies
              // SizedBox(height: 20),
              PopularMoviesList(),
              TopRatedMoviesList(),
              UpcomingMoviesList(),
          ],
        ),
      ),
    );
  }
}

// search_screen.dart

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search Movies')),
      body: Center(child: Text('Search functionality here')), // Placeholder
    );
  }
}

// details_screen.dart

class DetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Movie Details')),
      body: Center(child: Text('Movie details here')), // Placeholder
    );
  }
}

// movie_list.dart

class MovieList extends StatelessWidget {
  final String category;
  MovieList({required this.category});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<MovieProvider>(context, listen: false).fetchMovies(category),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        return Consumer<MovieProvider>(
          builder: (context, movieProvider, child) {
            final movies = movieProvider.getMovies(category);
            return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                return MovieCard(movie: movies[index]);
              },
            );
          },
        );
      },
    );
  }
}

// movie_card.dart

class MovieCard extends StatelessWidget {
  final dynamic movie;
  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      width: 120,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network('${TextConstants.imageUrl}${movie['poster_path']}'),
          ),
          SizedBox(height: 4),
          // Text(movie['title'] ?? 'No Title', style: TextStyle(fontSize: 12)),
          // Text(movie['release_date'] ?? 'Unknown Date', style: TextStyle(fontSize: 10)),
        ],
      ),
    );
  }
}
