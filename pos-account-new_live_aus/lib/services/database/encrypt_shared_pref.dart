part of 'shared_pref.dart';

class EncryptSharedPref {
  static const String _login_req_key = '_login_req_key_765234565';

  static final _key = Key.fromUtf8('lkjhgfrtyujhnb4f'); // 16 bytes key
  static final _encrypter = Encrypter(AES(_key));

  static Future<DbLoginReq?> get getLoginReq async {
    final pref = await SharedPreferences.getInstance();
    final encryptedValue = pref.getString(_login_req_key);
    if (encryptedValue == null || encryptedValue.isEmpty) return null;

    try {
      final parts = encryptedValue.split(':');

      final iv = IV.fromBase64(parts[0]);
      final encrypted = Encrypted.fromBase64(parts[1]);
      final decrypted = _encrypter.decrypt(encrypted, iv: iv);
      return DbLoginReq.fromJson(json.decode(decrypted));
    } catch (e) {
      // log(e.toString());
      return null;
    }
  }

  static set setLoginReq(DbLoginReq? value) {
    if (value == null) return;

    final jsonString = json.encode(value.toJson());
    final iv = IV.fromLength(16); // Generate a new IV
    final encrypted = _encrypter.encrypt(jsonString, iv: iv);

    SharedPreferences.getInstance().then((pref) =>
        pref.setString(_login_req_key, '${iv.base64}:${encrypted.base64}'));
  }
}
