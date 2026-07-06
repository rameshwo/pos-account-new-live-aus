import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';

class AddIconB extends StatelessWidget {
  const AddIconB({super.key, required this.size, this.onTap});
  final Ssize size;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    if (onTap == null)
      return SizedBox.shrink();
    else
      return InkWell(
        borderRadius: BorderRadius.circular(40),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: kSecondaryColor,
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: EdgeInsets.all(size.getW(8)),
            child: Text(
              '+',
              style: TextStyle(
                fontSize: size.getS(20),
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
  }
}
