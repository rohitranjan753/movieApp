import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movieapp/constant/text_constant.dart';
import 'package:movieapp/models/movie_model.dart';

class MovieProvider extends ChangeNotifier {
  String baseUrl = 'https://api.themoviedb.org/3';
  final Map<String, List<MovieModel>> _movies = {};

  List<MovieModel> getMovies(String category) => _movies[category] ?? [];

  Future<void> fetchMovies(String category) async {
    if (_movies.containsKey(category)) return; // Prevent redundant API calls

    final response = await http.get(
      Uri.parse('$baseUrl/movie/$category?api_key=${TextConstants.apiKey}'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<MovieModel> movies =
          (data['results'] as List)
              .map((movie) => MovieModel.fromJson(movie))
              .toList();

      _movies[category] = movies;
      notifyListeners();
    }
  }
}
