import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/providers/screen_saver/screen_saver_pro.dart';
import 'package:provider/provider.dart';
import 'com/image_slide_show.dart';
import 'com/random_text_animation.dart';
import 'com/screen_animator.dart';

class ScreenSaverScreen extends StatefulWidget {
  final bool isSecondScreen;
  const ScreenSaverScreen({
    super.key,
    this.isSecondScreen = false,
  });

  @override
  State<ScreenSaverScreen> createState() => _ScreenSaverScreenState();
}

class _ScreenSaverScreenState extends State<ScreenSaverScreen> {
  final _index = Random().nextInt(2);
  static const String _imagePath = "assets/png/posapt.png";

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final screenPro = Provider.of<ScreenSaverPro>(context);
    if (widget.isSecondScreen || screenPro.isScreenSaverOn)
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: screenPro.screenImages.isNotEmpty &&
                screenPro.screenImages.any((e) => e.isNotEmpty)
            ? ImageSlideShow(
                imageUrls: screenPro.screenImages,
                interval: Duration(
                  seconds: 5,
                ),
              )
            // ImageSlideshow(
            //     imageUrls: _screenPro.screenImages,
            //     initialScale: 3,
            //     finalScale: 3.3,
            //     duration: Duration(seconds: 10),
            //   )
            : _index == 0
                ? FlutterReflectiveScreensaver(
                    speed: 1,
                    child: Image.asset(
                      _imagePath,
                      height: size.getH(200),
                    ),
                  )
                : RandomTextAnimation(
                    child: Image.asset(
                      _imagePath,
                      height: size.getH(300),
                    ),
                  ),
      );
    else
      return SizedBox.shrink();
  }
}
