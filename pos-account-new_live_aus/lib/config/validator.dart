import 'package:pos_account/ln.dart';
import 'dart:math';

final RegExp _regexEmail =
    RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$');
final RegExp _regexPassword =
    RegExp(r'^.*(?=.{8,})(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=£*_#]).*$');

String? passwordValidator(String? val) {
  if (val!.isEmpty)
    return LN.passwordNotEmpty;
  // else if (val.length < 6)
  //   return 'Password must be at least 8 characters';
  else if (!_regexPassword.hasMatch(val))
    return LN.passwordMustContain;
  else
    return null;
}

String? confirmPasswordValidator(String? val1, String val2) {
  if (val1!.isEmpty)
    return LN.passwordNotEmpty;
  else if (val1.length < 6)
    return LN.passwordMustAtleast;
  else if (val1 != val2)
    return LN.passwordDoesNtMatch;
  else
    return null;
}

String? emailValidator(String? val) {
  if (val!.isEmpty)
    return LN.emailNotEmpty;
  else if (!_regexEmail.hasMatch(val))
    return LN.invalidEmail;
  else
    return null;
}

extension DoubleExtension on double {
  double nonNan() {
    return isNaN ? 0.0 : this;
  }

  // double roundToN({int n = 2}) {
  //   if (this == 0 || isNaN) return 0;
  //   // final ten = pow(10, n);
  //   return double.parse(toStringAsFixed(n));
  // }

  // String toStringRound(int n) {
  //   if (this == 0 || isNaN) return "0";
  //   final ten = pow(10, n);
  //   return ((this * ten).round() / ten).toString();
  // }
}

extension StringExtension on String? {
  String negPrice() {
    if (this == null)
      return '';
    else if (this!.contains('-')) {
      final negCount = this!.split('-').length - 1;
      final val = this!.replaceAll('-', '');
      if (negCount > 1)
        return val;
      else
        return '-$val';
    } else
      return this!;
  }
}

extension StringToDouble on String? {
  double get inDouble {
    return double.tryParse(this ?? '') ?? 0;
  }

  String formatNumber(double value) {
    return value
        .roundToNString()
        .replaceAll(RegExp(r'0+$'), '')
        .replaceAll(RegExp(r'\.$'), '');
  }

  bool get noNullorEmpty {
    return this != null && this!.isNotEmpty;
  }
}

extension DoubleToString on double? {
  String get formatDouble {
    return (this ?? 0.0)
        .roundToN()
        .toString()
        .replaceAll(RegExp(r'0+$'), '')
        .replaceAll(RegExp(r'\.$'), '');
  }

  String formatDoubleN({int digit = 2}) {
    return (this ?? 0.0)
        .roundToN(n: digit)
        .toString()
        .replaceAll(RegExp(r'0+$'), '')
        .replaceAll(RegExp(r'\.$'), '');
  }

  double roundToN({int n = 2}) {
    final value = this;
    if (value == null || value.isNaN || value.isInfinite) return 0.0;

    final mod = pow(10.0, n);
    return (((this ?? 0) * mod).round().toDouble() / mod);
  }

  String roundToNString({int n = 2}) {
    final value = this;
    if (value == null || value.isNaN || value.isInfinite) return '0.00';

    final mod = pow(10.0, n);

    final rounded = (((this ?? 0) * mod).round().toDouble() / mod);
    return rounded.toStringAsFixed(n);
  }

  int get formatInt {
    return (this ?? 0.0).formatDoubleN().inDouble.floor();
  }
}

extension StringExten on String? {
  bool get hasAmount {
    return this != null &&
        this!.isNotEmpty &&
        double.tryParse(this!) != null &&
        double.tryParse(this!) != 0;
  }
}

extension StringInt on String? {
  String get inQty {
    final val = double.tryParse(this ?? '') ?? 0.0;
    if (val == 0 || val % val.round() == 0) return val.round().toString();
    return this ?? '';
  }
}


// import 'package:pos_account/config/validator.dart';