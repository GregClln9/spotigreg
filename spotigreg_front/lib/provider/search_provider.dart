import 'package:flutter/material.dart';

class SearchProvider extends ChangeNotifier {
  late Set<String> _searchHistory = {};

  Set<String> get searchHistory => _searchHistory;

  // passer ca sous shared_preference

  void setSearchHistory(String newWord) {
    if (newWord.isNotEmpty) {
      _searchHistory.add(newWord);
    }
    notifyListeners();
  }

  void removeSearchHistory(String newWord) {
    _searchHistory.remove(newWord);
    notifyListeners();
  }

  void removeAllSearchHistory() {
    _searchHistory = {};
    notifyListeners();
  }
}
