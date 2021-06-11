import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movie_app/components/custom_loading_widget.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/providers/movie_logic.dart';
import 'package:movie_app/screens/movie_details_screen.dart';
import 'package:provider/provider.dart';

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
        title: Text('Movie App'),
      ),
      body: _isLoading
          ? CustomLoadingWidget()
          : ListView.builder(
              itemCount: _movies.length,
              itemBuilder: (context, index) => ListTile(
                leading: Image.network(_movies[index].posterPath!),
                title: Text(_movies[index].title!),
                subtitle: Text(
                  'Release Date: ${format.format(_movies[index].releaseDate!)}' +
                      '\nVote: ${_movies[index].voteAverage}',
                ),
                onTap: () => Navigator.of(context).pushNamed(
                  MovieDetailsScreen.routeName,
                  arguments: _movies[index],
                ),
              ),
            ),
    );
  }
}
