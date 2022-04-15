import 'package:flutter/material.dart';

class PlayerProvider extends ChangeNotifier {
  late String _currentTitle = "currentTitle";
  late String _currentArtiste = "currentArtiste";
  late String _currentCover = "currentCover";
  late String _currentUrl = "currentUrl";

  String get currentTitle => _currentTitle;
  String get currentArtiste => _currentArtiste;
  String get currentCover => _currentCover;
  String get currentUrl => _currentUrl;

  void setCurrentTrack(newTtile, newArtiste, newCover, newUrl) {
    _currentTitle = newTtile;
    _currentArtiste = newArtiste;
    _currentCover = newCover;
    _currentUrl = newUrl;
    notifyListeners();
  }
}
