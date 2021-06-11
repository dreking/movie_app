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
    final scaffold = ScaffoldMessenger.of(context);

    final movie = Provider.of<MovieLogic>(context).movieById;
    final recommendations = Provider.of<MovieLogic>(context).recommendations;

    return Scaffold(
      body: _isLoading
          ? CustomLoadingWidget()
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 250,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(_title),
                    background: Hero(
                      tag: movie.id!,
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/images/placeholder.png',
                        image: movie.posterPath!,
                        height: 300,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextDisplay(
                              title: 'Released: ',
                              text: format.format(movie.releaseDate!),
                            ),
                            SizedBox(height: 20),
                            TextDisplay(
                              title: 'Overview: ',
                              text: movie.overview!,
                            ),
                            SizedBox(height: 20),
                            TextDisplay(
                              title: 'Rating: ',
                              text: movie.voteAverage!.toStringAsFixed(1),
                            ),
                            SizedBox(height: 20),
                            TextDisplay(
                              title: 'Genre: ',
                              text: movie.genreText!,
                            ),
                            SizedBox(height: 20),
                            TextButton(
                              child: Text(
                                'View Cast',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  Theme.of(context).primaryColor,
                                ),
                              ),
                              onPressed: () => Navigator.of(context).pushNamed(
                                MovieCastScreen.routeName,
                                arguments: movie,
                              ),
                            ),
                            SizedBox(height: 20),
                            TextButton(
                              child: Text(
                                'Add to Favorite',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  Theme.of(context).primaryColor,
                                ),
                              ),
                              onPressed: () async {
                                final response = await Provider.of<MovieLogic>(
                                  context,
                                  listen: false,
                                ).markAsFavorite(movie.id!);

                                scaffold.showSnackBar(
                                  SnackBar(
                                    content: Text(response),
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
                            SizedBox(height: 20),
                            TextTitle(title: 'Rate this Movie'),
                            SizedBox(height: 20),
                            Center(
                              child: RatingBar.builder(
                                initialRating: 2.5,
                                maxRating: 10,
                                minRating: 1,
                                allowHalfRating: true,
                                direction: Axis.horizontal,
                                itemCount: 5,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 4.0),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) async {
                                  final message = await Provider.of<MovieLogic>(
                                    context,
                                    listen: false,
                                  ).rateMovie(movie.id!, rating * 2);

                                  scaffold.showSnackBar(
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
                            SizedBox(height: 20),
                            TextTitle(title: 'Recommended Movies'),
                            SizedBox(height: 20),
                            Container(
                              height: 250,
                              width: double.infinity,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: recommendations.length,
                                itemBuilder: (context, index) =>
                                    RecommendedMovie(
                                  movie: recommendations[index],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class TextTitle extends StatelessWidget {
  final String title;
  const TextTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headline1,
    );
  }
}

class TextDisplay extends StatelessWidget {
  final String title;
  final String text;
  const TextDisplay({
    Key? key,
    required this.text,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headline2,
        ),
        Flexible(
          child: Text(
            text,
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
      ],
    );
  }
}
