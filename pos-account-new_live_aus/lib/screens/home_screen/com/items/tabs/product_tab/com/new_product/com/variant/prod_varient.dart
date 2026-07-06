import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/product/new_product_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/product_tab/com/new_product/com/variant/modifier/modifier_dia.dart';
import 'package:pos_account/widgets/cus_expansion_tile.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/switch_adap.dart';
import 'package:provider/provider.dart';
import 'batch/batch_list_sec.dart';
import 'batch/batch_sec.dart';
import 'info_row.dart';
import 'raw_ingre/raw_ingre_list_sec.dart';
import 'raw_ingre/raw_ingre_sec.dart';
import 'spices_section.dart';
import 'supplier/sup_list_sec.dart';
import 'supplier/sup_sec.dart';

enum _PriceType { Price, DisPrice, DisPer }

class ProductVarient extends StatelessWidget {
  const ProductVarient({
    super.key,
    required this.size,
    this.remove,
    this.index = 0,
    required this.animation,
    this.ppVarient,
    this.changeDefault,
    required this.num,
    this.isService = false,
  });

  final int index;

  final Ssize size;
  final Function()? remove;
  final Function(bool?)? changeDefault;
  final Animation<double> animation;
  final PPVarient? ppVarient;
  final int num;
  final bool isService;

  void _clearPrice(int i) {
    final pvpvmList = ppVarient!.channels;
    pvpvmList[i].disPercentCltr.clear();
    pvpvmList[i].disPriceCltr.clear();
    pvpvmList[i].newSellingPriceCltr.clear();
  }

  void onChangePrice({required _PriceType priceType, required int i}) {
    final price = ppVarient?.channels[i].sellingPriceCltr.text.inDouble ?? 0;
    if ((ppVarient?.channels[i].sellingPriceCltr.text.isNotEmpty ?? false) &&
        price == 0) return;

    final disPer = ppVarient?.channels[i].disPercentCltr.text.inDouble ?? 0;

    final disPer0 = disPer == 0 || disPer.isInfinite || disPer.isNaN;

    final disPrice = ppVarient?.channels[i].disPriceCltr.text.inDouble ?? 0;

    final disPrice0 = disPrice == 0 || disPrice.isInfinite || disPrice.isNaN;

    if (priceType == _PriceType.Price) {
      if ((ppVarient?.channels[i].disPercentCltr.text.isNotEmpty ?? false) &&
          disPer0) {
        _clearPrice(i);
        return;
      }

      if (disPer0) {
        _clearPrice(i);
      } else {
        final _disPriceValue = price * disPer / 100;

        ppVarient?.channels[i].disPriceCltr.text =
            _disPriceValue.roundToNString();

        ppVarient?.channels[i].newSellingPriceCltr.text = _disPriceValue == 0
            ? ""
            : (price - _disPriceValue).roundToNString();
      }
    } else if (priceType == _PriceType.DisPrice) {
      if ((ppVarient?.channels[i].disPriceCltr.text.isNotEmpty ?? false) &&
          disPrice0) return;

      if (disPrice0) {
        _clearPrice(i);
      } else {
        final _disPerValue = (disPrice / price) * 100;

        ppVarient?.channels[i].disPercentCltr.text =
            _disPerValue.roundToNString();

        ppVarient?.channels[i].newSellingPriceCltr.text =
            disPrice == 0 ? "" : (price - disPrice).roundToNString();
      }
    } else if (priceType == _PriceType.DisPer) {
      if ((ppVarient?.channels[i].disPercentCltr.text.isNotEmpty ?? false) &&
          disPer0) return;

      if (disPer0) {
        _clearPrice(i);
      } else {
        final disPriceValue = price * disPer / 100;

        ppVarient?.channels[i].disPriceCltr.text =
            disPriceValue.roundToNString();

        ppVarient?.channels[i].newSellingPriceCltr.text =
            disPriceValue == 0 ? "" : (price - disPriceValue).roundToNString();
      }
    }

    if (changeDefault != null) changeDefault!(null);
    isInvalid(i);
  }

  bool isInvalid(int i) {
    final newPrice =
        ppVarient?.channels[i].newSellingPriceCltr.text.inDouble ?? 0;

    if (newPrice < 0) {
      showToast(LN.disAmtHigher);
      return true;
    } else
      return false;
  }

