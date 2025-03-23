import 'package:flutter/material.dart';
import 'package:movieapp/constant/text_constant.dart';
import 'package:movieapp/screens/search_screen.dart';
import 'package:movieapp/widgets/nowplaying_movie_widget.dart';
import 'package:movieapp/widgets/popular_movie_widget.dart';
import 'package:movieapp/widgets/toprated_movie_widget.dart';
import 'package:movieapp/widgets/upcoming_movie_widget.dart';

/*
  This widget is used to display the home screen of the app
  It displays the Now Playing, Popular, Top Rated, and Upcoming movies

  Once the user is signed in, this screen will be displayed
  The user can search for movies by clicking on the search icon
*/
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(TextConstants.appTitle),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // We will navigate to the search screen when the search icon is clicked
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20,
          children: [
            // Widget for displaying the Now Playing movies
            NowPlayingMovieWidget(),
            // Widget for displaying the Popular movies
            PopularMovieWidget(),
            // Widget for displaying the Top Rated movies
            TopRatedMovieWidget(),
            // Widget for displaying the Upcoming movies
            UpcomingMovieWidget(),
          ],
        ),
      ),
    );
  }
}
