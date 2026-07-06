class ConfigureDeviceReq {
  String? name;
  bool? isMainDevice;
  String? storeId;
  String? deviceIdenfitier;
  String? fcmToken;
  String? deviceTypeId;

  ConfigureDeviceReq({
    this.name,
    this.isMainDevice,
    this.storeId,
    this.deviceIdenfitier,
    this.fcmToken,
    this.deviceTypeId,
  });

  factory ConfigureDeviceReq.fromJson(Map<String, dynamic> json) =>
      ConfigureDeviceReq(
        name: json["Name"],
        isMainDevice: json["IsMainDevice"],
        storeId: json["StoreId"],
        deviceIdenfitier: json["DeviceIdenfitier"],
        fcmToken: json["FcmToken"],
        deviceTypeId: json["deviceTypeId"],
      );

  Map<String, dynamic> toJson() => {
        "Name": name,
        "IsMainDevice": isMainDevice,
        "StoreId": storeId,
        "DeviceIdenfitier": deviceIdenfitier,
        "FcmToken": fcmToken,
        "deviceTypeId": deviceTypeId,
      };
}
