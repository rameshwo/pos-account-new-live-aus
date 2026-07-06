import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pos_account/config/utils/utils.dart';

const Color kPrimaryColor = Color(0xFF00205B);
const Color kSecondaryColor = Color(0xFF1A9AA5);
const Color kTempColor = Color(0xFFFF4D4F);
const Color kBackgroundColor = Color(0xfff1f7fd);
const Color kIconBackColor = Color(0xFFFCCCD9);
const Color kUserColor = Color(0xff25b893);
const Color kBtnColor = Color(0xff00BD78);

const String kFontFBold = "Poppins-Bold";
const String kFontFItalic = "Poppins-Italic";
const String kFontFMedium = "Poppins-Medium";
const String kFontFRegular = "Poppins-Regular";

const int kDuration = 250;

const int kFlexLeft = 3; // 2

const int kFlexMiddleProt = 17;

const int kFlexMiddleLand = 11;
const int kFlexRightLand = 6;

Color getCupertinoBackColor({
  required BuildContext context,
}) {
  return CupertinoDynamicColor.resolve(
      CupertinoDynamicColor.withBrightness(
        color: Color.fromARGB(204, 221, 220, 220),
        darkColor: Color.fromARGB(204, 26, 25, 25),
      ),
      context);
}

class TileColor {
  final Color? backColor;
  final Color? textColor;
  final Color? selectedBackColor;
  final Color? selectedTextColor;

  TileColor({
    this.backColor,
    this.textColor,
    this.selectedBackColor,
    this.selectedTextColor,
  });

  /// Default colors (customize as needed)
  static TileColor defaultColor() {
    return TileColor(
      backColor: kPrimaryColor,
      textColor: Colors.white,
      selectedBackColor: kSecondaryColor,
      selectedTextColor: Colors.white,
    );
  }

  static TileColor getColor({
    String? backColor,
    String? textColor,
    String? selectedBackColor,
    String? selectedTextColor,
  }) {
    Color? tryParse(String? hex) {
      try {
        if (hex == null || hex.isEmpty) return null;
        return Utils.colorFromHex(hex);
      } catch (e) {
        // Log the error if needed
        // print('Invalid color hex: $hex');
        return null;
      }
    }

    final _defaultColor = defaultColor();

    return TileColor(
      backColor: tryParse(backColor) ?? _defaultColor.backColor,
      textColor: tryParse(textColor) ?? _defaultColor.textColor,
      selectedBackColor:
          tryParse(selectedBackColor) ?? _defaultColor.selectedBackColor,
      selectedTextColor:
          tryParse(selectedTextColor) ?? _defaultColor.selectedTextColor,
    );
  }
}

void kPrint(dynamic message) {
  if (kDebugMode) print('\x1B[33m${message.toString()}\x1B[0m');
}
