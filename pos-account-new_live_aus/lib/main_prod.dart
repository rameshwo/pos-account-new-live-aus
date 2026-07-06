import 'dart:async';
import 'package:flutter/material.dart';
import 'config/notification/notification_api.dart';
import 'env.dart';
import 'screens/initialize/init_app.dart';
import 'second_app/init_second_app.dart';
import 'services/crash_analytics.dart';

/// [main_prod] flutter run -t lib/main_prod.dart

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    PaintingBinding.instance.imageCache.maximumSize =
        100; // Set maximum cache size
    PaintingBinding.instance.imageCache.maximumSizeBytes =
        100 << 20; // Set maximum cache size in bytes
    AppEnviro.setupEnv(Enviroment.PROD);
    await NotificationApi.init();
    CrashAnalytics.init();

    runApp(const InitApp());
  }, CrashAnalytics.onError);
}

@pragma('vm:entry-point')
void secondaryDisplayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const InitSecondApp());
}
