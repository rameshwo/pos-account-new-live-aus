import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/product/combo_pack_pro.dart';
import 'package:pos_account/repository/if_exception.dart';
import 'package:pos_account/widgets/description_view.dart';
import 'package:pos_account/widgets/image/p_image_sec.dart';
import 'package:pos_account/widgets/input/dropdown/title_drop_down.dart';
import 'package:pos_account/widgets/input/dropdown/tree_dropdown/tree_dropdown.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:pos_account/widgets/switch_adap.dart';
import '../../../../../../../../../../widgets/title_pop.dart';

enum _PriceType { Price, DisPrice, DisPer }

class GeneralInfoSec extends StatelessWidget {
  final ComboPackPro comboPro;
  const GeneralInfoSec({super.key, required this.comboPro});

  void onChangePrice({required _PriceType priceType, required int i}) {
    final _price = comboPro.channelPriceList[i].sellingPriceCltr.text.inDouble;
    if (comboPro.channelPriceList[i].sellingPriceCltr.text.isNotEmpty &&
        _price == 0) return;

    final _disPer = comboPro.channelPriceList[i].disPercentCltr.text.inDouble;

    final _disPer0 = _disPer == 0 || _disPer.isInfinite || _disPer.isNaN;

    final _disPrice = comboPro.channelPriceList[i].disPriceCltr.text.inDouble;

    final _disPrice0 =
        _disPrice == 0 || _disPrice.isInfinite || _disPrice.isNaN;

    if (priceType == _PriceType.Price) {
      if ((comboPro.channelPriceList[i].disPercentCltr.text.isNotEmpty) &&
          _disPer0) {
        _clearPrice(i);
        return;
      }

      if (_disPer0) {
        _clearPrice(i);
      } else {
        final _disPriceValue = _price * _disPer / 100;

        comboPro.channelPriceList[i].disPriceCltr.text =
            _disPriceValue.roundToNString();

        comboPro.channelPriceList[i].newSellingPriceCltr.text =
            _disPriceValue == 0
                ? ""
                : (_price - _disPriceValue).roundToNString();
      }
    } else if (priceType == _PriceType.DisPrice) {
      if ((comboPro.channelPriceList[i].disPriceCltr.text.isNotEmpty) &&
          _disPrice0) return;

      if (_disPrice0) {
        _clearPrice(i);
      } else {
        final _disPerValue = (_disPrice / _price) * 100;

        comboPro.channelPriceList[i].disPercentCltr.text =
            _disPerValue.roundToNString();

        comboPro.channelPriceList[i].newSellingPriceCltr.text =
            _disPrice == 0 ? "" : (_price - _disPrice).roundToNString();
      }
    } else if (priceType == _PriceType.DisPer) {
      if ((comboPro.channelPriceList[i].disPercentCltr.text.isNotEmpty) &&
          _disPer0) return;

      if (_disPer0) {
        _clearPrice(i);
      } else {
        final _disPriceValue = _price * _disPer / 100;

        comboPro.channelPriceList[i].disPriceCltr.text =
            _disPriceValue.roundToNString();

        comboPro.channelPriceList[i].newSellingPriceCltr.text =
            _disPriceValue == 0
                ? ""
                : (_price - _disPriceValue).roundToNString();
      }
    }

    comboPro.notify;
    isInvalid(i);
  }

  void _clearPrice(int i) {
    final pvpvmList = comboPro.channelPriceList;
    pvpvmList[i].disPercentCltr.clear();
    pvpvmList[i].disPriceCltr.clear();
    pvpvmList[i].newSellingPriceCltr.clear();
  }

  bool isInvalid(int i) {
    final _newPrice =
        comboPro.channelPriceList[i].newSellingPriceCltr.text.inDouble;

    if (_newPrice < 0) {
      IfException.showMessage(message: LN.disAmtHigher);

      return true;
    } else
      return false;
  }

