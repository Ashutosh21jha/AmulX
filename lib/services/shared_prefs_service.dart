import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  Future<bool> isDarkTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isDarkTheme') ?? false;
  }

  Future<void> setDarkTheme(bool isDark) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkTheme', isDark);
  }
}
