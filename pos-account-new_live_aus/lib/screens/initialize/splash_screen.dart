import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_http_logger/flutter_http_logger.dart';
import 'package:lottie/lottie.dart';
import 'package:pos_account/config/app_update.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/dual_display/dual_display_config.dart';
import 'package:pos_account/env.dart';
import 'package:pos_account/services/language/translate.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = '/splash-screen';
  final String? message;
  const SplashScreen({
    super.key,
    this.message,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController animation;
  late Animation<double> _fadeInFadeOut;
  @override
  void initState() {
    setData();
    DualDisplayConfig.init();
    Future.delayed(
        Duration(
            milliseconds: (widget.message?.isNotEmpty ?? false) ? 500 : 2000),
        () {
      if (mounted)
        Navigator.pushNamedAndRemoveUntil(
            context, '/screen-cltr', (route) => false);
      _getData();
    });
    super.initState();
  }

  bool _isSandbox = true;

  void _getData() {
    if (widget.message?.isNotEmpty ?? false) return;

    // TODO: Do not comment for publishing in LIVE
    _isSandbox = AppEnviro.enviroment != Enviroment.PROD || kDebugMode;
    HttpLog.startServer(context, isSandbox: _isSandbox);
    AppUpdate.checkUpdate(isSandBox: _isSandbox);
  }

  setData() async {
    animation = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _fadeInFadeOut = Tween<double>(begin: 0, end: 1).animate(animation);
    animation.forward();
    await Translate.getAppLang();

    // if (mounted) {
    //   final _authPro = Provider.of<AuthProvider>(context, listen: false);

    //   if (_authPro.getAuth == AuthStatus.AUTHENTICATE) {
    //     final _cvp = Provider.of<CusValuePro>(context, listen: false);
    //     _cvp.init();
    //     await _cvp.getAllUserPermission(isFromLocal: false);

    //   if (_authPro.getAuthStatus == AuthStatus.AUTHENTICATE) {
    //     final _cvp = Provider.of<CusValuePro>(context, listen: false);
    //     _cvp.init();
    //     await _cvp.getAllUserPermission(isFromLocal: false);
    //   }
    // }
  }

  @override
  void dispose() {
    animation.dispose();
    _fadeInFadeOut.isDismissed;
    // if (widget.message == null || widget.message!.isEmpty) {
    //   HttpLog.endServer();
    // }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 0,
                child: SizedBox(
                  width: size.getW(200),
                  child: Lottie.asset(
                    "assets/json/98432-loading.json",
                  ),
                ),
              ),
              SizedBox(
                height: size.getH(540),
                child: (widget.message?.isNotEmpty ?? false)
                    ? Hero(
                        tag: '98432-loading',
                        child: Image.asset(
                          "assets/png/splash_logo.png",
                          width: size.getW(460),
                        ),
                      )
                    : FadeTransition(
                        opacity: _fadeInFadeOut,
                        child: Hero(
                          tag: '98432-loading',
                          child: Image.asset(
                            "assets/png/splash_logo.png",
                            width: size.getW(460),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
