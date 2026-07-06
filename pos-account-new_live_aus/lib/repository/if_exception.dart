import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:oktoast/oktoast.dart' as oktoast;
import 'package:pos_account/model/common/setting_res.dart';
import 'package:pos_account/widgets/dialog/msg_dialog.dart';

import '../model/common/message.dart';

class IfException {
  static Future<bool?> boolExpt({
    required Future<Response> function,
    String messge = "",
    bool showToast = true,
    BuildContext? diaCtx,
    Function(bool)? onPopMsg,
    bool isDia = true,
  }) async {
    try {
      final res = await function;
      // log(res.statusCode.toString());
      // log(res.body);

      final resData = res.body.isNotEmpty
          ? SettingRes.fromJson(jsonDecode(res.body))
          : null;

      if (res.statusCode >= 200 && res.statusCode < 300) {
        if (messge.isEmpty) {
          if (resData?.message != null) {
            if (resData?.message is List<Message>) {
              if (resData?.message.isNotEmpty ?? false) {
                messge = resData?.message.first.message ?? LN.success;
              }
            } else if (resData?.message is Message) {
              messge = resData?.message ?? LN.success;
            } else if (resData?.message is String) {
              messge = resData?.message;
            }
          } else {
            messge = LN.success;
          }
        }
        if (showToast) {
          if (isDia) {
            if (diaCtx != null) {
              try {
                final _state = diaCtx.findAncestorStateOfType();
                if (_state?.mounted ?? false) {
                  Navigator.pop(diaCtx);
                  await Future.delayed(Duration(milliseconds: 200));
                }
              } catch (e) {
                // print(e);
              }
            }

            MsgDia.show(
              CUS_CTX,
              headerAnimation: false,
              diaType: DiaType.success,
              // title: LN.success,
              title: messge,
              autoHideSecond: 2,
              onPop: onPopMsg == null ? null : () => onPopMsg(true),
            );
          } else {
            showMessage(message: messge, isError: false);
          }
        }
        return true;
      } else {
        messge = LN.somethingWentWrong;
        if (resData?.message != null) {
          if (resData?.message is List<Message> &&
              resData!.message!.isNotEmpty &&
              !resData.message!.first.message!.contains("Exception")) {
            messge = resData.message!.first.message!;
          } else if (resData?.message is String) {
            messge = resData?.message;
          }
        }
        if (showToast) {
          if (isDia) {
            MsgDia.show(
              CUS_CTX,
              headerAnimation: false,
              diaType: DiaType.warning,
              title: LN.error,
              desc: messge,
              autoHideSecond: 3,
              onPop: onPopMsg == null ? null : () => onPopMsg(false),
            );
          } else {
            showMessage(message: messge, isError: true);
          }
        }
        return false;
      }
    } on SocketException catch (_) {
      if (showToast) _showToast(LN.noInternetConnection);
    } on FormatException catch (_) {
      if (showToast) _showToast(LN.tryAgainAfterTime);
    } catch (e) {
      // print(e.toString());
      if (showToast) _showToast(LN.somethingWentWrong);
    }
    return null;
  }

  static String onError(
      {required Response res, String message = "", bool showToast = true}) {
    final err = SettingRes.fromJson(jsonDecode(res.body));
    message = LN.somethingWentWrong;
    if (err.message != null &&
        err.message![0].message != null &&
        !err.message![0].message!.contains("Exception")) {
      message = err.message![0].message!;
    }
    if (showToast) {
      _showToast(message);
    }
    return message;
  }

  static bool _isMessageOpen = false;

  static void showMessage({
    Msg msg = Msg.Toast,
    required String message,
    String? desc,
    int seconds = 1,
    bool popNav = true,
    bool isError = true,
    bool isWarn = false,
    int autoHideSecond = 2,
    Function()? onPop,
  }) {
    if (msg == Msg.Dialog)
      Utils.handleSearch(
        millisecond: seconds * 1000,
        callback: () async {
          if (popNav && CUS_CTX != null && msg == Msg.Dialog) {
            if (Navigator.canPop(CUS_CTX!)) Navigator.pop(CUS_CTX!);
          }

          if (_isMessageOpen) return;

          _isMessageOpen = true;

          MsgDia.show(
            CUS_CTX,
            headerAnimation: false,
            diaType: isError ? DiaType.warning : DiaType.success,
            title: message,
            desc: desc,
            autoHideSecond: autoHideSecond,
            onPop: () {
              _isMessageOpen = false;
              if (onPop != null) onPop();
            },
          );
        },
      );
    else
      _showToast(message, isError: isError, isWarn: isWarn);
  }

  static bool _hideToast = false;

  static void _showToast(
    String message, {
    bool isError = true,
    bool isWarn = false,
  }) {
    if (_hideToast) return;

    _hideToast = true;

    oktoast.showToast(message,
        textStyle: TextStyle(
            color: Colors.white, fontFamily: kFontFMedium, fontSize: 20),
        backgroundColor: isWarn
            ? Colors.amber.shade400
            : isError
                ? Colors.red.shade700
                : Colors.green.shade700, onDismiss: () {
      _hideToast = false;
    });
  }
}

enum Msg { Toast, Dialog }
