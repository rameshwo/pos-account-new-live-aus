class PosDeviceModel {
  PosDeviceModel({
    this.id,
    this.posDeviceNameOrLocation,
    this.sortOrder,
    this.isActive,
    this.openCashRegister,
    this.printerId,
    this.deviceIdentifier,
    this.deviceSerialNumber,
    this.isKitchenDisplay,
    this.posDeviceActivation,
    this.posDeviceTypeId,
    this.isMainPosDevice,
    this.screenSaverLogOffInterval,
    this.enablePinCodePopUpScreen,
    this.posDefaultScreen,
  });

  String? id;
  String? posDeviceNameOrLocation;
  int? sortOrder;
  bool? isActive;
  bool? openCashRegister;
  String? printerId;
  String? deviceIdentifier;
  String? deviceSerialNumber;
  bool? isKitchenDisplay;
  bool? posDeviceActivation;
  String? posDeviceTypeId;
  bool? isMainPosDevice;
  String? screenSaverLogOffInterval;
  bool? enablePinCodePopUpScreen;
  String? posDefaultScreen;

  factory PosDeviceModel.fromJson(Map<String, dynamic> json) => PosDeviceModel(
        id: json["id"],
        posDeviceNameOrLocation: json["posDeviceNameOrLocation"],
        sortOrder: json["sortOrder"],
        isActive: json["isActive"],
        openCashRegister: json["openCashRegister"],
        printerId: json["printerId"],
        deviceIdentifier: json["deviceIdentifier"],
        deviceSerialNumber: json["deviceSerialNumber"],
        isKitchenDisplay: json["isKitchenDisplay"],
        posDeviceActivation: json["posDeviceActivation"],
        posDeviceTypeId: json["posDeviceTypeId"],
        isMainPosDevice: json["isMainPosDevice"],
        screenSaverLogOffInterval: json["screenSaverLogOffInterval"],
        enablePinCodePopUpScreen: json["enablePinCodePopUpScreen"],
        posDefaultScreen: json["posDefaultScreen"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "PosDeviceNameOrLocation": posDeviceNameOrLocation,
        "SortOrder": sortOrder,
        "IsActive": isActive,
        "OpenCashRegister": openCashRegister,
        "PrinterId": printerId,
        "deviceIdentifier": deviceIdentifier,
        "deviceSerialNumber": deviceSerialNumber,
        "isKitchenDisplay": isKitchenDisplay,
        "posDeviceActivation": posDeviceActivation,
        "posDeviceTypeId": posDeviceTypeId,
        "isMainPosDevice": isMainPosDevice,
        "screenSaverLogOffInterval": screenSaverLogOffInterval,
        "enablePinCodePopUpScreen": enablePinCodePopUpScreen,
        "posDefaultScreen": posDefaultScreen,
      };
}
