import 'package:flutter_test/flutter_test.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_memory.dart';

void main() {
  late Database db;
  late StoreRef<int, Map<String, Object?>> products;
  late StoreRef<int, Map<String, Object?>> categories;
  late StoreRef<int, Map<String, Object?>> orders;
  late StoreRef<int, Map<String, Object?>> orderItems;
  late StoreRef<String, Map<String, Object?>> migrations;

  setUp(() async {
    db = await databaseFactoryMemory.openDatabase('pos-test.db');
    products = intMapStoreFactory.store('products');
    categories = intMapStoreFactory.store('categories');
    orders = intMapStoreFactory.store('orders');
    orderItems = intMapStoreFactory.store('order_items');
    migrations = stringMapStoreFactory.store('migrations');
  });

  tearDown(() async {
    await db.close();
  });

  group('database CRUD and data integrity', () {
    test('creates, reads, updates, and deletes records', () async {
      final id = await products.add(db, {
        'sku': 'COFFEE-001',
        'name': 'Coffee',
        'price': 4.50,
        'stock': 10,
      });

      final created = await products.record(id).get(db);
      expect(created?['name'], 'Coffee');

      await products.record(id).update(db, {'price': 5.00, 'stock': 8});
      final updated = await products.record(id).get(db);
      expect(updated?['price'], 5.00);
      expect(updated?['stock'], 8);

      await products.record(id).delete(db);
      expect(await products.record(id).get(db), isNull);
    });

    test('prevents duplicate business keys and preserves valid records',
        () async {
      await _insertUniqueProduct(products, db, sku: 'SKU-1', name: 'Latte');

      expect(
        () =>
            _insertUniqueProduct(products, db, sku: 'SKU-1', name: 'Duplicate'),
        throwsA(isA<StateError>()),
      );

      final records = await products.find(db);
      expect(records, hasLength(1));
      expect(records.single.value['name'], 'Latte');
    });

    test('enforces required fields, constraints, and numeric boundaries',
        () async {
      expect(
        () => _validateProduct({'sku': '', 'name': 'Coffee', 'price': 1}),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () => _validateProduct({'sku': 'SKU', 'name': '', 'price': 1}),
        throwsA(isA<ArgumentError>()),
      );
      expect(
        () =>
            _validateProduct({'sku': 'SKU', 'name': 'Coffee', 'price': -0.01}),
        throwsA(isA<RangeError>()),
      );
      expect(
        () => _validateProduct({
          'sku': 'SKU',
          'name': 'Coffee',
          'price': double.infinity,
        }),
        throwsA(isA<RangeError>()),
      );

      expect(
        _validateProduct({'sku': 'SKU', 'name': 'Coffee', 'price': 0}),
        isTrue,
      );
    });
  });

  group('transactions and rollback', () {
    test('commits all records in a successful transaction', () async {
      await db.transaction((txn) async {
        await orders.add(txn, {'orderNo': 'ORD-1', 'total': 16.50});
        await orderItems.add(txn, {
          'orderNo': 'ORD-1',
          'sku': 'COFFEE-001',
          'qty': 2,
        });
      });

      expect(await orders.count(db), 1);
      expect(await orderItems.count(db), 1);
    });

    test('rolls back all records when a transaction fails', () async {
      expect(
        () => db.transaction((txn) async {
          await orders.add(txn, {'orderNo': 'ORD-ROLLBACK', 'total': 10});
          await orderItems.add(txn, {
            'orderNo': 'ORD-ROLLBACK',
            'sku': 'MISSING',
            'qty': 1,
          });
          throw StateError('Simulated payment failure');
        }),
        throwsA(isA<StateError>()),
      );

      expect(await orders.count(db), 0);
      expect(await orderItems.count(db), 0);
    });
  });

  group('foreign keys and cascade rules', () {
    test('rejects child records when the parent does not exist', () async {
      await categories.add(db, {'code': 'DRINKS', 'name': 'Drinks'});

      expect(
        () => _insertProductWithCategory(
          products,
          categories,
          db,
          sku: 'BAD',
          categoryCode: 'MISSING',
        ),
        throwsA(isA<StateError>()),
      );

      await _insertProductWithCategory(
        products,
        categories,
        db,
        sku: 'GOOD',
        categoryCode: 'DRINKS',
      );
      expect(await products.count(db), 1);
    });

    test('cascades deletes from orders to order items', () async {
      final orderId = await orders.add(db, {'orderNo': 'ORD-CASCADE'});
      await orderItems.add(db, {'orderId': orderId, 'sku': 'COFFEE', 'qty': 1});
      await orderItems.add(db, {'orderId': orderId, 'sku': 'CAKE', 'qty': 1});

      await _deleteOrderCascade(orders, orderItems, db, orderId);

      expect(await orders.record(orderId).get(db), isNull);
      expect(await orderItems.count(db), 0);
    });
  });

  group('indexes, migrations, and integrity checks', () {
    test('uses indexed finders for lookup and sorted report queries', () async {
      await products
          .add(db, {'sku': 'B', 'name': 'Burger', 'category': 'Food'});
      await products
          .add(db, {'sku': 'A', 'name': 'Coffee', 'category': 'Drinks'});
      await products.add(db, {'sku': 'C', 'name': 'Cake', 'category': 'Food'});

      final food = await products.find(
        db,
        finder: Finder(
          filter: Filter.equals('category', 'Food'),
          sortOrders: [SortOrder('sku')],
        ),
      );

      expect(food.map((record) => record.value['sku']), ['B', 'C']);
    });

    test('runs migrations once and records schema version', () async {
      await _migrate(db, migrations, targetVersion: 2);
      await _migrate(db, migrations, targetVersion: 2);

      final version = await migrations.record('schema').get(db);
      expect(version?['version'], 2);
      expect(version?['runs'], 1);
    });

    test('detects orphaned child records as integrity violations', () async {
      await orderItems.add(db, {'orderId': 404, 'sku': 'ORPHAN', 'qty': 1});

      final violations = await _findOrphanOrderItems(orders, orderItems, db);

      expect(violations, ['ORPHAN']);
    });
  });
}

