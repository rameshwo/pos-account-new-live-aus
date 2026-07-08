import 'package:flutter_test/flutter_test.dart';
import 'package:pos_account/config/flavor_config.dart';

void main() {
  group('FlavorConfig Tests', () {
    setUp(() {
      FlavorConfig.setup(AppFlavor.UAT);
    });

    test('FlavorConfig.setup sets current flavor to UAT', () {
      FlavorConfig.setup(AppFlavor.UAT);
      expect(FlavorConfig.currentFlavor, AppFlavor.UAT);
    });

    test('FlavorConfig.setup sets current flavor to PROD', () {
      FlavorConfig.setup(AppFlavor.PROD);
      expect(FlavorConfig.currentFlavor, AppFlavor.PROD);
    });

    test('UAT API config has correct URLs', () {
      FlavorConfig.setup(AppFlavor.UAT);
      final config = FlavorConfig.getApiConfig();
      
      expect(config.name, 'UAT');
      expect(config.baseUrlPos, 'https://uathposapi.posapt.au/api/');
      expect(config.baseUrlMenu, 'https://uatadminapi.posapt.au/api/');
      expect(config.debugMode, true);
      expect(config.enableCrashlytics, false);
    });

    test('PROD API config has correct URLs', () {
      FlavorConfig.setup(AppFlavor.PROD);
      final config = FlavorConfig.getApiConfig();
      
      expect(config.name, 'PROD');
      expect(config.baseUrlPos, 'https://hposapi.posapt.au/api/');
      expect(config.baseUrlMenu, 'https://adminapi.posapt.au/api/');
      expect(config.debugMode, false);
      expect(config.enableCrashlytics, true);
    });

    test('API config contains all required fields', () {
      final config = FlavorConfig.getApiConfig();
      
      expect(config.name.isNotEmpty, true);
      expect(config.title.isNotEmpty, true);
      expect(config.baseUrlPos.isNotEmpty, true);
      expect(config.baseUrlMenu.isNotEmpty, true);
      expect(config.socketUrl.isNotEmpty, true);
      expect(config.adminUrl.isNotEmpty, true);
    });
  });
}
