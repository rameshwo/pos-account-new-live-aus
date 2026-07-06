class OrderTypeRes {
  String? orderTypeChannel;
  String? id;
  String? value;
  dynamic additionalValue;
  bool? isSelected;
  String? name;
  bool? enableCustomerPopUpScreen;
  String? channelId;

  OrderTypeRes({
    this.orderTypeChannel,
    this.id,
    this.value,
    this.additionalValue,
    this.isSelected,
    this.name,
    this.enableCustomerPopUpScreen,
    this.channelId,
  });

  factory OrderTypeRes.fromJson(Map<String, dynamic> json) => OrderTypeRes(
        orderTypeChannel: json["orderTypeChannel"],
        id: json["id"],
        value: json["value"],
        additionalValue: json["additionalValue"],
        isSelected: json["isSelected"],
        name: json["name"],
        enableCustomerPopUpScreen: json["enableCustomerPopUpScreen"],
        channelId: json["channelId"],
      );

  Map<String, dynamic> toJson() => {
        "orderTypeChannel": orderTypeChannel,
        "id": id,
        "value": value,
        "additionalValue": additionalValue,
        "isSelected": isSelected,
        "name": name,
        "enableCustomerPopUpScreen": enableCustomerPopUpScreen,
        "channelId": channelId,
      };
}
