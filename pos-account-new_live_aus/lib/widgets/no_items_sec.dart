import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';

class NoItemsSec extends StatelessWidget {
  final Ssize size;
  final String title;
  final Color backColor;
  final double iconHeight;
  const NoItemsSec({
    super.key,
    required this.size,
    required this.title,
    this.backColor = Colors.transparent,
    this.iconHeight = 280,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width / 1.2,
      constraints: BoxConstraints(
        minHeight: size.getH(160),
        maxHeight: size.getH(400),
      ),
      padding: EdgeInsets.symmetric(
          horizontal: size.getW(12), vertical: size.getH(16)),
      decoration: BoxDecoration(
        color: backColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: size.getH(iconHeight),
              child: Lottie.asset("assets/json/not_found.json", animate: false),
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(bottom: size.getH(16)),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: size.getS(24),
                    fontFamily: kFontFMedium,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
