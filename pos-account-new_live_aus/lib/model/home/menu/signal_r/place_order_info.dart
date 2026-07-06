class PlaceOrderInfo {
  String? title;
  String? body;
  String? orderId;
  String? sessionId;
  String? posDeviceId;
  bool? printAllItems;
  String? extendedPickupDeliveryTimeInMins;
  bool? isSendToKitchenPrinter;
  bool? isSendToKitchenDisplay;
  bool? isPrinted;
  String? dateTime;

  PlaceOrderInfo({
    this.title,
    this.body,
    this.orderId,
    this.sessionId,
    this.posDeviceId,
    this.printAllItems,
    this.extendedPickupDeliveryTimeInMins,
    this.isSendToKitchenPrinter,
    this.isSendToKitchenDisplay,
    this.isPrinted,
    this.dateTime,
  });

  factory PlaceOrderInfo.fromJson(Map<String, dynamic> json) => PlaceOrderInfo(
        title: json["title"],
        body: json["body"],
        orderId: json["orderId"],
        sessionId: json["sessionId"],
        posDeviceId: json["posDeviceId"],
        printAllItems: json["printAllItems"],
        extendedPickupDeliveryTimeInMins:
            json["extendedPickupDeliveryTimeInMins"]?.toString(),
        isSendToKitchenPrinter: json["isSendToKitchenPrinter"],
        isSendToKitchenDisplay: json["isSendToKitchenDisplay"],
        isPrinted: json["isPrinted"],
        dateTime: json["dateTime"],
      );

  Map<String, dynamic> toJson() => {
        if (title != null) "title": title,
        if (body != null) "body": body,
        "orderId": orderId,
        if (sessionId != null) "sessionId": sessionId,
        if (posDeviceId != null) "posDeviceId": posDeviceId,
        if (printAllItems != null) "printAllItems": printAllItems,
        if (extendedPickupDeliveryTimeInMins != null)
          "extendedPickupDeliveryTimeInMins": extendedPickupDeliveryTimeInMins,
        "isSendToKitchenPrinter": isSendToKitchenPrinter,
        "isSendToKitchenDisplay": isSendToKitchenDisplay,
        if (isPrinted != null) "isPrinted": isPrinted,
        "dateTime": dateTime,
      };
}
