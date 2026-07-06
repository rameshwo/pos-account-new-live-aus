import 'package:flutter/material.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/model/profile/create_up_user.dart';
import 'package:pos_account/model/profile/user_add_sec.dart';
import 'package:pos_account/model/profile/user_info.dart';
import 'package:pos_account/model/ui_model/screen_time_model.dart';
import 'package:pos_account/repository/handler.dart';
import 'package:pos_account/services/database/database/db_local_data.dart';
import 'package:pos_account/services/database/shared_pref.dart';
import 'package:pos_account/services/image/image_service.dart';

class ProfilePro extends ChangeNotifier {
  int selectedTab = 0;

  final formKey = GlobalKey<FormState>();

  final nameCltr = TextEditingController();
  final emailCltr = TextEditingController();
  final phoneCltr = TextEditingController();
  final addressCltr = TextEditingController();
  final postalCltr = TextEditingController();

  int? phoneCodeIndex;
  int? countryIndex;
  int? stateIndex;
  int? cityIndex;
  int? suburbIndex;

  //acount information
  int? defaultScreenIndex;
  final pinCltr = TextEditingController();
  final confirmPinCltr = TextEditingController();
  int? intervalIndex;
  bool enablePinCode = false;

  bool pushNotificationEnable = true;

  UserAddSec? userAddSec;

  UserInfo? userInfo;

  bool loading = true;

  bool updateLoad = false;

  Future<void> getData({bool loadAddSec = true}) async {
    if (loadAddSec) userAddSec = await Handler.getUserAddSec();
    final userId = await SharedPrefs.userId;
    userInfo = await Handler.getUserInfo(userId: userId);

    setData();
    if (userInfo != null) {
      DbLocalData.updateUserInfo(data: userInfo!);
      // .then((_) => GlobalCVP.getUserInfo());
    }

    loading = false;
    notify;
  }

  void setData() {
    if (userInfo == null) return;

    nameCltr.text = userInfo?.name ?? '';
    emailCltr.text = userInfo?.email ?? '';
    phoneCltr.text = userInfo?.phoneNumber ?? '';
    addressCltr.text = userInfo?.address ?? '';
    postalCltr.text = userInfo?.postalCode ?? '';

    pushNotificationEnable = userInfo?.isPushNotificationEnabled ?? true;
    _filePath = userInfo?.image;

    if (userAddSec == null) return;

    if ((userInfo!.countryPhoneNumberPrefixId?.isNotEmpty ?? false) &&
        userAddSec!.countryCityStates!.any((e) =>
            e.id?.toLowerCase() ==
            userInfo!.countryPhoneNumberPrefixId?.toLowerCase())) {
      phoneCodeIndex = userAddSec!.countryCityStates!.indexWhere((e) =>
          e.id?.toLowerCase() ==
          userInfo!.countryPhoneNumberPrefixId?.toLowerCase());
    } else if (userAddSec!.countryCityStates!
        .any((e) => e.isSelected ?? false)) {
      phoneCodeIndex = userAddSec!.countryCityStates!
          .indexWhere((e) => e.isSelected ?? false);
    }

    if ((userInfo!.countryId?.isNotEmpty ?? false) &&
        (userAddSec?.countryCityStates?.any((e) =>
                e.id?.toLowerCase() == userInfo!.countryId?.toLowerCase()) ??
            false)) {
      countryIndex = userAddSec?.countryCityStates!.indexWhere(
          (e) => e.id?.toLowerCase() == userInfo!.countryId?.toLowerCase());

      if ((userInfo?.stateId?.isNotEmpty ?? false) &&
          (userAddSec?.countryCityStates?[countryIndex!].states?.any((e) =>
                  e.id?.toLowerCase() == userInfo?.stateId?.toLowerCase()) ??
              false)) {
        stateIndex = userAddSec?.countryCityStates?[countryIndex!].states!
            .indexWhere(
                (e) => e.id?.toLowerCase() == userInfo?.stateId?.toLowerCase());

        if ((userInfo?.cityId?.isNotEmpty ?? false) &&
            (userAddSec?.countryCityStates?[countryIndex!].states?[stateIndex!]
                    .cities
                    ?.any((e) =>
                        e.id?.toLowerCase() ==
                        userInfo?.cityId?.toLowerCase()) ??
                false)) {
          cityIndex = userAddSec
              ?.countryCityStates?[countryIndex!].states?[stateIndex!].cities
              ?.indexWhere((e) =>
                  e.id?.toLowerCase() == userInfo?.cityId?.toLowerCase());

          if ((userInfo?.suburbId?.isNotEmpty ?? false) &&
              (userAddSec?.countryCityStates?[countryIndex!]
                      .states?[stateIndex!].cities?[cityIndex!].suburbs
                      ?.any((e) =>
                          e.id?.toLowerCase() ==
                          userInfo?.suburbId?.toLowerCase()) ??
                  false)) {
            suburbIndex = userAddSec?.countryCityStates?[countryIndex!]
                .states?[stateIndex!].cities?[cityIndex!].suburbs
                ?.indexWhere((e) =>
                    e.id?.toLowerCase() == userInfo?.suburbId?.toLowerCase());
          }
        }
      }
    } else if (userAddSec?.countryCityStates
            ?.any((e) => e.isSelected ?? false) ??
        false) {
      countryIndex = userAddSec?.countryCityStates!
          .indexWhere((e) => e.isSelected ?? false);
    }

    if (userAddSec?.posTabDefaultScreens?.any((e) =>
            e.name?.toLowerCase() ==
            userInfo?.posTabDefaultScreenName?.toLowerCase()) ??
        false) {
      defaultScreenIndex = userAddSec!.posTabDefaultScreens!.indexWhere((e) =>
          e.name?.toLowerCase() ==
          userInfo?.posTabDefaultScreenName?.toLowerCase());
    }

    pinCltr.text = userInfo?.loginPinCode ?? '';
    confirmPinCltr.text = userInfo?.loginPinCode ?? '';

    enablePinCode = userInfo?.enableLoginPinCodePopUpScreen ?? false;

    if (ScreenTimeOut.any((e) =>
        e.duration == userInfo?.loginPinAutoLogOffInterval?.inDouble.floor())) {
      intervalIndex = ScreenTimeOut.indexWhere((e) =>
          e.duration == userInfo?.loginPinAutoLogOffInterval?.inDouble.floor());
    } else {
      final _interval = userInfo?.loginPinAutoLogOffInterval?.inDouble.floor();
      if (_interval != null && _interval != 0) {
        final _screenTime = ScreenTimeModel(
          title: Utils.convertSeconds(_interval),
          duration: _interval,
          enable: true,
        );
        ScreenTimeOut.add(_screenTime);
        ScreenTimeOut.sort((a, b) => a.duration.compareTo(b.duration));
        final _first = ScreenTimeOut.first;
        ScreenTimeOut.add(_first);
        ScreenTimeOut.removeAt(0);

        intervalIndex = ScreenTimeOut.indexWhere((e) =>
            e.duration ==
            userInfo?.loginPinAutoLogOffInterval?.inDouble.floor());
      }
    }
  }

