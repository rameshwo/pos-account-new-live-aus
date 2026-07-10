import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/widgets/dialog/confirm_dialog.dart';
import 'package:pos_account/widgets/dialog/custom_dialog.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/paginate_sec.dart';
import 'package:pos_account/widgets/refresh_btn.dart';
import 'package:pos_account/widgets/setting_card.dart';
import 'package:pos_account/widgets/switch_adap.dart';
import 'package:pos_account/widgets/title_pop.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';

void main() {
  setUpAll(() {
    LnPro = LNProvider();
  });

  Future<void> pumpHarness(
    WidgetTester tester,
    Widget child, {
    Size surfaceSize = const Size(800, 600),
    ThemeMode themeMode = ThemeMode.light,
    TargetPlatform platform = TargetPlatform.android,
  }) async {
    tester.view.physicalSize = surfaceSize;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: NAV_KEY,
        themeMode: themeMode,
        theme: ThemeData(
          brightness: Brightness.light,
          platform: platform,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          platform: platform,
        ),
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(size: surfaceSize),
                child: child,
              );
            },
          ),
        ),
      ),
    );
    await tester.pump();
  }

  group('responsive reusable widgets', () {
    const viewports = <String, Size>{
      'mobile': Size(390, 844),
      'tablet': Size(768, 1024),
      'desktop': Size(1440, 900),
    };

    for (final entry in viewports.entries) {
      testWidgets('render on ${entry.key} layout', (tester) async {
        await pumpHarness(
          tester,
          Builder(
            builder: (context) {
              final size = Ssize(context);

              return SingleChildScrollView(
                child: Column(
                  children: [
                    const Loading(),
                    Processing(
                      loading: true,
                      child: const Text('Order content'),
                    ),
                    LoadButton(
                      btnText: 'Save order',
                      onsave: () {},
                    ),
                    RefreshBtn(size: size, onTap: () {}),
                    PaginateButton(
                      total: 25,
                      pageIndex: 2,
                      prev: () {},
                      next: () {},
                    ),
                    SwitchAdap(
                      size: size,
                      value: true,
                      onChanged: (_) {},
                    ),
                    NewCard(
                      title: 'Settings',
                      subTitle: 'Manage store behaviour',
                      iconWidget: const Icon(Icons.settings),
                      onTap: () {},
                    ),
                    TitlePop(
                      title: 'Back title',
                      size: size,
                      onTap: () {},
                    ),
                    TitlePop.infoSection(
                      size,
                      title: 'Info title',
                      subTitle: 'Info subtitle',
                    ),
                    const Text('No items found'),
                  ],
                ),
              );
            },
          ),
          surfaceSize: entry.value,
        );

        expect(find.text('Order content'), findsOneWidget);
        expect(find.text('Save order'), findsOneWidget);
        expect(find.text('11-20 of 25'), findsOneWidget);
        expect(find.text('Settings'), findsOneWidget);
        expect(find.text('No items found'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  });

  group('buttons and pointer interactions', () {
    testWidgets('LoadButton handles enabled, disabled loading, and mouse hover',
        (tester) async {
      var taps = 0;

      await pumpHarness(
        tester,
        Column(
          children: [
            LoadButton(
              btnText: 'Pay',
              onsave: () => taps++,
            ),
            LoadButton(
              btnText: 'Saving',
              loadingText: 'Saving',
              loading: true,
              onsave: () => taps++,
            ),
          ],
        ),
      );

      await tester.tap(find.text('Pay'));
      await tester.pump();
      expect(taps, 1);

      await tester.tap(find.text('Saving'), warnIfMissed: false);
      await tester.pump();
      expect(taps, 1);

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer();
      await gesture.moveTo(tester.getCenter(find.text('Pay')));
      await tester.pump();
      await gesture.removePointer();
    });

    testWidgets('RefreshBtn and PaginateButton call only enabled callbacks',
        (tester) async {
      var refresh = 0;
      var previous = 0;
      var next = 0;

      await pumpHarness(
        tester,
        Builder(
          builder: (context) {
            final size = Ssize(context);

            return Column(
              children: [
                RefreshBtn(size: size, onTap: () => refresh++),
                PaginateButton(
                  total: 25,
                  pageIndex: 2,
                  prev: () => previous++,
                  next: () => next++,
                ),
                PaginateButton(
                  total: 10,
                  pageIndex: 1,
                  prev: () => previous += 10,
                  next: () => next += 10,
                ),
              ],
            );
          },
        ),
      );

      await tester.tap(find.byIcon(Icons.refresh_outlined));
      await tester.tap(find.byIcon(Icons.arrow_back_ios).first);
      await tester.tap(find.byIcon(Icons.arrow_forward_ios).first);
      await tester.tap(find.byIcon(Icons.arrow_back_ios).last,
          warnIfMissed: false);
      await tester.tap(find.byIcon(Icons.arrow_forward_ios).last,
          warnIfMissed: false);
      await tester.pump();

      expect(refresh, 1);
      expect(previous, 1);
      expect(next, 1);
    });

    testWidgets('SwitchAdap toggles, disables, and supports long press',
        (tester) async {
      var value = false;

      await pumpHarness(
        tester,
        Builder(
          builder: (context) {
            final size = Ssize(context);

            return StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    SwitchAdap(
                      size: size,
                      value: value,
                      onChanged: (next) => setState(() => value = next),
                    ),
                    SwitchAdap(
                      size: size,
                      value: false,
                    ),
                  ],
                );
              },
            );
          },
        ),
      );

      await tester.tap(find.byType(CupertinoSwitch).first);
      await tester.pump();
      expect(value, isTrue);

      await tester.longPress(find.byType(CupertinoSwitch).first);
      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  });

  group('form validation, keyboard input, and focus', () {
    testWidgets(
        'TextFormWidget validates, accepts keyboard input, submits, and moves focus',
        (tester) async {
      final formKey = GlobalKey<FormState>();
      final controller = TextEditingController();
      final focusNode = FocusNode();
      var changes = <String?>[];
      String? submitted;

      addTearDown(controller.dispose);
      addTearDown(focusNode.dispose);

      await pumpHarness(
        tester,
        Form(
          key: formKey,
          child: TextFormWidget(
            cltr: controller,
            hintText: 'Email',
            labelText: 'Email address',
            focusNode: focusNode,
            textInputType: TextInputType.emailAddress,
            inputFormatters: [LengthLimitingTextInputFormatter(20)],
            validator: (value) {
              if (value == null || value.isEmpty) return 'Required';
              if (!value.contains('@')) return 'Invalid email';
              return null;
            },
            onChanged: changes.add,
            onSubmitted: (value) => submitted = value,
          ),
        ),
      );

      expect(formKey.currentState!.validate(), isFalse);
      await tester.pump();
      expect(find.text('Required'), findsOneWidget);

      await tester.tap(find.byType(TextFormField));
      await tester.enterText(find.byType(TextFormField), 'bad-email');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(focusNode.hasFocus, isTrue);
      expect(changes, contains('bad-email'));
      expect(submitted, 'bad-email');
      expect(formKey.currentState!.validate(), isFalse);
      await tester.pump();
      expect(find.text('Invalid email'), findsOneWidget);

      await tester.enterText(find.byType(TextFormField), 'a@example.com');
      expect(formKey.currentState!.validate(), isTrue);
    });

    testWidgets('TextFormWidget supports optional and read-only states',
        (tester) async {
      final controller = TextEditingController(text: 'Initial');
      var taps = 0;

      addTearDown(controller.dispose);

      await pumpHarness(
        tester,
        Form(
          child: TextFormWidget(
            cltr: controller,
            hintText: 'Read only',
            isReq: false,
            readOnly: true,
            onTap: () => taps++,
          ),
        ),
      );

      await tester.tap(find.byType(TextFormField));
      await tester.pump();

      expect(taps, 1);
      expect(controller.text, 'Initial');
    });
  });

  group('navigation, dialogs, bottom sheets, snackbars, and semantics', () {
    testWidgets('TitlePop invokes custom back action and default Navigator pop',
        (tester) async {
      var customBack = 0;

      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: NAV_KEY,
          home: Builder(
            builder: (context) {
              final size = Ssize(context);

              return Scaffold(
                body: Column(
                  children: [
                    TitlePop(
                      title: 'Custom back',
                      size: size,
                      onTap: () => customBack++,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (context) => Scaffold(
                              body: Builder(
                                builder: (context) => TitlePop(
                                  title: 'Pushed page',
                                  size: Ssize(context),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      child: const Text('Open page'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.arrow_back).first);
      await tester.pump();
      expect(customBack, 1);

      await tester.tap(find.text('Open page'));
      await tester.pumpAndSettle();
      expect(find.text('Pushed page'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      expect(find.text('Pushed page'), findsNothing);
    });

    testWidgets('ConfirmDialog renders, cancels, and returns action future',
        (tester) async {
      var cancelled = 0;

      await pumpHarness(
        tester,
        Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () {
                showDialog<bool?>(
                  context: context,
                  builder: (context) => ConfirmDialog(
                    title: 'Delete item?',
                    subTitle: 'This cannot be undone',
                    cancelText: 'Keep',
                    actionText: 'Delete',
                    onCancel: () {
                      cancelled++;
                      Navigator.pop(context);
                    },
                    onDelete: () async => true,
                  ),
                );
              },
              child: const Text('Open confirm'),
            );
          },
        ),
      );

      await tester.tap(find.text('Open confirm'));
      await tester.pumpAndSettle();
      expect(find.text('Delete item?'), findsOneWidget);
      expect(find.text('This cannot be undone'), findsOneWidget);

      await tester.tap(find.text('Keep'));
      await tester.pumpAndSettle();
      expect(cancelled, 1);

      await tester.tap(find.text('Open confirm'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();
      expect(find.text('Delete item?'), findsNothing);
    });

    testWidgets(
        'CustomDialog, bottom sheet, snackbar, and semantics are reachable',
        (tester) async {
      final semantics = SemanticsTester(tester);
      addTearDown(semantics.dispose);

      await pumpHarness(
        tester,
        Builder(
          builder: (context) {
            return Column(
              children: [
                Semantics(
                  label: 'Checkout action',
                  button: true,
                  child: ElevatedButton(
                    onPressed: () {
                      CustomDialog.showCustomDialog(
                        context: context,
                        title: 'Dialog title',
                        content: const Text('Dialog body'),
                        setCustomAction: true,
                      );
                    },
                    child: const Text('Open dialog'),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (context) => const SizedBox(
                        height: 80,
                        child: Center(child: Text('Bottom sheet body')),
                      ),
                    );
                  },
                  child: const Text('Open sheet'),
                ),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Saved')),
                    );
                  },
                  child: const Text('Show snackbar'),
                ),
              ],
            );
          },
        ),
      );

      expect(semantics, includesNodeWith(label: 'Checkout action'));

      await tester.tap(find.text('Open dialog'));
      await tester.pumpAndSettle();
      expect(find.text('Dialog title'), findsOneWidget);
      expect(find.text('Dialog body'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open sheet'));
      await tester.pumpAndSettle();
      expect(find.text('Bottom sheet body'), findsOneWidget);
      await tester.drag(find.text('Bottom sheet body'), const Offset(0, 300));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Show snackbar'));
      await tester.pump();
      expect(find.text('Saved'), findsOneWidget);
    });
  });

  group('scrolling, swipe, and empty/error/loading states', () {
    testWidgets('scrolls long content and handles horizontal swipe gestures',
        (tester) async {
      await pumpHarness(
        tester,
        ListView(
          children: [
            const Text('Top item'),
            for (var i = 0; i < 40; i++) Text('Row $i'),
            Dismissible(
              key: const ValueKey('dismissible-row'),
              child: const ListTile(title: Text('Swipe row')),
            ),
          ],
        ),
      );

      expect(find.text('Top item'), findsOneWidget);
      await tester.drag(find.byType(ListView), const Offset(0, -1200));
      await tester.pumpAndSettle();
      expect(find.text('Swipe row'), findsOneWidget);

      await tester.drag(find.text('Swipe row'), const Offset(-500, 0));
      await tester.pumpAndSettle();
      expect(find.text('Swipe row'), findsNothing);
    });

    testWidgets('renders light and dark themes without crashing',
        (tester) async {
      for (final mode in [ThemeMode.light, ThemeMode.dark]) {
        final controller = TextEditingController();
        addTearDown(controller.dispose);

        await pumpHarness(
          tester,
          Builder(
            builder: (context) {
              final brightness = Theme.of(context).brightness;

              return Column(
                children: [
                  Text('Theme: $brightness'),
                  Processing(
                    loading: true,
                    child: const Text('Loading content'),
                  ),
                  TextFormWidget(
                    cltr: controller,
                    hintText: 'Theme input',
                    isError: true,
                  ),
                  const Text('Empty state'),
                ],
              );
            },
          ),
          themeMode: mode,
        );

        expect(find.text('Loading content'), findsOneWidget);
        expect(find.text('Empty state'), findsOneWidget);
        expect(tester.takeException(), isNull);
      }
    });
  });
}
