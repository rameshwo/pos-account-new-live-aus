import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/widgets/image/image_error.dart';

class GiftImageSec extends StatelessWidget {
  final bool isSelected;
  final String? imageUrl;
  final Function()? onTap;
  const GiftImageSec(
      {super.key, this.isSelected = false, this.imageUrl, this.onTap});

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? kTempColor : Colors.grey.shade400,
            width: isSelected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(5)),
      margin: EdgeInsets.symmetric(
          vertical: size.getH(12), horizontal: size.getW(12)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: size.getH(12), horizontal: size.getW(12)),
          child: Column(
            children: [
              if (imageUrl != null && imageUrl!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl!,
                    height: size.getH(160),
                    width: size.getW(160),
                    placeholder: ImageError.load,
                    errorWidget: ImageError.icon,
                  ),
                )
              else
                Card(
                  margin: EdgeInsets.zero,
                  child: SizedBox(
                    height: size.getH(160),
                    width: size.getW(160),
                    child: Center(
                      child: Text(
                        LN.noImage,
                        style: TextStyle(
                            fontSize: size.getS(18),
                            fontStyle: FontStyle.italic,
                            color: Colors.black45),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
