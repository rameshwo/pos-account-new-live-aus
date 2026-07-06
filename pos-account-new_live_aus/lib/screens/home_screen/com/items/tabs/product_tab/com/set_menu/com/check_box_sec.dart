import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';

class CheckBoxSection extends StatelessWidget {
  final Ssize size;
  final bool checked;
  final Function(bool?)? onChanged;
  final String title;
  // final Color? fillColor;
  const CheckBoxSection({
    super.key,
    required this.size,
    this.checked = false,
    this.onChanged,
    required this.title,
    // this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: checked,
          activeColor: kPrimaryColor,
          checkColor: Colors.white,
          onChanged: onChanged,
          visualDensity: VisualDensity.compact,
          // fillColor: WidgetStateProperty.all(fillColor),
        ),
        Flexible(
          child: InkWell(
            onTap: onChanged == null ? null : () => onChanged!(!checked),
            child: Text(
              title,
              style: TextStyle(
                fontSize: size.getS(16),
                fontFamily: kFontFMedium,
                color: Colors.black,
              ),
              overflow: TextOverflow.visible,
            ),
          ),
        )
      ],
    );
  }
}
