import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/screens/auth_screen/com/two_fa/com/otp_code_sec.dart';

class DiaCodeSec extends StatelessWidget {
  final Function(String)? oTpValidate;
  final bool loading;
  const DiaCodeSec({super.key, this.oTpValidate, this.loading = false});

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return SizedBox(
      height: size.getH(450),
      child: SingleChildScrollView(
          child: Column(
        children: [
          SizedBox(
            height: size.getH(24),
          ),
          Text(LN.sessionExpired,
              style: TextStyle(
                fontSize: size.getS(32),
                fontFamily: kFontFRegular,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              )),
          Text(
            "Enter the code to access your account",
            style: TextStyle(
              fontSize: size.getS(18),
              fontFamily: kFontFRegular,
              color: Colors.black,
            ),
          ),
          SizedBox(
            height: size.getH(24),
          ),
          OtpCodeSec(
            otpMessage: LN.enter6digit,
            onTap: oTpValidate,
            isExpire: true,
            loading: loading,
          ),
        ],
      )),
    );
  }
}
