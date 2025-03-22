import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movieapp/constant/text_constant.dart';
import 'package:movieapp/models/movie_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class MovieProvider extends ChangeNotifier {
  final Map<String, List<MovieModel>> _movies = {};

  List<MovieModel> getMovies(String category) => _movies[category] ?? [];

  // Fetch Movies with Offline Support
  Future<void> fetchMovies(String category) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      await _loadCachedMovies(category);
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(
          '${TextConstants.baseApiUrl}/movie/$category?api_key=${TextConstants.apiKey}',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<MovieModel> movies =
            (data['results'] as List)
                .map((movie) => MovieModel.fromJson(movie))
                .toList();

        _movies[category] = movies;
        notifyListeners();

        // Cache the data locally
        await _cacheMovies(category, json.encode(data['results']));
      }
    } catch (e) {
      print("Error fetching movies: $e");
    }
  }

  // Search Movies with Offline Support
  Future<void> searchMovies(String query) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(
          '${TextConstants.baseApiUrl}/search/movie?api_key=${TextConstants.apiKey}&query=$query',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<MovieModel> movies =
            (data['results'] as List)
                .map((movie) => MovieModel.fromJson(movie))
                .toList();

        _movies['search'] = movies;
        notifyListeners();
      }
    } catch (e) {
      print("Error searching movies: $e");
    }
  }

  // Save movies to SharedPreferences
  Future<void> _cacheMovies(String category, String jsonMovies) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('movies_$category', jsonMovies);
  }

  // Load movies from SharedPreferences
  Future<void> _loadCachedMovies(String category) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString('movies_$category');

      if (cachedData != null) {
        final List<MovieModel> movies =
            (json.decode(cachedData) as List)
                .map((movie) => MovieModel.fromJson(movie))
                .toList();

        _movies[category] = movies;
        notifyListeners();
      }
    } catch (e) {
      print("Error loading cached movies: $e");
    }
  }
}
