import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:pos_account/constant/constant.dart';
import 'image_error.dart';

class UploadContainer extends StatelessWidget {
  final String title;
  final String? imageUrl;
  // final String bottomText;
  final Function()? onTap;
  final Function()? remove;
  const UploadContainer({
    super.key,
    required this.title,
    // required this.bottomText,
    this.onTap,
    this.imageUrl,
    this.remove,
  });

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      color: Colors.grey.shade400,
      strokeWidth: 1.5,
      dashPattern: [6, 7],
      radius: Radius.circular(10),
      borderType: BorderType.RRect,
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        splashColor: kSecondaryColor.withAlpha(60),
        child: SizedBox(
          width: double.infinity,
          height: 200,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              alignment: Alignment.center,
              children: [
                imageUrl == null || imageUrl!.isEmpty
                    ? Text(
                        title,
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.black38,
                        ),
                      )
                    : (imageUrl!.contains('http')
                        ? CachedNetworkImage(
                            imageUrl: imageUrl!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            // height: 200,
                            // width: size.getS(200),
                            placeholder: ImageError.load,
                            errorWidget: ImageError.icon,
                          )
                        : Image.file(
                            File(imageUrl!),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            // width: size.getS(200),
                            // height: size.getS(200),
                          )),
                if (imageUrl != null && imageUrl!.isNotEmpty)
                  Align(
                    alignment: Alignment.topRight,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100)),
                      child: IconButton(
                          onPressed: remove,
                          icon: Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                            size: 28,
                          )),
                    ),
                  ),
                // Align(
                //   alignment: Alignment.bottomRight,
                //   child: Container(
                //     decoration: BoxDecoration(
                //       color: Colors.white.withAlpha(70),
                //       borderRadius:
                //           BorderRadius.only(topLeft: Radius.circular(10)),
                //     ),
                //     padding: EdgeInsets.fromLTRB(12, 4, 0, 4),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.end,
                //       mainAxisSize: MainAxisSize.min,
                //       children: [
                //         Icon(
                //           Icons.camera_alt_outlined,
                //           color: kPrimaryColor,
                //           size: 20,
                //         ),
                //         SizedBox(width: 6),
                //         Text(
                //           bottomText,
                //           style: TextStyle(color: kPrimaryColor, fontSize: 14),
                //         ),
                //         SizedBox(width: 12),
                //       ],
                //     ),
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
