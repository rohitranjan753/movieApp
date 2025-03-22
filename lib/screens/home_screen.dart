import 'package:flutter/material.dart';
import 'package:movieapp/constant/text_constant.dart';
import 'package:movieapp/screens/search_screen.dart';
import 'package:movieapp/widgets/nowplaying_movie_widget.dart';
import 'package:movieapp/widgets/popular_movie_widget.dart';
import 'package:movieapp/widgets/toprated_movie_widget.dart';
import 'package:movieapp/widgets/upcoming_movie_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(title: Text(TextConstants.appTitle),centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            // Add logout functionality here
            Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchScreen()));
          },
        ),
      ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20,
          children: [
              NowPlayingMovieWidget(), // Carousel for Now Playing movies
              PopularMovieWidget(),
              TopRatedMovieWidget(),
              UpcomingMovieWidget(),
          ],
        ),
      ),
    );
  }
}