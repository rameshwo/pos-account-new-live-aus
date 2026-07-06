import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/product/new_product_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/product_tab/com/new_product/com/variant/pp_varient_list.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/product_tab/com/new_product/com/variant/prod_varient.dart';
import 'package:pos_account/widgets/dialog/confirm_dialog.dart';
import 'package:pos_account/widgets/image/p_image_sec.dart';
import 'package:pos_account/widgets/input/dropdown/title_drop_down.dart';
import 'package:pos_account/widgets/input/dropdown/tree_dropdown/tree_dropdown.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/switch_adap.dart';
import 'package:pos_account/widgets/title_pop.dart';
import 'package:provider/provider.dart';

import '../../../../../../../widgets/description_view.dart';

class ServiceAddUp extends StatefulWidget {
  final Function()? onBack;
  const ServiceAddUp({
    super.key,
    this.onBack,
  });

  @override
  State<ServiceAddUp> createState() => _ServiceAddUpState();
}

class _ServiceAddUpState extends State<ServiceAddUp> {
  final _formKey = GlobalKey<FormState>();
  final focusNode = FocusNode();
  final _scrollCltr = ScrollController();
  late NewProductPro? _newProdPro;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() {
    _newProdPro = Provider.of<NewProductPro>(context, listen: false);
    if (_newProdPro != null) {
      _newProdPro!.htmlController = HtmlEditorController();
      _newProdPro!.getData();
    }
  }

  void removeVarient(
      {required NewProductPro newProdPro,
      required int j,
      required Ssize size}) {
    newProdPro.removePVarient(
      j: j,
      builder: (context, animation) => ProductVarient(
        size: size,
        animation: animation,
        num: j + 1,
        isService: true,
      ),
    );
  }

