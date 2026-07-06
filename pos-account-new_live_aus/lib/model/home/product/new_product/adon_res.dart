class AdonRes {
  AdonRes({
    this.name,
    this.id,
  });

  final String? name;
  final String? id;

  factory AdonRes.fromJson(Map<String, dynamic> json) => AdonRes(
        name: json["name"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
      };
}
