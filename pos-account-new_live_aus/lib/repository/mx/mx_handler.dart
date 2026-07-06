import 'dart:convert';
// import 'dart:developer';
import 'dart:io';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/constant/strings.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/repository/if_exception.dart';
import 'package:pos_account/repository/mx/model/trans_res.dart';
import 'package:pos_account/repository/mx/mx_api.dart';
import 'package:pos_account/repository/repo_v2.dart';
import 'package:crypto/crypto.dart';
import 'model/mx_error_res.dart';
import 'model/pair_res.dart';
import 'model/trans_req.dart';

class MxHandler {
  static String _sciApiBaseUrl = "";
  static String _keyId = "";
  static String _signingSecret = "";

  static void setMerchant({
    required String? sciApiBaseUrl,
    required String? keyId,
    required String? signingSecret,
  }) {
    // final sciApiBaseUrl = mxMerchant?.customerId ?? '';
    // final keyId = mxMerchant?.keyOrId ?? '';
    // final signingSecret = mxMerchant?.secret ?? '';
    _sciApiBaseUrl = "$sciApiBaseUrl";
    _keyId = keyId ?? '';
    _signingSecret = signingSecret ?? '';
    // log("_sciApiBaseUrl: $_sciApiBaseUrl");
    // log("_keyId: $_keyId");
    // log("_signingSecret: $_signingSecret");
  }

  static Map<String, String> _pairHeader(bool isKiosk) {
    final Map<String, String> _head = {
      "Authorization":
          "ApiKey ${isKiosk ? MxApi.kioskApiKey : MxApi.posApiKey}",
    };
    return _head;
  }

  static Future<MxPairResponse?> pair({
    String? code,
    String? nickName,
    required bool isKiosk,
  }) async {
    if (code == null) return null;

    final _body = {
      "pairing_code": code,
      if (nickName?.isNotEmpty ?? false) "pairing_nickname": nickName,
    };

    try {
      final res = await RepoV2.post(
        h: _pairHeader(isKiosk),
        body: json.encode(_body),
        url: MxApi.pairUrl + MxApi.pairing,
      );

      if (res.statusCode == 200) {
        return MxPairResponse.fromJson(json.decode(res.body));
      } else {
        IfException.showMessage(
            message: json.decode(res.body)['error']['message']);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: Strings.noInternetOnTerminalConnection,
          msg: Msg.Dialog,
          autoHideSecond: 3);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      kPrint(e.toString());
    }
    return null;
  }

  static Future<Map<String, String>> _signRequest(
    String method,
    String path,
    String jsonBody,
  ) async {
    // Compute SHA-256 digest of the body
    final bodyBytes = utf8.encode(jsonBody);
    final bodyHash = base64Encode(sha256.convert(bodyBytes).bytes);

    final _utcTime = await Utils.getUtcTime();

    // Current timestamp in seconds
    final created = _utcTime.millisecondsSinceEpoch ~/ 1000;

    // Build signature base exactly as server expects (newlines + colons)
    final signatureBase = '"@method": ${method.toUpperCase()}\n'
        '"@authority": ${Uri.parse(_sciApiBaseUrl).host}\n'
        '"@request-target": $path\n'
        '"content-digest": sha-256=:$bodyHash:\n'
        '"@signature-params": ("@method" "@authority" "@request-target" "content-digest");'
        'created=$created;alg="hmac-sha256";keyid="$_keyId"';

    // Compute HMAC-SHA256 signature
    final hmacKey = utf8.encode(_signingSecret);
    final hmac = Hmac(sha256, hmacKey);
    final signature =
        base64Encode(hmac.convert(utf8.encode(signatureBase)).bytes);

    // Build Signature-Input header
    final signatureInput =
        'sig1=("@method" "@authority" "@request-target" "content-digest");'
        'created=$created;alg="hmac-sha256";keyid="$_keyId"';

    // Debug logs for verification
    // log("jsonBody: $jsonBody");
    // log("signatureBase: $signatureBase");
    // log("signatureInput: $signatureInput");

    // Return headers
    return {
      // if (hasAuth) 'Authorization': 'ApiKey ${MxApi.apiKey}',
      'Content-Digest': 'sha-256=:$bodyHash:',
      'Signature-Input': signatureInput,
      'Signature': 'sig1=:$signature:',
      'Content-Type': 'application/json',
      'Accept': '*/*',
    };
  }

