import 'dart:io';
import 'dart:isolate';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:pos_account/repository/handler.dart';

class CrashAnalytics {
  static Future<void> init() async {
    if (kDebugMode) return;
    // Pass all uncaught "fatal" errors from the framework to Crashlytics
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    Isolate.current.addErrorListener(RawReceivePort((pair) {
      final errorAndStackTrack = pair as List<dynamic>;
      FirebaseCrashlytics.instance.recordError(errorAndStackTrack.first,
          StackTrace.fromString(errorAndStackTrack.last.toString()),
          fatal: true);
    }).sendPort);
  }

  static Future<void> onError(Object error, StackTrace stack) async {
    if (kDebugMode) return;

    try {
      final deviceId =
          SupportHandler.deviceId ?? await SupportHandler.getDeviceId;

      await FirebaseCrashlytics.instance.recordError(
        error,
        stack,
        reason:
            'app: POSApt-${Platform.isIOS ? 'IOS' : 'Android'}, deviceId: $deviceId, time: ${DateTime.now().toUtc()}',
        fatal: true,
      );
    } catch (e) {
      //
    }
  }
}
