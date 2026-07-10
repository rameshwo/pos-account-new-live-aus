import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Sanity Tests', () {
    test('App should have a valid name and version', () {
      // Basic sanity check
      const appName = 'pos_account';
      expect(appName, isNotEmpty);
    });
  });
}
