import 'package:pos_account/model/common/message.dart';

class AllGiftCardRes {
  AllGiftCardRes({
    this.data,
    this.message,
    this.total,
    this.status,
  });

  List<GiftCardData>? data;
  List<Message>? message;
  int? total;
  int? status;

  factory AllGiftCardRes.fromJson(Map<String, dynamic> json) => AllGiftCardRes(
        data: json["data"] == null
            ? []
            : List<GiftCardData>.from(
                json["data"]!.map((x) => GiftCardData.fromJson(x))),
        message: json["message"] == null
            ? []
            : List<Message>.from(
                json["message"]!.map((x) => Message.fromJson(x))),
        total: json["total"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "message": message == null
            ? []
            : List<dynamic>.from(message!.map((x) => x.toJson())),
        "total": total,
        "status": status,
      };
}

class GiftCardData {
  GiftCardData({
    this.id,
    this.giftCardCode,
    this.receiverName,
    this.senderName,
    this.amount,
    this.status,
    this.statusEnum,
    this.purchaseDate,
    this.expiryDate,
    this.total,
  });

  String? id;
  String? giftCardCode;
  String? receiverName;
  String? senderName;
  String? amount;
  String? status;
  String? statusEnum;
  String? purchaseDate;
  String? expiryDate;
  int? total;

  factory GiftCardData.fromJson(Map<String, dynamic> json) => GiftCardData(
        id: json["id"],
        giftCardCode: json["giftCardCode"],
        receiverName: json["receiverName"],
        senderName: json["senderName"],
        amount: json["amount"],
        status: json["status"],
        statusEnum: json["statusEnum"],
        purchaseDate: json["purchaseDate"],
        expiryDate: json["expiryDate"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "giftCardCode": giftCardCode,
        "receiverName": receiverName,
        "senderName": senderName,
        "amount": amount,
        "status": status,
        "statusEnum": statusEnum,
        "purchaseDate": purchaseDate,
        "expiryDate": expiryDate,
        "total": total,
      };
}
