import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movieapp/constant/text_constant.dart';
import 'package:movieapp/models/movie_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class MovieProvider extends ChangeNotifier {
  String _searchStringQuery = '';
  String get searchStringQuery => _searchStringQuery;

  String _errorString='';
  String get errorString=>_errorString;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  final Map<String, List<MovieModel>> _movies = {};

  List<MovieModel> getMovies(String category) => _movies[category] ?? [];

  // This method fetches the movies for a given category from the API and stores them in the _movies map.
  // If there is no internet, we will try to get data from cache
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
      }else{
        // If there is internet but the response is not 200, we will try to load the cached data
        await _loadCachedMovies(category);
      }
    } catch (e) {
      print("Error fetching movies: $e");
    }
  }


  // This method searches for movies based on the query provided.
  // It fetches the movies from the API and stores them in the _movies map.

  // If status code is not 200, then it will set the errorString to Something went wrong.
  // If there is no internet connection, the method returns without doing anything.
  Future<void> searchMovies(String query) async {
    _searchStringQuery = query;
    _isLoading = true;
    notifyListeners();
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      _isLoading = false;
      notifyListeners();
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
      }else{
        _errorString=TextConstants.errorFetchingMovies;
      }
    } catch (e) {
      print("Error searching movies: $e");
    }
    _isLoading = false;
    notifyListeners();
  }

  // Caches the movies for a given category in SharedPreferences.
  // This method stores the JSON representation of the movies in the SharedPreferences.
  Future<void> _cacheMovies(String category, String jsonMovies) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('movies_$category', jsonMovies);
  }

  
  // Loads the cached movies for a given category from SharedPreferences.
  // This method retrieves the JSON representation of the movies from the SharedPreferences and converts it back to a list of MovieModel objects.
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
