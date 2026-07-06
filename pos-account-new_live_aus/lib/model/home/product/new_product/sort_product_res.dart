class GetSortProductRes {
  String? id;
  String? sort;
  List<SortOrder>? sortOrders;
  String? name;
  bool isCatSorted;
  bool isProdSorted;

  GetSortProductRes({
    this.id,
    this.sort,
    this.sortOrders,
    this.name,
    this.isCatSorted = false,
    this.isProdSorted = false,
  });

  factory GetSortProductRes.fromJson(Map<String, dynamic> json) =>
      GetSortProductRes(
        id: json["id"],
        sort: json["sort"],
        sortOrders: json["sortOrders"] == null
            ? []
            : List<SortOrder>.from(
                json["sortOrders"]!.map((x) => SortOrder.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sort": sort,
        "sortOrders": sortOrders == null
            ? []
            : List<dynamic>.from(sortOrders!.map((x) => x.toJson())),
      };
}

class SortOrder {
  String? sort;
  String? id;

  SortOrder({
    this.sort,
    this.id,
  });

  factory SortOrder.fromJson(Map<String, dynamic> json) => SortOrder(
        sort: json["sort"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "sort": sort,
        "id": id,
      };
}
