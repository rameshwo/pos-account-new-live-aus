class PoMakePaymentReq {
  PoMakePaymentReq({
    this.orderId,
    this.paymentMethodId,
    this.paymentType,
    this.paymentTipAmount,
    this.paidAmount,
    this.totalPaymentAmount,
    this.discountAmount,
    // this.discountPercentage,
    this.publicHolidaySurChargeAmount,
    this.creditCardSurChargeAmount,
    this.serviceChargeAmount,
    this.taxAmount,
    this.creditCardSurChargeAmountWithTax,
    this.publicHolidaySurChargeAmoutWithTax,
    this.discountAmountWithTax,
    this.deliveryAmount,
    this.deliveryAmountWithTax,
    this.reedemCode,
    // this.channel,
    this.creditCardSurchargePercentage,
    this.serviceChargePercentage,
    this.finalTotalAmount,
    this.totalWithoutTaxAmount,
    this.transactionRefId,
    this.customerViewModel,
    // this.creditCardViewModel,
    this.orderDetailsModel,
    this.setMenuDetails,
    this.rawLooseIngredientDetails,
    this.merchantInvoiceRequestViewModel,
    this.comments,
    this.isDeliveryEnable,
    this.isPaymentRevoked,
    this.eftPosMerchantType,
    this.eftposSerialNumber,
    this.noOfCustomerOnTable,
    this.remainingAmountOnGiftPay,
    this.integrationPlatformTerminalId,
    this.holidaySurchargeType,
    // this.discountId,
    this.isComplimentary,
    this.merchantCardSurchargeAmount,
    this.isSendToKitchen = false,
    this.orderDiscounts,
  });

  String? orderId;
  String? paymentMethodId;
  String? paymentType;
  String? paymentTipAmount;
  String? paidAmount;
  String? totalPaymentAmount;
  String? discountAmount;
  // String? discountId;
  // String? discountPercentage;
  String? publicHolidaySurChargeAmount;
  String? creditCardSurChargeAmount;
  String? serviceChargeAmount;
  String? taxAmount;
  String? creditCardSurChargeAmountWithTax;
  String? publicHolidaySurChargeAmoutWithTax;
  String? discountAmountWithTax;
  String? deliveryAmount;
  String? deliveryAmountWithTax;
  String? reedemCode;
  // String? channel;
  String? creditCardSurchargePercentage;
  String? serviceChargePercentage;
  String? finalTotalAmount;
  String? totalWithoutTaxAmount;
  String? transactionRefId;
  CustomerViewModel? customerViewModel;
  // CreditCardViewModel? creditCardViewModel;
  List<OrderDetailsModel>? orderDetailsModel;
  List<SetMenuDetailModel>? setMenuDetails;
  List<RawLooseIngredientDetail>? rawLooseIngredientDetails;
  MerchantInvoiceRequestViewModel? merchantInvoiceRequestViewModel;
  String? comments;
  bool? isDeliveryEnable;
  bool? isPaymentRevoked;
  String? eftPosMerchantType;
  String? eftposSerialNumber;
  String? noOfCustomerOnTable;
  String? remainingAmountOnGiftPay;
  String? integrationPlatformTerminalId;
  String? holidaySurchargeType;
  bool? isComplimentary;
  String? merchantCardSurchargeAmount;
  bool isSendToKitchen;
  List<OrderDiscountModel>? orderDiscounts;

  factory PoMakePaymentReq.fromJson(Map<String, dynamic> json) =>
      PoMakePaymentReq(
        orderId: json["OrderId"],
        paymentMethodId: json["PaymentMethodId"],
        paymentType: json["PaymentType"],
        paymentTipAmount: json["PaymentTipAmount"],
        paidAmount: json["PaidAmount"],
        totalPaymentAmount: json["TotalPaymentAmount"],
        discountAmount: json["DiscountAmount"],
        // discountId: json["DiscountId"],
        // discountPercentage: json["DiscountPercentage"],
        publicHolidaySurChargeAmount: json["PublicHolidaySurChargeAmount"],
        creditCardSurChargeAmount: json["CreditCardSurChargeAmount"],
        serviceChargeAmount: json["ServiceChargeAmount"],
        taxAmount: json["TaxAmount"],
        creditCardSurChargeAmountWithTax:
            json["CreditCardSurChargeAmountWithTax"],
        publicHolidaySurChargeAmoutWithTax:
            json["PublicHolidaySurChargeAmoutWithTax"],
        discountAmountWithTax: json["DiscountAmountWithTax"],
        deliveryAmount: json["DeliveryAmount"],
        deliveryAmountWithTax: json["DeliveryAmountWithTax"],
        reedemCode: json["ReedemCode"],
        // channel: json["ChannelPlatform"],
        creditCardSurchargePercentage: json["CreditCardSurchargePercentage"],
        serviceChargePercentage: json["ServiceChargePercentage"],
        finalTotalAmount: json["FinalTotalAmount"],
        totalWithoutTaxAmount: json["TotalWithoutTaxAmount"],
        transactionRefId: json["TransactionRefId"],
        customerViewModel: json["CustomerViewModel"] == null
            ? null
            : CustomerViewModel.fromJson(json["CustomerViewModel"]),
        // creditCardViewModel: json["CreditCardViewModel"] == null
        //     ? null
        //     : CreditCardViewModel.fromJson(json["CreditCardViewModel"]),
        orderDetailsModel: json["OrderDetails"] == null
            ? []
            : List<OrderDetailsModel>.from(json["OrderDetails"]!
                .map((x) => OrderDetailsModel.fromJson(x))),
        setMenuDetails: json["SetMenuOrderDetails"] == null
            ? []
            : List<SetMenuDetailModel>.from(json["SetMenuOrderDetails"]!
                .map((x) => SetMenuDetailModel.fromJson(x))),
        rawLooseIngredientDetails:
            json["RawLooseIngredientOrderDetails"] == null
                ? []
                : List<RawLooseIngredientDetail>.from(
                    json["RawLooseIngredientOrderDetails"]!
                        .map((x) => RawLooseIngredientDetail.fromJson(x))),
        merchantInvoiceRequestViewModel:
            json["MerchantInvoiceRequestViewModel"] == null
                ? null
                : MerchantInvoiceRequestViewModel.fromJson(
                    json["MerchantInvoiceRequestViewModel"]),
        comments: json["Comments"],
        isDeliveryEnable: json["IsDeliveryEnable"],
        isPaymentRevoked: json["IsPaymentRevoked"],
        eftPosMerchantType: json["EftPOSMerchantType"],
        eftposSerialNumber: json["EFTPOSSerialNumber"],
        noOfCustomerOnTable: json["NoOfCustomerOnTable"],
        remainingAmountOnGiftPay: json["RemainingAmountOnGiftPay"],
        integrationPlatformTerminalId: json["IntegrationPlatformTerminalId"],
        holidaySurchargeType: json["HolidaySurchargeType"],
        isComplimentary: json["isComplimentary"],
        merchantCardSurchargeAmount: json["MerchantCardSurchargeAmount"],
        isSendToKitchen: json["isSendToKitchen"],
        orderDiscounts: json["orderDiscounts"] == null
            ? []
            : List<OrderDiscountModel>.from(json["orderDiscounts"]!
                .map((x) => OrderDiscountModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "OrderId": orderId,
        "PaymentMethodId": paymentMethodId,
        "PaymentType": paymentType,
        "PaymentTipAmount": paymentTipAmount,
        "PaidAmount": paidAmount,
        "TotalPaymentAmount": totalPaymentAmount,
        "DiscountAmount": discountAmount,
        // "DiscountId": discountId,
        // "DiscountPercentage": discountPercentage,
        "PublicHolidaySurChargeAmount": publicHolidaySurChargeAmount,
        "CreditCardSurChargeAmount": creditCardSurChargeAmount,
        "ServiceChargeAmount": serviceChargeAmount,
        "TaxAmount": taxAmount,
        "CreditCardSurChargeAmountWithTax": creditCardSurChargeAmountWithTax,
        "PublicHolidaySurChargeAmoutWithTax":
            publicHolidaySurChargeAmoutWithTax,
        "DiscountAmountWithTax": discountAmountWithTax,
        "DeliveryAmount": deliveryAmount,
        "DeliveryAmountWithTax": deliveryAmountWithTax,
        "ReedemCode": reedemCode,
        // "ChannelPlatform": channel,
        "CreditCardSurchargePercentage": creditCardSurchargePercentage,
        "ServiceChargePercentage": serviceChargePercentage,
        "FinalTotalAmount": finalTotalAmount,
        "TotalWithoutTaxAmount": totalWithoutTaxAmount,
        if (transactionRefId != null && transactionRefId!.isNotEmpty)
          "TransactionRefId": transactionRefId,
        "CustomerViewModel": customerViewModel?.toJson(),
        // "CreditCardViewModel":
        //     creditCardViewModel == null ? null : creditCardViewModel!.toJson(),
        "OrderDetails": orderDetailsModel == null
            ? []
            : List<dynamic>.from(orderDetailsModel!.map((x) => x.toJson())),
        "SetMenuOrderDetails": setMenuDetails == null
            ? []
            : List<dynamic>.from(setMenuDetails!.map((x) => x.toJson())),
        "RawLooseIngredientOrderDetails": rawLooseIngredientDetails == null
            ? []
            : List<dynamic>.from(
                rawLooseIngredientDetails!.map((x) => x.toJson())),
        "MerchantInvoiceRequestViewModel":
            merchantInvoiceRequestViewModel?.toJson(),
        "Comments": comments,
        "IsDeliveryEnable": isDeliveryEnable,
        "IsPaymentRevoked": isPaymentRevoked,
        "EftPOSMerchantType": eftPosMerchantType,
        "EFTPOSSerialNumber": eftposSerialNumber,
        "NoOfCustomerOnTable": noOfCustomerOnTable,
        "RemainingAmountOnGiftPay": remainingAmountOnGiftPay,
        "IntegrationPlatformTerminalId": integrationPlatformTerminalId,
        "HolidaySurchargeType": holidaySurchargeType,
        "isComplimentary": isComplimentary,
        "MerchantCardSurchargeAmount": merchantCardSurchargeAmount,
        "isSendToKitchen": isSendToKitchen,
        "orderDiscounts": orderDiscounts == null
            ? []
            : List<dynamic>.from(orderDiscounts!.map((x) => x.toJson())),
      };
}

class CustomerViewModel {
  CustomerViewModel({
    this.id = "",
    this.name,
    this.email,
    this.phoneNumber,
    this.customerTypeId,
    this.customerGroupId,
    this.isMarketingPromotionEnabled = false,
    this.isLoyaltyEnabled = false,
    this.countryPhoneNumberPrefixId,
    this.countryId,
    this.postalCode,
  });

  String id;
  String? name;
  String? email;
  String? phoneNumber;
  String? customerTypeId;
  String? customerGroupId;
  bool isMarketingPromotionEnabled;
  bool isLoyaltyEnabled;
  String? countryPhoneNumberPrefixId;
  String? countryId;
  String? postalCode;

  factory CustomerViewModel.fromJson(Map<String, dynamic> json) =>
      CustomerViewModel(
        id: json["Id"],
        name: json["Name"],
        email: json["Email"],
        phoneNumber: json["PhoneNumber"],
        customerTypeId: json["CustomerTypeId"],
        customerGroupId: json["CustomerGroupId"],
        isMarketingPromotionEnabled: json["IsMarketingPromotionEnabled"],
        isLoyaltyEnabled: json["IsLoyaltyEnabled"],
        countryPhoneNumberPrefixId: json["CountryPhoneNumberPrefixId"],
        countryId: json["CountryId"],
        postalCode: json["PostalCode"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Name": name,
        "Email": email,
        "PhoneNumber": phoneNumber,
        "CustomerTypeId": customerTypeId,
        "CustomerGroupId": customerGroupId,
        "IsMarketingPromotionEnabled": isMarketingPromotionEnabled,
        "IsLoyaltyEnabled": isLoyaltyEnabled,
        "CountryPhoneNumberPrefixId": countryPhoneNumberPrefixId,
        "CountryId": countryId,
        "PostalCode": postalCode,
      };
}

class CreditCardViewModel {
  String? nameOnCard;
  String? cardNumber;
  String? cVCNumber;
  String? expiryMonth;
  String? expiryYear;

  CreditCardViewModel({
    this.nameOnCard,
    this.cardNumber,
    this.cVCNumber,
    this.expiryMonth,
    this.expiryYear,
  });

  factory CreditCardViewModel.fromJson(Map<String, dynamic> json) =>
      CreditCardViewModel(
        nameOnCard: json["NameOnCard"],
        cardNumber: json["CardNumber"],
        cVCNumber: json["CVCNumber"],
        expiryMonth: json["ExpiryMonth"],
        expiryYear: json["ExpiryYear"],
      );

  Map<String, dynamic> toJson() => {
        "NameOnCard": nameOnCard,
        "CardNumber": cardNumber,
        "CVCNumber": cVCNumber,
        "ExpiryMonth": expiryMonth,
        "ExpiryYear": expiryYear,
      };
}

class OrderDetailsModel {
  String? id;
  String? paidQuantity;
  String? productVariationId;
  String? productId;
  String? paidAmount;
  String? currentPaidQuantity;
  String? surChargeAmount;

  /// this keys are used to know either the charges are used in previous payment or not, if yes then it will be added in total amount of the item to get correct value
  bool? isPublicHolidaySurchargeUsed;
  bool? isCreditCardSurchargeUsed;
  bool? isServiceChargeUsed;
  // eod report
  String? finalTotalSellingAmount;
  String? finalTotalTax;
  String? finalTotalDiscount;
  String? finalTotalDiscountWithTax;

  OrderDetailsModel({
    this.id,
    this.paidQuantity,
    this.productVariationId,
    this.productId,
    this.paidAmount,
    this.currentPaidQuantity,
    this.surChargeAmount,
    this.isPublicHolidaySurchargeUsed,
    this.isCreditCardSurchargeUsed,
    this.isServiceChargeUsed,
    this.finalTotalSellingAmount,
    this.finalTotalTax,
    this.finalTotalDiscount,
    this.finalTotalDiscountWithTax,
  });

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) =>
      OrderDetailsModel(
        id: json["Id"],
        paidQuantity: json["PaidQuantity"],
        productVariationId: json["ProductVariationId"],
        productId: json["ProductId"],
        paidAmount: json["PaidAmount"],
        currentPaidQuantity: json["CurrentPaidQuantity"],
        surChargeAmount: json["SurChargeAmount"],
        isPublicHolidaySurchargeUsed: json["IsPublicHolidaySurchargeUsed"],
        isCreditCardSurchargeUsed: json["IsCreditCardSurchargeUsed"],
        isServiceChargeUsed: json["IsServiceChargeUsed"],
        finalTotalSellingAmount: json["FinalTotalSellingAmount"],
        finalTotalTax: json["FinalTotalTax"],
        finalTotalDiscount: json["FinalTotalDiscount"],
        finalTotalDiscountWithTax: json["FinalTotalDiscountWithTax"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "PaidQuantity": paidQuantity,
        "ProductVariationId": productVariationId,
        "ProductId": productId,
        "PaidAmount": paidAmount,
        "CurrentPaidQuantity": currentPaidQuantity,
        "SurChargeAmount": surChargeAmount,
        "IsPublicHolidaySurchargeUsed": isPublicHolidaySurchargeUsed,
        "IsCreditCardSurchargeUsed": isCreditCardSurchargeUsed,
        "IsServiceChargeUsed": isServiceChargeUsed,
        "FinalTotalSellingAmount": finalTotalSellingAmount,
        "FinalTotalTax": finalTotalTax,
        "FinalTotalDiscount": finalTotalDiscount,
        "FinalTotalDiscountWithTax": finalTotalDiscountWithTax,
      };
}

class MerchantInvoiceRequestViewModel {
  String? merchantInvoiceData;
  String? customerInvoiceData;

  MerchantInvoiceRequestViewModel({
    this.merchantInvoiceData,
    this.customerInvoiceData,
  });

  factory MerchantInvoiceRequestViewModel.fromJson(Map<String, dynamic> json) =>
      MerchantInvoiceRequestViewModel(
        merchantInvoiceData: json["MerchantInvoiceData"],
        customerInvoiceData: json["CustomerInvoiceData"],
      );

  Map<String, dynamic> toJson() => {
        "MerchantInvoiceData": merchantInvoiceData,
        "CustomerInvoiceData": customerInvoiceData,
      };
}

class SetMenuDetailModel {
  String? id;
  String? setMenuId;
  String? paidQuantity;
  String? paidAmount;
  String? currentPaidQuantity;
  String? surChargeAmount;
  bool? isPublicHolidaySurchargeUsed;
  bool? isCreditCardSurchargeUsed;
  bool? isServiceChargeUsed;
  // eod report
  String? finalTotalSellingAmount;
  String? finalTotalTax;
  String? finalTotalDiscount;
  String? finalTotalDiscountWithTax;

  SetMenuDetailModel({
    this.id,
    this.setMenuId,
    this.paidQuantity,
    this.paidAmount,
    this.currentPaidQuantity,
    this.surChargeAmount,
    this.isPublicHolidaySurchargeUsed,
    this.isCreditCardSurchargeUsed,
    this.isServiceChargeUsed,
    this.finalTotalSellingAmount,
    this.finalTotalTax,
    this.finalTotalDiscount,
    this.finalTotalDiscountWithTax,
  });

  factory SetMenuDetailModel.fromJson(Map<String, dynamic> json) =>
      SetMenuDetailModel(
        id: json["Id"],
        setMenuId: json["SetMenuId"],
        paidQuantity: json["PaidQuantity"],
        paidAmount: json["PaidAmount"],
        currentPaidQuantity: json["CurrentPaidQuantity"],
        surChargeAmount: json["SurChargeAmount"],
        isPublicHolidaySurchargeUsed: json["IsPublicHolidaySurchargeUsed"],
        isCreditCardSurchargeUsed: json["IsCreditCardSurchargeUsed"],
        isServiceChargeUsed: json["IsServiceChargeUsed"],
        finalTotalSellingAmount: json["FinalTotalSellingAmount"],
        finalTotalTax: json["FinalTotalTax"],
        finalTotalDiscount: json["FinalTotalDiscount"],
        finalTotalDiscountWithTax: json["FinalTotalDiscountWithTax"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "SetMenuId": setMenuId,
        "PaidQuantity": paidQuantity,
        "PaidAmount": paidAmount,
        "CurrentPaidQuantity": currentPaidQuantity,
        "SurChargeAmount": surChargeAmount,
        "IsPublicHolidaySurchargeUsed": isPublicHolidaySurchargeUsed,
        "IsCreditCardSurchargeUsed": isCreditCardSurchargeUsed,
        "IsServiceChargeUsed": isServiceChargeUsed,
        "FinalTotalSellingAmount": finalTotalSellingAmount,
        "FinalTotalTax": finalTotalTax,
        "FinalTotalDiscount": finalTotalDiscount,
        "FinalTotalDiscountWithTax": finalTotalDiscountWithTax,
      };
}

class RawLooseIngredientDetail {
  String? id;
  String? paidQuantity;
  String? currentPaidQuantity;
  String? paidAmount;
  String? surChargeAmount;
  bool? isCreditCardSurchargeUsed;
  bool? isPublicHolidaySurchargeUsed;
  bool? isServiceChargeUsed;
  // eod report
  String? finalTotalSellingAmount;
  String? finalTotalTax;
  String? finalTotalDiscount;
  String? finalTotalDiscountWithTax;

  RawLooseIngredientDetail({
    this.id,
    this.paidQuantity,
    this.currentPaidQuantity,
    this.paidAmount,
    this.surChargeAmount,
    this.isCreditCardSurchargeUsed,
    this.isPublicHolidaySurchargeUsed,
    this.isServiceChargeUsed,
    this.finalTotalSellingAmount,
    this.finalTotalTax,
    this.finalTotalDiscount,
    this.finalTotalDiscountWithTax,
  });

  factory RawLooseIngredientDetail.fromJson(Map<String, dynamic> json) =>
      RawLooseIngredientDetail(
        id: json["Id"],
        paidQuantity: json["PaidQuantity"],
        currentPaidQuantity: json["CurrentPaidQuantity"],
        paidAmount: json["PaidAmount"],
        surChargeAmount: json["SurChargeAmount"],
        isCreditCardSurchargeUsed: json["IsCreditCardSurchargeUsed"],
        isPublicHolidaySurchargeUsed: json["IsPublicHolidaySurchargeUsed"],
        isServiceChargeUsed: json["IsServiceChargeUsed"],
        finalTotalSellingAmount: json["FinalTotalSellingAmount"],
        finalTotalTax: json["FinalTotalTax"],
        finalTotalDiscount: json["FinalTotalDiscount"],
        finalTotalDiscountWithTax: json["FinalTotalDiscountWithTax"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "PaidQuantity": paidQuantity,
        "CurrentPaidQuantity": currentPaidQuantity,
        "PaidAmount": paidAmount,
        "SurChargeAmount": surChargeAmount,
        "IsCreditCardSurchargeUsed": isCreditCardSurchargeUsed,
        "IsPublicHolidaySurchargeUsed": isPublicHolidaySurchargeUsed,
        "IsServiceChargeUsed": isServiceChargeUsed,
        "FinalTotalSellingAmount": finalTotalSellingAmount,
        "FinalTotalTax": finalTotalTax,
        "FinalTotalDiscount": finalTotalDiscount,
        "FinalTotalDiscountWithTax": finalTotalDiscountWithTax,
      };
}

class OrderDiscountModel {
  String? discountTypeId; //promotionid,discountid,voucherid,GiftCardId
  String? discountPercentage;
  String? discountAmount;
  String? discountAmountWithTax;
  String? discountType; //General,Promotion,Voucher
  String? name; //discount name
  String? code; //voucher code
  double discountTax;

  OrderDiscountModel({
    this.discountTypeId,
    this.discountPercentage,
    this.discountAmount,
    this.discountAmountWithTax,
    this.discountType,
    this.name,
    this.code,
    this.discountTax = 0.0,
  });

  factory OrderDiscountModel.fromJson(Map<String, dynamic> json) =>
      OrderDiscountModel(
        discountTypeId: json["discountTypeId"],
        discountPercentage: json["discountPercentage"],
        discountAmount: json["discountAmount"],
        discountAmountWithTax: json["discountAmountWithTax"],
        discountType: json["discountType"],
        name: json["name"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "discountTypeId": discountTypeId,
        "discountPercentage": discountPercentage,
        "discountAmount": discountAmount,
        "discountAmountWithTax": discountAmountWithTax,
        "discountType": discountType,
        "name": name,
        "code": code,
      };
}

enum DiscountType { General, Promotion, GiftCard, Voucher }
