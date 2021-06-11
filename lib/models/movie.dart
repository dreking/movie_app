import 'package:movie_app/models/genre.dart';

class Movie {
  int? id;
  String? title;
  String? originalTitle;
  String? originalLanguage;
  String? overview;
  double? popularity;
  String? posterPath;
  DateTime? releaseDate;
  bool? video;
  double? voteAverage;
  int? voteCount;
  String? backdropPath;
  bool? adult;
  List<Genre>? genres;
  String? genreText;

  Movie({
    this.adult,
    this.backdropPath,
    this.id,
    this.originalLanguage,
    this.originalTitle,
    this.overview,
    this.popularity,
    this.posterPath,
    this.releaseDate,
    this.title,
    this.video,
    this.voteAverage,
    this.voteCount,
    this.genres,
    this.genreText,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    List<Genre> genres = [];
    String genreText = '';

    if (json['genre_ids'] != null) {
      genres =
          json['genre_ids'].map<Genre>((genre) => Genre(id: genre)).toList();
    }

    if (json['genres'] != null) {
      genres = json['genres']
          .cast<Map<String, dynamic>>()
          .map<Genre>(
            (genre) => Genre(id: genre['id'], name: genre['name']),
          )
          .toList();
      genres.forEach((e) {
        genreText += '${e.name}, ';
      });
    }

    return Movie(
      id: json['id'],
      title: json['title'],
      adult: json['adult'] as bool,
      backdropPath: 'https://image.tmdb.org/t/p/w500/' + json['backdrop_path'],
      originalLanguage: json['original_language'],
      originalTitle: json['original_title'],
      overview: json['overview'],
      popularity: json['popularity'].toDouble(),
      posterPath: 'https://image.tmdb.org/t/p/w500/' + json['poster_path'],
      releaseDate: DateTime.parse(json['release_date']),
      video: json['video'],
      voteAverage: json['vote_average'].toDouble(),
      voteCount: json['vote_count'],
      genres: genres,
      genreText: genreText,
    );
  }
}
