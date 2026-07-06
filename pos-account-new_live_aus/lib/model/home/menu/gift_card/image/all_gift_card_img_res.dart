import 'gift_card_img_data.dart';

class AllGiftCardImageRes {
  List<GiftCardImageData>? data;
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
    List<GiftCardImageData>? data,
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
            : List<GiftCardImageData>.from(
                json["data"]!.map((x) => GiftCardImageData.fromJson(x))),
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
