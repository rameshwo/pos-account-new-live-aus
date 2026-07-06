import 'package:flutter/material.dart';
import 'package:pos_account/config/utils/promo_utils.dart';
import 'package:pos_account/model/auth/configure_device_req.dart';
import 'package:pos_account/model/auth/login_res.dart';
import 'package:pos_account/model/auth/opt_send_res.dart';
import 'package:pos_account/model/auth/register_req.dart';
import 'package:pos_account/model/auth/user_stores_res.dart';
import 'package:pos_account/model/common/message.dart';
import 'package:pos_account/model/profile/user_add_sec.dart';
import 'package:pos_account/providers/z_multi_pro.dart';
import 'package:pos_account/repository/handler.dart';
import 'package:pos_account/services/database/database/db_local_data.dart';
import 'package:pos_account/services/database/shared_pref.dart';
import 'package:pos_account/services/signal_core/signalr_core.dart';
import '../cus_val_pro.dart';

enum AuthStatus {
  INITIALIZE,
  AUTHENTICATING,
  VERIFICATION,
  AUTHENTICATE,
  UNAUTHENTICATED,
}

late AuthProvider AUTH_PRO;

class AuthProvider extends ChangeNotifier {
  AuthStatus _authStatus = AuthStatus.INITIALIZE;

  AuthPageState authPageState = AuthPageState.Login;
  AuthPageState onBackPageState = AuthPageState.Login;

  AuthStatus get getAuth => _authStatus;

  set setAuthStatus(AuthStatus status) {
    if (getRM) {
      SharedPrefs.setAuth = status.name;
    }
    _authStatus = status;
    notifyListeners();
  }

  AuthProvider.init() {
    SharedPrefs.isAuth.then((status) {
      if ((status?.isNotEmpty ?? false) &&
          status == AuthStatus.AUTHENTICATE.name) {
        _authStatus = AuthStatus.AUTHENTICATE;
      } else {
        _authStatus = AuthStatus.UNAUTHENTICATED;
      }
      notifyListeners();
    });
  }

  /// show/hide password

  bool _showPass = false;

  bool get getShowPass => _showPass;

  set setShowPass(bool val) {
    _showPass = val;
    notifyListeners();
  }

  //remember me

  bool _rememberMe = true;

  bool get getRM => _rememberMe;

  set setRM(bool val) {
    _rememberMe = val;
    notifyListeners();
  }

  //email and password
  final _emailCltr = TextEditingController();
  final _passCltr = TextEditingController();

  TextEditingController get emailCltr => _emailCltr;
  TextEditingController get passCltr => _passCltr;

  // server handler section

  String? errorMessage;
  String? succMessage;

  LoginRes? loginRess;
  UserStoresRes? userStoreRes;

  LoginRes? validateRes;
  bool loading = false;

  Future<bool?> doLogin({
    required String email,
    required String password,
    Future<void> Function()? twofaFun,
  }) async {
    succMessage = null;
    errorMessage = null;
    loginRess = null;
    userStoreRes = null;
    loading = true;
    notify;
    try {
      loginRess = await Handler.login(email: email, password: password);
      loading = false;
      notify;
      if (loginRess != null) {
        if (loginRess!.isEmailConfirmed != null &&
            loginRess!.isEmailConfirmed!) {
          if (loginRess!.is2FaEnabled != null) {
            if (loginRess!.is2FaEnabled! && twofaFun != null) {
              await twofaFun();
            } else {
              GlobalCVP.authorize = Authorize.Yes;

              final _deviceStatus = await _isDeviceConfigured();
              if (_deviceStatus == null) {
                setAuthStatus = AuthStatus.UNAUTHENTICATED;
                return false;
              } else {
                emailCltr.clear();
                passCltr.clear();
                return true;
              }
            }
          }
        } else {
          errorMessage = loginRess!.message;
          setAuthStatus = AuthStatus.UNAUTHENTICATED;
          return false;
        }
      }
    } catch (e) {
      errorMessage = e.toString();
    }
    loading = false;
    notify;
    clearMessage();
    return null;
  }

