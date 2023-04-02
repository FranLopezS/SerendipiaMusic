import 'package:flutter/material.dart';
import 'package:serendipiamusic/src/routes/routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Serendipia Music',
      debugShowCheckedModeBanner: false,
      routes: getApplicationRoutes(),
      initialRoute: '/',
    );
  }
}
