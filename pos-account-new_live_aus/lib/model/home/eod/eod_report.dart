class EodReportRes {
  EodReportStoreInformationViewModel? eodReportStoreInformationViewModel;
  EodSalesSummaryViewModel? eodSalesSummaryViewModel;
  EodSalesReedemptionViewModel? eodSalesReedemptionViewModel;
  List<EodSalesByChannelViewModel>? eodSalesByChannelViewModel;
  List<EodSalesByPaymentMethodViewModel>? eodSalesByPaymentMethodViewModel;
  List<EodSalesByCategoryTypeViewModel>? eodSalesByCategoryTypeViewModel;
  List<EodSalesByCategoryViewModel>? eodSalesByCategoryViewModel;
  List<PosPrinterResponseViewModel>? posPrinterResponseViewModels;

  EodReportRes({
    this.eodReportStoreInformationViewModel,
    this.eodSalesSummaryViewModel,
    this.eodSalesReedemptionViewModel,
    this.eodSalesByChannelViewModel,
    this.eodSalesByPaymentMethodViewModel,
    this.eodSalesByCategoryTypeViewModel,
    this.eodSalesByCategoryViewModel,
    this.posPrinterResponseViewModels,
  });

  factory EodReportRes.fromJson(Map<String, dynamic> json) => EodReportRes(
        eodReportStoreInformationViewModel:
            json["eodReportStoreInformationViewModel"] == null
                ? null
                : EodReportStoreInformationViewModel.fromJson(
                    json["eodReportStoreInformationViewModel"]),
        eodSalesSummaryViewModel: json["eodSalesSummaryViewModel"] == null
            ? null
            : EodSalesSummaryViewModel.fromJson(
                json["eodSalesSummaryViewModel"]),
        eodSalesReedemptionViewModel:
            json["eodSalesReedemptionViewModel"] == null
                ? null
                : EodSalesReedemptionViewModel.fromJson(
                    json["eodSalesReedemptionViewModel"]),
        eodSalesByChannelViewModel: json["eodSalesByChannelViewModel"] == null
            ? []
            : List<EodSalesByChannelViewModel>.from(
                json["eodSalesByChannelViewModel"]!
                    .map((x) => EodSalesByChannelViewModel.fromJson(x))),
        eodSalesByPaymentMethodViewModel:
            json["eodSalesByPaymentMethodViewModel"] == null
                ? []
                : List<EodSalesByPaymentMethodViewModel>.from(
                    json["eodSalesByPaymentMethodViewModel"]!.map(
                        (x) => EodSalesByPaymentMethodViewModel.fromJson(x))),
        eodSalesByCategoryTypeViewModel:
            json["eodSalesByCategoryTypeViewModel"] == null
                ? []
                : List<EodSalesByCategoryTypeViewModel>.from(
                    json["eodSalesByCategoryTypeViewModel"]!.map(
                        (x) => EodSalesByCategoryTypeViewModel.fromJson(x))),
        eodSalesByCategoryViewModel: json["eodSalesByCategoryViewModel"] == null
            ? []
            : List<EodSalesByCategoryViewModel>.from(
                json["eodSalesByCategoryViewModel"]!
                    .map((x) => EodSalesByCategoryViewModel.fromJson(x))),
        posPrinterResponseViewModels:
            json["posPrinterResponseViewModels"] == null
                ? []
                : List<PosPrinterResponseViewModel>.from(
                    json["posPrinterResponseViewModels"]!
                        .map((x) => PosPrinterResponseViewModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "eodReportStoreInformationViewModel":
            eodReportStoreInformationViewModel?.toJson(),
        "eodSalesSummaryViewModel": eodSalesSummaryViewModel?.toJson(),
        "eodSalesReedemptionViewModel": eodSalesReedemptionViewModel?.toJson(),
        "eodSalesByChannelViewModel": eodSalesByChannelViewModel == null
            ? []
            : List<dynamic>.from(
                eodSalesByChannelViewModel!.map((x) => x.toJson())),
        "eodSalesByPaymentMethodViewModel":
            eodSalesByPaymentMethodViewModel == null
                ? []
                : List<dynamic>.from(
                    eodSalesByPaymentMethodViewModel!.map((x) => x.toJson())),
        "eodSalesByCategoryTypeViewModel":
            eodSalesByCategoryTypeViewModel == null
                ? []
                : List<dynamic>.from(
                    eodSalesByCategoryTypeViewModel!.map((x) => x.toJson())),
        "eodSalesByCategoryViewModel": eodSalesByCategoryViewModel == null
            ? []
            : List<dynamic>.from(
                eodSalesByCategoryViewModel!.map((x) => x.toJson())),
        "posPrinterResponseViewModels": posPrinterResponseViewModels == null
            ? []
            : List<dynamic>.from(
                posPrinterResponseViewModels!.map((x) => x.toJson())),
      };
}

class EodReportStoreInformationViewModel {
  String? name;
  String? address;
  String? dateTime;

  EodReportStoreInformationViewModel({
    this.name,
    this.address,
    this.dateTime,
  });

  factory EodReportStoreInformationViewModel.fromJson(
          Map<String, dynamic> json) =>
      EodReportStoreInformationViewModel(
        name: json["name"],
        address: json["address"],
        dateTime: json["dateTime"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "address": address,
        "dateTime": dateTime,
      };
}

class EodSalesByCategoryTypeViewModel {
  String? totalSales;
  String? categoryTypeName;
  String? quantity;

  EodSalesByCategoryTypeViewModel({
    this.totalSales,
    this.categoryTypeName,
    this.quantity,
  });

  factory EodSalesByCategoryTypeViewModel.fromJson(Map<String, dynamic> json) =>
      EodSalesByCategoryTypeViewModel(
        totalSales: json["totalSales"],
        categoryTypeName: json["categoryTypeName"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "totalSales": totalSales,
        "categoryTypeName": categoryTypeName,
        "quantity": quantity,
      };
}

class EodSalesByCategoryViewModel {
  String? totalSales;
  String? categoryName;
  String? quantity;

  EodSalesByCategoryViewModel({
    this.totalSales,
    this.categoryName,
    this.quantity,
  });

  factory EodSalesByCategoryViewModel.fromJson(Map<String, dynamic> json) =>
      EodSalesByCategoryViewModel(
        totalSales: json["totalSales"],
        categoryName: json["categoryName"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "totalSales": totalSales,
        "categoryName": categoryName,
        "quantity": quantity,
      };
}

class EodSalesByChannelViewModel {
  String? totalSales;
  String? channelName;
  String? quantity;

  EodSalesByChannelViewModel({
    this.totalSales,
    this.channelName,
    this.quantity,
  });

  factory EodSalesByChannelViewModel.fromJson(Map<String, dynamic> json) =>
      EodSalesByChannelViewModel(
        totalSales: json["totalSales"],
        channelName: json["channelName"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "totalSales": totalSales,
        "channelName": channelName,
        "quantity": quantity,
      };
}

class EodSalesByPaymentMethodViewModel {
  String? totalSales;
  String? paymentMethodName;

  EodSalesByPaymentMethodViewModel({
    this.totalSales,
    this.paymentMethodName,
  });

  factory EodSalesByPaymentMethodViewModel.fromJson(
          Map<String, dynamic> json) =>
      EodSalesByPaymentMethodViewModel(
        totalSales: json["totalSales"],
        paymentMethodName: json["paymentMethodName"],
      );

  Map<String, dynamic> toJson() => {
        "totalSales": totalSales,
        "paymentMethodName": paymentMethodName,
      };
}

class EodSalesSummaryViewModel {
  String? totalGrossSales;
  String? totalDiscount;
  String? totalRefund;
  String? totalCreditCardSurcharge;
  String? totalHolidaySurcharge;
  String? totalServiceCharge;
  String? totalTip;
  String? totalTax;
  String? totalDeliveryCharge;
  String? totalGiftCardSales;

  EodSalesSummaryViewModel({
    this.totalGrossSales,
    this.totalDiscount,
    this.totalRefund,
    this.totalCreditCardSurcharge,
    this.totalHolidaySurcharge,
    this.totalServiceCharge,
    this.totalTip,
    this.totalTax,
    this.totalDeliveryCharge,
    this.totalGiftCardSales,
  });

  factory EodSalesSummaryViewModel.fromJson(Map<String, dynamic> json) =>
      EodSalesSummaryViewModel(
        totalGrossSales: json["totalGrossSales"],
        totalDiscount: json["totalDiscount"],
        totalRefund: json["totalRefund"],
        totalCreditCardSurcharge: json["totalCreditCardSurcharge"],
        totalHolidaySurcharge: json["totalHolidaySurcharge"],
        totalServiceCharge: json["totalServiceCharge"],
        totalTip: json["totalTip"],
        totalTax: json["totalTax"],
        totalDeliveryCharge: json["totalDeliveryCharge"],
        totalGiftCardSales: json["totalGiftCardSales"],
      );

  Map<String, dynamic> toJson() => {
        "totalGrossSales": totalGrossSales,
        "totalDiscount": totalDiscount,
        "totalRefund": totalRefund,
        "totalCreditCardSurcharge": totalCreditCardSurcharge,
        "totalHolidaySurcharge": totalHolidaySurcharge,
        "totalServiceCharge": totalServiceCharge,
        "totalTip": totalTip,
        "totalTax": totalTax,
        "totalDeliveryCharge": totalDeliveryCharge,
        "totalGiftCardSales": totalGiftCardSales,
      };
}

class PosPrinterResponseViewModel {
  String? message;
  String? ipAddress;
  String? port;
  bool? isBluetoothPrinter;
  String? printerType;
  bool? orderPrintCopy;
  bool? printBillCustomerCopy;
  bool? openCashRegister;
  bool? printEftPosSignature;

  PosPrinterResponseViewModel({
    this.message,
    this.ipAddress,
    this.port,
    this.isBluetoothPrinter,
    this.printerType,
    this.orderPrintCopy,
    this.printBillCustomerCopy,
    this.openCashRegister,
    this.printEftPosSignature,
  });

  factory PosPrinterResponseViewModel.fromJson(Map<String, dynamic> json) =>
      PosPrinterResponseViewModel(
        message: json["message"],
        ipAddress: json["ipAddress"],
        port: json["port"],
        isBluetoothPrinter: json["isBluetoothPrinter"],
        printerType: json["printerType"],
        orderPrintCopy: json["orderPrintCopy"],
        printBillCustomerCopy: json["printBillCustomerCopy"],
        openCashRegister: json["openCashRegister"],
        printEftPosSignature: json["printEftPosSignature"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "ipAddress": ipAddress,
        "port": port,
        "isBluetoothPrinter": isBluetoothPrinter,
        "printerType": printerType,
        "orderPrintCopy": orderPrintCopy,
        "printBillCustomerCopy": printBillCustomerCopy,
        "openCashRegister": openCashRegister,
        "printEftPosSignature": printEftPosSignature,
      };
}

class EodSalesReedemptionViewModel {
  String? totalGiftCardReedemption;
  String? totalLoyaltyReedemption;

  EodSalesReedemptionViewModel({
    this.totalGiftCardReedemption,
    this.totalLoyaltyReedemption,
  });

  factory EodSalesReedemptionViewModel.fromJson(Map<String, dynamic> json) =>
      EodSalesReedemptionViewModel(
        totalGiftCardReedemption: json["totalGiftCardReedemption"],
        totalLoyaltyReedemption: json["totalLoyaltyReedemption"],
      );

  Map<String, dynamic> toJson() => {
        "totalGiftCardReedemption": totalGiftCardReedemption,
        "totalLoyaltyReedemption": totalLoyaltyReedemption,
      };
}
