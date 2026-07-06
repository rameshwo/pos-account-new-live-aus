import 'package:flutter/material.dart';

class VerticalStepper extends StatelessWidget {
  final List<StepTile> steps;
  final double dotGap;
  final Color inActiveColor;
  final Color activeColor;
  final bool reverse;

  const VerticalStepper({
    super.key,
    required this.steps,
    this.dotGap = 50,
    this.inActiveColor = Colors.grey,
    this.activeColor = Colors.green,
    this.reverse = false,
  });

  @override
  Widget build(BuildContext context) {
    final double height = (steps.length - 2) * dotGap;
    return Column(
      children: [
        if (reverse)
          Stack(
            children: [
              if (height > 0)
                Positioned(
                    height: height + 23,
                    left: 26,
                    top: dotGap + 16,
                    width: 2.5,
                    child: RotatedBox(
                        quarterTurns: 1,
                        child: LinearProgressIndicator(
                          color: inActiveColor,
                          value: 1,
                        ))),
              if (steps.length > 1)
                Positioned(
                    height: dotGap + 6,
                    left: 26,
                    top: 23,
                    width: 2.5,
                    child: RotatedBox(
                        quarterTurns: 1,
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: LinearProgressIndicator(
                            color: activeColor,
                            // value: _animation.value,
                          ),
                        ))),
              Column(
                children: [
                  for (int i = steps.length - 1; i >= 0; i--) steps[i]
                ],
              )
            ],
          )
        else
          Stack(
            children: [
              if (height > 0)
                Positioned(
                    height: height,
                    left: 26,
                    top: 23,
                    width: 2.5,
                    child: RotatedBox(
                        quarterTurns: 1,
                        child: LinearProgressIndicator(
                          color: inActiveColor,
                          value: 1,
                        ))),
              if (steps.length > 1)
                Positioned(
                    height: dotGap,
                    left: 26,
                    top: height + 23,
                    width: 2.5,
                    child: RotatedBox(
                        quarterTurns: 1,
                        child: LinearProgressIndicator(
                          color: activeColor,
                          // value: _animation.value,
                        ))),
              Column(
                children: [for (int i = 0; i < steps.length; i++) steps[i]],
              )
            ],
          ),
      ],
    );
  }
}

class StepTile extends StatelessWidget {
  final Widget title;
  final Widget? subTitle;
  final Widget? icon;
  final Color iconBackColor;
  final bool isActive;
  final double? height;

  const StepTile({
    super.key,
    required this.title,
    this.subTitle,
    this.iconBackColor = Colors.green,
    this.isActive = false,
    this.icon,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData().copyWith(dividerColor: Colors.transparent),
      child: Container(
        height: height,
        padding: height != null
            ? null
            : EdgeInsets.only(bottom: 16, top: isActive ? 0 : 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 12.5),
            // SizedBox(
            //   height: 28.5,
            //   width: 28.5,
            //   child: CircularProgressIndicator(
            //     value: isActive ? null : 1,
            //     color: iconBackColor,
            //   ),
            // ),
            Expanded(
              child: Container(
                padding: isActive ? EdgeInsets.all(1.5) : null,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: isActive
                      ? Border.all(color: iconBackColor, width: 2)
                      : null,
                ),
                child: Container(
                  margin: EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: iconBackColor,
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(4),
                  child: icon ??
                      Icon(
                        Icons.circle,
                        size: 15,
                        color: iconBackColor,
                      ),
                ),
              ),
            ),
            SizedBox(width: 11),
            Expanded(
              flex: 9,
              child: Padding(
                padding: EdgeInsets.only(top: 2.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    title,
                    if (subTitle != null) subTitle!,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
