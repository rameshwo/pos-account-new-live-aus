import 'package:flutter/material.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/auth/store_detail_res.dart';
import 'package:pos_account/model/auth/user_stores_res.dart';
import 'package:pos_account/model/common/view_keys.dart';
import 'package:pos_account/model/home/menu/place_order/place_order_res.dart';
import 'package:pos_account/repository/handler.dart';
import 'package:pos_account/services/database/database/db_local_data.dart';
import 'package:pos_account/services/database/shared_pref.dart';
import '../model/home/menu/payment/make_pay_res.dart';
import '../model/home/menu/place_order/pos_res/store_information.dart';

late CusValuePro GlobalCVP;

class CusValuePro extends ChangeNotifier {
  PageController? PageCltr;
  int _currentPage = 0;

  int _endDrawerValue = 0;
  int _hptIndex = 0; //home page tab index

  int get endDrawerValue => _endDrawerValue;
  int get currentPage => _currentPage;

  setCurrentPage(int val) {
    _currentPage = val;
  }

  int get getHPTIndex => _hptIndex;

  bool showReview = false;
  ReviewQuestionUserViewModel? reviewQuestionUserViewModel;

  void init() {
    _endDrawerValue = 0;
    _hptIndex = 0;
    _orderPath = PathOfOrder.MENUPATH;
    _mainPage = MainPage.HomePage;
    isForBooking = false;
    pathOfSubsBills = PathOfSubsBills.OnInit;
    authorize = Authorize.Yes;
    isSessionDialogOpen = false;
  }

  set setEndDValue(int val) {
    _endDrawerValue = val;
    notify;
  }

  set setHPTIndex(int val) {
    if (tabs.length > val)
      _hptIndex = val;
    else
      _hptIndex = 0;
    notify;
  }

  PathOfOrder _orderPath = PathOfOrder.MENUPATH;

  PathOfOrder get getOrPath => _orderPath;

  set setOrPath(PathOfOrder val) {
    _orderPath = val;
    notify;
  }

  MainPage _mainPage = MainPage.HomePage;

  MainPage get getMainPage => _mainPage;
  bool jumpToTabOnSetPage = true;

  set setMainPage(MainPage val) {
    // print('------------ from setmain page : ${val.name}');
    if (getMainPage == val) return;

    _mainPage = val;
    notify;
    if (jumpToTabOnSetPage && _mainPage == MainPage.HomePage) {
      jumpToTab();
    }
    jumpToTabOnSetPage = true;
  }

  bool isForBooking = false;
  BusinessType _businessType = BusinessType.Hospitality;

  BusinessType get businessType => _businessType;

  bool get isServiceStore => _businessType == BusinessType.Service;
  bool get isRetailStore => _businessType == BusinessType.Retail;
  bool get isHospitality => _businessType == BusinessType.Hospitality;

  set setBusinessType(String? val) {
    if (BusinessType.values
        .any((e) => e.name.toLowerCase() == val?.toLowerCase()))
      _businessType = BusinessType.values
          .firstWhere((e) => e.name.toLowerCase() == val?.toLowerCase());
    notify;
  }

  Future<void> setupStoreInfo() async {
    setMainPage = MainPage.HomePage;
  }

  Future<void> getStoreListServer() async {
    storeList.clear();
    final _storeList = await Handler.getStoreList();
    if (_storeList?.userStores != null)
      storeList.addAll(_storeList!.userStores!);
    DbLocalData.updateAllStores(data: _storeList);
  }

  Future<void> getStoreDataServer() async {
    final _storeData = await Handler.getStoreDetail();
    if (_storeData != null) currentStore = _storeData;
    DbLocalData.updateStoreData(data: _storeData);
  }

  PathOfSubsBills pathOfSubsBills = PathOfSubsBills.OnInit;

  StoreDetailRes? currentStore;
  final storeList = <UserStore>[];
  UserStoresRes? userStoresRes;

  Future<StoreDetailRes?> getStoreData() async {
    storeList.clear();
    currentStore = await DbLocalData.getStoreData();

    if (currentStore == null) {
      await getStoreDataServer();
    }

    setBusinessType = currentStore?.businessCategory;

    final _storeListDb = await DbLocalData.getAllStores();

    if (_storeListDb?.userStores != null) {
      storeList.addAll(_storeListDb!.userStores!);
    } else {
      getStoreListServer();
    }
    notify;
    return currentStore;
  }

  // DeviceDetailRes? deviceDetailRes;

  Future<void> getDeviceDetailById({bool isServerCall = true}) async {
    if (isServerCall) {
      userStoresRes = await Handler.getStoreList();
      DbLocalData.updateAllStores(data: userStoresRes);
    } else {
      final _dbData = await DbLocalData.getAllStores();
      if (_dbData != null) {
        userStoresRes = _dbData;
      } else {
        await getDeviceDetailById(isServerCall: true);
      }
    }
    // kPrint("userStoresRes deviceID : ${userStoresRes?.id}");
  }

