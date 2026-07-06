import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:pos_account/providers/auth/db_login_req.dart';
part 'encrypt_shared_pref.dart';

class SharedPrefs {
  static const String _auth_user = '_auth_user_76545433';
  static const String _store_id = 'store_id_654346';
  static const String _user_id = 'user_id_7623456';
  static const String _api_token = 'api_token_54452';
  static const String _currency_key = "currency_key_654345";
  static const String _date_format_key = "date_format_key_7654456";
  static const String _base_url_key = "base_url_key_765345234";
  static const String _dual_display_pattern = "_dual_display_pattern_76543456";
  // static const String _screen_saver_key = "screen_saver_7653445";
  // static const String _eft_default_key = "_eft_default_key_453245324";
  static const String _wind_transa_key = "_wind_transa_key_387654324562";
  static const String _eft_default_key = "_eft_default_key_453245324";
  // static const String _login_pin_code = '_login_pin_code_654324564';
  static const String _employee_id = 'employee_id_56432456';

  static Future<String?> get isAuth async {
    final pref = await SharedPreferences.getInstance();
    final status = pref.getString(_auth_user);
    return status;
  }

  static set setAuth(String value) {
    SharedPreferences.getInstance()
        .then((pref) => pref.setString(_auth_user, value));
  }

  static Future<String> get storeId async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(_store_id) ?? "";
  }

  static Future<void> setStoreId(String value) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString(_store_id, value);
  }

  static Future<String> get userId async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(_user_id) ?? "";
  }

  static set setUserId(String value) {
    SharedPreferences.getInstance()
        .then((pref) => pref.setString(_user_id, value));
  }

  static Future<String> get apiToken async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(_api_token) ?? "";
  }

  static set setApiToken(String value) {
    SharedPreferences.getInstance()
        .then((pref) => pref.setString(_api_token, value));
  }

  static Future<String> get curSym async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(_currency_key) ?? "";
  }

  static set setCurSym(String value) {
    SharedPreferences.getInstance()
        .then((pref) => pref.setString(_currency_key, value));
  }

  static Future<String> get dateFormat async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(_date_format_key) ?? "";
  }

  static Future<void> setDateFormat(String value) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString(_date_format_key, value);
  }

  // static Future<String?> get baseUrl async {
  //   final _pref = await SharedPreferences.getInstance();
  //   return _pref.getString(_base_url_key);
  // }

  // static set setBaseUrl(String? _value) {
  //   if (_value == null) return;
  //   SharedPreferences.getInstance()
  //       .then((_pref) => _pref.setString(_base_url_key, _value));
  // }

  static Future<String?> get dualDisPattern async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(_dual_display_pattern);
  }

  static set setDualDisPattern(String? value) {
    if (value == null) return;
    SharedPreferences.getInstance()
        .then((pref) => pref.setString(_dual_display_pattern, value));
  }

  // static Future<String?> get getEFTDefault async {
  //   final _pref = await SharedPreferences.getInstance();
  //   return _pref.getString(_eft_default_key);
  // }

  // static set setEFTDefault(String? _value) {
  //   if (_value == null) return;
  //   SharedPreferences.getInstance()
  //       .then((_pref) => _pref.setString(_eft_default_key, _value));
  // }

  static Future<String?> get getWindLastTran async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(_wind_transa_key);
  }

  static set setWindLastTrans(String value) {
    SharedPreferences.getInstance()
        .then((pref) => pref.setString(_wind_transa_key, value));
  }

  // static Future<String?> get getPinCode async {
  //   final _pref = await SharedPreferences.getInstance();
  //   return _pref.getString(_login_pin_code);
  // }

  // static set setPinCode(String _value) {
  //   SharedPreferences.getInstance()
  //       .then((_pref) => _pref.setString(_login_pin_code, _value));
  // }

  static Future<String> get employeeId async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(_employee_id) ?? "";
  }

  static set setemployeeId(String value) {
    SharedPreferences.getInstance()
        .then((pref) => pref.setString(_employee_id, value));
  }

  static void get clear => SharedPreferences.getInstance().then((pref) {
        for (final e in [
          _auth_user,
          _store_id,
          _user_id,
          _api_token,
          _currency_key,
          _date_format_key,
          _base_url_key,
          // _eft_default_key,
          _wind_transa_key,
          _eft_default_key,
          // _login_pin_code,
          _employee_id,
          EncryptSharedPref._login_req_key,
        ]) {
          pref.remove(e);
        }
        // _pref.clear();
      });
}
