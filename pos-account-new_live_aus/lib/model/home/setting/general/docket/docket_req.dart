class DocketGroupReq {
  String? name;
  int? sortOrder;
  String? id;
  bool enableDocketGroupSpliter;

  DocketGroupReq({
    this.name,
    this.sortOrder,
    this.id,
    this.enableDocketGroupSpliter = false,
  });

  factory DocketGroupReq.fromJson(Map<String, dynamic> json) => DocketGroupReq(
        name: json["name"],
        sortOrder: json["sortOrder"],
        id: json["id"],
        enableDocketGroupSpliter: json["enableDocketGroupSpliter"],
      );

  Map<String, dynamic> toJson() => {
        "Name": name,
        "SortOrder": sortOrder,
        "Id": id,
        "EnableDocketGroupSpliter": enableDocketGroupSpliter,
      };
}
