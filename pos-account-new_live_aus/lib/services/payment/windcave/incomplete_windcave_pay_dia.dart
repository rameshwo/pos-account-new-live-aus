import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/widgets/load_btn.dart';

class InCompleteWindcavePayDia extends StatelessWidget {
  const InCompleteWindcavePayDia({super.key});

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
        SizedBox(
          width: size.getW(500),
        ),
        Image.asset(
          "assets/png/windcave.png",
          width: size.getW(140),
          height: size.getW(60),
        ),
        SizedBox(
          height: size.getH(24),
        ),
        Center(
          child: Text(
            LN.incompleteTransactionRecovery,
            style: TextStyle(
              fontSize: size.getS(22),
              fontWeight: FontWeight.bold,
              color: Colors.black,
              height: 1.4,
            ),
          ),
        ),
        SizedBox(
          height: size.getH(24),
        ),
        LoadButton(
          btnText: LN.continueTransaction,
          onsave: () {
            Navigator.pop(context, true);
          },
        ),
        SizedBox(
          height: size.getH(12),
        ),
      ],
    );
  }
}
