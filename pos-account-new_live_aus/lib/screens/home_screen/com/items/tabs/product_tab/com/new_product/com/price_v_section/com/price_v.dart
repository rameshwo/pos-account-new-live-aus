import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/product/new_product_pro.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/switch_adap.dart';

enum _PriceType { Price, DisPrice, DisPer }

class PriceVariention extends StatelessWidget {
  final Ssize size;
  final int index;
  final String? tabName;
  final NewProductPro pro;
  const PriceVariention({
    super.key,
    required this.size,
    required this.index,
    this.tabName,
    required this.pro,
  });

  void _clearPrice(int i) {
    final pvpvmList = pro.priceData![index].productVariationsPriceViewModel!;
    pvpvmList[i].disPercentCltr?.clear();
    pvpvmList[i].disPriceCltr?.clear();
    pvpvmList[i].newPriceCltr?.clear();
    pvpvmList[i].discountPercentage = "";
    pvpvmList[i].discountPrice = "";
    pvpvmList[i].discountedPrice = "";
  }

  void onChangePrice({required _PriceType priceType, required int i}) {
    final pvpvmList = pro.priceData?[index].productVariationsPriceViewModel;
    if (pvpvmList == null) return;

    final _price = pvpvmList[i].priceCltr?.text.inDouble ?? 0;

    if ((pvpvmList[i].priceCltr?.text.isNotEmpty ?? false) && _price == 0)
      return;

    final disPer = pvpvmList[i].disPercentCltr?.text.inDouble ?? 0;

    final disPer0 = disPer == 0 || disPer.isInfinite || disPer.isNaN;

    final disPrice = pvpvmList[i].disPriceCltr?.text.inDouble ?? 0;

    final disPrice0 = disPrice == 0 || disPrice.isInfinite || disPrice.isNaN;

    if (priceType == _PriceType.Price) {
      if ((pvpvmList[i].disPercentCltr?.text.isNotEmpty ?? false) && disPer0) {
        _clearPrice(i);

        return;
      }

      if (disPer0) {
        _clearPrice(i);
      } else {
        final _disPrice = _price * disPer / 100;

        pvpvmList[i].disPriceCltr?.text = _disPrice.roundToNString();
        pvpvmList[i].discountPrice = _disPrice.roundToNString();

        pvpvmList[i].newPriceCltr?.text =
            _disPrice == 0 ? "" : (_price - _disPrice).roundToNString();
        pvpvmList[i].discountedPrice = (_price - _disPrice).roundToNString();
      }
    } else if (priceType == _PriceType.DisPrice) {
      if ((pvpvmList[i].disPriceCltr?.text.isNotEmpty ?? false) && disPrice0)
        return;

      if (disPrice0) {
        _clearPrice(i);
      } else {
        final _disPerValue = (disPrice / _price) * 100;

        pvpvmList[i].disPercentCltr?.text = _disPerValue.roundToNString();
        pvpvmList[i].discountPercentage = _disPerValue.roundToNString();

        pvpvmList[i].newPriceCltr?.text =
            disPrice == 0 ? "" : (_price - disPrice).roundToNString();
        pvpvmList[i].discountedPrice = (_price - disPrice).roundToNString();
      }
    } else if (priceType == _PriceType.DisPer) {
      if ((pvpvmList[i].disPercentCltr?.text.isNotEmpty ?? false) && disPer0)
        return;
      if (disPer0) {
        _clearPrice(i);
      } else {
        final disPriceValue = _price * disPer / 100;

        pvpvmList[i].disPriceCltr?.text = disPriceValue.roundToNString();
        pvpvmList[i].discountPrice = disPriceValue.roundToNString();

        pvpvmList[i].newPriceCltr?.text =
            disPriceValue == 0 ? "" : (_price - disPriceValue).roundToNString();
        pvpvmList[i].discountedPrice =
            (_price - disPriceValue).roundToNString();
      }
    }

    pro.notify;
    isInvalid(i);
  }

