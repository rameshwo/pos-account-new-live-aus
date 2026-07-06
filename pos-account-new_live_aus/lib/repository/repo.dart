import 'dart:convert';
import 'package:flutter_http_logger/flutter_http_logger.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:pos_account/screens/home_screen/com/dialogs/session_expire/sesson_expire.dart';
import 'package:pos_account/services/database/database/db_local_data.dart';
import 'package:pos_account/services/database/shared_pref.dart';
import 'handler.dart';

class Repo {
  static final client = http.Client();

  static Map<String, String> _getHeader({
    Map<String, String>? moreHeader,
  }) {
    Map<String, String> headers = {};

    headers.addAll({
      'Content-type': 'application/json',
      'Accept': 'application/json',
    });
    // {'Authorization': 'Bearer $token'}
    if (moreHeader != null) headers.addAll(moreHeader);

    return headers;
  }

  static Future<http.Response> post({
    Map<String, String>? h,
    Object? dataInJson,
    required String api,
  }) async {
    final _header = _getHeader(moreHeader: h);
    // print(baseUrl + api);
    final startTime = DateTime.now();

    HttpLog.sendLog(
      id: startTime.millisecondsSinceEpoch,
      method: "POST",
      url: api,
      header: _header,
      request: dataInJson,
    );

    http.Response response;

    try {
      response =
          await client.post(Uri.parse(api), body: dataInJson, headers: _header);
    } catch (e) {
      response = http.Response(_errorRes(e), 503);
    }

    final endTime = DateTime.now();

    HttpLog.sendLog(
      id: startTime.millisecondsSinceEpoch,
      method: "POST",
      url: api,
      header: _header,
      request: dataInJson,
      statusCode: response.statusCode,
      duration: endTime.difference(startTime).inMilliseconds,
      response: response.body,
    );

    final _auth = await _checkAuthorized(response);
    if (_auth != null) {
      h!.addAll(_auth);
      return post(
        h: h,
        dataInJson: dataInJson,
        api: api,
      );
    }

    return response;
  }

  static Future<http.Response> put({
    Map<String, String>? h,
    required Object? dataInJson,
    required String api,
  }) async {
    final _header = h != null ? _getHeader(moreHeader: h) : null;

    final startTime = DateTime.now();

    HttpLog.sendLog(
      id: startTime.millisecondsSinceEpoch,
      method: "PUT",
      url: api,
      request: dataInJson,
      header: _header,
    );

    http.Response response;

    try {
      response =
          await client.put(Uri.parse(api), body: dataInJson, headers: _header);
    } catch (e) {
      response = http.Response(_errorRes(e), 503);
    }

    final endTime = DateTime.now();

    HttpLog.sendLog(
      id: startTime.millisecondsSinceEpoch,
      method: "PUT",
      url: api,
      request: dataInJson,
      header: _header,
      statusCode: response.statusCode,
      duration: endTime.difference(startTime).inMilliseconds,
      response: response.body,
    );

    final _auth = await _checkAuthorized(response);
    if (_auth != null) {
      h!.addAll(_auth);
      return put(
        h: h,
        dataInJson: dataInJson,
        api: api,
      );
    }
    return response;
  }

  static Future<http.Response> get({
    Map<String, String>? h,
    required String api,
  }) async {
    final _header = _getHeader(moreHeader: h);
    // print(baseUrl + api);

    final startTime = DateTime.now();

    HttpLog.sendLog(
      id: startTime.millisecondsSinceEpoch,
      method: "GET",
      url: api,
      header: _header,
    );

    http.Response response;

    try {
      response = await client.get(Uri.parse(api), headers: _header);
    } catch (e) {
      response = http.Response(_errorRes(e), 503);
    }

    final endTime = DateTime.now();

    HttpLog.sendLog(
      id: startTime.millisecondsSinceEpoch,
      method: "GET",
      url: api,
      header: _header,
      statusCode: response.statusCode,
      duration: endTime.difference(startTime).inMilliseconds,
      response: response.body,
    );

    final _auth = await _checkAuthorized(response);
    if (_auth != null) {
      h!.addAll(_auth);
      return get(
        h: h,
        api: api,
      );
    }

    return response;
  }

