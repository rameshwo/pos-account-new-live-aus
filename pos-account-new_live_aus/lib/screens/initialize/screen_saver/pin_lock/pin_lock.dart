import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/screen_saver/screen_saver_pro.dart';
import 'package:pos_account/widgets/pin_lock/pin_lock_sec.dart';
import 'package:pos_account/widgets/pin_lock/time_date_sec.dart';
import 'package:provider/provider.dart';

class PinLockScreen extends StatefulWidget {
  const PinLockScreen({super.key});

  static Future<dynamic> show() async {
    if (GlobalCVP.authorize == Authorize.No) return false;

    if (PinLockScreen.isOn) {
      return;
    }

    isOn = true;
    final ppo = await showDialog(
        context: CUS_CTX!,
        barrierDismissible: false,
        barrierColor: Colors.transparent,
        builder: (_) {
          return PinLockScreen();
        });
    isOn = false;
    return ppo;
  }

  static bool isOn = false;

  @override
  State<PinLockScreen> createState() => _PinLockScreenState();
}

class _PinLockScreenState extends State<PinLockScreen> {
  late ScreenSaverPro _screenSavPro;

  @override
  void initState() {
    final screenPro = Provider.of<ScreenSaverPro>(context, listen: false);
    screenPro.resetUser();
    super.initState();
  }

  @override
  void dispose() {
    _screenSavPro.pageLoad = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    _screenSavPro = Provider.of<ScreenSaverPro>(context);

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        extendBody: true,
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: size.getH(42)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: PinLockSection(
                  loading: _screenSavPro.pageLoad,
                  validate: _validate,
                ),
              ),
              SizedBox(width: size.getW(24)),
              Expanded(
                child: TimeDateSec(
                  showLogo: true,
                ),
              ),
              SizedBox(width: size.getW(32)),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _validate(
      {required void Function() clear, required String pin}) async {
    final status = await _screenSavPro.validatePinCode(pinCode: pin);
    if (status) {
      GlobalCVP.getAllUserPermission().then((value) => GlobalCVP.jumpToTab());
      Navigator.pop(context, true);
    } else {
      clear();
    }
  }
}
