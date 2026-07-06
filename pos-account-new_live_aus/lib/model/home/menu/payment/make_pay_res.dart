import 'package:pos_account/model/home/menu/place_order/place_order_res.dart';

class MakePaymentRes {
  MakePaymentRes({
    this.message,
    this.askForPrintConfirmation,
    this.orderId,
    this.isPaymentCompleted,
    this.remainingAmount,
    this.url,
    this.taxType,
    this.printingInvoiceDetailsResponseViewModels,
    this.printingMerchantInvoiceDetailsResponseViewModels,
    this.reviewQuestionUserViewModel,
    // this.sendToKitchenPrinter,
    // this.sendToKitchenDisplay,
  });

  String? message;
  bool? askForPrintConfirmation;

  String? orderId;
  bool? isPaymentCompleted;
  String? remainingAmount;
  String? url;
  String? taxType;
  List<PrintingInvoiceDetailsResponseViewModel>?
      printingInvoiceDetailsResponseViewModels;
  List<PrintingMerchantInvoiceDetailsResponseViewModel>?
      printingMerchantInvoiceDetailsResponseViewModels;

  ReviewQuestionUserViewModel? reviewQuestionUserViewModel;
  // bool? sendToKitchenPrinter;
  // bool? sendToKitchenDisplay;

  factory MakePaymentRes.fromJson(Map<String, dynamic> json) => MakePaymentRes(
        message: json["message"],
        askForPrintConfirmation: json["askForPrintConfirmation"],
        orderId: json["orderId"],
        taxType: json["taxType"],
        isPaymentCompleted: json["isPaymentCompleted"],
        remainingAmount: json["remainingAmount"],
        url: json["url"],
        printingInvoiceDetailsResponseViewModels:
            json["printingInvoiceDetailsResponseViewModels"] == null
                ? null
                : List<PrintingInvoiceDetailsResponseViewModel>.from(
                    json["printingInvoiceDetailsResponseViewModels"].map((x) =>
                        PrintingInvoiceDetailsResponseViewModel.fromJson(x))),
        printingMerchantInvoiceDetailsResponseViewModels:
            json["printingMerchantInvoiceDetailsResponseViewModels"] == null
                ? []
                : List<PrintingMerchantInvoiceDetailsResponseViewModel>.from(
                    json["printingMerchantInvoiceDetailsResponseViewModels"]!
                        .map((x) =>
                            PrintingMerchantInvoiceDetailsResponseViewModel
                                .fromJson(x))),
        reviewQuestionUserViewModel: json["reviewQuestionUserViewModel"] == null
            ? null
            : ReviewQuestionUserViewModel.fromJson(
                json["reviewQuestionUserViewModel"]),
        // sendToKitchenPrinter: json["sendToKitchenPrinter"],
        // sendToKitchenDisplay: json["sendToKitchenDisplay"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "askForPrintConfirmation": askForPrintConfirmation,
        "orderId": orderId,
        "taxType": taxType,
        "isPaymentCompleted": isPaymentCompleted,
        "remainingAmount": remainingAmount,
        "url": url,
        "printingInvoiceDetailsResponseViewModels":
            printingInvoiceDetailsResponseViewModels == null
                ? null
                : List<dynamic>.from(printingInvoiceDetailsResponseViewModels!
                    .map((x) => x.toJson())),
        "printingMerchantInvoiceDetailsResponseViewModels":
            printingMerchantInvoiceDetailsResponseViewModels == null
                ? []
                : List<dynamic>.from(
                    printingMerchantInvoiceDetailsResponseViewModels!
                        .map((x) => x.toJson())),
        "reviewQuestionUserViewModel": reviewQuestionUserViewModel?.toJson(),
        // "sendToKitchenPrinter": sendToKitchenPrinter,
        // "sendToKitchenDisplay": sendToKitchenDisplay,
      };
}

class PrintingInvoiceDetailsResponseViewModel {
  PrintingInvoiceDetailsResponseViewModel({
    this.customerName,
    this.discount,
    this.totalAmount,
    this.publicHolidaySurCharge,
    this.creditCardSurchargeAmount,
    this.publicHolidaySurChargeWithTax,
    this.creditCardSurchargeAmountWithTax,
    this.serviceChargeAmount,
    this.serviceChargePercentage,
    this.discountWithTax,
    this.deliveryAmount,
    this.deliveryAmountWithTax,
    this.tax,
    this.taxExclusiveInclusiveType,
    this.tipAmount,
    this.total,
    this.storeName,
    this.storeAddress,
    this.tableNumber,
    this.orderNumber,
    this.invoiceNumber,
    this.abnNumber,
    this.date,
    this.posName,
    this.ipAddress,
    this.port,
    this.paperSize,
    this.description,
    this.orderType,
    this.channel,
    this.paymentMethod,
    this.message,
    this.isBluetoothPrinter,
    this.paymentProcessBy,
    this.printBillCustomerCopy,
    this.openCashRegister,
    this.deliveryLocation,
    this.customerPhoneNumber,
    this.orderItemsDetailsResponseViewModels,
    this.setMenuOrderOrderDetailsResponseViewModels,
    this.rawLooseOrderItemsDetailsResponseViewModels,
    this.printerType,
    this.holidaySurchargeType,
    this.loyaltyPointsResponseModel,
    this.paymentMethodsSummary,
  });

