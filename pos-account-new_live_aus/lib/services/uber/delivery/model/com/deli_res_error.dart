class DeliResError {
  String? code;
  String? message;
  String? kind;
  Map<String, dynamic>? metadata;

  DeliResError({
    this.code,
    this.message,
    this.kind,
    this.metadata,
  });

  factory DeliResError.fromJson(Map<String, dynamic> json) => DeliResError(
      code: json["code"],
      message: json["message"],
      kind: json["kind"],
      metadata: json["metadata"]);

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "kind": kind,
      };
}
