import 'package:flutter/material.dart';

import 'package:movie_app/models/movie.dart';

class RecommendedMovie extends StatelessWidget {
  final Movie movie;

  const RecommendedMovie({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/images/placeholder.png',
                image: movie.posterPath!,
                height: 180,
                width: 150,
                fit: BoxFit.cover,
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(movie.title!),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
