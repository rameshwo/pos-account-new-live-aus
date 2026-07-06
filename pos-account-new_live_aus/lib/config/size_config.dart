import 'dart:io';
// import 'dart:math';

import 'package:flutter/material.dart';

/// Simulator iPad Pro (12.9-inch) size
const double _tabLHeight = 1024.0;
const double _tabLWidth = 1366.0;
// ratio width/height = 1.33398 | root(w2+h2) = 1707.2

/// iPad (9.7-INCH) size
// width: 1024.0 | height: 768.0
//ratio width/height = 1.3333  | root(w2+h2) = 1280

// try by calculating display area later

class Ssize {
  final BuildContext context;

  Ssize(this.context) {
    final mqData = MediaQuery.of(context);
    _newWidth = mqData.size.width;
    _newHeight = mqData.size.height;
    // _newWidth = 1366;
    // _newHeight = 1024;
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
    // return h * _newHeight / _oldHeight;
    return h * (_newWidth + _newHeight) / (_oldWidth + _oldHeight);
  }

  double getW(double w) {
    // return w * _newWidth / _oldWidth;
    return w * (_newWidth + _newHeight) / (_oldWidth + _oldHeight);
  }

  double getS(double fs) {
    // return fs * _getDRatio;
    // return fs * _newWidth / _oldWidth;
    return fs * (_newWidth + _newHeight) / (_oldWidth + _oldHeight);
  }

  bool get isProt => MediaQuery.of(context).orientation == Orientation.portrait;

  bool get isDesktop => Platform.isMacOS || Platform.isWindows;

  // double get _getDRatio {
  //   final _old = sqrt(pow(_oldWidth, 2) + pow(_oldHeight, 2));
  //   final _new = sqrt(pow(_newWidth, 2) + pow(_newHeight, 2));
  //   return _new / _old;
  // }
}
