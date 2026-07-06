import 'package:pos_account/ln.dart';

class CreditCValidator {
  static String? validateCreditCaardNum(String val) {
    String input = val;
    String trimVal = input.replaceAll(' ', '');
    int sum = 0;
    bool alternate = true;
    for (int i = 0; i < trimVal.length; i++) {
      int digit = int.parse(trimVal.substring(i, i + 1));

      if (alternate) {
        digit *= 2;
        if (digit > 9) {
          digit -= 9;
        }
      }

      sum += digit;
      alternate = !alternate;
    }
    bool result = sum % 10 == 0;
    if (trimVal.isEmpty)
      return LN.ccNumEmpty;
    else if (trimVal.length < 16)
      return LN.invalidCcLen;
    else if (!result)
      return LN.invalidCc;
    else
      return null;
  }
}
