import 'dart:convert';

List<UsbDevice> usbDeviceFromJson(String str) =>
    List<UsbDevice>.from(json.decode(str).map((x) => UsbDevice.fromJson(x)));

String usbDeviceToJson(List<UsbDevice> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UsbDevice {
  String? productId;
  String? vendorId;
  String? deviceName;
  String? deviceId;
  String? productName;
  String? manufacturer;

  UsbDevice({
    this.productId,
    this.vendorId,
    this.deviceName,
    this.deviceId,
    this.productName,
    this.manufacturer,
  });

  factory UsbDevice.fromJson(Map<String, dynamic> json) => UsbDevice(
        productId: json["productId"],
        vendorId: json["vendorId"],
        deviceName: json["deviceName"],
        deviceId: json["deviceId"],
        productName: json["productName"],
        manufacturer: json["manufacturer"],
      );

  Map<String, dynamic> toJson() => {
        "productId": productId,
        "vendorId": vendorId,
        "deviceName": deviceName,
        "deviceId": deviceId,
        "productName": productName,
        "manufacturer": manufacturer,
      };
}