  static Future<http.Response> httpPostFile({
    Map<String, String>? h,
    Map<String, String>? data,
    String? filePath,
    required String api,
    String method = "POST",
  }) async {
    // print(baseUrl + api);
    final _header = _getHeader(moreHeader: h);
    var request = http.MultipartRequest(method, Uri.parse(api));
    if (h != null) request.headers.addAll(_header);

    if (data != null) request.fields.addAll(data);

    if (filePath != null && filePath.isNotEmpty && !filePath.contains('http')) {
      final file =
          await http.MultipartFile.fromPath(path.basename(filePath), filePath);
      request.files.add(file);
    }
    final startTime = DateTime.now();
    HttpLog.sendLog(
      id: startTime.millisecondsSinceEpoch,
      method: "${method}_FILE",
      url: api,
      header: h != null ? _header : {},
      request: data?['Request'] ?? filePath,
    );

    http.Response response;

    try {
      final req = await request.send();
      response = await http.Response.fromStream(req);
    } catch (e) {
      response = http.Response(_errorRes(e), 503);
    }

    final endTime = DateTime.now();

    HttpLog.sendLog(
      id: startTime.millisecondsSinceEpoch,
      method: "${method}_FILE",
      url: api,
      header: h != null ? _header : {},
      request: data?['Request'] ?? filePath,
      statusCode: response.statusCode,
      duration: endTime.difference(startTime).inMilliseconds,
      response: response.body,
    );

    final auth = await _checkAuthorized(response);
    if (auth != null) {
      h!.addAll(auth);
      return httpPostFile(h: h, data: data, filePath: filePath, api: api);
    }

    return response;
  }

  static final _unAuthUrlList = <String>[];

  static Future<Map<String, String>?> _checkAuthorized(
      http.Response response) async {
    if (response.statusCode != 401) return null;

    if (_unAuthUrlList.contains(response.request?.url.path)) {
      SessionExpireSec.show();
      _unAuthUrlList.clear();
      return null;
    }

    if (response.request?.url.path != null) {
      _unAuthUrlList.add(response.request!.url.path);
    }

    Future.delayed(Duration(seconds: 10), () {
      _unAuthUrlList.clear();
    });

    final res = await Handler.getRefreshToken();
    if (res?.isRefreshTokenValid ?? false) {
      SharedPrefs.setApiToken = res?.accessToken ?? '';
      final _loginRes = await DbLocalData.getLoginData();
      _loginRes?.token = res?.accessToken;
      _loginRes?.refreshToken = res?.refreshToken;
      await DbLocalData.updateLoginData(loginRes: _loginRes);
      return {"Authorization": "Bearer ${res?.accessToken}"};
    } else {
      SessionExpireSec.show();
      return null;
    }
  }

  static String _errorRes(dynamic e) {
    return json.encode({
      "error": "Network error",
      "message": e.toString(),
    });
  }
}


  // final response = await HttpLog.run<http.Response>(
  //     method: "POST",
  //     header: _header,
  //     url: api,
  //     function: () =>
  //         client.post(Uri.parse(api), body: dataInJson, headers: _header),
  //     request: dataInJson,
  //     statusCode: (r) => r.statusCode,
  //     resBody: (r) => r.body,
  //   );

  //     final response = await HttpLog.run<http.Response>(
  //     method: "PUT",
  //     header: _header,
  //     url: api,
  //     function: () =>
  //         client.put(Uri.parse(api), body: dataInJson, headers: _header),
  //     request: dataInJson,
  //     statusCode: (r) => r.statusCode,
  //     resBody: (r) => r.body,
  //   );

  //    final response = await HttpLog.run<http.Response>(
  //     method: "GET",
  //     header: _header,
  //     url: api,
  //     function: () => client.get(Uri.parse(api), headers: _header),
  //     statusCode: (r) => r.statusCode,
  //     resBody: (r) => r.body,
  //   );
