import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:movie_app/models/movie.dart';
import 'package:movie_app/screens/movie_details_screen.dart';

class MovieWidget extends StatelessWidget {
  final Movie movie;
  final bool isFavorite;

  const MovieWidget({
    Key? key,
    required this.movie,
    this.isFavorite = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final format = DateFormat.yMd();

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.all(10),
      child: ListTile(
        contentPadding: EdgeInsets.all(10),
        leading: Hero(
          tag: movie.id!,
          child: Image.network(movie.posterPath!),
        ),
        title: Text(movie.title!),
        subtitle: Text(
          'Release Date: ${format.format(movie.releaseDate!)}' +
              '\nVote: ${movie.voteAverage}',
        ),
        onTap: isFavorite
            ? null
            : () => Navigator.of(context).pushNamed(
                  MovieDetailsScreen.routeName,
                  arguments: movie,
                ),
      ),
    );
  }
}