  String? customerName;
  String? discount;
  String? totalAmount;
  String? publicHolidaySurCharge;
  String? creditCardSurchargeAmount;
  String? serviceChargeAmount;
  String? serviceChargePercentage;
  String? tax;
  String? taxExclusiveInclusiveType;
  String? tipAmount;
  String? publicHolidaySurChargeWithTax;
  String? creditCardSurchargeAmountWithTax;
  String? discountWithTax;
  String? deliveryAmount;
  String? deliveryAmountWithTax;
  String? total;
  String? storeName;
  String? storeAddress;
  String? tableNumber;
  String? orderNumber;
  String? invoiceNumber;
  String? abnNumber;
  String? date;
  String? posName;
  String? ipAddress;
  String? port;
  String? paperSize;
  String? description;
  String? orderType;
  String? channel;
  String? paymentMethod;
  String? message;
  bool? isBluetoothPrinter;
  String? paymentProcessBy;
  bool? printBillCustomerCopy;
  bool? openCashRegister;
  String? deliveryLocation;
  String? customerPhoneNumber;
  String? printerType;
  String? holidaySurchargeType;
  LoyaltyPointsResponseModel? loyaltyPointsResponseModel;

  List<OrderItemsDetailsResponseViewModel>? orderItemsDetailsResponseViewModels;
  List<SetMenuOrderOrderDetailsResponseViewModel>?
      setMenuOrderOrderDetailsResponseViewModels;
  List<RawLooseOrderItemsDetailsResponseViewModel>?
      rawLooseOrderItemsDetailsResponseViewModels;
  List<PaymentMethodsSummary>? paymentMethodsSummary;

