import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:pos_account/config/dual_display/dual_display_config.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/second_app/model/call_back_model.dart';
import 'package:pos_account/widgets/image/network_image_sec.dart';
import 'video_section.dart';

class AdSection extends StatelessWidget {
  final AdsPattern? adsPattern;
  const AdSection({super.key, this.adsPattern});

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return Column(
      children: [
        if (adsPattern?.videoPath?.isNotEmpty ?? false)
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: VideoSection(url: adsPattern?.videoPath ?? ''),
                ),
              ],
            ),
          ),
        if (adsPattern?.imagePathList?.isNotEmpty ?? false)
          Expanded(
              child: CarouselSlider.builder(
            itemCount: adsPattern!.imagePathList!.length,
            itemBuilder: (context, i, y) {
              final image = adsPattern!.imagePathList![i];
              if (image.isNotEmpty)
                return Image.file(
                  File(image),
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                );
              else
                return Container();
            },
            options: CarouselOptions(
              height: double.infinity,
              viewportFraction: 1,
              autoPlay: adsPattern!.imagePathList!.length > 1,
            ),
          )),
        if (adsPattern!.pattern == DualDisPattern.style4 &&
            adsPattern?.adProductData != null)
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: NetworkImageSec(
                    image: adsPattern?.adProductData?.image,
                    height: 400,
                    width: 360,
                  ),
                ),
                SizedBox(
                  height: size.getH(12),
                ),
                Text(
                  adsPattern?.adProductData?.productName ?? '',
                  style: TextStyle(
                    fontSize: size.getS(24),
                    color: Colors.black,
                    fontFamily: kFontFMedium,
                  ),
                ),
                SizedBox(
                  height: size.getH(4),
                ),
                Text(
                  "Price: ${adsPattern?.adProductData?.price}",
                  style: TextStyle(
                    fontSize: size.getS(22),
                    color: Colors.black,
                    fontFamily: kFontFMedium,
                  ),
                ),
                SizedBox(
                  height: size.getH(4),
                ),
                Text(
                  "Quantity: ${adsPattern?.adProductData?.quantity}",
                  style: TextStyle(
                    fontSize: size.getS(20),
                    color: Colors.black,
                    fontFamily: kFontFMedium,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
