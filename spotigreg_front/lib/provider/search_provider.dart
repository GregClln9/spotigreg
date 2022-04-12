import 'package:flutter/material.dart';

class SearchProvider extends ChangeNotifier {
  // late String _pageToken = "";
  late Set<String> _searchHistory = {};

  // String get pageToken => _pageToken;
  Set<String> get searchHistory => _searchHistory;

  // void nextPage(String newPageToken) {
  //   _pageToken = newPageToken;
  //   notifyListeners();
  // }

  void setSearchHistory(String newWord) {
    _searchHistory.add(newWord);
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
