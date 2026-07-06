class DashChannelUpdateReq {
  String? channelId;
  List<CuisineType>? cuisineTypes;
  List<CuisineType>? filterOptions;
  dynamic creditCardDetails;

  DashChannelUpdateReq({
    this.channelId,
    this.cuisineTypes,
    this.filterOptions,
    this.creditCardDetails,
  });

  factory DashChannelUpdateReq.fromJson(Map<String, dynamic> json) =>
      DashChannelUpdateReq(
        channelId: json["ChannelId"],
        cuisineTypes: json["CuisineTypes"] == null
            ? []
            : List<CuisineType>.from(
                json["CuisineTypes"]!.map((x) => CuisineType.fromJson(x))),
        filterOptions: json["FilterOptions"] == null
            ? []
            : List<CuisineType>.from(
                json["FilterOptions"]!.map((x) => CuisineType.fromJson(x))),
        creditCardDetails: json["CreditCardDetails"],
      );

  Map<String, dynamic> toJson() => {
        "ChannelId": channelId,
        "CuisineTypes": cuisineTypes == null
            ? []
            : List<dynamic>.from(cuisineTypes!.map((x) => x.toJson())),
        "FilterOptions": filterOptions == null
            ? []
            : List<dynamic>.from(filterOptions!.map((x) => x.toJson())),
        "CreditCardDetails": creditCardDetails,
      };
}

class CuisineType {
  String? id;
  String? name;

  CuisineType({
    this.id,
    this.name,
  });

  factory CuisineType.fromJson(Map<String, dynamic> json) => CuisineType(
        id: json["Id"],
        name: json["Name"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Name": name,
      };
}
