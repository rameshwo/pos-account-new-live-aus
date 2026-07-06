// same response as password changed success.
class OtpSendRes {
  OtpSendRes({
    this.message,
  });

  String? message;

  factory OtpSendRes.fromJson(Map<String, dynamic> json) => OtpSendRes(
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
      };
}
