class PayInvoiceSendEmailReq {
  PayInvoiceSendEmailReq({
    this.orderId,
    this.emailViewModel,
  });

  String? orderId;
  EmailViewModel? emailViewModel;

  factory PayInvoiceSendEmailReq.fromJson(Map<String, dynamic> json) =>
      PayInvoiceSendEmailReq(
        orderId: json["OrderId"],
        emailViewModel: json["EmailViewModel"] == null
            ? null
            : EmailViewModel.fromJson(json["EmailViewModel"]),
      );

  Map<String, dynamic> toJson() => {
        "OrderId": orderId,
        "EmailViewModel": emailViewModel?.toJson(),
      };
}

class EmailViewModel {
  EmailViewModel({
    this.to,
    this.cc,
    this.senderEmail,
    this.senderName,
    this.subject,
    this.message,
  });

  List<String>? to;
  List<String>? cc;
  String? senderEmail;
  String? senderName;
  String? subject;
  String? message;

  factory EmailViewModel.fromJson(Map<String, dynamic> json) => EmailViewModel(
        to: json["To"] == null
            ? null
            : List<String>.from(json["To"].map((x) => x)),
        cc: json["CC"] == null
            ? null
            : List<String>.from(json["CC"].map((x) => x)),
        senderEmail: json["SenderEmail"],
        senderName: json["SenderName"],
        subject: json["Subject"],
        message: json["Message"],
      );

  Map<String, dynamic> toJson() => {
        "To": to == null ? null : List<dynamic>.from(to!.map((x) => x)),
        "CC": cc == null ? null : List<dynamic>.from(cc!.map((x) => x)),
        "SenderEmail": senderEmail,
        "SenderName": senderName,
        "Subject": subject,
        "Message": message,
      };
}
