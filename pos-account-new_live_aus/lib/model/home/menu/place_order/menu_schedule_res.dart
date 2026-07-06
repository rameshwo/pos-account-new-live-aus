class MenuScheduleRes {
  String? weekDayName;
  List<MenuSchedule>? menuSchedule;

  MenuScheduleRes({
    this.weekDayName,
    this.menuSchedule,
  });

  factory MenuScheduleRes.fromJson(Map<String, dynamic> json) =>
      MenuScheduleRes(
        weekDayName: json["weekDayName"],
        menuSchedule: json["menuSchedule"] == null
            ? []
            : List<MenuSchedule>.from(
                json["menuSchedule"]!.map((x) => MenuSchedule.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "weekDayName": weekDayName,
        "menuSchedule": menuSchedule == null
            ? []
            : List<dynamic>.from(menuSchedule!.map((x) => x.toJson())),
      };
}

class MenuSchedule {
  String? menuId;
  String? timeFrom;
  String? timeTo;
  List<String>? products;

  MenuSchedule({
    this.menuId,
    this.timeFrom,
    this.timeTo,
    this.products,
  });

  factory MenuSchedule.fromJson(Map<String, dynamic> json) => MenuSchedule(
        menuId: json["menuId"],
        timeFrom: json["timeFrom"],
        timeTo: json["timeTo"],
        products: json["products"] == null
            ? []
            : List<String>.from(json["products"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "menuId": menuId,
        "timeFrom": timeFrom,
        "timeTo": timeTo,
        "products":
            products == null ? [] : List<dynamic>.from(products!.map((x) => x)),
      };
}
