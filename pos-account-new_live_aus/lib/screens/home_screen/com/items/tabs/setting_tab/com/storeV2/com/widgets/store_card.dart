import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';

class StoreCardUI extends StatelessWidget {
  final IconData? iconData;
  final String title;
  final Widget child;
  final List<Widget>? trail;
  const StoreCardUI({
    super.key,
    this.iconData,
    required this.title,
    required this.child,
    this.trail,
  });

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return Card(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: size.getH(16), horizontal: size.getW(24)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (iconData != null)
                    Padding(
                      padding: EdgeInsets.only(right: size.getW(8)),
                      child: Icon(
                        iconData,
                        size: size.getS(25),
                        color: kSecondaryColor,
                      ),
                    ),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: size.getS(18),
                      color: kSecondaryColor,
                      fontFamily: kFontFMedium,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (trail != null) ...trail!,
                ],
              ),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
