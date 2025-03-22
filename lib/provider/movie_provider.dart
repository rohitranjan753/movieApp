import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movieapp/constant/text_constant.dart';

class MovieProvider extends ChangeNotifier {
  String baseUrl = 'https://api.themoviedb.org/3';
  final Map<String, List<dynamic>> _movies = {};

  List<dynamic> getMovies(String category) => _movies[category] ?? [];

  Future<void> fetchMovies(String category) async {
    if (_movies.containsKey(category)) return; // Prevent redundant API calls

    final response = await http.get(Uri.parse('$baseUrl/movie/$category?api_key=${TextConstants.apiKey}'));
    if (response.statusCode == 200) {
      _movies[category] = json.decode(response.body)['results'];
      notifyListeners();
    }
  }
}