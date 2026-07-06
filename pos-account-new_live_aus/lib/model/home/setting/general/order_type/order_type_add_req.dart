class OrderTypeAddReq {
  OrderTypeAddReq({
    this.id,
    this.orderTypeId,
    this.isActive,
    this.sortOrder,
    this.storeChannelId,
    this.displayName,
    // this.channel,
    this.enableCustomerPopUpScreen,
    this.productChannelId,
    this.enableTableSelection,
  });

  String? id;
  String? orderTypeId;
  bool? isActive;
  int? sortOrder;
  String? storeChannelId;
  String? displayName;
  // String? channel;
  bool? enableCustomerPopUpScreen;
  String? productChannelId;
  bool? enableTableSelection;

  factory OrderTypeAddReq.fromJson(Map<String, dynamic> json) =>
      OrderTypeAddReq(
        id: json["id"],
        orderTypeId: json["orderTypeId"],
        isActive: json["isActive"],
        sortOrder: json["sortOrder"],
        storeChannelId: json["channelId"],
        displayName: json["displayName"],
        // channel: json["channel"],
        enableCustomerPopUpScreen: json["enableCustomerPopUpScreen"],
        productChannelId: json["productChannelId"],
        enableTableSelection: json["enableTableSelection"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "OrderTypeId": orderTypeId,
        "IsActive": isActive,
        "SortOrder": sortOrder,
        "ChannelId": storeChannelId,
        "DisplayName": displayName,
        // "Channel": channel,
        "EnableCustomerPopUpScreen": enableCustomerPopUpScreen,
        "productChannelId": productChannelId,
        "enableTableSelection": enableTableSelection,
      };
}