  factory PrintingInvoiceDetailsResponseViewModel.fromJson(
          Map<String, dynamic> json) =>
      PrintingInvoiceDetailsResponseViewModel(
        customerName: json["customerName"],
        discount: json["discount"],
        totalAmount: json["totalAmount"],
        publicHolidaySurCharge: json["publicHolidaySurCharge"],
        creditCardSurchargeAmount: json["creditCardSurchargeAmount"],
        tax: json["tax"],
        taxExclusiveInclusiveType: json["taxExclusiveInclusiveType"],
        publicHolidaySurChargeWithTax: json["publicHolidaySurChargeWithTax"],
        creditCardSurchargeAmountWithTax:
            json["creditCardSurchargeAmountWithTax"],
        serviceChargeAmount: json["serviceChargeAmount"],
        serviceChargePercentage: json["serviceChargePercentage"],
        discountWithTax: json["discountWithTax"],
        tipAmount: json["tipAmount"],
        deliveryAmount: json["deliveryAmount"],
        deliveryAmountWithTax: json["deliveryAmountWithTax"],
        total: json["total"],
        storeName: json["storeName"],
        storeAddress: json["storeAddress"],
        tableNumber: json["tableNumber"],
        orderNumber: json["orderNumber"],
        invoiceNumber: json["invoiceNumber"],
        abnNumber: json["abnNumber"],
        date: json["date"],
        posName: json["posName"],
        ipAddress: json["ipAddress"],
        port: json["port"],
        paperSize: json["paperSize"],
        description: json["description"],
        orderType: json["orderType"],
        channel: json["channel"],
        paymentMethod: json["paymentMethod"],
        message: json["message"],
        isBluetoothPrinter: json["isBluetoothPrinter"],
        paymentProcessBy: json["paymentProcessBy"],
        printBillCustomerCopy: json["printBillCustomerCopy"],
        openCashRegister: json["openCashRegister"],
        deliveryLocation: json["deliveryLocation"],
        customerPhoneNumber: json["customerPhoneNumber"],
        orderItemsDetailsResponseViewModels:
            json["orderItemsDetailsResponseViewModels"] == null
                ? null
                : List<OrderItemsDetailsResponseViewModel>.from(
                    json["orderItemsDetailsResponseViewModels"].map(
                        (x) => OrderItemsDetailsResponseViewModel.fromJson(x))),
        setMenuOrderOrderDetailsResponseViewModels:
            json["setMenuOrderOrderDetailsResponseViewModels"] == null
                ? null
                : List<SetMenuOrderOrderDetailsResponseViewModel>.from(json[
                        "setMenuOrderOrderDetailsResponseViewModels"]
                    .map((x) =>
                        SetMenuOrderOrderDetailsResponseViewModel.fromJson(x))),
        rawLooseOrderItemsDetailsResponseViewModels: json[
                    "rawLooseOrderItemsDetailsResponseViewModels"] ==
                null
            ? []
            : List<RawLooseOrderItemsDetailsResponseViewModel>.from(
                json["rawLooseOrderItemsDetailsResponseViewModels"]!.map((x) =>
                    RawLooseOrderItemsDetailsResponseViewModel.fromJson(x))),
        printerType: json["printerType"],
        holidaySurchargeType: json["holidaySurchargeType"],
        loyaltyPointsResponseModel: json["loyaltyPointsResponseModel"] == null
            ? null
            : LoyaltyPointsResponseModel.fromJson(
                json["loyaltyPointsResponseModel"]),
        paymentMethodsSummary: json["paymentMethodsSummary"] == null
            ? []
            : List<PaymentMethodsSummary>.from(json["paymentMethodsSummary"]!
                .map((x) => PaymentMethodsSummary.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "customerName": customerName,
        "discount": discount,
        "totalAmount": totalAmount,
        "publicHolidaySurCharge": publicHolidaySurCharge,
        "creditCardSurchargeAmount": creditCardSurchargeAmount,
        "serviceChargeAmount": serviceChargeAmount,
        "serviceChargePercentage": serviceChargePercentage,
        "tax": tax,
        "taxExclusiveInclusiveType": taxExclusiveInclusiveType,
        "tipAmount": tipAmount,
        "total": total,
        "storeName": storeName,
        "publicHolidaySurChargeWithTax": publicHolidaySurChargeWithTax,
        "creditCardSurchargeAmountWithTax": creditCardSurchargeAmountWithTax,
        "discountWithTax": discountWithTax,
        "deliveryAmount": deliveryAmount,
        "deliveryAmountWithTax": deliveryAmountWithTax,
        "storeAddress": storeAddress,
        "tableNumber": tableNumber,
        "orderNumber": orderNumber,
        "invoiceNumber": invoiceNumber,
        "abnNumber": abnNumber,
        "date": date,
        "posName": posName,
        "ipAddress": ipAddress,
        "port": port,
        "paperSize": paperSize,
        "description": description,
        "orderType": orderType,
        "channel": channel,
        "paymentMethod": paymentMethod,
        "message": message,
        "isBluetoothPrinter": isBluetoothPrinter,
        "paymentProcessBy": paymentProcessBy,
        "printBillCustomerCopy": printBillCustomerCopy,
        "openCashRegister": openCashRegister,
        "deliveryLocation": deliveryLocation,
        "customerPhoneNumber": customerPhoneNumber,
        "orderItemsDetailsResponseViewModels":
            orderItemsDetailsResponseViewModels == null
                ? null
                : List<dynamic>.from(orderItemsDetailsResponseViewModels!
                    .map((x) => x.toJson())),
        "setMenuOrderOrderDetailsResponseViewModels":
            setMenuOrderOrderDetailsResponseViewModels == null
                ? null
                : List<dynamic>.from(setMenuOrderOrderDetailsResponseViewModels!
                    .map((x) => x.toJson())),
        "rawLooseOrderItemsDetailsResponseViewModels":
            rawLooseOrderItemsDetailsResponseViewModels == null
                ? []
                : List<dynamic>.from(
                    rawLooseOrderItemsDetailsResponseViewModels!
                        .map((x) => x.toJson())),
        "printerType": printerType,
        "holidaySurchargeType": holidaySurchargeType,
        "loyaltyPointsResponseModel": loyaltyPointsResponseModel?.toJson(),
        "paymentMethodsSummary": paymentMethodsSummary == null
            ? []
            : List<dynamic>.from(paymentMethodsSummary!.map((x) => x.toJson())),
      };
}

class ReviewQuestionUserViewModel {
  String? userId;
  List<ReviewQuestions>? reviewQuestions;
  String? description;

  ReviewQuestionUserViewModel({this.userId, this.reviewQuestions});

  ReviewQuestionUserViewModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    if (json['reviewQuestions'] != null) {
      reviewQuestions = <ReviewQuestions>[];
      json['reviewQuestions'].forEach((v) {
        reviewQuestions!.add(ReviewQuestions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    if (reviewQuestions != null) {
      data['reviewQuestions'] =
          reviewQuestions!.map((v) => v.toJson()).toList();
    }
    data['description'] = description;
    return data;
  }
}

class ReviewQuestions {
  String? id;
  String? question;
  String? ratings;

  ReviewQuestions({this.id, this.question});

  ReviewQuestions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['question'] = question;
    data['ratings'] = ratings;
    return data;
  }
}

class PrintingMerchantInvoiceDetailsResponseViewModel {
  String? storeName;
  String? storeAddress;
  String? posName;
  String? ipAddress;
  String? port;
  String? paperSize;
  String? tid;
  String? mid;
  String? rrn;
  String? stan;
  String? auth;
  String? amex;
  String? tvr;
  String? arqc;
  String? purchase;
  String? approved;
  String? merchant;
  String? merchantInvoiceData;
  String? customerInvoiceData;
  bool? isBluetoothPrinter;
  String? printerType;

  PrintingMerchantInvoiceDetailsResponseViewModel({
    this.storeName,
    this.storeAddress,
    this.posName,
    this.ipAddress,
    this.port,
    this.paperSize,
    this.tid,
    this.mid,
    this.rrn,
    this.stan,
    this.auth,
    this.amex,
    this.tvr,
    this.arqc,
    this.purchase,
    this.approved,
    this.merchant,
    this.merchantInvoiceData,
    this.customerInvoiceData,
    this.isBluetoothPrinter,
    this.printerType,
  });

  factory PrintingMerchantInvoiceDetailsResponseViewModel.fromJson(
          Map<String, dynamic> json) =>
      PrintingMerchantInvoiceDetailsResponseViewModel(
        storeName: json["storeName"],
        storeAddress: json["storeAddress"],
        posName: json["posName"],
        ipAddress: json["ipAddress"],
        port: json["port"],
        paperSize: json["paperSize"],
        tid: json["tid"],
        mid: json["mid"],
        rrn: json["rrn"],
        stan: json["stan"],
        auth: json["auth"],
        amex: json["amex"],
        tvr: json["tvr"],
        arqc: json["arqc"],
        purchase: json["purchase"],
        approved: json["approved"],
        merchant: json["merchant"],
        merchantInvoiceData: json["merchantInvoiceData"],
        customerInvoiceData: json["customerInvoiceData"],
        isBluetoothPrinter: json["isBluetoothPrinter"],
        printerType: json["printerType"],
      );

  Map<String, dynamic> toJson() => {
        "storeName": storeName,
        "storeAddress": storeAddress,
        "posName": posName,
        "ipAddress": ipAddress,
        "port": port,
        "paperSize": paperSize,
        "tid": tid,
        "mid": mid,
        "rrn": rrn,
        "stan": stan,
        "auth": auth,
        "amex": amex,
        "tvr": tvr,
        "arqc": arqc,
        "purchase": purchase,
        "approved": approved,
        "merchant": merchant,
        "merchantInvoiceData": merchantInvoiceData,
        "customerInvoiceData": customerInvoiceData,
        "isBluetoothPrinter": isBluetoothPrinter,
        "printerType": printerType,
      };
}

class RawLooseOrderItemsDetailsResponseViewModel {
  String? itemName;
  String? quantity;
  String? unitOfMeasurement;
  String? price;

  RawLooseOrderItemsDetailsResponseViewModel({
    this.itemName,
    this.quantity,
    this.unitOfMeasurement,
    this.price,
  });

  factory RawLooseOrderItemsDetailsResponseViewModel.fromJson(
          Map<String, dynamic> json) =>
      RawLooseOrderItemsDetailsResponseViewModel(
        itemName: json["itemName"],
        quantity: json["quantity"],
        unitOfMeasurement: json["unitOfMeasurement"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "itemName": itemName,
        "quantity": quantity,
        "unitOfMeasurement": unitOfMeasurement,
        "price": price,
      };
}

class LoyaltyPointsResponseModel {
  String? pointsEarned;
  String? balancePoints;

  LoyaltyPointsResponseModel({
    this.pointsEarned,
    this.balancePoints,
  });

  factory LoyaltyPointsResponseModel.fromJson(Map<String, dynamic> json) =>
      LoyaltyPointsResponseModel(
        pointsEarned: json["pointsEarned"],
        balancePoints: json["balancePoints"],
      );

  Map<String, dynamic> toJson() => {
        "pointsEarned": pointsEarned,
        "balancePoints": balancePoints,
      };
}

class PaymentMethodsSummary {
  String? name;
  String? amount;

  PaymentMethodsSummary({
    this.name,
    this.amount,
  });

  factory PaymentMethodsSummary.fromJson(Map<String, dynamic> json) =>
      PaymentMethodsSummary(
        name: json["name"],
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "amount": amount,
      };
}
