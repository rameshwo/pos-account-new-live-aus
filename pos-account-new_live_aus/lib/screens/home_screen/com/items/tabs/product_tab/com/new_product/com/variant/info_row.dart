// Optional, if using SVG for icon

import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';

class InfoRowSec extends StatelessWidget {
  final String title;
  final String? subTitle;
  final IconData? iconData;

  const InfoRowSec(
      {super.key, required this.title, this.subTitle, this.iconData});

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return Padding(
      padding: EdgeInsets.only(top: size.getH(12), bottom: size.getH(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (iconData != null)
            Icon(iconData, // Icons.local_shipping_outlined,
                color: Colors.teal,
                size: size.getS(20)), // Or use your SVG icon
          SizedBox(width: size.getW(8)),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.black87,
                    ),
                children: [
                  TextSpan(
                    text: title,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: size.getS(20),
                    ),
                  ),
                  if (subTitle != null)
                    TextSpan(
                      text: subTitle,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.black87,
                        fontSize: size.getS(17),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
