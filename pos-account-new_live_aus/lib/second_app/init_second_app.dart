import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pos_account/config/theme.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/constant/strings.dart';
import 'package:pos_account/screens/app_routes.dart';
import 'package:pos_account/second_app/second_splash_screen.dart';

final GlobalKey<NavigatorState> SECOND_NAV_KEY = GlobalKey<NavigatorState>();

class InitSecondApp extends StatelessWidget {
  const InitSecondApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return OKToast(
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
      child: MaterialApp(
        navigatorKey: SECOND_NAV_KEY,
        title: Strings.APP_NAME,
        themeMode: ThemeMode.light,
        darkTheme: MyThemes.darkTheme,
        theme: MyThemes.lightTheme,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: AppRoute.onGenerateRoute,
        initialRoute: SecondSplashScreen.routeName,
      ),
    );
  }
}
