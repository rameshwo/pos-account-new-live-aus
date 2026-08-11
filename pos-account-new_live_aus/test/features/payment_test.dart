import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pos_account/model/home/menu/orders/order_detail_by_id.dart';
import 'package:pos_account/model/home/menu/payment/make_pay_res.dart';
import 'package:pos_account/model/home/menu/place_order/po_make_pay_req.dart';
import 'package:pos_account/providers/menu/payment_pro.dart';

import '../mocks/mock_repositories.mocks.dart';

void main() {
  group('PaymentPro Unit Tests - Payment Calculation', () {
    late PaymentPro paymentPro;

    setUp(() {
      // Initialize the provider before each test
      paymentPro = PaymentPro();
      // Set default tax type for calculations
      paymentPro.taxExclusiveInclusiveType = "Inclusive";
    });

    test('Calculates total correctly for a single item (Tax Inclusive)', () {
      // Arrange: Add a single item to the order list
      paymentPro.orderList.add(
        OrderDetail(
          id: "1",
          productId: "prod-1",
          productName: "Coffee",
          quantity: 1,
          productPrice: "10.00", // Price before tax
          total: "11.00", // Price after 10% tax
          totalTax: "1.00",
          taxPercent: "10.0",
          taxType: TaxType.Inclusive,
        ),
      );

      // Act: Trigger the calculation
      final amountDetails = paymentPro.getAllAmount;

      // Assert: Verify the calculated amounts
      expect(amountDetails.itemPrice, 11.00); // Total price including tax
      expect(amountDetails.totalTax, 1.00);
      expect(amountDetails.finalPrice, 11.00);
    });
  });

  group('PaymentPro Integration Tests - Request Building', () {
    late PaymentPro paymentPro;

    setUp(() {
      paymentPro = PaymentPro();
      paymentPro.taxExclusiveInclusiveType = "Inclusive";
      paymentPro.orderId = "order-123";
      // Mock necessary data that would be loaded from globals/API
      paymentPro.paySecListRes = PoPaySecListRes(
        paymentMethods: [PaymentMethods(id: "1", name: "Cash", isSelected: true)],
      );
    });

    test(
        'getPaymentRequest builds correct request with item, discount, and surcharge',
        () {
      // Arrange: Set up a complex scenario
      // 1. Add an item
      paymentPro.orderList.add(
        OrderDetail(
          id: "1",
          productId: "prod-1",
          productName: "Burger",
          quantity: 2,
          productPrice: "15.00", // Subtotal 30.00
          total: "33.00", // Total 33.00 (with 10% tax)
          totalTax: "3.00",
          taxPercent: "10.0",
          taxType: TaxType.Inclusive,
        ),
      );

      // 2. Apply a 10% discount
      paymentPro.discountPercentCltr.text = "10";

      // 3. Apply a 1.5% credit card surcharge
      paymentPro.isCheckCreCarCharge = true;
      paymentPro.creditCardSurchargeCltr.text = "1.5";
      paymentPro.paidAmountCltr.text = "33.00"; // Base amount for surcharge calc

      // Act: Generate the payment request object
      final request = paymentPro.getPaymentRequest;

      // Assert: Verify the integration of calculations in the final request
      expect(request, isNotNull);

      // Verify discount (10% of $33.00 = $3.30)
      // Note: Your logic calculates discount on the price before other surcharges.
      expect(request!.discountAmountWithTax, "3.30");

      // Verify surcharge (1.5% on the post-discount amount of $29.70 = $0.45)
      final finalAmountAfterDiscount = 33.00 - 3.30;
      final expectedSurcharge = (finalAmountAfterDiscount * 0.015).roundToNString();
      expect(request.creditCardSurChargeAmountWithTax, expectedSurcharge);

      // Verify final total (Item Total - Discount + Surcharge)
      expect(request.finalTotalAmount, "30.15"); // 33.00 - 3.30 + 0.45 = 30.15
    });
  });

  group('PaymentPro Unit Tests - Split Payment', () {
    late PaymentPro paymentPro;

    setUp(() {
      paymentPro = PaymentPro();
      paymentPro.taxExclusiveInclusiveType = "Inclusive";
      paymentPro.orderId = "order-split-123";
      paymentPro.paySecListRes = PoPaySecListRes(
        paymentMethods: [PaymentMethods(id: "1", name: "Cash", isSelected: true)],
      );
    });

    test('Calculates split amount correctly for 2 people', () {
      // Arrange: Add an item with a total of $110
      paymentPro.orderList.add(
        OrderDetail(
          id: "1",
          productId: "prod-1",
          productName: "Steak Dinner",
          quantity: 1,
          productPrice: "100.00",
          total: "110.00", // Price after 10% tax
          totalTax: "10.00",
          taxPercent: "10.0",
          taxType: TaxType.Inclusive,
        ),
      );

      // Set up for split payment
      paymentPro.paymentType = PaymentType.PartialPayment;
      paymentPro.isSplitPerPerson = true;
      paymentPro.splitPerPersonCltr.text = "2";

      // Act: Trigger the calculation
      paymentPro.onChangedPayAmount(isUpdatePaidAmount: false);

      // Assert: Verify the payable amount is half of the total
      // Total is $110.00, so split by 2 should be $55.00
      expect(paymentPro.payableAmount, 55.00);
      expect(paymentPro.readOnlyPaidAmount, "55.00");
    });

    test('getPaymentRequest builds correct request for split payment', () {
      // Arrange: Same setup as above
      paymentPro.orderList.add(OrderDetail(total: "110.00", taxType: TaxType.Inclusive));
      paymentPro.paymentType = PaymentType.PartialPayment;
      paymentPro.isSplitPerPerson = true;
      paymentPro.splitPerPersonCltr.text = "2";
      paymentPro.onChangedPayAmount(isUpdatePaidAmount: false);

      // Act: Generate the payment request
      final request = paymentPro.getPaymentRequest;

      // Assert: Verify the request body reflects the split payment
      expect(request, isNotNull);
      expect(request!.paymentType, "3"); // "3" for SplitByPerson
      expect(request.noOfCustomerOnTable, "2");
      expect(request.paidAmount, "55.00");
      expect(request.totalPaymentAmount, "110.00");
    });
  });

  group('PaymentPro API Integration Tests', () {
    late PaymentPro paymentPro;
    late MockPaymentRepository mockPaymentRepository;

    setUp(() {
      mockPaymentRepository = MockPaymentRepository();
      // Inject the mock repository into the provider
      paymentPro = PaymentPro(paymentRepository: mockPaymentRepository);

      // Basic setup for a valid payment request
      paymentPro.orderId = "order-api-123";
      paymentPro.paySecListRes = PoPaySecListRes(
        paymentMethods: [PaymentMethods(id: "1", name: "Cash", isSelected: true)],
      );
      paymentPro.orderList.add(OrderDetail(total: "50.00", taxType: TaxType.Inclusive));
    });

    test('makePayment updates state correctly on successful API call', () async {
      // Arrange: Define the successful response from the mock repository.
      final successResponse = MakePaymentRes(
        isPaymentCompleted: true,
        message: "Payment Successful",
        orderId: "order-api-123",
      );

      // Use Mockito to stub the method call.
      when(mockPaymentRepository.placeOrderMakePays(paymentReq: anyNamed('paymentReq')))
          .thenAnswer((_) async => successResponse);
      when(mockPaymentRepository.orderPayInvoice(orderId: anyNamed('orderId')))
          .thenAnswer((_) async => successResponse);

      // Act: Call the method to be tested.
      final result = await paymentPro.makePayment();

      // Assert:
      // 1. Verify the method returned true.
      expect(result, isTrue);

      // 2. Verify the provider's state was updated.
      expect(paymentPro.makePaymentRes, isNotNull);
      expect(paymentPro.makePaymentRes?.isPaymentCompleted, isTrue);
      expect(paymentPro.loadingPay, isFalse);
    });

    test('makePayment handles API failure gracefully', () async {
      // Arrange: Configure the mock repository to throw an exception.
      final apiException = Exception("Network Error: 503 Service Unavailable");
      when(mockPaymentRepository.placeOrderMakePays(paymentReq: anyNamed('paymentReq')))
          .thenThrow(apiException);

      // Act: Call the method to be tested.
      final result = await paymentPro.makePayment();

      // Assert:
      // 1. Verify the method returned null or false, indicating failure.
      expect(result, isFalse); // Assuming makePayment returns false on failure

      // 2. Verify the provider's state reflects the failure.
      expect(paymentPro.makePaymentRes, isNull);

      // 3. Verify loading indicators are turned off.
      expect(paymentPro.loadingPay, isFalse);

      // 4. Verify that the 'orderPayInvoice' method was NOT called,
      //    since the first call failed.
      verifyNever(mockPaymentRepository.orderPayInvoice(orderId: anyNamed('orderId')));
    });
  });

  group('PaymentPro with Complex Fixture', () {
    late PaymentPro paymentPro;
    late MockPaymentRepository mockPaymentRepository;

    setUp(() {
      mockPaymentRepository = MockPaymentRepository();
      paymentPro = PaymentPro(paymentRepository: mockPaymentRepository);

      // Use the fixture to set up a complex state
      final complexOrder = OrderFixtures.complexOrder;
      paymentPro.orderDetailById = complexOrder;
      paymentPro.orderId = complexOrder.orderDetailsViewModel?.orderId;
      paymentPro.taxExclusiveInclusiveType = "Inclusive";

      // Populate lists using factory constructors
      paymentPro.orderList.addAll(
        complexOrder.productWithPriceDetailsViewModel
                ?.map((p) => OrderDetail.fromProduct(p)) ??
            [],
      );
      paymentPro.setMenuList.addAll(
        complexOrder.setMenuWithPriceDetailsViewModel
                ?.map((s) => SetMenuOrderDetail.fromSetMenu(s)) ??
            [],
      );

      // Mock other necessary data
      paymentPro.paySecListRes = PoPaySecListRes(
        paymentMethods: [PaymentMethods(id: "1", name: "Cash", isSelected: true)],
      );
    });

    test('makePayment builds correct request and updates state from complex order',
        () async {
      // Arrange: Stub the repository to return a success response
      final successResponse = MakePaymentRes(isPaymentCompleted: true);
      when(mockPaymentRepository.placeOrderMakePays(paymentReq: anyNamed('paymentReq')))
          .thenAnswer((_) async => successResponse);
      when(mockPaymentRepository.orderPayInvoice(orderId: anyNamed('orderId')))
          .thenAnswer((_) async => successResponse);

      // Act: Call the method
      await paymentPro.makePayment();

      // Assert:
      // 1. Capture the request object sent to the repository
      final captured = verify(mockPaymentRepository.placeOrderMakePays(
              paymentReq: captureAnyNamed('paymentReq')))
          .captured;

      final PoMakePaymentReq capturedRequest = captured.first;

      // 2. Verify the contents of the captured request
      expect(capturedRequest.orderId, "order-fixture-123");
      expect(capturedRequest.orderDetailsModel?.length, 2); // 2 products
      expect(capturedRequest.setMenuDetails?.length, 1); // 1 set menu
      expect(capturedRequest.finalTotalAmount, "165.00"); // 55+55+55

      // 3. Verify the final state of the provider
      expect(paymentPro.makePaymentRes?.isPaymentCompleted, isTrue);
    });

    test('calculates split payment correctly with complex order fixture', () {
      // Arrange: Configure for a split payment by 2 people.
      paymentPro.paymentType = PaymentType.PartialPayment;
      paymentPro.isSplitPerPerson = true;
      paymentPro.splitPerPersonCltr.text = "2";

      // Act: Trigger the calculation.
      paymentPro.onChangedPayAmount(isUpdatePaidAmount: false);

      // Assert:
      // 1. Verify the payable amount is correctly halved.
      // The total from the fixture is 165.00. Half of that is 82.50.
      expect(paymentPro.payableAmount, 82.50);
      expect(paymentPro.readOnlyPaidAmount, "82.50");

      // 2. Generate the payment request and verify its contents.
      final request = paymentPro.getPaymentRequest;
      expect(request, isNotNull);
      expect(request!.paymentType, "3"); // "3" for SplitByPerson
      expect(request.paidAmount, "82.50");
      expect(request.totalPaymentAmount, "165.00");
    });
  });
}
