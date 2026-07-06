import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'image_error.dart';

class ProfileImageSec extends StatelessWidget {
  // final String? imageUrl;
  final Ssize size;
  final String? filePath;
  final Function()? pickImage;
  final double radius;
  const ProfileImageSec({
    super.key,
    // this.imageUrl,
    required this.size,
    this.filePath,
    this.pickImage,
    this.radius = 160,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: size.getW(6),
              color: kUserColor.withAlpha(70),
            ),
            shape: BoxShape.circle,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(200),
            child: (filePath == null || filePath!.isEmpty)
                ? SvgPicture.asset(
                    "assets/svg/others/avatar.svg",
                    fit: BoxFit.cover,
                    width: size.getS(radius),
                    height: size.getS(radius),
                  )
                : filePath!.contains('http')
                    ? CachedNetworkImage(
                        imageUrl: filePath!,
                        fit: BoxFit.cover,
                        width: size.getS(radius),
                        height: size.getS(radius),
                        placeholder: ImageError.load,
                        errorWidget: ImageError.icon,
                      )
                    : Image.file(
                        File(filePath!),
                        fit: BoxFit.cover,
                        width: size.getS(radius),
                        height: size.getS(radius),
                      ),
          ),
        ),
        InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: pickImage,
          child: Card(
            color: kUserColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: Padding(
              padding: EdgeInsets.all(size.getS(8)),
              child: Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: size.getS(28),
              ),
            ),
          ),
        )
      ],
    );
  }
}
