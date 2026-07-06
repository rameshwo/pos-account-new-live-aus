class MxTransReq {
  bool? printMerchantReceipt;
  bool? promptCustomerReceipt;
  bool? verifySignatureOnTerminal;
  bool? posAutoPrintSignatureReceipt;
  PurchaseDetails? purchaseDetails;
  CashoutDetails? cashoutDetails;
  PurchaseWithCashoutDetails? purchaseWithCashoutDetails;
  MotoDetails? motoDetails;
  RefundDetails? refundDetails;

  MxTransReq({
    this.printMerchantReceipt,
    this.promptCustomerReceipt,
    this.verifySignatureOnTerminal,
    this.posAutoPrintSignatureReceipt,
    this.purchaseDetails,
    this.cashoutDetails,
    this.purchaseWithCashoutDetails,
    this.motoDetails,
    this.refundDetails,
  });

  factory MxTransReq.fromJson(Map<String, dynamic> json) => MxTransReq(
        printMerchantReceipt: json["print_merchant_receipt"],
        promptCustomerReceipt: json["prompt_customer_receipt"],
        verifySignatureOnTerminal: json["verify_signature_on_terminal"],
        posAutoPrintSignatureReceipt: json["pos_auto_print_signature_receipt"],
        purchaseDetails: json["purchase_details"] == null
            ? null
            : PurchaseDetails.fromJson(json["purchase_details"]),
        cashoutDetails: json["cashout_details"] == null
            ? null
            : CashoutDetails.fromJson(json["cashout_details"]),
        purchaseWithCashoutDetails:
            json["purchase_with_cashout_details"] == null
                ? null
                : PurchaseWithCashoutDetails.fromJson(
                    json["purchase_with_cashout_details"]),
        motoDetails: json["moto_details"] == null
            ? null
            : MotoDetails.fromJson(json["moto_details"]),
        refundDetails: json["refund_details"] == null
            ? null
            : RefundDetails.fromJson(json["refund_details"]),
      );

  Map<String, dynamic> toJson() => {
        "print_merchant_receipt": printMerchantReceipt,
        "prompt_customer_receipt": promptCustomerReceipt,
        "verify_signature_on_terminal": verifySignatureOnTerminal,
        "pos_auto_print_signature_receipt": posAutoPrintSignatureReceipt,
        if (purchaseDetails != null)
          "purchase_details": purchaseDetails?.toJson(),
        if (cashoutDetails != null) "cashout_details": cashoutDetails?.toJson(),
        if (purchaseWithCashoutDetails != null)
          "purchase_with_cashout_details": purchaseWithCashoutDetails?.toJson(),
        if (motoDetails != null) "moto_details": motoDetails?.toJson(),
        if (refundDetails != null) "refund_details": refundDetails?.toJson(),
      };
}

class PurchaseDetails {
  int? purchaseAmount;
  int? tipAmount;
  int? surchargeAmount;

  PurchaseDetails({
    this.purchaseAmount,
    this.tipAmount,
    this.surchargeAmount,
  });

  factory PurchaseDetails.fromJson(Map<String, dynamic> json) =>
      PurchaseDetails(
        purchaseAmount: json["purchase_amount"],
        tipAmount: json["tip_amount"],
        surchargeAmount: json["surcharge_amount"],
      );

  Map<String, dynamic> toJson() => {
        "purchase_amount": purchaseAmount,
        "tip_amount": tipAmount,
        "surcharge_amount": surchargeAmount,
      };
}

class CashoutDetails {
  int? cashoutAmount;
  int? surchargeAmount;

  CashoutDetails({
    this.cashoutAmount,
    this.surchargeAmount,
  });

  factory CashoutDetails.fromJson(Map<String, dynamic> json) => CashoutDetails(
        cashoutAmount: json["cashout_amount"],
        surchargeAmount: json["surcharge_amount"],
      );

  Map<String, dynamic> toJson() => {
        "cashout_amount": cashoutAmount,
        "surcharge_amount": surchargeAmount,
      };
}

class PurchaseWithCashoutDetails {
  int? purchaseAmount;
  int? cashoutAmount;
  int? surchargeAmount;

  PurchaseWithCashoutDetails({
    this.purchaseAmount,
    this.cashoutAmount,
    this.surchargeAmount,
  });

  factory PurchaseWithCashoutDetails.fromJson(Map<String, dynamic> json) =>
      PurchaseWithCashoutDetails(
        purchaseAmount: json["purchase_amount"],
        cashoutAmount: json["cashout_amount"],
        surchargeAmount: json["surcharge_amount"],
      );

  Map<String, dynamic> toJson() => {
        "purchase_amount": purchaseAmount,
        "cashout_amount": cashoutAmount,
        "surcharge_amount": surchargeAmount,
      };
}

class MotoDetails {
  int? motoAmount;
  int? surchargeAmount;

  MotoDetails({
    this.motoAmount,
    this.surchargeAmount,
  });

  factory MotoDetails.fromJson(Map<String, dynamic> json) => MotoDetails(
        motoAmount: json["moto_amount"],
        surchargeAmount: json["surcharge_amount"],
      );

  Map<String, dynamic> toJson() => {
        "moto_amount": motoAmount,
        "surcharge_amount": surchargeAmount,
      };
}

class RefundDetails {
  int? refundAmount;

  RefundDetails({
    this.refundAmount,
  });

  factory RefundDetails.fromJson(Map<String, dynamic> json) => RefundDetails(
        refundAmount: json["refund_amount"],
      );

  Map<String, dynamic> toJson() => {
        "refund_amount": refundAmount,
      };
}



// final _req = {
//   "purchase_details": {"purchase_amount": 2197, "surcharge_amount": 0},
//   "print_merchant_receipt": false,
//   "prompt_customer_receipt": false,
//   "verify_signature_on_terminal": false
// };

// final _res = {
//   "data": {
//     "id": "12c1c116-0776-4a44-861c-7269dc469429",
//     "version": 1,
//     "status": "PENDING",
//     "message": "Waiting for terminal to accept transaction",
//     "merchant_receipt": null,
//     "customer_receipt": null,
//     "result_amounts": null,
//     "pos_instructions": {
//       "auto_actions": null,
//       "action_form": {
//         "layout": null,
//         "properties": null,
//         "details": {
//           "Pairing ID": "pid_39571548-88e0-4bfe-9a21-8d37a88ea3cb",
//           "TID": "30118002",
//           "Transaction ID": "12c1c116-0776-4a44-861c-7269dc469429",
//           "Transaction Version": "1"
//         }
//       }
//     }
//   }
// };
