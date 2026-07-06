import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:pos_account/env.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/repository/handler.dart';
import 'package:pos_account/repository/if_exception.dart';
import 'package:pos_account/repository/repo_v2.dart';
import 'package:pos_account/repository/windcave/model/button_res.dart';
import 'package:pos_account/repository/windcave/model/tran_res.dart';
import 'package:pos_account/repository/windcave/xml_parse.dart';
import 'model/button_req.dart';
import 'model/receipt_req.dart';
import 'model/receipt_res.dart';
import 'model/tran_req.dart';
part 'windcave_api.dart';

class WindcaveHandler {
  static String wCConsoleData = "";

  static Future<WcTransactionRes?> transaction({
    WcTransactionReq? req,
    Function()? onNoSocket,
  }) async {
    if (req == null) return null;

    try {
      final body = XmlParse.jsonToString(req.toJson());

      wCConsoleData += """Url : ${WindcaveApi._BASE_URL}\n""";
      wCConsoleData += """Request : ${XmlParse.formatXml(body)}\n""";

      _storeLocally();

      final _startTime = DateTime.now();

      final res = await RepoV2.post(
        h: {
          'Content-Type': 'application/xml',
        },
        body: body,
        url: WindcaveApi._BASE_URL,
      );

      final _endTime = DateTime.now();

      wCConsoleData += """Status : ${res.statusCode}\n""";

      wCConsoleData +=
          """Duration : ${_endTime.difference(_startTime).inMilliseconds} ms \n""";

      wCConsoleData += """Response : ${XmlParse.formatXml(res.body)}\n\n\n\n""";

      _storeLocally();

      if (res.statusCode == 200) {
        final xmlResponse = res.body;

        // Convert the XML response to JSON
        final jsonResponse = XmlParse.xmlToJson(xmlResponse);
        // log(_stringData);

        final data = WcTransactionRes.fromJson(jsonResponse);

        if (data.response?.code == "XX" && data.response?.message != null) {
          IfException.showMessage(message: data.response?.message ?? '');
        }

        return data;
      }
    } on SocketException catch (_) {
      IfException.showMessage(message: LN.noInternetConnection);
      if (onNoSocket != null) onNoSocket();
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<WcButtonRes?> clickButton({
    WcButtonReq? req,
  }) async {
    if (req == null) return null;

    try {
      final body = XmlParse.jsonToString(req.toJson());

      wCConsoleData += """Url : ${WindcaveApi._BASE_URL}\n""";
      wCConsoleData += """Request : ${XmlParse.formatXml(body)}\n""";

      _storeLocally();

      final _startTime = DateTime.now();

      final res = await RepoV2.post(
        h: {
          'Content-Type': 'application/xml',
        },
        body: body,
        url: WindcaveApi._BASE_URL,
      );

      final _endTime = DateTime.now();

      wCConsoleData += """Status : ${res.statusCode}\n""";

      wCConsoleData +=
          """Duration : ${_endTime.difference(_startTime).inMilliseconds} ms \n""";

      wCConsoleData +=
          """Response : ${XmlParse.formatXml(res.body)}\n\n\n\n\n""";

      _storeLocally();

      if (res.statusCode == 200) {
        final xmlResponse = res.body;

        // Convert the XML response to JSON
        final jsonResponse = XmlParse.xmlToJson(xmlResponse);

        final data = WcButtonRes.fromJson(jsonResponse);

        if (data.response?.code == "XX" && data.response?.message != null) {
          IfException.showMessage(message: data.response?.message ?? '');
        }

        return data;
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  static Future<WcReceiptRes?> getReceipt({
    WcReceiptReq? req,
  }) async {
    if (req == null) return null;

    try {
      final body = XmlParse.jsonToString(req.toJson());

      wCConsoleData += """Url : ${WindcaveApi._BASE_URL}\n""";
      wCConsoleData += """Request : ${XmlParse.formatXml(body)}\n""";

      _storeLocally();

      final _startTime = DateTime.now();

      final res = await RepoV2.post(
        h: {
          'Content-Type': 'application/xml',
        },
        body: body,
        url: WindcaveApi._BASE_URL,
      );

      final _endTime = DateTime.now();

      wCConsoleData += """Status : ${res.statusCode}\n""";

      wCConsoleData +=
          """Duration : ${_endTime.difference(_startTime).inMilliseconds} ms \n""";

      wCConsoleData +=
          """Response : ${XmlParse.formatXml(res.body)}\n\n\n\n\n""";

      _storeLocally();

      if (res.statusCode == 200) {
        final xmlResponse = res.body;

        // Convert the XML response to JSON
        final jsonResponse = XmlParse.xmlToJson(xmlResponse);

        final data = WcReceiptRes.fromJson(jsonResponse);

        if (data.response?.code == "XX" && data.response?.message != null) {
          IfException.showMessage(message: data.response?.message ?? '');
        }

        return data;
      }
    } on SocketException catch (_) {
      IfException.showMessage(
          message: LN.noInternetConnection, msg: Msg.Dialog);
    } on FormatException catch (_) {
      IfException.showMessage(message: LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
    }
    return null;
  }

  // static void _storeLocally() {
  //   StorageService.writeData(wCConsoleData);
  // }

  // static Future<void> sendLogs(
  //   String orderId,
  // ) async {
  //   final _logs = await StorageService.readData();
  //   if (_logs == null || _logs.isEmpty) return;

  //   final _status = await Handler.windcaveLog(logs: _logs, orderId: orderId);

  //   if (_status ?? false) {
  //     await StorageService.deleteData();
  //   }
  // }

  static void _storeLocally() {}

  static Future<void> sendLogs(
    String orderId,
  ) async {
    if (wCConsoleData.isEmpty) return;

    await Handler.windcaveLog(logs: wCConsoleData, orderId: orderId);
  }
}
