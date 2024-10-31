import 'package:move_app/constants/shared_preferences_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefer {
  static final SharedPrefer sharedPrefer = SharedPrefer._internal();

  factory SharedPrefer() {
    return sharedPrefer;
  }

  SharedPrefer._internal();

  late SharedPreferences _prefsInstance;
  Future<SharedPreferences> init() async {
    _prefsInstance = await SharedPreferences.getInstance();
    return _prefsInstance;
  }

  Future<void> setUserToken(String value) async {
    await _prefsInstance.setString(SharedPreferencesKey.token, value);
  }

  Future<void> setUserEmail(String value) async {
    await _prefsInstance.setString(SharedPreferencesKey.token, value);
  }

  String getUserToken() {
    return _prefsInstance.getString(SharedPreferencesKey.token) ?? "";
  }

  Future<void> setUserRefreshToken(String value) async {
    await _prefsInstance.setString(SharedPreferencesKey.refreshToken, value);
  }

  String getUserRefreshToken() {
    return _prefsInstance.getString(SharedPreferencesKey.refreshToken) ?? "";
  }

  Future<void> saveSearchHistory(List<String> history) async {
    await _prefsInstance.setStringList(SharedPreferencesKey.searchHistory, history);
  }

  Future<List<String>> loadSearchHistory() async {
    final history = _prefsInstance.getStringList(SharedPreferencesKey.searchHistory) ?? [];
    return history;
  }

  Future<void> setAvatarUserUrl(String value) async {
    await _prefsInstance.setString(SharedPreferencesKey.avatarUrl, value);
  }

  String getUserAvatarUrl() {
    return _prefsInstance.getString(SharedPreferencesKey.avatarUrl) ?? "";
  }

  Future<void> setUsername(String value) async {
    await _prefsInstance.setString(SharedPreferencesKey.username, value);
  }

  String getUsername() {
    return _prefsInstance.getString(SharedPreferencesKey.username) ?? "";
  }

  Future<void> setUserId(int value) async {
    await _prefsInstance.setInt(SharedPreferencesKey.userId, value);
  }

  int getUserId() {
    return _prefsInstance.getInt(SharedPreferencesKey.userId) ?? 0;
  }

  Future<void> setUnreadNotificationCount(int value) async {
    await _prefsInstance.setInt(SharedPreferencesKey.unreadNotificationCount, value);
  }

  int getUnreadNotificationCount() {
    return _prefsInstance.getInt(SharedPreferencesKey.unreadNotificationCount) ?? 0;
  }
}