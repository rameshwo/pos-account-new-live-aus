class NewOrderNotifi {
  NewOrderNotifi({
    this.id,
    this.typeId,
    this.message,
    this.date,
    this.isSeen,
    this.type,
    this.total,
    this.loading = false,
  });

  String? id;
  String? typeId;
  String? message;
  String? date;
  bool? isSeen;
  String? type;
  int? total;

  // extra data
  bool loading;

  factory NewOrderNotifi.fromJson(Map<String, dynamic> json) => NewOrderNotifi(
        id: json["id"],
        typeId: json["typeId"],
        message: json["message"],
        date: json["date"],
        isSeen: json["isSeen"],
        type: json["type"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "typeId": typeId,
        "message": message,
        "date": date,
        "isSeen": isSeen,
        "type": type,
        "total": total,
      };
}

class NewOrderDbModel {
  NewOrderDbModel({
    this.newOrders,
  });

  List<NewOrderNotifi>? newOrders;

  factory NewOrderDbModel.fromJson(Map<String, dynamic> json) =>
      NewOrderDbModel(
        newOrders: json["new_orders"] == null
            ? null
            : List<NewOrderNotifi>.from(
                json["new_orders"].map((x) => NewOrderNotifi.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "new_orders": newOrders == null
            ? null
            : List<dynamic>.from(newOrders!.map((x) => x.toJson())),
      };
}
