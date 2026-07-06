import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:imin_cash_drawer/utils/constant.dart';

/// A class to interact with the IMIN cash drawer connected to an IMIN POS device.
///
/// This class provides methods to check the drawer status and to open the cash drawer.
class IminCashDrawer {
  // Define the method channel for communication with the platform.
  static const MethodChannel _channel = MethodChannel(Constants.methodChannel);

  /// Retrieves the status of the cash drawer.
  ///
  /// Returns a [Future] that resolves to the status of the drawer.
  /// Throws an [UnsupportedError] if the platform is not Android.
  static Future<dynamic> get drawerStatus async {
    if (Platform.isAndroid) {
      return await _channel.invokeMethod(Constants.drawerStatus);
    } else {
      throw UnsupportedError('This package only works on Android');
    }
  }

  /// Opens the cash drawer.
  ///
  /// Returns a [Future] that resolves to the result of the open drawer command.
  /// Throws an [UnsupportedError] if the platform is not Android.
  static Future<dynamic> get openDrawer {
    if (Platform.isAndroid) {
      return _channel.invokeMethod(Constants.openDrawer);
    } else {
      throw UnsupportedError('This package only works on Android');
    }
  }
}
