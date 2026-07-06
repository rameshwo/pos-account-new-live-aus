import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pos_account/config/size_config.dart';

class NetworkImageSec extends StatelessWidget {
  final String? image;
  final double height;
  final double width;
  final BoxFit boxFit;
  final Widget? placeHolder;
  final Widget? errWidget;
  const NetworkImageSec({
    super.key,
    this.image,
    this.height = 100,
    this.width = 140,
    this.boxFit = BoxFit.fitHeight,
    this.placeHolder,
    this.errWidget,
  });

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    if (image == null || image!.isEmpty)
      return SizedBox(
        height: size.getW(height),
        width: size.getW(width),
        child: errWidget ??
            Image.asset(
              'assets/png/placeholder.png',
              height: size.getW(height),
              width: size.getW(width),
              fit: boxFit,
            ),
      );
    else if (image!.contains('assets/')) {
      if (image!.contains('.svg'))
        return SvgPicture.asset(
          image!,
          height: size.getW(height),
          width: size.getW(width),
          fit: boxFit,
        );
      else
        return Image.asset(
          image!,
          height: size.getW(height),
          width: size.getW(width),
          fit: boxFit,
        );
    } else if (!image!.contains('https://')) {
      if (image!.contains('.svg'))
        return SvgPicture.file(
          File(image!),
          height: size.getW(height),
          width: size.getW(width),
          fit: boxFit,
        );
      else
        return Image.file(
          File(image!),
          height: size.getW(height),
          width: size.getW(width),
          fit: boxFit,
        );
    } else {
      return CachedNetworkImage(
          imageUrl: image!,
          height: size.getW(height),
          width: size.getW(width),
          fit: boxFit,
          placeholder: (context, url) =>
              placeHolder ?? Image.asset('assets/png/placeholder.png'),
          errorWidget: (context, url, error) =>
              errWidget ??
              Image.asset(
                'assets/png/placeholder.png',
                height: size.getS(40),
                width: size.getS(40),
                fit: boxFit,
              ));
    }
    //  ImageError.text(context, url, error));
  }
}
