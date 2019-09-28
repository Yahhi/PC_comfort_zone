import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class PreferencesProvider {
  static const KEY_FIRST_RUN = "first_run";
  static const KEY_UID = "uid";

  static PreferencesProvider _instance;
  Future _initialized;
  SharedPreferences _preferences;

  factory PreferencesProvider() {
    if (_instance == null) {
      _instance = PreferencesProvider._();
    }
    return _instance;
  }

  PreferencesProvider._() {
    _initialized = _initPreferences();
  }

  void saveFirstRunFinished() {
    _preferences.setBool(KEY_FIRST_RUN, true);
  }

  Future<bool> getFirstRunFinished() async {
    await _initialized;
    bool result = _preferences.getBool(KEY_FIRST_RUN);
    return result ?? false;
  }

  Future _initPreferences() async {
    _preferences = await SharedPreferences.getInstance();
  }

  Future<String> getUid() async {
    await _initialized;
    String result = _preferences.getString(KEY_UID);
    if (result == null) {
      result = Uuid().v4();
      _preferences.setString(KEY_UID, result);
    }
    return result;
  }
}
