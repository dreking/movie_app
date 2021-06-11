import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'package:movie_app/providers/movie_logic.dart';
import 'package:movie_app/screens/cast_screen.dart';
import 'package:movie_app/screens/main_screen.dart';
import 'package:movie_app/screens/movie_details_screen.dart';

void main() async {
  await dotenv.load(fileName: '.env');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: MovieLogic()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          MainScreen.routeName: (ctx) => MainScreen(),
          MovieDetailsScreen.routeName: (ctx) => MovieDetailsScreen(),
          MovieCastScreen.routeName: (ctx) => MovieCastScreen(),
        },
      ),
    );
  }
}
