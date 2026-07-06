import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/order_utils.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/menu/place_order/pos_res/pos_ingre_res.dart';
import 'package:pos_account/model/ui_model/amount_class.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/menu/place_order_pro.dart';
import 'package:pos_account/providers/menu/raw_ingre_pro.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:provider/provider.dart';

class RawIngreDia extends StatefulWidget {
  final RawLooseIngredientProduct? rawIngredient;
  final String? curSym;
  final int? upIndex;
  const RawIngreDia({
    super.key,
    this.rawIngredient,
    this.curSym,
    this.upIndex,
  });

  @override
  State<RawIngreDia> createState() => _RawIngreDiaState();
}

class _RawIngreDiaState extends State<RawIngreDia> {
  late PlaceOrderPro _placeOrder;
  late RawIngrePro _rawPro;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _placeOrder = Provider.of<PlaceOrderPro>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    _rawPro.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    _rawPro = Provider.of<RawIngrePro>(context);

    final rawIngredient = widget.rawIngredient;
    final curSym = widget.curSym;
    final unit = (rawIngredient?.maxMeasurementName?.isNotEmpty ?? false)
        ? ('/${rawIngredient?.maxMeasurementName ?? ''}')
        : '';

    final _amount = _getTotalAmount();

    return Container(
      constraints: BoxConstraints(
        maxHeight: size.height / 1.2,
        minHeight: size.height / 5,
      ),
      width: size.width / 1.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                LN.rawIngre,
                style: TextStyle(
                  fontSize: size.getS(18),
                  color: Colors.black,
                  fontFamily: kFontFMedium,
                ),
              ),
              Spacer(),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(kSecondaryColor)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(LN.ok, style: TextStyle(fontSize: size.getS(16))))
            ],
          ),
          Flexible(
              child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${LN.productName}: ${rawIngredient?.name ?? ''}",
                    style: TextStyle(
                      fontSize: size.getS(20),
                      color: Colors.black,
                      fontFamily: kFontFMedium,
                    ),
                  ),
                  Text(
                    "${LN.price}: ${curSym ?? ''}${rawIngredient?.sellingPricePerUnit ?? ''}$unit",
                    style: TextStyle(
                      fontSize: size.getS(18),
                      color: Colors.black,
                      fontFamily: kFontFMedium,
                    ),
                  ),
                  SizedBox(
                    height: size.getH(24),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: _conversionSec(
                          size,
                          title:
                              "In ${rawIngredient?.minMeasurementName ?? ""}",
                          textCltr: _rawPro.minValueCltr,
                          onChanged: (val) => _rawPro.onChange(
                            data: val,
                            maxToMinConFactor:
                                rawIngredient?.maxToMinConversionFactor,
                            isFirstText: true,
                          ),
                          optionList: _rawPro.firstOptionData,
                          onSelectOption: (i) {
                            _rawPro.minValueCltr.text =
                                _rawPro.firstOptionData[i];
                            _rawPro.onChange(
                              data: _rawPro.minValueCltr.text,
                              maxToMinConFactor:
                                  rawIngredient?.maxToMinConversionFactor,
                              isFirstText: true,
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        width: size.getW(100),
                      ),
                      Flexible(
                        child: _conversionSec(
                          size,
                          title:
                              "In ${rawIngredient?.maxMeasurementName ?? ""}",
                          textCltr: _rawPro.maxValueCltr,
                          onChanged: (val) => _rawPro.onChange(
                            data: val,
                            maxToMinConFactor:
                                rawIngredient?.maxToMinConversionFactor,
                            isFirstText: false,
                          ),
                          optionList: _rawPro.secondOptionData,
                          onSelectOption: (i) {
                            _rawPro.maxValueCltr.text =
                                _rawPro.secondOptionData[i];
                            _rawPro.onChange(
                              data: _rawPro.maxValueCltr.text,
                              maxToMinConFactor:
                                  rawIngredient?.maxToMinConversionFactor,
                              isFirstText: false,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.getH(32),
                  ),
                  // Spacer(),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Tax Amount    : ${curSym ?? ''}${_amount.totalTax.roundToNString()}",
                            style: TextStyle(
                              fontSize: size.getS(20),
                              color: Colors.black,
                              fontFamily: kFontFMedium,
                            ),
                          ),
                          Text(
                            "Total Amount : ${curSym ?? ''}${_amount.totalPrice.roundToNString()}",
                            style: TextStyle(
                              fontSize: size.getS(20),
                              color: Colors.black,
                              fontFamily: kFontFMedium,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      LoadButton(
                        btnText: LN.clear,
                        btnColor: Colors.red.shade700,
                        vPad: 8,
                        onsave: () {
                          _rawPro.clear();
                          _rawPro.notify;
                        },
                      ),
                      SizedBox(
                        width: size.getW(20),
                      ),
                      LoadButton(
                        btnText:
                            widget.upIndex != null ? "Update" : "Add to Cart",
                        vPad: 8,
                        onsave: () {
                          // if (_rawPro.maxValueCltr.text.isEmpty) return;
                          if (_formKey.currentState == null ||
                              !_formKey.currentState!.validate()) {
                            showToast("Quantity field is empty");
                            return;
                          }

                          final qty =
                              double.tryParse(_rawPro.maxValueCltr.text) ?? 0.1;

                          final totalQuantity = _placeOrder.ingreList.any(
                                  (b) => b.rawIngredientId == rawIngredient?.id)
                              ? _placeOrder.ingreList
                                  .where((b) =>
                                      b.rawIngredientId == rawIngredient?.id)
                                  .fold<double>(
                                      0, (x, y) => x + (y.quantity ?? 0.0))
                              : 0;
                          final stockCount = double.tryParse(
                                  rawIngredient?.availiableStock ?? '') ??
                              0;

                          final _outOfStock =
                              GlobalCVP.stockExceedRestriction &&
                                  !GlobalCVP.isHospitality &&
                                  stockCount < (totalQuantity + qty);
                          if (_outOfStock) {
                            showToast(LN.productOutOfStock);
                            return;
                          }

                          _placeOrder.updateRawCre(
                            rawIngredient: rawIngredient,
                            quantity: qty,
                            cartIndex: widget.upIndex,
                          );
                          _rawPro.clear();
                          _rawPro.notify;
                          showToast(
                            widget.upIndex != null
                                ? LN.updatedSuccessfully
                                : LN.addCartSuccess,
                            backgroundColor: Colors.green,
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontFamily: kFontFMedium,
                                fontSize: size.getS(16)),
                          );
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }

  AmountClass _getTotalAmount() {
    final _amount = OrderUtils.getAmount(
      taxTypeString:
          _placeOrder.initAddSec?.storeInformation?.taxExclusiveInclusiveType,
      taxPercent: widget.rawIngredient?.salesTax,
      price: widget.rawIngredient?.sellingPricePerUnit,
      quantity: double.tryParse(_rawPro.maxValueCltr.text) ?? 0,
    );
    return _amount;
  }

  Widget _conversionSec(
    Ssize size, {
    required String title,
    required final TextEditingController textCltr,
    void Function(String?)? onChanged,
    List<String>? optionList,
    Function(int)? onSelectOption,
  }) {
    return Container(
      width: double.infinity,
      color: Colors.green.withAlpha(40),
      padding: EdgeInsets.all(size.getS(24)),
      child: Column(
        children: [
          SizedBox(
            width: size.getW(300),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: size.getW(100),
                  child: TextFormWidget(
                    cltr: textCltr,
                    borderColor: kSecondaryColor,
                    hintText: '',
                    vPad: 8,
                    // isReq: false,
                    textInputType: TextInputType.number,
                    textAlign: TextAlign.right,
                    onChanged: onChanged,
                    errH: 0,
                    initValidate: true,
                  ),
                ),
                SizedBox(
                  width: size.getW(12),
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: size.getS(18),
                    color: Colors.black,
                    fontFamily: kFontFMedium,
                  ),
                ),
              ],
            ),
          ),
          if (optionList != null && onSelectOption != null) ...[
            SizedBox(
              height: size.getH(12),
            ),
            Wrap(
                spacing: size.getW(16),
                runSpacing: size.getH(4),
                children: List.generate(
                    optionList.length,
                    (index) => LoadButton(
                          vPad: 8,
                          hPad: 8,
                          width: 80,
                          btnText: optionList[index],
                          onsave: () => onSelectOption(index),
                        )))
          ]
        ],
      ),
    );
  }
}
