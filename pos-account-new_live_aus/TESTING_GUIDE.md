# Testing Guide & Coverage Plan

**Version**: 1.0
**Last Updated**: 2024-07-06

---

## Overview

This document outlines the testing strategy for POSApt Flutter application, targeting **70% code coverage**.

---

## Testing Strategy

### Test Pyramid

```
         Integration Tests (5%)
        /                    \
       /    Widget Tests      \
      /        (25%)          \
     /________________________\
       Unit Tests (70%)
```

### Target Coverage by Component

| Component | Current | Target | Effort |
|-----------|---------|--------|--------|
| Providers | 0% | 90% | 40h |
| Services | 5% | 80% | 30h |
| Repositories | 0% | 85% | 35h |
| Models | 0% | 95% | 20h |
| Validators | 0% | 100% | 10h |
| Widgets | 0% | 50% | 40h |
| Screens | 0% | 30% | 50h |
| **Total** | **1%** | **70%** | **225h** |

---

## Unit Tests

### 1. Configuration Tests
**File**: `test/config/flavor_config_test.dart`

```dart
✅ Flavor configuration loads correctly
✅ API URLs are set from flavor
✅ Environment variables are correct
```

**Run**:
```bash
flutter test test/config/flavor_config_test.dart
```

### 2. Authentication Tests
**File**: `test/features/auth_test.dart`

**Must Test**:
- [ ] Login with valid credentials
- [ ] Login failure with invalid credentials
- [ ] Token refresh on expiry
- [ ] Logout clears data
- [ ] OTP generation and validation
- [ ] Store selection post-login

**Example**:
```dart
test('User can login with valid credentials', () async {
  final authProvider = AuthProvider();
  final result = await authProvider.login('user@test.com', 'password123');
  
  expect(result.isSuccess, true);
  expect(authProvider.isAuthenticated, true);
  expect(authProvider.userToken, isNotEmpty);
});
```

### 3. Order Tests
**File**: `test/features/order_test.dart`

**Must Test**:
- [ ] Order creation
- [ ] Order total calculation
- [ ] Discount application
- [ ] Tax calculation
- [ ] Order status transitions
- [ ] Order modifications
- [ ] Order cancellation

**Example**:
```dart
test('Order total is calculated correctly', () async {
  final order = Order();
  order.addItem(MenuItem(price: 100, quantity: 2)); // 200
  order.addItem(MenuItem(price: 50, quantity: 1));  // 50
  // Subtotal: 250
  order.taxPercent = 10; // 25
  // Total: 275
  
  expect(order.subtotal, 250);
  expect(order.tax, 25);
  expect(order.total, 275);
});
```

### 4. Payment Tests
**File**: `test/features/payment_test.dart`

**Must Test**:
- [ ] Successful payment processing
- [ ] Payment failure handling
- [ ] Multiple payment methods
- [ ] Refund processing
- [ ] Partial refunds
- [ ] Payment validation
- [ ] Receipt generation

**Example**:
```dart
test('Payment can be processed successfully', () async {
  final payment = PaymentService();
  final result = await payment.process(
    amount: 100,
    method: PaymentMethod.creditCard,
    card: cardDetails,
  );
  
  expect(result.status, PaymentStatus.completed);
  expect(result.transactionId, isNotEmpty);
});
```

### 5. Database & Sync Tests
**File**: `test/features/database_sync_test.dart`

**Must Test**:
- [ ] Data persistence to local DB
- [ ] Data retrieval
- [ ] Data updates
- [ ] Data deletion
- [ ] Offline sync queueing
- [ ] Sync error handling
- [ ] Conflict resolution

**Example**:
```dart
test('Offline orders are queued for sync', () async {
  final db = DatabaseService();
  
  // Simulate offline
  db.isOnline = false;
  
  // Create order
  final order = await db.saveOrder(orderData);
  
  // Verify queued for sync
  final pending = await db.getPendingSyncOrders();
  expect(pending, contains(order));
});
```

### 6. Validation Tests
**File**: `test/features/validation_test.dart`

**Must Test**:
- [ ] Email validation
- [ ] Phone validation
- [ ] Card validation (Luhn algorithm)
- [ ] Amount validation
- [ ] PIN validation
- [ ] Store selection

**Example**:
```dart
test('Email validation works', () {
  final validator = Validator();
  
  expect(validator.isValidEmail('user@test.com'), true);
  expect(validator.isValidEmail('invalid-email'), false);
  expect(validator.isValidEmail(''), false);
});
```

---

## Widget Tests

### 1. UI Component Tests
**File**: `test/widgets/button_test.dart`

```dart
testWidgets('Button responds to tap', (WidgetTester tester) async {
  bool tapped = false;
  
  await tester.pumpWidget(
    MaterialApp(
      home: Button(onPressed: () => tapped = true),
    ),
  );
  
  await tester.tap(find.byType(Button));
  expect(tapped, true);
});
```

### 2. Form Tests
**File**: `test/widgets/form_test.dart`

```dart
testWidgets('Form validation works', (WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
  
  // Find form field
  await tester.enterText(find.byType(TextField), 'invalid');
  await tester.tap(find.byText('Submit'));
  await tester.pumpAndSettle();
  
  // Verify error shown
  expect(find.text('Invalid input'), findsOneWidget);
});
```

### 3. Screen Tests
**File**: `test/screens/order_screen_test.dart`

```dart
testWidgets('Order screen displays items', (WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
  
  // Verify items are displayed
  expect(find.byType(OrderItem), findsWidgets);
});
```

---

## Integration Tests

