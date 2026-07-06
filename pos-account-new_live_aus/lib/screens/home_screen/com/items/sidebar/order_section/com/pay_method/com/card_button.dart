import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';

class CardButton extends StatelessWidget {
  final String title;
  // final String? imgPath;
  final TileColor? tileColor;
  final Function()? onTap;
  final bool isSelected;
  const CardButton({
    super.key,
    required this.title,
    // this.imgPath,
    this.tileColor,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final _cardColor = onTap == null
        ? Colors.grey.shade400
        : isSelected
            ? (tileColor?.selectedBackColor ?? kSecondaryColor)
            : (tileColor?.backColor ?? Colors.white);
    // onTap == null
    //     ? Colors.grey.shade500
    //     : isSelected
    //         ? kBtnColor
    //         : kSecondaryColor;
    final _borderColor = onTap == null
        ? Colors.grey.shade400
        : (tileColor?.selectedBackColor ?? kSecondaryColor);
    final _textColor = onTap == null
        ? Colors.white
        : isSelected
            ? (tileColor?.selectedTextColor ?? Colors.white)
            : (tileColor?.textColor ?? kSecondaryColor);

    // Colors.white;

    return Container(
      decoration: isSelected
          ? BoxDecoration(
              border: Border.all(color: _borderColor),
              borderRadius: BorderRadius.circular(10))
          : null,
      margin: EdgeInsets.symmetric(horizontal: size.getW(2)),
      child: Card(
        color: _cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: _borderColor),
        ),
        child: SizedBox(
          width: size.getW(80),
          height: size.getH(60),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: size.getH(6.0), horizontal: size.getW(2)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // imgPath != null && imgPath!.isNotEmpty
                  //     ? SvgImageSection(
                  //         imageUrl: imgPath!,
                  //         width: size.getS(32),
                  //         height: size.getS(32),
                  //         color: _textColor,
                  //         placeholder: (ctx) => SvgPicture.asset(
                  //               "assets/svg/others/Wallet.svg",
                  //               width: size.getS(32),
                  //               height: size.getS(32),
                  //             ))
                  //     : SvgPicture.asset(
                  //         "assets/svg/others/Wallet.svg",
                  //         width: size.getS(32),
                  //         height: size.getS(32),
                  //         color: _textColor,
                  //       ),
                  // SizedBox(
                  //   height: size.getH(4),
                  // ),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: size.getS(title.length < 12 ? 16 : 13),
                      color: _textColor,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    // overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
