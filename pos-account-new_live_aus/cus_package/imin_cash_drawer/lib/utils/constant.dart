/// This class contains constant values for method and event channel names.
///
/// These constants are used to facilitate communication between the Flutter
/// application and the native platform (e.g., Android) for the cash drawer.
class Constants {
  /// The name of the method channel for cash drawer operations.
  static const String methodChannel = 'com.printer/cashDrawer';

  /// The method name to retrieve the status of the cash drawer.
  static const String drawerStatus = 'drawerStatus';

  /// The method name to open the cash drawer.
  static const String openDrawer = 'openDrawer';
}
