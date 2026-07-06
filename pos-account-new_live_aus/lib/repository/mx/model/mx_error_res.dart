class MxErrorRes {
  Error? error;

  MxErrorRes({
    this.error,
  });

  factory MxErrorRes.fromJson(Map<String, dynamic> json) => MxErrorRes(
        error: json["error"] == null ? null : Error.fromJson(json["error"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error?.toJson(),
      };
}

class Error {
  String? requestId;
  String? code;
  String? message;

  Error({
    this.requestId,
    this.code,
    this.message,
  });

  factory Error.fromJson(Map<String, dynamic> json) => Error(
        requestId: json["request_id"],
        code: json["code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "request_id": requestId,
        "code": code,
        "message": message,
      };
}
