import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/auth/auth_pro.dart';
import 'com/other_verify_sec.dart';

class TwoFaScreen extends StatefulWidget {
  final PageController pageCltr;
  final Ssize size;
  final AuthProvider authPro;
  const TwoFaScreen(
      {super.key,
      required this.pageCltr,
      required this.size,
      required this.authPro});

  @override
  State<TwoFaScreen> createState() => _TwoFaScreenState();
}

class _TwoFaScreenState extends State<TwoFaScreen>
    with SingleTickerProviderStateMixin {
  late AuthProvider authPro;

  final _tfaTabs = <String>[
    // LN.google2faVer,
    LN.emailVer,
    // LN.phoneVer,
  ];

  TabController? _tabCltr;

  @override
  void initState() {
    super.initState();
    authPro = widget.authPro;
    _tabCltr = TabController(length: _tfaTabs.length, vsync: this);
  }

  Future<void> onTapOtp(String p0, {required bool isEmail}) async {
    if (authPro.loginRess == null || authPro.loginRess!.email == null) return;

    await authPro.validateUser(
      userId: authPro.loginRess!.userId ?? '',
      otpCode: p0,
      isEmail: isEmail,
    );

    // if (authPro.validateRes != null) {
    //   if (authPro.validateRes!.isEmailConfirmed != null &&
    //       authPro.validateRes!.isEmailConfirmed!) {
    //     if (authPro.validateRes!.is2FaEnabled != null &&
    //         !authPro.validateRes!.is2FaEnabled!) {
    //       authPro.setAuthStatus = AuthStatus.AUTHENTICATE;
    //     } else {
    //       authPro.errorMessage = authPro.validateRes!.message;
    //       authPro.notify;
    //     }
    //   }
    // }
  }

  sendOtpToEmail() async {
    await authPro.sendOtpToMail(email: authPro.emailCltr.text);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
                onPressed: () {
                  widget.pageCltr.animateToPage(0,
                      duration: Duration(milliseconds: 400),
                      curve: Curves.easeInOut);
                },
                icon: Icon(
                  Icons.arrow_back,
                  size: widget.size.getS(25),
                )),
            Text(
              LN.back,
              style: TextStyle(
                fontSize: widget.size.getS(18),
                // fontFamily: ,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            )
          ],
        ),
        Flexible(
            child: DefaultTabController(
                length: _tfaTabs.length,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Container(
                      //   decoration: BoxDecoration(
                      //     color: kTempColor,
                      //   ),
                      //   child: TabBar(
                      //     indicatorWeight: 0,
                      //     tabs: List.generate(
                      //         _tfaTabs.length,
                      //         (index) => Container(
                      //               decoration: BoxDecoration(
                      //                 border: Border.symmetric(
                      //                   vertical: BorderSide(
                      //                     color: Colors.white,
                      //                     width: 2,
                      //                   ),
                      //                 ),
                      //               ),
                      //               padding: EdgeInsets.symmetric(
                      //                 horizontal: widget.size.getW(32),
                      //               ),
                      //               child: Tab(
                      //                 child: Text(
                      //                   _tfaTabs[index],
                      //                   style: TextStyle(
                      //                       fontSize: widget.size.getS(16)),
                      //                 ),
                      //                 iconMargin: EdgeInsets.zero,
                      //               ),
                      //             )),
                      //     indicatorColor: Colors.transparent,
                      //     labelColor: Colors.white,
                      //     controller: _tabCltr,
                      //     isScrollable: true,
                      //     indicator: BoxDecoration(
                      //       color: kPrimaryColor,
                      //     ),
                      //     labelStyle: TextStyle(
                      //       fontSize: widget.size.getS(18),
                      //       fontFamily: kFontFMedium,
                      //     ),
                      //     labelPadding: EdgeInsets.zero,
                      //     indicatorPadding: EdgeInsets.zero,
                      //     padding: EdgeInsets.zero,
                      //     unselectedLabelColor: Colors.white,
                      //   ),
                      // ),
                      Flexible(
                          child: TabBarView(controller: _tabCltr, children: [
                        // GoogleTFAVer(
                        //   base64String: authPro.loginRess?.twoFaQrImage,
                        //   onTapOtp: (String val) =>
                        //       onTapOtp(val, isEmail: false),
                        //   onCancel: () {
                        //     widget.pageCltr.animateToPage(0,
                        //         duration: Duration(milliseconds: 400),
                        //         curve: Curves.easeInOut);
                        //   },
                        //   loading: authPro.loading,
                        // ),
                        OtherVerifySec(
                          title: LN.emailVer,
                          textInputType: TextInputType.emailAddress,
                          textCltr: authPro.emailCltr,
                          hintTextField: LN.enterEmail,
                          verify: sendOtpToEmail,
                          otpMessage: LN.enter6digit,
                          oTpValidate: (String val) =>
                              onTapOtp(val, isEmail: true),
                          loading: authPro.loading,
                        ),
                        // Container(
                        //   alignment: Alignment.center,
                        //   child: Text(
                        //     LN.comingSoon,
                        //     style: TextStyle(
                        //       fontSize: widget.size.getS(24),
                        //       fontFamily: kFontFRegular,
                        //       color: Colors.black,
                        //     ),
                        //   ),
                        // )
                        // OtherVerifySec(
                        //   title: "Phone Verification",
                        //   textInputType: TextInputType.number,
                        //   textCltr: TextEditingController(),
                        //   hintTextField: "Enter your phone number",
                        //   verify: () {},
                        //   otpMessage: "OTP is sent to your phone number",
                        //   oTpValidate: (p0) {},
                        // ),
                      ]))
                    ],
                  ),
                )))
      ],
    );
  }
}
