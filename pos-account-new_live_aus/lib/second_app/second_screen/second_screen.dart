import 'package:flutter/material.dart';
import 'package:pos_account/config/dual_display/dual_display_config.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/screens/initialize/screen_saver/screen_saver_screen.dart';
import 'package:pos_account/second_app/provider/second_screen_pro.dart';
import 'package:pos_account/second_app/second_screen/com/ad_section.dart';
import 'package:pos_account/second_app/second_screen/com/image_show_dia.dart';
import 'package:presentation_displays/secondary_display.dart';
// import 'package:presentation_displays/secondary_display.dart';
import 'com/item_view_section.dart';

/// UI of Presentation display
class SecondScreen extends StatefulWidget {
  static const String routeName = '/second-screen';
  const SecondScreen({super.key});

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  // SecondScreenPro? _sPro;

  final _sPro = SecondScreenPro();

  @override
  void initState() {
    try {
      // _sPro = Provider.of<SecondScreenPro>(context, listen: false);
      _sPro.scrollCltr = ScrollController();
    } catch (e) {
      // showToast("31: Something went wrong $e");
    }
    super.initState();
  }

  @override
  void dispose() {
    if (_sPro.scrollCltr != null) _sPro.scrollCltr!.dispose();
    super.dispose();
  }

  static bool _isShowQR = false;

  Future<void> callFunction() async {
    if (_sPro.cbm.qrImageUrl == null || _sPro.cbm.qrImageUrl!.isEmpty) {
      if (_isShowQR) {
        _isShowQR = false;
        Navigator.pop(context);
      }
      return;
    }

    //

    if (!_isShowQR) {
      _isShowQR = true;
      await ImageShowDia.showQRDia(
              ctx: context,
              image: _sPro.cbm.qrImageUrl ?? '',
              diaName: "Scan QR Code")
          .then((_) {
        _isShowQR = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      final size = Ssize(context);
      final secondPro = _sPro;
      // final _secondPro = Provider.of<SecondScreenPro>(context);

      // log("second_screen 42");
      return SecondaryDisplay(
        callback: (data) => secondPro.callback(
          data,
          load: () {
            if (mounted) setState(() {});
          },
        ).then((_) => callFunction()),
        child: secondPro.adsPattern?.pattern == null ||
                secondPro.adsPattern?.pattern == DualDisPattern.none ||
                (secondPro.adsPattern?.pattern == DualDisPattern.style4 &&
                    !secondPro.isThereItem)
            ? ScreenSaverScreen(
                isSecondScreen: true,
              )
            : Scaffold(
                body: SafeArea(
                  child: IgnorePointer(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (secondPro.isThereItem)
                          Expanded(
                            child: ItemViewSection(
                              size: size,
                              screenPro: secondPro,
                            ),
                          ),
                        Expanded(
                            child: AdSection(
                          adsPattern: secondPro.adsPattern,
                        )),
                      ],
                    ),
                  ),
                ),
              ),
      );
    } catch (e) {
      // showToast("79: Something went wrong $e");
      return ScreenSaverScreen(
          // screenImages: [],
          );
    }
  }
}
