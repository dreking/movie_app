import 'package:flutter/material.dart';
import 'package:movie_app/models/movie.dart';

class RecommendedMovie extends StatelessWidget {
  final Movie movie;

  const RecommendedMovie({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 100,
      child: Card(
        child: Column(
          children: [
            Image.network(
              movie.posterPath!,
              height: 150,
            ),
            Flexible(child: Text(movie.title!)),
          ],
        ),
      ),
    );
  }
}
