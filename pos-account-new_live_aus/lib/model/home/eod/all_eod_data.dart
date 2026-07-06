import 'package:flutter/material.dart';

class AllEodData {
  AllEodData({
    this.message,
    this.currencySymbol,
    this.eodSaleReconcilation,
    this.eodChartOfAccountPayment,
  });

  String? message;
  String? currencySymbol;
  EodSaleReconcilation? eodSaleReconcilation;
  List<EodChartOfAccountPayment>? eodChartOfAccountPayment;

  factory AllEodData.fromJson(Map<String, dynamic> json) => AllEodData(
        message: json["message"],
        currencySymbol: json["currencySymbol"],
        eodSaleReconcilation: json["eodSaleReconcilation"] == null
            ? null
            : EodSaleReconcilation.fromJson(json["eodSaleReconcilation"]),
        eodChartOfAccountPayment: json["eodChartOfAccountPayment"] == null
            ? null
            : List<EodChartOfAccountPayment>.from(
                json["eodChartOfAccountPayment"]
                    .map((x) => EodChartOfAccountPayment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "currencySymbol": currencySymbol,
        "eodSaleReconcilation": eodSaleReconcilation?.toJson(),
        "eodChartOfAccountPayment": eodChartOfAccountPayment == null
            ? null
            : List<dynamic>.from(
                eodChartOfAccountPayment!.map((x) => x.toJson())),
      };
}

class EodChartOfAccountPayment {
  EodChartOfAccountPayment({
    this.name,
    this.storeChartOfAccountId,
    this.chartOfAccountCode,
    this.accountingPlatFormId,
    this.amount,
    this.sortOrder,
    this.chartOfAccountNameEnum,
    this.formattedAmount,
    this.textCltr,
    this.readOnly = false,
  });

  String? name;
  String? storeChartOfAccountId;
  String? chartOfAccountCode;
  String? accountingPlatFormId;
  String? amount;
  int? sortOrder;
  String? chartOfAccountNameEnum;
  String? formattedAmount;
  TextEditingController? textCltr;
  bool readOnly;

  factory EodChartOfAccountPayment.fromJson(Map<String, dynamic> json) =>
      EodChartOfAccountPayment(
        name: json["name"],
        storeChartOfAccountId: json["storeChartOfAccountId"],
        chartOfAccountCode: json["chartOfAccountCode"],
        accountingPlatFormId: json["accountingPlatFormId"],
        amount: json["amount"],
        sortOrder: json["sortOrder"],
        chartOfAccountNameEnum: json["chartOfAccountNameEnum"],
        formattedAmount: json["formattedAmount"],
      );

  Map<String, dynamic> toJson() => {
        "Name": name,
        "StoreChartOfAccountId": storeChartOfAccountId,
        "ChartOfAccountCode": chartOfAccountCode,
        "AccountingPlatFormId": accountingPlatFormId,
        "Amount": amount,
        "SortOrder": sortOrder,
        "ChartOfAccountNameEnum": chartOfAccountNameEnum,
        "FormattedAmount": formattedAmount,
      };
}

class EodSaleReconcilation {
  EodSaleReconcilation({
    this.posSales,
    this.onlineOrderSales,
    this.qrOrderSales,
    this.uberEatsSales,
    this.doorDashSales,
    this.menuLogSales,
    // this.centralizedSales,
    this.discount,
    this.refund,
    this.gstOrTax,
    this.cashIn,
    this.cashOut,
    this.kioskOrderSales,
  });

  String? posSales;
  String? onlineOrderSales;
  String? qrOrderSales;
  String? uberEatsSales;
  String? doorDashSales;
  String? menuLogSales;
  // String? centralizedSales;
  String? discount;
  String? refund;
  String? gstOrTax;
  String? cashIn;
  String? cashOut;
  String? kioskOrderSales;

  factory EodSaleReconcilation.fromJson(Map<String, dynamic> json) =>
      EodSaleReconcilation(
        posSales: json["posSales"],
        onlineOrderSales: json["onlineOrderSales"],
        qrOrderSales: json["qrOrderSales"],
        kioskOrderSales: json["kioskOrderSales"],
        uberEatsSales: json["uberEatsSales"],
        doorDashSales: json["doorDashSales"],
        menuLogSales: json["menuLogSales"],

        // centralizedSales: json["centralizedSales"],
        discount: json["discount"],
        refund: json["refund"],
        gstOrTax: json["gstOrTax"],
        cashIn: json["cashIn"],
        cashOut: json["cashOut"],
      );

  Map<String, dynamic> toJson() => {
        "posSales": posSales,
        "onlineOrderSales": onlineOrderSales,
        "qrOrderSales": qrOrderSales,
        "kioskOrderSales": kioskOrderSales,
        "uberEatsSales": uberEatsSales,
        "doorDashSales": doorDashSales,
        "menuLogSales": menuLogSales,
        // "centralizedSales": centralizedSales,
        "discount": discount,
        "refund": refund,
        "gstOrTax": gstOrTax,
        "cashIn": cashIn,
        "cashOut": cashOut,
      };
}
