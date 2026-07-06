class OrderPrintStatus {
  String? orderId;
  String? sessionId;
  bool? isOrderPrinted;

  OrderPrintStatus({
    this.orderId,
    this.sessionId,
    this.isOrderPrinted,
  });

  factory OrderPrintStatus.fromJson(Map<String, dynamic> json) =>
      OrderPrintStatus(
        orderId: json["orderId"],
        sessionId: json["sessionId"],
        isOrderPrinted: json["isOrderPrinted"],
      );

  Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "sessionId": sessionId,
        "isOrderPrinted": isOrderPrinted,
      };
}
