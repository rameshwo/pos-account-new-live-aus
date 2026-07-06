class PrintStatusReq {
  String? name;
  String? ipAddress;
  String? port;
  String? status;
  String? requestData;
  String? orderNumber;

  PrintStatusReq({
    this.name,
    this.ipAddress,
    this.port,
    this.status,
    this.requestData,
    this.orderNumber,
  });

  factory PrintStatusReq.fromJson(Map<String, dynamic> json) => PrintStatusReq(
        name: json["name"],
        ipAddress: json["ipAddress"],
        port: json["port"],
        status: json["status"],
        requestData: json["requestData"],
        orderNumber: json["orderNumber"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "ipAddress": ipAddress,
        "port": port,
        "status": status,
        "requestData": requestData,
        "orderNumber": orderNumber,
      };
}
