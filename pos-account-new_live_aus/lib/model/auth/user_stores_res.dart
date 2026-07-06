class UserStoresRes {
  String? id;
  String? name;
  String? imageUrl;
  String? screenSaverLogoffInterval;
  String? storeId;
  bool? isMainDevice;
  bool? isConfigured;
  bool? enablePinCodePopUpScreen;
  String? posTabDefaultScreenName;
  bool? openCashRegister;
  String? userType;
  List<UserStore>? userStores;

  UserStoresRes({
    this.id,
    this.name,
    this.imageUrl,
    this.screenSaverLogoffInterval,
    this.storeId,
    this.isMainDevice,
    this.isConfigured,
    this.enablePinCodePopUpScreen,
    this.posTabDefaultScreenName,
    this.openCashRegister,
    this.userType,
    this.userStores,
  });

  factory UserStoresRes.fromJson(Map<String, dynamic> json) => UserStoresRes(
        id: json["id"],
        name: json["name"],
        imageUrl: json["imageUrl"],
        screenSaverLogoffInterval: json["screenSaverLogoffInterval"],
        storeId: json["storeId"],
        isMainDevice: json["isMainDevice"],
        isConfigured: json["isConfigured"],
        enablePinCodePopUpScreen: json["enablePinCodePopUpScreen"],
        posTabDefaultScreenName: json["posTabDefaultScreenName"],
        openCashRegister: json["openCashRegister"],
        userType: json["userType"],
        userStores: json["userStores"] == null
            ? []
            : List<UserStore>.from(
                json["userStores"]!.map((x) => UserStore.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "imageUrl": imageUrl,
        "screenSaverLogoffInterval": screenSaverLogoffInterval,
        "storeId": storeId,
        "isMainDevice": isMainDevice,
        "isConfigured": isConfigured,
        "enablePinCodePopUpScreen": enablePinCodePopUpScreen,
        "posTabDefaultScreenName": posTabDefaultScreenName,
        "openCashRegister": openCashRegister,
        "userType": userType,
        "userStores": userStores == null
            ? []
            : List<dynamic>.from(userStores!.map((x) => x.toJson())),
      };
}

class UserStore {
  String? id;
  String? name;
  bool? isActive;
  String? employeeId;

  UserStore({
    this.id,
    this.name,
    this.isActive,
    this.employeeId,
  });

  factory UserStore.fromJson(Map<String, dynamic> json) => UserStore(
        id: json["id"],
        name: json["name"],
        isActive: json["isActive"],
        employeeId: json["employeeId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "isActive": isActive,
        "employeeId": employeeId,
      };
}
