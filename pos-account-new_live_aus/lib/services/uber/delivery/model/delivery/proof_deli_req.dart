class ProofDeliverytReq {
  ProofDeliTypeEnum? type;
  String? waypoint; // "pickup" "dropoff" "return"

  ProofDeliverytReq({
    this.type,
    this.waypoint,
  });

  factory ProofDeliverytReq.fromJson(Map<String, dynamic> json) =>
      ProofDeliverytReq(
        type: json["type"] == null
            ? null
            : ProofDeliTypeEnum.values
                .firstWhere((e) => e.name == json["type"]),
        waypoint: json["waypoint"],
      );

  Map<String, String> toJson() => {
        "type": type?.name ?? '',
        "waypoint": waypoint ?? "",
      };
}

enum ProofDeliTypeEnum { picture, signature, pincode }

class ProofDeliverytRes {
  String? document;

  ProofDeliverytRes({
    this.document,
  });

  factory ProofDeliverytRes.fromJson(Map<String, dynamic> json) =>
      ProofDeliverytRes(
        document: json["document"],
      );

  Map<String, dynamic> toJson() => {
        "document": document,
      };
}
