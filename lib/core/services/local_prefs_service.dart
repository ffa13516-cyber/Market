import 'package:shared_preferences/shared_preferences.dart';

/// Wraps shared_preferences for small local-only settings
/// (e.g. last cash drawer count, theme toggle, logged-in cashier name).
/// NOT used for Firestore data — that's handled by Firestore's own cache.
class LocalPrefsService {
  final SharedPreferences _prefs;

  LocalPrefsService(this._prefs);

  static Future<LocalPrefsService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalPrefsService(prefs);
  }

  String? getString(String key) => _prefs.getString(key);
  Future<bool> setString(String key, String value) => _prefs.setString(key, value);

  double? getDouble(String key) => _prefs.getDouble(key);
  Future<bool> setDouble(String key, double value) => _prefs.setDouble(key, value);
}
