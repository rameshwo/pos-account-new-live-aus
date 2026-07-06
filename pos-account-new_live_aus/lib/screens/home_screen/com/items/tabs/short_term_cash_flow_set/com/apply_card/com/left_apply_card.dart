import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/ui_model/asset_title.dart';

class LeftApplyCard extends StatelessWidget {
  const LeftApplyCard({
    super.key,
    required this.size,
  });

  final Ssize size;

  @override
  Widget build(BuildContext context) {
    final assets = <AssetTitle>[
      AssetTitle(
          id: 1, title: LN.fastTrack, assetPath: "assets/png/lucapay/1.png"),
      AssetTitle(
          id: 2, title: LN.saveTime, assetPath: "assets/png/lucapay/2.png"),
      AssetTitle(
          id: 3, title: LN.takePressOff, assetPath: "assets/png/lucapay/3.png"),
      AssetTitle(
          id: 4, title: LN.betterSupBuy, assetPath: "assets/png/lucapay/4.png"),
    ];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.getW(48)),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.getH(20),
            ),
            Image.asset(
              "assets/png/lucapay/pos_lucapay.png",
              width: size.getW(400),
            ),
            SizedBox(
              height: size.getH(16),
            ),
            Text(
              LN.partnerWith,
              style: TextStyle(
                fontSize: size.getS(16),
                fontFamily: kFontFRegular,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: size.getH(24),
            ),
            Wrap(
              spacing: size.getS(60),
              runSpacing: size.getS(32),
              children: List.generate(
                  assets.length,
                  (index) => SizedBox(
                        width: size.getS(160),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              assets[index].assetPath,
                              width: size.getS(80),
                              height: size.getS(80),
                            ),
                            Text(
                              assets[index].title,
                              style: TextStyle(
                                fontSize: size.getS(14),
                                fontFamily: kFontFRegular,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      )),
            ),
            SizedBox(
              height: size.getH(24),
            ),
            Text(
              LN.lucaDes,
              style: TextStyle(
                fontSize: size.getS(11.5),
                fontFamily: kFontFRegular,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: size.getH(32),
            ),
          ],
        ),
      ),
    );
  }
}
