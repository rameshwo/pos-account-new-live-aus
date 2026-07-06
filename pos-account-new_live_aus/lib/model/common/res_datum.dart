//created for setting response data
//used for all type of response till now

class SRDatum {
  SRDatum({
    this.id,
    this.name,
    this.description,
    this.isActive,
    this.sortOrder,
  });

  String? id;
  String? name;
  String? description;
  bool? isActive;
  int? sortOrder;

  factory SRDatum.fromJson(Map<String, dynamic> json) {
    final fromJson = SRDatum(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      isActive: json["isActive"],
    );

    if (json["sortOrder"] != null) {
      fromJson.sortOrder = json["sortOrder"];
    }

    return fromJson;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _toJson = {
      "id": id,
      if (name != null) "name": name,
      if (description != null) "description": description,
      if (isActive != null) "isActive": isActive,
      if (sortOrder != null) "sortOrder": sortOrder,
    };

    return _toJson;
  }
}
