import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';

class AgreementSec extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  final double fontSize;
  final Function(int)? onTap;
  const AgreementSec({
    super.key,
    required this.text,
    this.textAlign = TextAlign.start,
    this.fontSize = 12.8,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
            child: RichText(
                textAlign: textAlign,
                text: TextSpan(
                    text: '',
                    style: TextStyle(
                        letterSpacing: 0.3,
                        height: 1.5,
                        fontSize: size.getS(fontSize),
                        color: Colors.black),
                    children: List.generate(
                        text.split('*').length,
                        (index) => index % 2 == 0
                            ? TextSpan(
                                text: text.split('*')[index],
                                style: TextStyle(
                                  fontSize: size.getS(fontSize),
                                  color: Colors.black54,
                                ))
                            : TextSpan(
                                text: text.split('*')[index],
                                recognizer: TapGestureRecognizer()
                                  ..onTap = onTap == null
                                      ? null
                                      : () => onTap!(index),
                                style: TextStyle(
                                    fontSize: size.getS(fontSize),
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline))))))
      ],
    );
  }
}
