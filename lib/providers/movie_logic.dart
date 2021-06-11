import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:movie_app/data/data.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/models/people.dart';

class MovieLogic with ChangeNotifier {
  final String _domain = getUrl();
  final String _api = getApiKey();
  final String _sessionId = getSessionId();
  final String _accountId = getAccountId();

  List<Movie> _movies = [];
  List<Person> _people = [];
  List<Movie> _recommendations = [];
  List<Movie> _favoriteMovies = [];
  Movie _movieById = Movie();

  List<Movie> get movies {
    return [..._movies];
  }

  List<Person> get people {
    return [..._people];
  }

  Movie get movieById {
    return _movieById;
  }

  List<Movie> get recommendations {
    return [..._recommendations];
  }

  List<Movie> get favoriteMovies {
    return [..._favoriteMovies];
  }

  Future<void> getNowPlayingMovies() async {
    final uri = Uri.parse(
      _domain + '/movie/now_playing?api_key=$_api&language=en-US&page=1',
    );
    try {
      final response = await http.get(uri);

      if (response.statusCode != 200) return;

      final movies =
          jsonDecode(response.body)['results'].cast<Map<String, dynamic>>();
      _movies = movies.map<Movie>((json) => Movie.fromJson(json)).toList();

      _movies.sort((a, b) => a.title!.compareTo(b.title!));

      notifyListeners();
    } catch (e) {
      print(e);
      return;
    }
  }

  Future<void> getMovieById(int id) async {
    final uri = Uri.parse(_domain + '/movie/$id?api_key=$_api&language=en-US');

    try {
      final response = await http.get(uri);

      if (response.statusCode != 200) return;

      final movie = Movie.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
      _movieById = movie;

      notifyListeners();
    } catch (e) {
      print(e);
      return;
    }
  }

  Future<void> getMovieCast(int id) async {
    final uri = Uri.parse(
      _domain + '/movie/$id/credits?api_key=$_api&language=en-US',
    );

    try {
      final response = await http.get(uri);

      if (response.statusCode != 200) return;

      final people =
          jsonDecode(response.body)['cast'].cast<Map<String, dynamic>>();
      _people = people.map<Person>((json) => Person.fromJson(json)).toList();
      notifyListeners();

      return;
    } catch (e) {
      print(e);
      return;
    }
  }

  Future<String> rateMovie(int id, double rating) async {
    final uri = Uri.parse(
      _domain +
          '/movie/$id/rating?api_key=$_api&language=en-US&session_id=$_sessionId',
    );

    try {
      final response = await http.post(
        uri,
        body: jsonEncode({'value': 8.5}),
        headers: {'Content-Type': 'application/json'},
      );

      final data = jsonDecode(response.body)['status_code'];

      if (data == 1 || data == 12)
        return 'Rating saved';
      else
        return 'Something went wrong. Please try again later';
    } catch (e) {
      print(e);
      return 'Something went wrong. Please try again later';
    }
  }

  Future<void> getRecommendations(int id) async {
    final uri = Uri.parse(
        _domain + '/movie/$id/recommendations?api_key=$_api&language=en-US');

    try {
      final response = await http.get(uri);

      if (response.statusCode != 200) return;

      final recommendations =
          jsonDecode(response.body)['results'].cast<Map<String, dynamic>>();
      _recommendations =
          recommendations.map<Movie>((json) => Movie.fromJson(json)).toList();

      notifyListeners();
    } catch (e) {
      print(e);
      return;
    }
  }

  Future<String> markAsFavorite(int id) async {
    final uri = Uri.parse(
      _domain +
          '/account/$_accountId/favorite?api_key=$_api&language=en-US&session_id=$_sessionId',
    );

    try {
      final response = await http.post(
        uri,
        body: jsonEncode(
          {'media_type': 'movie', 'media_id': id, 'favorite': true},
        ),
        headers: {'Content-Type': 'application/json'},
      );

      final data = jsonDecode(response.body)['status_code'];

      if (data == 1 || data == 12)
        return 'Added to favorite';
      else
        return 'Something went wrong. Please try again later';
    } catch (e) {
      print(e);
      return 'Something went wrong';
    }
  }

  Future<void> getMyFavorites() async {
    final uri = Uri.parse(
      _domain +
          '/account/$_accountId/favorite/movies?api_key=$_api&language=en-US&session_id=$_sessionId',
    );

    try {
      final response = await http.get(uri);

      if (response.statusCode != 200) return;

      final movies =
          jsonDecode(response.body)['results'].cast<Map<String, dynamic>>();
      _favoriteMovies =
          movies.map<Movie>((json) => Movie.fromJson(json)).toList();

      notifyListeners();
    } catch (e) {
      print(e);
      return;
    }
  }
}
