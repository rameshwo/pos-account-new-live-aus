import 'package:pos_account/model/common/message.dart';

class CustomerHistory {
  CustomerOrders? customerOrders;
  String? totalSales;

  CustomerHistory({
    this.customerOrders,
    this.totalSales,
  });

  factory CustomerHistory.fromJson(Map<String, dynamic> json) =>
      CustomerHistory(
        customerOrders: json["customerOrders"] == null
            ? null
            : CustomerOrders.fromJson(json["customerOrders"]),
        totalSales: json["totalSales"],
      );

  Map<String, dynamic> toJson() => {
        "customerOrders": customerOrders?.toJson(),
        "totalSales": totalSales,
      };
}

class CustomerOrders {
  List<CustomerOrderData>? data;
  List<Message>? message;
  int? total;
  bool? isError;
  int? status;

  CustomerOrders({
    this.data,
    this.message,
    this.total,
    this.isError,
    this.status,
  });

  factory CustomerOrders.fromJson(Map<String, dynamic> json) => CustomerOrders(
        data: json["data"] == null
            ? []
            : List<CustomerOrderData>.from(
                json["data"]!.map((x) => CustomerOrderData.fromJson(x))),
        message: json["message"] == null
            ? []
            : List<Message>.from(
                json["message"]!.map((x) => Message.fromJson(x))),
        total: json["total"],
        isError: json["isError"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "message": message == null
            ? []
            : List<dynamic>.from(message!.map((x) => x.toJson())),
        "total": total,
        "isError": isError,
        "status": status,
      };
}

class CustomerOrderData {
  String? orderId;
  String? orderNumber;
  double? totalAmount;
  String? orderDate;
  String? orderChannel;

  CustomerOrderData({
    this.orderId,
    this.orderNumber,
    this.totalAmount,
    this.orderDate,
    this.orderChannel,
  });

  factory CustomerOrderData.fromJson(Map<String, dynamic> json) =>
      CustomerOrderData(
        orderId: json["orderId"],
        orderNumber: json["orderNumber"],
        totalAmount: json["totalAmount"],
        orderDate: json["orderDate"],
        orderChannel: json["orderChannel"],
      );

  Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "orderNumber": orderNumber,
        "totalAmount": totalAmount,
        "orderDate": orderDate,
        "orderChannel": orderChannel,
      };
}
