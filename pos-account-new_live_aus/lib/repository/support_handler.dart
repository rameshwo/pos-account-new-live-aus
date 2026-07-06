part of 'handler.dart';

mixin SupportHandler {
  static String? deviceId;

  static Future<Map<String, String>?> get _header async {
    final _storeId = await SharedPrefs.storeId;
    final _userId = await SharedPrefs.userId;
    final _apiToken = await SharedPrefs.apiToken;
    final employeeId = await SharedPrefs.employeeId;
    // final _pinCode = await SharedPrefs.getPinCode;
    //
    // final _loginRes = await DbLocalData.getLoginRes();

    // final _store = (_loginRes.storeDetailsLoginResponseViewModels?.any(
    //             (f) => f.storeId?.toLowerCase() == _storeId.toLowerCase()) ??
    //         false)
    //     ? _loginRes.storeDetailsLoginResponseViewModels!.firstWhere(
    //         (f) => f.storeId?.toLowerCase() == _storeId.toLowerCase())
    //     : null;
    //

    deviceId = await getDeviceId;
    final Map<String, String> _head = {
      "StoreId": _storeId,
      "UserId": _userId,
      "ChannelPlatForm": "PosApp",
      "Authorization": "Bearer $_apiToken",
      "DeviceIdentifier": deviceId ?? '',
      if (employeeId.isNotEmpty) "EmployeeId": employeeId,
      // if (_pinCode?.isNotEmpty ?? false) "LoginPinCode": _pinCode!,
    };
    // log("header: ${json.encode(_head)}");
    return _head;
  }

  static Future<String?> get getDeviceId async {
    String? _deviceId;
    // return '140e848108ffb5f8'; // MX

    if (kDebugMode) return "fe497d8eba9b6d45";
    // return "fe497d8eba9b6d45";

    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      // final androidInfo = await deviceInfo.androidInfo;
      // final jsonEncode = json.encode(androidInfo.toString());
      // log("android info: ${jsonEncode}");

      // deviceId = androidInfo.serialNumber;
      _deviceId = await DeviceInfo.getAndroidID();
      // print("android id is: ${deviceId ?? 'null'}");
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      _deviceId = iosInfo.identifierForVendor;
    } else if (Platform.isMacOS) {
      final macInfo = await deviceInfo.macOsInfo;
      _deviceId = macInfo.systemGUID;
    } else if (Platform.isWindows) {
      final winInfo = await deviceInfo.windowsInfo;
      _deviceId = winInfo.computerName;
    }
    // print(" device id is: ${deviceId ?? 'null'}");
    return _deviceId;
  }

  static Future<String> get getFcmToken async {
    String? _fcmToken = "";
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        _fcmToken = await FirebaseMessaging.instance.getToken();
      }
    } catch (e) {
      // print(e.toString());
    }
    return _fcmToken ?? '';
  }

  // static void onErrorRes(Response res, {bool showToast = true}) {
  //   if (res.statusCode == 401) {
  //     globalAuthPro.authorize = Authorize.No;
  //     globalAuthPro.notify;
  //   } else {
  //     IfException.onError(res: res, showToast: showToast);
  //   }
  // }

  // static void switchServer({bool isPrimary = true}) {
  //   if (isPrimary) {
  //     Repo.baseUrl = AppEnviro.baseUrl;
  //   } else {
  //     if (AppEnviro.enviroment == Enviroment.DEV) {
  //       Repo.baseUrl = Api.BASE_URL_PROD;
  //     } else {
  //       Repo.baseUrl = Api.BASE_URL_DEV;
  //     }
  //   }
  // }
}

class DeviceInfo {
  static const platform = MethodChannel('com.example.cashbox');

  static Future<String?> getAndroidID() async {
    try {
      final String? androidId = await platform.invokeMethod('getAndroidID');
      return androidId;
    } on PlatformException catch (e) {
      showToast("Failed to get device info: '${e.message}'.");
      // print("Failed to get Android ID: '${e.message}'.");
      return null;
    }
  }
}
