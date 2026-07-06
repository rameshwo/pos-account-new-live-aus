import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';

class InfoMessageSec extends StatelessWidget {
  final String message;
  const InfoMessageSec({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return Container(
      decoration: BoxDecoration(
        color: kSecondaryColor.withAlpha(40),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: EdgeInsets.symmetric(
          vertical: size.getH(8), horizontal: size.getW(12)),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: size.getS(36),
            color: Colors.teal.shade700,
          ),
          SizedBox(
            width: size.getW(6),
          ),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: size.getS(16),
                color: Colors.teal.shade700,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
