import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pos_account/config/size_config.dart';

import '../constant/constant.dart';

class NewCard extends StatelessWidget {
  final String title;
  final String? subTitle;
  final String? asset;
  final Widget? iconWidget;
  final Function()? onTap;
  final double? width;
  final double? height;
  const NewCard({
    super.key,
    required this.title,
    this.subTitle,
    this.onTap,
    this.asset,
    this.width,
    this.height,
    this.iconWidget,
  });

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        width: width ?? size.width * 0.22,
        height: height ?? size.getH(120),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: size.getH(12), horizontal: size.getW(24)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (asset != null && asset!.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(right: size.getW(16)),
                    child: SvgPicture.asset(
                      asset!,
                      width: size.getW(40),
                      height: size.getW(40),
                    ),
                  )
                else if (iconWidget != null)
                  Padding(
                    padding: EdgeInsets.only(right: size.getW(16)),
                    child: iconWidget,
                  ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: size.getH(20),
                          fontFamily: kFontFMedium,
                          color: Colors.black,
                        ),
                      ),

                      // SizedBox(
                      //   height: size.getH(12),
                      // ),
                      if (subTitle != null)
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(top: size.getH(12)),
                            child: Text(
                              subTitle!,
                              style: TextStyle(
                                fontSize: size.getS(16),
                                color: Colors.grey.shade500,
                              ),
                              // overflow: TextOverflow.visible,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
