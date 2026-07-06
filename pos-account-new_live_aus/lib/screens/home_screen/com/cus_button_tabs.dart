import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';

class CusButtonTabs extends StatelessWidget {
  final List<String> kTabs;
  final Ssize size;
  final int? selectedIndex;
  final Function(int)? onTap;
  final Color unSelectedColor;
  final Color selectedColor;
  final double selectedColorOpacity;
  final Color selectedTextColor;
  final Color unSelectedTextColor;
  final double fontSize;
  final Color? borderColor;

  const CusButtonTabs({
    super.key,
    required this.kTabs,
    required this.size,
    this.selectedIndex,
    this.onTap,
    this.unSelectedColor = kBackgroundColor,
    this.selectedColor = kUserColor,
    this.selectedColorOpacity = 0.15,
    this.selectedTextColor = Colors.black,
    this.unSelectedTextColor = Colors.black,
    this.fontSize = 16,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...List.generate(
            kTabs.length,
            (index) => AnimatedContainer(
                  duration: Duration(milliseconds: 350),
                  margin: EdgeInsets.only(right: size.getW(16)),
                  decoration: BoxDecoration(
                      border: Border.all(color: borderColor ?? selectedColor),
                      color: selectedIndex == index
                          ? selectedColor
                          : unSelectedColor,
                      borderRadius: BorderRadius.circular(5)),
                  child: InkWell(
                    onTap: onTap == null ? null : () => onTap!(index),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: size.getH(8), horizontal: size.getW(24)),
                      child: Text(
                        kTabs[index],
                        style: TextStyle(
                          color: selectedIndex == index
                              ? selectedTextColor
                              : unSelectedTextColor,
                          fontFamily: kFontFMedium,
                          fontSize: size.getS(fontSize),
                        ),
                      ),
                    ),
                  ),
                ))
      ],
    );
  }
}