  Future<bool?> doLoginWithCode({
    String? email,
    required String code,
    Future<void> Function()? twofaFun,
  }) async {
    succMessage = null;
    errorMessage = null;
    loginRess = null;
    userStoreRes = null;
    loading = true;
    notify;
    try {
      loginRess = await Handler.loginWithCode(email: email, code: code);
      loading = false;
      notify;
      if (loginRess != null) {
        if (loginRess!.isEmailConfirmed != null &&
            loginRess!.isEmailConfirmed!) {
          if (loginRess!.is2FaEnabled != null) {
            if (loginRess!.is2FaEnabled! && twofaFun != null) {
              await twofaFun();
            } else {
              GlobalCVP.authorize = Authorize.Yes;

              final _deviceStatus = await _isDeviceConfigured();
              if (_deviceStatus == null) {
                setAuthStatus = AuthStatus.UNAUTHENTICATED;
                return false;
              } else {
                emailCltr.clear();
                passCltr.clear();
                return true;
              }
            }
          }
        } else {
          errorMessage = loginRess!.message;
          setAuthStatus = AuthStatus.UNAUTHENTICATED;
          return false;
        }
      }
    } catch (e) {
      errorMessage = e.toString();
    }
    loading = false;
    notify;
    clearMessage();
    return null;
  }

  Future<bool?> validateUser(
      {required String userId,
      required String otpCode,
      required bool isEmail}) async {
    succMessage = null;
    errorMessage = null;
    validateRes = null;
    loading = true;
    notify;
    try {
      validateRes = await Handler.validateUser(
        userId: userId,
        otpCode: otpCode,
        isEmail: isEmail,
      );
    } catch (e) {
      errorMessage = e.toString();
    }
    loading = false;
    notify;

    if (validateRes != null) {
      loginRess = validateRes;
      if (validateRes!.isEmailConfirmed != null &&
          validateRes!.isEmailConfirmed!) {
        if (validateRes!.is2FaEnabled != null && !validateRes!.is2FaEnabled!) {
          GlobalCVP.authorize = Authorize.Yes;

          final _deviceStatus = await _isDeviceConfigured();
          if (_deviceStatus == null) {
            return false;
          } else {
            return true;
          }
        } else {
          errorMessage = validateRes!.message;
          notify;
          return false;
        }
      }
    }
    clearMessage();
    return null;
  }

  Future<bool?> sendOtpToMail({required String email}) async {
    succMessage = null;
    errorMessage = null;
    loading = true;
    notify;
    OtpSendRes? otpSendRes;
    try {
      otpSendRes = await Handler.sendOtpToMail(email: email);
      succMessage = otpSendRes?.message;
    } catch (e) {
      errorMessage = e.toString();
    }
    loading = false;
    notify;

    clearMessage();

    return otpSendRes != null;
  }

  // forgot Password section

  final forEmailCltr = TextEditingController();

  Future<void> forgotPass() async {
    succMessage = null;
    errorMessage = null;
    loading = true;
    notify;
    try {
      final res = await Handler.forgotPassword(email: forEmailCltr.text);
      succMessage = res?.message;
      forEmailCltr.clear();
    } catch (e) {
      errorMessage = e.toString();
    }
    loading = false;
    notify;
    clearMessage();
  }

  // register email section
  bool initvalidateOtpOnRegister = false;
  final fullNameCltr = TextEditingController();
  String? otpCode;

  List<CountryCityState>? countryList;
  int? countryIndex;
  int? stateIndex;
  int? cityIndex;
  int? suburbIndex;
  int? phoneCodeIndex;
  final phoneCltr = TextEditingController();
  final passwordCltr = TextEditingController();
  final confirmPasswordCltr = TextEditingController();
  bool registerBtnLoad = false;

  Future<bool?> sendOtpToMailRegister({required String email}) async {
    succMessage = null;
    errorMessage = null;
    loading = true;
    notify;
    OtpSendRes? otpSendRes;
    try {
      otpSendRes = await Handler.sendOtpToMailRegister(email: email);
      succMessage = otpSendRes?.message;
    } catch (e) {
      errorMessage = e.toString();
    }
    loading = false;
    notify;

    clearMessage();

    return otpSendRes != null;
  }

  Future<void> getCountryData() async {
    final countryData = await Handler.getCommonListCountry();
    countryList = countryData?.countries;
    setDefaultData();
    loading = false;
    notify;
  }

  setDefaultData() {
    if (countryList != null && countryList!.any((e) => e.isSelected ?? false)) {
      countryIndex = countryList!.indexWhere((e) => e.isSelected ?? false);
      phoneCodeIndex = countryList!.indexWhere((e) => e.isSelected ?? false);
    }
  }

