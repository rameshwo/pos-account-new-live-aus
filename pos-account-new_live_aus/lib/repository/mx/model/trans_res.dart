import 'package:flutter/material.dart';
import 'package:pos_account/model/home/menu/place_order/po_pay_sec_list_res.dart';

class MxTransRes {
  MxTranResData? data;
  EftposMerchant? terminal;

  MxTransRes({
    this.data,
    this.terminal,
  });

  factory MxTransRes.fromJson(Map<String, dynamic> json) => MxTransRes(
        data:
            json["data"] == null ? null : MxTranResData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
      };
}

class MxTranResData {
  String? id;
  int? version;
  String? status;
  String? message;
  String? merchantReceipt;
  String? customerReceipt;
  ResultAmounts? resultAmounts;
  String? resultFinancialStatus;
  PosInstructions? posInstructions;

  MxTranResData({
    this.id,
    this.version,
    this.status,
    this.message,
    this.merchantReceipt,
    this.customerReceipt,
    this.resultAmounts,
    this.resultFinancialStatus,
    this.posInstructions,
  });

  factory MxTranResData.fromJson(Map<String, dynamic> json) => MxTranResData(
        id: json["id"],
        version: json["version"],
        status: json["status"],
        message: json["message"],
        merchantReceipt: json["merchant_receipt"],
        customerReceipt: json["customer_receipt"],
        resultAmounts: json["result_amounts"] == null
            ? null
            : ResultAmounts.fromJson(json["result_amounts"]),
        resultFinancialStatus: json["result_financial_status"],
        posInstructions: json["pos_instructions"] == null
            ? null
            : PosInstructions.fromJson(json["pos_instructions"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "version": version,
        "status": status,
        "message": message,
        "merchant_receipt": merchantReceipt,
        "customer_receipt": customerReceipt,
        "result_amounts": resultAmounts?.toJson(),
        "result_financial_status": resultFinancialStatus,
        "pos_instructions": posInstructions?.toJson(),
      };
}

class ResultAmounts {
  int? purchaseAmount;
  int? tipAmount;
  int? surchargeAmount;
  int? cashoutAmount;
  int? refundAmount;
  int? motoAmount;

  ResultAmounts({
    this.purchaseAmount,
    this.tipAmount,
    this.surchargeAmount,
    this.cashoutAmount,
    this.refundAmount,
    this.motoAmount,
  });

  factory ResultAmounts.fromJson(Map<String, dynamic> json) => ResultAmounts(
        purchaseAmount: json["purchase_amount"],
        tipAmount: json["tip_amount"],
        surchargeAmount: json["surcharge_amount"],
        cashoutAmount: json["cashout_amount"],
        refundAmount: json["refund_amount"],
        motoAmount: json["moto_amount"],
      );

  Map<String, dynamic> toJson() => {
        "purchase_amount": purchaseAmount,
        "tip_amount": tipAmount,
        "surcharge_amount": surchargeAmount,
        "cashout_amount": cashoutAmount,
        "refund_amount": refundAmount,
        "moto_amount": motoAmount,
      };
}

class PosInstructions {
  dynamic autoActions;
  ActionForm? actionForm;

  PosInstructions({
    this.autoActions,
    this.actionForm,
  });

  factory PosInstructions.fromJson(Map<String, dynamic> json) =>
      PosInstructions(
        autoActions: json["auto_actions"],
        actionForm: json["action_form"] == null
            ? null
            : ActionForm.fromJson(json["action_form"]),
      );

  Map<String, dynamic> toJson() => {
        "auto_actions": autoActions,
        "action_form": actionForm?.toJson(),
      };
}

class ActionForm {
  List<Layout>? layout;
  Map<String, dynamic>? properties;
  Map<String, dynamic>? details;

  ActionForm({
    this.layout,
    this.properties,
    this.details,
  });

  factory ActionForm.fromJson(Map<String, dynamic> json) => ActionForm(
        layout: json["layout"] == null
            ? []
            : List<Layout>.from(json["layout"]!.map((x) => Layout.fromJson(x))),
        properties: json["properties"],
        //  == null
        //     ? null
        //     : Properties.fromJson(json["properties"]),
        details: json[
            "details"], // == null ? null : Details.fromJson(json["details"]),
      );

  Map<String, dynamic> toJson() => {
        "layout": layout == null
            ? []
            : List<dynamic>.from(layout!.map((x) => x.toJson())),
        "properties": properties,
        "details": details, // ?.toJson(),
      };
}

// class Details {
//   String? pairingId;
//   String? tid;
//   String? transactionId;
//   String? transactionVersion;

//   Details({
//     this.pairingId,
//     this.tid,
//     this.transactionId,
//     this.transactionVersion,
//   });

//   factory Details.fromJson(Map<String, dynamic> json) => Details(
//         pairingId: json["Pairing ID"],
//         tid: json["TID"],
//         transactionId: json["Transaction ID"],
//         transactionVersion: json["Transaction Version"],
//       );

//   Map<String, dynamic> toJson() => {
//         "Pairing ID": pairingId,
//         "TID": tid,
//         "Transaction ID": transactionId,
//         "Transaction Version": transactionVersion,
//       };
// }

class Layout {
  String? type;
  List<Element>? elements;

  Layout({
    this.type,
    this.elements,
  });

  factory Layout.fromJson(Map<String, dynamic> json) => Layout(
        type: json["type"],
        elements: json["elements"] == null
            ? []
            : List<Element>.from(
                json["elements"]!.map((x) => Element.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "elements": elements == null
            ? []
            : List<dynamic>.from(elements!.map((x) => x.toJson())),
      };
}

class Element {
  String? label;
  String? key;
  TextEditingController? textCltr;

  Element({
    this.label,
    this.key,
    this.textCltr,
  });

  factory Element.fromJson(Map<String, dynamic> json) => Element(
        label: json["label"],
        key: json["key"],
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "key": key,
      };
}

// class Properties {
//   PrintCustomerReceipt? printCustomerReceipt;
//   PrintCustomerReceipt? printMerchantReceipt;
//   PrintCustomerReceipt? transactionComplete;
//   PrintCustomerReceipt? cancelTransaction;
//   PrintCustomerReceipt? retryTransaction;

//   Properties({
//     this.printCustomerReceipt,
//     this.printMerchantReceipt,
//     this.transactionComplete,
//     this.cancelTransaction,
//     this.retryTransaction,
//   });

//   factory Properties.fromJson(Map<String, dynamic> json) => Properties(
//         printCustomerReceipt: json["print_customer_receipt"] == null
//             ? null
//             : PrintCustomerReceipt.fromJson(json["print_customer_receipt"]),
//         printMerchantReceipt: json["print_merchant_receipt"] == null
//             ? null
//             : PrintCustomerReceipt.fromJson(json["print_merchant_receipt"]),
//         transactionComplete: json["transaction_complete"] == null
//             ? null
//             : PrintCustomerReceipt.fromJson(json["transaction_complete"]),
//         cancelTransaction: json["cancel_transaction"] == null
//             ? null
//             : PrintCustomerReceipt.fromJson(json["cancel_transaction"]),
//         retryTransaction: json["retry_transaction"] == null
//             ? null
//             : PrintCustomerReceipt.fromJson(json["retry_transaction"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "print_customer_receipt": printCustomerReceipt?.toJson(),
//         "print_merchant_receipt": printMerchantReceipt?.toJson(),
//         "transaction_complete": transactionComplete?.toJson(),
//         "cancel_transaction": cancelTransaction?.toJson(),
//         "retry_transaction": retryTransaction?.toJson(),
//       };
// }

// class PrintCustomerReceipt {
//   String? type;
//   String? submitUrl;
//   String? action;
//   String? text;

//   PrintCustomerReceipt({
//     this.type,
//     this.submitUrl,
//     this.action,
//     this.text,
//   });

//   factory PrintCustomerReceipt.fromJson(Map<String, dynamic> json) =>
//       PrintCustomerReceipt(
//         type: json["type"],
//         submitUrl: json["submit_url"],
//         action: json["action"],
//         text: json["text"],
//       );

//   Map<String, dynamic> toJson() => {
//         "type": type,
//         "submit_url": submitUrl,
//         "action": action,
//         "text": text,
//       };
// }
