// import 'package:shared_preferences/shared_preferences.dart';

// class UberDeliSharedPref {
//   static const String _token = 'token_53453423';

//   static Future<String?> get token async {
//     final _pref = await SharedPreferences.getInstance();
//     return _pref.getString(_token);
//   }

//   static set setToken(String? value) {
//     if (value == null) return;

//     SharedPreferences.getInstance()
//         .then((_pref) => _pref.setString(_token, value));
//   }

//   //
//   static const String _storeId = 'store_6543456';

//   static Future<String?> get storeId async {
//     final _pref = await SharedPreferences.getInstance();
//     return _pref.getString(_storeId);
//   }

//   static set setStoreId(String? value) {
//     if (value == null) return;

//     SharedPreferences.getInstance()
//         .then((_pref) => _pref.setString(_storeId, value));
//   }
// }