  @override
  void dispose() {
    _newProdPro?.clear(init: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final newProdPro = Provider.of<NewProductPro>(context);
    return Processing(
      loading: newProdPro.loading,
      child: GestureDetector(
        onTap: () {
          for (final e in newProdPro.labelList) {
            e.htmlCltr.clearFocus();
          }
          newProdPro.htmlController?.clearFocus();

          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Form(
            key: _formKey,
            child: Card(
              child: Scrollbar(
                controller: _scrollCltr,
                thumbVisibility: true,
                trackVisibility: true,
                interactive: true,
                thickness: 8,
                radius: Radius.circular(40),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: size.getH(8.0), horizontal: size.getW(24)),
                  child: SingleChildScrollView(
                    controller: _scrollCltr,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: size.getH(8),
                        ),
                        TitlePop(
                          title: newProdPro.editData == null
                              ? "Add New Service"
                              : "Update Service",
                          size: size,
                          onTap: () {
                            if (widget.onBack != null) widget.onBack!();
                          },
                        ),
                        SizedBox(
                          height: size.getH(16),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                                child: Wrap(
                              spacing: size.getW(24),
                              runSpacing: size.getH(24),
                              children: [
                                TitleTextForm(
                                  title: "Service Name",
                                  pWidth: 0.22,
                                  borderColor: Colors.black26,
                                  textCltr: newProdPro.nameCltr,
                                  hintText: "Service Name",
                                ),
                                TreeDropWidget(
                                  isReq: true,
                                  width: size.width * 0.22,
                                  dialogWidth: size.width / 2,
                                  mode: Mode.DIALOG,
                                  selectedColor: kSecondaryColor,
                                  title: LN.category,
                                  borderColor: Colors.black26,
                                  hintText: LN.chooseCategory,
                                  categoryList: newProdPro.categoryList,
                                  selectedId: newProdPro.selectedCatId,
                                  onChanged: (p0) {
                                    newProdPro.selectedCatId = p0;
                                    newProdPro.notify;
                                  },
                                ),
                                TitleDropDown(
                                  title: LN.salesTax,
                                  hintText: LN.chooseTaxType,
                                  isReq: true,
                                  pWidth: 0.22,
                                  borderColor: Colors.black26,
                                  indexVal: newProdPro.salesTaxIndex,
                                  list: (newProdPro.addSecRes == null ||
                                          newProdPro.addSecRes!.salesTaxes ==
                                              null)
                                      ? []
                                      : newProdPro.addSecRes!.salesTaxes!
                                          .map((e) => e.value ?? '')
                                          .toList(),
                                  onChanged: (int? i) {
                                    newProdPro.salesTaxIndex = i;
                                    newProdPro.notify;
                                  },
                                ),
                                TitleTextForm(
                                  title: "Service Code",
                                  pWidth: 0.22,
                                  isReq: false,
                                  readOnly: true,
                                  fillColor: Colors.grey.shade200,
                                  borderColor: Colors.grey.shade400,
                                  textInputType: TextInputType.number,
                                  textCltr: TextEditingController(
                                    text: newProdPro.codeCltr.text.isNotEmpty &&
                                            newProdPro.codeCltr.text
                                                .contains('-')
                                        ? newProdPro.codeCltr.text.substring(
                                            newProdPro.codeCltr.text
                                                    .indexOf('-') +
                                                1)
                                        : newProdPro.codeCltr.text,
                                  ),
                                ),
                                TitleDropDown(
                                  title: LN.purchaseTax,
                                  hintText: LN.chooseTaxType,
                                  isReq: false,
                                  pWidth: 0.22,
                                  borderColor: Colors.black26,
                                  indexVal: newProdPro.purchaseTaxIndex,
                                  list: (newProdPro.addSecRes == null ||
                                          newProdPro.addSecRes!.purchaseTaxes ==
                                              null)
                                      ? []
                                      : newProdPro.addSecRes!.purchaseTaxes!
                                          .map((e) => e.value ?? '')
                                          .toList(),
                                  onChanged: (int? i) {
                                    newProdPro.purchaseTaxIndex = i;
                                    newProdPro.notify;
                                  },
                                ),
                                TitleDropDown(
                                  title: LN.brand,
                                  hintText: LN.chooseBrand,
                                  isReq: false,
                                  pWidth: 0.22,
                                  borderColor: Colors.black26,
                                  indexVal: newProdPro.brandIndex,
                                  list: (newProdPro.addSecRes == null ||
                                          newProdPro.addSecRes!.brands == null)
                                      ? []
                                      : newProdPro.addSecRes!.brands!
                                          .map((e) => e.value ?? '')
                                          .toList(),
                                  onChanged: (int? i) {
                                    newProdPro.brandIndex = i;
                                    newProdPro.notify;
                                  },
                                ),
                              ],
                            )),
                            SizedBox(
                              width: size.getW(48),
                            ),
                            SizedBox(
                              width: size.width * 0.22, //size.getW(328),
                              height: size.getH(170),
                              child: PImageSection(
                                hintText: "Add Image",
                                imagePath: newProdPro.getFilePath,
                                onTap: () {
                                  newProdPro.getFilePick();
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
                            TitleDropDown(
                              title: "Service Type",
                              hintText: "Service Type",
                              isReq: false,
                              pWidth: 0.22,
                              borderColor: Colors.black26,
                              indexVal: newProdPro.productTypeIndex,
                              list: (newProdPro.addSecRes == null ||
                                      newProdPro.addSecRes!.productTypes ==
                                          null)
                                  ? []
                                  : newProdPro.addSecRes!.productTypes!
                                      .map((e) => e.name ?? '')
                                      .toList(),
                              onChanged: (int? i) {
                                newProdPro.productTypeIndex = i;
                                newProdPro.notify;
                              },
                            ),
                            TitleDropDown(
                              title: "Service Price Type",
                              hintText: "Service Price Type",
                              isReq: false,
                              pWidth: 0.22,
                              borderColor: Colors.black26,
                              indexVal: newProdPro.pPriceTypeIndex,
                              list: (newProdPro.addSecRes == null ||
                                      newProdPro.addSecRes!.productPriceTypes ==
                                          null)
                                  ? []
                                  : newProdPro.addSecRes!.productPriceTypes!
                                      .map((e) => e.name ?? '')
                                      .toList(),
                              onChanged: (int? i) {
                                newProdPro.pPriceTypeIndex = i;
                                newProdPro.notify;
                              },
                            ),
                            TitleTextForm(
                              title: LN.priceRange,
                              pWidth: 0.22,
                              isReq: false,
                              borderColor: Colors.black26,
                              textCltr: newProdPro.priceRangeCtrl,
                              hintText: LN.priceRange,
                            ),
                            TitleTextForm(
                              title: "Estimated Time Range",
                              pWidth: 0.22,
                              isReq: false,
                              borderColor: Colors.black26,
                              textCltr: newProdPro.estimateTimeRangeCltr,
                              hintText: "Time Range",
                            ),
                            _titleSwitch(size,
                                title: "Enable Time Range",
                                value: newProdPro.enableEstTime,
                                onChanged: (val) {
                              newProdPro.enableEstTime = val;
                              newProdPro.notify;
                            }),
                            _titleSwitch(size,
                                title: LN.enablePrice,
                                value: newProdPro.enablePriceRange,
                                onChanged: (val) {
                              newProdPro.enablePriceRange = val;
                              newProdPro.notify;
                            }),
                            _titleSwitch(size,
                                title: LN.serviceStatus,
                                value: newProdPro.activateStatus,
                                onChanged: (val) {
                              newProdPro.activateStatus = val;
                              newProdPro.notify;
                            }),
                          ],
                        ),
                        SizedBox(
                          height: size.getH(24),
                        ),

                        if (newProdPro.addSecRes != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: PPVarientsList(
                              size: size,
                              listKey: newProdPro.listKey,
                              titleCltr: newProdPro.variationTitleCltr,
                              ppvList: newProdPro.ppvList,
                              onAdd: () {
                                newProdPro.addPVarient();
                              },
                              remove: (int j) {
                                if (newProdPro.ppvList[j].id.isNotEmpty) {
                                  showDialog(
                                      context: context,
                                      builder: (builder) => ConfirmDialog(
                                            title:
                                                "${LN.delete} ${newProdPro.ppvList[j].nameCltr.text}",
                                            subTitle:
                                                "${LN.sureToDelete} ${newProdPro.ppvList[j].nameCltr.text} ${LN.varient}?",
                                            actionText: LN.delete,
                                            onDelete: () async {
                                              newProdPro.deleteProdVariaton(
                                                  index: j);
                                              removeVarient(
                                                  j: j,
                                                  newProdPro: newProdPro,
                                                  size: size);
                                              return null;
                                            },
                                          ));
                                } else {
                                  removeVarient(
                                      j: j, newProdPro: newProdPro, size: size);
                                }
                              },
                              changeDefault: (p0, {bool? val}) {
                                if (val == null) {
                                  newProdPro.notify;
                                  return;
                                }
                                for (final e in newProdPro.ppvList) {
                                  e.isDefault = false;
                                }
                                newProdPro.ppvList[p0].isDefault =
                                    !newProdPro.ppvList[p0].isDefault;
                                newProdPro.notify;
                              },
                              isService: true,
                            ),
                          ),
                        //
                        if (newProdPro.htmlController != null)
                          Container(
                            margin: EdgeInsets.only(
                                top: size.getH(12),
                                bottom: size.getH(12),
                                right: size.getW(40)),
                            decoration: BoxDecoration(
                                color: kBackgroundColor,
                                borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.symmetric(
                                vertical: size.getH(8),
                                horizontal: size.getW(24)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                  height: 200,
                                  descriptionText: newProdPro.descriptionText,
                                  size: size,
                                  htmlController: newProdPro.htmlController ??
                                      HtmlEditorController(),
                                  onSave: (val) {
                                    newProdPro.descriptionText = val;
                                    newProdPro.notify;
                                  },
                                )
                              ],
                            ),
                          ),

                        SizedBox(
                          height: size.getH(24),
                        ),
                        Row(
                          children: [
                            if (GlobalCVP.viewWidget.viewAddProductButton)
                              LoadButton(
                                onsave: newProdPro.loading
                                    ? null
                                    : () {
                                        if (_formKey.currentState!.validate()) {
                                          newProdPro.htmlController
                                              ?.clearFocus();
                                          FocusScope.of(context).unfocus();
                                          newProdPro.addProduct(
                                              scrollController: _scrollCltr);
                                        } else {
                                          newProdPro.htmlController
                                              ?.clearFocus();
                                          FocusScope.of(context).unfocus();
                                          showToast(LN.invalidInput);
                                        }
                                      },
                                loading: newProdPro.loading,
                                btnText: newProdPro.editData == null
                                    ? 'Add Service'
                                    : 'Update Service',
                                width: 180,
                              ),
                            SizedBox(
                              width: size.getW(12),
                            ),
                            if (newProdPro.editData != null)
                              ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: WidgetStateProperty.all(
                                          Colors.red.shade700),
                                      padding: WidgetStateProperty.all(
                                          EdgeInsets.symmetric(
                                              horizontal: size.getW(16),
                                              vertical: size.getH(8)))),
                                  onPressed: () {
                                    newProdPro.clear();
                                    newProdPro.notify;
                                  },
                                  child: Text(
                                    LN.cancel,
                                    style: TextStyle(
                                      fontSize: size.getS(16),
                                      color: Colors.white,
                                    ),
                                  ))
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
            )),
      ),
    );
  }

  Widget _titleSwitch(
    Ssize size, {
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return SizedBox(
      width: size.width * 0.12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
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
                value: value,
                size: size,
                onChanged: onChanged,
              ),
              SizedBox(
                width: size.getW(12),
              ),
              Text(
                value ? LN.active : LN.inActive,
                style: TextStyle(
                  fontSize: size.getS(16),
                  color: value ? kSecondaryColor : Colors.red.shade700,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
