import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/widgets/load_btn.dart';

class TrialExpiryMsg extends StatelessWidget {
  final Ssize size;
  final bool show;
  final String? btnText;
  final String message;
  final Function()? onTap;
  final double? width;
  const TrialExpiryMsg({
    super.key,
    required this.size,
    this.show = false,
    this.onTap,
    this.btnText,
    required this.message,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final widthh = width ?? (size.width / 1.2);

    return AnimatedSwitcher(
      duration: Duration(milliseconds: 400),
      child: !show
          ? Container()
          : Container(
              key: ValueKey(true),
              width: widthh,
              constraints: BoxConstraints(
                minHeight: size.getH(160),
                maxHeight: size.getH(180),
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: size.getW(12), vertical: size.getH(16)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    "assets/png/unsubscriber.png",
                    height: size.getH(140),
                    fit: BoxFit.fitHeight,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 2,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: size.getH(16)),
                            child: Text(
                              message,
                              style: TextStyle(
                                fontSize: size.getS(18),
                                fontFamily: kFontFMedium,
                                color: Colors.red.shade900,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        if (btnText != null)
                          Flexible(
                            child: LoadButton(
                              btnText: btnText,
                              width: 200,
                              vPad: 8,
                              onsave: onTap,
                            ),
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
