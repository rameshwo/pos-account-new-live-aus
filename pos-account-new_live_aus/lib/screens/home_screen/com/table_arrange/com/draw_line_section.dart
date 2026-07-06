import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pos_account/model/home/setting/table_layout/layout_design_model.dart';

class DrawLineSection extends StatefulWidget {
  final Color? dotColor;
  final PData? pData;
  final double minLeft;
  final double minTop;
  final Offset? minOffset;
  final Offset? maxOffset;
  final Function(PData?)? removeLine;

  const DrawLineSection({
    super.key,
    this.pData,
    this.dotColor,
    this.minLeft = 0,
    this.minTop = 0.0,
    this.minOffset,
    this.maxOffset,
    this.removeLine,
  });

  @override
  State<DrawLineSection> createState() => _DrawLineSectionState();
}

class _DrawLineSectionState extends State<DrawLineSection> {
  var points = <Offset>[
    Offset(0, 25),
    Offset(200, 25),
  ];

  double left = 250;
  double top = 50;

  void load() {
    setState(() {});
  }

  onUpdate() {
    final pData = widget.pData ?? PData();

    pData.lineData ??= LineData();

    pData.lineData!.startPoint = [points.first.dx, points.first.dy];
    pData.lineData!.endPoint = [points.last.dx, points.last.dy];

    pData.top = top;
    pData.left = left;
  }

  @override
  void initState() {
    if (widget.pData?.lineData == null) return;
    final startPoint = Offset(widget.pData?.lineData?.startPoint?.first ?? 0,
        widget.pData?.lineData?.startPoint?.last ?? 25);
    final endPoint = Offset(widget.pData?.lineData?.endPoint?.first ?? 200,
        widget.pData?.lineData?.endPoint?.last ?? 25);
    points = [startPoint, endPoint];

    left = widget.pData?.left ?? left;
    top = widget.pData?.top ?? top;

    load();
    super.initState();
  }

  double calculateRotationAngle(Offset startPoint, Offset endPoint) {
    double deltaX = endPoint.dx - startPoint.dx;
    double deltaY = endPoint.dy - startPoint.dy;

    // Calculate the angle in radians using atan2
    double radians = atan2(deltaY, deltaX);

    return radians;
  }

  @override
  Widget build(BuildContext context) {
    final width = sqrt(pow((points.last.dy - points.first.dy), 2) +
        pow((points.last.dx - points.first.dx), 2));
    final angle = calculateRotationAngle(points.last, points.first);
    final left = points.last.dx;
    final top = points.last.dy;
    // final _coverOffset = Offset(points.last.dy > points.first.dy ? -15 : 15,
    //     points.last.dx > points.first.dx ? 15 : -15);
    // final _coverMargin =
    //     EdgeInsets.only(left: points.last.dx > points.first.dx ? 12.5 : 40);
    return Stack(
      children: [
        Positioned(
          left: left - widget.minLeft + left,
          top: top - widget.minTop + top,
          child: GestureDetector(
            onPanUpdate: (details) {
              // print('-------------');
              // left = left + details.delta.dx;
              // top = top + details.delta.dy;
              // load();
              // onUpdate();
            },
            child: Stack(
              children: [
                Container(
                  width: width,
                  height: 2,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.black, // Line color
                        width: widget.pData?.lineData?.strokeWidth ??
                            5, // Line width
                      ),
                    ),
                  ),
                  transform: Matrix4.rotationZ(angle),
                ),
                // Transform.translate(
                //   offset: _coverOffset,
                //   child: Container(
                //     margin: _coverMargin,
                //     width: _width - 50,
                //     height: 30,
                //     decoration: BoxDecoration(
                //       color: Colors.amber.withAlpha(110),
                //     ),
                //     transform: Matrix4.rotationZ(_angle),
                //     // child: Text(
                //     //   '------------------------------------------------------------------------',
                //     //   style: TextStyle(fontSize: 24, color: Colors.black),
                //     // ),
                //   ),
                // )
              ],
            ),
          ),
        ),
        // Positioned(
        //   left: left - widget.minLeft,
        //   top: top - widget.minTop,
        //   child: GestureDetector(
        //     // onPanUpdate: (details) {
        //     //   left = left + details.delta.dx;
        //     //   top = top + details.delta.dy;
        //     //   load();
        //     //   onUpdate();
        //     // },
        //     child: CustomPaint(
        //       painter: CustomLine(
        //         startPoint: points.first,
        //         endPoint: points.last,
        //         width: widget.strokWidth,
        //       ),
        //       child: ClipPath(
        //         child: Container(
        //           height: (points.last.dy - points.first.dy).abs() + 50,
        //           width: ((points.last.dx - points.first.dx).abs() - 50).abs(),
        //           margin: EdgeInsets.symmetric(horizontal: 25),
        //           // color: Colors.amber.withAlpha(60),
        //         ),
        //         // clipper:
        //         //     LineCustomClipper(start: points.first, end: points.last),
        //       ),
        //     ),
        //   ),
        // ),

