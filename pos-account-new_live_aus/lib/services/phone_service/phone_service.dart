import 'package:flutter/material.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/main.dart';
import 'package:pos_account/model/home/menu/payment/cus_loyal_res.dart';
import 'package:pos_account/repository/handler.dart';
import 'package:pos_account/services/phone_service/local_server.dart';
import 'udp_listen.dart';
import 'widgets/phone_dialog.dart';

class PhoneService {
  static GlobalKey<ScaffoldState>? scaffoldKey;
  static PageController? pageController;

  // static Future<bool> _requestPermission() async {
  //   final _status = await Permission.phone.status;
  //   if (_status != PermissionStatus.granted) {
  //     final _status2nd = await Permission.phone.request();
  //     if (_status2nd == PermissionStatus.granted) {
  //       // showToast("Permission G")
  //       // log("phone permission _status2nd $_status2nd");
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } else {
  //     return true;
  //   }
  // }

  static Future<void> init({
    final GlobalKey<ScaffoldState>? scafKey,
    final PageController? pageCltr,
  }) async {
    scaffoldKey = scafKey;
    pageController = pageCltr;

    CallerIdService.init();
    LocalServer.initServer();

    // final _status = await _requestPermission();

    // // log("phone permission status = $_status");
    // if (!_status) return;

    // PhoneState.stream.listen((event) {
    //   // log("Incoming call state ${event.status}  ${event.number}");
    //   if (event.status == PhoneStateStatus.CALL_INCOMING)
    //     showWidget(phoneNumber: event.number);
    //   else if (event.status == PhoneStateStatus.CALL_ENDED)
    //     removeWidget(phoneNumber: event.number);
    // });
  }

  // static bool isPhoneEventOn = false;

  static final phoneCusList = <CusForLoyalityRes>[];
  static Function(void Function())? _setState;

  static Future<void> removeWidget({
    final String? phoneNumber,
    bool serverUpdate = true,
  }) async {
    if (CUS_CTX == null || phoneNumber == null || _setState == null) return;

    final phoneData =
        phoneNumber.replaceAll("+", "").replaceAll("-", "").trim();

    final hasOnList = phoneCusList
        .any((e) => e.phoneNumber?.toLowerCase() == phoneData.toLowerCase());
    if (hasOnList) {
      //
      if (serverUpdate) {
        _addRecentCalls(numbers: [phoneData]);
      }
      phoneCusList.removeWhere(
          (e) => e.phoneNumber?.toLowerCase() == phoneData.toLowerCase());
    }

    await Future.delayed(Duration(milliseconds: 300), () {
      if (hasOnList) {
        _setState!(() {});
      }

      if (Navigator.canPop(CUS_CTX!) && phoneCusList.isEmpty) {
        Navigator.pop(CUS_CTX!);
      }
    });
  }

  static Future<void> showWidget({
    final String? phoneNumber,
    final String? line,
  }) async {
    if (CUS_CTX == null || phoneNumber == null) return;
    final context = CUS_CTX!;

    // if (isPhoneEventOn) return;

    // isPhoneEventOn = true;

    final phoneData =
        phoneNumber.replaceAll("+", "").replaceAll("-", "").trim();

    CusForLoyalityRes? cusData =
        await Handler.searchCustomer(phoneNumber: phoneData);

    // if (_cusData == null) {
    //   isPhoneEventOn = false;
    //   return;
    // }
    cusData ??= CusForLoyalityRes(phoneNumber: phoneData);

    cusData.line = line;

    if (phoneCusList.any(
        (e) => e.phoneNumber != null && e.phoneNumber == phoneData)) return;

    phoneCusList.add(cusData);

    if (phoneCusList.length > 1) {
      if (_setState != null) _setState!(() {});
      return;
    }

    await showDialog(
        context: context,
        barrierColor: Colors.black12,
        builder: (_) {
          return StatefulBuilder(builder: (context, setS) {
            _setState = setS;
            return SlideInDialog(
              cusDataList: phoneCusList,
              onUpdate: () => setS(() {}),
            );
          });
        });
    _addRecentCalls(numbers: phoneCusList.map((e) => e.phoneNumber).toList());

    phoneCusList.clear();
    _setState = null;

    // isPhoneEventOn = false;
  }

  static Future<void> _addRecentCalls({List<String?>? numbers}) async {
    if (numbers == null) return;
    for (final e in numbers) {
      if (e?.isNotEmpty ?? false) {
        await Handler.addRecentCalls(phone: e, isAccept: false);
      }
    }
  }

  static void stop() {
    CallerIdService.stop();
  }
}
