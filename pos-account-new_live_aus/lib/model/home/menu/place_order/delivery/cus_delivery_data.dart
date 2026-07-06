class CusDeliveryData {
  String? id;
  String? userId;
  String? latitude;
  String? longitude;
  String? deliveryLocation;

  CusDeliveryData({
    this.id,
    this.userId,
    this.latitude,
    this.longitude,
    this.deliveryLocation,
  });

  factory CusDeliveryData.fromJson(Map<String, dynamic> json) =>
      CusDeliveryData(
        id: json["id"],
        userId: json["userId"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        deliveryLocation: json["deliveryLocation"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "latitude": latitude,
        "longitude": longitude,
        "deliveryLocation": deliveryLocation,
      };
}
