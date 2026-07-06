import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/profile/user_add_sec.dart';
import 'package:pos_account/widgets/image/network_image_sec.dart';

class UpgradePlanWidget extends StatelessWidget {
  const UpgradePlanWidget({
    super.key,
    required this.size,
    this.height = 324,
    this.upgrade,
    this.imageList,
    this.widgetList = const [],
    this.width = 300,
  });

  final Ssize size;
  final double height;
  final Function()? upgrade;
  final List<UserAddSecData>? imageList;
  final List<Widget> widgetList;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xff00215b),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: SizedBox(
          width: size.getW(width),
          height: size.getH(height),
          child: //GlobalCVP.isSubscriptionActive ||
              Platform.isIOS ? _bannerImage(widgets: widgetList) : _upgradeNow()

          // ? _bannerImage(widgets: [_upgradeNow()])
          // : _bannerImage(
          //     widgets: widgetList,
          //   ),
          ),
    );
  }

  ClipRRect _bannerImage({required List<Widget> widgets}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: imageList == null || imageList!.isEmpty
          ? Image.asset(
              "assets/png/login-image.png",
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
            )
          : CarouselSlider.builder(
              itemCount: imageList!.length + widgets.length,
              itemBuilder: (context, i, y) {
                if (i >= imageList!.length)
                  return widgets[imageList!.length - i];
                else
                  return NetworkImageSec(
                    image: imageList![i].image,
                    height: double.infinity,
                    width: double.infinity,
                    boxFit: BoxFit.fill,
                    errWidget: Image.asset(
                      "assets/png/login-image.png",
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    placeHolder: Container(
                      color: Colors.grey[350],
                    ),
                  );
              },
              options: CarouselOptions(
                height: double.infinity,
                viewportFraction: 1,
                autoPlay: (imageList!.length + widgets.length) > 1,
              ),
            ),
    );
  }

  Padding _upgradeNow() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: size.getH(8.0), horizontal: size.getW(32)),
      child: Column(
        children: [
          Spacer(
            flex: 2,
          ),
          Container(
            padding: EdgeInsets.all(size.getW(8)),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: SvgPicture.asset(
              "assets/svg/icons/warning.svg",
              height: size.getW(48),
              width: size.getW(48),
            ),
          ),
          Spacer(
            flex: 2,
          ),
          Text(
            LN.upgradePlanFromFreeTrial,
            style: TextStyle(
              fontSize: size.getS(21),
              color: Colors.white,
              fontFamily: kFontFMedium,
            ),
            textAlign: TextAlign.center,
          ),
          Spacer(
            flex: 2,
          ),
          ElevatedButton(
              style: ButtonStyle(
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
                  backgroundColor: WidgetStateProperty.all(Colors.white)),
              onPressed: upgrade,
              child: Text(
                LN.upgradeNow,
                style: TextStyle(
                  fontSize: size.getS(18),
                  fontFamily: kFontFMedium,
                  color: Color(0xff00215b),
                ),
              )),
          Spacer(
            flex: 1,
          ),
        ],
      ),
    );
  }
}
