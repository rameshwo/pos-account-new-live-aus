import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/widgets/image/network_image_sec.dart';

class ImageShowDia extends StatelessWidget {
  final String diaName;
  final String image;

  const ImageShowDia({
    super.key,
    required this.diaName,
    required this.image,
  });

  static Future showQRDia({
    required BuildContext ctx,
    required String image,
    required String diaName,
  }) async {
    return await showDialog(
        context: ctx,
        builder: (builder) => SimpleDialog(
              backgroundColor: kBackgroundColor,
              titlePadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              children: [
                ImageShowDia(
                  image: image,
                  diaName: diaName,
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return Container(
      constraints: BoxConstraints(
        maxHeight: size.height / 1.14,
        minHeight: size.height / 4,
      ),
      width: size.width / 2.6,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: size.getH(24),
          ),
          Text(
            diaName,
            style: TextStyle(
              fontSize: size.getS(24),
              // fontFamily: ,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(
            height: size.getH(18),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              // borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              children: [
                NetworkImageSec(
                  image: image,
                  height: size.height * 0.6,
                  width: size.height * 0.6,
                ),
              ],
            ),
          ),
          SizedBox(
            height: size.getH(60),
          ),
        ],
      ),
    );
  }
}
