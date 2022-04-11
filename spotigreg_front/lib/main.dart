import 'package:flutter/material.dart';
import 'package:spotigreg_front/screens/home.dart';
import 'package:spotigreg_front/themes/themedata.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SpotiGreg',
      theme: themedata,
      home: const Home(),
    );
  }
}
