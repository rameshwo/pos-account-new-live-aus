class TableStatusUpdateReq {
  String? tableid;
  String? status;
  String? name;
  bool selected;
  String? orderId;

  TableStatusUpdateReq({
    this.tableid,
    this.status,
    this.name,
    this.selected = false,
    this.orderId,
  });

  factory TableStatusUpdateReq.fromJson(Map<String, dynamic> json) =>
      TableStatusUpdateReq(
        tableid: json["TableId"],
        status: json["Status"],
        orderId: json["OrderId"],
      );

  Map<String, dynamic> toJson() => {
        "TableId": tableid,
        if (status != null) "Status": status,
        if (orderId != null) "OrderId": orderId,
      };
}
