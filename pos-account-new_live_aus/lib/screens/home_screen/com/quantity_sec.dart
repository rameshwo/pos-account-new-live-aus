import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';

class QuantitySection extends StatelessWidget {
  final Ssize size;
  final double quantity;
  final double fr;
  final double vPad;
  final Function(bool?)? update;

  const QuantitySection(
      {required this.size,
      required this.quantity,
      this.update,
      this.fr = 1,
      this.vPad = 4,
      super.key});

  @override
  Widget build(BuildContext context) {
    final _roundQty = quantity.round();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Colors.black38)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(5),
                onTap: update == null
                    ? null
                    : () {
                        update!(false);
                      },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: size.getH(vPad * fr),
                      horizontal: size.getW(16 * fr)),
                  child: Text(
                    '-',
                    style: TextStyle(
                      fontSize: size.getS(20 * fr),
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: update == null
                    ? null
                    : () {
                        update!(null);
                      },
                child: Container(
                  width: size.getW((quantity.round().toString().length > 4
                          ? 80
                          : quantity.round().toString().length > 3
                              ? 60
                              : 48) *
                      fr),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.symmetric(
                          vertical: BorderSide(color: Colors.black38))),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: size.getH(vPad * fr),
                        horizontal: size.getW(0)),
                    child: Text(
                      "${(quantity % _roundQty) == 0.0 ? quantity.round() : quantity}",
                      style: TextStyle(
                        fontSize: size.getS(17 * fr),
                        fontFamily: kFontFMedium,
                        color: Colors.black,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: update == null
                    ? null
                    : () {
                        update!(true);
                      },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: size.getH(vPad * fr),
                      horizontal: size.getW(16 * fr)),
                  child: Text(
                    '+',
                    style: TextStyle(
                      fontSize: size.getS(20 * fr),
                      fontFamily: kFontFMedium,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Card(
        //   color: Colors.white,
        //   shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(10),
        //       side: BorderSide(color: kTempColor)),
        //   child: InkWell(
        //     onTap: update == null
        //         ? null
        //         : () {
        //             update!(null);
        //           },
        //     child: Padding(
        //       padding: EdgeInsets.symmetric(
        //           vertical: size.getH(3.0), horizontal: size.getW(12)),
        //       child: Text(
        //         "${(quantity % _roundQty) == 0.0 ? quantity.round() : quantity}",
        //         style: TextStyle(
        //           fontSize: size.getS(16 * fr),
        //           fontFamily: kFontFBold,
        //           color: Colors.red,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        // Card(
        //   color: Colors.white,
        //   shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(10),
        //       side: BorderSide(color: kTempColor)),
        //   child: InkWell(
        //     borderRadius: BorderRadius.circular(10),
        //     onTap: update == null
        //         ? null
        //         : () {
        //             update!(true);
        //           },
        //     child: Padding(
        //       padding: EdgeInsets.symmetric(
        //           vertical: size.getH(0.0), horizontal: size.getW(8)),
        //       child: Text(
        //         '+',
        //         style: TextStyle(
        //           fontSize: size.getS(20 * fr),
        //           fontFamily: kFontFBold,
        //           color: kTempColor,
        //         ),
        //       ),
        //     ),
        //   ),
        // )
      ],
    );
  }
}
