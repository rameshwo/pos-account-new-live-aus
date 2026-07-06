import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';

import 'otp_code_sec.dart';

class GoogleTFAVer extends StatelessWidget {
  final String? base64String;
  final Function(String)? onTapOtp;
  final Function()? onCancel;
  final bool showDes;
  final bool loading;
  const GoogleTFAVer({
    super.key,
    this.base64String,
    this.onTapOtp,
    this.onCancel,
    this.showDes = true,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: size.getH(12),
                ),
                Text(
                  LN.enable2faAuth,
                  style: TextStyle(
                    fontSize: size.getS(showDes ? 28 : 18),
                    fontFamily: kFontFMedium,
                    fontWeight: FontWeight.w900,
                    color: kPrimaryColor,
                  ),
                ),
                if (showDes) ...[
                  Text(
                    LN.s2faAuthTitle1,
                    style: TextStyle(
                      fontSize: size.getS(16),
                      fontFamily: kFontFRegular,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: size.getH(24),
                  ),
                  // Text(
                  //   LN.s2faAuthTitle2,
                  //   style: TextStyle(
                  //     fontSize: size.getS(16),
                  //     fontFamily: kFontFRegular,
                  //     color: Colors.black,
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: size.getH(24),
                  // ),
                  Text(
                    LN.s2faAuthTitle2,
                    style: TextStyle(
                      fontSize: size.getS(16),
                      fontFamily: kFontFRegular,
                      color: Colors.black,
                    ),
                  ),
                ],
                Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.getH(24),
                      ),
                      OtpCodeSec(
                        otpMessage: LN.enter6digit,
                        onTap: onTapOtp,
                        onCancel: onCancel,
                        isExpire: !showDes,
                        loading: loading,
                      ),
                    ],
                  ),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Checkbox(value: skip4_30Days, onChanged: onChangeSkip),
                //     Text(
                //       "Skip for 30 Days",
                //       style: TextStyle(
                //         fontSize: 18,
                //         color: Colors.black,
                //         fontWeight: FontWeight.bold,
                //       ),
                //     )
                //   ],
                // ),
              ],
            ),
          ),
        ),
        if (base64String != null && showDes)
          Container(
            height: size.getS(200),
            width: size.getS(200),
            margin: EdgeInsets.symmetric(
                horizontal: size.getW(12), vertical: size.getW(12)),
            // color: Colors.amber,
            child: Image.memory(base64Decode(base64String!.split(',').last)),
          )
      ],
    );
  }
}
