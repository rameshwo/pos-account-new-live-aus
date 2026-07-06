import 'package:flutter/material.dart';
import 'package:pos_account/constant/constant.dart';

class MyThemes {
  static final darkTheme = ThemeData(
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        textStyle: WidgetStateProperty.all(
          const TextStyle(
            color: Colors.black,
            fontFamily: kFontFRegular,
          ),
        ),
      ),
    ),

    splashColor: Colors.transparent,
    fontFamily: kFontFRegular,
    scaffoldBackgroundColor: Colors.grey.shade900,
    // primaryColor: Colors.black,
    colorScheme: const ColorScheme.dark(
        // onSurface: Colors.red,
        ),
    // textTheme: TextTheme(
    //     bodyText1: TextStyle(color: Colors.red),
    //     bodyText2: TextStyle(color: Colors.blue)),
    // iconTheme: IconThemeData(color: Colors.purple.shade200),
  );
  static final lightTheme = ThemeData(
    splashColor: Colors.transparent,
    fontFamily: kFontFRegular,
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        textStyle: WidgetStateProperty.all(
          const TextStyle(
            color: Colors.black,
            fontFamily: kFontFRegular,
          ),
        ),
      ),
    ),
    dividerTheme: DividerThemeData(
      // space: 0.1,
      color: Colors.grey.shade400,
      thickness: 1,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    ),
    tabBarTheme: const TabBarThemeData(
      dividerColor: Colors.transparent,
    ),
    dataTableTheme: DataTableThemeData(
      dividerThickness: 0.1,
      dataTextStyle: const TextStyle(
        fontFamily: kFontFRegular,
        color: Colors.black,
      ),
      headingTextStyle: const TextStyle(
        fontFamily: kFontFRegular,
        color: Colors.black,
      ),
    ),
    // primaryColor: Colors.white,
    // primaryColorLight: Colors.green,
    scaffoldBackgroundColor: kBackgroundColor,
    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(backgroundColor: Colors.white),
    focusColor: kSecondaryColor.withOpacity(0.5),
    colorScheme: const ColorScheme.light(
      // onSurface: Colors.green,

      primary: kSecondaryColor,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontFamily: kFontFBold,
        color: Colors.black,
      ),
      displayMedium: TextStyle(
        fontFamily: kFontFBold,
        color: Colors.black,
      ),
      displaySmall: TextStyle(fontFamily: kFontFRegular, color: Colors.black),
      headlineMedium: TextStyle(
        fontFamily: kFontFRegular,
        color: Colors.black,
      ),
      headlineSmall: TextStyle(fontFamily: kFontFMedium, color: Colors.black),
      titleMedium: TextStyle(fontFamily: kFontFItalic, color: Colors.black),
      bodyLarge: TextStyle(
        color: Colors.black,
      ),
      bodyMedium: TextStyle(color: Colors.black),
    ),
    // iconTheme: IconThemeData(color: Colors.red.shade200),
  );
}
