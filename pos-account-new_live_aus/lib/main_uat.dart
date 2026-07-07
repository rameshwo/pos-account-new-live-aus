import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pos_account/env.dart';
import 'package:pos_account/screens/initialize/init_app.dart';
import 'package:pos_account/services/crash_analytics.dart';
import 'package:pos_account/config/notification/notification_api.dart';
import 'package:pos_account/second_app/init_second_app.dart';

/// [main_uat] flutter run -t lib/main_uat.dart
Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    // Configure image cache: max 500 images, 500 MB total size
    PaintingBinding.instance.imageCache.maximumSize = 500;
    PaintingBinding.instance.imageCache.maximumSizeBytes = 500 << 20;

    AppEnvironment.setupEnv(Environment.UAT);
    await NotificationApi.init();
    await CrashAnalytics.init();

    runApp(const InitApp());
  }, CrashAnalytics.onError);

@pragma('vm:entry-point')
void secondaryDisplayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const InitSecondApp());
}
