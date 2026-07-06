import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/widgets/image/network_image_sec.dart';

class BtnClass {
  final String title;
  final Function() onTap;
  final Color? color;

  BtnClass({
    required this.title,
    required this.onTap,
    this.color,
  });
}

class SettingImageCard extends StatelessWidget {
  const SettingImageCard({
    super.key,
    required this.size,
    this.title,
    this.subTitle,
    this.image,
    this.button,
    this.moreOption,
    this.isSelected = false,
    this.onTap,
    this.width = 700,
  });

  final Ssize size;
  final String? title;
  final String? subTitle;
  final String? image;
  final List<BtnClass>? button;
  final Widget? moreOption;
  final bool isSelected;
  final double width;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: SizedBox(
            width: size.getW(width),
            height: size.getH(170),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              splashColor: kSecondaryColor.withAlpha(60),
              onTap: onTap,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: size.getH(12.0), horizontal: size.getW(12)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: NetworkImageSec(
                      image: image, // "assets/png/lucapay/lucapay.png",
                      height: 80,
                      boxFit: BoxFit.contain,
                    )),
                    SizedBox(
                      width: size.getW(16),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title ?? '',
                                style: TextStyle(
                                  fontSize: size.getS(24),
                                  fontFamily: kFontFMedium,
                                  fontWeight: FontWeight.bold,
                                  color: kPrimaryColor,
                                ),
                              ),
                              if (moreOption != null) ...[Spacer(), moreOption!]
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: size.getH(4)),
                            child: Text(
                              subTitle ?? '',
                              style: TextStyle(
                                fontSize: size.getS(16),
                                fontFamily: kFontFRegular,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: size.getH(6),
                          ),
                          if (button != null)
                            Wrap(
                              spacing: size.getW(12),
                              runSpacing: size.getH(12),
                              children: List.generate(
                                  button!.length,
                                  (index) => ElevatedButton(
                                      style: ButtonStyle(
                                          minimumSize: WidgetStateProperty.all(
                                              Size.zero),
                                          backgroundColor:
                                              WidgetStateProperty.all(
                                                  button![index].color ??
                                                      kPrimaryColor),
                                          shape: WidgetStateProperty.all(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          )),
                                          padding: WidgetStateProperty.all(
                                            EdgeInsets.symmetric(
                                                horizontal: size.getW(12),
                                                vertical: size.getH(10)),
                                          )),
                                      onPressed: button?[index].onTap,
                                      child: Text(
                                        button?[index].title ?? '',
                                        style: TextStyle(
                                          fontSize: size.getS(14),
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ))),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: size.getW(12),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // TODO: WINDCAVE TEST
        // if (isSelected)
        //   Container(
        //     decoration: BoxDecoration(
        //       color: Colors.green.shade700,
        //       borderRadius: BorderRadius.circular(5),
        //     ),
        //     padding: EdgeInsets.symmetric(
        //         horizontal: size.getW(12), vertical: size.getH(4)),
        //     child: Text(
        //       LN.defaultText,
        //       style: TextStyle(color: Colors.white, fontSize: size.getS(16)),
        //     ),
        //   )
      ],
    );
  }
}
