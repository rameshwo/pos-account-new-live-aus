import 'package:pos_account/model/home/menu/payment/make_pay_res.dart';
import 'package:pos_account/model/home/menu/place_order/po_make_pay_req.dart';

abstract class PaymentRepository {
  Future<MakePaymentRes?> placeOrderMakePays({
    required PoMakePaymentReq paymentReq,
  });

  Future<MakePaymentRes?> orderPayInvoice({
    required String orderId,
  });

  // Add other methods from Handler that PaymentPro uses here
}