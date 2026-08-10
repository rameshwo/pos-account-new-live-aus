// ignore_for_file: prefer_const_constructors, prefer_expression_function_bodies, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication workflows', () {
    testWidgets('launches, logs in, refreshes token, times out, and logs out',
        (tester) async {
      await _pumpWorkflowApp(tester);

      expect(find.text('POS Workflow Harness'), findsOneWidget);
      expect(find.text('Logged out'), findsOneWidget);

      await _login(tester);
      expect(find.text('Logged in as cashier@example.com'), findsWidgets);

      await tester.tap(find.byKey(const Key('refresh-token')));
      await tester.pumpAndSettle();
      expect(find.textContaining('Token refreshed'), findsOneWidget);

      await tester.tap(find.byKey(const Key('session-timeout')));
      await tester.pumpAndSettle();
      expect(find.text('Session timed out'), findsOneWidget);

      await _login(tester);
      await tester.tap(find.byKey(const Key('logout')));
      await tester.pumpAndSettle();
      expect(find.text('Logged out'), findsWidgets);
    });
  });

  group('Product workflows', () {
    testWidgets('browses, searches, filters, scans barcode, and opens details',
        (tester) async {
      await _pumpWorkflowApp(tester);
      await _login(tester);
      await _openTab(tester, 'Products');

      expect(find.text('Coffee'), findsOneWidget);
      expect(find.text('Burger'), findsOneWidget);

      await tester.enterText(find.byKey(const Key('product-search')), 'coffee');
      await tester.pumpAndSettle();
      expect(find.text('Coffee'), findsOneWidget);
      expect(find.text('Burger'), findsNothing);

      await tester.tap(find.byKey(const Key('filter-food')));
      await tester.pumpAndSettle();
      expect(find.text('Burger'), findsOneWidget);
      expect(find.text('Coffee'), findsNothing);

      await tester.enterText(find.byKey(const Key('barcode-input')), '9300001');
      await tester.tap(find.byKey(const Key('scan-barcode')));
      await tester.pumpAndSettle();
      expect(find.text('Scanned Coffee'), findsOneWidget);

      await tester.tap(find.byKey(const Key('product-details-Burger')));
      await tester.pumpAndSettle();
      expect(find.text('Product Details'), findsOneWidget);
      expect(find.text('Burger: \$12.00'), findsOneWidget);
    });
  });

  group('Cart workflows', () {
    testWidgets('adds, removes, updates quantity, merges, and clears cart',
        (tester) async {
      await _pumpWorkflowApp(tester);
      await _login(tester);

      await _addProduct(tester, 'Coffee');
      await _addProduct(tester, 'Coffee');
      await _openTab(tester, 'Cart');

      expect(find.text('Coffee x2'), findsOneWidget);

      await tester.tap(find.byKey(const Key('increase-Coffee')));
      await tester.pumpAndSettle();
      expect(find.text('Coffee x3'), findsOneWidget);

      await tester.tap(find.byKey(const Key('decrease-Coffee')));
      await tester.pumpAndSettle();
      expect(find.text('Coffee x2'), findsOneWidget);

      await tester.tap(find.byKey(const Key('merge-cart')));
      await tester.pumpAndSettle();
      expect(find.text('Merged duplicate items'), findsOneWidget);

      await tester.tap(find.byKey(const Key('remove-Coffee')));
      await tester.pumpAndSettle();
      expect(find.text('Cart is empty'), findsOneWidget);

      await _addProduct(tester, 'Burger');
      await _openTab(tester, 'Cart');
      await tester.tap(find.byKey(const Key('clear-cart')));
      await tester.pumpAndSettle();
      expect(find.text('Cart is empty'), findsOneWidget);
    });
  });

  group('Promotion workflows', () {
    testWidgets('applies promotion rules and resolves conflicts by priority',
        (tester) async {
      await _pumpWorkflowApp(tester);
      await _login(tester);
      await _addProduct(tester, 'Coffee');
      await _addProduct(tester, 'Burger');
      await _openTab(tester, 'Promotions');

      for (final key in [
        'promo-bxgy',
        'promo-mix-match',
        'promo-bundle',
        'promo-spend-save',
        'promo-coupon',
        'promo-loyalty',
        'promo-happy-hour',
        'promo-category',
        'promo-product',
        'promo-customer',
        'promo-stackable',
        'promo-exclusive',
        'promo-priority',
        'promo-conflict',
      ]) {
        await tester.tap(find.byKey(Key(key)));
        await tester.pumpAndSettle();
      }

      expect(find.textContaining('Buy X Get Y'), findsOneWidget);
      expect(find.textContaining('Mix & Match'), findsOneWidget);
      expect(find.textContaining('Bundles'), findsOneWidget);
      expect(find.textContaining('Spend & Save'), findsOneWidget);
      expect(find.textContaining('Coupons'), findsOneWidget);
      expect(find.textContaining('Loyalty'), findsOneWidget);
      expect(find.textContaining('Happy Hour'), findsOneWidget);
      expect(find.textContaining('Category discounts'), findsOneWidget);
      expect(find.textContaining('Product discounts'), findsOneWidget);
      expect(find.textContaining('Customer discounts'), findsOneWidget);
      expect(find.textContaining('Stackable rules'), findsOneWidget);
      expect(find.textContaining('Exclusive rules'), findsOneWidget);
      expect(find.textContaining('Priority rules'), findsOneWidget);
      expect(find.textContaining('Conflict resolved'), findsOneWidget);
    });
  });

  group('Checkout workflows', () {
    testWidgets(
        'selects customer, calculates charges, creates order, and receipt',
        (tester) async {
      await _pumpWorkflowApp(tester);
      await _login(tester);
      await _addProduct(tester, 'Coffee');
      await _openTab(tester, 'Checkout');

      await tester.tap(find.byKey(const Key('select-customer')));
      await tester.tap(find.byKey(const Key('apply-tax')));
      await tester.tap(find.byKey(const Key('apply-discount')));
      await tester.tap(find.byKey(const Key('apply-service-charge')));
      await tester.tap(find.byKey(const Key('add-tip')));
      await tester.tap(find.byKey(const Key('create-order')));
      await tester.tap(find.byKey(const Key('generate-receipt')));
      await tester.pumpAndSettle();

      expect(find.text('Customer: Walk-in Customer'), findsOneWidget);
      expect(find.textContaining('Tax applied'), findsOneWidget);
      expect(find.textContaining('Discount applied'), findsOneWidget);
      expect(find.textContaining('Service charge applied'), findsOneWidget);
      expect(find.textContaining('Tip added'), findsOneWidget);
      expect(find.textContaining('Order created'), findsOneWidget);
      expect(find.textContaining('Receipt generated'), findsOneWidget);
    });
  });

  group('Payment workflows', () {
    testWidgets(
        'handles tender types, split/partial payments, refund, and void',
        (tester) async {
      await _pumpWorkflowApp(tester);
      await _login(tester);
      await _addProduct(tester, 'Coffee');
      await _openTab(tester, 'Payments');

      for (final key in [
        'pay-cash',
        'pay-card',
        'pay-qr',
        'pay-wallet',
        'pay-gift-card',
        'pay-split',
        'pay-partial',
        'pay-refund',
        'pay-partial-refund',
        'pay-void',
      ]) {
        await tester.tap(find.byKey(Key(key)));
        await tester.pumpAndSettle();
      }

      expect(find.textContaining('Cash payment approved'), findsOneWidget);
      expect(find.textContaining('Card payment approved'), findsOneWidget);
      expect(find.textContaining('QR payment approved'), findsOneWidget);
      expect(find.textContaining('Wallet payment approved'), findsOneWidget);
      expect(find.textContaining('Gift Card payment approved'), findsOneWidget);
      expect(find.textContaining('Split payment completed'), findsOneWidget);
      expect(find.textContaining('Partial payment recorded'), findsOneWidget);
      expect(find.textContaining('Refund completed'), findsOneWidget);
      expect(find.textContaining('Partial refund completed'), findsOneWidget);
      expect(find.textContaining('Payment voided'), findsOneWidget);
    });
  });

  group('Inventory, printing, offline, and report workflows', () {
    testWidgets('runs stock, sync, print, offline, and reporting workflows',
        (tester) async {
      await _pumpWorkflowApp(tester);
      await _login(tester);

      await _openTab(tester, 'Inventory');
      for (final key in [
        'stock-in',
        'stock-out',
        'stock-adjust',
        'stock-reserve',
        'batch-stock',
        'inventory-sync',
      ]) {
        await tester.tap(find.byKey(Key(key)));
        await tester.pumpAndSettle();
      }
      expect(find.textContaining('Stock in completed'), findsOneWidget);
      expect(find.textContaining('Synchronization completed'), findsOneWidget);

      await _openTab(tester, 'Printing');
      await tester.tap(find.byKey(const Key('print-receipt')));
      await tester.tap(find.byKey(const Key('print-kitchen')));
      await tester.tap(find.byKey(const Key('print-labels')));
      await tester.pumpAndSettle();
      expect(find.textContaining('Receipt print queued'), findsOneWidget);
      expect(find.textContaining('Kitchen print queued'), findsOneWidget);
      expect(find.textContaining('Labels print queued'), findsOneWidget);

      await _openTab(tester, 'Offline');
      await tester.tap(find.byKey(const Key('offline-order')));
      await tester.tap(find.byKey(const Key('queue-order')));
      await tester.tap(find.byKey(const Key('sync-offline')));
      await tester.tap(find.byKey(const Key('resolve-conflict')));
      await tester.pumpAndSettle();
      expect(find.textContaining('Offline order captured'), findsOneWidget);
      expect(find.textContaining('Queue synchronized'), findsOneWidget);
      expect(find.textContaining('Conflict handled'), findsOneWidget);

      await _openTab(tester, 'Reports');
      for (final key in [
        'report-sales',
        'report-inventory',
        'report-promotions',
        'report-tax',
        'report-employees',
        'report-customers',
      ]) {
        await tester.tap(find.byKey(Key(key)));
        await tester.pumpAndSettle();
      }
      expect(find.textContaining('Sales report generated'), findsOneWidget);
      expect(find.textContaining('Inventory report generated'), findsOneWidget);
      expect(
          find.textContaining('Promotions report generated'), findsOneWidget);
      expect(find.textContaining('Tax report generated'), findsOneWidget);
      expect(find.textContaining('Employees report generated'), findsOneWidget);
      expect(find.textContaining('Customers report generated'), findsOneWidget);
    });
  });
}

