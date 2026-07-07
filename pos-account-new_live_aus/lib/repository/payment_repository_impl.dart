import 'package:pos_account/model/home/menu/payment/make_pay_res.dart';
import 'package:pos_account/model/home/menu/place_order/po_make_pay_req.dart';
import 'package:pos_account/repository/handler.dart';
import 'package:pos_account/repository/payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  @override
  Future<MakePaymentRes?> placeOrderMakePays({
    required PoMakePaymentReq paymentReq,
  }) {
    // This calls the static Handler method
    return Handler.placeOrderMakePays(paymentReq: paymentReq);
  }

  @override
  Future<MakePaymentRes?> orderPayInvoice({
    required String orderId,
  }) {
    // This calls the static Handler method
    return Handler.orderPayInvoice(orderId: orderId);
  }
}