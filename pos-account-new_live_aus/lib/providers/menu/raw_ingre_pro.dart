import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

class RawIngrePro extends ChangeNotifier {
  void get notify => notifyListeners();

  // double factor_1_2 = 1 / 1000;

  final minValueCltr = TextEditingController();

  final maxValueCltr = TextEditingController();

  final firstOptionData = [
    "100",
    "200",
    "300",
    "500",
    "600",
    "700",
    "800",
    "900",
  ];

  final secondOptionData = [
    "1",
    "2",
    "3",
    "5",
    "8",
    "10",
    "12",
    "15",
  ];

  void onChange({
    String? data,
    bool isFirstText = false,
    String? maxToMinConFactor,
  }) {
    if (maxToMinConFactor == null || maxToMinConFactor.isEmpty) {
      showToast("Measurement factor is empty");
      return;
    }
    double val = double.tryParse(data ?? '') ?? 0.0;

    double factor = double.tryParse(maxToMinConFactor) ?? 0.0;

    if (isFirstText) {
      maxValueCltr.text = (val / factor).toStringAsFixed(3);
    } else {
      minValueCltr.text = (val * factor).toStringAsFixed(0);
    }
    notify;
  }

  void clear() {
    minValueCltr.clear();
    maxValueCltr.clear();
  }
}
