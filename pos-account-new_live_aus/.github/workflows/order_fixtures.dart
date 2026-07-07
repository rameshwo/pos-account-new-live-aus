import 'package:pos_account/model/home/menu/orders/order_detail_by_id.dart';

class OrderFixtures {
  /// A fixture representing a complex order with multiple items and types.
  static OrderDetailById get complexOrder {
    return OrderDetailById(
      orderDetailsViewModel: OrderDetailsViewModel(
        orderId: "order-fixture-123",
        orderType: "Dine-In",
        orderStatus: "Pending",
        totalAmount: "155.00", // 55 (Steak) + 50 (Wine) + 50 (Set Menu)
      ),
      productWithPriceDetailsViewModel: [
        ProductWithPriceDetailsViewModel(
          id: "item-1",
          productId: "prod-steak",
          productName: "Steak",
          quantity: "1",
          price: "50.00",
          totalAmount: "55.00", // with 10% tax
          tax: "5.00",
          taxPercentage: "10.0",
          taxType: "Inclusive",
          statusId: "1",
        ),
        ProductWithPriceDetailsViewModel(
          id: "item-2",
          productId: "prod-wine",
          productName: "Wine",
          quantity: "2",
          price: "25.00",
          totalAmount: "55.00", // with 10% tax
          tax: "5.00",
          taxPercentage: "10.0",
          taxType: "Inclusive",
          statusId: "1",
        ),
      ],
      setMenuWithPriceDetailsViewModel: [
        SetMenuWithPriceDetailsViewModel(
          id: "setmenu-1",
          setMenuId: "sm-dinner",
          setMenuName: "Dinner Special",
          quantity: "1",
          price: "50.00",
          totalAmount: "55.00", // with 10% tax
          tax: "5.00",
          taxPercentage: "10.0",
          taxType: "Inclusive",
          statusId: "1",
        ),
      ],
      orderPaymentDetailsWithPaymentStatusViewModel:
          OrderPaymentDetailsWithPaymentStatusViewModel(
        totalAmount: "165.00",
        paidAmount: "0.00",
        remainingAmount: "165.00",
        paymentStatus: "Unpaid",
      ),
    );
  }
}