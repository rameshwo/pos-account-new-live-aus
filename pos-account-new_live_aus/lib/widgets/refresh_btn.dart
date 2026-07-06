import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';

class RefreshBtn extends StatelessWidget {
  final Ssize size;
  final Function()? onTap;
  final Widget? icon;
  const RefreshBtn({
    super.key,
    required this.size,
    this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final iconn = icon ??
        Icon(
          Icons.refresh_outlined,
          color: Colors.white,
          size: size.getS(32),
        );
    return ElevatedButton(
      style: ButtonStyle(
          minimumSize: WidgetStateProperty.all(Size(0, 0)),
          shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100))),
          backgroundColor: WidgetStateProperty.all(
              onTap == null ? Colors.grey.shade400 : kSecondaryColor),
          padding: WidgetStateProperty.all(EdgeInsets.all(size.getS(8)))),
      onPressed: onTap,
      child: iconn,
    );
  }
}
