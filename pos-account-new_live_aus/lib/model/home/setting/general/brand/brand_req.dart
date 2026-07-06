class BrandReq {
  BrandReq({
    this.id,
    this.name,
    this.isActive,
    this.description,
    this.imagePath,
    this.isImageDeleted,
  });

  String? id;
  String? name;
  bool? isActive;
  String? description;
  String? imagePath;
  bool? isImageDeleted;

  factory BrandReq.fromJson(Map<String, dynamic> json) => BrandReq(
        id: json["id"],
        name: json["name"],
        isActive: json["isActive"],
        description: json["description"],
        imagePath: json["imagePath"],
        isImageDeleted: json["isImageDeleted"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Name": name,
        "isActive": isActive,
        "Description": description,
        if (imagePath != null) "imagePath": imagePath,
        "IsImageDeleted": isImageDeleted,
      };
}