  static Future<MXDeviceStatus?> pairingInfo() async {
    try {
      final _headers = await _signRequest(
        'get',
        MxApi.pairingInfo,
        '',
      );

      // log("header: $_headers");

      final res = await RepoV2.get(
        h: _headers,
        url: _sciApiBaseUrl + MxApi.pairingInfo,
      );

      if (res.statusCode == 200) {
        return MXDeviceStatus.pair;
      } else if (res.statusCode == 401) {
        final _errRes = MxErrorRes.fromJson(json.decode(res.body));
        if (_errRes.error?.code?.toLowerCase().trim() ==
            'no_active_pairings_found') {
          return MXDeviceStatus.unpair;
        } else {
          IfException.showMessage(message: LN.somethingWentWrong);
          return MXDeviceStatus.invalid;
        }
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: Strings.noInternetOnTerminalConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      kPrint(e.toString());
    }
    return null;
  }

  static Future<bool> unPair() async {
    try {
      final _headers = await _signRequest(
        'post',
        MxApi.unpair,
        '',
      );

      // log("header: $_headers");

      final res = await RepoV2.post(
        h: _headers,
        url: _sciApiBaseUrl + MxApi.unpair,
        body: '',
      );

      if (res.statusCode == 204) {
        return true;
      } else {
        final _resError = json.decode(res.body)['error'];

        if (res.statusCode == 401 &&
            (_resError['code'] as String)
                .contains('no_active_pairings_found')) {
          return true;
        }

        IfException.showMessage(message: _resError['message']);
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: Strings.noInternetOnTerminalConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      kPrint(e.toString());
    }
    return false;
  }

  /// Create a transaction
  static Future<MxTransRes?> transaction({
    required MxTransReq transReq,
    Function()? onNoSocket,
  }) async {
    try {
      final _headers = await _signRequest(
        'post',
        MxApi.transaction,
        json.encode(transReq.toJson()),
      );

      // log("header: $_headers");

      final res = await RepoV2.post(
        h: _headers,
        url: _sciApiBaseUrl + MxApi.transaction,
        body: json.encode(transReq.toJson()),
      );

      if (res.statusCode == 200) {
        return MxTransRes.fromJson(json.decode(res.body));
      } else {
        IfException.showMessage(
            message: json.decode(res.body)['error']['message']);
      }
    } on SocketException catch (_) {
      // IfException.showMessage(message: Strings.noInternetOnTerminalConnection);
      if (onNoSocket != null) onNoSocket();
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      kPrint(e.toString());
    }
    return null;
  }

  static Future<MxTransRes?> getTransaction({
    required String id,
    int? version,
    Function()? onNoSocket,
  }) async {
    final _version = version != null ? '?min_version=$version' : '';

    try {
      final _headers = await _signRequest(
        'get',
        MxApi.getTransaction(id) + _version,
        '',
      );

      // log("header: $_headers");

      final res = await RepoV2.get(
        h: _headers,
        url: _sciApiBaseUrl + MxApi.getTransaction(id) + _version,
      );

      if (res.statusCode == 200) {
        return MxTransRes.fromJson(json.decode(res.body));
      } else {
        IfException.showMessage(
            message: json.decode(res.body)['error']['message']);
      }
    } on SocketException catch (_) {
      // IfException.showMessage(message: Strings.noInternetOnTerminalConnection);
      if (onNoSocket != null) onNoSocket();
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      kPrint(e.toString());
    }
    return null;
  }

  /// Create a transaction
  static Future<MxTransRes?> onClickButton({
    required String url,
    Map<String, dynamic> body = const {},
  }) async {
    try {
      final _headers = await _signRequest(
        'post',
        url.replaceAll(_sciApiBaseUrl, ''),
        // MxApi.cancelTransaction(id),
        json.encode(body),
      );

      // log("header: $_headers");

      final res = await RepoV2.post(
        h: _headers,
        url: url,
        //  _sciApiBaseUrl + MxApi.cancelTransaction(id),
        body: json.encode(body),
      );

      if (res.statusCode == 200) {
        return MxTransRes.fromJson(json.decode(res.body));
      } else {
        IfException.showMessage(
            message: json.decode(res.body)['error']['message']);
      }
    } on SocketException catch (_) {
      // IfException.showMessage(message: Strings.noInternetOnTerminalConnection);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      kPrint(e.toString());
    }
    return null;
  }
}

enum MXDeviceStatus { pair, unpair, invalid }
