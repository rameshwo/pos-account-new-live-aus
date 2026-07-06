import 'package:flutter/material.dart';

class BarcodeLabelPrintViewModel {
  String? productCode;
  String? productName;
  String? actualPrice;
  String? discountPrice;
  String? barCodeNumber;
  GenBarcodePrintRes? printingSetupViewModel;
  Widget? captureWidget;

  BarcodeLabelPrintViewModel({
    this.productCode,
    this.productName,
    this.actualPrice,
    this.discountPrice,
    this.barCodeNumber,
    this.printingSetupViewModel,
    this.captureWidget,
  });

  factory BarcodeLabelPrintViewModel.fromJson(Map<String, dynamic> json) =>
      BarcodeLabelPrintViewModel(
        productCode: json["productCode"],
        productName: json["productName"],
        actualPrice: json["actualPrice"],
        discountPrice: json["discountPrice"],
        barCodeNumber: json["barCodeNumber"],
        printingSetupViewModel: json["printingSetupViewModel"] == null
            ? null
            : GenBarcodePrintRes.fromJson(json["printingSetupViewModel"]),
      );

  Map<String, dynamic> toJson() => {
        "productCode": productCode,
        "productName": productName,
        "actualPrice": actualPrice,
        "discountPrice": discountPrice,
        "barCodeNumber": barCodeNumber,
        "printingSetupViewModel": printingSetupViewModel?.toJson(),
      };
}

class GenBarcodePrintRes {
  List<BarcodeLabelPrintViewModel>? barcodeLabelPrintViewModels;
  String? marginTop;
  String? marginButtom;
  String? marginLeft;
  String? marginRight;
  String? fontFamily;
  String? fontSize;
  String? barCodeWidth;
  String? barCodeHeight;

  GenBarcodePrintRes({
    this.barcodeLabelPrintViewModels,
    this.marginTop,
    this.marginButtom,
    this.marginLeft,
    this.marginRight,
    this.fontFamily,
    this.fontSize,
    this.barCodeWidth,
    this.barCodeHeight,
  });

  factory GenBarcodePrintRes.fromJson(Map<String, dynamic> json) =>
      GenBarcodePrintRes(
        barcodeLabelPrintViewModels: json["barcodeLabelPrintViewModels"] == null
            ? []
            : List<BarcodeLabelPrintViewModel>.from(
                json["barcodeLabelPrintViewModels"]!
                    .map((x) => BarcodeLabelPrintViewModel.fromJson(x))),
        marginTop: json["marginTop"],
        marginButtom: json["marginButtom"],
        marginLeft: json["marginLeft"],
        marginRight: json["marginRight"],
        fontFamily: json["fontFamily"],
        fontSize: json["fontSize"],
        barCodeWidth: json["barCodeWidth"],
        barCodeHeight: json["barCodeHeight"],
      );

  Map<String, dynamic> toJson() => {
        "barcodeLabelPrintViewModels": barcodeLabelPrintViewModels == null
            ? []
            : List<dynamic>.from(
                barcodeLabelPrintViewModels!.map((x) => x.toJson())),
        "marginTop": marginTop,
        "marginButtom": marginButtom,
        "marginLeft": marginLeft,
        "marginRight": marginRight,
        "fontFamily": fontFamily,
        "fontSize": fontSize,
        "barCodeWidth": barCodeWidth,
        "barCodeHeight": barCodeHeight,
      };
}