### 1. Authentication Flow
**File**: `integration_test/auth_flow_test.dart`

```dart
testWidgets('Complete authentication flow', (WidgetTester tester) async {
  app.main();
  await tester.pumpAndSettle();
  
  // Login
  await tester.enterText(find.byType(EmailField), 'test@example.com');
  await tester.enterText(find.byType(PasswordField), 'password');
  await tester.tap(find.byText('Login'));
  await tester.pumpAndSettle();
  
  // Verify logged in
  expect(find.byType(HomeScreen), findsOneWidget);
});
```

### 2. Order to Payment Flow
**File**: `integration_test/order_payment_flow_test.dart`

```dart
testWidgets('Complete order and payment flow', (WidgetTester tester) async {
  // Create order
  // Add items
  // Apply discount
  // Process payment
  // Verify receipt
});
```

---

## Running Tests

### Local Execution

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific file
flutter test test/features/auth_test.dart

# Run matching pattern
flutter test --name "Auth"

# Run widget tests only
flutter test --name "testWidgets"

# Watch mode
flutter test --watch

# Generate coverage report
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### CI/CD Execution

Tests run automatically on:
- Every push to main/develop/staging
- Every pull request
- Results posted as PR comment

---

## Coverage Analysis

### View Coverage Report

```bash
# Generate
flutter test --coverage

# macOS
open coverage/html/index.html

# Linux/Windows
start coverage/html/index.html

# Any
python -m http.server 8000 -d coverage/html
# Visit http://localhost:8000
```

### Upload to Codecov

```bash
# Automatic via CI
# Manual:
curl -Os https://codecov.io/bash
bash codecov -f coverage/lcov.info
```

---

## Test Data & Mocking

### Mock Services

```dart
import 'package:mockito/mockito.dart';

class MockAuthService extends Mock implements AuthService {}
class MockPaymentService extends Mock implements PaymentService {}

void main() {
  test('example', () {
    final mockAuth = MockAuthService();
    when(mockAuth.login(...)).thenAnswer((_) async => true);
  });
}
```

### Test Fixtures

```dart
// test/fixtures/user_fixture.dart
User getUserFixture() => User(
  id: '123',
  email: 'test@example.com',
  name: 'Test User',
);

Order getOrderFixture() => Order(
  id: '456',
  items: [
    OrderItem(name: 'Pizza', price: 500, quantity: 1),
  ],
  total: 500,
);
```

---

## Test Coverage Goals by Phase

### Phase 1 (Week 1-2): Foundation
- **Target**: 20% coverage
- **Focus**: Models, validators, configs
- **Tests**: 30 unit tests
- **Effort**: 40 hours

### Phase 2 (Week 3-4): Services & Repos
- **Target**: 40% coverage
- **Focus**: Services, repositories
- **Tests**: 40 unit tests
- **Effort**: 50 hours

### Phase 3 (Week 5-6): Providers & Screens
- **Target**: 60% coverage
- **Focus**: State management, widgets
- **Tests**: 50 widget tests
- **Effort**: 80 hours

### Phase 4 (Week 7+): Integration & Polish
- **Target**: 70%+ coverage
- **Focus**: Integration tests, edge cases
- **Tests**: 20 integration tests
- **Effort**: 55 hours

---

## Common Test Patterns

### Async Test
```dart
test('async operation', () async {
  final result = await service.fetchData();
  expect(result, isNotNull);
});
```

### Mock HTTP
```dart
test('API call', () async {
  final mock = MockHttpClient();
  when(mock.get(...)).thenAnswer((_) async => Response(json, 200));
});
```

### Widget Finding
```dart
testWidgets('find widget', (WidgetTester tester) async {
  await tester.pumpWidget(MyApp());
  
  expect(find.byType(Button), findsOneWidget);
  expect(find.byText('Submit'), findsOneWidget);
  expect(find.byIcon(Icons.add), findsOneWidget);
  expect(find.byWidgetPredicate(...), findsOneWidget);
});
```

---

## Test Checklist

Before committing:

- [ ] All new tests pass locally
- [ ] Coverage didn't decrease
- [ ] No flaky tests
- [ ] Tests are isolated (no dependencies)
- [ ] Mocks used for external services
- [ ] Test names are descriptive
- [ ] No commented-out tests
- [ ] Tests follow naming convention

---

## Continuous Improvement

### Monthly Reviews
- [ ] Review coverage trends
- [ ] Identify undertested areas
- [ ] Update test strategy
- [ ] Remove flaky tests

### Quarterly Goals
- Week 1-4: 30% coverage
- Week 5-8: 50% coverage
- Week 9-12: 70% coverage

---

## Resources

- [Flutter Testing Docs](https://flutter.dev/docs/testing)
- [Mockito](https://pub.dev/packages/mockito)
- [Integration Test](https://flutter.dev/docs/testing/integration-tests)
- [Coverage Analysis](https://pub.dev/packages/coverage)

---

## FAQ

**Q: Why 70% coverage?**
A: Industry standard for production apps. Focuses on critical paths.

**Q: How long to reach 70%?**
A: ~225 hours = 5-6 weeks with team of 2

**Q: Should I test getters/setters?**
A: Only if they contain logic. Skip trivial ones.

**Q: How do I test UI navigation?**
A: Use `integration_test` for full flow testing.

---

**Related Documents**:
- [CI_CD_DOCUMENTATION.md](./CI_CD_DOCUMENTATION.md)
- [COMPREHENSIVE_AUDIT_REPORT.md](./COMPREHENSIVE_AUDIT_REPORT.md)
