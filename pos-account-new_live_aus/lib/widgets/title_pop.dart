import 'package:flutter/material.dart';
import 'package:pos_account/constant/constant.dart';

import '../config/size_config.dart';

class TitlePop extends StatelessWidget {
  const TitlePop({
    super.key,
    required this.title,
    required this.size,
    this.onTap,
  });

  final String title;
  final VoidCallback? onTap;
  final Ssize size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: size.getS(24),
            ),
            onPressed: () {
              if (onTap != null) {
                onTap!();
              } else {
                Navigator.pop(context);
              }
            }),
        SizedBox(width: size.getW(8)),
        Text(
          title,
          style: TextStyle(
            fontSize: size.getS(20),
            fontFamily: kFontFMedium,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  static Widget infoSection(
    Ssize size, {
    String? title,
    String? subTitle,
  }) {
    if (title == null) return SizedBox.shrink();
    return Container(
      decoration: BoxDecoration(
        color: kSecondaryColor.withOpacity(0.05),
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(
          horizontal: size.getW(12), vertical: size.getH(16)),
      child: Row(
        children: [
          Icon(
            Icons.info,
            color: kSecondaryColor,
            size: size.getS(36),
          ),
          SizedBox(width: size.getW(12)),
          Flexible(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: size.getS(18),
                  // fontFamily: kFontFMedium,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              if (subTitle != null)
                Text(
                  subTitle,
                  style: TextStyle(
                    fontSize: size.getS(16),
                    fontFamily: kFontFRegular,
                    color: Colors.black,
                  ),
                ),
            ],
          ))
        ],
      ),
    );
  }
}
