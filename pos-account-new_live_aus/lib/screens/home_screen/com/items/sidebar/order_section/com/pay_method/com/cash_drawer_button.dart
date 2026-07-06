import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/providers/setting/pos_device/printer_setting_pro.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CashDrawerButton extends StatelessWidget {
  const CashDrawerButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final printSettingPro = Provider.of<PrinterSettingPro>(context);

    return Tooltip(
      message: "Open Cash Drawer",
      child: InkWell(
        onTap: printSettingPro.opencashDrawerLoad
            ? null
            : printSettingPro.openCashDrawer,
        borderRadius: BorderRadius.circular(100),
        child: CircleAvatar(
            radius: size.getS(24),
            backgroundColor: printSettingPro.opencashDrawerLoad
                ? Colors.grey
                : kSecondaryColor,
            child: Padding(
              padding: EdgeInsets.all(size.getS(8)),
              child: Icon(
                Icons.adf_scanner_rounded,
                size: size.getS(28),
                color: Colors.white,
              ),
            )),
      ),
    );

    // Row(
    //   mainAxisAlignment: MainAxisAlignment.end,
    //   children: [
    //     Container(
    //       margin: EdgeInsets.symmetric(
    //           vertical: size.getH(4), horizontal: size.getW(4)),
    //       decoration: BoxDecoration(
    //           borderRadius: BorderRadius.circular(5),
    //           border: Border.all(
    //             color: kTempColor,
    //           )),
    //       child: InkWell(
    //         onTap: _openCashDrawer,
    //         child: Padding(
    //           padding: EdgeInsets.symmetric(
    //               horizontal: size.getW(12), vertical: size.getH(4)),
    //           child: Text(
    //             "Open Cash Drawer",
    //             style: TextStyle(
    //               fontSize: size.getS(14),
    //               fontWeight: FontWeight.bold,
    //               color: kTempColor,
    //             ),
    //           ),
    //         ),
    //       ),
    //     ),
    //   ],
    // );
  }
}
