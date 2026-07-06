import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';

class SelectiveTab extends StatelessWidget {
  final bool isDefault;
  final Function()? onTap;
  final String title;
  final Widget? trail;
  final Color unSelectBorderColor;
  final double fRatio;

  const SelectiveTab({
    super.key,
    this.isDefault = false,
    this.onTap,
    required this.title,
    this.unSelectBorderColor = Colors.black54,
    this.trail,
    this.fRatio = 1,
  });

  static Widget taxTypeSec(
    Ssize size, {
    bool isSelect = false,
    Function()? onTap,
    String? title,
    double fontRatio = 1,
  }) {
    return Card(
      color: isSelect ? kSecondaryColor : Colors.white,
      margin: EdgeInsets.only(
          right: size.getW(4),
          left: size.getW(4),
          bottom: size.getH(4),
          top: size.getH(4)),
      shape: RoundedRectangleBorder(
          side: BorderSide(
            color: isSelect ? kSecondaryColor : Colors.black,
          ),
          borderRadius: BorderRadius.circular(5)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: size.getH(fontRatio * 12.0), horizontal: size.getW(4)),
          child: Text(
            title ?? '',
            style: TextStyle(
              fontSize: size.getS(18),
              color: isSelect ? Colors.white : Colors.black,
              fontWeight: isSelect ? FontWeight.bold : null,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return Material(
      color: isDefault ? kSecondaryColor : Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: isDefault ? kSecondaryColor : unSelectBorderColor,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: size.getH(4 * fRatio),
                horizontal: size.getW(12 * fRatio)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: size.getS(18 * fRatio),
                    color: isDefault ? Colors.white : Colors.black,
                    fontFamily: isDefault ? kFontFMedium : null,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (trail != null) trail!
              ],
            ),
          ),
        ),
      ),
    );
  }
}