  Future<bool?> updateUser() async {
    final updateUser = CreateUpUser()
      ..id = userInfo?.id
      ..fullName = nameCltr.text
      ..phoneNumber = phoneCltr.text
      ..email = emailCltr.text
      ..address = addressCltr.text
      ..postalCode = postalCltr.text
      ..loginPinCode = pinCltr.text
      ..confirmLoginPinCode = confirmPinCltr.text
      ..isActive = userInfo?.isActive ?? false
      ..enableLoginPinCodePopUpScreen = enablePinCode
      ..isPushNotificationEnabled = pushNotificationEnable;

    if (phoneCodeIndex != null && userAddSec!.countryCityStates != null)
      updateUser.countryPhoneNumberPrefixId =
          userAddSec!.countryCityStates![phoneCodeIndex!].id;
    if (countryIndex != null) {
      updateUser.countryId = userAddSec!.countryCityStates![countryIndex!].id;

      if (stateIndex != null) {
        updateUser.stateId = userAddSec!
            .countryCityStates![countryIndex!].states![stateIndex!].id;

        if (cityIndex != null) {
          updateUser.cityId = userAddSec!.countryCityStates![countryIndex!]
              .states![stateIndex!].cities![cityIndex!].id;

          if (suburbIndex != null) {
            updateUser.suburbId = userAddSec!
                .countryCityStates![countryIndex!]
                .states![stateIndex!]
                .cities![cityIndex!]
                .suburbs![suburbIndex!]
                .id;
          }
        }
      }
    }

    if (defaultScreenIndex != null) {
      updateUser.posTabDefaultScreenName =
          userAddSec?.posTabDefaultScreens?[defaultScreenIndex!].name;
    } else {
      updateUser.posTabDefaultScreenName = "";
    }

    if (intervalIndex != null) {
      updateUser.loginPinAutoLogOffInterval =
          ScreenTimeOut[intervalIndex!].duration.toString();
    }

    if (getFilePath != null &&
        getFilePath!.isEmpty &&
        userInfo?.image != null &&
        userInfo!.image!.isNotEmpty) {
      updateUser.isImageDeleted = true;
    }

    updateLoad = true;
    notify;

    final status = await Handler.updateUserProfile(
        updateUser: updateUser, filePath: _filePath);
    updateLoad = false;
    notify;
    if (status ?? false) {
      await getData(loadAddSec: false);
    }

    return status;
  }

  Future<String?> generatePin() async {
    loading = true;
    notify;

    final _pin = await Handler.generatePin();
    pinCltr.text = _pin ?? '';
    confirmPinCltr.text = _pin ?? '';

    loading = false;
    notify;

    return _pin;
  }

  void get notify => notifyListeners();

  //google places section

  // AutocompleteResponse? _autoCompleteRes;

  // AutocompleteResponse? get getAutoPlaces => _autoCompleteRes;

  // Future<void> getPlaces({required String input, String? country}) async {
  //   _autoCompleteRes = await MapUtils.getPlaces(
  //     input: input,
  //     region: country,
  //   );
  //   notifyListeners();
  // }

  String? _placeId;
  String? get getPlaceId => _placeId;

  set setPlaceId(String? val) {
    _placeId = val;
  }

  //file picker section
  String? _filePath;
  String? get getFilePath => _filePath;

  set setFilepath(String? val) {
    _filePath = val;
    notify;
  }

  void getFilePick() async {
    final file = await ImageService.filePick(
        showRemoveTile: getFilePath != null &&
            getFilePath!.isNotEmpty &&
            userInfo?.image != null &&
            userInfo!.image!.isNotEmpty);
    if (file != null) {
      setFilepath = file;
      notify;
    }
  }

  void clear() {
    selectedTab = 0;
    nameCltr.clear();
    emailCltr.clear();
    phoneCltr.clear();
    addressCltr.clear();
    postalCltr.clear();
    phoneCodeIndex = null;
    countryIndex = null;
    stateIndex = null;
    cityIndex = null;
    suburbIndex = null;
    pushNotificationEnable = true;
    userAddSec = null;
    loading = true;
    updateLoad = false;
    defaultScreenIndex = null;
    pinCltr.clear();
    confirmPinCltr.clear();
    intervalIndex = null;
    enablePinCode = false;
  }
}
