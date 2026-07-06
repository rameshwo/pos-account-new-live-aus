class TableLocationStatusModel {
  String? id;
  String? name;
  String? layout;
  // List<TableReservationStatus>? tableReservationStatus;

  TableLocationStatusModel({
    this.id,
    this.name,
    this.layout,
    // this.tableReservationStatus,
  });

  factory TableLocationStatusModel.fromJson(Map<String, dynamic> json) =>
      TableLocationStatusModel(
        id: json["id"],
        name: json["name"],
        layout: json["layout"],
        // tableReservationStatus: json["tableReservationStatus"] == null
        //     ? []
        //     : List<TableReservationStatus>.from(json["tableReservationStatus"]!
        //         .map((x) => TableReservationStatus.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "layout": layout,
        // "tableReservationStatus": tableReservationStatus == null
        //     ? []
        //     : List<dynamic>.from(
        //         tableReservationStatus!.map((x) => x.toJson())),
      };
}

class TableReservationStatus {
  String? tableId;
  String? tableName;
  String? tableLocationId;
  // String? tableLocationName;
  // String? reserveType;
  // int? reservedTime;
  String? customerName;
  // int? adult;
  String? status;
  String? orderId;
  double? amount;
  // String? tableReservationsId;
  String? orderNumber;
  String? mergedId;
  String? image;

  TableReservationStatus({
    this.tableId,
    this.tableName,
    this.tableLocationId,
    // this.tableLocationName,
    // this.reserveType,
    // this.reservedTime,
    this.customerName,
    // this.adult,
    this.status,
    this.orderId,
    this.amount,
    // this.tableReservationsId,
    this.orderNumber,
    this.mergedId,
    this.image,
  });

  factory TableReservationStatus.fromJson(Map<String, dynamic> json) =>
      TableReservationStatus(
        tableId: json["tableId"],
        tableName: json["tableName"],
        tableLocationId: json["tableLocationId"],
        // tableLocationName: json["tableLocationName"],
        // reserveType: json["reserveType"],
        // reservedTime: json["reservedTime"],
        customerName: json["customerName"],
        // adult: json["adult"],
        status: json["status"],
        orderId: json["orderId"],
        amount: json["amount"]?.toDouble(),
        // tableReservationsId: json["tableReservationsId"],
        orderNumber: json["orderNumber"],
        mergedId: json["mergedId"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "tableId": tableId,
        "tableName": tableName,
        "tableLocationId": tableLocationId,
        // "tableLocationName": tableLocationName,
        // "reserveType": reserveType,
        // "reservedTime": reservedTime,
        "customerName": customerName,
        // "adult": adult,
        "status": status,
        "orderId": orderId,
        "amount": amount,
        // "tableReservationsId": tableReservationsId,
        "orderNumber": orderNumber,
        "mergedId": mergedId,
        "image": image,
      };
}
