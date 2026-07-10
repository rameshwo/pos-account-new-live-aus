import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_account/screens/app_routes.dart';

void main() {
  testWidgets(
      'AppRoute renders fallback screen for unknown routes and navigates back',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        onGenerateRoute: AppRoute.onGenerateRoute,
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/missing-screen');
                  },
                  child: const Text('Open missing screen'),
                ),
              ),
            );
          },
        ),
      ),
    );

    expect(find.text('Open missing screen'), findsOneWidget);

    await tester.tap(find.text('Open missing screen'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Error'), findsOneWidget);

    await tester.pageBack();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Open missing screen'), findsOneWidget);
  });

  testWidgets('AppRoute fallback works in light and dark Material themes',
      (tester) async {
    for (final mode in [ThemeMode.light, ThemeMode.dark]) {
      await tester.pumpWidget(
        MaterialApp(
          themeMode: mode,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          onGenerateRoute: AppRoute.onGenerateRoute,
          initialRoute: '/missing-screen',
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Error'), findsOneWidget);
    }
  });
}
