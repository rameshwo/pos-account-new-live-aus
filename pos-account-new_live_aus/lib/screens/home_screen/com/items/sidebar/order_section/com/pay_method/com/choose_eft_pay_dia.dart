import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';

enum EftPayMethod {
  Mx51,
// Linky,
  VisionPay,
  WindcavePay
}

class ChooseEftPayDia extends StatelessWidget {
  final List<EftPayMethod> hiddenList;
  const ChooseEftPayDia({
    super.key,
    this.hiddenList = const [],
  });

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return SimpleDialog(
      backgroundColor: kBackgroundColor,
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.symmetric(
          horizontal: size.getW(12), vertical: size.getH(12)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: size.getW(8), vertical: size.getH(8)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  text: "Choose the Terminal",
                ),
                style: TextStyle(
                  fontSize: size.getS(22),
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  height: 1.4,
                ),
              ),
              Spacer(),
              Container(
                  decoration: BoxDecoration(
                    color: Colors.red.shade800,
                    shape: BoxShape.circle,
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: size.getS(8), vertical: size.getS(8)),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  )),
            ],
          ),
        ),
        SizedBox(
          height: size.getH(24),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (!hiddenList.any((e) => e == EftPayMethod.Mx51)) ...[
              _cardSec(
                  title: "Simple Cloud Integration",
                  asset: "assets/svg/icons/mx.svg",
                  size: size,
                  onTap: () {
                    Navigator.pop(context, EftPayMethod.Mx51);
                  }),
              SizedBox(
                width: size.getW(24),
              )
            ],
            if (!hiddenList.any((e) => e == EftPayMethod.VisionPay)) ...[
              _cardSec(
                title: "Vision Pay",
                asset: "assets/png/vision_pay.png",
                size: size,
                onTap: () {
                  Navigator.pop(context, EftPayMethod.VisionPay);
                },
              ),
              SizedBox(
                width: size.getW(24),
              )
            ],
            if (!hiddenList.any((e) => e == EftPayMethod.WindcavePay))
              _cardSec(
                title: "Windcave Pay",
                asset: "assets/png/windcave.png",
                size: size,
                onTap: () {
                  Navigator.pop(context, EftPayMethod.WindcavePay);
                },
              ),
            // _cardSec(
            //   title: "Linky",
            //   asset: "assets/png/linky.png",
            //   size: size,
            //   onTap: () {
            //     Navigator.pop(context, EftPayMethod.Linky);
            //   },
            // ),
          ],
        ),
        SizedBox(
          height: size.getH(24),
          width: size.getW(460),
        ),
      ],
    );
  }

  Widget _cardSec({
    Function()? onTap,
    required Ssize size,
    required String title,
    required String asset,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: size.getW(12), vertical: size.getH(12)),
              child: asset.contains('.svg')
                  ? SvgPicture.asset(
                      asset,
                      width: size.getW(140),
                      height: size.getW(60),
                    )
                  : Image.asset(
                      asset,
                      width: size.getW(140),
                      height: size.getW(60),
                    ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: size.getW(12), vertical: size.getH(12)),
            child: Text(
              title,
              style: TextStyle(
                fontSize: size.getS(22),
                fontWeight: FontWeight.bold,
                color: Colors.black,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
