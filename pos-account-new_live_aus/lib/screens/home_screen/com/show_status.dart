import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';

enum Status {
  Pending,
  Confirmed,
  Cancelled,
  Cancel,
  Delivered,
  Complete,
  onHold,
}

class ShowStatus extends StatelessWidget {
  final String title;
  final Ssize size;
  final double fontSize;
  const ShowStatus(
      {super.key, required this.title, required this.size, this.fontSize = 16});

  @override
  Widget build(BuildContext context) {
    Color? color;
    Color? backColor;
    final index = Status.values.indexWhere((e) => title.contains(e.name));
    if (index == 0) {
      color = Color(0xFF1A9AA5);
      backColor = Color(0xFF1A9AA5).withAlpha(60);
    } else if (index == 1) {
      color = Colors.teal.shade800;
      backColor = Colors.teal.withAlpha(60);
    } else if (index == 2 || index == 3) {
      color = Colors.red.shade800;
      backColor = Colors.red.withAlpha(60);
    } else if (index == 4 || index == 5) {
      color = Colors.green.shade800;
      backColor = Colors.green.withOpacity(0.2);
    } else if (index == 6) {
      color = Colors.amber.shade900;
      backColor = Colors.amber.withOpacity(0.15);
    } else {
      color = Colors.blue.shade800;
      backColor = Colors.blue.withAlpha(60);
    }

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: size.getW(fontSize > 14 ? 12 : 8),
          vertical: size.getH(4)),
      decoration: BoxDecoration(
        color: backColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: size.getS(fontSize),
          color: color,
          fontFamily: kFontFMedium,
        ),
      ),
    );
  }
}
