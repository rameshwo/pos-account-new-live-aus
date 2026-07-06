class DeliveryDisRes {
  String? deliveryAmount;
  String? deliveryAmountWithTax;
  String? distanceInKm;
  String? distanceInMile;

  DeliveryDisRes({
    this.deliveryAmount,
    this.deliveryAmountWithTax,
    this.distanceInKm,
    this.distanceInMile,
  });

  factory DeliveryDisRes.fromJson(Map<String, dynamic> json) => DeliveryDisRes(
        deliveryAmount: json["deliveryAmount"],
        deliveryAmountWithTax: json["deliveryAmountWithTax"],
        distanceInKm: json["distanceInKm"],
        distanceInMile: json["distanceInMile"],
      );

  Map<String, dynamic> toJson() => {
        "deliveryAmount": deliveryAmount,
        "deliveryAmountWithTax": deliveryAmountWithTax,
        "distanceInKm": distanceInKm,
        "distanceInMile": distanceInMile,
      };
}
