class StoreDeliDistanceModel {
  String? id;
  bool? enableUberDelivery;
  List<DeliveryDistancePriceAddViewModel>? deliveryDistancePriceAddViewModels;
  List<String>? deliveryDistancePriceDeletedIds;

  StoreDeliDistanceModel({
    this.id,
    this.enableUberDelivery,
    this.deliveryDistancePriceAddViewModels,
    this.deliveryDistancePriceDeletedIds,
  });

  factory StoreDeliDistanceModel.fromJson(Map<String, dynamic> json) =>
      StoreDeliDistanceModel(
        id: json["id"],
        enableUberDelivery: json["enableUberDelivery"],
        deliveryDistancePriceAddViewModels:
            json["deliveryDistancePriceAddViewModels"] == null
                ? []
                : List<DeliveryDistancePriceAddViewModel>.from(
                    json["deliveryDistancePriceAddViewModels"]!.map(
                        (x) => DeliveryDistancePriceAddViewModel.fromJson(x))),
        deliveryDistancePriceDeletedIds:
            json["deliveryDistancePriceDeletedIds"] == null
                ? []
                : List<String>.from(
                    json["deliveryDistancePriceDeletedIds"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "enableUberDelivery": enableUberDelivery,
        "deliveryDistancePriceAddViewModels":
            deliveryDistancePriceAddViewModels == null
                ? []
                : List<dynamic>.from(
                    deliveryDistancePriceAddViewModels!.map((x) => x.toJson())),
        "deliveryDistancePriceDeletedIds":
            deliveryDistancePriceDeletedIds == null
                ? []
                : List<dynamic>.from(
                    deliveryDistancePriceDeletedIds!.map((x) => x)),
      };
}

class DeliveryDistancePriceAddViewModel {
  String? id;
  String? mileKmId;
  String? distanceFrom;
  String? distanceTo;
  String? price;

  DeliveryDistancePriceAddViewModel({
    this.id,
    this.mileKmId,
    this.distanceFrom,
    this.distanceTo,
    this.price,
  });

  factory DeliveryDistancePriceAddViewModel.fromJson(
          Map<String, dynamic> json) =>
      DeliveryDistancePriceAddViewModel(
        id: json["id"],
        mileKmId: json["mileKmId"],
        distanceFrom: json["distanceFrom"],
        distanceTo: json["distanceTo"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "mileKmId": mileKmId,
        "distanceFrom": distanceFrom,
        "distanceTo": distanceTo,
        "price": price,
      };
}
