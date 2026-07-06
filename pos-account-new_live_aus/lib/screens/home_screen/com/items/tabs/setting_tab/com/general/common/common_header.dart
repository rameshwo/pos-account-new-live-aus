import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';

class CommonHeader extends StatelessWidget {
  final Widget child;
  final double padding;
  const CommonHeader({super.key, required this.child, this.padding = 12});

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(padding: EdgeInsets.all(size.getW(padding)), child: child),
    );
  }
}
