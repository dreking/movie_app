import 'package:flutter/material.dart';
import 'package:movie_app/components/custom_loading_widget.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/providers/movie_logic.dart';
import 'package:provider/provider.dart';

class MovieCastScreen extends StatefulWidget {
  static const routeName = '/movie-cast';

  MovieCastScreen({Key? key}) : super(key: key);

  @override
  _MovieCastScreenState createState() => _MovieCastScreenState();
}

class _MovieCastScreenState extends State<MovieCastScreen> {
  bool _isLoading = false;
  bool _isInit = true;

  String _title = '';

  void _loadData(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    final movie = ModalRoute.of(context)?.settings.arguments as Movie;

    _title = movie.title! + ' Cast';

    await Provider.of<MovieLogic>(context).getMovieCast(movie.id!);

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
    final people = Provider.of<MovieLogic>(context).people;

    return Scaffold(
      appBar: AppBar(title: Text(_title)),
      body: _isLoading
          ? CustomLoadingWidget()
          : ListView.builder(
              itemCount: people.length,
              itemBuilder: (context, index) => ListTile(
                title: Text('Character: ' + people[index].character!),
                subtitle: Text('Name: ' + people[index].name!),
              ),
            ),
    );
  }
}
