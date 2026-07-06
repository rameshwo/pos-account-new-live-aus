class BarcodePrintReq {
  String? id;
  String? name;

  BarcodePrintReq({
    this.id,
    this.name,
  });

  factory BarcodePrintReq.fromJson(Map<String, dynamic> json) =>
      BarcodePrintReq(
        id: json["Id"],
        name: json["Name"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Name": name,
      };
}
