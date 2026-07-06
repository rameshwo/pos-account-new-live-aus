import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/auth/auth_pro.dart';
import 'package:pos_account/screens/auth_screen/com/two_fa/com/google_tfa_ver.dart';
import 'package:pos_account/screens/auth_screen/com/two_fa/com/other_verify_sec.dart';

class Dia2faSec extends StatefulWidget {
  final AuthProvider authPro;
  final Function(bool)? closeDia;
  final Function()? onCancel;
  const Dia2faSec(
      {super.key, required this.authPro, this.closeDia, this.onCancel});

  @override
  State<Dia2faSec> createState() => _Dia2faSecState();
}

class _Dia2faSecState extends State<Dia2faSec>
    with SingleTickerProviderStateMixin {
  late AuthProvider authPro;

  final _tfaTabs = <String>[
    LN.google2faVer,
    LN.emailVer,
    LN.phoneVer,
  ];

  TabController? _tabCltr;

  @override
  void initState() {
    super.initState();
    authPro = widget.authPro;
    _tabCltr = TabController(length: _tfaTabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabCltr?.dispose();
    super.dispose();
  }

  Future<void> onTapOtp(String p0, {required bool isEmail}) async {
    if (authPro.loginRess == null || authPro.loginRess!.email == null) return;

    final status = await authPro.validateUser(
      userId: authPro.loginRess!.userId ?? '',
      otpCode: p0,
      isEmail: isEmail,
    );

    if (widget.closeDia != null) {
      if (status ?? false) {
        widget.closeDia!(true);
      } else {
        widget.closeDia!(false);
      }
    }
  }

  Future<void> sendOtpToEmail() async {
    await authPro.sendOtpToMail(email: authPro.emailCltr.text);
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return DefaultTabController(
      length: _tfaTabs.length,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: size.getH(12),
          ),
          Container(
            decoration: BoxDecoration(
              color: kTempColor,
            ),
            child: TabBar(
              tabAlignment: TabAlignment.start,
              indicatorWeight: 0,
              tabs: List.generate(
                  _tfaTabs.length,
                  (index) => Container(
                        decoration: BoxDecoration(
                          border: Border.symmetric(
                            vertical: BorderSide(
                              color: Colors.white,
                              width: 4,
                            ),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: size.getW(16),
                        ),
                        child: Tab(
                          height: size.getH(32),
                          iconMargin: EdgeInsets.zero,
                          child: Text(
                            _tfaTabs[index],
                          ),
                        ),
                      )),
              indicatorColor: Colors.transparent,
              labelColor: Colors.white,
              controller: _tabCltr,
              isScrollable: true,
              indicator: BoxDecoration(
                color: kPrimaryColor,
              ),
              labelStyle: TextStyle(
                fontSize: size.getS(20),
                fontFamily: kFontFMedium,
              ),
              labelPadding: EdgeInsets.zero,
              indicatorPadding: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              unselectedLabelColor: Colors.white,
            ),
          ),
          Flexible(
              child: TabBarView(controller: _tabCltr, children: [
            GoogleTFAVer(
              base64String: authPro.loginRess?.twoFaQrImage,
              showDes: false,
              onTapOtp: (String val) => onTapOtp(val, isEmail: false),
              onCancel: widget.onCancel,
              loading: authPro.loading,
            ),
            OtherVerifySec(
              showDes: false,
              title: LN.emailVer,
              textInputType: TextInputType.emailAddress,
              textCltr: authPro.emailCltr,
              hintTextField: LN.enterEmail,
              verify: sendOtpToEmail,
              otpMessage: LN.otpSentEmail,
              oTpValidate: (String val) => onTapOtp(val, isEmail: true),
              loading: authPro.loading,
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                LN.comingSoon,
                style: TextStyle(
                  fontSize: size.getS(24),
                  fontFamily: kFontFRegular,
                  color: Colors.black,
                ),
              ),
            )
          ]))
        ],
      ),
    );
  }
}
