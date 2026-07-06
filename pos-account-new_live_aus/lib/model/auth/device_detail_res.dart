// class DeviceDetailRes {
//   String? id;
//   String? name;
//   String? imageUrl;
//   String? screenSaverLogoffInterval;
//   String? storeId;
//   bool? isMainDevice;
//   bool? isConfigured;
//   bool? enablePinCodePopUpScreen;
//   String? posTabDefaultScreenName;

//   DeviceDetailRes({
//     this.id,
//     this.name,
//     this.imageUrl,
//     this.screenSaverLogoffInterval,
//     this.storeId,
//     this.isMainDevice,
//     this.isConfigured,
//     this.enablePinCodePopUpScreen,
//     this.posTabDefaultScreenName,
//   });

//   factory DeviceDetailRes.fromJson(Map<String, dynamic> json) =>
//       DeviceDetailRes(
//         id: json["id"],
//         name: json["name"],
//         imageUrl: json["imageUrl"],
//         screenSaverLogoffInterval: json["screenSaverLogoffInterval"],
//         storeId: json["storeId"],
//         isMainDevice: json["isMainDevice"],
//         isConfigured: json["isConfigured"],
//         enablePinCodePopUpScreen: json["enablePinCodePopUpScreen"],
//         posTabDefaultScreenName: json["posTabDefaultScreenName"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "imageUrl": imageUrl,
//         "screenSaverLogoffInterval": screenSaverLogoffInterval,
//         "storeId": storeId,
//         "isMainDevice": isMainDevice,
//         "isConfigured": isConfigured,
//         "enablePinCodePopUpScreen": enablePinCodePopUpScreen,
//         "posTabDefaultScreenName": posTabDefaultScreenName,
//       };
// }
