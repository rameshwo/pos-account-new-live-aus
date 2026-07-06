import 'dart:convert';
import 'package:flutter_http_logger/flutter_http_logger.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class RepoV2 {
  static Map<String, String> _getHeader({
    Map<String, String>? moreHeader,
  }) {
    Map<String, String> headers = {};

    headers.addAll({
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });
    // {'Authorization': 'Bearer $token'}
    if (moreHeader != null) headers.addAll(moreHeader);

    return headers;
  }

  static Future<http.Response> post({
    Map<String, String>? h,
    required String url,
    Object? body,
  }) async {
    final header = _getHeader(moreHeader: h);
    // print(baseUrl + api);
    final startTime = DateTime.now();

    HttpLog.sendLog(
      id: startTime.millisecondsSinceEpoch,
      method: "POST",
      url: url,
      header: header,
      request: body,
    );

    http.Response response;
    try {
      response = await http.post(Uri.parse(url), body: body, headers: header);
    } catch (e) {
      response = http.Response(_errorRes(e), 503);
    }

    final endTime = DateTime.now();

    HttpLog.sendLog(
      id: startTime.millisecondsSinceEpoch,
      method: "POST",
      url: url,
      header: header,
      request: body,
      statusCode: response.statusCode,
      duration: endTime.difference(startTime).inMilliseconds,
      response: response.body,
    );
    return response;
  }

  static Future<http.Response> get({
    Map<String, String>? h,
    required String url,
  }) async {
    final header = _getHeader(moreHeader: h);
    // print(baseUrl + api);
    final startTime = DateTime.now();

    HttpLog.sendLog(
      id: startTime.millisecondsSinceEpoch,
      method: "GET",
      url: url,
      header: header,
    );

    http.Response response;
    try {
      response = await http.get(Uri.parse(url), headers: header);
    } catch (e) {
      response = http.Response(_errorRes(e), 503);
    }

    final endTime = DateTime.now();

    HttpLog.sendLog(
      id: startTime.millisecondsSinceEpoch,
      method: "GET",
      url: url,
      header: header,
      statusCode: response.statusCode,
      duration: endTime.difference(startTime).inMilliseconds,
      response: response.body,
    );
    return response;
  }

  static Future<http.Response> postFile({
    Map<String, String>? h,
    required String url,
    required Map<String, String> body,
    List<String?>? fileList,
  }) async {
    // print(baseUrl + api);
    final header = _getHeader(moreHeader: h);
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll(header);
    request.fields.addAll(body);

    if (fileList?.isNotEmpty ?? false) {
      for (final e in fileList!) {
        if ((e?.isNotEmpty ?? false) && !e!.contains('http')) {
          final file = await http.MultipartFile.fromPath(path.basename(e), e);
          request.files.add(file);
        }
      }
    }

    final startTime = DateTime.now();

    HttpLog.sendLog(
      id: startTime.millisecondsSinceEpoch,
      method: "POSTFILE",
      url: url,
      header: header,
      request: body['Request'],
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
      method: "POSTFILE",
      url: url,
      header: header,
      request: body['Request'],
      statusCode: response.statusCode,
      duration: endTime.difference(startTime).inMilliseconds,
      response: response.body,
    );
    return response;
  }

  static String _errorRes(dynamic e) {
    return json.encode({
      "error": "Network error",
      "message": e.toString(),
    });
  }
}


//   final response = await HttpLog.run<http.Response>(
//       method: "POST",
//       url: url,
//       header: header,
//       request: body,
//       function: () => http.post(Uri.parse(url), body: body, headers: header),
//       statusCode: (r) => r.statusCode,
//       resBody: (r) => r.body,
//     );


//  final response = await HttpLog.run<http.Response>(
//       method: "GET",
//       url: url,
//       header: header,
//       function: () => http.get(Uri.parse(url), headers: header),
//       statusCode: (r) => r.statusCode,
//       resBody: (r) => r.body,
//     );