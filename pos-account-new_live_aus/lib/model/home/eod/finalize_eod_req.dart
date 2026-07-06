import 'all_eod_data.dart';

class FinalizeEodReq {
  FinalizeEodReq({
    this.date,
    this.taxExclusiveInclusiveId,
    this.accountingPlatformId,
    this.eodChartOfAccountPayments,
    this.emailModel,
    this.isSendMailAndFinalize,
    this.isFinalize,
    this.isSendMail,
  });

  String? date;
  String? taxExclusiveInclusiveId;
  String? accountingPlatformId;
  List<EodChartOfAccountPayment>? eodChartOfAccountPayments;
  EmailModel? emailModel;
  bool? isSendMailAndFinalize;
  bool? isFinalize;
  bool? isSendMail;

  factory FinalizeEodReq.fromJson(Map<String, dynamic> json) => FinalizeEodReq(
        date: json["Date"],
        accountingPlatformId: json["AccountingPlatformId"],
        taxExclusiveInclusiveId: json["TaxExclusiveInclusiveId"],
        eodChartOfAccountPayments: json["EODChartOfAccountPayments"] == null
            ? []
            : List<EodChartOfAccountPayment>.from(
                json["EODChartOfAccountPayments"]!
                    .map((x) => EodChartOfAccountPayment.fromJson(x))),
        emailModel: json["EmailModel"] == null
            ? null
            : EmailModel.fromJson(json["EmailModel"]),
        isSendMailAndFinalize: json["IsSendMailAndFinalize"],
        isFinalize: json["IsFinalize"],
        isSendMail: json["IsSendMail"],
      );

  Map<String, dynamic> toJson() => {
        "Date": date,
        "AccountingPlatformId": accountingPlatformId,
        "TaxExclusiveInclusiveId": taxExclusiveInclusiveId,
        "EODChartOfAccountPayments": eodChartOfAccountPayments == null
            ? []
            : List<dynamic>.from(
                eodChartOfAccountPayments!.map((x) => x.toJson())),
        "EmailModel": emailModel?.toJson(),
        "IsSendMailAndFinalize": isSendMailAndFinalize,
        "IsFinalize": isFinalize,
        "IsSendMail": isSendMail,
      };
}

class EmailModel {
  EmailModel({
    this.to,
    this.message,
    this.subject,
  });

  List<String>? to;
  String? message;
  String? subject;

  factory EmailModel.fromJson(Map<String, dynamic> json) => EmailModel(
        to: json["To"] == null
            ? []
            : List<String>.from(json["To"]!.map((x) => x)),
        message: json["Message"],
        subject: json["Subject"],
      );

  Map<String, dynamic> toJson() => {
        "To": to == null ? [] : List<dynamic>.from(to!.map((x) => x)),
        "Message": message,
        "Subject": subject,
      };
}
