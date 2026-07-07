import 'dart:async';
import 'package:flutter/material.dart';
import 'config/notification/notification_api.dart';
import 'env.dart';
import 'screens/initialize/init_app.dart';
import 'second_app/init_second_app.dart';
import 'services/crash_analytics.dart';

/// [main_prod] flutter run -t lib/main_prod.dart

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    // Configure image cache: max 500 images, 500 MB total size
    PaintingBinding.instance.imageCache.maximumSize = 500;
    PaintingBinding.instance.imageCache.maximumSizeBytes = 500 << 20;

    AppEnvironment.setupEnv(Environment.PROD);
    await NotificationApi.init();
    await CrashAnalytics.init();

    runApp(const InitApp());
  }, CrashAnalytics.onError);
}

@pragma('vm:entry-point')
void secondaryDisplayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const InitSecondApp());
}
