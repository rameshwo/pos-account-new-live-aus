import 'make_pay_res.dart';

class RefundPaymentRes {
  String? message;
  bool? askForPrintConfirmation;
  String? taxType;
  String? url;
  List<PrintingInvoiceDetailsResponseViewModel>?
      printingRefundDetailsResponseViewModels;
  List<PrintingMerchantInvoiceDetailsResponseViewModel>?
      printingMerchantInvoiceDetailsResponseViewModels;
  String? orderId;
  String? sessionId;
  String? posDeviceId;
  bool? printAllItems;
  bool? sendToKitchenPrinter;
  bool? sendToKitchenDisplay;

  RefundPaymentRes({
    this.message,
    this.askForPrintConfirmation,
    this.taxType,
    this.url,
    this.printingRefundDetailsResponseViewModels,
    this.printingMerchantInvoiceDetailsResponseViewModels,
    this.orderId,
    this.sessionId,
    this.posDeviceId,
    this.printAllItems,
    this.sendToKitchenPrinter,
    this.sendToKitchenDisplay,
  });

  factory RefundPaymentRes.fromJson(Map<String, dynamic> json) =>
      RefundPaymentRes(
        message: json["message"],
        askForPrintConfirmation: json["askForPrintConfirmation"],
        taxType: json["taxType"],
        url: json["url"],
        printingRefundDetailsResponseViewModels:
            json["printingRefundDetailsResponseViewModels"] == null
                ? []
                : List<PrintingInvoiceDetailsResponseViewModel>.from(
                    json["printingRefundDetailsResponseViewModels"]!.map((x) =>
                        PrintingInvoiceDetailsResponseViewModel.fromJson(x))),
        printingMerchantInvoiceDetailsResponseViewModels:
            json["printingMerchantInvoiceDetailsResponseViewModels"] == null
                ? []
                : List<PrintingMerchantInvoiceDetailsResponseViewModel>.from(
                    json["printingMerchantInvoiceDetailsResponseViewModels"]!
                        .map((x) =>
                            PrintingMerchantInvoiceDetailsResponseViewModel
                                .fromJson(x))),
        orderId: json["orderId"],
        sessionId: json["sessionId"],
        posDeviceId: json["posDeviceId"],
        printAllItems: json["printAllItems"],
        sendToKitchenPrinter: json["sendToKitchenPrinter"],
        sendToKitchenDisplay: json["sendToKitchenDisplay"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "askForPrintConfirmation": askForPrintConfirmation,
        "taxType": taxType,
        "url": url,
        "printingRefundDetailsResponseViewModels":
            printingRefundDetailsResponseViewModels == null
                ? []
                : List<dynamic>.from(printingRefundDetailsResponseViewModels!
                    .map((x) => x.toJson())),
        "printingMerchantInvoiceDetailsResponseViewModels":
            printingMerchantInvoiceDetailsResponseViewModels == null
                ? []
                : List<dynamic>.from(
                    printingMerchantInvoiceDetailsResponseViewModels!
                        .map((x) => x.toJson())),
        "orderId": orderId,
        "sessionId": sessionId,
        "posDeviceId": posDeviceId,
        "printAllItems": printAllItems,
        "sendToKitchenPrinter": sendToKitchenPrinter,
        "sendToKitchenDisplay": sendToKitchenDisplay,
      };
}
