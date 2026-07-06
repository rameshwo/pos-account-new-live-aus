import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/widgets/switch_adap.dart';

class StatusSwitch extends StatelessWidget {
  const StatusSwitch({
    super.key,
    required this.title,
    required this.status,
    this.onChanged,
  });

  final String title;
  final bool status;
  final Function(bool)? onChanged;
  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: size.getS(16),
            fontFamily: kFontFRegular,
            color: Colors.black,
          ),
        ),
        SizedBox(
          width: size.getW(10),
        ),
        SwitchAdap(
          size: size,
          // value: pro.editData?.orderPrintAutomatically ?? false,
          value: status,
          activeColor: kSecondaryColor,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
