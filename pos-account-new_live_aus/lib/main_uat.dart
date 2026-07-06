import 'package:flutter/material.dart';
import 'package:pos_account/env.dart';
import 'package:pos_account/screens/initialize/init_app.dart';
import 'package:pos_account/services/crash_analytics.dart';
import 'config/notification/notification_api.dart';
import 'second_app/init_second_app.dart';

/// [main_uat] flutter run -t lib/main_uat.dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PaintingBinding.instance.imageCache.maximumSize =
      100; // Set maximum cache size
  PaintingBinding.instance.imageCache.maximumSizeBytes =
      100 << 20; // Set maximum cache size in bytes

  AppEnviro.setupEnv(Enviroment.UAT);
  await NotificationApi.init();
  await CrashAnalytics.init();

  runApp(const InitApp());
}

@pragma('vm:entry-point')
void secondaryDisplayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const InitSecondApp());
}
//
