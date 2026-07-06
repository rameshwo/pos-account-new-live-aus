import 'package:pos_account/model/home/menu/place_order/place_order_req.dart';
import 'package:pos_account/model/home/menu/place_order/po_make_pay_req.dart';

class RefundOrderReq {
  String? orderId;
  String? paymentMethodId;
  String? refundAmount;
  String? refundTaxAmount;
  String? refundAmountWithoutTax;
  String? refundDiscountAmount;
  String? refundDiscountAmountWithTax;
  String? refundPublicHolidaySurChargeAmount;
  String? refundPublicHolidaySurChargeAmoutWithTax;
  String? refundCreditCardSurChargeAmount;
  String? refundCreditCardSurChargeAmountWithTax;
  String? refundServiceChargeAmount;
  String? refundServiceChargePercentage;
  String? refundCreditCardSurchargePercentage;
  String? refundDeliveryAmount;
  String? refundDeliveryAmountWithTax;
  List<OrderDetail>? orderDetails;
  List<SetMenuOrderDetail>? setMenuOrderDetails;
  String? transactionRefId;
  MerchantInvoiceRequestViewModel? merchantInvoiceRequestViewModel;
  List<RawIngredientOrderDetail>? rawIngredientOrderDetails;
  bool? isDeliveryEnable;
  String? eftPosMerchantType;
  String? eftposSerialNumber;
  String? transactionSessionId;
  String? stockDeductType;
  String? integrationPlatformTerminalId;
  String? holidaySurchargeType;

  RefundOrderReq({
    this.orderId,
    this.paymentMethodId,
    this.refundAmount,
    this.refundTaxAmount,
    this.refundAmountWithoutTax,
    this.refundDiscountAmount,
    this.refundDiscountAmountWithTax,
    this.refundPublicHolidaySurChargeAmount,
    this.refundPublicHolidaySurChargeAmoutWithTax,
    this.refundCreditCardSurChargeAmount,
    this.refundCreditCardSurChargeAmountWithTax,
    this.refundServiceChargeAmount,
    this.refundServiceChargePercentage,
    this.refundCreditCardSurchargePercentage,
    this.refundDeliveryAmount,
    this.refundDeliveryAmountWithTax,
    this.orderDetails,
    this.setMenuOrderDetails,
    this.transactionRefId,
    this.merchantInvoiceRequestViewModel,
    this.rawIngredientOrderDetails,
    this.isDeliveryEnable,
    this.eftPosMerchantType,
    this.eftposSerialNumber,
    this.transactionSessionId,
    this.stockDeductType,
    this.integrationPlatformTerminalId,
    this.holidaySurchargeType,
  });

