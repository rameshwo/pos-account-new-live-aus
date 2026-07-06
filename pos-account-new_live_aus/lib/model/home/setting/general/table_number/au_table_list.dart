class AllTableNoList {
  AllTableNoList({
    this.id,
    this.name,
    this.tableLocationId,
    this.tableImageId,
    this.adultCapacity,
    this.childCapacity,
    this.isActive,
    this.description,
  });

  String? id;
  String? name;
  String? tableLocationId;
  String? tableImageId;
  String? adultCapacity;
  String? childCapacity;
  bool? isActive;
  String? description;

  factory AllTableNoList.fromJson(Map<String, dynamic> json) => AllTableNoList(
        id: json["id"],
        name: json["name"],
        tableLocationId: json["tableLocationId"],
        tableImageId: json["tableImageId"],
        adultCapacity: json["adultCapacity"],
        childCapacity: json["childCapacity"],
        isActive: json["isActive"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Name": name,
        "TableLocationId": tableLocationId,
        "TableImageId": tableImageId,
        "AdultCapacity": adultCapacity,
        "ChildCapacity": childCapacity,
        "IsActive": isActive,
        "Description": description,
      };
}
