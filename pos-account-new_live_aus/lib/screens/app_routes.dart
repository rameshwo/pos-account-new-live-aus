import 'package:flutter/material.dart';
import 'package:pos_account/screens/initialize/screen_cltr.dart';
import 'package:pos_account/screens/initialize/splash_screen.dart';
import 'package:pos_account/second_app/second_screen/second_screen.dart';
import 'package:pos_account/second_app/second_splash_screen.dart';

class AppRoute {
  static Route onGenerateRoute(RouteSettings settings) {
    // print('The Route is : ${settings.name}');
    return PageRouteBuilder(
      pageBuilder: (c, a1, a2) {
        switch (settings.name) {
          case SplashScreen.routeName:
            return SplashScreen(
              message: settings.arguments is String
                  ? (settings.arguments as String)
                  : null,
            );
          case ScreenCltr.routeName:
            return ScreenCltr();

          /// second app screen (dual screen)
          case SecondSplashScreen.routeName:
            return SecondSplashScreen();
          case SecondScreen.routeName:
            return SecondScreen();

          default:
            return _errorRoute();
        }
      },
      transitionsBuilder: (c, anim, a2, child) =>
          FadeTransition(opacity: anim, child: child),
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  static Widget _errorRoute() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Error"),
      ),
    );
  }
}
