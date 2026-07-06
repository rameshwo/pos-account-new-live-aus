import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/model/profile/user_add_sec.dart';

class CashTabSection extends StatelessWidget {
  const CashTabSection({
    super.key,
    this.onTapCash,
    this.availiableCurrencies,
    this.cashIndex,
  });

  final Function(int)? onTapCash;
  final List<UserAddSecData>? availiableCurrencies;
  final int? cashIndex;

  @override
  Widget build(BuildContext context) {
    Ssize size = Ssize(context);
    return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            availiableCurrencies!.length,
            (index) => Padding(
              padding: EdgeInsets.symmetric(horizontal: size.getW(8)),
              child: ElevatedButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                      vertical: size.getH(8), horizontal: size.getW(16))),
                  backgroundColor: MaterialStateProperty.all(
                    cashIndex != null
                        ? cashIndex == index
                            ? kTempColor
                            : kSecondaryColor
                        : kSecondaryColor,
                  ),
                ),
                onPressed: onTapCash != null ? () => onTapCash!(index) : null,
                child: Text(
                  availiableCurrencies![index].value!,
                  style: TextStyle(
                    fontSize: size.getS(18),
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
