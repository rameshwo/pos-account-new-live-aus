class AddFeatProData {
  AddFeatProData({
    this.id = "",
    this.productId,
    this.name,
  });

  final String id;
  final String? productId;
  final String? name;

  factory AddFeatProData.fromJson(Map<String, dynamic> json) => AddFeatProData(
        id: json["Id"],
        productId: json["ProductId"],
        name: json["Name"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "ProductId": productId,
        "Name": name,
      };
}
