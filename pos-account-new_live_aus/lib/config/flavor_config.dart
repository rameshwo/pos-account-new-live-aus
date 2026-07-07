/// Flavor-based configuration for different environments
/// This allows runtime configuration without rebuilding
enum AppFlavor { UAT, PROD }

class FlavorConfig {
  static late AppFlavor _currentFlavor;

  /// Get current app flavor
  static AppFlavor get currentFlavor => _currentFlavor;

  /// Initialize flavor with configuration
  static void setup(AppFlavor flavor) {
    _currentFlavor = flavor;
  }

  /// Get API configuration for current flavor
  static ApiConfig getApiConfig() => _configs[_currentFlavor]!;

  /// All flavor configurations
  static const Map<AppFlavor, ApiConfig> _configs = {
    AppFlavor.UAT: ApiConfig(
      name: 'UAT',
      title: 'POS UAT (Testing)',
      baseUrlPos: 'https://uathposapi.posapt.au/api/',
      baseUrlMenu: 'https://uatadminapi.posapt.au/api/',
      socketUrl: 'https://uatsocket.posapt.au',
      adminUrl: 'https://uatapp.posapt.au/',
      enableCrashlytics: false,
      debugMode: true,
    ),
    AppFlavor.PROD: ApiConfig(
      name: 'PROD',
      title: 'POS Production',
      baseUrlPos: 'https://hposapi.posapt.au/api/',
      baseUrlMenu: 'https://adminapi.posapt.au/api/',
      socketUrl: 'https://socket.posapt.au',
      adminUrl: 'https://app.posapt.au/',
      enableCrashlytics: true,
      debugMode: false,
    ),
  };
}

/// API configuration for a specific flavor
class ApiConfig {
  final String name;
  final String title;
  final String baseUrlPos;
  final String baseUrlMenu;
  final String socketUrl;
  final String adminUrl;
  final bool enableCrashlytics;
  final bool debugMode;

  const ApiConfig({
    required this.name,
    required this.title,
    required this.baseUrlPos,
    required this.baseUrlMenu,
    required this.socketUrl,
    required this.adminUrl,
    required this.enableCrashlytics,
    required this.debugMode,
  });
}
