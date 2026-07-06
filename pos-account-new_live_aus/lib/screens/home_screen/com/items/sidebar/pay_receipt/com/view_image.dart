import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/widgets/image/image_error.dart';
import 'package:pos_account/widgets/no_items_sec.dart';

class ImageFullScreen extends StatelessWidget {
  final String imageUrl;
  final String title;
  const ImageFullScreen({
    super.key,
    required this.imageUrl,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return SizedBox(
      height: size.height * 0.7,
      width: size.width * 0.7,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: size.getH(12), horizontal: size.getW(12)),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  title,
                  style: TextStyle(
                    fontSize: size.getS(16),
                    fontWeight: FontWeight.w500,
                  ),
                )),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close,
                        size: size.getS(25), color: Colors.black)),
              ],
            ),
          ),
          if (imageUrl.contains('https://'))
            Expanded(
              child: PhotoView(
                imageProvider: CachedNetworkImageProvider(imageUrl),
                loadingBuilder: (_, a) => ImageError.load(_, ""),
                errorBuilder: (_, a, b) => Center(
                    child:
                        NoItemsSec(size: Ssize(context), title: LN.noImgFound)),
                minScale: PhotoViewComputedScale.contained * 1,
                maxScale: PhotoViewComputedScale.contained * 4,
              ),
            )
          else
            Expanded(
              child: PhotoView(
                imageProvider: FileImage(
                  File(imageUrl),
                ),
                minScale: PhotoViewComputedScale.contained * 1,
                maxScale: PhotoViewComputedScale.contained * 4,
              ),
            ),
        ],
      ),
    );
  }
}
