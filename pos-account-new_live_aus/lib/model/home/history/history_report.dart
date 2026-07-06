class HistoryReport {
  HistoryReport({
    this.data,
    this.content,
    this.total,
  });

  List<HistoryData>? data;
  String? content;
  int? total;

  factory HistoryReport.fromJson(Map<String, dynamic> json) => HistoryReport(
        data: json["data"] == null
            ? null
            : List<HistoryData>.from(
                json["data"].map((x) => HistoryData.fromJson(x))),
        content: json["content"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "content": content,
        "total": total,
      };
}

class HistoryData {
  HistoryData({
    this.date,
    this.receiptNumber,
    this.status,
    this.statusEnum,
    this.salesAmount,
    this.remainingAmount,
    this.taxAmount,
    this.tipAmount,
    this.holidayChargeAmount,
    this.creditCardSurchargeAmount,
    this.discountAmount,
    this.paymentMethod,
    this.total,
  });

  String? date;
  String? receiptNumber;
  String? status;
  String? statusEnum;
  String? salesAmount;
  String? remainingAmount;
  String? taxAmount;
  String? tipAmount;
  String? holidayChargeAmount;
  String? creditCardSurchargeAmount;
  String? discountAmount;
  String? paymentMethod;
  int? total;

  factory HistoryData.fromJson(Map<String, dynamic> json) => HistoryData(
        date: json["date"],
        receiptNumber: json["receiptNumber"],
        status: json["status"],
        statusEnum: json["statusEnum"],
        salesAmount: json["salesAmount"],
        remainingAmount: json["remainingAmount"],
        taxAmount: json["taxAmount"],
        tipAmount: json["tipAmount"],
        holidayChargeAmount: json["holidayChargeAmount"],
        creditCardSurchargeAmount: json["creditCardSurchargeAmount"],
        discountAmount: json["discountAmount"],
        paymentMethod: json["paymentMethod"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "receiptNumber": receiptNumber,
        "status": status,
        "statusEnum": statusEnum,
        "salesAmount": salesAmount,
        "remainingAmount": remainingAmount,
        "taxAmount": taxAmount,
        "tipAmount": tipAmount,
        "holidayChargeAmount": holidayChargeAmount,
        "creditCardSurchargeAmount": creditCardSurchargeAmount,
        "discountAmount": discountAmount,
        "paymentMethod": paymentMethod,
        "total": total,
      };
}
