import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pos_account/config/notification/notification_api.dart';
import 'package:pos_account/config/utils/internet_utils.dart';
import 'package:pos_account/services/signal_core/utils/stk_event_utils.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/menu/payment_pro.dart';
import 'package:pos_account/providers/menu/place_order_pro.dart';
import 'package:pos_account/providers/menu/pos_retail_pro.dart';
import 'package:pos_account/providers/screen_saver/screen_saver_pro.dart';
import 'package:pos_account/screens/custom_drawer/cus_end_drawer.dart';
import 'package:pos_account/screens/initialize/screen_saver/pin_lock/pin_lock.dart';
import 'package:pos_account/services/payment/eft_payment.dart';
import 'package:pos_account/services/phone_service/phone_service.dart';
import 'package:pos_account/services/signal_core/signalr_core.dart';
import 'package:pos_account/widgets/dialog/confirm_dialog.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../custom_drawer/custom_drawer.dart';
import 'bottom_nav_2.dart';
import 'com/sub_home_page.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home-page';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final _scafKey = GlobalKey<ScaffoldState>();

  final _homeProfilePageCltr = PageController();

  final _cvp = GlobalCVP;

  void _pageCltrSetup({
    int index = 0,
    bool ignoreReturn = false,
  }) {
    if (!ignoreReturn &&
        _cvp.PageCltr != null &&
        _cvp.PageCltr!.hasClients &&
        _cvp.currentPage == index &&
        index != 0 &&
        _cvp.tabs.length == _cvp.PageCltr!.positions.length) return;

    final _index = _cvp.tabs.length > index ? index : 0;

    _cvp.PageCltr = PageController(initialPage: _index);
    _cvp.setCurrentPage(_index);
  }

  PlaceOrderPro? _placeOrderPro;
  PosRetailPro? _retailPro;

  bool _productLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _placeOrderPro = Provider.of<PlaceOrderPro>(context, listen: false);
    _retailPro = Provider.of<PosRetailPro>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      GlobalCVP.tabCltrFunction = _pageCltrSetup;
      _pageCltrSetup();
      if (GlobalCVP.phoneCallEnable) {
        PhoneService.init(scafKey: _scafKey, pageCltr: _homeProfilePageCltr);
      }
      _getData();
      NotificationApi.askPermission();
      WakelockPlus.enable();
    });
  }

  Future<void> _initialize() async {
    _cvp.init();
    await _cvp
        .getAllUserPermission(isFromLocal: true)
        .then((_) => _pageCltrSetup(index: _cvp.PageCltr?.initialPage ?? 0));

    InternetUtils.init(listen: (_status, isInitApp) {
      if (_status != InternetStatus.Disconnect) {
        if (!isInitApp) {
          _startSocket();
        }
      }
    });
  }

  _getData() async {
    final _screenSavPro = Provider.of<ScreenSaverPro>(context, listen: false);

    _initialize();
    _placeOrderPro?.initStore = await _cvp.getStoreData();
    // To prevent duplication initialization of focus node
    _placeOrderPro?.desFocus = FocusNode();
    _cvp.jumpToTab();

    _pageCltrSetup(index: _cvp.getHPTIndex, ignoreReturn: true);

    _retailPro?.placeOrderPro = _placeOrderPro;
    await _cvp.getDeviceDetailById(isServerCall: false);

    await _cvp.getAllAddSection();
    signalRConnect(path: '_getData');

    await _getPosData(_retailPro!);
    if (_cvp.isRetailStore) {
      await _retailPro
          ?.getOrderAddSection(placeOr: _placeOrderPro!)
          .then((value) async {
        _retailPro!.getAllPromotions();
      });
      _retailPro!.notify;
    } else {
      await _placeOrderPro!
          .getOrderAddSection()
          .then((value) => _placeOrderPro!.getAllPromotions());
      _placeOrderPro?.setOrderNotes();
    }
    _placeOrderPro?.getCusAddSec();

    await _cvp.setupStoreInfo();

    await _placeOrderPro?.onChangeStore(initLoad: true);

    await _cvp.getAllUserPermission(isFromLocal: false);
    _pageCltrSetup(index: _cvp.getHPTIndex, ignoreReturn: true);
    _productLoading = false;

    _screenSavPro.setInterval(_cvp.userStoresRes?.screenSaverLogoffInterval);
    if (_cvp.userStoresRes?.enablePinCodePopUpScreen ?? false) {
      Future.delayed(Duration(milliseconds: 50), () {
        PinLockScreen.show();
      });
    }
    _cvp.jumpToTab();
    _cvp.notify;

    StkEventUtils.listenOnlineOrder();

    if (mounted) {
      NotificationApi.onStartApp();

      final _payPro = Provider.of<PaymentPro>(context, listen: false);
      _payPro.getData();

      if (GlobalCVP.eftPosEnable && GlobalCVP.recoverEftPOSEnable) {
        _checkEftPendingPayment();
      }
    }
  }

  Future<void> _getPosData(PosRetailPro? _retailPro) async {
    if (_cvp.isRetailStore) {
      await _retailPro?.getAllRetailProducts();
    } else {
      await _placeOrderPro!.getAllProducts();
    }
  }

  Future<void> _checkEftPendingPayment() async {
    EFTPayment.scaffKey = _scafKey;
    // print('1');

    if (await InternetUtils.getInterNetStatus) {
      Future.delayed(Duration(milliseconds: 1000), () {
        if (mounted) {
          EFTPayment.checkEftPendingPayment(context);
        }
      });
    }

    EFTPayment.checkEftOnInternetConnect();
  }

  Future<bool> get _closeApp async {
    bool isExit = false;

    await showDialog(
        context: context,
        builder: (builder) {
          return ConfirmDialog(
            title: LN.exit,
            subTitle: LN.sureToExit,
            onDelete: () async {
              isExit = true;
              return null;
            },
            actionText: LN.yes,
            cancelText: LN.no,
          );
        });

    return isExit;
  }

  void signalRConnect({String path = ""}) {
    SignalRCore.connectToSignalR(load: () => GlobalCVP.notify).then((val) {
      if (val ?? false) {
        SignalRCore.listen(load: () => GlobalCVP.notify);
      }
    });
  }

  void _startSocket() {
    SignalRCore.doReconnecting = true;
    // _kitPro.getAllOrderIds();
    kPrint(
        '------===_startSocket============= ${SignalRCore.hubConnection?.state}');

    // check once only
    if (SignalRCore.hubConnection?.state == HubConnectionState.disconnected ||
        SignalRCore.hubConnection?.state == HubConnectionState.disconnecting) {
      signalRConnect(path: "didChangeAppLifecycleState");
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // log('--------------AppLifecycleState $state-----------');
    if (state == AppLifecycleState.resumed) {
      _startSocket();
    } else {
      SignalRCore.doReconnecting = false;
    }
  }

  @override
  void dispose() {
    _homeProfilePageCltr.dispose();
    if (GlobalCVP.phoneCallEnable) PhoneService.stop();

    _placeOrderPro?.posCatRes = null;
    _productLoading = true;
    GlobalCVP.permissionLoad = true;
    WakelockPlus.disable();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    _cvp.safeAreaPadding = MediaQuery.of(context).padding;
    // print("${size.width} ${size.height}");
    final placeOrderPro = Provider.of<PlaceOrderPro>(context);

    final _cusEndDrawer = CusEndDrawer(context,
            currentIndex: _cvp.currentPage,
            scafKey: _scafKey,
            cvp: _cvp,
            placeOrderPro: placeOrderPro)
        .endDrawer;

    return WillPopScope(
      onWillPop: () async {
        if (GlobalCVP.authorize == Authorize.No)
          return false;
        else {
          return await _closeApp;
        }
      },
      child: Stack(
        children: [
          Scaffold(
            key: _scafKey,
            backgroundColor: kBackgroundColor,
            drawer: size.isProt
                ? SizedBox(
                    width: size.getW(140),
                    child: CustomDrawer(
                      homeProfilePageCltr: _homeProfilePageCltr,
                    ))
                : null,
            endDrawer: _cusEndDrawer,
            endDrawerEnableOpenDragGesture: false,
            bottomNavigationBar: !_cvp.permissionLoad &&
                    _cvp.getMainPage != MainPage.BookingPage &&
                    _cvp.getMainPage != MainPage.SubscriptionPage
                ? BottomNavSection2(
                    placeOrderPro: placeOrderPro,
                    pageCltr: _homeProfilePageCltr,
                  )
                : null,
            body: Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: SafeArea(
                child: _cvp.permissionLoad || _productLoading
                    ? Center(child: _splashLoading(size))
                    : AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        transitionBuilder: (child, animation) => FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                        child: SubHome.buildMainPageContent(
                            _cvp, _scafKey, _homeProfilePageCltr)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _splashLoading(Ssize size) {
    return Hero(
      tag: '98432-loading',
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            "assets/png/splash_logo.png",
            width: size.getW(460),
            height: size.getH(300),
          ),
          Positioned(
            top: 0,
            child: SizedBox(
                width: size.getW(100),
                height: size.getW(100),
                child: Loading()),
          ),
        ],
      ),
    );
  }
}
