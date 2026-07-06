import 'dart:convert';
import 'dart:io';
import 'package:oktoast/oktoast.dart';
import 'package:pos_account/env.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/repository/repo_v2.dart';

part 'linkly_api.dart';

class LinkyHandler {
  static Future<String?> pinPair() async {
    final body = {
      "username": "123456789",
      "password": "QWERTY",
      "pairCode": "09876"
    };

    try {
      final res = await RepoV2.post(
        body: jsonEncode(body),
        url: LinklyApi._PIN_PAIRING,
      );
      // log(res.body);
      if (res.statusCode == 200) {
        return res.body;
      }
      //  else if (res.statusCode == 401) {
      //   showToast(res.body);
      // } else if (res.statusCode == 400) {
      //   showToast("Invalid request");
      // } else if (res.statusCode == 408) {
      //   showToast("Request Timeout");
      // } else if (res.statusCode >= 500 && res.statusCode <= 599) {
      //   showToast("A server error has occurred.");
      // }
    } on SocketException catch (_) {
      showToast(LN.noInternetConnection);
    } on FormatException catch (_) {
      showToast(LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }
}