  Future<bool?> registerUser() async {
    final _register = RegisterReq();
    // _register.channelPlatForm = "POSMobile";
    _register.fullName = fullNameCltr.text;
    _register.email = emailCltr.text;
    _register.password = passwordCltr.text;
    _register.confirmPassword = confirmPasswordCltr.text;

    _register.phoneNumber = phoneCltr.text;
    _register.otp = otpCode;

    if (countryList != null && countryList!.isNotEmpty) {
      if (phoneCodeIndex != null) {
        _register.countryPhoneNumberPrefixId = countryList![phoneCodeIndex!].id;
      }

      if (countryIndex != null) {
        _register.countryId = countryList![countryIndex!].id;

        if (stateIndex != null) {
          _register.stateId =
              countryList![countryIndex!].states![stateIndex!].id;

          if (cityIndex != null) {
            _register.cityId = countryList![countryIndex!]
                .states![cityIndex!]
                .cities![cityIndex!]
                .id;

            if (suburbIndex != null) {
              _register.suburbId = countryList![countryIndex!]
                  .states![cityIndex!]
                  .cities![cityIndex!]
                  .suburbs![suburbIndex!]
                  .id;
            }
          }
        }
      }
    }
    loading = true;
    registerBtnLoad = true;
    notify;
    Message? status;

    try {
      status = await Handler.registerUser(registerReq: _register);
      if (status != null) {
        succMessage = status.message;
      }
    } catch (e) {
      errorMessage = e.toString();
    }

    clearMessage();

    loading = false;
    registerBtnLoad = false;
    notify;

    return status != null;
  }

  void clearMessage() {
    Future.delayed(Duration(seconds: 5), () {
      succMessage = null;
      errorMessage = null;
      notify;
    });
  }

  void clearRegisteredUserData() {
    initvalidateOtpOnRegister = false;
    fullNameCltr.clear();
    otpCode = null;
    countryIndex = null;
    stateIndex = null;
    cityIndex = null;
    suburbIndex = null;
    phoneCodeIndex = null;
    phoneCltr.clear();
    passwordCltr.clear();
    confirmPasswordCltr.clear();
  }

  // logout

  void logOut() {
    GlobalCVP.permissionLoad = true;
    GlobalCVP.setCurrentPage(0);
    _showPass = false;
    setAuthStatus = AuthStatus.UNAUTHENTICATED;
    emailCltr.clear();
    passCltr.clear();
    PromoUtils.clear();
    DbLocalData.deleteOrderNotify();
    // DbLocalData.deleteMenuRes();
    MultiPro.reset;
    Handler.logout();
    clearDeviceInfo();
    SignalRCore.stop();
  }

  //get login banner images

  List<UserAddSecData>? bannerList;

  Future<void> getBannerImages() async {
    final dbBanners = await DbLocalData.getLoginBanners();
    if (dbBanners != null) {
      bannerList = dbBanners.userTypes;
      notify;
    }
    final serverBanner = await Handler.getLoginBannners();
    if (serverBanner != null) {
      bannerList = serverBanner;
      notify;
      DbLocalData.updateLoginBanners(
          bannerData: UserAddSec(userTypes: serverBanner));
    }
  }

  // List<InitCountryData>? initCountryList;
  // int? loginCountryIndex;

  // Future<void> getCountryList() async {
  //   initCountryList = await Handler.getInitCountryList();
  //   if (initCountryList != null && initCountryList!.isNotEmpty) {
  //     if (initCountryList?.any((e) => e.name! == "Australia") ?? false) {
  //       final index =
  //           initCountryList?.indexWhere((e) => e.name! == "Australia");
  //       if (index! >= 0) {
  //         loginCountryIndex = index;
  //       }
  //     }
  //   }
  //   notify;
  // }

  // void onChangedCountry() {
  //   if (loginCountryIndex != null &&
  //       initCountryList?[loginCountryIndex!].mobilePosApiBaseUrl != null) {
  //     final _baseUrl =
  //         (initCountryList![loginCountryIndex!].mobilePosApiBaseUrl ?? '') +
  //             '/api/';
  //     AppEnviro.baseUrl = _baseUrl;

  //     SharedPrefs.setBaseUrl = _baseUrl;
  //   }
  // }

  // send deviceid email
  Future<bool?> sendDeviceIdEmail() async {
    loading = true;
    notify;
    final status = await Handler.sendEmailDeviceIdCommon();
    loading = false;
    notify;
    return status;
  }

  // deviceId Check

  int? selectedStoreIndex;

