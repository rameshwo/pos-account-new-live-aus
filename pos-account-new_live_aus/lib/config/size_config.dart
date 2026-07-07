import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

/// Simulator iPad Pro (12.9-inch) size
const double _tabLHeight = 1024.0;
const double _tabLWidth = 1366.0;
// ratio width/height = 1.33398 | root(w2+h2) = 1707.2

// try by calculating display area later

class Ssize {
  final BuildContext context;

  Ssize(this.context) {
    final mqData = MediaQuery.of(context);
    _newWidth = mqData.size.width;
    _newHeight = mqData.size.height;
    if (mqData.orientation == Orientation.landscape) {
      _oldHeight = _tabLHeight;
      _oldWidth = _tabLWidth;
    } else {
      _oldHeight = _tabLWidth;
      _oldWidth = _tabLHeight;
    }
  }
  late double _oldHeight;
  late double _oldWidth;

  late double _newWidth;
  late double _newHeight;

  double get width => _newWidth;
  double get height => _newHeight;

  double getH(double h) {
    return h * _getDiagonalRatio;
  }

  double getW(double w) {
    return w * _getDiagonalRatio;
  }

  double getS(double fs) {
    return fs * _getDiagonalRatio;
  }

  bool get isProt => MediaQuery.of(context).orientation == Orientation.portrait;

  bool get isDesktop => Platform.isMacOS || Platform.isWindows;

  double get _getDiagonalRatio {
    final oldDiagonal = sqrt(_oldWidth * _oldWidth + _oldHeight * _oldHeight);
    final newDiagonal = sqrt(_newWidth * _newWidth + _newHeight * _newHeight);
    return newDiagonal / oldDiagonal;
  }
}