  bool get _isMakeYourOwn =>
      comboPro.productPriceTypeIndex != null &&
      (comboPro.comboAddSec?.productPriceTypes?.isNotEmpty ?? false) &&
      comboPro.comboAddSec!.productPriceTypes!.length >
          comboPro.productPriceTypeIndex! &&
      (comboPro.comboAddSec?.productPriceTypes?[comboPro.productPriceTypeIndex!]
              .additionalValue
              ?.toString()
              .toLowerCase()
              .contains('makeyourown') ??
          false);

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: size.getH(12)),
          TitlePop.infoSection(size,
              title: "General Information",
              subTitle:
                  "Fill in the basic details about your combo pack including name, price, and description. Add an image to make your combo pack more appealing to customers."),
          SizedBox(height: size.getH(12)),
          Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: size.getW(24), vertical: size.getH(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Basic Information",
                    style: TextStyle(
                      fontSize: size.getS(20),
                      // fontFamily: kFontFMedium,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Divider(),
                  Row(
                    children: [
                      Flexible(
                        child: Wrap(
                          spacing: size.getW(24),
                          runSpacing: size.getH(24),
                          children: [
                            TitleTextForm(
                              title: "Combo Code",
                              pWidth: 0.20,
                              isReq: false,
                              readOnly: true,
                              fillColor: Colors.grey.shade200,
                              borderColor: Colors.black26,
                              textInputType: TextInputType.number,
                              textCltr: TextEditingController(
                                text: comboPro.codeCltr.text.isNotEmpty &&
                                        comboPro.codeCltr.text.contains('-')
                                    ? comboPro.codeCltr.text.substring(
                                        comboPro.codeCltr.text.indexOf('-') + 1)
                                    : comboPro.codeCltr.text,
                              ),
                            ),
                            TitleTextForm(
                              title: LN.name,
                              pWidth: 0.20,
                              borderColor: Colors.black26,
                              textCltr: comboPro.nameCltr,
                            ),
                            TreeDropWidget(
                              isReq: true,
                              vPad: 8.5,
                              width: size.width * 0.20,
                              dialogWidth: size.width / 2,
                              mode: Mode.DIALOG,
                              selectedColor: kSecondaryColor,
                              title: LN.category,
                              dropdownTitle: LN.category,
                              borderColor: Colors.black26,
                              hintText: LN.chooseCategory,
                              categoryList: comboPro.categoryList,
                              selectedId: comboPro.selectedCatId,
                              onChanged: (p0) {
                                comboPro.selectedCatId = p0;
                                comboPro.notify;
                              },
                            ),
                            TitleDropDown(
                              title: LN.salesTax,
                              hintText: LN.chooseTaxType,
                              isReq: true,
                              pWidth: 0.20,
                              borderColor: Colors.black26,
                              indexVal: comboPro.salesTaxIndex,
                              list: (comboPro.comboAddSec?.salesTaxes == null)
                                  ? []
                                  : comboPro.comboAddSec!.salesTaxes!
                                      .map((e) => e.value ?? '')
                                      .toList(),
                              onChanged: (int? i) {
                                comboPro.salesTaxIndex = i;
                                comboPro.notify;
                              },
                            ),
                            TitleTextForm(
                              title: LN.barcode,
                              pWidth: 0.20,
                              isReq: false,
                              borderColor: Colors.black26,
                              textCltr: comboPro.barcodeCltr,
                            ),
                            TitleTextForm(
                              title: LN.slug,
                              pWidth: 0.20,
                              isReq: false,
                              borderColor: Colors.black26,
                              textCltr: comboPro.slugCltr,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: size.getW(48),
                      ),
                      SizedBox(
                        width: size.width * 0.20, //size.getW(328),
                        height: size.getH(170),
                        child: PImageSection(
                          hintText: LN.addProductImage,
                          imagePath: comboPro.filePath,
                          onTap: () {
                            comboPro.getFilePick();
                          },
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: size.getH(16),
                  ),
                  Wrap(
                    spacing: size.getW(24),
                    runSpacing: size.getH(24),
                    children: [
                      // TitleDropDown(
                      //   title: "Product Price Type",
                      //   hintText: "Choose product price type",
                      //   isReq: false,
                      //   pWidth: 0.20,
                      //   borderColor: Colors.black26,
                      //   indexVal: comboPro.productPriceTypeIndex,
                      //   list: (comboPro.comboAddSec?.productPriceTypes == null)
                      //       ? []
                      //       : comboPro.comboAddSec!.productPriceTypes!
                      //           .map((e) => e.name ?? '')
                      //           .toList(),
                      //   onChanged: (int? i) {
                      //     comboPro.productPriceTypeIndex = i;
                      //     comboPro.notify;
                      //   },
                      // ),
                      TitleTextForm(
                        title: "Link",
                        pWidth: 0.20,
                        isReq: false,
                        borderColor: Colors.black26,
                        textCltr: comboPro.linkCltr,
                      ),
                      TitleTextForm(
                        title: LN.calories,
                        pWidth: 0.20,
                        isReq: false,
                        borderColor: Colors.black26,
                        textCltr: comboPro.caloryCltr,
                      ),
                      SizedBox(
                        width: size.width * 0.20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Auto Cart Detection",
                              style: TextStyle(
                                fontSize: size.getS(16),
                                fontFamily: kFontFMedium,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: size.getH(12),
                            ),
                            SwitchAdap(
                              value: comboPro.enableAutoCartDetection,
                              size: size,
                              onChanged: (val) {
                                comboPro.enableAutoCartDetection = val;
                                comboPro.notify;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              LN.status,
                              style: TextStyle(
                                fontSize: size.getS(16),
                                fontFamily: kFontFMedium,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: size.getH(12),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SwitchAdap(
                                  value: comboPro.status,
                                  size: size,
                                  onChanged: (val) {
                                    comboPro.status = val;
                                    comboPro.notify;
                                  },
                                ),
                                SizedBox(
                                  width: size.getW(12),
                                ),
                                Text(
                                  comboPro.status ? LN.active : LN.inActive,
                                  style: TextStyle(
                                    fontSize: size.getS(16),
                                    color: comboPro.status
                                        ? kSecondaryColor
                                        : Colors.red.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.getH(16),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: size.getH(12), bottom: size.getH(12), right: 0),
                    decoration: BoxDecoration(
                        color: kBackgroundColor,
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.symmetric(
                        vertical: size.getH(8), horizontal: size.getW(24)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          LN.description,
                          style: TextStyle(
                            fontSize: size.getS(18),
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: size.getH(12),
                        ),
                        DescriptionHtmlView(
                          size: size,
                          htmlController:
                              comboPro.htmlController ?? HtmlEditorController(),
                          descriptionText: comboPro.descriptionText,
                          height: 150,
                          onSave: (val) {
                            comboPro.descriptionText = val;
                            comboPro.notify;
                          },
                        ),
                        SizedBox(
                          height: size.getH(16),
                        ),
                      ],
                    ),
                  ),
                  if (comboPro.comboAddSec?.productPriceTypes != null)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Price Type
                        Text(
                          "Select Product Price Type",
                          style: TextStyle(
                            fontSize: size.getS(18),
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: size.getH(8),
                        ),
                        Row(
                          children: [
                            ...List.generate(
                                comboPro.comboAddSec!.productPriceTypes!.length,
                                (index) {
                              //     comboPro.productPriceTypeIndex = i;
                              //     comboPro.notify;
                              return Container(
                                // width: size.getW(200),
                                height: size.getH(50),
                                margin: EdgeInsets.only(right: size.getW(12)),
                                decoration: BoxDecoration(
                                  color: comboPro.productPriceTypeIndex == index
                                      ? kSecondaryColor.withOpacity(0.03)
                                      : Colors.white,
                                  border: Border.all(
                                      color: comboPro.productPriceTypeIndex ==
                                              index
                                          ? kSecondaryColor
                                          : Colors.black26,
                                      width: 1.6),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                alignment: Alignment.center,
                                child: InkWell(
                                  onTap: () {
                                    comboPro.productPriceTypeIndex = index;

                                    for (final a in comboPro.comboGroupList) {
                                      for (final b in a.productList) {
                                        if (_isMakeYourOwn) {
                                          b.prevIsReqVal = b.isReq;
                                          b.isReq = true;
                                        } else {
                                          b.isReq = b.prevIsReqVal;
                                          b.prevIsReqVal = true;
                                        }
                                      }
                                    }

                                    comboPro.notify;
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: size.getW(60),
                                        vertical: size.getH(6)),
                                    child: Text(
                                      comboPro.comboAddSec!
                                              .productPriceTypes![index].name ??
                                          '',
                                      style: TextStyle(
                                        fontSize: size.getS(18),
                                        fontFamily: kFontFMedium,
                                        color: comboPro.productPriceTypeIndex ==
                                                index
                                            ? kSecondaryColor
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            })
                          ],
                        ),
                      ],
                    ),
                  SizedBox(
                    height: size.getH(16),
                  ),
                  if (_isMakeYourOwn)
                    Text(
                      "# The price will be based on the items selected from the combo list in Products Tab.",
                      style: TextStyle(
                        fontSize: size.getS(16),
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    )
                  else ...[
                    Text(
                      "Pricing",
                      style: TextStyle(
                        fontSize: size.getS(20),
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: size.getH(12),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      // padding: EdgeInsets.symmetric(
                      //     horizontal: size.getW(24), vertical: size.getH(16)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: size.getW(24),
                                vertical: size.getH(16)),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    LN.channelsPrice,
                                    style: TextStyle(
                                      fontSize: size.getS(18),
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
                                      fontSize: size.getS(19),
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
                                      fontSize: size.getS(19),
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
                                      fontSize: size.getS(19),
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
                                      fontSize: size.getS(19),
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
                                    "Status",
                                    style: TextStyle(
                                      fontSize: size.getS(19),
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: size.getH(16)),
                          ...List.generate(comboPro.channelPriceList.length,
                              (i) {
                            final _channel = comboPro.channelPriceList[i];
                            return Column(
                              children: [
                                if (i != 0)
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: size.getH(6)),
                                    child: Divider(),
                                  ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        _channel.channelName,
                                        style: TextStyle(
                                          fontSize: size.getS(19),
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
                                          isReq: false,
                                          errH: 0,
                                          borderColor: Colors.black54,
                                          borderRadius: 5,
                                          cltr: _channel.sellingPriceCltr,
                                          hintText: LN.sellingPrice,
                                          textInputType: TextInputType.number,
                                          // hintStyle:
                                          //     TextStyle(fontSize: size.getS(14)),
                                          onChanged: (_) => onChangePrice(
                                              priceType: _PriceType.Price,
                                              i: i),
                                          validator: (val) {
                                            if (val!.isEmpty)
                                              return "";
                                            else if (val.isNotEmpty) {
                                              if (!_channel.isActive)
                                                return null;
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
                                        cltr: _channel.disPriceCltr,
                                        hintText: LN.disPrice,
                                        textInputType: TextInputType.number,
                                        // hintStyle:
                                        //     TextStyle(fontSize: size.getS(14)),
                                        onChanged: (_) => onChangePrice(
                                            priceType: _PriceType.DisPrice,
                                            i: i),
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
                                        cltr: _channel.disPercentCltr,
                                        hintText: "${LN.discount}(%)",
                                        textInputType: TextInputType.number,
                                        // hintStyle:
                                        //     TextStyle(fontSize: size.getS(14)),
                                        onChanged: (_) => onChangePrice(
                                            priceType: _PriceType.DisPer, i: i),
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
                                        cltr: _channel.newSellingPriceCltr,
                                        hintText: LN.newSellingPrice,
                                        textInputType: TextInputType.number,
                                        // hintStyle:
                                        //     TextStyle(fontSize: size.getS(14)),
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
                                            value: _channel.isActive,
                                            size: size,
                                            onChanged: (val) {
                                              _channel.isActive = val;
                                              comboPro.notify;
                                            },
                                          ),
                                          SizedBox(
                                            width: size.getW(12),
                                          ),
                                          Text(
                                            _channel.isActive
                                                ? LN.active
                                                : LN.inActive,
                                            style: TextStyle(
                                              fontSize: size.getS(16),
                                              color: _channel.isActive
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
                          SizedBox(height: size.getH(16)),
                        ],
                      ),
                    )
                  ],
                  SizedBox(
                    height: size.getH(100),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
