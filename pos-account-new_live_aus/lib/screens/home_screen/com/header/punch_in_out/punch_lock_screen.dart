import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/dashboard/punch_pro.dart';
import 'package:pos_account/widgets/pin_lock/pin_lock_sec.dart';
import 'package:pos_account/widgets/pin_lock/time_date_sec.dart';
import 'package:provider/provider.dart';
import 'com/start_shift_sec.dart';

class PunchLockScreen extends StatefulWidget {
  const PunchLockScreen({super.key});

  @override
  State<PunchLockScreen> createState() => _PunchLockScreenState();
}

class _PunchLockScreenState extends State<PunchLockScreen> {
  late PunchPro punchPro;

  final _pageCltr = PageController();

  @override
  void initState() {
    super.initState();
    punchPro = Provider.of<PunchPro>(context, listen: false);
  }

  @override
  void dispose() {
    punchPro.clearAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final punchPro = Provider.of<PunchPro>(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.getH(24)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: size.getW(32)),
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: kSecondaryColor, width: 1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: PageView(
                controller: _pageCltr,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  PinLockSection(
                    decoration: BoxDecoration(),
                    topWidget: Padding(
                      padding: EdgeInsets.only(top: size.getH(0)),
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                GlobalCVP.setMainPage = MainPage.HomePage;
                              },
                              icon: Icon(Icons.arrow_back)),
                          Expanded(
                            child: Text(
                              LN.enterEmpCode,
                              style: TextStyle(
                                color: kPrimaryColor,
                                fontFamily: kFontFMedium,
                                fontSize: size.getS(24),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(width: size.getW(36)),
                        ],
                      ),
                    ),
                    loading: punchPro.pageLoad,
                    validate: _validate,
                  ),
                  StartShiftSec(
                    punchPro: punchPro,
                    back: () => _gotoPage(0),
                  )
                ],
              ),
            ),
          ),
          SizedBox(width: size.getW(24)),
          Expanded(
            child:
                //  ShiftSec(
                //   punchPro: _punchPro,
                // ),
                //     StartShiftSec(
                //   punchPro: _punchPro,
                // ),
                TimeDateSec(
              showLogo: true,
              // background: Colors.transparent,
            ),
          ),
          SizedBox(width: size.getW(32)),
        ],
      ),
    );
  }

  void _gotoPage(int i) {
    _pageCltr.animateToPage(i,
        duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
  }

  Future<void> _validate(
      {required void Function() clear, required String pin}) async {
    final status = await punchPro.getEmployeeByCode(code: pin);

    if (status) {
      _gotoPage(1);
      // Navigator.pop(context, true);
      clear();
    } else {
      clear();
    }
  }
}
