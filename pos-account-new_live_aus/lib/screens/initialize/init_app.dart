import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pos_account/config/notification/notification_api.dart';
import 'package:pos_account/config/theme.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/constant/strings.dart';
import 'package:pos_account/env.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/screen_saver/screen_saver_pro.dart';
import 'package:pos_account/providers/z_multi_pro.dart';
import 'package:pos_account/screens/app_routes.dart';
import 'package:provider/provider.dart';

class InitApp extends StatelessWidget {
  const InitApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    return MultiPro(child: const MyApp());
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  void initState() {
    GlobalCVP = Provider.of<CusValuePro>(context, listen: false);
    _ssPro = Provider.of<ScreenSaverPro>(context, listen: false);
    _getActivity('init');
    NotificationApi.onFirebaseMessage();
    NotificationApi.setUp(
        // onSelect: (String? payload) =>
        //     NotificationApi.onSelectNotification(payload, context),
        // onDidReceive: (id, title, body, payload) =>
        //     NotificationApi.onDidReceiveLocalNotification(
        //         id, title, body, payload, context),
        );
    super.initState();
  }

  void _getActivity(dynamic data) {
    if (_ssPro != null && mounted) {
      _ssPro!.screenSaverCheck(data, context: context);
    }
  }

  ScreenSaverPro? _ssPro;

  @override
  Widget build(BuildContext context) {
    GlobalCVP = Provider.of<CusValuePro>(context);
    LnPro = Provider.of<LNProvider>(context);
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        _getActivity('on_tap');
      },
      onPanDown: _getActivity,
      onScaleStart: _getActivity,
      onLongPressStart: (details) {
        _ssPro?.isHoldingScreen = true;
        _getActivity('holding screen start');
      },
      onLongPressEnd: (details) {
        _ssPro?.isHoldingScreen = false;
        _getActivity('holding screen end');
      },
      child: OKToast(
        position: ToastPosition.bottom,
        dismissOtherOnShow: true,
        textPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        handleTouch: true,
        radius: 5,
        textStyle: TextStyle(
          color: Colors.white,
          fontFamily: kFontFRegular,
          fontWeight: FontWeight.w500,
          fontSize: 14,
          decoration: TextDecoration.none,
        ),
        duration: Duration(seconds: 3),
        child: AppEnvironment.environment == Environment.UAT
            ? Banner(
                location: BannerLocation.topEnd,
                message: 'UAT',
                child: _materialApp,
              )
            : _materialApp,
      ),
    );
  }

  MaterialApp get _materialApp {
    return MaterialApp(
      navigatorKey: NAV_KEY,
      title: Strings.APP_NAME,
      themeMode: ThemeMode.light,
      darkTheme: MyThemes.darkTheme,
      theme: MyThemes.lightTheme,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: AppRoute.onGenerateRoute,
      initialRoute: '/splash-screen',
    );
  }
}
