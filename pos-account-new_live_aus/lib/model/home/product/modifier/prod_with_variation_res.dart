import 'package:pos_account/model/common/message.dart';

class AllProdWithVariation {
  List<ProdWithVarData>? data;
  List<Message>? message;
  int? total;
  bool? isError;
  int? status;

  AllProdWithVariation({
    this.data,
    this.message,
    this.total,
    this.isError,
    this.status,
  });

  factory AllProdWithVariation.fromJson(Map<String, dynamic> json) =>
      AllProdWithVariation(
        data: json["data"] == null
            ? []
            : List<ProdWithVarData>.from(
                json["data"]!.map((x) => ProdWithVarData.fromJson(x))),
        message: json["message"] == null
            ? []
            : List<Message>.from(
                json["message"]!.map((x) => Message.fromJson(x))),
        total: json["total"],
        isError: json["isError"],
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
        "isError": isError,
        "status": status,
      };
}

class ProdWithVarData {
  String? id;
  String? name;
  String? imageUrl;
  String? productCategoryId;
  String? productCategoryName;
  String? brandId;
  List<ModifierVarData>? productVariations;
  int? total;

  ProdWithVarData({
    this.id,
    this.name,
    this.imageUrl,
    this.productCategoryId,
    this.productCategoryName,
    this.brandId,
    this.productVariations,
    this.total,
  });

  factory ProdWithVarData.fromJson(Map<String, dynamic> json) =>
      ProdWithVarData(
        id: json["id"],
        name: json["name"],
        imageUrl: json["imageUrl"],
        productCategoryId: json["productCategoryId"],
        productCategoryName: json["productCategoryName"],
        brandId: json["brandId"],
        productVariations: json["productVariations"] == null
            ? []
            : List<ModifierVarData>.from(json["productVariations"]!
                .map((x) => ModifierVarData.fromJson(x))),
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "imageUrl": imageUrl,
        "productCategoryId": productCategoryId,
        "productCategoryName": productCategoryName,
        "brandId": brandId,
        "productVariations": productVariations == null
            ? []
            : List<dynamic>.from(productVariations!.map((x) => x.toJson())),
        "total": total,
      };
}

class ModifierVarData {
  String? id;
  String? name;
  String? productId;
  int? modifierCount;

  ModifierVarData({
    this.id,
    this.name,
    this.productId,
    this.modifierCount,
  });

  factory ModifierVarData.fromJson(Map<String, dynamic> json) =>
      ModifierVarData(
        id: json["id"],
        name: json["name"],
        productId: json["productId"],
        modifierCount: json["modifierCount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "productId": productId,
        "modifierCount": modifierCount,
      };
}
