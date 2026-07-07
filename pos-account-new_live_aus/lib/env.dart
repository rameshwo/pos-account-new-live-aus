import 'package:pos_account/config/flavor_config.dart';

enum Environment { UAT, PROD }

abstract class AppEnvironment {
  static late String baseUrlPos;
  static late String baseUrlMenu;
  static late String adminUrl;
  static late String socketUrl;
  static late String title;
  static late Environment _environment;
  static late AppFlavor _flavor;

  static Environment get environment => _environment;
  static AppFlavor get flavor => _flavor;

  /// eftpos url
  static late String eftposPay;

  static void setupEnv(Environment env) {
    _environment = env;
    final appFlavor = env == Environment.UAT ? AppFlavor.UAT : AppFlavor.PROD;
    _flavor = appFlavor;
    
    // Initialize flavor configuration
    FlavorConfig.setup(appFlavor);
    final config = FlavorConfig.getApiConfig();
    
    // Set URLs from flavor configuration
    baseUrlPos = config.baseUrlPos;
    baseUrlMenu = config.baseUrlMenu;
    socketUrl = config.socketUrl;
    adminUrl = config.adminUrl;
    title = config.title;
  }
}
