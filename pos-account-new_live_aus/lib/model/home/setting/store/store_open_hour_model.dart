class StoreOpenHourModel {
  String? id;
  List<HoursAddViewModel>? pickUpHoursAddViewModels;
  List<HoursAddViewModel>? deliveryHoursAddViewModels;
  // List<String>? deliveryDistancePriceDeletedIds;
  // List<String>? onlineThemeColorDeletedIds;
  // List<String>? publicHolidaysDeletedIds;
  List<String>? picKUpHoursDeletedIds;
  List<String>? deliveryHoursDeletedIds;
  // List<String>? secondaryEmailDeletedIds;

  StoreOpenHourModel({
    this.id,
    this.pickUpHoursAddViewModels,
    this.deliveryHoursAddViewModels,
    // this.deliveryDistancePriceDeletedIds,
    // this.onlineThemeColorDeletedIds,
    // this.publicHolidaysDeletedIds,
    this.picKUpHoursDeletedIds,
    this.deliveryHoursDeletedIds,
    // this.secondaryEmailDeletedIds,
  });

  factory StoreOpenHourModel.fromJson(Map<String, dynamic> json) =>
      StoreOpenHourModel(
        id: json["id"],
        pickUpHoursAddViewModels: json["pickUpHoursAddViewModels"] == null
            ? []
            : List<HoursAddViewModel>.from(json["pickUpHoursAddViewModels"]!
                .map((x) => HoursAddViewModel.fromJson(x))),
        deliveryHoursAddViewModels: json["deliveryHoursAddViewModels"] == null
            ? []
            : List<HoursAddViewModel>.from(json["deliveryHoursAddViewModels"]!
                .map((x) => HoursAddViewModel.fromJson(x))),
        // deliveryDistancePriceDeletedIds:
        //     json["deliveryDistancePriceDeletedIds"] == null
        //         ? []
        //         : List<String>.from(
        //             json["deliveryDistancePriceDeletedIds"]!.map((x) => x)),
        // onlineThemeColorDeletedIds: json["onlineThemeColorDeletedIds"] == null
        //     ? []
        //     : List<String>.from(
        //         json["onlineThemeColorDeletedIds"]!.map((x) => x)),
        // publicHolidaysDeletedIds: json["publicHolidaysDeletedIds"] == null
        //     ? []
        //     : List<String>.from(
        //         json["publicHolidaysDeletedIds"]!.map((x) => x)),
        picKUpHoursDeletedIds: json["picKUpHoursDeletedIds"] == null
            ? []
            : List<String>.from(json["picKUpHoursDeletedIds"]!.map((x) => x)),
        deliveryHoursDeletedIds: json["deliveryHoursDeletedIds"] == null
            ? []
            : List<String>.from(json["deliveryHoursDeletedIds"]!.map((x) => x)),
        // secondaryEmailDeletedIds: json["secondaryEmailDeletedIds"] == null
        //     ? []
        //     : List<String>.from(
        //         json["secondaryEmailDeletedIds"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "pickUpHoursAddViewModels": pickUpHoursAddViewModels == null
            ? []
            : List<dynamic>.from(
                pickUpHoursAddViewModels!.map((x) => x.toJson())),
        "deliveryHoursAddViewModels": deliveryHoursAddViewModels == null
            ? []
            : List<dynamic>.from(
                deliveryHoursAddViewModels!.map((x) => x.toJson())),
        // "deliveryDistancePriceDeletedIds":
        //     deliveryDistancePriceDeletedIds == null
        //         ? []
        //         : List<dynamic>.from(
        //             deliveryDistancePriceDeletedIds!.map((x) => x)),
        // "onlineThemeColorDeletedIds": onlineThemeColorDeletedIds == null
        //     ? []
        //     : List<dynamic>.from(onlineThemeColorDeletedIds!.map((x) => x)),
        // "publicHolidaysDeletedIds": publicHolidaysDeletedIds == null
        //     ? []
        //     : List<dynamic>.from(publicHolidaysDeletedIds!.map((x) => x)),
        "picKUpHoursDeletedIds": picKUpHoursDeletedIds == null
            ? []
            : List<dynamic>.from(picKUpHoursDeletedIds!.map((x) => x)),
        "deliveryHoursDeletedIds": deliveryHoursDeletedIds == null
            ? []
            : List<dynamic>.from(deliveryHoursDeletedIds!.map((x) => x)),
        // "secondaryEmailDeletedIds": secondaryEmailDeletedIds == null
        //     ? []
        //     : List<dynamic>.from(secondaryEmailDeletedIds!.map((x) => x)),
      };
}

class HoursAddViewModel {
  String? id;
  String? weekDayId;
  String? weekDayName;
  String? openHour;
  String? closeHour;
  bool? isOpened;

  HoursAddViewModel({
    this.id,
    this.weekDayId,
    this.weekDayName,
    this.openHour,
    this.closeHour,
    this.isOpened,
  });

  factory HoursAddViewModel.fromJson(Map<String, dynamic> json) =>
      HoursAddViewModel(
        id: json["id"],
        weekDayId: json["weekDayId"],
        weekDayName: json["weekDayName"],
        openHour: json["openHour"],
        closeHour: json["closeHour"],
        isOpened: json["isOpened"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "weekDayId": weekDayId,
        "weekDayName": weekDayName,
        "openHour": openHour,
        "closeHour": closeHour,
        "isOpened": isOpened,
      };
}
