class GenerateBarcodeReq {
  GenerateBarcodeReq({
    this.productVariationId,
    this.barCodeTypeStoreId,
    this.storePosPrinterId,
    this.numberOfBarCode,
  });

  String? productVariationId;
  String? barCodeTypeStoreId;
  String? storePosPrinterId;
  int? numberOfBarCode;

  factory GenerateBarcodeReq.fromJson(Map<String, dynamic> json) =>
      GenerateBarcodeReq(
        productVariationId: json["ProductVariationId"],
        barCodeTypeStoreId: json["BarCodeTypeStoreId"],
        storePosPrinterId: json["StorePosPrinterId"],
        numberOfBarCode: json["NumberOfBarCode"],
      );

  Map<String, dynamic> toJson() => {
        "ProductVariationId": productVariationId,
        "StorePosPrinterId": storePosPrinterId,
        if (barCodeTypeStoreId != null)
          "BarCodeTypeStoreId": barCodeTypeStoreId,
        if (numberOfBarCode != null) "NumberOfBarCode": numberOfBarCode,
      };
}
