import 'package:flutter/material.dart';

// horizontal dash divider
class HDashDivider extends StatelessWidget {
  final double? dashWidth;
  final double? dashSpace;
  final double? strokeWidth;
  final Color? color;
  const HDashDivider({
    super.key,
    this.dashWidth,
    this.dashSpace,
    this.color,
    this.strokeWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomPaint(
            painter: _DashedLinePainter(
              dashSpace: dashSpace ?? 4,
              dashWidth: dashWidth ?? 3,
              strokeWidth: strokeWidth ?? 1,
              color: color ?? Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final double dashWidth;
  final double dashSpace;
  final double strokeWidth;
  final Color color;

  _DashedLinePainter({
    this.dashWidth = 3,
    this.dashSpace = 4,
    this.color = Colors.black,
    this.strokeWidth = 1,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double startX = 0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
