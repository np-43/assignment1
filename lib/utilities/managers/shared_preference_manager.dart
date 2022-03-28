import 'package:shared_preferences/shared_preferences.dart';

enum SPKey { token }
extension on SPKey {
  String get value {
    switch(this) {
      case SPKey.token: return "token";
    }
  }
}

class SharedPrefsManager {

  static SharedPrefsManager? _instance;
  SharedPrefsManager._internal() {
    _instance = this;
  }

  static SharedPrefsManager get shared => _instance ?? SharedPrefsManager._internal();

  late SharedPreferences _sharedPreferences;

  _setSharedPreference() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  // Call this method in main()
  static initSharedPreference() async {
    await SharedPrefsManager.shared._setSharedPreference();
  }

}

extension ExtSharedPrefsManager on SharedPrefsManager {

  setString({required String value, required SPKey spKey}) async {
    await _sharedPreferences.setString(spKey.value, value);
  }

  String? getString({required SPKey spKey}){
    return _sharedPreferences.getString(spKey.value);
  }

  setBool({required bool value, required SPKey spKey}) async {
    await _sharedPreferences.setBool(spKey.value, value);
  }

  bool? getBool({required SPKey spKey}){
    return _sharedPreferences.getBool(spKey.value);
  }

  setInt({required int value, required SPKey spKey}) async {
    await _sharedPreferences.setInt(spKey.value, value);
  }

  int? getInt({required SPKey spKey}){
    return _sharedPreferences.getInt(spKey.value);
  }

  setDouble({required double value, required SPKey spKey}) async {
    await _sharedPreferences.setDouble(spKey.value, value);
  }

  double? getDouble({required SPKey spKey}){
    return _sharedPreferences.getDouble(spKey.value);
  }

  remove({required SPKey spKey}) {
    _sharedPreferences.remove(spKey.value);
  }

  clearAll() async {
    await _sharedPreferences.clear();
  }

}