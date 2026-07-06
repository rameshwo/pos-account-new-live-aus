class TagProductToDocketReq {
  String? docketGroupId;
  List<String>? productList;

  TagProductToDocketReq({
    this.docketGroupId,
    this.productList,
  });

  factory TagProductToDocketReq.fromJson(Map<String, dynamic> json) =>
      TagProductToDocketReq(
        docketGroupId: json["DocketGroupId"],
        productList: json["ProductList"] == null
            ? []
            : List<String>.from(json["ProductList"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "DocketGroupId": docketGroupId,
        "ProductList": productList == null
            ? []
            : List<dynamic>.from(productList!.map((x) => x)),
      };
}
