import 'package:flutter/material.dart';

extension ColorExtension on Color {
  /// Convert the color to a darken color based on the [percent]
  // Color darken([int percent = 40]) {
  //   assert(1 <= percent && percent <= 100);
  //   final value = 1 - percent / 100;
  //   return Color.fromARGB(alpha, (red * value).round(), (green * value).round(),
  //       (blue * value).round());
  // }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final double fontSize;
  final Color textColor;

  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 18,
    this.fontSize = 16,
    this.textColor = const Color(0xff505050),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 2),
          width: size,
          height: size,
          decoration: BoxDecoration(
              shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
              color: color,
              borderRadius: BorderRadius.circular(5)),
        ),
        const SizedBox(
          width: 6,
        ),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
            maxLines: 2,
          ),
        )
      ],
    );
  }
}