  bool isInvalid(int i) {
    final pvpvmList = pro.priceData?[index].productVariationsPriceViewModel;

    if (pvpvmList == null) return false;
    final newPrice = pvpvmList[i].newPriceCltr?.text.inDouble ?? 0;

    if (newPrice < 0) {
      showToast(LN.disAmtHigher);
      return true;
    } else
      return false;
  }

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: size.getS(18),
      fontFamily: kFontFRegular,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
    final pvpvmList = pro.priceData?[index].productVariationsPriceViewModel;
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          VarientSec(
            size: size,
            widgetList: [
              Text(
                LN.variations,
                style: style,
                textAlign: TextAlign.center,
              ),
              Text(
                LN.sellingPrice,
                style: style,
                textAlign: TextAlign.center,
              ),
              Text(
                LN.disPrice,
                style: style,
                textAlign: TextAlign.center,
              ),
              Text(
                "${LN.discount} (%)",
                style: style,
                textAlign: TextAlign.center,
              ),
              Text(
                LN.newSellingPrice,
                style: style,
                textAlign: TextAlign.center,
              ),
              // Text(
              //   "Variable Price Mode",
              //   style: style,
              //   textAlign: TextAlign.center,
              // ),
              Text(
                LN.status,
                style: style,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Divider(
            color: Colors.black26,
            thickness: 0.6,
          ),
          if (pvpvmList != null)
            ...List.generate(pvpvmList.length, (i) {
              return Padding(
                padding: EdgeInsets.only(top: size.getH(12)),
                child: VarientSec(
                  size: size,
                  widgetList: [
                    Text(
                      pvpvmList[i].name ?? '',
                      style: style,
                    ),
                    _textFieldSection(
                      textCltr: pvpvmList[i].priceCltr ??
                          TextEditingController(text: pvpvmList[i].price),
                      onChanged: (p0) {
                        pvpvmList[i].price = p0;
                        onChangePrice(priceType: _PriceType.Price, i: i);
                      },
                      onClear: () {
                        pvpvmList[i].priceCltr?.clear();
                        pvpvmList[i].price = "";
                        onChangePrice(priceType: _PriceType.Price, i: i);
                        pro.notify;
                      },
                      hintText: LN.sellingPrice,
                    ),
                    _textFieldSection(
                      textCltr: pvpvmList[i].disPriceCltr ??
                          TextEditingController(
                              text: pvpvmList[i].discountPrice),
                      onChanged: (p0) {
                        pvpvmList[i].discountPrice = p0;
                        onChangePrice(priceType: _PriceType.DisPrice, i: i);
                      },
                      onClear: () {
                        pvpvmList[i].disPriceCltr?.clear();
                        pvpvmList[i].discountPrice = "";
                        onChangePrice(priceType: _PriceType.DisPrice, i: i);
                        pro.notify;
                      },
                      hintText: LN.disPrice,
                    ),
                    _textFieldSection(
                      textCltr: pvpvmList[i].disPercentCltr ??
                          TextEditingController(
                              text: pvpvmList[i].discountPercentage),
                      onChanged: (p0) {
                        pvpvmList[i].discountPercentage = p0;
                        onChangePrice(priceType: _PriceType.DisPer, i: i);
                      },
                      onClear: () {
                        pvpvmList[i].disPercentCltr?.clear();
                        pvpvmList[i].discountPercentage = "";
                        onChangePrice(priceType: _PriceType.DisPer, i: i);
                        pro.notify;
                      },
                      hintText: "${LN.discount}(%)",
                    ),
                    _textFieldSection(
                      readOnly: true,
                      textCltr: pvpvmList[i].newPriceCltr ??
                          TextEditingController(
                              text: pvpvmList[i].discountedPrice),
                      hintText: LN.newSellingPrice,
                    ),
                    // SwitchAdap(
                    //   size: size,
                    //   value: pvpvmList[i].variablePriceMode ?? false,
                    //   onChanged: (p0) {
                    //     if (tabName == "POS") {
                    //       pvpvmList[i].variablePriceMode = p0;
                    //       pro.notify;
                    //     } else {
                    //       showToast(
                    //           "Variable Price mode applies exclusively to the POS channel.");
                    //     }
                    //   },
                    // ),
                    SwitchAdap(
                      size: size,
                      value: pvpvmList[i].isActive ?? false,
                      onChanged: (p0) {
                        pvpvmList[i].isActive = p0;
                        pro.notify;
                      },
                    )
                  ],
                ),
              );
            }),
          SizedBox(
            height: size.getH(32),
          ),
          Row(
            children: [
              LoadButton(
                btnText: LN.save,
                loading: pro.updatePriceLoad,
                btnColor: kSecondaryColor,
                onsave: () {
                  pro.updateProductPrice().then((value) {
                    if (value ?? false) {
                      // Navigator.pop(context);
                    }
                  });
                },
              ),
              SizedBox(
                width: size.getW(12),
              ),
              LoadButton(
                btnText: LN.cancel,
                btnColor: Colors.red.shade700,
                onsave: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
          SizedBox(
            height: size.getH(48),
          ),
        ],
      ),
    );
  }

  Widget _textFieldSection({
    required TextEditingController textCltr,
    Function(String?)? onChanged,
    Function()? onClear,
    bool readOnly = false,
    String hintText = "",
  }) {
    return Padding(
      padding: EdgeInsets.only(left: 16),
      child: TextFormWidget(
        readOnly: readOnly,
        cltr: textCltr,
        hintText: hintText,
        borderColor: Colors.black26,
        fillColor: readOnly ? Colors.grey.shade50 : Colors.white,
        textInputType: TextInputType.number,
        onChanged: onChanged,
        suffixIcon: textCltr.text.isNotEmpty && onClear != null
            ? InkWell(
                onTap: onClear, child: Icon(Icons.close, size: size.getW(28)))
            : null,
        suffixIconWidth: 40,
      ),
    );
  }
}

class VarientSec extends StatelessWidget {
  const VarientSec({
    super.key,
    required this.size,
    required this.widgetList,
  });

  final Ssize size;
  final List<Widget> widgetList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.getW(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...List.generate(
              widgetList.length,
              (index) => IntrinsicWidth(
                    child: SizedBox(
                      width: index == 0
                          ? size.getW(210)
                          : index == widgetList.length - 1
                              ? size.getW(150)
                              : size.getW(200),
                      child: Align(
                          alignment: index == 0
                              ? Alignment.centerLeft
                              : Alignment.center,
                          child: widgetList[index]),
                    ),
                  )),
        ],
      ),
    );
  }
}
