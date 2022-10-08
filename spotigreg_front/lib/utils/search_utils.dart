import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final searchProvider = Provider((ref) => SearchHistory());

class SearchHistory {
  late List<String>? searchHistoryList = [];

  updateSearch(dynamic data, WidgetRef ref) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? saveSearch = prefs.getStringList('searchHistory');
    searchHistoryList = saveSearch;
  }

  saveSearch(dynamic data, WidgetRef ref) async {
    if (data == null) return;
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('searchHistory', data);
  }
}
