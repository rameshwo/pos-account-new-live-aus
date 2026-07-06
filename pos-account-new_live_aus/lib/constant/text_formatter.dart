import 'package:flutter/services.dart';

class Between0And100TextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Get the current text in the TextField
    final String newText = newValue.text;

    // Check if the new text is empty or "-" (allowing negative numbers)
    if (newText.isEmpty || newText == "-") {
      return newValue; // Allow empty or "-" input
    }

    // Try to parse the new text to a number
    final value = double.tryParse(newText);

    // Check if the parsed value is null (failed to parse)
    if (value == null) {
      return oldValue; // Reject the change if it's not a valid number
    }

    // Check if the value is between 0 and 100 (inclusive)
    if (value >= 0 && value <= 100) {
      return newValue; // Accept the change
    } else {
      return oldValue; // Reject the change if the value is outside the range
    }
  }
}

class NonNegativeTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Get the current text in the TextField
    final String newText = newValue.text;

    // Check if the new text is empty or "-" (allowing negative numbers)
    if (newText.isEmpty) {
      return newValue; // Allow empty or "-" input
    }

    // Try to parse the new text to a number
    final value = double.tryParse(newText);

    // Check if the parsed value is null (failed to parse)
    if (value == null) {
      return oldValue; // Reject the change if it's not a valid number
    }

    if (value >= 0) {
      return newValue; // Accept the change
    } else {
      return oldValue; // Reject the change if the value is outside the range
    }
  }
}
