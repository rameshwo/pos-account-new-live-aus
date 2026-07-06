class MerchantLog {
  MerchantInvoiceRequestViewModel? merchantInvoiceRequestViewModel;
  String? orderId;
  String? transactionRefId;

  MerchantLog({
    this.merchantInvoiceRequestViewModel,
    this.orderId,
    this.transactionRefId,
  });

  factory MerchantLog.fromJson(Map<String, dynamic> json) => MerchantLog(
        merchantInvoiceRequestViewModel:
            json["MerchantInvoiceRequestViewModel"] == null
                ? null
                : MerchantInvoiceRequestViewModel.fromJson(
                    json["MerchantInvoiceRequestViewModel"]),
        orderId: json["OrderId"],
        transactionRefId: json["TransactionRefId"],
      );

  Map<String, dynamic> toJson() => {
        "MerchantInvoiceRequestViewModel":
            merchantInvoiceRequestViewModel?.toJson(),
        "OrderId": orderId,
        "TransactionRefId": transactionRefId,
      };
}

class MerchantInvoiceRequestViewModel {
  String? merchantInvoiceData;
  String? customerInvoiceData;

  MerchantInvoiceRequestViewModel({
    this.merchantInvoiceData,
    this.customerInvoiceData,
  });

  factory MerchantInvoiceRequestViewModel.fromJson(Map<String, dynamic> json) =>
      MerchantInvoiceRequestViewModel(
        merchantInvoiceData: json["MerchantInvoiceData"],
        customerInvoiceData: json["CustomerInvoiceData"],
      );

  Map<String, dynamic> toJson() => {
        "MerchantInvoiceData": merchantInvoiceData,
        "CustomerInvoiceData": customerInvoiceData,
      };
}
