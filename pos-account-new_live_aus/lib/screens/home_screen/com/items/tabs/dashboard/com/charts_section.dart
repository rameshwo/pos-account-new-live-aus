import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';

class ChartsSection extends StatelessWidget {
  final Ssize size;
  final String title;
  final Widget chart;
  final double width;
  final double height;
  const ChartsSection({
    super.key,
    required this.size,
    required this.title,
    required this.chart,
    this.width = 308,
    this.height = 324,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: SizedBox(
        width: size.getW(width),
        height: size.getH(height),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              size.getW(16), size.getH(16.0), size.getW(16), size.getH(12.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: size.getS(16),
                  fontFamily: kFontFMedium,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                ),
              ),
              Flexible(child: chart),
            ],
          ),
        ),
      ),
    );
  }
}
