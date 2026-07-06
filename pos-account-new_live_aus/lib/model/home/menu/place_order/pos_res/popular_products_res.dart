class PopularProductRes {
  String? id;
  String? name;
  String? imageUrl;

  PopularProductRes({
    this.id,
    this.name,
    this.imageUrl,
  });

  factory PopularProductRes.fromJson(Map<String, dynamic> json) =>
      PopularProductRes(
        id: json["id"],
        name: json["name"],
        imageUrl: json["imageUrl"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "imageUrl": imageUrl,
      };
}
