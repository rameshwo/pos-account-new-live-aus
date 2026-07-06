import 'package:flutter/material.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/ui_model/screen_time_model.dart';
import 'package:pos_account/providers/auth/auth_pro.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/repository/handler.dart';
import 'package:pos_account/screens/initialize/screen_saver/pin_lock/pin_lock.dart';
import 'package:pos_account/services/database/database/db_local_data.dart';
import 'package:pos_account/services/database/shared_pref.dart';
import 'package:provider/provider.dart';

class ScreenSaverPro extends ChangeNotifier {
  void get notify => notifyListeners();

  // screen saver
  ScreenTimeModel? _enableScreenSaver;

  bool isHoldingScreen = false;

  int lockScreenCount = 0;

  ScreenTimeModel get isEnableScreenSaver {
    return _enableScreenSaver ??
        ScreenTimeOut.firstWhere((e) => e.duration == 0);
  }

  set setScreenSaver(ScreenTimeModel val) {
    _enableScreenSaver = val;
    // DbLocalData.updateScreenSavers(data: val);
    // SharedPrefs.setScreenSaver = val;
    notify;
    screenSaverCheck('setscreensaver');
  }

  bool _isScreenSaverOn = false;

  bool get isScreenSaverOn => _isScreenSaverOn;

  set showScreenSaver(bool val) {
    // in case keyboard is on don't show screen saver

    if (isHoldingScreen) return;

    if (_isScreenSaverOn == val) return;
    if (!isEnableScreenSaver.enable) return;

    if (CUS_CTX != null) {
      final authPro = Provider.of<AuthProvider>(CUS_CTX!, listen: false);
      if (authPro.getAuth != AuthStatus.AUTHENTICATE) return;
    }

    if (GlobalCVP.authorize == Authorize.No) return;

    if (val &&
        (WidgetsBinding
                .instance.platformDispatcher.views.first.viewInsets.bottom >
            0.0)) {
      return;
    }

    Future.delayed(Duration(milliseconds: 300), () {
      if (val) {
        // if (WidgetsBinding.instance != null &&
        //     WidgetsBinding.instance!.window.viewInsets.bottom > 0) {
        //   FocusManager.instance.primaryFocus?.unfocus();
        // }
        checkDia();
      }

      _isScreenSaverOn = val;
      notify;
    });
  }

  void checkDia() {
    if (CUS_CTX != null) {
      final isDiaOpen = Navigator.canPop(CUS_CTX!);
      if (isDiaOpen) {
        Navigator.pop(CUS_CTX!);
        checkDia();
      } else {
        return;
      }
    }
  }

  Future<void> screenSaverCheck(dynamic data, {BuildContext? context}) async {
    if (CUS_CTX == null && context == null) return;

    final authPro =
        Provider.of<AuthProvider>(CUS_CTX ?? (context!), listen: false);
    if (authPro.getAuth != AuthStatus.AUTHENTICATE ||
        GlobalCVP.authorize == Authorize.No) return;

    // print(
    //     '----------$data---------screen saver -- ${isEnableScreenSaver.duration} ---- ${_authPro.getAuth} ====== ${GlobalCVP.authorize}');
    // _enableScreenSaver ??= await SharedPrefs.getScreenSaver;

    if (isScreenSaverOn && await _doAuthenticate()) {
      // print('object');
      showScreenSaver = false;
    }

    if (isEnableScreenSaver.duration != 0)
      Utils.handleSearch(
          callback: () async {
            if (authPro.getAuth != AuthStatus.AUTHENTICATE ||
                GlobalCVP.authorize == Authorize.No) return;
            showScreenSaver = true;
            // print('===================== ======== show Screen Saver');
          },
          millisecond: isEnableScreenSaver.duration * 1000);
  }

  Future<bool> _doAuthenticate() async {
    // if (!isEnableScreenSaver.isAppLockEnable) return true;

    if (isScreenSaverOn) {
      //lock screen

      if (GlobalCVP.userStoresRes?.enablePinCodePopUpScreen ?? false) {
        lockScreenCount++;

        if (lockScreenCount > 1) return false;

        if (lockScreenCount == 1) {
          final status = await PinLockScreen.show();
          lockScreenCount = 0;
          if (status is bool && status) return true;
        }
      } else
        return true;
    }
    return false;
  }

  // api call

  // ScreenSaverPro() {
  //   getScreenBanner();
  // }

  final screenImages = <String>[];

  Future<void> getScreenBanner() async {
    final response = await Handler.getLockScreenBanner();
    if (response == null) return;
    screenImages.clear();
    for (final e in response) {
      if (e.image != null) {
        // final _status = await Handler.checkStatusCode(api: e.image!);
        // if (_status ?? false) {
        screenImages.add(e.image!);
        // }
      }
    }
  }

  // validate pin code
  bool pageLoad = false;

  Future<bool> validatePinCode({String? pinCode}) async {
    if (pinCode == null) return false;

    pageLoad = true;
    notify;

    final status = await Handler.validatePinCode(pinCode: pinCode);

    if (status != null) {
      setInterval(status.loginPinAutoLogOffInterval);
      SharedPrefs.setUserId = status.userId ?? '';
      // SharedPrefs.setPinCode = pinCode;
    } else {
      pageLoad = false;
      notify;
    }

    return status != null;
  }

  Future<void> resetUser() async {
    SharedPrefs.setUserId = (await DbLocalData.getLoginData())?.userId ?? '';
    //  GlobalCVP.loginRes?.userId ?? '';
  }

  void setInterval(String? loginPinAutoLogOffInterval) {
    // print(loginPinAutoLogOffInterval);
    final interval = double.tryParse(loginPinAutoLogOffInterval ?? '')?.floor();
    if (interval != null
        // && _interval != 0
        ) {
      final screenTime = ScreenTimeModel(
        title: Utils.convertSeconds(interval),
        duration: interval,
        enable: true,
      );
      if (!ScreenTimeOut.any((e) => e.duration == interval)) {
        ScreenTimeOut.add(screenTime);
        ScreenTimeOut.sort((a, b) => a.duration.compareTo(b.duration));
        final first = ScreenTimeOut.first;
        ScreenTimeOut.add(first);
        ScreenTimeOut.removeAt(0);
      }
      setScreenSaver = screenTime;
    }
  }
}
