import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';

enum DiaType {
  info,
  warning,
  error,
  success,
  noHeader,
}

class MsgDia {
  static Future<void> show(
    BuildContext? context, {
    DiaType diaType = DiaType.noHeader,
    bool headerAnimation = false,
    required String title,
    String? desc,
    Function()? onPop,
    Function()? onOkay,
    String? btnText,
    Color? btnOkColor,
    Function()? onCancel,
    String? cancelText,
    Color? btnCancelColor,
    int? autoHideSecond,
    bool dismissOnTouchOut = true,
    bool showCloseIcon = true,
    Widget? btnOK,
  }) async {
    if (context == null) return;

    // if (!context.findAncestorStateOfType()!.mounted) return;

    final size = Ssize(context);
    await AwesomeDialog(
      context: context,
      headerAnimationLoop: headerAnimation,
      autoHide:
          autoHideSecond == null ? null : Duration(seconds: autoHideSecond),
      dialogType: DialogType.values.firstWhere((e) => e.name == diaType.name),
      animType: AnimType.bottomSlide,
      padding: EdgeInsets.symmetric(horizontal: size.getW(16)),
      title: title,
      desc: desc,
      btnOkOnPress: onOkay,
      btnOkText: btnText,
      btnOkColor: btnOkColor,
      btnCancelOnPress: onCancel,
      btnCancelText: cancelText,
      btnCancelColor: btnCancelColor,
      buttonsBorderRadius: BorderRadius.circular(5),
      showCloseIcon: showCloseIcon,
      width: size.getW(700),
      titleTextStyle: TextStyle(fontSize: size.getS(24)),
      descTextStyle: TextStyle(fontSize: size.getS(20)),
      dismissOnTouchOutside: dismissOnTouchOut,
      onDismissCallback: (type) {
        if (onPop != null) onPop();
      },
      btnOk: btnOK,
    ).show();
  }
}