  void get notify => notifyListeners();

  // Authorization
  Authorize authorize = Authorize.Yes;

  bool isSessionDialogOpen = false;

  // user permission data
  ViewKeys viewWidget = ViewKeys();

  bool permissionLoad = true;

  Future<void> getAllUserPermission({isFromLocal = false}) async {
    if (isFromLocal) {
      viewWidget = await DbLocalData.getButtonsPermisson();
    } else {
      final widgets = await Handler.getAllUserPermission();
      if (widgets != null) {
        viewWidget = widgets;
        DbLocalData.updateButtonPermission(data: viewWidget);
      }
      // getUserInfo();
    }
    permissionLoad = false;
    notify;
  }

  List<CustomTabs> get tabs {
    return [
      // if (viewWidget.viewDashBoardModule)
      //   CustomTabs(
      //     title: LN.dashboard,
      //     icon: const Icon(
      //       Icons.dashboard_rounded,
      //       size: 30,
      //     ),
      //   ),
      if ((viewWidget.viewPosModule))
        CustomTabs(
          title: LN.pos,
          icon: const Icon(
            Icons.point_of_sale_rounded,
            size: 30,
            color: Colors.grey,
          ),
        ),
      if (viewWidget.viewPosModule)
        CustomTabs(
          title: "Keypad",
          icon: const Icon(
            Icons.keyboard_rounded,
            size: 30,
            color: Colors.grey,
          ),
        ),
      if (viewWidget.viewOrdersButton)
        CustomTabs(
          title: isServiceStore ? LN.services : LN.orders,
          icon: const Icon(
            Icons.receipt_long_rounded,
            size: 30,
            color: Colors.grey,
          ),
        ),

      // if (viewWidget.viewProductModule && !isServiceStore) LN.productsTab,
      // if (isServiceStore) LN.services,
      // if (viewWidget.viewSyncModule) LN.sync,
      // if (viewWidget.viewEodModule) LN.eod,
      // if (viewWidget.viewAccountingIntegrationModule) LN.integration,
      if (!isRetailStore &&
          !isServiceStore &&
          viewWidget.viewTableBookingModule)
        CustomTabs(
          title: isServiceStore ? "Appointments" : "Booking",
          icon: const Icon(
            Icons.calendar_today_outlined,
            size: 30,
            color: Colors.grey,
          ),
        ),
      // if (isHospitality)
      //   CustomTabs(
      //     title: "Kitchen Display",
      //     icon: const Icon(
      //       Icons.kitchen,
      //       size: 30,
      //       color: Colors.grey,
      //       // color: Colors.white,
      //     ),
      //   ),
      if (viewWidget.viewTableBookingModule &&
          !isRetailStore &&
          !isServiceStore)
        CustomTabs(
          title: LN.floorPlan,
          icon: const Icon(
            Icons.table_chart_rounded,
            size: 30,
            color: Colors.grey,
            // color: Colors.white,
          ),
        ),
      CustomTabs(
        title: "Manage",
        icon: const Icon(
          Icons.manage_accounts_rounded,
          size: 30,
          color: Colors.grey,
        ),
      ),
      // if (viewWidget.viewSettingsModule) LN.settings,
      // if (viewWidget.viewPayBillsModule) LN.shortTCashFlow,
    ];
  }

