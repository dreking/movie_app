import 'package:flutter/material.dart';
import 'package:movie_app/providers/movie_logic.dart';
import 'package:movie_app/widgets/movie_widget.dart';
import 'package:provider/provider.dart';

class FavoriteMoviesScreen extends StatefulWidget {
  static const routeName = '/favorite-movies';

  FavoriteMoviesScreen({Key? key}) : super(key: key);

  @override
  _FavoriteMoviesScreenState createState() => _FavoriteMoviesScreenState();
}

class _FavoriteMoviesScreenState extends State<FavoriteMoviesScreen> {
  bool _isLoading = false;
  bool _isInit = true;

  void _loadData(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    await Provider.of<MovieLogic>(
      context,
      listen: false,
    ).getMyFavorites();

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
    final movies = Provider.of<MovieLogic>(context).favoriteMovies;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Favorites'),
      ),
      body: ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) => MovieWidget(
          movie: movies[index],
          isFavorite: true,
        ),
      ),
    );
  }
}
