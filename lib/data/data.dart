import 'package:flutter_dotenv/flutter_dotenv.dart';

String getUrl() {
  return 'https://api.themoviedb.org/3';
}

String getApiKey() {
  final String api = dotenv.env['API_KEY'] as String;
  return api;
}

String getSessionId() {
  final String id = dotenv.env['SESSION_ID'] as String;
  return id;
}

String getAccountId() {
  final String id = dotenv.env['ACCOUNT_ID'] as String;
  return id;
}
