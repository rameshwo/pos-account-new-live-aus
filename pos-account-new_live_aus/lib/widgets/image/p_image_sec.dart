import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'image_error.dart';

class PImageSection extends StatelessWidget {
  final String? imagePath;
  final String? hintText;
  final Function()? onTap;
  final Color backgroundColor;
  const PImageSection({
    super.key,
    this.imagePath,
    this.hintText,
    this.onTap,
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return DottedBorder(
      color: kSecondaryColor,
      borderType: BorderType.RRect,
      strokeWidth: 2,
      dashPattern: [16, 8],
      radius: Radius.circular(10),
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Center(
            child: (imagePath != null && imagePath!.isNotEmpty)
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: (imagePath!.contains('http')
                        ? CachedNetworkImage(
                            imageUrl: imagePath!,
                            fit: BoxFit.cover,
                            height: size.getS(200),
                            // width: size.getS(200),
                            placeholder: ImageError.load,
                            errorWidget: ImageError.icon,
                          )
                        : Image.file(
                            File(imagePath!),
                            fit: BoxFit.cover,
                            width: size.getS(200),
                            // height: size.getS(200),
                          )))
                : Container(
                    alignment: Alignment.center,
                    height: size.getH(200),
                    padding: EdgeInsets.symmetric(
                        horizontal: size.getW(12), vertical: size.getH(8)),
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: backgroundColor)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/svg/others/product_image.svg",
                          height: size.getS(80),
                          width: size.getS(80),
                        ),
                        if (hintText != null) ...[
                          SizedBox(
                            height: size.getH(12),
                          ),
                          Text(
                            hintText!,
                            style: TextStyle(
                              fontSize: size.getS(16),
                              color: kSecondaryColor,
                            ),
                          )
                        ]
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
