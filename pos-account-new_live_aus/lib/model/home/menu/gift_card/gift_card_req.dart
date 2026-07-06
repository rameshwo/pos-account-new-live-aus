class GiftcardReq {
  GiftcardReq({
    this.id,
    this.code,
    this.amount,
    this.message,
    this.senderViewModel,
    this.receiverViewModel,
    this.giftCardPaymentModel,
    this.giftCardTemplateId,
  });

  String? id;
  String? code;
  String? amount;
  String? message;
  ErViewModel? senderViewModel;
  ErViewModel? receiverViewModel;
  GiftCardPaymentModel? giftCardPaymentModel;
  String? giftCardTemplateId;

  factory GiftcardReq.fromJson(Map<String, dynamic> json) => GiftcardReq(
        id: json["Id"],
        code: json["Code"],
        amount: json["Amount"],
        message: json["Message"],
        senderViewModel: json["SenderViewModel"] == null
            ? null
            : ErViewModel.fromJson(json["SenderViewModel"]),
        receiverViewModel: json["ReceiverViewModel"] == null
            ? null
            : ErViewModel.fromJson(json["ReceiverViewModel"]),
        giftCardPaymentModel: json["GiftCardPaymentModel"] == null
            ? null
            : GiftCardPaymentModel.fromJson(json["GiftCardPaymentModel"]),
        giftCardTemplateId: json["GiftCardTemplateId"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Code": code,
        "Amount": amount,
        "Message": message,
        "SenderViewModel": senderViewModel?.toJson(),
        "ReceiverViewModel": receiverViewModel?.toJson(),
        "GiftCardPaymentModel": giftCardPaymentModel?.toJson(),
        "GiftCardTemplateId": giftCardTemplateId,
      };
}

class GiftCardPaymentModel {
  GiftCardPaymentModel({
    this.isScheduledForFuture,
    this.giftCardScheduledDate,
    this.paidAmount,
    this.paymentMethodId,
  });

  bool? isScheduledForFuture;
  String? giftCardScheduledDate;
  String? paidAmount;
  String? paymentMethodId;

  factory GiftCardPaymentModel.fromJson(Map<String, dynamic> json) =>
      GiftCardPaymentModel(
        isScheduledForFuture: json["IsScheduledForFuture"],
        giftCardScheduledDate: json["GiftCardScheduledDate"],
        paidAmount: json["PaidAmount"],
        paymentMethodId: json["PaymentMethodId"],
      );

  Map<String, dynamic> toJson() => {
        "IsScheduledForFuture": isScheduledForFuture,
        "GiftCardScheduledDate": giftCardScheduledDate,
        "PaidAmount": paidAmount,
        "PaymentMethodId": paymentMethodId,
      };
}

class ErViewModel {
  ErViewModel({
    this.id,
    this.name,
    this.email,
    this.countryPhoneNumberPrefixId,
    this.phoneNumber,
    this.countryId,
    this.postalCode,
  });

  String? id;
  String? name;
  String? email;
  String? countryPhoneNumberPrefixId;
  String? phoneNumber;
  String? countryId;
  String? postalCode;

  factory ErViewModel.fromJson(Map<String, dynamic> json) => ErViewModel(
        id: json["Id"],
        name: json["Name"],
        email: json["Email"],
        countryPhoneNumberPrefixId: json["CountryPhoneNumberPrefixId"],
        phoneNumber: json["PhoneNumber"],
        countryId: json["CountryId"],
        postalCode: json["PostalCode"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Name": name,
        "Email": email,
        "CountryPhoneNumberPrefixId": countryPhoneNumberPrefixId,
        "PhoneNumber": phoneNumber,
        "CountryId": countryId,
        "PostalCode": postalCode,
      };
}