  Future<void> goToPosTab({String? tabName}) async {
    tabName ??= LN.pos;
    if (tabs.isNotEmpty &&
        tabs[currentPage].title != tabName &&
        tabs.any((tab) => tab.title == tabName)) {
      final _index = tabs.indexWhere((tab) => tab.title == tabName);
      if (PageCltr != null && PageCltr!.hasClients) {
        await PageCltr!.animateToPage(
          _index,
          duration: Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
      _currentPage = _index;
    }
  }

  bool get DontShowLeftSide => getMainPage == MainPage.PunchInOutPage;

  ///* New Features
  /// EFTPOS Enable/Disable
  bool get eftPosEnable => _storeInfo?.enablePayWithPairing ?? false;
  bool recoverEftPOSEnable = true;
  bool phoneCallEnable = true;

  bool isInitApiCalled = false;

  StoreInformation? _storeInfo;
  StoreInformation? get storeInfo => _storeInfo;
  set setStoreInfo(StoreInformation? _data) {
    _storeInfo = _data;
    SharedPrefs.setCurSym = _data?.currencySymbol ?? '';
    SharedPrefs.setDateFormat(_data?.dateFormat ?? '');
  }

  // Dual Screen Stuff
  // bool isDualMainScreen = false;

  Function({int index, bool ignoreReturn})? tabCltrFunction;

  PathOfPOS pathOfPOS = PathOfPOS.Init;

  Future<void> jumpToTab() async {
    int _index = 0;
    String _tabName = LN.pos;
    final _getTab = userStoresRes?.posTabDefaultScreenName ?? '';

    if (_getTab.isNotEmpty) {
      if (_getTab.toLowerCase().contains('floor') &&
          tabs.any((tab) => tab.title == LN.floorPlan)) {
        _index = tabs.indexWhere((tab) => tab.title == LN.floorPlan);
        _tabName = LN.floorPlan;
      } else if (_getTab.toLowerCase().contains('pos') &&
          tabs.any((tab) => tab.title == LN.pos)) {
        _index = tabs.indexWhere((tab) => tab.title == LN.pos);
        _tabName = LN.pos;
      }
    }

    // log("$_index ${tabs.map((e) => e.title).toList()} $_getTab");

    if (_index != 0 && _getTab.isNotEmpty) {
      tabCltrFunction!(index: _index);
      if (currentPage == 0 || tabs[currentPage].title != _tabName) {
        await goToPosTab(tabName: _tabName);
      }
    }
  }

  // stock exceed boolean
  /// [true]: Out-of-stock restriction is enabled, [false]: Out-of-stock restriction is disabled
  bool stockExceedRestriction = true;

  EdgeInsets safeAreaPadding = EdgeInsets.zero;

  // all Add Section

  Map<String, dynamic> get allAddSection => _allAddSection;

  Map<String, dynamic> _allAddSection = {};

  Future<void> getAllAddSection({bool isServerCall = false}) async {
    if (isServerCall) {
      await _getAllAddSectionFromServer();
      return;
    }

    final _dbData = await DbLocalData.getAllAddSection();
    if (_dbData != null) {
      _allAddSection = _dbData;
      setSyncData();
      _getAllAddSectionFromServer();
    } else {
      await _getAllAddSectionFromServer();
    }
  }

  Future<void> _getAllAddSectionFromServer() async {
    final _data =
        await Handler.posAddSection(isRetail: GlobalCVP.isRetailStore);
    if (_data != null) {
      _allAddSection = _data;
      setSyncData();
      await DbLocalData.updateAllAddSection(data: _data);
      final _storeInfoServer = await Handler.getStoreChargeInfo();
      await updateStoreInfo(data: _storeInfoServer);
    }
  }

  Future<void> updateAddSection({Map<String, dynamic>? data}) async {
    if (data == null) return;
    // _allAddSection = Map<String, dynamic>.from(_allAddSection);
    try {
      _allAddSection.addAll(data);
    } catch (e) {
      kPrint("updateAddSection Error : $e");
    }
    // log(json.encode(_allAddSection));
    await DbLocalData.updateAllAddSection(data: _allAddSection);
  }

  Future<void> updateStoreInfo({Map<String, dynamic>? data}) async {
    if (data == null) return;
    // _allAddSection = Map<String, dynamic>.from(_allAddSection);
    try {
      if (_allAddSection['storeInformation'] is Map<String, dynamic>) {
        (_allAddSection['storeInformation'] as Map<String, dynamic>)
            .addAll(data);
      }
    } catch (e) {
      kPrint("updateAddSection Error : $e");
    }
    // log(json.encode(_allAddSection));
    await DbLocalData.updateAllAddSection(data: _allAddSection);
  }

  List<PosThermalPrintTypeSetupResponseModel>?
      posThermalPrintTypeSetupResponseModels;

  void setSyncData() {
    posThermalPrintTypeSetupResponseModels = allAddSection["printingSetUps"] ==
            null
        ? []
        : List<PosThermalPrintTypeSetupResponseModel>.from(
            allAddSection["printingSetUps"]!
                .map((x) => PosThermalPrintTypeSetupResponseModel.fromJson(x)));
  }
}

enum PathOfOrder { MENUPATH, ORDERPATH, FLOORPATH }

enum MainPage {
  HomePage,
  OrderPage,
  BookingPage,
  SubscriptionPage,
  // ActivatePosPage,
  ProfilePage,
  SubscriptionPlanPage,
  NewOrgPage,
  GiftCardPage,
  NotificationPage,
  RecentCallPage,
  // KitchenPage,
  DeliveryPage,
  PunchInOutPage,
  ManagePage,
  SettingsPage,
  ProductPage,
  ServicePage,
  IntegrationPage,
  Report,
  EODPage,
  SyncPage,
}

enum Authorize { Yes, No }

enum PathOfSubsBills { OnInit, InApp }

enum PathOfPOS { Init, FloorPlan }

enum BusinessType { Hospitality, Retail, Service }

class CustomTabs {
  final String? title;
  final Icon? icon;

  const CustomTabs({this.title, this.icon});
}
