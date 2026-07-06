import 'create_deli_res.dart';

class DeliveryListRes {
  List<CreateDeliveryRes>? data;
  String? nextHref;
  int? totalCount;

  DeliveryListRes({
    this.data,
    this.nextHref,
    this.totalCount,
  });

  factory DeliveryListRes.fromJson(Map<String, dynamic> json) =>
      DeliveryListRes(
        data: json["data"] == null
            ? []
            : List<CreateDeliveryRes>.from(
                json["data"]!.map((x) => CreateDeliveryRes.fromJson(x))),
        nextHref: json["next_href"],
        totalCount: json["total_count"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "next_href": nextHref,
        "total_count": totalCount,
      };
}

enum DeliveryStatusEnum {
  pending,
  pickup,
  pickup_complete,
  dropoff,
  delivered,
  canceled,
  returned,
  ongoing
}
