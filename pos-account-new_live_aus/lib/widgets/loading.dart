import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.threeArchedCircle(
        color: kSecondaryColor,
        // secondRingColor: kSecondaryColor,
        // thirdRingColor: kPrimaryColor,
        size: 32,
      ),
      // CircularProgressIndicator.adaptive(
      //   backgroundColor: Colors.transparent,
      //   valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
      // ),
    );
  }

  static bool loadDiaOn = false;

  static Future<void> dialog(
    BuildContext context, {
    String? title,
    Widget? child,
    double width = 140,
    double? height,
    bool allowDismiss = false,
  }) async {
    title ??= LN.loading;
    final size = Ssize(context);

    if (loadDiaOn) return;

    loadDiaOn = true;

    await showDialog(
        context: context,
        barrierDismissible: allowDismiss,
        builder: (context) {
          return SimpleDialog(
            titlePadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            insetPadding: EdgeInsets.zero,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: size.getW(width),
                      height: height,
                      padding: EdgeInsets.symmetric(
                          vertical: size.getH(24), horizontal: size.getW(16)),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          child ?? Loading(),
                          SizedBox(
                            height: size.getH(12),
                          ),
                          Text('${title ?? ''} ...',
                              style: TextStyle(
                                fontSize: size.getS(18),
                                color: Colors.black,
                                fontFamily: kFontFMedium,
                              ))
                        ],
                      )),
                ],
              )
            ],
          );
        });
    loadDiaOn = false;
  }
}

class Processing extends StatelessWidget {
  final Widget child;
  final bool loading;
  final AlignmentGeometry align;
  final Color backColor;
  const Processing({
    super.key,
    required this.child,
    this.loading = false,
    this.align = Alignment.topCenter,
    this.backColor = Colors.black12,
  });

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return Stack(
      alignment: Alignment.center,
      children: [
        Align(alignment: align, child: child),
        if (loading)
          SizedBox(
              width: size.getW(100),
              height: size.getW(100),
              child: Material(
                  color: backColor,
                  elevation: 0.1,
                  shadowColor: backColor.withAlpha(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Loading())),
      ],
    );
  }
}
