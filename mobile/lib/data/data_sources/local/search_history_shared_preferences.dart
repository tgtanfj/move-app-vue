import 'package:shared_preferences/shared_preferences.dart';

class SearchHistorySharedPreferences {
  static final SearchHistorySharedPreferences sharedPrefer =
      SearchHistorySharedPreferences._internal();

  factory SearchHistorySharedPreferences() {
    return sharedPrefer;
  }

  SearchHistorySharedPreferences._internal();

  late SharedPreferences _prefsInstance;

  Future<SharedPreferences> init() async {
    _prefsInstance = await SharedPreferences.getInstance();
    return _prefsInstance;
  }

  Future<void> saveSearchHistory(List<String> history) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('searchHistory', history);
  }

  Future<List<String>> loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('searchHistory') ?? [];
    return history;
  }
}
