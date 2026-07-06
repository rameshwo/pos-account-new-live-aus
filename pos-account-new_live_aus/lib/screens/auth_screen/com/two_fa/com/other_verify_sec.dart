import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'otp_code_sec.dart';

class OtherVerifySec extends StatelessWidget {
  final String title;
  final TextInputType textInputType;
  final TextEditingController textCltr;
  final String hintTextField;
  final Function()? verify;
  final String otpMessage;
  final Function(String)? oTpValidate;
  final bool showDes;
  final bool loading;
  const OtherVerifySec({
    super.key,
    required this.title,
    this.textInputType = TextInputType.text,
    this.hintTextField = "",
    this.verify,
    this.otpMessage = "",
    this.oTpValidate,
    required this.textCltr,
    this.showDes = true,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return SingleChildScrollView(
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: size.getH(12),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: size.getS(showDes ? 28 : 18),
              fontFamily: kFontFMedium,
              fontWeight: FontWeight.w900,
              color: kPrimaryColor,
            ),
          ),
          if (showDes) ...[
            Text(
              LN.the2FaAuthEmailTitle,
              style: TextStyle(
                fontSize: size.getS(16),
                fontFamily: kFontFRegular,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
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
          ],
          SizedBox(
            height: size.getH(24),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        border: Border.all(color: Colors.black38)),
                    padding: EdgeInsets.symmetric(
                        horizontal: size.getW(32), vertical: size.getH(13)),
                    child: Text(
                      textCltr.text,
                      style: TextStyle(
                          fontFamily: kFontFMedium,
                          color: Colors.black,
                          fontSize: size.getS(20)),
                    ),
                  ),
                ),
                SizedBox(
                  width: size.getW(12),
                ),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(Colors.blue.shade700),
                        padding: WidgetStateProperty.all(EdgeInsets.symmetric(
                            horizontal: size.getW(24),
                            vertical: size.getH(12)))),
                    onPressed: verify,
                    child: Text(
                      LN.sendOtp,
                      style: TextStyle(
                        fontSize: size.getS(16),
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
              ],
            ),
          ),
          SizedBox(
            height: size.getH(24),
          ),
          OtpCodeSec(
            otpMessage: otpMessage,
            onTap: oTpValidate,
            isExpire: !showDes,
            loading: loading,
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Checkbox(value: false, onChanged: (bool? val) {}),
          //     Text(
          //       "Skip for 30 Days",
          //       style: TextStyle(
          //         fontSize: 18,
          //         color: Colors.black,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     )
          //   ],
          // )
        ],
      ),
    );
  }
}
