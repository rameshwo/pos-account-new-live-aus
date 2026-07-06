import 'package:flutter/material.dart';

class SizeConfig {
  static final SizeConfig _instance = SizeConfig._internal();
  factory SizeConfig() => _instance;
  SizeConfig._internal();

  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;

  static late double _safeAreaHorizontal;
  static late double _safeAreaVertical;
  static late double safeBlockHorizontal;
  static late double safeBlockVertical;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;
  }

  static double getFontSize(double fontSize, {double? min, double? max}) {
    double scaledSize = fontSize * safeBlockHorizontal;
    if (min != null && scaledSize < min) {
      return min;
    }
    if (max != null && scaledSize > max) {
      return max;
    }
    return scaledSize;
  }

  static double getWidth(double width, {double? min, double? max}) {
    double scaledWidth = width * safeBlockHorizontal;
    if (min != null && scaledWidth < min) {
      return min;
    }
    if (max != null && scaledWidth > max) {
      return max;
    }
    return scaledWidth;
  }

  static double getHeight(double height, {double? min, double? max}) {
    double scaledHeight = height * safeBlockVertical;
    if (min != null && scaledHeight < min) {
      return min;
    }
    if (max != null && scaledHeight > max) {
      return max;
    }
    return scaledHeight;
  }

  static double getIconSize(double size, {double? min, double? max}) {
    double scaledSize = size * safeBlockHorizontal;
    if (min != null && scaledSize < min) {
      return min;
    }
    if (max != null && scaledSize > max) {
      return max;
    }
    return scaledSize;
  }

  static bool get isMobile => screenWidth < 600;
  static bool get isTablet => screenWidth >= 600 && screenWidth < 1200;
  static bool get isDesktop => screenWidth >= 1200;

  static double get tSmall => getFontSize(12, min: 10, max: 14);
  static double get tMedium => getFontSize(16, min: 14, max: 18);
  static double get tLarge => getFontSize(20, min: 18, max: 24);

  static double get tTitle => getFontSize(24, min: 20, max: 28);
  static double get tSubtitle => getFontSize(18, min: 16, max: 20);
  static double get tHeader => getFontSize(22, min: 20, max: 26);
  static double get tTab => getFontSize(14, min: 12, max: 16);

  static double get tButton => getFontSize(16, min: 14, max: 18);
  static double get tCaption => getFontSize(10, min: 8, max: 12);
  static double get tBody => getFontSize(14, min: 12, max: 16);
  static double get tBody2 => getFontSize(12, min: 10, max: 14);
  static double get vPadding => getHeight(10);
  static double get hPadding => getWidth(10);

  static double get vMargin => getHeight(10);
  static double get hMargin => getWidth(10);

  static double get vSmallPadding => getHeight(5);
  static double get hSmallPadding => getWidth(5);

  static double get vSmallMargin => getHeight(5);
  static double get hSmallMargin => getWidth(5);

  static double get vLargePadding => getHeight(20);
  static double get hLargePadding => getWidth(20);

  static double get vLargeMargin => getHeight(20);
  static double get hLargeMargin => getWidth(20);

  static double get vMediumPadding => getHeight(15);
  static double get hMediumPadding => getWidth(15);

  static double get vMediumMargin => getHeight(15);
  static double get hMediumMargin => getWidth(15);

  static double get smallIconSize => getIconSize(20);
  static double get mediumIconSize => getIconSize(25);
  static double get largeIconSize => getIconSize(30);

  static TextStyle get tHeadline => TextStyle(
        fontSize: tTitle,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get tSubHead => TextStyle(
        fontSize: tSubtitle,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get tBodyText1 => TextStyle(
        fontSize: tBody,
        fontWeight: FontWeight.normal,
      );

  static TextStyle get tBodyText2 => TextStyle(
        fontSize: tBody2,
        fontWeight: FontWeight.normal,
      );

  static TextStyle get tButtonStyle => TextStyle(
        fontSize: tButton,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get tCaptionStyle => TextStyle(
        fontSize: tCaption,
        fontWeight: FontWeight.normal,
      );

  static TextStyle get tTabStyle => TextStyle(
        fontSize: tTab,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get tSmallStyle => TextStyle(
        fontSize: tSmall,
        fontWeight: FontWeight.normal,
      );

  static TextStyle get tMediumStyle => TextStyle(
        fontSize: tMedium,
        fontWeight: FontWeight.normal,
      );

  static TextStyle get tLargeStyle => TextStyle(
        fontSize: tLarge,
        fontWeight: FontWeight.normal,
      );

  static TextStyle get tHeaderStyle => TextStyle(
        fontSize: tHeader,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get tTitleStyle => TextStyle(
        fontSize: tTitle,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get tSubtitleStyle => TextStyle(
        fontSize: tSubtitle,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get tBodyStyle => TextStyle(
        fontSize: tBody,
        fontWeight: FontWeight.normal,
      );
}