  Future<bool?> _isDeviceConfigured() async {
    userStoreRes = await Handler.getStoreList();
    if (userStoreRes == null) return null;

    await DbLocalData.updateAllStores(data: userStoreRes);

    if (userStoreRes?.userType == UserTypeEnum.AppTestUser.name) {
      setAuthStatus = AuthStatus.AUTHENTICATE;

      await _setStoreList();

      return true;
    } else if (userStoreRes?.userType == UserTypeEnum.SuperAdmin.name) {
      if (userStoreRes?.isConfigured ?? false) {
        setAuthStatus = AuthStatus.AUTHENTICATE;
        await _setStoreList(deviceId: userStoreRes?.id);

        return true;
      } else {
        setAuthStatus = AuthStatus.VERIFICATION;
        return false;
      }

      // setAuthStatus = AuthStatus.AUTHENTICATE;
      // await _setStoreList(tagFcm: false);
      // return true;
    } else {
      if ((userStoreRes?.id?.isNotEmpty ?? false) &&
          (userStoreRes?.isConfigured ?? false)) {
        setAuthStatus = AuthStatus.AUTHENTICATE;
        await _setStoreList(deviceId: userStoreRes?.id);

        return true;
      } else {
        setAuthStatus = AuthStatus.VERIFICATION;
        return false;
      }
    }
  }

  // DeviceTypeRes? deviceTypeRes;
  // int? selectedDeviceType;
  final deviceNameCltr = TextEditingController();
  bool isMainDevice = false;

  // Future<void> getDeviceList() async {
  //   deviceTypeRes = await Handler.getConfigureDeviceList();
  //   if (deviceTypeRes?.deviceTypes
  //           ?.any((a) => a.value?.toLowerCase().contains('pos') ?? false) ??
  //       false)
  //     selectedDeviceType = deviceTypeRes?.deviceTypes
  //         ?.indexWhere((a) => a.value?.toLowerCase().contains('pos') ?? false);
  //   notify;
  // }

  bool configureLoad = false;

  Future<bool> configureDevice() async {
    final _storeId = (userStoreRes?.userStores?.isNotEmpty ?? false) &&
            selectedStoreIndex != null
        ? (userStoreRes?.userStores?[selectedStoreIndex!].id ?? '')
        : "";

    // final _deviceId = (deviceTypeRes?.deviceTypes?.isNotEmpty ?? false) &&
    //         selectedDeviceType != null
    //     ? (deviceTypeRes?.deviceTypes?[selectedDeviceType!].id ?? '')
    //     : "";

    final _req = ConfigureDeviceReq(
      name: deviceNameCltr.text,
      isMainDevice: isMainDevice,
      storeId: _storeId,
      deviceIdenfitier: await SupportHandler.getDeviceId,
      fcmToken: await SupportHandler.getFcmToken,
      deviceTypeId: "",
    );
    configureLoad = true;
    notify;

    final _status = await Handler.configureDevice(data: _req);

    if (_status ?? false) {
      await _isDeviceConfigured();
    }
    configureLoad = false;
    notify;

    return _status ?? false;
  }

  void clearDeviceInfo() {
    selectedStoreIndex = null;
    // deviceTypeRes = null;
    // selectedDeviceType = null;
    deviceNameCltr.clear();
    isMainDevice = false;
    configureLoad = false;
  }

  Future<bool> _setStoreList({String? deviceId}) async {
    if (userStoreRes?.userStores?.isNotEmpty ?? false) {
      final _activeStore =
          (userStoreRes?.userStores?.any((a) => a.isActive ?? false) ?? false)
              ? userStoreRes?.userStores?.firstWhere((a) => a.isActive ?? false)
              : userStoreRes?.userStores?.first;

      _activeStore?.isActive = true;
      selectedStoreIndex =
          userStoreRes?.userStores?.indexWhere((a) => a.isActive ?? false);

      await SharedPrefs.setStoreId(_activeStore?.id ?? '');
      await _getStoreDetail(deviceId: deviceId);
    }
    return userStoreRes?.userStores != null;
  }

  Future<void> _getStoreDetail({String? deviceId}) async {
    if (deviceId != null) {
      await Handler.tagFcmTokenDevice(deviceId: deviceId);
    }
    final _storeDetail = await Handler.getStoreDetail();
    await DbLocalData.updateStoreData(data: _storeDetail);
  }

  void get notify => notifyListeners();
}

enum AuthPageState { Login, Register }

enum UserTypeEnum {
  Admin,
  Employee,
  SuperAdmin,
  AppTestUser,
}
