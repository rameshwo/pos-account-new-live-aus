import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/model/home/setting/table_layout/layout_design_model.dart';
import 'package:pos_account/widgets/image/image_error.dart';
import 'dart:math' as math;
import '../../../../../ln.dart';

//resizable table
class ReSiTable extends StatelessWidget {
  final PData pData;
  final Function(double)? onSizeUpdate;
  final Function(double)? onRotUpdate;
  final String? tappedId;
  final List<String?>? mergeIds;
  const ReSiTable({
    super.key,
    required this.pData,
    this.onSizeUpdate,
    this.tappedId,
    this.onRotUpdate,
    this.mergeIds,
  });

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final double pSize = pData.size < 70
        ? 70
        : pData.size > 200
            ? 200
            : pData.size;

    final _mergeTableColor = pData.pElements.isNotEmpty &&
            (pData.pElements.first.mergeId?.isNotEmpty ?? false)
        ? getColorFromId(mergeIds, pData.pElements.first.mergeId!)
        : null;

    // kPrint("${pData.title} $_mergeTableColor");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              elevation: 10,
              shadowColor: _mergeTableColor != null
                  ? _mergeTableColor.withOpacity(0.2)
                  : Colors.black12,
              color: _mergeTableColor != null
                  ? _mergeTableColor.withOpacity(0.7)
                  : Colors.transparent,
              // color: Colors.teal.withOpacity(0.2),
              // shadowColor: Colors.tealAccent.withOpacity(0.8),
              shape: CircleBorder(),
              child: Padding(
                padding: _mergeTableColor == null
                    ? EdgeInsets.zero
                    : EdgeInsets.all(size.getS(24)),
                child: Transform.rotate(
                  angle: pData.angle * math.pi / 180,
                  child: pData.image != null
                      ? CachedNetworkImage(
                          imageUrl: pData.image!,
                          width: pSize,
                          height: pSize,
                          // fit: BoxFit.fitWidth,
                          // placeholder: ImageError.load,
                          placeholder: (_, __) => ImageError.table(pSize),
                          errorWidget: (ctx, _, __) => ImageError.table(pSize),
                        )
                      : null,
                ),
              ),
            ),
            if (tappedId == pData.id)
              SizedBox(
                height: size.getH(120),
                child: RotatedBox(
                  quarterTurns: 3,
                  child: Column(
                    children: [
                      Slider.adaptive(
                        value: pData.angle,
                        min: 0,
                        max: 180,
                        onChanged: onRotUpdate,
                        activeColor: kPrimaryColor,
                        inactiveColor: Colors.grey,
                      ),
                      Text(
                        LN.rotateTable,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: size.getS(16),
                        ),
                      )
                    ],
                  ),
                ),
              )
          ],
        ),
        if (tappedId == pData.id)
          SizedBox(
              width: size.getW(120),
              child: Column(
                children: [
                  Slider.adaptive(
                    value: pSize,
                    min: 70,
                    max: 200,
                    onChanged: onSizeUpdate,
                    activeColor: kPrimaryColor,
                    inactiveColor: Colors.grey,
                  ),
                  Text(
                    LN.resizeTable,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: size.getS(16),
                    ),
                  )
                ],
              ))
      ],
    );
  }

  // Color getColorFromId(String id) {
  //   int hash = 0;
  //   for (final codeUnit in id.codeUnits) {
  //     hash = 0x1fffffff & (hash + codeUnit);
  //     hash = 0x1fffffff & (hash + ((hash & 0x0007ffff) << 10));
  //     hash ^= (hash >> 6);
  //   }

  //   hash = 0x1fffffff & (hash + ((hash & 0x03ffffff) << 3));
  //   hash ^= (hash >> 11);
  //   hash = 0x1fffffff & (hash + ((hash & 0x00003fff) << 15));

  //   final index = hash % _colorList.length;
  //   return _colorList[index];
  // }
  Color? getColorFromId(List<String?>? mergeIds, String id) {
    final index =
        (mergeIds?.any((a) => a?.toLowerCase() == id.toLowerCase()) ?? false)
            ? mergeIds!.indexWhere((a) => a?.toLowerCase() == id.toLowerCase())
            : null;

    if (index == null) {
      return null;
    }

    // Option A: cycle through predefined colors (unique until colors run out)
    if (index < _colorList.length) {
      return _colorList[index];
    }

    // Option B: generate new colors dynamically if list is exceeded
    return _generateColor(index);
  }

  Color _generateColor(int index) {
    final hue = (index * 137.508) % 360; // golden angle
    return HSLColor.fromAHSL(
      1.0,
      hue,
      0.65,
      0.55,
    ).toColor();
  }

  // Color getColorFromId(String id) {
  //   final String str = id.toString();
  //   int hash = 0;

  //   for (int i = 0; i < str.length; i++) {
  //     hash = str.codeUnitAt(i) + ((hash << 5) - hash);
  //   }

  //   final int index = hash.abs() % _colorList.length;
  //   return _colorList[index];
  // }
}

final List<Color> _colorList = [
  Color(0xFFEF5350), // Red
  Color(0xFF5C6BC0), // Indigo
  Color(0xFF42A5F5), // Blue
  Color(0xFF26A69A), // Teal
  Color(0xFF66BB6A), // Green
  Color(0xFFFFEE58), // Yellow
  Color(0xFFFF7043), // Deep Orange
  Color(0xFF26A69A), // Teal (alt)
  Color(0xFF5C6BC0), // Indigo (alt)
  Color(0xFFEC407A), // Pink (alt)
];
