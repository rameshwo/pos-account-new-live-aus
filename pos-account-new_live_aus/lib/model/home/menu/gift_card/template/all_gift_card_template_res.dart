import 'package:pos_account/model/home/menu/gift_card/template/gift_card_temp_data.dart';

class AllGiftCardImageRes {
  List<GiftCardTempData>? data;
  List<dynamic>? message;
  int? total;
  int? status;

  AllGiftCardImageRes({
    this.data,
    this.message,
    this.total,
    this.status,
  });

  AllGiftCardImageRes copyWith({
    List<GiftCardTempData>? data,
    List<dynamic>? message,
    int? total,
    int? status,
  }) =>
      AllGiftCardImageRes(
        data: data ?? this.data,
        message: message ?? this.message,
        total: total ?? this.total,
        status: status ?? this.status,
      );

  factory AllGiftCardImageRes.fromJson(Map<String, dynamic> json) =>
      AllGiftCardImageRes(
        data: json["data"] == null
            ? []
            : List<GiftCardTempData>.from(
                json["data"]!.map((x) => GiftCardTempData.fromJson(x))),
        message: json["message"] == null
            ? []
            : List<dynamic>.from(json["message"]!.map((x) => x)),
        total: json["total"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "message":
            message == null ? [] : List<dynamic>.from(message!.map((x) => x)),
        "total": total,
        "status": status,
      };
}
