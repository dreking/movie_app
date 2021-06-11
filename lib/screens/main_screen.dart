import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movie_app/screens/favorites_screen.dart';
import 'package:movie_app/widgets/movie_widget.dart';
import 'package:provider/provider.dart';

import 'package:movie_app/components/custom_loading_widget.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/providers/movie_logic.dart';
import 'package:movie_app/screens/movie_details_screen.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/';

  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _isLoading = false;
  bool _isInit = true;

  List<Movie> _movies = [];

  void _loadData(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    await Provider.of<MovieLogic>(
      context,
      listen: false,
    ).getNowPlayingMovies();

    _movies = Provider.of<MovieLogic>(context, listen: false).movies;

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
    final format = DateFormat.yMd();

    return Scaffold(
      appBar: AppBar(
        title: Text('Film Fan'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () => Navigator.of(context).pushNamed(
              FavoriteMoviesScreen.routeName,
            ),
          )
        ],
      ),
      body: _isLoading
          ? CustomLoadingWidget()
          : Column(
              children: [
                SizedBox(height: 20),
                TextTitle(title: 'Now Playing'),
                SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: _movies.length,
                    itemBuilder: (context, index) => MovieWidget(
                      movie: _movies[index],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