        ...List<Positioned>.generate(
            points.length,
            (index) => Positioned(
                  left: left + points[index].dx - 25 - widget.minLeft,
                  top: top + points[index].dy - 25,
                  child: GestureDetector(
                      onPanUpdate: (details) {
                        points[index] = points[index] + details.delta;

                        final pointDx =
                            points[index].dx + left - widget.minLeft - 53;
                        final pointDy = points[index].dy - top + 47;

                        if (points[index].dx < -35) {
                          points[index] = Offset(-34, points[index].dy);
                        } else if (pointDx > widget.maxOffset!.dx) {
                          points[index] = Offset(
                              widget.maxOffset!.dx -
                                  (left - widget.minLeft - 53) -
                                  1,
                              points[index].dy);
                        }

                        if (points[index].dy < -27) {
                          points[index] = Offset(points[index].dx, -26);
                        } else if (pointDy > widget.maxOffset!.dy) {
                          points[index] = Offset(points[index].dx,
                              widget.maxOffset!.dy + (top - 47) - 1);
                        }

                        // print("${points[index].dx}, ${points[index].dy} ");

                        // print(
                        //     "${points[index].dx} <= ${widget.minOffset!.dx} && ${points[index].dy} <= ${widget.minOffset!.dy}");

                        load();
                        onUpdate();
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        color: index == 0
                            ? Colors.red.withAlpha(0)
                            : Colors.teal.withAlpha(0),
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          backgroundColor:
                              widget.dotColor ?? Colors.transparent,
                          radius: 7,
                        ),
                      )),
                )),
        if (widget.removeLine != null)
          ...List<Positioned>.generate(
            points.length,
            (index) {
              int selctedDot = points.first.dy < points.last.dy ? 0 : 1;
              return Positioned(
                  left: left +
                      points[index].dx -
                      widget.minLeft +
                      (points.first.dx > points.last.dx
                          ? (index == 0 ? 10 : -60)
                          : (index == 0 ? -60 : 10)),
                  top: top + points[index].dy - 25,
                  child: selctedDot == index
                      ? IconButton(
                          onPressed: () => widget.removeLine!(widget.pData),
                          icon: Icon(Icons.close))
                      : SizedBox.shrink());
            },
          )
      ],
    );
  }
}

class CustomLine extends CustomPainter {
  final Offset startPoint;
  final Offset endPoint;
  final Color lineColor;
  final double width;

  CustomLine({
    required this.startPoint,
    required this.endPoint,
    this.lineColor = Colors.black,
    this.width = 5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(startPoint, endPoint, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

// class CustomDots extends CustomPainter {
//   final Offset point;
//   final Color? dotColor;
//   final double width;

//   CustomDots({
//     required this.point,
//     this.dotColor,
//     this.width = 5,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     final dotPaint = Paint()
//       ..color = dotColor ?? Colors.transparent
//       ..style = PaintingStyle.fill
//       ..strokeWidth = width;

//     canvas.drawCircle(point, width * 1.5, dotPaint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }

class LineBorderClipper implements CustomClipper<Path> {
  final Offset start;
  final Offset end;

  LineBorderClipper({
    this.start = Offset.zero,
    this.end = Offset.zero,
  });

  @override
  void addListener(VoidCallback listener) {}

  @override
  Rect getApproximateClipRect(Size size) {
    return Rect.zero;
  }

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(start.dx + 12.5, start.dy - 25);
    path.lineTo(start.dx + 12.5, start.dy + 25);
    path.lineTo(end.dx - 12.5, end.dy + 25);
    path.lineTo(end.dx - 12.5, end.dy - 25);
    return path;
  }

  @override
  void removeListener(VoidCallback listener) {}

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
