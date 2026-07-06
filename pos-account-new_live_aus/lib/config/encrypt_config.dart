import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/services/database/shared_pref.dart';

class EncryptConfig {
  static const String _secretKey = "1b2613097d730a14d6cac665cbeg0a15";
  static const String _iv = "1090152305672910";

  static String _encryptString(String plainText) {
    final key = encrypt.Key.fromUtf8(_secretKey);
    final ivObj = encrypt.IV.fromUtf8(_iv);

    final encrypter = encrypt.Encrypter(
      encrypt.AES(
        key,
        mode: encrypt.AESMode.cbc,
        padding: 'PKCS7',
      ),
    );

    final encrypted = encrypter.encrypt(plainText, iv: ivObj);

    // CryptoJS outputs Base64 by default
    return encrypted.base64;
  }

  // static String _decryptString(String cipherText) {
  //   if (cipherText.isEmpty) return "";

  //   final key = encrypt.Key.fromUtf8(_secretKey);
  //   final ivObj = encrypt.IV.fromUtf8(_iv);

  //   final encrypter = encrypt.Encrypter(
  //     encrypt.AES(
  //       key,
  //       mode: encrypt.AESMode.cbc,
  //       padding: 'PKCS7',
  //     ),
  //   );

  //   final decrypted = encrypter.decrypt64(cipherText, iv: ivObj);

  //   return decrypted;
  // }

  static Future<EncryptLoginData?> getEncLoginData() async {
    final _loginReq = await EncryptSharedPref.getLoginReq;

    if (_loginReq?.email == null || _loginReq?.password == null) return null;

    kPrint("_loginReq: ${_loginReq?.email} ${_loginReq?.password}");

    final _encPass = _encryptString(_loginReq!.password!);

    // final _decPass = decryptString(_encPass);

    // kPrint("_decPass: $_decPass");

    return EncryptLoginData(email: _loginReq.email!, encPassword: _encPass);
  }
}

class EncryptLoginData {
  final String email;
  final String encPassword;

  EncryptLoginData({required this.email, required this.encPassword});
}
