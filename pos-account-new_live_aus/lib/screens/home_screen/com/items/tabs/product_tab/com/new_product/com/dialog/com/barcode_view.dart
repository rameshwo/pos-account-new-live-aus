import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';

class BarCodeView extends StatelessWidget {
  const BarCodeView({
    super.key,
    required this.size,
    this.title,
    this.code,
    this.price,
    this.discountPrice,
    required this.barcode,
    this.curSym = "",
  });

  final Ssize size;
  final String? title;
  final String? code;
  final String? price;
  final String barcode;
  final String? discountPrice;
  final String curSym;

  @override
  Widget build(BuildContext context) {
    final _discountPrice =
        ((discountPrice?.isNotEmpty ?? false) && discountPrice != price)
            ? (curSym + (discountPrice?.inDouble.roundToNString() ?? '0.00'))
            : null;
    final _price = curSym + (price?.inDouble.roundToNString() ?? '0.00');
    final _topPrice = _discountPrice ?? _price;
    return Container(
      width: size.getW(425),
      decoration: BoxDecoration(color: Colors.white),
      padding: EdgeInsets.symmetric(
        horizontal: size.getW(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Text(
              title ?? '',
              style: TextStyle(
                fontSize: size.getS(24),
                fontWeight: FontWeight.bold,
                color: Colors.black,
                overflow: TextOverflow.ellipsis,
              ),
              maxLines: 2,
            ),
          SizedBox(
            height: size.getH(132),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      text: _topPrice,
                      children: [
                        if (_discountPrice != null)
                          TextSpan(
                            text: "\n$_price",
                            style: TextStyle(
                              fontSize: size.getS(_price.length > 6 ? 23 : 25),
                              decoration: TextDecoration.lineThrough,
                              fontFamily: kFontFMedium,
                              color: Colors.black,
                              height: 0.8,
                            ),
                          )
                      ],
                    ),
                    style: TextStyle(
                      fontSize: size.getS(_topPrice.length > 6 ? 40 : 50),
                      fontWeight: FontWeight.bold,
                      fontFamily: kFontFMedium,
                      color: Colors.black,
                      height: 1.4,
                    ),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      code ?? '',
                      style: TextStyle(
                        fontSize: size.getS(18),
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: size.getH(100),
                      child: BarcodeWidget(
                        barcode: Barcode.code128(),
                        data: barcode,
                        style: TextStyle(
                          fontSize: size.getS(18),
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
