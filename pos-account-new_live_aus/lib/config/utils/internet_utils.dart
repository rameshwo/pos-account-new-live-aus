import 'dart:async';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pos_account/repository/if_exception.dart';

import '../../constant/constant.dart';

enum InternetStatus { Connect, Disconnect, Slow }

class InternetUtils {
  static final connectionChecker = InternetConnectionChecker.createInstance(
    slowConnectionConfig: SlowConnectionConfig(
      enableToCheckForSlowConnection: true,
      slowConnectionThreshold: const Duration(seconds: 3),
    ),
  );

  static StreamSubscription<InternetConnectionStatus>? stream;

  static InternetStatus? status;

  static Future<bool> get getInterNetStatus async {
    final bool isConnected = await connectionChecker.hasConnection;
    return isConnected;
  }

  static bool isInitApp = true;

  static void init({
    required Function(InternetStatus, bool) listen,
  }) {
    stream = connectionChecker.onStatusChange.listen(
      (InternetConnectionStatus status) {
        kPrint('--------------------internet status = ${status.name}');
        if (status == InternetConnectionStatus.slow) {
          listen(InternetStatus.Slow, isInitApp);
          if (!isInitApp) {
            IfException.showMessage(
                message: "Slow Internet Connection", isWarn: true);
          }
        } else if (status == InternetConnectionStatus.disconnected) {
          IfException.showMessage(message: "No Internet Connection");
          isInitApp = false;
          listen(InternetStatus.Disconnect, isInitApp);
        } else {
          listen(InternetStatus.Connect, isInitApp);
        }
        Future.delayed(Duration(seconds: 5), () {
          isInitApp = false;
        });
      },
    );
  }
}