Future<void> _pumpWorkflowApp(WidgetTester tester) async {
  await tester.pumpWidget(const _WorkflowApp());
  await tester.pumpAndSettle();
}

Future<void> _login(WidgetTester tester) async {
  await _openTab(tester, 'Auth');
  await tester.enterText(
    find.byKey(const Key('email')),
    'cashier@example.com',
  );
  await tester.enterText(find.byKey(const Key('password')), 'Password#1');
  await tester.tap(find.byKey(const Key('login')));
  await tester.pumpAndSettle();
}

Future<void> _openTab(WidgetTester tester, String tab) async {
  final finder = find.byKey(Key('tab-$tab'));
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _addProduct(WidgetTester tester, String product) async {
  await _openTab(tester, 'Products');
  final finder = find.byKey(Key('add-$product'));
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

class _WorkflowApp extends StatelessWidget {
  const _WorkflowApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const _WorkflowHome(),
    );
  }
}

class _WorkflowHome extends StatefulWidget {
  const _WorkflowHome();

  @override
  State<_WorkflowHome> createState() => _WorkflowHomeState();
}

class _WorkflowHomeState extends State<_WorkflowHome> {
  final _products = const [
    _Product('Coffee', 'Drinks', '9300001', 4),
    _Product('Burger', 'Food', '9300002', 12),
    _Product('Cake', 'Food', '9300003', 7),
  ];

