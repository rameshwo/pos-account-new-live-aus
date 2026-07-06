import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pos_account/providers/auth/auth_pro.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/screens/auth_screen/configure_device/configure_store.dart';
import 'package:pos_account/screens/auth_screen/login_screen.dart';
import 'package:pos_account/screens/home_screen/home_page.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'screen_saver/pin_lock/pin_lock.dart';
import 'screen_saver/screen_saver_screen.dart';

class ScreenCltr extends StatefulWidget {
  static const String routeName = '/screen-cltr';
  const ScreenCltr({super.key});

  @override
  State<ScreenCltr> createState() => _ScreenCltrState();

  static AppLifecycleState prevState = AppLifecycleState.inactive;
}

class _ScreenCltrState extends State<ScreenCltr> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _fullScreen();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // print('---------${ScreenCltr.prevState} ------------- $state');

    if (ScreenCltr.prevState == AppLifecycleState.paused &&
        state == AppLifecycleState.resumed) {
      // App is in the foreground
      if (GlobalCVP.userStoresRes?.enablePinCodePopUpScreen ?? false) {
        Future.delayed(Duration(milliseconds: 500), () {
          PinLockScreen.show();
        });
      }
    }

    ScreenCltr.prevState = state;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GlobalCVP = Provider.of<CusValuePro>(context);
    AUTH_PRO = Provider.of<AuthProvider>(context);
    return Stack(
      children: [
        Builder(builder: (context) {
          switch (AUTH_PRO.getAuth) {
            case AuthStatus.INITIALIZE:
              return ScafLoading();
            case AuthStatus.AUTHENTICATE:
              return HomePage();
            //TODO: remove it later dual screen
            // return TempPreview(child: HomePage());
            // case AuthStatus.AUTHENTICATING:
            //   return LoginScreen();
            case AuthStatus.VERIFICATION:
              return ConfigureStoreScreen();
            default:
              return LoginScreen();
          }
        }),
        // if (GlobalCVP.eftPosEnable && GlobalCVP.recoverEftPOSEnable)
        //   AnimatedSwitcher(
        //     duration: Duration(milliseconds: 400),
        //     child: AUTH_PRO.getAuth == AuthStatus.AUTHENTICATE &&
        //             _eftPro.runEftPay_Mx51
        //         ? BackgroundEftPos()
        //         : SizedBox.shrink(),
        //   ),
        // if (_authPro.getAuthStatus == AuthStatus.AUTHENTICATE &&
        //     (_eftPro.runEftPay))
        //   BackgroundWeb(),
        if (AUTH_PRO.getAuth == AuthStatus.AUTHENTICATE) ScreenSaverScreen(),
      ],
    );
  }
}

class ScafLoading extends StatelessWidget {
  const ScafLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Loading(),
    );
  }
}

Future<void> _fullScreen() async {
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
}
