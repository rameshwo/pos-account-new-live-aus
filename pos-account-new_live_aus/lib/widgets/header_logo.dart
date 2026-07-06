import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';

class HeaderLogo extends StatelessWidget {
  final double height;
  const HeaderLogo({super.key, this.height = 48});

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return
        // Text(
        //   LN.headerTitle,
        //   style: TextStyle(
        //     color: kPrimaryColor,
        //     fontFamily: kFontFMedium,
        //     fontSize: size.getS(32),
        //   ),
        // );
        Image.asset(
      "assets/png/posapt.png",
      height: size.getH(height),
    );
  }
}