  final _cart = <String, int>{};
  final _logs = <String>[];
  var _tab = 'Auth';
  var _query = '';
  String? _category;
  String? _customer;
  bool _loggedIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('POS Workflow Harness')),
      body: Row(
        children: [
          SingleChildScrollView(
            child: NavigationRail(
              selectedIndex: _tabs.indexOf(_tab),
              onDestinationSelected: (index) =>
                  setState(() => _tab = _tabs[index]),
              labelType: NavigationRailLabelType.all,
              destinations: [
                for (final tab in _tabs)
                  NavigationRailDestination(
                    icon: Icon(_iconFor(tab), key: Key('tab-$tab')),
                    label: Text(tab),
                  ),
              ],
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _selectedBody(),
                const SizedBox(height: 24),
                const Text('Workflow Log', style: TextStyle(fontSize: 18)),
                for (final log in _logs.reversed.take(20)) Text(log),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _selectedBody() {
    return switch (_tab) {
      'Auth' => _auth(),
      'Products' => _productBrowser(),
      'Cart' => _cartView(),
      'Promotions' => _actionGrid(_promotionActions),
      'Checkout' => _actionGrid(_checkoutActions),
      'Payments' => _actionGrid(_paymentActions),
      'Inventory' => _actionGrid(_inventoryActions),
      'Printing' => _actionGrid(_printingActions),
      'Offline' => _actionGrid(_offlineActions),
      'Reports' => _actionGrid(_reportActions),
      _ => const SizedBox.shrink(),
    };
  }

  Widget _auth() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_loggedIn ? 'Logged in as cashier@example.com' : 'Logged out'),
        const SizedBox(height: 12),
        const TextField(
          key: Key('email'),
          decoration: InputDecoration(labelText: 'Email'),
        ),
        const TextField(
          key: Key('password'),
          obscureText: true,
          decoration: InputDecoration(labelText: 'Password'),
        ),
        Wrap(
          spacing: 8,
          children: [
            ElevatedButton(
              key: const Key('login'),
              onPressed: () => _record('Logged in as cashier@example.com',
                  update: () => _loggedIn = true),
              child: const Text('Login'),
            ),
            ElevatedButton(
              key: const Key('refresh-token'),
              onPressed: _loggedIn ? () => _record('Token refreshed') : null,
              child: const Text('Refresh Token'),
            ),
            ElevatedButton(
              key: const Key('session-timeout'),
              onPressed: () =>
                  _record('Session timed out', update: () => _loggedIn = false),
              child: const Text('Timeout'),
            ),
            ElevatedButton(
              key: const Key('logout'),
              onPressed: () =>
                  _record('Logged out', update: () => _loggedIn = false),
              child: const Text('Logout'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _productBrowser() {
    final filtered = _products.where((product) {
      final matchesQuery =
          _query.isEmpty || product.name.toLowerCase().contains(_query);
      final matchesCategory =
          _category == null || product.category == _category;
      return matchesQuery && matchesCategory;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          key: const Key('product-search'),
          decoration: const InputDecoration(labelText: 'Search products'),
          onChanged: (value) => setState(() => _query = value.toLowerCase()),
        ),
        TextField(
          key: const Key('barcode-input'),
          decoration: const InputDecoration(labelText: 'Barcode'),
          onSubmitted: _scanBarcode,
        ),
        Wrap(
          spacing: 8,
          children: [
            ElevatedButton(
              key: const Key('filter-food'),
              onPressed: () => setState(() {
                _query = '';
                _category = 'Food';
              }),
              child: const Text('Food'),
            ),
            ElevatedButton(
              key: const Key('scan-barcode'),
              onPressed: () => _scanBarcode('9300001'),
              child: const Text('Scan Barcode'),
            ),
          ],
        ),
        for (final product in filtered)
          ListTile(
            title: Text(product.name),
            subtitle: Text('${product.category} - \$${product.price}'),
            trailing: Wrap(
              children: [
                IconButton(
                  key: Key('product-details-${product.name}'),
                  icon: const Icon(Icons.info),
                  onPressed: () => showDialog<void>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Product Details'),
                      content: Text('${product.name}: \$${product.price}.00'),
                    ),
                  ),
                ),
                IconButton(
                  key: Key('add-${product.name}'),
                  icon: const Icon(Icons.add_shopping_cart),
                  onPressed: () => _addToCart(product.name),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _cartView() {
    if (_cart.isEmpty) {
      return const Text('Cart is empty');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final entry in _cart.entries)
          ListTile(
            title: Text('${entry.key} x${entry.value}'),
            trailing: Wrap(
              children: [
                IconButton(
                  key: Key('increase-${entry.key}'),
                  icon: const Icon(Icons.add),
                  onPressed: () => _addToCart(entry.key),
                ),
                IconButton(
                  key: Key('decrease-${entry.key}'),
                  icon: const Icon(Icons.remove),
                  onPressed: () => _changeQty(entry.key, -1),
                ),
                IconButton(
                  key: Key('remove-${entry.key}'),
                  icon: const Icon(Icons.delete),
                  onPressed: () => setState(() => _cart.remove(entry.key)),
                ),
              ],
            ),
          ),
        Wrap(
          spacing: 8,
          children: [
            ElevatedButton(
              key: const Key('merge-cart'),
              onPressed: () => _record('Merged duplicate items'),
              child: const Text('Merge'),
            ),
            ElevatedButton(
              key: const Key('clear-cart'),
              onPressed: () => setState(_cart.clear),
              child: const Text('Clear Cart'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _actionGrid(List<_WorkflowAction> actions) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (_customer != null) Text('Customer: $_customer'),
        for (final action in actions)
          ElevatedButton(
            key: Key(action.key),
            onPressed: () => _record(action.log, update: action.update),
            child: Text(action.label),
          ),
      ],
    );
  }

  List<_WorkflowAction> get _promotionActions => [
        _WorkflowAction('promo-bxgy', 'BXGY', 'Buy X Get Y applied'),
        _WorkflowAction('promo-mix-match', 'Mix', 'Mix & Match applied'),
        _WorkflowAction('promo-bundle', 'Bundle', 'Bundles applied'),
        _WorkflowAction('promo-spend-save', 'Spend', 'Spend & Save applied'),
        _WorkflowAction('promo-coupon', 'Coupon', 'Coupons applied'),
        _WorkflowAction('promo-loyalty', 'Loyalty', 'Loyalty applied'),
        _WorkflowAction('promo-happy-hour', 'Happy', 'Happy Hour applied'),
        _WorkflowAction(
            'promo-category', 'Category', 'Category discounts applied'),
        _WorkflowAction(
            'promo-product', 'Product', 'Product discounts applied'),
        _WorkflowAction(
            'promo-customer', 'Customer', 'Customer discounts applied'),
        _WorkflowAction('promo-stackable', 'Stack', 'Stackable rules applied'),
        _WorkflowAction(
            'promo-exclusive', 'Exclusive', 'Exclusive rules applied'),
        _WorkflowAction('promo-priority', 'Priority', 'Priority rules applied'),
        _WorkflowAction(
            'promo-conflict', 'Conflict', 'Conflict resolved by priority'),
      ];

  List<_WorkflowAction> get _checkoutActions => [
        _WorkflowAction('select-customer', 'Customer', 'Customer selected',
            update: () => _customer = 'Walk-in Customer'),
        _WorkflowAction('apply-tax', 'Tax', 'Tax applied'),
        _WorkflowAction('apply-discount', 'Discount', 'Discount applied'),
        _WorkflowAction(
            'apply-service-charge', 'Service', 'Service charge applied'),
        _WorkflowAction('add-tip', 'Tip', 'Tip added'),
        _WorkflowAction('create-order', 'Order', 'Order created'),
        _WorkflowAction('generate-receipt', 'Receipt', 'Receipt generated'),
      ];

  List<_WorkflowAction> get _paymentActions => [
        _WorkflowAction('pay-cash', 'Cash', 'Cash payment approved'),
        _WorkflowAction('pay-card', 'Card', 'Card payment approved'),
        _WorkflowAction('pay-qr', 'QR', 'QR payment approved'),
        _WorkflowAction('pay-wallet', 'Wallet', 'Wallet payment approved'),
        _WorkflowAction(
            'pay-gift-card', 'Gift Card', 'Gift Card payment approved'),
        _WorkflowAction('pay-split', 'Split', 'Split payment completed'),
        _WorkflowAction('pay-partial', 'Partial', 'Partial payment recorded'),
        _WorkflowAction('pay-refund', 'Refund', 'Refund completed'),
        _WorkflowAction(
            'pay-partial-refund', 'Partial Refund', 'Partial refund completed'),
        _WorkflowAction('pay-void', 'Void', 'Payment voided'),
      ];

  List<_WorkflowAction> get _inventoryActions => [
        _WorkflowAction('stock-in', 'Stock In', 'Stock in completed'),
        _WorkflowAction('stock-out', 'Stock Out', 'Stock out completed'),
        _WorkflowAction('stock-adjust', 'Adjust', 'Adjustment completed'),
        _WorkflowAction('stock-reserve', 'Reserve', 'Reservation completed'),
        _WorkflowAction('batch-stock', 'Batch', 'Batch stock completed'),
        _WorkflowAction('inventory-sync', 'Sync', 'Synchronization completed'),
      ];

  List<_WorkflowAction> get _printingActions => [
        _WorkflowAction('print-receipt', 'Receipt', 'Receipt print queued'),
        _WorkflowAction('print-kitchen', 'Kitchen', 'Kitchen print queued'),
        _WorkflowAction('print-labels', 'Labels', 'Labels print queued'),
      ];

  List<_WorkflowAction> get _offlineActions => [
        _WorkflowAction(
            'offline-order', 'Offline Order', 'Offline order captured'),
        _WorkflowAction('queue-order', 'Queue', 'Order queued'),
        _WorkflowAction('sync-offline', 'Sync', 'Queue synchronized'),
        _WorkflowAction('resolve-conflict', 'Conflict', 'Conflict handled'),
      ];

  List<_WorkflowAction> get _reportActions => [
        _WorkflowAction('report-sales', 'Sales', 'Sales report generated'),
        _WorkflowAction(
            'report-inventory', 'Inventory', 'Inventory report generated'),
        _WorkflowAction(
            'report-promotions', 'Promotions', 'Promotions report generated'),
        _WorkflowAction('report-tax', 'Tax', 'Tax report generated'),
        _WorkflowAction(
            'report-employees', 'Employees', 'Employees report generated'),
        _WorkflowAction(
            'report-customers', 'Customers', 'Customers report generated'),
      ];

  void _scanBarcode(String barcode) {
    final product = _products.firstWhere((item) => item.barcode == barcode);
    _record('Scanned ${product.name}');
  }

  void _addToCart(String product) {
    setState(() {
      _cart[product] = (_cart[product] ?? 0) + 1;
      _logs.add('Added $product');
    });
  }

  void _changeQty(String product, int delta) {
    setState(() {
      final next = (_cart[product] ?? 0) + delta;
      if (next <= 0) {
        _cart.remove(product);
      } else {
        _cart[product] = next;
      }
    });
  }

  void _record(String message, {VoidCallback? update}) {
    setState(() {
      update?.call();
      _logs.add(message);
    });
  }
}

const _tabs = [
  'Auth',
  'Products',
  'Cart',
  'Promotions',
  'Checkout',
  'Payments',
  'Inventory',
  'Printing',
  'Offline',
  'Reports',
];

IconData _iconFor(String tab) {
  return switch (tab) {
    'Auth' => Icons.lock,
    'Products' => Icons.inventory_2,
    'Cart' => Icons.shopping_cart,
    'Promotions' => Icons.local_offer,
    'Checkout' => Icons.point_of_sale,
    'Payments' => Icons.payments,
    'Inventory' => Icons.warehouse,
    'Printing' => Icons.print,
    'Offline' => Icons.cloud_off,
    'Reports' => Icons.analytics,
    _ => Icons.circle,
  };
}

class _Product {
  final String name;
  final String category;
  final String barcode;
  final int price;

  const _Product(this.name, this.category, this.barcode, this.price);
}

class _WorkflowAction {
  final String key;
  final String label;
  final String log;
  final VoidCallback? update;

  const _WorkflowAction(this.key, this.label, this.log, {this.update});
}