  @override
  Widget build(BuildContext context) {
    final newProdPro = Provider.of<NewProductPro>(context);
    final _modiGroup =
        (newProdPro.editData?.productVariations?.isNotEmpty ?? false) &&
                (index < newProdPro.editData!.productVariations!.length)
            ? (newProdPro.editData?.productVariations?[index]
                .productVariationModifierGroups)
            : null;

    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black38)),
      padding: EdgeInsets.symmetric(horizontal: size.getW(24)),
      child: SizeTransition(
        // key: ValueKey(animation), //make transition better
        sizeFactor: animation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Theme(
              data: ThemeData().copyWith(dividerColor: Colors.transparent),
              child: CusExpansionTile(
                initiallyExpanded: true,
                tilePadding: EdgeInsets.zero,
                childrenPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${LN.variant} $num",
                      style: TextStyle(
                        fontSize: size.getS(16),
                        fontFamily: kFontFMedium,
                        color: Colors.black,
                      ),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        changeDefault!(!ppVarient!.isDefault);
                      },
                      child: Row(
                        children: [
                          Checkbox(
                            value: ppVarient?.isDefault ?? false,
                            onChanged: changeDefault,
                          ),
                          Text(
                            LN.defaultText,
                            style: TextStyle(
                              fontSize: size.getS(17),
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: size.getW(24),
                    ),
                    if (remove != null)
                      Card(
                        elevation: 4,
                        margin: EdgeInsets.zero,
                        shadowColor: Colors.grey[200],
                        color: kIconBackColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        child: InkWell(
                          onTap: remove,
                          child: Padding(
                            padding: EdgeInsets.all(size.getW(11.0)),
                            child: SvgPicture.asset(
                              "assets/svg/icons/Delete.svg",
                              width: size.getW(17),
                              height: size.getW(12),
                            ),
                          ),
                        ),
                      )
                  ],
                ),
                children: [
                  SizedBox(
                    height: size.getH(6),
                  ),
                  if (isService) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TitleTextForm(
                            title: LN.code,
                            isDense: true,
                            isReq: false,
                            errH: 0,
                            borderColor: Colors.black54,
                            borderRadius: 5,
                            hintText: LN.code,
                            textInputType: TextInputType.number,
                            textCltr: ppVarient == null
                                ? TextEditingController()
                                : ppVarient!.codeCltr,
                            // hintStyle: TextStyle(fontSize: size.getS(14)),
                          ),
                        ),
                        SizedBox(
                          width: size.getW(12),
                        ),
                        Expanded(
                          flex: 2,
                          child: TitleTextForm(
                            title: LN.name,
                            isDense: true,
                            isReq: false,
                            errH: 0,
                            borderColor: Colors.black54,
                            borderRadius: 5,
                            textCltr: ppVarient == null
                                ? TextEditingController()
                                : ppVarient!.nameCltr,
                            hintText: LN.name,
                            maxLines: 4,
                            minLines: 1,
                            // hintStyle: TextStyle(fontSize: size.getS(14)),
                          ),
                        ),
                        SizedBox(
                          width: size.getW(12),
                        ),
                        Expanded(
                          child: TitleTextForm(
                            title: "Estimated Time",
                            isDense: true,
                            isReq: false,
                            errH: 0,
                            borderColor: Colors.black54,
                            borderRadius: 5,
                            textCltr: ppVarient == null
                                ? TextEditingController()
                                : ppVarient!.caloryCltr,
                            hintText: "Estimated time",
                            // hintStyle: TextStyle(fontSize: size.getS(14)),
                            suffixIcon: Text('min',
                                style: TextStyle(fontSize: size.getS(14))),
                            suffixIconWidth: 36,
                            textInputType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                        ),
                        SizedBox(
                          width: size.getW(2),
                        ),
                      ],
                    ),
                  ] else ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TitleTextForm(
                            title: LN.code,
                            isDense: true,
                            isReq: false,
                            errH: 0,
                            borderColor: Colors.black54,
                            borderRadius: 5,
                            hintText: LN.code,
                            textInputType: TextInputType.number,
                            textCltr: ppVarient == null
                                ? TextEditingController()
                                : ppVarient!.codeCltr,
                            // hintStyle: TextStyle(fontSize: size.getS(14)),
                          ),
                        ),
                        SizedBox(
                          width: size.getW(12),
                        ),
                        Expanded(
                          child: TitleTextForm(
                            title: LN.name,
                            isDense: true,
                            isReq: false,
                            errH: 0,
                            borderColor: Colors.black54,
                            borderRadius: 5,
                            textCltr: ppVarient == null
                                ? TextEditingController()
                                : ppVarient!.nameCltr,
                            hintText: LN.name,

                            maxLines: 4,
                            minLines: 1,
                            // hintStyle: TextStyle(fontSize: size.getS(14)),
                          ),
                        ),
                        SizedBox(
                          width: size.getW(12),
                        ),
                        Expanded(
                          child: TitleTextForm(
                            title: LN.calories,
                            isDense: true,
                            isReq: false,
                            errH: 0,
                            borderColor: Colors.black54,
                            borderRadius: 5,
                            textCltr: ppVarient == null
                                ? TextEditingController()
                                : ppVarient!.caloryCltr,
                            hintText: LN.calories,
                            // hintStyle: TextStyle(fontSize: size.getS(14)),
                          ),
                        ),
                        SizedBox(
                          width: size.getW(12),
                        ),

                        if (!GlobalCVP.isServiceStore) ...[
                          Expanded(
                            child: TitleTextForm(
                              title: LN.barcode,
                              isDense: true,
                              isReq: false,
                              errH: 0,
                              borderColor: Colors.black54,
                              borderRadius: 5,
                              textCltr: ppVarient == null
                                  ? TextEditingController()
                                  : ppVarient!.barcodeCltr,
                              hintText: LN.barcode,
                              textInputType: TextInputType.text,
                              // hintStyle: TextStyle(fontSize: size.getS(14)),
                            ),
                          ),
                          SizedBox(
                            width: size.getW(12),
                          ),
                        ],
                        Expanded(
                          child: TitleTextForm(
                            title: LN.unitPrice,
                            isDense: true,
                            isReq: false,
                            errH: 0,
                            borderColor: Colors.black54,
                            borderRadius: 5,
                            textCltr: ppVarient == null
                                ? TextEditingController()
                                : ppVarient!.unitPriceCltr,
                            hintText: LN.unitPrice,
                            textInputType: TextInputType.number,
                            // hintStyle: TextStyle(fontSize: size.getS(14)),
                          ),
                        ),
                        SizedBox(
                          width: size.getW(12),
                        ),
                        Expanded(
                          child: TitleTextForm(
                            title: LN.minStockAlert,
                            isDense: true,
                            isReq: false,
                            errH: 0,
                            borderColor: Colors.black54,
                            borderRadius: 5,
                            textCltr: ppVarient == null
                                ? TextEditingController()
                                : ppVarient!.minSACountCltr,
                            hintText: LN.minStockAlert,
                            textInputType: TextInputType.number,
                            // hintStyle: TextStyle(fontSize: size.getS(14)),
                          ),
                        ),
                        SizedBox(
                          width: size.getW(12),
                        ),
                        Expanded(
                          child: TitleTextForm(
                            title: LN.maxStockAlert,
                            isDense: true,
                            isReq: false,
                            errH: 0,
                            borderColor: Colors.black54,
                            borderRadius: 5,
                            textCltr: ppVarient == null
                                ? TextEditingController()
                                : ppVarient!.maxSACountCltr,
                            hintText: LN.maxStockAlert,
                            textInputType: TextInputType.number,
                            // hintStyle: TextStyle(fontSize: size.getS(14)),
                          ),
                        ),
                        SizedBox(
                          width: size.getW(12),
                        ),
                        Expanded(
                          child: TitleTextForm(
                            title: LN.sortOrder,
                            isDense: true,
                            isReq: false,
                            errH: 0,
                            borderColor: Colors.black54,
                            borderRadius: 5,
                            textCltr: ppVarient == null
                                ? TextEditingController()
                                : ppVarient!.sortOrderCltr,
                            hintText: LN.sortOrder,
                            textInputType: TextInputType.number,
                            maxLines: 4,
                            minLines: 1,
                            // hintStyle: TextStyle(fontSize: size.getS(14)),
                          ),
                        ),
                        if (ppVarient?.id.isNotEmpty ?? false) ...[
                          SizedBox(
                            width: size.getW(12),
                          ),
                          Expanded(
                            child: TitleTextForm(
                              title: LN.runningStock,
                              isDense: true,
                              isReq: false,
                              errH: 0,
                              borderColor: Colors.black26,
                              readOnly: true,
                              fillColor: Colors.grey[200]!,
                              borderRadius: 5,
                              textCltr: ppVarient == null
                                  ? TextEditingController()
                                  : ppVarient!.stockCountCltr,
                              hintText: LN.stock,
                              textInputType: TextInputType.number,
                              // hintStyle: TextStyle(fontSize: size.getS(14)),
                            ),
                          ),
                        ],
                        // if (!(ppVarient?.id.isNotEmpty ?? false)) ...[
                        //   SizedBox(width: size.getW(12)),
                        //   Expanded(child: Container())
                        // ]
                        SizedBox(
                          width: size.getW(2),
                        ),
                      ],
                    ),
                  ],
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.end,
                  //   children: [
                  //     Expanded(
                  //       child: TitleTextForm(
                  //         title: LN.code,
                  //         isDense: true,
                  //         isReq: false,
                  //         errH: 0,
                  //         borderColor: Colors.black54,
                  //         borderRadius: 5,
                  //         hintText: LN.code,
                  //         textInputType: TextInputType.number,
                  //         textCltr: ppVarient == null
                  //             ? TextEditingController()
                  //             : ppVarient!.codeCltr,
                  //         // hintStyle: TextStyle(fontSize: size.getS(14)),
                  //       ),
                  //     ),
                  //     SizedBox(
                  //       width: size.getW(12),
                  //     ),
                  //     Expanded(
                  //       child: TitleTextForm(
                  //         title: LN.name,
                  //         isDense: true,
                  //         isReq: false,
                  //         errH: 0,
                  //         borderColor: Colors.black54,
                  //         borderRadius: 5,
                  //         textCltr: ppVarient == null
                  //             ? TextEditingController()
                  //             : ppVarient!.nameCltr,
                  //         hintText: LN.name,
                  //         // hintStyle: TextStyle(fontSize: size.getS(14)),
                  //       ),
                  //     ),
                  //     SizedBox(
                  //       width: size.getW(12),
                  //     ),
                  //     if (!isService) ...[
                  //       Expanded(
                  //         child: TitleTextForm(
                  //           title: LN.calories,
                  //           isDense: true,
                  //           isReq: false,
                  //           errH: 0,
                  //           borderColor: Colors.black54,
                  //           borderRadius: 5,
                  //           textCltr: ppVarient == null
                  //               ? TextEditingController()
                  //               : ppVarient!.caloryCltr,
                  //           hintText: LN.calories,
                  //           // hintStyle: TextStyle(fontSize: size.getS(14)),
                  //         ),
                  //       ),
                  //       SizedBox(
                  //         width: size.getW(12),
                  //       ),
                  //       if (ppVarient?.id.isNotEmpty ?? false) ...[
                  //         Expanded(
                  //           child: TitleTextForm(
                  //             title: LN.runningStock,
                  //             isDense: true,
                  //             isReq: false,
                  //             errH: 0,
                  //             borderColor: Colors.black26,
                  //             readOnly: true,
                  //             fillColor: Colors.grey[200]!,
                  //             borderRadius: 5,
                  //             textCltr: ppVarient == null
                  //                 ? TextEditingController()
                  //                 : ppVarient!.stockCountCltr,
                  //             hintText: LN.stock,
                  //             textInputType: TextInputType.number,
                  //             // hintStyle: TextStyle(fontSize: size.getS(14)),
                  //           ),
                  //         ),
                  //         SizedBox(
                  //           width: size.getW(12),
                  //         )
                  //       ],
                  //       if (GlobalCVP.isRetailStore)
                  //         Expanded(
                  //           child: TitleTextForm(
                  //             title: LN.barcode,
                  //             isDense: true,
                  //             isReq: false,
                  //             errH: 0,
                  //             borderColor: Colors.black54,
                  //             borderRadius: 5,
                  //             textCltr: ppVarient == null
                  //                 ? TextEditingController()
                  //                 : ppVarient!.barcodeCltr,
                  //             hintText: LN.barcode,
                  //             textInputType: TextInputType.text,
                  //             // hintStyle: TextStyle(fontSize: size.getS(14)),
                  //           ),
                  //         )
                  //       else
                  //         Expanded(
                  //           child: TitleTextForm(
                  //             title: LN.unitPrice,
                  //             isDense: true,
                  //             isReq: false,
                  //             errH: 0,
                  //             borderColor: Colors.black54,
                  //             borderRadius: 5,
                  //             textCltr: ppVarient == null
                  //                 ? TextEditingController()
                  //                 : ppVarient!.unitPriceCltr,
                  //             hintText: LN.unitPrice,
                  //             textInputType: TextInputType.number,
                  //             // hintStyle: TextStyle(fontSize: size.getS(14)),
                  //           ),
                  //         )
                  //     ] else ...[
                  //       Expanded(
                  //         child: TitleTextForm(
                  //           title: "Estimated Time",
                  //           isDense: true,
                  //           isReq: false,
                  //           errH: 0,
                  //           borderColor: Colors.black54,
                  //           borderRadius: 5,
                  //           textCltr: ppVarient == null
                  //               ? TextEditingController()
                  //               : ppVarient!.caloryCltr,
                  //           hintText: "Estimated time",
                  //           // hintStyle: TextStyle(fontSize: size.getS(14)),
                  //           suffixIcon: Text('min',
                  //               style: TextStyle(fontSize: size.getS(14))),
                  //           suffixIconWidth: 36,
                  //           textInputType: TextInputType.number,
                  //           inputFormatters: [
                  //             FilteringTextInputFormatter.digitsOnly
                  //           ],
                  //         ),
                  //       ),
                  //       SizedBox(
                  //         width: size.getW(12),
                  //       )
                  //     ],
                  //     if (!(ppVarient?.id.isNotEmpty ?? false)) ...[
                  //       SizedBox(width: size.getW(12)),
                  //       Expanded(child: Container())
                  //     ]
                  //   ],
                  // ),
                  SizedBox(
                    height: size.getH(16),
                  ),
                  // if (!isService) ...[
                  //   Row(
                  //     children: [
                  //       if (GlobalCVP.isRetailStore) ...[
                  //         Expanded(
                  //           child: TitleTextForm(
                  //             title: LN.unitPrice,
                  //             isDense: true,
                  //             isReq: false,
                  //             errH: 0,
                  //             borderColor: Colors.black54,
                  //             borderRadius: 5,
                  //             textCltr: ppVarient == null
                  //                 ? TextEditingController()
                  //                 : ppVarient!.unitPriceCltr,
                  //             hintText: LN.unitPrice,
                  //             textInputType: TextInputType.number,
                  //             // hintStyle: TextStyle(fontSize: size.getS(14)),
                  //           ),
                  //         ),
                  //         SizedBox(
                  //           width: size.getW(12),
                  //         )
                  //       ],
                  //       Expanded(
                  //         child: TitleTextForm(
                  //           title: LN.minStockAlert,
                  //           isDense: true,
                  //           isReq: false,
                  //           errH: 0,
                  //           borderColor: Colors.black54,
                  //           borderRadius: 5,
                  //           textCltr: ppVarient == null
                  //               ? TextEditingController()
                  //               : ppVarient!.minSACountCltr,
                  //           hintText: LN.minStockAlert,
                  //           textInputType: TextInputType.number,
                  //           // hintStyle: TextStyle(fontSize: size.getS(14)),
                  //         ),
                  //       ),
                  //       SizedBox(
                  //         width: size.getW(12),
                  //       ),
                  //       Expanded(
                  //         child: TitleTextForm(
                  //           title: LN.maxStockAlert,
                  //           isDense: true,
                  //           isReq: false,
                  //           errH: 0,
                  //           borderColor: Colors.black54,
                  //           borderRadius: 5,
                  //           textCltr: ppVarient == null
                  //               ? TextEditingController()
                  //               : ppVarient!.maxSACountCltr,
                  //           hintText: LN.maxStockAlert,
                  //           textInputType: TextInputType.number,
                  //           // hintStyle: TextStyle(fontSize: size.getS(14)),
                  //         ),
                  //       ),
                  //       // SizedBox(
                  //       //   width: size.getW(12),
                  //       // ),
                  //       // Expanded(
                  //       //   child: Column(
                  //       //     crossAxisAlignment: CrossAxisAlignment.start,
                  //       //     children: [
                  //       //       Text(
                  //       //         LN.expiryDate,
                  //       //         style: TextStyle(
                  //       //           fontSize: size.getS(17),
                  //       //           color: Colors.black,
                  //       //         ),
                  //       //       ),
                  //       //       SizedBox(
                  //       //         height: size.getH(4),
                  //       //       ),
                  //       //       TextFormWidget(
                  //       //         isDense: true,
                  //       //         isReq: false,
                  //       //         readOnly: true,
                  //       //         vPad: 6,
                  //       //         errH: 0,
                  //       //         borderColor: Colors.black54,
                  //       //         borderRadius: 5,
                  //       //         cltr: TextEditingController(
                  //       //           text: ppVarient == null
                  //       //               ? ""
                  //       //               : ppVarient!.expiryDateCltr.text.split(' ').first,
                  //       //         ),
                  //       //         hintText: LN.chooseDate,
                  //       //         textInputType: TextInputType.text,
                  //       //         suffixIcon: Icon(Icons.calendar_month_outlined),
                  //       //         suffixIconWidth: 36,
                  //       //         hintStyle: TextStyle(fontSize: size.getS(14)),
                  //       //         onTap: () async {
                  //       //           final _dateFormat = await SharedPrefs.dateFormat;
                  //       //           Utils.datePick(context,
                  //       //                   initDate:
                  //       //                       ppVarient!.expiryDateCltr.text.isEmpty
                  //       //                           ? null
                  //       //                           : DateFormat(_dateFormat).parse(
                  //       //                               ppVarient!.expiryDateCltr.text))
                  //       //               .then((_date) {
                  //       //             if (_date == null) return;
                  //       //             ppVarient!.expiryDateCltr.text =
                  //       //                 DateFormat(_dateFormat).format(_date);
                  //       //             if (changeDefault != null) changeDefault!(null);
                  //       //             // pro.notify;
                  //       //           });
                  //       //         },
                  //       //       ),
                  //       //     ],
                  //       //   ),
                  //       // ),
                  //       SizedBox(
                  //           width: size
                  //               .getW(12 * (GlobalCVP.isRetailStore ? 2 : 3))),
                  //       Expanded(
                  //           flex: GlobalCVP.isRetailStore ? 2 : 3,
                  //           child: Container())
                  //     ],
                  //   ),
                  //   SizedBox(
                  //     height: size.getH(16),
                  //   ),
                  // ],
                  if (ppVarient?.channels.isNotEmpty ?? false)
                    Column(
                      children: [
                        Divider(color: Colors.black38),
                        // InfoMessageSec(
                        //     message:
                        //         "Variable Price mode applies exclusively to the POS channel."),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                LN.channelsPrice,
                                style: TextStyle(
                                  fontSize: size.getS(16),
                                  color: Colors.black,
                                  fontStyle: FontStyle.italic,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              width: size.getW(12),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                LN.sellingPrice,
                                style: TextStyle(
                                  fontSize: size.getS(17),
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: size.getW(12),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                LN.disPrice,
                                style: TextStyle(
                                  fontSize: size.getS(17),
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: size.getW(12),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "${LN.discount}(%)",
                                style: TextStyle(
                                  fontSize: size.getS(17),
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: size.getW(12),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                LN.newSellingPrice,
                                style: TextStyle(
                                  fontSize: size.getS(17),
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: size.getW(12),
                            ),
                            // Expanded(
                            //   flex: 2,
                            //   child: Text(
                            //     "Variable Price Mode",
                            //     style: TextStyle(
                            //       fontSize: size.getS(17),
                            //       color: Colors.black,
                            //     ),
                            //   ),
                            // ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Status",
                                style: TextStyle(
                                  fontSize: size.getS(17),
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: size.getW(2),
                            ),
                          ],
                        ),
                        ...List.generate(ppVarient!.channels.length, (index) {
                          return Column(
                            children: [
                              Divider(color: Colors.black38),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      ppVarient?.channels[index].channelName ??
                                          '',
                                      style: TextStyle(
                                        fontSize: size.getS(17),
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(
                                    width: size.getW(12),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: TextFormWidget(
                                        isDense: true,
                                        isReq: true,
                                        errH: 0,
                                        borderColor: Colors.black54,
                                        borderRadius: 5,
                                        cltr: ppVarient == null
                                            ? TextEditingController()
                                            : ppVarient!.channels[index]
                                                .sellingPriceCltr,
                                        hintText: LN.sellingPrice,
                                        textInputType: TextInputType.number,
                                        hintStyle:
                                            TextStyle(fontSize: size.getS(14)),
                                        onChanged: (_) => onChangePrice(
                                            priceType: _PriceType.Price,
                                            i: index),
                                        validator: (val) {
                                          if (val!.isEmpty)
                                            return "";
                                          else if (val.isNotEmpty) {
                                            if (!ppVarient!.channels[index]
                                                .isActive) return null;
                                          }
                                          return null;
                                        }),
                                  ),
                                  SizedBox(
                                    width: size.getW(12),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: TextFormWidget(
                                      isDense: true,
                                      isReq: false,
                                      errH: 0,
                                      borderColor: Colors.black54,
                                      borderRadius: 5,
                                      cltr: ppVarient == null
                                          ? TextEditingController()
                                          : ppVarient!
                                              .channels[index].disPriceCltr,
                                      hintText: LN.disPrice,
                                      textInputType: TextInputType.number,
                                      hintStyle:
                                          TextStyle(fontSize: size.getS(14)),
                                      onChanged: (_) => onChangePrice(
                                          priceType: _PriceType.DisPrice,
                                          i: index),
                                    ),
                                  ),
                                  SizedBox(
                                    width: size.getW(12),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: TextFormWidget(
                                      isDense: true,
                                      isReq: false,
                                      errH: 0,
                                      borderColor: Colors.black54,
                                      borderRadius: 5,
                                      cltr: ppVarient == null
                                          ? TextEditingController()
                                          : ppVarient!
                                              .channels[index].disPercentCltr,
                                      hintText: "${LN.discount}(%)",
                                      textInputType: TextInputType.number,
                                      hintStyle:
                                          TextStyle(fontSize: size.getS(14)),
                                      onChanged: (_) => onChangePrice(
                                          priceType: _PriceType.DisPer,
                                          i: index),
                                    ),
                                  ),
                                  SizedBox(
                                    width: size.getW(12),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: TextFormWidget(
                                      isDense: true,
                                      isReq: false,
                                      readOnly: true,
                                      errH: 0,
                                      borderColor: Colors.black54,
                                      borderRadius: 5,
                                      cltr: ppVarient == null
                                          ? TextEditingController()
                                          : ppVarient!.channels[index]
                                              .newSellingPriceCltr,
                                      hintText: LN.newSellingPrice,
                                      textInputType: TextInputType.number,
                                      hintStyle:
                                          TextStyle(fontSize: size.getS(14)),
                                    ),
                                  ),
                                  SizedBox(
                                    width: size.getW(12),
                                  ),
                                  // Expanded(
                                  //   flex: 2,
                                  //   child: Row(
                                  //     mainAxisSize: MainAxisSize.min,
                                  //     children: [
                                  //       SwitchAdap(
                                  //         height: 32,
                                  //         value: ppVarient!.channels[index]
                                  //             .variablePriceMode,
                                  //         size: size,
                                  //         onChanged: (val) {
                                  //           if (ppVarient!.channels[index]
                                  //                   .channelName ==
                                  //               "POS") {
                                  //             ppVarient!.channels[index]
                                  //                 .variablePriceMode = val;
                                  //             newProdPro.notify;
                                  //           } else {
                                  //             showToast(
                                  //                 "Variable Price Mode applies exclusively to the POS channel.");
                                  //           }
                                  //         },
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SwitchAdap(
                                          height: 32,
                                          value: ppVarient!
                                              .channels[index].isActive,
                                          size: size,
                                          onChanged: (val) {
                                            ppVarient!
                                                .channels[index].isActive = val;
                                            if (changeDefault != null)
                                              changeDefault!(null);
                                          },
                                        ),
                                        SizedBox(
                                          width: size.getW(12),
                                        ),
                                        Text(
                                          ppVarient!.channels[index].isActive
                                              ? LN.active
                                              : LN.inActive,
                                          style: TextStyle(
                                            fontSize: size.getS(16),
                                            color: ppVarient!
                                                    .channels[index].isActive
                                                ? kSecondaryColor
                                                : Colors.red.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          );
                        }),
                        // Divider(),
                        // Align(
                        //   alignment: Alignment.centerLeft,
                        //   child: ModifierListSec(
                        //     vIndex: index,
                        //     size: size,
                        //     title: isService
                        //         ? 'Extra Service Modifiers'
                        //         : LN.modifiers,
                        //     modifierList: newProdPro.ppvList[index].modifiers,
                        //     onAdd: () {
                        //       newProdPro.addModifier(index);
                        //       newProdPro.notify;
                        //       if (!newProdPro.modifierExpand &&
                        //           newProdPro.modifierExFun != null) {
                        //         newProdPro.modifierExFun!();
                        //       }
                        //     },
                        //     remove: (p0) {
                        //       newProdPro.removeModifier(
                        //         modifierLabelIndex: p0,
                        //         variantIndex: index,
                        //         builder: (ctx, animation) =>
                        //             VariationModifierSec(
                        //                 animation: animation,
                        //                 isService: isService),
                        //       );
                        //     },
                        //     isService: isService,
                        //   ),
                        // ),
                        if (!isService) ...[
                          // Divider(),
                          if (GlobalCVP.isRetailStore)
                            Align(
                              alignment: Alignment.centerLeft,
                              child: BatchListSec(
                                vIndex: index,
                                size: size,
                                title: 'Batch Stock Count',
                                batchList: newProdPro.ppvList[index].batches,
                                onAdd: () async {
                                  newProdPro.addBatches(
                                    index,
                                  );
                                  newProdPro.notify;
                                  if (!newProdPro.batchExpand &&
                                      newProdPro.batchExFun != null) {
                                    newProdPro.batchExFun!();
                                  }
                                },
                                remove: (p0) {
                                  newProdPro.removeBatches(
                                    batchIndex: p0,
                                    variantIndex: index,
                                    builder: (ctx, animation) =>
                                        VariantBatchSection(
                                            animation: animation),
                                  );
                                },
                              ),
                            ),
                          // Divider(),
                          if (GlobalCVP.isRetailStore)
                            Align(
                              alignment: Alignment.centerLeft,
                              child: SupplierListSec(
                                vIndex: index,
                                size: size,
                                title: 'Suppliers',
                                supplierList:
                                    newProdPro.ppvList[index].suppliers,
                                onAdd: () {
                                  newProdPro.addSupplier(index);
                                  newProdPro.notify;
                                  if (!newProdPro.supplierExpand &&
                                      newProdPro.supExFun != null) {
                                    newProdPro.supExFun!();
                                  }
                                },
                                remove: (p0) {
                                  newProdPro.removeSupplier(
                                    supIndex: p0,
                                    variantIndex: index,
                                    builder: (ctx, animation) =>
                                        VariantSupSec(animation: animation),
                                  );
                                },
                              ),
                            ),
                          if (GlobalCVP.isHospitality) ...[
                            SizedBox(height: size.getH(12)),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: SpicesSection(
                                  vIndex: index,
                                  onTap: (p0) {
                                    if (newProdPro.ppvList.isNotEmpty)
                                      newProdPro.ppvList[index].spices[p0]
                                          .isSelected = !(newProdPro
                                              .ppvList[index]
                                              .spices[p0]
                                              .isSelected ??
                                          false);
                                    newProdPro.notify;
                                  },
                                  size: size,
                                  title: 'Spice Choice',
                                  spicesList: newProdPro.ppvList[index].spices),
                            ),
                            Divider(),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: RawIngreListSec(
                                vIndex: index,
                                size: size,
                                title: 'Raw Ingredients',
                                ingreList: newProdPro.ppvList[index].rawIngre,
                                onAdd: () {
                                  newProdPro.addRawIngre(index);
                                  newProdPro.notify;
                                  if (!newProdPro.ingreExpand &&
                                      newProdPro.ingreExFun != null) {
                                    newProdPro.ingreExFun!();
                                  }
                                },
                                remove: (p0) {
                                  newProdPro.removeRawIngre(
                                    ingreIndex: p0,
                                    variantIndex: index,
                                    builder: (ctx, animation) =>
                                        RawIngreSec(animation: animation),
                                  );
                                },
                              ),
                            ),
                            if (_modiGroup?.isNotEmpty ?? false)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Divider(),
                                  InfoRowSec(
                                    title: "Modifiers",
                                    subTitle:
                                        ' (List all modifiers that can be applied to this product.)',
                                    iconData: Icons.tag_rounded,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                      right: size.getW(2),
                                    ),
                                    decoration: BoxDecoration(
                                      color: kBackgroundColor,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.black12),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: size.getH(24),
                                        horizontal: size.getW(24)),
                                    child: LoadButton(
                                      width: double.infinity,
                                      hPad: 4,
                                      icon: Icon(
                                        Icons.add,
                                        color: Colors.black,
                                        size: size.getS(20),
                                      ),
                                      btnText: " Update Modifier",
                                      btnColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: kSecondaryColor
                                                .withOpacity(0.3)),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      textColor: Colors.black,
                                      onsave: () {
                                        ModifierDialog.show(
                                          context,
                                          varIndex: index,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ] else ...[
                          // Divider(),
                          // Align(
                          //   alignment: Alignment.centerLeft,
                          //   child: ServiceTypeListSec(
                          //     vIndex: index,
                          //     size: size,
                          //     title: 'Other Types',
                          //     serviceTypeList:
                          //         newProdPro.ppvList[index].serviceType,
                          //     onAdd: () {
                          //       newProdPro.addServiceType(index);
                          //       newProdPro.notify;
                          //       // if (!newProdPro.serviceTypeExpand &&
                          //       //     newProdPro.serviceTypeExFun != null) {
                          //       //   newProdPro.serviceTypeExFun!();
                          //       // }
                          //     },
                          //     remove: (p0) {
                          //       newProdPro.removeServiceType(
                          //         serviceIndex: p0,
                          //         variantIndex: index,
                          //         builder: (ctx, animation) =>
                          //             ServiceTypeSec(animation: animation),
                          //       );
                          //     },
                          //   ),
                          // )
                        ],
                        SizedBox(height: 16),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
