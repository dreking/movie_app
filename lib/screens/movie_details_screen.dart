import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:movie_app/components/custom_loading_widget.dart';
import 'package:movie_app/providers/movie_logic.dart';
import 'package:movie_app/widgets/recommended.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/screens/cast_screen.dart';

class MovieDetailsScreen extends StatefulWidget {
  static const routeName = '/movie-details';

  const MovieDetailsScreen({Key? key}) : super(key: key);

  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  bool _isLoading = false;
  bool _isInit = true;

  String _title = '';

  void _loadData(context) async {
    setState(() {
      _isLoading = true;
    });

    final movie = ModalRoute.of(context)?.settings.arguments as Movie;
    _title = movie.title!;

    await Provider.of<MovieLogic>(context, listen: false)
        .getMovieById(movie.id!);
    await Provider.of<MovieLogic>(context, listen: false)
        .getRecommendations(movie.id!);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) _loadData(context);
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    final format = DateFormat.yM();

    final movie = Provider.of<MovieLogic>(context).movieById;
    final recommendations = Provider.of<MovieLogic>(context).recommendations;

    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: _isLoading
          ? CustomLoadingWidget()
          : ListView(
              children: [
                Container(
                  height: 300,
                  child: Image.network(
                    movie.posterPath!,
                    fit: BoxFit.cover,
                  ),
                ),
                Text('Released: ' + format.format(movie.releaseDate!)),
                Text(movie.overview!),
                Text('Rating: ' + movie.voteAverage!.toStringAsFixed(1)),
                Text('Genre: ${movie.genreText}'),
                TextButton(
                  child: Text('View Cast'),
                  onPressed: () => Navigator.of(context).pushNamed(
                    MovieCastScreen.routeName,
                    arguments: movie,
                  ),
                ),
                Center(
                  child: RatingBar.builder(
                    initialRating: 2.5,
                    maxRating: 10,
                    minRating: 1,
                    allowHalfRating: true,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) async {
                      print(rating * 2);

                      final message = await Provider.of<MovieLogic>(
                        context,
                        listen: false,
                      ).rateMovie(movie.id!, rating * 2);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${rating * 2} $message'),
                          action: SnackBarAction(
                            label: 'Okay',
                            onPressed: () {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Text('Recommended Movies'),
                Container(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: recommendations.length,
                    itemBuilder: (context, index) => RecommendedMovie(
                      movie: recommendations[index],
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
