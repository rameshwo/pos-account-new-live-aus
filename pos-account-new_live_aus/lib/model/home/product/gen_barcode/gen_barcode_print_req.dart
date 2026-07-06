class GenBarcodePrintReq {
  String? productVariationId;

  GenBarcodePrintReq({
    this.productVariationId,
  });

  factory GenBarcodePrintReq.fromJson(Map<String, dynamic> json) =>
      GenBarcodePrintReq(
        productVariationId: json["ProductVariationId"],
      );

  Map<String, dynamic> toJson() => {
        "ProductVariationId": productVariationId,
      };
}
