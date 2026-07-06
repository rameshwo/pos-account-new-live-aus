import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/ui_model/amount_class.dart';

class OrderTotalSection extends StatelessWidget {
  final Widget? bottomWidget;
  final AmountClass amount;
  final String curSym;
  final bool isPayScreen;
  final TaxType? taxType;
  final double fontUp;
  const OrderTotalSection({
    super.key,
    required this.amount,
    this.bottomWidget,
    this.curSym = "",
    this.isPayScreen = true,
    this.taxType,
    this.fontUp = 0,
  });

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);

    return Column(
      children: [
        if (taxType != TaxType.NoTax) ...[
          Divider(
            color: Colors.black54,
            thickness: 0.6,
          ),
          if (taxType == TaxType.Exclusive)
            Padding(
              padding: EdgeInsets.only(top: size.getH(4)),
              child: Row(
                children: [
                  Text(
                    LN.subtotal,
                    style: TextStyle(
                      fontSize: size.getS(16 + fontUp),
                      color: Colors.black,
                    ),
                  ),
                  Spacer(),
                  Text(
                    curSym + amount.itemPrice.nonNan().roundToNString(),
                    style: TextStyle(
                      fontSize: size.getS(16 + fontUp),
                      color: Colors.black,
                      fontFamily: kFontFMedium,
                    ),
                  ),
                ],
              ),
            ),
          // if (isPayScreen) ...[
          Row(
            children: [
              SizedBox(height: size.getH(4)),
              Text(
                taxType == TaxType.Inclusive ? LN.taxIncInTotal : LN.tax,
                style: TextStyle(
                  fontSize: size.getS(16 + fontUp),
                  color: Colors.black,
                ),
              ),
              Spacer(),
              Text(
                curSym + (amount.totalTax).nonNan().roundToNString(),
                style: TextStyle(
                  fontSize: size.getS(16 + fontUp),
                  color: Colors.black,
                  fontFamily: kFontFMedium,
                ),
              ),
            ],
          )
        ],
        Divider(
          color: Colors.black54,
          thickness: 0.6,
        ),
        // ],
        Row(
          children: [
            Text(
              LN.total,
              style: TextStyle(
                fontSize: size.getS(16 + fontUp),
                color: Colors.black,
              ),
            ),
            Spacer(),
            Text(
              curSym + amount.totalPrice.nonNan().roundToNString(),
              style: TextStyle(
                fontSize: size.getS(16 + fontUp),
                color: Colors.black,
                fontFamily: kFontFMedium,
              ),
            ),
          ],
        ),
        SizedBox(height: size.getH(6)),
        if (bottomWidget != null) bottomWidget!,
      ],
    );
  }
}
