import 'package:flutter/material.dart';
import 'package:pos_account/model/auth/login_res.dart';
import 'package:pos_account/repository/handler.dart';
import 'package:pos_account/services/database/database/db_local_data.dart';

class ChangePassPro extends ChangeNotifier {
  bool loading = true;

  final emailCltr = TextEditingController();
  final oldPassCltr = TextEditingController();
  final newPassCltr = TextEditingController();
  final conNewPassCltr = TextEditingController();

  String? errMessage;
  String? successMessage;

  bool showOldPass = false;
  bool showNewPass = false;
  LoginRes? _loginRes;

  bool staySignedIn = true;

  void setData({bool? is2faEnabled}) async {
    errMessage = null;
    successMessage = null;
    _loginRes = await DbLocalData.getLoginData();
    emailCltr.text = _loginRes?.email ?? '';
    enable2fa = is2faEnabled ?? false; // _loginRes?.is2FaEnabled ?? false;
    loading = false;
    notify;
  }

  Future<bool?> changePassword() async {
    loading = true;
    errMessage = null;
    successMessage = null;
    notify;
    try {
      final res = await Handler.changePassword(
        email: emailCltr.text,
        oldPass: oldPassCltr.text,
        newPass: newPassCltr.text,
        staySignedIn: staySignedIn,
      );
      successMessage = res?.message;
      oldPassCltr.clear();
      newPassCltr.clear();
      conNewPassCltr.clear();

      Future.delayed(Duration(seconds: 5), () {
        successMessage = null;
        notify;
      });
    } catch (e) {
      errMessage = e.toString();
      Future.delayed(Duration(seconds: 5), () {
        errMessage = null;
        notify;
      });
    }
    loading = false;
    notify;
    return successMessage != null;
  }

  // enable 2fa
  bool enable2fa = false;

  Future<bool?> enableDis2fa() async {
    final status =
        await Handler.enableDis2fa(email: emailCltr.text, isEnable: enable2fa);
    if ((status ?? false) && _loginRes != null) {
      _loginRes!.is2FaEnabled = enable2fa;
      await DbLocalData.updateLoginData(loginRes: _loginRes!);
      return true;
    } else {
      enable2fa = !enable2fa;
      notify;
    }
    return null;
  }

  bool emailSendLoad = false;

  Future<bool?> sendDeviceIdEmail() async {
    emailSendLoad = true;
    notify;
    final status = await Handler.sendEmailDeviceId();
    emailSendLoad = false;
    notify;
    return status;
  }

  void clear() {
    loading = true;
    emailCltr.clear();
    oldPassCltr.clear();
    newPassCltr.clear();
    conNewPassCltr.clear();
    errMessage = null;
    successMessage = null;
    showOldPass = false;
    showNewPass = false;
    enable2fa = false;
    staySignedIn = true;
  }

  void get notify => notifyListeners();
}
