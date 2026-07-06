class OnlineOrderId {
  String? id;
  String? name;
  String? title;
  String? body;

  OnlineOrderId({
    this.id,
    this.name,
    this.title,
    this.body,
  });

  factory OnlineOrderId.fromJson(Map<String, dynamic> json) => OnlineOrderId(
        id: json["Id"] ?? json["id"],
        name: json["name"] ?? json["Name"],
        title: json["title"] ?? json["Title"],
        body: json["body"] ?? json["Body"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "name": name,
        "Title": title,
        "Body": body,
      };
}
