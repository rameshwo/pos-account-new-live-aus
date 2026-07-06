import 'package:flutter/cupertino.dart';
import 'package:pos_account/config/size_config.dart';

class SwitchAdap extends StatelessWidget {
  final Ssize size;
  final bool value;
  final void Function(bool)? onChanged;
  final Color? activeColor;
  final Color? inactiveColor;
  final double height;

  const SwitchAdap({
    super.key,
    required this.size,
    required this.value,
    this.onChanged,
    this.activeColor,
    this.inactiveColor,
    this.height = 34,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.getS(height),
      child: FittedBox(
          child: CupertinoSwitch(
        value: value,
        activeTrackColor: activeColor,
        onChanged: onChanged,
        inactiveTrackColor: inactiveColor,
      )
          // Switch.adaptive(
          //   value: value,
          //   activeColor: activeColor,
          //   onChanged: onChanged,
          // ),
          ),
    );
  }
}
