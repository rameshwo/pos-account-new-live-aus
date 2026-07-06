import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/stcf/short_tcf_pro.dart';
import 'package:provider/provider.dart';
import 'com/apply_card/apply_card.dart';
import 'com/setting_card_img.dart';

class ShortTermCashFlow extends StatefulWidget {
  const ShortTermCashFlow({super.key});

  @override
  State<ShortTermCashFlow> createState() => _ShortTermCashFlowState();
}

class _ShortTermCashFlowState extends State<ShortTermCashFlow> {
  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return Padding(
      padding: EdgeInsets.symmetric(
          // vertical: size.getH(8.0),
          horizontal: size.getW(24)),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LN.shortTCashFlow,
              style: TextStyle(
                fontSize: size.getS(18),
                fontFamily: kFontFRegular,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: size.getH(12),
            ),
            SettingImageCard(
              size: size,
              title: "Lucapay",
              subTitle: LN.payBillsInstall,
              image: "assets/png/lucapay/pos_lucapay.png",
              button: [BtnClass(title: LN.applyNow, onTap: _applyNow)],
            )
          ],
        ),
      ),
    );
  }

  _applyNow() {
    Provider.of<StcfPro>(context, listen: false).clear;
    showDialog(
        context: context,
        builder: (builder) => SimpleDialog(
              backgroundColor: kBackgroundColor,
              titlePadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              children: [ApplyCard()],
            ));
  }
}
