import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/providers/menu/place_order_pro.dart';
import 'package:pos_account/widgets/input/dropdown/tree_dropdown/tree_dropdown.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../constant/constant.dart';
import '../../../../../../../../ln.dart';
import '../../../../../../../../providers/cus_val_pro.dart';
import '../../../../../../../../providers/product/new_product_pro.dart';
import '../../../../../../../../widgets/input/dropdown/title_drop_down.dart';
import '../../../../../../../../widgets/input/text_form/title_text_form.dart';
import '../../../../../../../../widgets/load_btn.dart';
import '../../../../../../../../widgets/switch_adap.dart';

class RawIngreAddSection extends StatefulWidget {
  final Function()? onBack;
  const RawIngreAddSection({
    super.key,
    this.onBack,
  });

  @override
  State<RawIngreAddSection> createState() => _RawIngreAddSectionState();
}

class _RawIngreAddSectionState extends State<RawIngreAddSection> {
  late NewProductPro? _newProdPro;
  final ScrollController _scrollCltr = ScrollController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _newProdPro = Provider.of<NewProductPro>(context, listen: false);
    _newProdPro!.loading = true;
    _newProdPro!.getRawIngreAddSection();
  }

  @override
  void dispose() {
    super.dispose();
    _newProdPro!.clearIngreSec();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final newProdPro = Provider.of<NewProductPro>(context);
    final placePro = Provider.of<PlaceOrderPro>(context);
    return Processing(
      loading: newProdPro.loading,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: size.width,
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.01,
                    vertical: size.height * 0.02),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Scrollbar(
                  controller: _scrollCltr,
                  // isAlwaysShown: true,
                  // showTrackOnHover: true,
                  interactive: true,
                  thickness: 8,
                  radius: Radius.circular(40),
                  child: SingleChildScrollView(
                    controller: _scrollCltr,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Wrap(
                          spacing: size.getW(24),
                          runSpacing: size.getH(24),
                          alignment: WrapAlignment.start,
                          crossAxisAlignment: WrapCrossAlignment.start,
                          children: [
                            TitleTextForm(
                              title: LN.code,
                              pWidth: 0.22,
                              isReq: true,
                              readOnly: true,
                              fillColor: Colors.grey.shade200,
                              borderColor: Colors.black26,
                              textInputType: TextInputType.number,
                              textCltr: TextEditingController(
                                text: newProdPro.ingCodeCltr.text.isNotEmpty &&
                                        newProdPro.ingCodeCltr.text
                                            .contains('-')
                                    ? newProdPro.ingCodeCltr.text.substring(
                                        newProdPro.ingCodeCltr.text
                                                .indexOf('-') +
                                            1)
                                    : newProdPro.ingCodeCltr.text,
                              ),
                            ),
                            TitleTextForm(
                              title: LN.name,
                              pWidth: 0.22,
                              isReq: true,
                              textInputType: TextInputType.text,
                              textCltr: newProdPro.ingNameCltr,
                              borderColor: Colors.black26,
                            ),
                            //unitprice
                            TitleTextForm(
                              title: "${LN.unitPrice}(${placePro.curSym})",
                              pWidth: 0.22,
                              isReq: false,
                              textInputType: TextInputType.number,
                              textCltr: newProdPro.ingUnitPriceCltr,
                              borderColor: Colors.black26,
                            ),
                            //sellingunit
                            TitleTextForm(
                              title:
                                  "Selling Price Per Unit (${placePro.curSym})",
                              pWidth: 0.22,
                              isReq: true,
                              textInputType: TextInputType.number,
                              textCltr: newProdPro.ingSellPriceUnitCltr,
                              borderColor: Colors.black26,
                            ),
                            //purchase tax
                            TitleDropDown(
                              list:
                                  (newProdPro.rawIngreAddSectionList == null ||
                                          newProdPro.rawIngreAddSectionList!
                                                  .purchaseTaxes ==
                                              null)
                                      ? []
                                      : newProdPro.rawIngreAddSectionList!
                                          .purchaseTaxes!
                                          .map((e) => e.value ?? '')
                                          .toList(),
                              title: LN.purchaseTax,
                              indexVal:
                                  newProdPro.selectedIngPucharseTaxIndex ?? 0,
                              onChanged: (int? i) {
                                newProdPro.selectedIngPucharseTaxIndex = i;
                                newProdPro.notify;
                              },
                              pWidth: 0.22,
                              isReq: true,
                              borderColor: Colors.black26,
                            ),
                            //sales tax
                            TitleDropDown(
                              list:
                                  (newProdPro.rawIngreAddSectionList == null ||
                                          newProdPro.rawIngreAddSectionList!
                                                  .salesTaxes ==
                                              null)
                                      ? []
                                      : newProdPro
                                          .rawIngreAddSectionList!.salesTaxes!
                                          .map((e) => e.value ?? '')
                                          .toList(),
                              indexVal:
                                  newProdPro.selectedIngSalesTaxIndex ?? 0,
                              onChanged: (int? i) {
                                newProdPro.selectedIngSalesTaxIndex = i;
                                newProdPro.notify;
                              },
                              title: LN.salesTax,
                              pWidth: 0.22,
                              isReq: true,
                              borderColor: Colors.black26,
                            ),
                            //category

                            TreeDropWidget(
                              isReq: true,
                              vPad: 8.5,
                              width: size.width * 0.22,
                              dialogWidth: size.width / 2,
                              mode: Mode.DIALOG,
                              selectedColor: kSecondaryColor,
                              title: LN.category,
                              dropdownTitle: LN.category,
                              borderColor: Colors.black26,
                              hintText: LN.chooseCategory,
                              categoryList: newProdPro.rawCategoryList,
                              selectedId: newProdPro.selectedRawCatId,
                              onChanged: (p0) {
                                newProdPro.selectedRawCatId = p0;
                                newProdPro.notify;
                              },
                            ),
                            //wastage
                            TitleTextForm(
                              title: 'Wastage Percentage',
                              pWidth: 0.22,
                              isReq: true,
                              textInputType: TextInputType.number,
                              textCltr: newProdPro.ingWastagePercentCltr,
                              borderColor: Colors.black26,
                            ),
                            //unit
                            TitleDropDown(
                              list:
                                  (newProdPro.rawIngreAddSectionList == null ||
                                          newProdPro.rawIngreAddSectionList!
                                                  .unitOfMeasurements ==
                                              null)
                                      ? []
                                      : newProdPro.rawIngreAddSectionList!
                                          .unitOfMeasurements!
                                          .map((e) => e.value ?? '')
                                          .toList(),
                              indexVal: newProdPro.selectedIngUnitIndex ?? 0,
                              onChanged: (int? i) {
                                newProdPro.selectedIngUnitIndex = i;
                                newProdPro.notify;
                              },
                              title: "Unit of Measurement",
                              pWidth: 0.22,
                              isReq: true,
                              borderColor: Colors.black26,
                            ),

                            Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  LN.isActive,
                                  style: TextStyle(
                                    fontSize: size.getS(16),
                                    color: Colors.black,
                                  ),
                                ),
                                SwitchAdap(
                                  value: newProdPro.isIngActive,
                                  size: size,
                                  onChanged: (val) {
                                    newProdPro.isIngActive = val;
                                    newProdPro.notify;
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: size.getH(24),
                        ),
                        Row(
                          children: [
                            if (GlobalCVP.viewWidget.viewAddProductButton)
                              LoadButton(
                                hPad: 2,
                                onsave: newProdPro.loading
                                    ? null
                                    : () {
                                        if (_formKey.currentState!.validate()) {
                                          newProdPro
                                              .addUpdateRawIngreAddSection();
                                        } else {
                                          FocusScope.of(context).unfocus();
                                          showToast(LN.invalidInput);
                                        }
                                      },
                                loading: newProdPro.loading,
                                btnText: newProdPro.editRawIngreData == null
                                    ? "${LN.add} ${LN.rawIngre}"
                                    : "${LN.update} ${LN.rawIngre}",
                                width: 230,
                              ),
                            SizedBox(
                              width: size.getW(12),
                            ),
                            if (newProdPro.editRawIngreData != null)
                              LoadButton(
                                width: 120,
                                hPad: 2,
                                btnColor: Colors.red.shade700,
                                onsave: () {
                                  newProdPro.clearIngreSec();
                                  newProdPro.setRawData();
                                  newProdPro.notify;
                                },
                                loading: newProdPro.loading,
                                btnText: LN.cancel,
                              ),
                          ],
                        ),
                        SizedBox(
                          height: size.getH(24),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
