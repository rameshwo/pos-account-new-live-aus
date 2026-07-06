class BarcodePrintRes {
  BarcodePrintRes({
    this.image,
    this.ipAddress,
    this.port,
  });

  List<String>? image;
  String? ipAddress;
  String? port;

  factory BarcodePrintRes.fromJson(Map<String, dynamic> json) =>
      BarcodePrintRes(
        image: json["image"] == null
            ? []
            : List<String>.from(json["image"]!.map((x) => x)),
        ipAddress: json["ipAddress"],
        port: json["port"],
      );

  Map<String, dynamic> toJson() => {
        "image": image == null ? [] : List<dynamic>.from(image!.map((x) => x)),
        "ipAddress": ipAddress,
        "port": port,
      };
}
