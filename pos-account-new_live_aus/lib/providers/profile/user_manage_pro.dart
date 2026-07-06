import 'package:flutter/material.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/booking/all_customer.dart';
import 'package:pos_account/model/home/setting/general/category/restro_table_model.dart';
import 'package:pos_account/model/profile/all_employees.dart';
import 'package:pos_account/model/profile/assign_service_model.dart';
import 'package:pos_account/model/profile/commission_details.dart';
import 'package:pos_account/model/profile/emp_add_sec.dart';
import 'package:pos_account/model/ui_model/screen_time_model.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/repository/handler.dart';
import 'package:pos_account/services/database/shared_pref.dart';
import 'package:pos_account/services/image/image_service.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../model/home/menu/place_order/all_cus_add_sec.dart';
import '../../model/home/product/setmenu/prod_by_prod_res.dart';
import '../../model/profile/commison_add_sec.dart';
import '../../model/profile/emp_info.dart';

class UserManagePro extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  final commFormKey = GlobalKey<FormState>();

  final nameCltr = TextEditingController();
  final preferNameCltr = TextEditingController();
  final emailCltr = TextEditingController();
  final phoneCltr = TextEditingController();
  // final addressCltr = TextEditingController();
  final postalCltr = TextEditingController();

  final empCodeCltr = TextEditingController();
  final jobTitleCltr = TextEditingController();
  final addressCltr = TextEditingController();
  final salaryCltr = TextEditingController();
  final hourlyRateCltr = TextEditingController();
  final emergNameCltr = TextEditingController();
  // final emergContactCltr = TextEditingController();
  final emergPhoneCltr = TextEditingController();
  final emergEmailCltr = TextEditingController();
  final refreshController = RefreshController();
  final passCltr = TextEditingController();
  final confirmPassCltr = TextEditingController();

  bool showPass = false;
  bool showConfrimPass = false;

  int? phoneCodeIndex;
  int? countryIndex;
  int? stateIndex;
  int? cityIndex;
  int? genderIndex;
  // int? suburbIndex;
  int? userTypeIndex;
  int? userRoleIndex;
  int? defaultScreenIndex;
  int? commissionTypeIndex;
  int? intervalIndex;
  bool enablePinCode = false;
  String? curSym;
  final pinCltr = TextEditingController();
  final confirmPinCltr = TextEditingController();

  final commissionPerList = <ToFromData>[
    ToFromData(
        fromCltr: TextEditingController(),
        toCltr: TextEditingController(),
        dataCltr: TextEditingController()),
  ];

  bool pushNotificationEnable = true;
  bool isActive = true;
  bool isMarketingPromotion = false;
  bool enableLoyality = false;
  int? selectedSubCatIndex = 0;

  // UserAddSec? userAddSec;
  CommissionAddSec? commAddSec;
  EmpAddSec? empAddSec;

  bool loading = true;
  bool updateLoad = false;

  // AllUsers? allUsers;
  AllEmployees? allEmployees;
  AllCustomer? allCustomer;
  List<ParentProductCategory> servicesTypesList = [];

  final employeeTableList = RTableData(
    headerList: [
      LN.empCode,
      LN.preferredName,
      LN.jobTitle,
      LN.phoneNumber,
      LN.email,
      LN.action,
    ],
    hasAction: true,
    showCheckBox: false,
  );

  final customerTableList = RTableData(
    headerList: [
      LN.fullName,
      LN.phoneNumber,
      LN.email,
      "Promotion Enabled",
      "Loyalty Enabled",
      LN.action,
    ],
    hasAction: true,
    showCheckBox: false,
  );

  final userTableList = RTableData(
    headerList: [
      "",
      LN.fullName,
      LN.userType,
      LN.phoneNumber,
      LN.email,
      LN.action,
    ],
    hasAction: true,
    showCheckBox: false,
  );

  int pagiPage = 1;
  int empPage = 1;
  int empPageSize = 10;
  int userPageSize = 10;
  int cusPage = 1;
  int cusPageSize = 10;

  bool userLoad = true;

  // final searchCltr = TextEditingController();

  final searchCltr = TextEditingController();
  final filterCltr = TextEditingController();

  clear() {
    nameCltr.clear();
    emailCltr.clear();
    phoneCltr.clear();
    postalCltr.clear();
    empCodeCltr.clear();
    jobTitleCltr.clear();
    addressCltr.clear();
    salaryCltr.clear();
    hourlyRateCltr.clear();
    emergNameCltr.clear();
    // emergContactCltr.clear();
    emergPhoneCltr.clear();
    emergEmailCltr.clear();
    commAddSec = null;
    // empAddSec = null;
    commissionTypeIndex = null;
    commissionPerList.clear();
    commissionPerList.add(ToFromData(
        fromCltr: TextEditingController(),
        toCltr: TextEditingController(),
        dataCltr: TextEditingController()));
    // passCltr.clear();
    // confirmPassCltr.clear();
    phoneCodeIndex = null;
    countryIndex = null;
    stateIndex = null;
    cityIndex = null;
    // suburbIndex = null;
    userTypeIndex = null;
    userRoleIndex = null;
    defaultScreenIndex = null;
    intervalIndex = null;
    pinCltr.clear();
    isActive = true;
    isMarketingPromotion = false;
    enableLoyality = false;
    customerTypeIndex = null;
    cusGroupIndex = null;
    enablePinCode = false;
    _filePath = null;
    userId = "";
    empId = "";
    cusId = "";
    genderIndex = null;
    // userInfo = null;
    empInfo = null;
    commAddSec = null;
    commDetails = null;
    searchCltr.clear();
    preferNameCltr.clear();
    passCltr.clear();
    confirmPassCltr.clear();
    showPass = false;
    showConfrimPass = false;
    confirmPinCltr.clear();
  }

  // Future<void> getUserData() async {
  //   _filePath = null;
  //   userAddSec = await Handler.getUserAddSec();
  //   setData();
  //   getUserInfo();

  //   loading = false;
  //   notify;
  // }

  String? dateFormat;
  CustomerAddSecRes? customerAddSecRes;
  int? customerTypeIndex;
  int? cusGroupIndex;

  Future<void> getCusAddSec() async {
    dateFormat = await SharedPrefs.dateFormat;
    customerAddSecRes = CustomerAddSecRes.fromJson(GlobalCVP.allAddSection);
    //  await Handler.getAllCusAddSecList();
    _setCusAddSecData();
    getCustomerInfo();
  }

  _setCusAddSecData() {
    if (customerAddSecRes?.customerType?.any((e) => e.isSelected ?? false) ??
        false) {
      customerTypeIndex = customerAddSecRes!.customerType!
          .indexWhere((e) => e.isSelected ?? false);
    }
    if (customerAddSecRes?.countries?.any((e) => e.isSelected ?? false) ??
        false) {
      phoneCodeIndex = customerAddSecRes!.countries!
          .indexWhere((e) => e.isSelected ?? false);
      countryIndex = customerAddSecRes!.countries!
          .indexWhere((e) => e.isSelected ?? false);
    }

    if (customerAddSecRes?.customerGroups?.any((e) => e.isSelected ?? false) ??
        false) {
      cusGroupIndex = customerAddSecRes!.customerGroups!
          .indexWhere((e) => e.isSelected ?? false);
    }

    notify;
  }

  Future<void> getCustomerData() async {
    await getCusAddSec();
    loading = false;
    notify;
  }

  // setData() {
  //   if (userAddSec?.countryCityStates != null &&
  //       userAddSec!.countryCityStates!.any((e) => e.isSelected == true)) {
  //     countryIndex =
  //         userAddSec!.countryCityStates!.indexWhere((e) => e.isSelected!);
  //     phoneCodeIndex =
  //         userAddSec!.countryCityStates!.indexWhere((e) => e.isSelected!);
  //   }

  //   if (ScreenTimeOut.any((e) => e.duration == 0))
  //     intervalIndex = ScreenTimeOut.indexWhere((e) => e.duration == 0);
  // }

  String userId = "";

  String cusId = "";

  //add up customer
  Future<bool> addUpCustomer() async {
    final updateCus = CusData()
      ..id = cusId
      ..name = nameCltr.text
      ..phoneNumber = phoneCltr.text
      ..email = emailCltr.text
      ..postalCode = postalCltr.text
      ..isLoyaltyEnabled = enableLoyality
      ..isMarketingPromotionEnabled = isMarketingPromotion
      ..customerTypeId =
          customerAddSecRes?.customerType?[customerTypeIndex ?? 0].id;

    if (customerAddSecRes?.customerGroups?.isNotEmpty ?? false)
      updateCus.customerGroupId =
          customerAddSecRes?.customerGroups?[cusGroupIndex ?? 0].id;

    if (phoneCodeIndex != null && customerAddSecRes?.countries != null)
      updateCus.countryPhoneNumberPrefixId =
          customerAddSecRes!.countries![phoneCodeIndex!].id;

    if (countryIndex != null) {
      updateCus.countryId = customerAddSecRes!.countries![countryIndex!].id;
    }

    updateLoad = true;
    notify;

    final status = await Handler.addUpCus(
      cusData: updateCus,
    );
    updateLoad = false;
    notify;

    return status ?? false;
  }

  // Future<bool> addUpUser() async {
  //   final _updateUser = CreateUpUser()
  //     ..id = userId
  //     ..fullName = nameCltr.text
  //     ..phoneNumber = phoneCltr.text
  //     ..email = emailCltr.text
  //     // ..address = addressCltr.text
  //     ..postalCode = postalCltr.text
  //     // ..password = passCltr.text
  //     // ..confirmPassword = confirmPassCltr.text
  //     ..channelPlatform = "POSMobile"
  //     ..isActive = isActive
  //     ..enableLoginPinCodePopUpScreen = enablePinCode
  //     ..loginPinCode = pinCltr.text;

  //   if (phoneCodeIndex != null && userAddSec!.countryCityStates != null)
  //     _updateUser.countryPhoneNumberPrefixId =
  //         userAddSec!.countryCityStates![phoneCodeIndex!].id;

  //   if (countryIndex != null) {
  //     _updateUser.countryId = userAddSec!.countryCityStates![countryIndex!].id;

  //     if (stateIndex != null) {
  //       _updateUser.stateId = userAddSec!
  //           .countryCityStates![countryIndex!].states![stateIndex!].id;

  //       if (cityIndex != null) {
  //         _updateUser.cityId = userAddSec!.countryCityStates![countryIndex!]
  //             .states![stateIndex!].cities![cityIndex!].id;

  //         // if (suburbIndex != null) {
  //         //   _updateUser.suburbId = userAddSec!
  //         //       .countryCityStates![countryIndex!]
  //         //       .states![stateIndex!]
  //         //       .cities![cityIndex!]
  //         //       .suburbs![suburbIndex!]
  //         //       .id;
  //         // }
  //       }
  //     }
  //   }

  //   if (userTypeIndex != null && userAddSec!.userTypes != null) {
  //     _updateUser.userTypeId = userAddSec!.userTypes![userTypeIndex!].id;
  //     if (userAddSec!.userTypes![userTypeIndex!].value!.contains("Admin")) {
  //       _updateUser.isPushNotificationEnabled = pushNotificationEnable;
  //     } else {
  //       _updateUser.isPushNotificationEnabled = false;
  //     }
  //   }

  //   if (userRoleIndex != null && userAddSec?.roles != null) {
  //     _updateUser.roleId = userAddSec!.roles![userRoleIndex!].id;
  //   }

  //   if (defaultScreenIndex != null &&
  //       userAddSec?.posTabDefaultScreens != null) {
  //     _updateUser.posTabDefaultScreenName =
  //         userAddSec!.posTabDefaultScreens![defaultScreenIndex!].name;
  //   } else {
  //     _updateUser.posTabDefaultScreenName = "";
  //   }

  //   if (intervalIndex != null) {
  //     _updateUser.loginPinAutoLogOffInterval =
  //         ScreenTimeOut[intervalIndex!].duration.toString();
  //   }

  //   if (getFilePath != null &&
  //       getFilePath!.isEmpty &&
  //       userInfo?.image != null &&
  //       userInfo!.image!.isNotEmpty) {
  //     _updateUser.isImageDeleted = true;
  //   }

  //   updateLoad = true;
  //   notify;

  //   final _status = await Handler.createUpUser(
  //     createUpUser: _updateUser,
  //     filePath: _filePath,
  //   );
  //   if (_status ?? false) {
  //     clear();
  //   }

  //   updateLoad = false;
  //   notify;

  //   return _status ?? false;
  // }

  // UserInfo? userInfo;
  EmployeeInfo? empInfo;
  CusData? cusInfo;

  // Future<void> getUserInfo() async {
  //   if (userId.isNotEmpty) {
  //     userInfo = await Handler.getUserInfo(userId: userId);
  //     setUserData();
  //   }
  //   loading = false;
  //   notify;
  // }

  ServiceCommissionDetailsModel? commDetails;

  Future<void> getCommDetails() async {
    loading = true;
    notify;
    commDetails = await Handler.getCommissionDetails(employeeId: empId);
    setCommissionData();
    loading = false;
    notify;
  }

  void setCommissionData() {
    if (commDetails?.serviceCommissionTypeId != null &&
        (commDetails?.employeeServiceCommissionSettingViewModels?.isNotEmpty ??
            false)) {
      commissionPerList.clear();
      for (final e
          in commDetails!.employeeServiceCommissionSettingViewModels!) {
        commissionPerList.add(ToFromData(
            fromCltr: TextEditingController(text: e.amountFrom ?? ''),
            toCltr: TextEditingController(text: e.amountTo ?? ''),
            dataCltr:
                TextEditingController(text: e.commissionPercentage ?? '')));
      }
      commissionTypeIndex = commAddSec?.serviceCommissionTypes?.indexWhere(
          (e) =>
              e.id?.toLowerCase() ==
              commDetails?.serviceCommissionTypeId?.toLowerCase());
    }
    notifyListeners();
  }

  Future<void> getCommAddSec() async {
    loading = true;
    notify;
    curSym = await SharedPrefs.curSym;
    commAddSec = await Handler.getCommissionAddSec();

    getCommDetails();
  }

  void updateCommission() async {
    updateLoad = true;
    notify;
    if (commissionPerList.isNotEmpty) {
      commDetails?.employeeServiceCommissionSettingViewModels = [];
      for (final e in commissionPerList) {
        commDetails?.employeeServiceCommissionSettingViewModels?.add(
          EmployeeServiceCommissionSettingViewModels(
            amountFrom: e.fromCltr.text,
            amountTo: e.toCltr.text,
            commissionPercentage: e.dataCltr.text,
          ),
        );
      }
      commDetails?.employeeId = empId;
      commDetails?.serviceCommissionTypeId =
          commAddSec?.serviceCommissionTypes?[commissionTypeIndex ?? 0].id;
      await Handler.updateCommissionDetails(req: commDetails);
      updateLoad = false;
      notify;
    }
  }

  void addCommissionPer() {
    commissionPerList.add(ToFromData(
        fromCltr: TextEditingController(),
        toCltr: TextEditingController(),
        dataCltr: TextEditingController()));
    notifyListeners();
  }

  void removeCommissionPer(int index) {
    commissionPerList.removeAt(index);
    notifyListeners();
  }

  // void setUserData() {
  //   if (userAddSec?.userTypes != null &&
  //       userAddSec!.userTypes!.any((e) =>
  //           e.id?.toLowerCase() == userInfo?.userTypeId?.toLowerCase())) {
  //     userTypeIndex = userAddSec!.userTypes!.indexWhere(
  //         (e) => e.id?.toLowerCase() == userInfo?.userTypeId?.toLowerCase());
  //   }

  //   if (userAddSec?.roles != null &&
  //       userAddSec!.roles!.any(
  //           (e) => e.id?.toLowerCase() == userInfo?.roleId?.toLowerCase())) {
  //     userRoleIndex = userAddSec!.roles!.indexWhere(
  //         (e) => e.id?.toLowerCase() == userInfo?.roleId?.toLowerCase());
  //   }

  //   if (userAddSec?.posTabDefaultScreens != null &&
  //       userAddSec!.posTabDefaultScreens!.any((e) =>
  //           e.name?.toLowerCase() ==
  //           userInfo?.posTabDefaultScreenName?.toLowerCase())) {
  //     defaultScreenIndex = userAddSec!.posTabDefaultScreens!.indexWhere((e) =>
  //         e.name?.toLowerCase() ==
  //         userInfo?.posTabDefaultScreenName?.toLowerCase());
  //   }

  //   if (ScreenTimeOut.any((e) =>
  //       e.duration == userInfo?.loginPinAutoLogOffInterval?.inDouble.floor())) {
  //     intervalIndex = ScreenTimeOut.indexWhere((e) =>
  //         e.duration == userInfo?.loginPinAutoLogOffInterval?.inDouble.floor());
  //   } else {
  //     final _interval = userInfo?.loginPinAutoLogOffInterval?.inDouble.floor();
  //     if (_interval != null && _interval != 0) {
  //       final _screenTime = ScreenTimeModel(
  //         title: Utils.convertSeconds(_interval),
  //         duration: _interval,
  //         enable: true,
  //       );
  //       ScreenTimeOut.add(_screenTime);
  //       ScreenTimeOut.sort((a, b) => a.duration.compareTo(b.duration));
  //       final _first = ScreenTimeOut.first;
  //       ScreenTimeOut.add(_first);
  //       ScreenTimeOut.removeAt(0);

  //       intervalIndex = ScreenTimeOut.indexWhere((e) =>
  //           e.duration ==
  //           userInfo?.loginPinAutoLogOffInterval?.inDouble.floor());
  //     }
  //   }

  //   nameCltr.text = userInfo?.name ?? '';
  //   pinCltr.text = userInfo?.loginPinCode ?? '';
  //   emailCltr.text = userInfo?.email ?? '';
  //   if (userAddSec?.countryCityStates != null &&
  //       userAddSec!.countryCityStates!.any((e) =>
  //           e.id?.toLowerCase() ==
  //           userInfo?.countryPhoneNumberPrefixId?.toLowerCase())) {
  //     phoneCodeIndex = userAddSec!.countryCityStates!.indexWhere((e) =>
  //         e.id?.toLowerCase() ==
  //         userInfo?.countryPhoneNumberPrefixId?.toLowerCase());
  //   }

  //   phoneCltr.text = userInfo?.phoneNumber ?? '';

  //   if (userInfo!.countryId != null &&
  //       (userAddSec?.countryCityStates?.any((e) =>
  //               e.id?.toLowerCase() == userInfo!.countryId?.toLowerCase()) ??
  //           false)) {
  //     countryIndex = userAddSec?.countryCityStates!.indexWhere(
  //         (e) => e.id?.toLowerCase() == userInfo!.countryId?.toLowerCase());
  //     phoneCodeIndex = userAddSec!.countryCityStates!.indexWhere(
  //         (e) => e.id?.toLowerCase() == userInfo!.countryId?.toLowerCase());

  //     if (userInfo?.stateId != null &&
  //         (userAddSec?.countryCityStates?[countryIndex!].states?.any((e) =>
  //                 e.id?.toLowerCase() == userInfo?.stateId?.toLowerCase()) ??
  //             false)) {
  //       stateIndex = userAddSec?.countryCityStates?[countryIndex!].states!
  //           .indexWhere(
  //               (e) => e.id?.toLowerCase() == userInfo?.stateId?.toLowerCase());

  //       if (userInfo?.cityId != null &&
  //           (userAddSec?.countryCityStates?[countryIndex!].states?[stateIndex!]
  //                   .cities
  //                   ?.any((e) =>
  //                       e.id?.toLowerCase() ==
  //                       userInfo?.cityId?.toLowerCase()) ??
  //               false)) {
  //         cityIndex = userAddSec
  //             ?.countryCityStates?[countryIndex!].states?[stateIndex!].cities
  //             ?.indexWhere((e) =>
  //                 e.id?.toLowerCase() == userInfo?.cityId?.toLowerCase());

  //         // if (userInfo?.suburbId != null &&
  //         //     (userAddSec?.countryCityStates?[countryIndex!]
  //         //             .states?[stateIndex!].cities?[cityIndex!].suburbs
  //         //             ?.any((e) =>
  //         //                 e.id?.toLowerCase() ==
  //         //                 userInfo?.suburbId?.toLowerCase()) ??
  //         //         false)) {
  //         //   suburbIndex = userAddSec?.countryCityStates?[countryIndex!]
  //         //       .states?[stateIndex!].cities?[cityIndex!].suburbs
  //         //       ?.indexWhere((e) =>
  //         //           e.id?.toLowerCase() == userInfo?.suburbId?.toLowerCase());
  //         // }
  //       }
  //     }
  //   }

  //   // addressCltr.text = userInfo?.address ?? '';
  //   postalCltr.text = userInfo?.postalCode ?? '';
  //   isActive = userInfo?.isActive ?? false;
  //   enablePinCode = userInfo?.enableLoginPinCodePopUpScreen ?? false;

  //   _filePath = userInfo?.image;

  //   pushNotificationEnable = userInfo?.isPushNotificationEnabled ?? false;
  //   notify;
  // }

  void get notify => notifyListeners();

  //google places section
  // final _googlePlace = GooglePlace(Keys.gMapKey);

  // AutocompleteResponse? _autoCompleteRes;

  // AutocompleteResponse? get getAutoPlaces => _autoCompleteRes;

  // Future<void> getPlaces({required String input, String? country}) async {
  //   _autoCompleteRes =
  //       await _googlePlace.autocomplete.get(input, region: country);
  //   notifyListeners();
  // }

  // String? _placeId;
  // String? get getPlaceId => _placeId;

  // set setPlaceId(String? val) {
  //   _placeId = val;
  // }

  // show all users

  void setEmployeeTableData(
    AllEmployees? allEmployees,
  ) {
    if (allEmployees?.data != null) {
      employeeTableList.tableDataList = [];
      for (final e in allEmployees!.data!) {
        employeeTableList.tableDataList.add(
          TableDataList(
            id: e.id ?? '',
            imgList: [],
            itemList: [
              e.code ?? '',
              e.preferredName ?? '',
              e.jobTitle ?? '',
              e.phoneNumber ?? '',
              e.email ?? '',
            ],
            statusList: [],
          ),
        );
      }
    }
    notify;
  }

  void setCusTableData(
    AllCustomer? allCustomer,
  ) {
    if (allCustomer?.data != null) {
      customerTableList.tableDataList = [];
      for (final e in allCustomer!.data!) {
        customerTableList.tableDataList.add(
          TableDataList(
            id: e.id ?? '',
            imgList: [],
            itemList: [
              e.name ?? '',
              e.phoneNumber ?? '',
              e.email ?? '',
            ],
            statusList: [
              e.isMarketingPromotionEnabled ?? false
                  ? TableStatus.Yes
                  : TableStatus.No,
              e.isLoyaltyEnabled ?? false ? TableStatus.Yes : TableStatus.No,
            ],
          ),
        );
      }
    }
    notify;
  }

  String? selectedCatId = "";
  ProdByProdCatRes? serviceList;
  ProdByProdCatRes? subCatServList;
  AssignedServiceRes? assignedServiceList;

  Future<void> getAllServices() async {
    if (servicesTypesList.isEmpty) return;

    final id = selectedCatId ?? servicesTypesList.first.id;

    if (id == null) return;

    selectedCatId ??= id;
    loading = true;
    notify;
    serviceList = await Handler.getAllVarByCat(id: id);
    if (serviceList != null)
      subCatServList = ProdByProdCatRes.fromJson(serviceList!.toJson());
    loading = false;
    notify;
  }

  void onTapSubCategory(int index) {
    selectedSubCatIndex = index;
    if (index == 0) {
      subCatServList?.productVariations = serviceList?.productVariations;
      notify;
      return;
    }
    subCatServList?.productVariations = serviceList?.productVariations
        ?.where(
          (element) =>
              element.productCategoryId?.toLowerCase() ==
              serviceList?.subCategories?[index - 1].id?.toLowerCase(),
        )
        .toList();
    notify;
  }

  Future<void> addUpdate() async {
    loading = true;
    notify;

    await Handler.addUpAssignedService(req: assignedServiceList);

    loading = false;
    notify;
  }

  Future<void> getAssignServiceAddSec(
      {required String employeeId, required String employeeName}) async {
    loading = true;

    final res2 = await Handler.getAssignedServiceList(
        employeeId: employeeId, employeeName: employeeName);
    final res = await Handler.getAssignServiceAddSec();

    if (res2 != null) {
      assignedServiceList = AssignedServiceRes.fromJson(res2.toJson());
    }
    if (res != null) {
      servicesTypesList = [];
      servicesTypesList = res.parentProductCategories ?? [];
      selectedCatId = servicesTypesList.first.id;
      await getAllServices();
    }
    loading = false;
    notify;
  }

  Future<void> getAllEmployees({required int page}) async {
    empPage = page;
    allEmployees = await Handler.getAllEmployees(
      pageSize: empPageSize,
      page: page,
      searchKey: searchCltr.text,
    );

    if (allEmployees?.data != null) {
      setEmployeeTableData(allEmployees);
    }
    userLoad = false;
    notify;
  }

  // Future<void> getAllUsers({required int page}) async {
  //   pagiPage = page;
  //   allUsers = await Handler.getAllUsers(
  //     page: page,
  //     pageSize: userPageSize,
  //     searchKey: searchCltr.text,
  //   );
  //   if (allUsers?.data != null) {
  //     userTableList.tableDataList = [];
  //     for (final e in allUsers!.data!) {
  //       userTableList.tableDataList.add(TableDataList(id: e.id ?? '', imgList: [
  //         e.image,
  //       ], itemList: [
  //         e.fullName ?? '',
  //         e.userType ?? '',
  //         e.phoneNumber ?? '',
  //         e.email ?? '',
  //       ], statusList: []));
  //     }
  //   }
  //   userLoad = false;
  //   notify;
  // }

  Future<void> getAllCustomers({required int page}) async {
    cusPage = page;
    allCustomer = await Handler.getAllCus(
      page: page,
      pageSize: cusPageSize,
      keyword: searchCltr.text,
    );
    if (allCustomer?.data != null) {
      setCusTableData(allCustomer);
    }
    userLoad = false;
    notify;
  }

  Future<void> getCustomerInfo() async {
    cusInfo = null;
    if (cusId.isNotEmpty) {
      cusInfo = await Handler.getCusById(cusId: cusId);
      setCusData();
    }
    loading = false;
    notify;
  }

  setCusData() {
    if (customerAddSecRes?.customerType
            ?.any((e) => e.id == cusInfo?.customerTypeId) ??
        false) {
      customerTypeIndex = cusInfo?.customerTypeId != null
          ? customerAddSecRes!.customerType!
              .indexWhere((e) => e.id == cusInfo?.customerTypeId)
          : 0;
    }
    if (customerAddSecRes?.customerGroups
            ?.any((e) => e.id == cusInfo?.customerGroupId) ??
        false) {
      cusGroupIndex = cusInfo?.customerGroupId != null
          ? customerAddSecRes!.customerGroups!
              .indexWhere((e) => e.id == cusInfo?.customerGroupId)
          : 0;
    }
    if (customerAddSecRes?.countries?.any((e) =>
            e.id?.toLowerCase() ==
            cusInfo?.countryPhoneNumberPrefixId?.toLowerCase()) ??
        false) {
      phoneCodeIndex = cusInfo?.countryPhoneNumberPrefixId != null
          ? customerAddSecRes!.countries!.indexWhere((e) =>
              e.id?.toLowerCase() ==
              cusInfo?.countryPhoneNumberPrefixId?.toLowerCase())
          : 0;
    }

    if (customerAddSecRes?.countries?.any(
            (e) => e.id?.toLowerCase() == cusInfo?.countryId?.toLowerCase()) ??
        false) {
      countryIndex = customerAddSecRes!.countries!.indexWhere(
          (e) => e.id?.toLowerCase() == cusInfo?.countryId?.toLowerCase());
    }

    nameCltr.text = cusInfo?.name ?? '';
    phoneCltr.text = cusInfo?.phoneNumber ?? '';
    emailCltr.text = cusInfo?.email ?? '';
    postalCltr.text = cusInfo?.postalCode ?? '';
    enableLoyality = cusInfo?.isLoyaltyEnabled ?? false;
    isMarketingPromotion = cusInfo?.isMarketingPromotionEnabled ?? false;
    notify;
  }

  // employee info
  Future<bool> getEmpAddSec() async {
    _filePath = null;
    empAddSec = await Handler.getEmpAddSec();

    if (ScreenTimeOut.any((e) => e.duration == 0))
      intervalIndex = ScreenTimeOut.indexWhere((e) => e.duration == 0);

    if (empAddSec?.countryCityStates?.any((e) => e.isSelected ?? false) ??
        false) {
      countryIndex = empAddSec?.countryCityStates
          ?.indexWhere((e) => e.isSelected ?? false);
      phoneCodeIndex = empAddSec?.countryCityStates
          ?.indexWhere((e) => e.isSelected ?? false);
    }
    final _status = await getEmployeeInfo();
    loading = false;
    notify;

    return _status;
  }

  String empId = "";

  Future<bool> getEmployeeInfo() async {
    if (empId.isNotEmpty) {
      empInfo = await Handler.getEmployeeInfo(empId: empId);
      setEmpData();
    }
    loading = false;
    notify;
    return empInfo != null;
  }

  void setEmpData() {
    if (empInfo == null) return;

    empCodeCltr.text = empInfo!.code ?? '';
    nameCltr.text = empInfo!.fullName ?? '';
    preferNameCltr.text = empInfo!.preferredName ?? '';
    _filePath = empInfo?.imagePath;

    jobTitleCltr.text = empInfo!.jobTitle ?? '';
    if (empAddSec?.countryCityStates?.any(
            (a) => a.id?.toLowerCase() == empInfo?.countryId?.toLowerCase()) ??
        false) {
      countryIndex = empAddSec?.countryCityStates?.indexWhere(
          (a) => a.id?.toLowerCase() == empInfo?.countryId?.toLowerCase());

      if (empAddSec?.countryCityStates?[countryIndex!].states?.any(
              (b) => b.id?.toLowerCase() == empInfo?.stateId?.toLowerCase()) ??
          false) {
        stateIndex = empAddSec?.countryCityStates?[countryIndex!].states
            ?.indexWhere(
                (b) => b.id?.toLowerCase() == empInfo?.stateId?.toLowerCase());

        if (empAddSec
                ?.countryCityStates?[countryIndex!].states?[stateIndex!].cities
                ?.any((c) =>
                    c.id?.toLowerCase() == empInfo?.cityId?.toLowerCase()) ??
            false) {
          cityIndex = empAddSec
              ?.countryCityStates?[countryIndex!].states?[stateIndex!].cities
              ?.indexWhere(
                  (c) => c.id?.toLowerCase() == empInfo?.cityId?.toLowerCase());
        }
      }
    }
    postalCltr.text = empInfo?.postalCode ?? '';

    if (empAddSec?.genders?.any(
            (d) => d.id?.toLowerCase() == empInfo?.genderId?.toLowerCase()) ??
        false) {
      genderIndex = empAddSec?.genders?.indexWhere(
          (d) => d.id?.toLowerCase() == empInfo?.genderId?.toLowerCase());
    }

    if (empAddSec?.employmentTypes?.any((e) =>
            e.id?.toLowerCase() == empInfo?.employmentTypeId?.toLowerCase()) ??
        false) {
      userTypeIndex = empAddSec?.employmentTypes?.indexWhere((e) =>
          e.id?.toLowerCase() == empInfo?.employmentTypeId?.toLowerCase());
    }

    salaryCltr.text = empInfo!.annualsalary ?? '';
    hourlyRateCltr.text = empInfo!.hourlyRate ?? '';

    emailCltr.text = empInfo?.email ?? '';

    if (empAddSec?.countryCityStates?.any((f) =>
            f.id?.toLowerCase() ==
            empInfo?.countryPhoneNumberPrefixId?.toLowerCase()) ??
        false) {
      phoneCodeIndex = empAddSec?.countryCityStates?.indexWhere((f) =>
          f.id?.toLowerCase() ==
          empInfo?.countryPhoneNumberPrefixId?.toLowerCase());
    }

    phoneCltr.text = empInfo?.phoneNumber ?? '';

    if (empAddSec?.roles?.any(
            (g) => g.id?.toLowerCase() == empInfo?.roleId?.toLowerCase()) ??
        false) {
      userRoleIndex = empAddSec?.roles?.indexWhere(
          (g) => g.id?.toLowerCase() == empInfo?.roleId?.toLowerCase());
    }

    isActive = empInfo?.isActive ?? false;

    passCltr.text = empInfo?.password ?? '';
    confirmPassCltr.text = empInfo?.confirmPassword ?? '';

    pinCltr.text = empInfo?.loginPinCode ?? '';
    confirmPinCltr.text = empInfo?.confirmLoginPinCode ?? '';

    if (empAddSec?.posTabDefaultScreens?.any((e) =>
            e.name?.toLowerCase() ==
            empInfo?.posTabDefaultScreenName?.toLowerCase()) ??
        false) {
      defaultScreenIndex = empAddSec!.posTabDefaultScreens!.indexWhere((e) =>
          e.name?.toLowerCase() ==
          empInfo?.posTabDefaultScreenName?.toLowerCase());
    }

    if (ScreenTimeOut.any((e) =>
        e.duration == empInfo?.loginPinAutoLogOffInterval?.inDouble.floor())) {
      intervalIndex = ScreenTimeOut.indexWhere((e) =>
          e.duration == empInfo?.loginPinAutoLogOffInterval?.inDouble.floor());
    } else {
      final _interval = empInfo?.loginPinAutoLogOffInterval?.inDouble.floor();
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
            empInfo?.loginPinAutoLogOffInterval?.inDouble.floor());
      }
    }

    enablePinCode = empInfo?.enableLoginPinCodePopUpScreen ?? false;

    emergNameCltr.text = empInfo!.emergencyContactName ?? '';
    emergPhoneCltr.text = empInfo!.emergencyPhone ?? '';
    emergEmailCltr.text = empInfo!.emergencyEmail ?? '';

    pushNotificationEnable = empInfo?.isPushNotificationEnabled ?? false;
  }

  Future<bool> addUpEmployee() async {
    final _updateEmp = EmployeeInfo()
      ..id = empId
      ..userId = empInfo?.userId ?? ''
      ..code = empCodeCltr.text
      ..fullName = nameCltr.text
      ..preferredName = preferNameCltr.text
      ..jobTitle = jobTitleCltr.text
      ..postalCode = postalCltr.text
      ..annualsalary = salaryCltr.text
      ..hourlyRate = hourlyRateCltr.text
      ..email = emailCltr.text
      ..phoneNumber = phoneCltr.text
      ..isActive = isActive
      ..password = passCltr.text
      ..confirmPassword = confirmPassCltr.text
      ..loginPinCode = pinCltr.text
      ..confirmLoginPinCode = confirmPinCltr.text
      ..enableLoginPinCodePopUpScreen = enablePinCode
      ..emergencyContactName = emergNameCltr.text
      ..emergencyPhone = emergPhoneCltr.text
      ..emergencyEmail = emergEmailCltr.text
      ..isPushNotificationEnabled = pushNotificationEnable;

    if (countryIndex != null) {
      _updateEmp.countryId = empAddSec?.countryCityStates?[countryIndex!].id;

      if (stateIndex != null) {
        _updateEmp.stateId = empAddSec
            ?.countryCityStates?[countryIndex!].states?[stateIndex!].id;

        if (cityIndex != null) {
          _updateEmp.cityId = empAddSec?.countryCityStates?[countryIndex!]
              .states?[stateIndex!].cities?[cityIndex!].id;
        }
      }
    }

    if (genderIndex != null) {
      _updateEmp.genderId = empAddSec?.genders?[genderIndex!].id;
    }

    if (userTypeIndex != null) {
      _updateEmp.employmentTypeId =
          empAddSec?.employmentTypes?[userTypeIndex!].id;
    }

    if (phoneCodeIndex != null) {
      _updateEmp.countryPhoneNumberPrefixId =
          empAddSec?.countryCityStates?[phoneCodeIndex!].id;
    }

    if (userRoleIndex != null) {
      _updateEmp.roleId = empAddSec?.roles?[userRoleIndex!].id;
    }

    if (defaultScreenIndex != null) {
      _updateEmp.posTabDefaultScreenName =
          empAddSec?.posTabDefaultScreens?[defaultScreenIndex!].name;
    } else {
      _updateEmp.posTabDefaultScreenName = "";
    }

    if (intervalIndex != null) {
      _updateEmp.loginPinAutoLogOffInterval =
          ScreenTimeOut[intervalIndex!].duration.toString();
    }

    // if (getFilePath != null &&
    //     getFilePath!.isEmpty &&
    //     empInfo?.imagePath != null &&
    //     empInfo!.imagePath!.isNotEmpty) {
    //   _updateEmp.isImageDeleted = true;
    // }

    updateLoad = true;
    loading = true;
    notify;

    final _status = await Handler.addUpEmployee(
      emp: _updateEmp,
      filePath: _filePath,
    );
    updateLoad = false;
    loading = false;
    notify;

    return _status ?? false;
  }

  Future<String?> generatePass() async {
    loading = true;
    notify;
    final _pass = await Handler.generatePassword();
    passCltr.text = _pass ?? '';
    confirmPassCltr.text = _pass ?? '';
    loading = false;
    notify;

    return _pass;
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
            empInfo?.imagePath != null &&
            empInfo!.imagePath!.isNotEmpty);
    if (file != null) {
      setFilepath = file;
      notify;
    }
  }

  void clearAssignService() {
    servicesTypesList = [];
    assignedServiceList = null;
    selectedCatId = "";
    serviceList = null;
    subCatServList = null;
    selectedSubCatIndex = 0;
  }
}

class ToFromData {
  final String id;
  final TextEditingController fromCltr;
  final TextEditingController toCltr;
  final TextEditingController dataCltr;

  ToFromData({
    this.id = "",
    required this.fromCltr,
    required this.toCltr,
    required this.dataCltr,
  });
}