  factory RefundOrderReq.fromJson(Map<String, dynamic> json) => RefundOrderReq(
        orderId: json["OrderId"],
        paymentMethodId: json["PaymentMethodId"],
        refundAmount: json["RefundAmount"],
        refundTaxAmount: json["RefundTaxAmount"],
        refundAmountWithoutTax: json["RefundAmountWithoutTax"],
        refundDiscountAmount: json["RefundDiscountAmount"],
        refundDiscountAmountWithTax: json["RefundDiscountAmountWithTax"],
        refundPublicHolidaySurChargeAmount:
            json["RefundPublicHolidaySurChargeAmount"],
        refundPublicHolidaySurChargeAmoutWithTax:
            json["RefundPublicHolidaySurChargeAmoutWithTax"],
        refundCreditCardSurChargeAmount:
            json["RefundCreditCardSurChargeAmount"],
        refundCreditCardSurChargeAmountWithTax:
            json["RefundCreditCardSurChargeAmountWithTax"],
        refundServiceChargeAmount: json["RefundServiceChargeAmount"],
        refundServiceChargePercentage: json["RefundServiceChargePercentage"],
        refundCreditCardSurchargePercentage:
            json["RefundCreditCardSurchargePercentage"],
        refundDeliveryAmount: json["RefundDeliveryAmount"],
        refundDeliveryAmountWithTax: json["RefundDeliveryAmountWithTax"],
        orderDetails: json["OrderItemsViewModels"] == null
            ? []
            : List<OrderDetail>.from(json["OrderItemsViewModels"]!
                .map((x) => OrderDetail.fromJson(x))),
        setMenuOrderDetails: json["SetMenuOrderDetails"] == null
            ? []
            : List<SetMenuOrderDetail>.from(json["SetMenuOrderDetails"]!
                .map((x) => SetMenuOrderDetail.fromJson(x))),
        transactionRefId: json["TransactionRefId"],
        merchantInvoiceRequestViewModel:
            json["MerchantInvoiceRequestViewModel"] == null
                ? null
                : MerchantInvoiceRequestViewModel.fromJson(
                    json["MerchantInvoiceRequestViewModel"]),
        rawIngredientOrderDetails:
            json["RawLooseIngredientOrderDetails"] == null
                ? []
                : List<RawIngredientOrderDetail>.from(
                    json["RawLooseIngredientOrderDetails"]!
                        .map((x) => RawIngredientOrderDetail.fromJson(x))),
        isDeliveryEnable: json["IsDeliveryEnable"],
        eftPosMerchantType: json["EftPOSMerchantType"],
        eftposSerialNumber: json["EFTPOSSerialNumber"],
        transactionSessionId: json["TransactionSessionId"],
        stockDeductType: json["StockDeductType"],
        integrationPlatformTerminalId: json["IntegrationPlatformTerminalId"],
        holidaySurchargeType: json["HolidaySurchargeType"],
      );

  Map<String, dynamic> toJson() => {
        "OrderId": orderId,
        "PaymentMethodId": paymentMethodId,
        "RefundAmount": refundAmount,
        "RefundTaxAmount": refundTaxAmount,
        "RefundAmountWithoutTax": refundAmountWithoutTax,
        "RefundDiscountAmount": refundDiscountAmount,
        "RefundDiscountAmountWithTax": refundDiscountAmountWithTax,
        "RefundPublicHolidaySurChargeAmount":
            refundPublicHolidaySurChargeAmount,
        "RefundPublicHolidaySurChargeAmoutWithTax":
            refundPublicHolidaySurChargeAmoutWithTax,
        "RefundCreditCardSurChargeAmount": refundCreditCardSurChargeAmount,
        "RefundCreditCardSurChargeAmountWithTax":
            refundCreditCardSurChargeAmountWithTax,
        "RefundServiceChargeAmount": refundServiceChargeAmount,
        "RefundServiceChargePercentage": refundServiceChargePercentage,
        "RefundCreditCardSurchargePercentage":
            refundCreditCardSurchargePercentage,
        "RefundDeliveryAmount": refundDeliveryAmount,
        "RefundDeliveryAmountWithTax": refundDeliveryAmountWithTax,
        "OrderItemsViewModels": orderDetails == null
            ? []
            : List<dynamic>.from(orderDetails!.map((x) => x.toJson())),
        "SetMenuOrderDetails": setMenuOrderDetails == null
            ? []
            : List<dynamic>.from(setMenuOrderDetails!.map((x) => x.toJson())),
        if (transactionRefId != null && transactionRefId!.isNotEmpty)
          "TransactionRefId": transactionRefId,
        "MerchantInvoiceRequestViewModel":
            merchantInvoiceRequestViewModel?.toJson(),
        "RawLooseIngredientOrderDetails": rawIngredientOrderDetails == null
            ? []
            : List<dynamic>.from(
                rawIngredientOrderDetails!.map((x) => x.toJson())),
        "IsDeliveryEnable": isDeliveryEnable,
        "EftPOSMerchantType": eftPosMerchantType,
        "EFTPOSSerialNumber": eftposSerialNumber,
        "TransactionSessionId": transactionSessionId,
        "StockDeductType": stockDeductType,
        "IntegrationPlatformTerminalId": integrationPlatformTerminalId,
        "HolidaySurchargeType": holidaySurchargeType,
      };
}