Future<int> _insertUniqueProduct(
  StoreRef<int, Map<String, Object?>> store,
  DatabaseClient db, {
  required String sku,
  required String name,
}) async {
  final existing = await store.findFirst(
    db,
    finder: Finder(filter: Filter.equals('sku', sku)),
  );
  if (existing != null) {
    throw StateError('Duplicate sku: $sku');
  }
  return store.add(db, {'sku': sku, 'name': name, 'price': 1.0});
}

bool _validateProduct(Map<String, Object?> product) {
  final sku = product['sku'] as String?;
  final name = product['name'] as String?;
  final price = product['price'] as num?;

  if (sku == null || sku.trim().isEmpty) {
    throw ArgumentError('sku is required');
  }
  if (name == null || name.trim().isEmpty) {
    throw ArgumentError('name is required');
  }
  if (price == null || price < 0 || !price.isFinite) {
    throw RangeError('price must be finite and non-negative');
  }
  return true;
}

Future<void> _insertProductWithCategory(
  StoreRef<int, Map<String, Object?>> productStore,
  StoreRef<int, Map<String, Object?>> categoryStore,
  DatabaseClient db, {
  required String sku,
  required String categoryCode,
}) async {
  final parent = await categoryStore.findFirst(
    db,
    finder: Finder(filter: Filter.equals('code', categoryCode)),
  );
  if (parent == null) {
    throw StateError('Missing category: $categoryCode');
  }
  await productStore.add(db, {'sku': sku, 'categoryCode': categoryCode});
}

Future<void> _deleteOrderCascade(
  StoreRef<int, Map<String, Object?>> orderStore,
  StoreRef<int, Map<String, Object?>> itemStore,
  DatabaseClient db,
  int orderId,
) async {
  await db.transaction((txn) async {
    await itemStore.delete(txn,
        finder: Finder(filter: Filter.equals('orderId', orderId)));
    await orderStore.record(orderId).delete(txn);
  });
}

Future<void> _migrate(
  DatabaseClient db,
  StoreRef<String, Map<String, Object?>> migrationStore, {
  required int targetVersion,
}) async {
  final current = await migrationStore.record('schema').get(db);
  if (current?['version'] == targetVersion) return;

  await migrationStore.record('schema').put(db, {
    'version': targetVersion,
    'runs': ((current?['runs'] as int?) ?? 0) + 1,
  });
}

Future<List<String>> _findOrphanOrderItems(
  StoreRef<int, Map<String, Object?>> orderStore,
  StoreRef<int, Map<String, Object?>> itemStore,
  DatabaseClient db,
) async {
  final violations = <String>[];
  final items = await itemStore.find(db);

  for (final item in items) {
    final orderId = item.value['orderId'] as int?;
    if (orderId == null || await orderStore.record(orderId).get(db) == null) {
      violations.add(item.value['sku'] as String);
    }
  }

  return violations;
}
