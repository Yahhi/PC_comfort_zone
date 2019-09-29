import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class PreferencesProvider {
  static const KEY_FIRST_RUN = "first_run";
  static const KEY_UID = "uid";
  static const KEY_HUMIDITY = "humidity";
  static const KEY_CO2 = "co2";
  static const KEY_LIGHT = "light";
  static const KEY_FREQUENCY = "frequency";

  static const Map<String, Duration> frequencyOptions = {
    "30 секунд": Duration(seconds: 30),
    "1 минута": Duration(minutes: 1),
    "2 минуты": Duration(minutes: 2),
  };

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

  void saveHumiditySetting(bool newValue) async {
    await _initialized;
    _preferences.setBool(KEY_HUMIDITY, newValue);
  }

  Future<bool> getHumiditySetting() async {
    await _initialized;
    bool result = _preferences.getBool(KEY_HUMIDITY);
    return result ?? true;
  }

  void saveCO2Setting(bool newValue) async {
    await _initialized;
    _preferences.setBool(KEY_CO2, newValue);
  }

  Future<bool> getCO2Setting() async {
    await _initialized;
    bool result = _preferences.getBool(KEY_CO2);
    return result ?? true;
  }

  void saveLightSetting(bool newValue) async {
    await _initialized;
    _preferences.setBool(KEY_LIGHT, newValue);
  }

  Future<bool> getLightSetting() async {
    await _initialized;
    bool result = _preferences.getBool(KEY_LIGHT);
    return result ?? true;
  }

  void saveFrequencySetting(String durationText) async {
    await _initialized;
    _preferences.setString(KEY_FREQUENCY, durationText);
  }

  Future<Duration> getFrequencySetting() async {
    await _initialized;
    String resultIndex = _preferences.getString(KEY_FREQUENCY);
    return frequencyOptions[resultIndex] ?? Duration(seconds: 30);
  }
}
