import 'package:pos_account/model/common/message.dart';

class AllOrdersRes {
  AllOrdersRes({
    this.data,
    this.message,
    this.total,
    this.status,
  });

  List<AllOrderData>? data;
  List<Message>? message;
  int? total;
  int? status;

  factory AllOrdersRes.fromJson(Map<String, dynamic> json) => AllOrdersRes(
        data: json["data"] == null
            ? null
            : List<AllOrderData>.from(
                json["data"].map((x) => AllOrderData.fromJson(x))),
        message: json["message"] == null
            ? null
            : List<Message>.from(
                json["message"].map((x) => Message.fromJson(x))),
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

class AllOrderData {
  String? orderId;
  String? orderType;
  String? orderNumber;
  String? eftPosMerchantType;
  String? customerName;
  String? email;
  String? tableName;
  String? totalAmount;
  String? status;
  dynamic statusEnumValue;
  String? orderDate;
  String? refundDate;
  String? orderChannel;
  String? paymentMethod;
  bool? isOrderRevoked;
  int? total;

  AllOrderData({
    this.orderId,
    this.orderType,
    this.orderNumber,
    this.eftPosMerchantType,
    this.customerName,
    this.email,
    this.tableName,
    this.totalAmount,
    this.status,
    this.statusEnumValue,
    this.orderDate,
    this.refundDate,
    this.orderChannel,
    this.paymentMethod,
    this.isOrderRevoked,
    this.total,
  });

  factory AllOrderData.fromJson(Map<String, dynamic> json) => AllOrderData(
        orderId: json["orderId"],
        orderType: json["orderType"],
        orderNumber: json["orderNumber"],
        eftPosMerchantType: json["eftPOSMerchantType"],
        customerName: json["customerName"],
        email: json["email"],
        tableName: json["tableName"],
        totalAmount: json["totalAmount"],
        status: json["status"],
        statusEnumValue: json["statusEnumValue"],
        orderDate: json["orderDate"],
        refundDate: json["refundDate"],
        orderChannel: json["orderChannel"],
        paymentMethod: json["paymentMethod"],
        isOrderRevoked: json["isOrderRevoked"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "orderType": orderType,
        "orderNumber": orderNumber,
        "eftPOSMerchantType": eftPosMerchantType,
        "customerName": customerName,
        "email": email,
        "tableName": tableName,
        "totalAmount": totalAmount,
        "status": status,
        "statusEnumValue": statusEnumValue,
        "orderDate": orderDate,
        "refundDate": refundDate,
        "orderChannel": orderChannel,
        "paymentMethod": paymentMethod,
        "isOrderRevoked": isOrderRevoked,
        "total": total,
      };
}
