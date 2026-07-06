import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pos_account/constant/constant.dart';

class FrostedGlassBox extends StatelessWidget {
  const FrostedGlassBox({
    super.key,
    required this.theWidth,
    required this.theHeight,
    required this.child,
  });

  final double theWidth;
  final double theHeight;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: theWidth,
      height: theHeight,
      color: Colors.transparent,
      child: Stack(
        children: [
          //blur effect ==> the third layer of stack
          BackdropFilter(
            filter: ImageFilter.blur(
              //sigmaX is the Horizontal blur
              sigmaX: 5.0,
              //sigmaY is the Vertical blur
              sigmaY: 5.0,
            ),
            //we use this container to scale up the blur effect to fit its
            //  parent, without this container the blur effect doesn't appear.
            child: Container(),
          ),
          //gradient effect ==> the second layer of stack
          Container(
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(30),
              // border: Border.all(color: Colors.black.withAlpha(60)),
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    //begin color
                    kBackgroundColor.withAlpha(200),
                    //end color
                    kBackgroundColor.withAlpha(200),
                  ]),
            ),
          ),
          //child ==> the first/top layer of stack
          Center(child: child),
        ],
      ),
    );
  }
}
