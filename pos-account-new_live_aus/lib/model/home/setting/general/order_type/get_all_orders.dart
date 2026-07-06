import 'package:pos_account/model/common/message.dart';

class GetAllOrderTypeRes {
  GetAllOrderTypeRes({
    this.data,
    this.message,
    this.total,
    this.status,
  });

  List<Datum>? data;
  List<Message>? message;
  int? total;
  int? status;

  factory GetAllOrderTypeRes.fromJson(Map<String, dynamic> json) =>
      GetAllOrderTypeRes(
        data: json["data"] == null
            ? null
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        message: json["message"] == null
            ? null
            : List<Message>.from(json["message"].map((x) => x)),
        total: json["total"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "message":
            message == null ? null : List<dynamic>.from(message!.map((x) => x)),
        "total": total,
        "status": status,
      };
}

class Datum {
  Datum({
    this.id,
    this.channelName,
    this.orderType,
    this.isActive,
    // this.isDefault,
    this.sortOrder,
    // this.isPosOrderType,
    // this.isOnlineOrderType,
  });

  String? id;
  String? channelName;
  String? orderType;
  bool? isActive;
  // bool? isDefault;
  int? sortOrder;
  // bool? isPosOrderType;
  // bool? isOnlineOrderType;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        channelName: json["channelName"],
        orderType: json["orderType"],
        isActive: json["isActive"],
        // isDefault: json["isDefault"],
        sortOrder: json["sortOrder"],
        // isPosOrderType: json["isPosOrderType"],
        // isOnlineOrderType: json["isOnlineOrderType"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "channelName": channelName,
        "orderType": orderType,
        "isActive": isActive,
        // "isDefault": isDefault,
        "sortOrder": sortOrder,
        // "isPosOrderType": isPosOrderType,
        // "isOnlineOrderType": isOnlineOrderType,
      };
}
