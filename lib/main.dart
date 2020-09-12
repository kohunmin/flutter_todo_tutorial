import 'package:flutter/material.dart';
import 'package:flutter_todo/views/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // uid = cQjyqzkq5jcNYPAZQpq6ffEbZqp1

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: "OverpassRegular",
        primaryColor: Color(0xff3185FC),
        scaffoldBackgroundColor: Color(0xffFFFAFF),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: /*SignIn()*/ Home(),
    );
  }
}
