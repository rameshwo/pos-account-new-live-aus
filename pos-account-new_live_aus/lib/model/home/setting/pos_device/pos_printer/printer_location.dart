class PrinterLocationReq {
  PrinterLocationReq({
    this.id,
    // this.departmentId,
    this.name,
    this.description,
    this.port,
    this.ipAddress,
    this.isActive,
    this.isBluetoothPrinter,
    this.printerTypeId,
    // this.isDefault,
  });

  String? id;
  // String? departmentId;
  String? name;
  String? description;
  String? port;
  String? ipAddress;
  bool? isActive;
  bool? isBluetoothPrinter;
  String? printerTypeId;
  // bool? isDefault;

  factory PrinterLocationReq.fromJson(Map<String, dynamic> json) =>
      PrinterLocationReq(
        id: json["id"],
        // departmentId: json["departmentId"],
        name: json["name"],
        description: json["description"],
        port: json["port"],
        ipAddress: json["ipAddress"],
        isActive: json["isActive"],
        isBluetoothPrinter: json["isBluetoothPrinter"],
        printerTypeId: json["printerTypeId"],
        // isDefault: json["isDefault"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        // "DepartmentId": departmentId,
        "Name": name,
        "Description": description,
        "Port": port,
        "IpAddress": ipAddress,
        "IsActive": isActive,
        "IsBluetoothPrinter": isBluetoothPrinter,
        "PrinterTypeId": printerTypeId,
        // "isDefault": isDefault,
      };
}
