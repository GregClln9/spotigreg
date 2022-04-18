import 'package:flutter/material.dart';
import 'package:spotigreg_front/screens/home.dart';
import 'package:spotigreg_front/screens/settings.dart';

// Route Names
const String settingsPage = 'settingsPage';
const String homePage = 'homePage';

// Control our page route flow
Route<dynamic> controller(RouteSettings settings) {
  switch (settings.name) {
    case settingsPage:
      return MaterialPageRoute(builder: (context) => const Settings());
    case homePage:
      return MaterialPageRoute(builder: (context) => const Home());
    default:
      throw ('This route name does not exit');
  }
}
