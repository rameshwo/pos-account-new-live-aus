class StoreDetailRes {
  String? businessCategory;
  String? id;
  String? employeeId;
  String? name;
  String? email;
  String? address;
  String? latitude;
  String? longitude;
  String? currencySymbol;
  String? currencyCode;
  String? languageCode;
  String? imageUrl;
  String? dateFormat;
  String? storeId;
  bool? isActive;

  StoreDetailRes({
    this.businessCategory,
    this.id,
    this.employeeId,
    this.name,
    this.email,
    this.address,
    this.latitude,
    this.longitude,
    this.currencySymbol,
    this.currencyCode,
    this.languageCode,
    this.imageUrl,
    this.dateFormat,
    this.storeId,
    this.isActive,
  });

  factory StoreDetailRes.fromJson(Map<String, dynamic> json) => StoreDetailRes(
        businessCategory: json["businessCategory"],
        id: json["id"],
        employeeId: json["employeeId"],
        name: json["name"],
        email: json["email"],
        address: json["address"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        currencySymbol: json["currencySymbol"],
        currencyCode: json["currencyCode"],
        languageCode: json["languageCode"],
        imageUrl: json["imageUrl"],
        dateFormat: json["dateFormat"],
        storeId: json["storeId"],
        isActive: json["isActive"],
      );

  Map<String, dynamic> toJson() => {
        "businessCategory": businessCategory,
        "id": id,
        "employeeId": employeeId,
        "name": name,
        "email": email,
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
        "currencySymbol": currencySymbol,
        "currencyCode": currencyCode,
        "languageCode": languageCode,
        "imageUrl": imageUrl,
        "dateFormat": dateFormat,
        "storeId": storeId,
        "isActive": isActive,
      };
}
