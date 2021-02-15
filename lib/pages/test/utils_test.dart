import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  static SharedPreferences preferences;

  static Future<void> getSharedPreferences() async {
    if (preferences == null) {
      preferences = await SharedPreferences.getInstance();
    } else {
      return;
    }
  }
}
