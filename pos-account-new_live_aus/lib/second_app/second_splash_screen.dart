import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/second_app/second_screen/second_screen.dart';

class SecondSplashScreen extends StatefulWidget {
  static const String routeName = 'presentation';
  const SecondSplashScreen({
    super.key,
  });

  @override
  State<SecondSplashScreen> createState() => _SecondSplashScreenState();
}

class _SecondSplashScreenState extends State<SecondSplashScreen>
    with TickerProviderStateMixin {
  late AnimationController animation;
  late Animation<double> _fadeInFadeOut;
  @override
  void initState() {
    setData();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushNamedAndRemoveUntil(
          context, SecondScreen.routeName, (route) => false);
    });
    super.initState();
  }

  setData() async {
    animation = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _fadeInFadeOut = Tween<double>(begin: 0, end: 1).animate(animation);
    animation.forward();
  }

  @override
  void dispose() {
    animation.dispose();
    _fadeInFadeOut.isDismissed;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return Scaffold(
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
              child: FadeTransition(
                opacity: _fadeInFadeOut,
                child: Image.asset(
                  "assets/png/splash_logo.png",
                  width: size.getW(460),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
