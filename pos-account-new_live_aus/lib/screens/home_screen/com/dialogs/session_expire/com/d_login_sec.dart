import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';

class DiaLoginSec extends StatelessWidget {
  final bool? loading;
  final Function(bool val) onLogin;

  const DiaLoginSec({
    super.key,
    required this.loading,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: size.getH(36)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(LN.sessionExpired,
              style: TextStyle(
                fontSize: size.getS(32),
                fontFamily: kFontFRegular,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              )),
          Divider(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.getW(24)),
            child: Text(
              "You're being timed out due to inactivity. Please choose to stay logged in or to logoff.",
              // LN.loginAc,
              style: TextStyle(
                fontSize: size.getS(20),
                fontFamily: kFontFRegular,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: size.getH(24),
          ),
          // AutofillGroup(
          //   child: Column(
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //       SizedBox(
          //         width: size.getW(400),
          //         child: TextFormWidget(
          //           cltr: authPro.emailCltr,
          //           hintText: LN.email,
          //           borderColor: Colors.black12,
          //           borderRadius: 5,
          //           vPad: 16,
          //           hPad: 16,
          //           textInputType: TextInputType.emailAddress,
          //           validator: emailValidator,
          //           autofillHints: const [AutofillHints.email],
          //         ),
          //       ),
          //       Padding(
          //         padding: EdgeInsets.only(top: size.getH(24)),
          //         child: SizedBox(
          //           width: size.getW(400),
          //           child: TextFormWidget(
          //             cltr: authPro.passCltr,
          //             hintText: LN.password,
          //             borderColor: Colors.black12,
          //             borderRadius: 5,
          //             vPad: 16,
          //             hPad: 16,
          //             textInputType: TextInputType.visiblePassword,
          //             validator: passwordValidator,
          //             autofillHints: const [AutofillHints.password],
          //             obsecure: !authPro.getShowPass,
          //             suffixIcon: InkWell(
          //               onTap: () {
          //                 authPro.setShowPass = !authPro.getShowPass;
          //               },
          //               child: Icon(
          //                 authPro.getShowPass
          //                     ? Icons.visibility
          //                     : Icons.visibility_off_outlined,
          //                 size: size.getS(24),
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          SizedBox(
            height: size.getH(36),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: size.getW(140),
                child: TextButton(
                  onPressed: () => onLogin(false),
                  style: ButtonStyle(
                      shape: WidgetStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: BorderSide(
                            color: Colors.black54,
                          ))),
                      padding: WidgetStateProperty.all(EdgeInsets.symmetric(
                        vertical: size.getH(size.isDesktop ? 16 : 12),
                      ))),
                  child: Text(
                    LN.logOut,
                    style: TextStyle(
                      fontSize: size.getS(20),
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              if (loading != null) ...[
                SizedBox(
                  width: size.getW(24),
                ),
                SizedBox(
                  width: size.getW(240),
                  child: ElevatedButton(
                    onPressed: () => onLogin(true),
                    style: ButtonStyle(
                        padding: WidgetStateProperty.all(EdgeInsets.symmetric(
                          vertical: size.getH(size.isDesktop ? 16 : 12),
                        )),
                        backgroundColor:
                            WidgetStateProperty.all(kSecondaryColor)),
                    child: loading!
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                LN.loading,
                                style: TextStyle(
                                  fontSize: size.getS(20),
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: size.getW(12),
                              ),
                              LoadingAnimationWidget.waveDots(
                                color: Colors.white,
                                size: size.getS(24),
                              ),
                            ],
                          )
                        : Text(
                            "Stay Logged In",
                            style: TextStyle(
                              fontSize: size.getS(20),
                              color: Colors.white,
                              fontFamily: kFontFMedium,
                            ),
                          ),
                  ),
                )
              ],
            ],
          ),
        ],
      ),
    );
  }
}
