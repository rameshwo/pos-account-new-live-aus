import 'package:pos_account/model/common/table_location.dart';

class OrderTabReq {
  String? id;
  String? tabIdentification;
  String? noOfCustomer;
  String? tabLimit;
  String? orderId;
  int? total;
  String? createDate;
  String? totalAmount;
  String? totalOrderItems;

  OrderTabReq({
    this.id,
    this.tabIdentification,
    this.noOfCustomer,
    this.tabLimit,
    this.orderId,
    this.total,
    this.createDate,
    this.totalAmount,
    this.totalOrderItems,
  });

  factory OrderTabReq.fromJson(Map<String, dynamic> json) => OrderTabReq(
        id: json["id"],
        tabIdentification: json["tabIdentification"],
        noOfCustomer: json["noOfCustomer"],
        tabLimit: json["tabLimit"],
        orderId: json["orderId"],
        total: json["total"],
        createDate: json["createDate"],
        totalAmount: json["totalAmount"],
        totalOrderItems: json["totalOrderItems"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tabIdentification": tabIdentification,
        "noOfCustomer": noOfCustomer,
        "tabLimit": tabLimit,
        "orderId": orderId,
        "total": total,
        "createDate": createDate,
        "totalAmount": totalAmount,
        "totalOrderItems": totalOrderItems,
      };
}

class OrderTabSection {
  List<TableLocation>? orderStatus;

  OrderTabSection({
    this.orderStatus,
  });

  factory OrderTabSection.fromJson(Map<String, dynamic> json) =>
      OrderTabSection(
        orderStatus: json["orderTabStatus"] == null
            ? []
            : List<TableLocation>.from(
                json["orderTabStatus"].map((x) => TableLocation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "orderTabStatus": orderStatus == null
            ? []
            : List<dynamic>.from(orderStatus!.map((x) => x.toJson())),
      };
}
