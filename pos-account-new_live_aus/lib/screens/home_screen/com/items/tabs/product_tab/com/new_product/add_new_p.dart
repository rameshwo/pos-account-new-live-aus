import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/product/new_product_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/product_tab/com/new_product/com/macros/macro_list_sec.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/product_tab/com/new_product/com/macros/macro_sec.dart';
import 'package:pos_account/widgets/dialog/confirm_dialog.dart';
import 'package:pos_account/widgets/input/dropdown/tree_dropdown/tree_dropdown.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/image/p_image_sec.dart';
import 'package:pos_account/widgets/input/dropdown/title_drop_down.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:pos_account/widgets/switch_adap.dart';
import 'package:pos_account/widgets/title_pop.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../widgets/description_view.dart';
import 'com/adons_section.dart';
import 'com/label_section/label_list_sec.dart';
import 'com/label_section/label_sec.dart';
import 'com/variant/pp_varient_list.dart';
import 'com/variant/prod_varient.dart';
import 'com/recent_add_product/recent_add_p.dart';

class AddNewProduct extends StatefulWidget {
  final Function()? onBack;

  const AddNewProduct({
    super.key,
    this.onBack,
  });

  @override
  State<AddNewProduct> createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {
  final _formKey = GlobalKey<FormState>();
  final focusNode = FocusNode();
  final _scrollCltr = ScrollController();
  NewProductPro? _newProdPro;

  @override
  void initState() {
    super.initState();
    _newProdPro = Provider.of<NewProductPro>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) => getData());
  }

  getData() {
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
        isService: false,
      ),
    );
  }

  // showRecentAddPDia() {
  //   return showDialog(
  //       context: context,
  //       builder: (builder) => SimpleDialog(
  //             backgroundColor: kBackgroundColor,
  //             titlePadding: EdgeInsets.zero,
  //             contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(15)),
  //             children: [
  //               RecentAddedProducts(
  //                 scrollController: _scrollCltr,
  //               )
  //             ],
  //           ));
  // }

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
        child: Column(
          children: [
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: EdgeInsets.all(size.getW(12)),
                child: TitlePop(
                  title: newProdPro.editData == null
                      ? LN.addNewProducts
                      : LN.updateProduct,
                  size: size,
                  onTap: () {
                    if (widget.onBack != null) widget.onBack!();
                  },
                ),
              ),
            ),
            SizedBox(height: size.getH(8)),
            Flexible(
              child: Form(
                  key: _formKey,
                  child: Card(
                    child: Scrollbar(
                      controller: _scrollCltr,
                      // isAlwaysShown: true,
                      // showTrackOnHover: true,
                      interactive: true,
                      thickness: 8,
                      radius: Radius.circular(40),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: size.getH(8.0),
                            horizontal: size.getW(24)),
                        child: SingleChildScrollView(
                          controller: _scrollCltr,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                      child: Wrap(
                                    spacing: size.getW(24),
                                    runSpacing: size.getH(24),
                                    children: [
                                      TitleTextForm(
                                        title: LN.productCode,
                                        pWidth: 0.22,
                                        isReq: false,
                                        readOnly: true,
                                        fillColor: Colors.grey.shade200,
                                        borderColor: Colors.black26,
                                        textInputType: TextInputType.number,
                                        textCltr: TextEditingController(
                                          text: newProdPro.codeCltr.text
                                                      .isNotEmpty &&
                                                  newProdPro.codeCltr.text
                                                      .contains('-')
                                              ? newProdPro.codeCltr.text
                                                  .substring(newProdPro
                                                          .codeCltr.text
                                                          .indexOf('-') +
                                                      1)
                                              : newProdPro.codeCltr.text,
                                        ),
                                      ),
                                      TitleTextForm(
                                        title: LN.productName,
                                        pWidth: 0.22,
                                        borderColor: Colors.black26,
                                        textCltr: newProdPro.nameCltr,
                                      ),

                                      // TitleTextForm(
                                      //   title: LN.slug,
                                      //   pWidth: 0.24,
                                      //   isReq: false,
                                      //   textCltr: newProdPro.slugCltr,
                                      // ),
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
                                        categoryList: newProdPro.categoryList,
                                        selectedId: newProdPro.selectedCatId,
                                        onChanged: (p0) {
                                          newProdPro.selectedCatId = p0;
                                          newProdPro.notify;
                                        },
                                      ),
                                      // TitleDropDown(
                                      //   title: LN.category,
                                      //   hintText: LN.chooseCategory,
                                      //   isReq: true,
                                      //   pWidth: 0.24,
                                      //   indexVal: newProdPro.catIndex,
                                      //   list: (newProdPro
                                      //               .addSecRes?.productCategories ==
                                      //           null)
                                      //       ? []
                                      //       : newProdPro.addSecRes!.productCategories!
                                      //           .map((e) => e.categoryName ?? '')
                                      //           .toList(),
                                      //   onChanged: (int? i) {
                                      //     newProdPro.catIndex = i;
                                      //     newProdPro.notify;
                                      //   },
                                      // ),
                                      // TreeDropWidget(
                                      //   width: size.width * 0.24,
                                      //   dialogWidth: size.width / 2,
                                      //   mode: Mode.DIALOG,
                                      //   selectedColor: kSecondaryColor,
                                      //   title: LN.brand,
                                      //   borderColor: Colors.black,
                                      //   hintText: LN.chooseBrand,
                                      //   categoryList: newProdPro.brandList,
                                      //   selectedId: newProdPro.selectedBrandId,
                                      //   onChanged: (p0) {
                                      //     newProdPro.selectedBrandId = p0;
                                      //     newProdPro.notify;
                                      //   },
                                      // ),
                                      TitleDropDown(
                                        title: LN.brand,
                                        hintText: LN.chooseBrand,
                                        isReq: false,
                                        pWidth: 0.22,
                                        borderColor: Colors.black26,
                                        indexVal: newProdPro.brandIndex,
                                        list: (newProdPro.addSecRes == null ||
                                                newProdPro.addSecRes!.brands ==
                                                    null)
                                            ? []
                                            : newProdPro.addSecRes!.brands!
                                                .map((e) => e.value ?? '')
                                                .toList(),
                                        onChanged: (int? i) {
                                          newProdPro.brandIndex = i;
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
                                                newProdPro.addSecRes!
                                                        .salesTaxes ==
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
                                      TitleDropDown(
                                        title: LN.purchaseTax,
                                        hintText: LN.chooseTaxType,
                                        isReq: false,
                                        pWidth: 0.22,
                                        borderColor: Colors.black26,
                                        indexVal: newProdPro.purchaseTaxIndex,
                                        list: (newProdPro.addSecRes == null ||
                                                newProdPro.addSecRes!
                                                        .purchaseTaxes ==
                                                    null)
                                            ? []
                                            : newProdPro
                                                .addSecRes!.purchaseTaxes!
                                                .map((e) => e.value ?? '')
                                                .toList(),
                                        onChanged: (int? i) {
                                          newProdPro.purchaseTaxIndex = i;
                                          newProdPro.notify;
                                        },
                                      ),
                                      // TitleDropDown(
                                      //   title: LN.taxIncExcl,
                                      //   hintText: LN.chooseTaxType,
                                      //   isReq: true,
                                      //   pWidth: 0.24,
                                      //   indexVal: newProdPro.taxIndex,
                                      //   list: (newProdPro.addSecRes == null ||
                                      //           newProdPro.addSecRes!
                                      //                   .taxInclusiveExclusive ==
                                      //               null)
                                      //       ? []
                                      //       : newProdPro
                                      //           .addSecRes!.taxInclusiveExclusive!
                                      //           .map((e) => e.value ?? '')
                                      //           .toList(),
                                      //   onChanged: (int? i) {
                                      //     newProdPro.taxIndex = i;
                                      //     newProdPro.notify;
                                      //   },
                                      // ),
                                    ],
                                  )),
                                  SizedBox(
                                    width: size.getW(48),
                                  ),
                                  SizedBox(
                                    width: size.width * 0.22, //size.getW(328),
                                    height: size.getH(170),
                                    child: PImageSection(
                                      hintText: LN.addProductImage,
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
                                  if (!GlobalCVP.isRetailStore)
                                    TitleDropDown(
                                        title: LN.docGroup,
                                        hintText: LN.chooseDocGroup,
                                        isReq: false,
                                        pWidth: 0.22,
                                        borderColor: Colors.black26,
                                        indexVal: newProdPro.docketGroupIndex,
                                        list: newProdPro
                                                    .addSecRes?.docketGroups ==
                                                null
                                            ? []
                                            : newProdPro
                                                .addSecRes!.docketGroups!
                                                .map((e) => e.value ?? '')
                                                .toList(),
                                        onChanged: (int? i) {
                                          newProdPro.docketGroupIndex = i;
                                          newProdPro.notify;
                                        },
                                        sufIcon: InkWell(
                                            onTap: () {
                                              newProdPro.docketGroupIndex =
                                                  null;
                                              newProdPro.notify;
                                            },
                                            child: Icon(Icons.close,
                                                size: size.getS(24)))),
                                  // TitleDropDown(
                                  //   title: LN.supplier,
                                  //   hintText: LN.chooseSupplier,
                                  //   isReq: false,
                                  //   pWidth: 0.24,
                                  //   indexVal: newProdPro.supplierIndex,
                                  //   list: newProdPro.addSecRes?.suppliers == null
                                  //       ? []
                                  //       : newProdPro.addSecRes!.suppliers!
                                  //           .map((e) => e.value ?? '')
                                  //           .toList(),
                                  //   onChanged: (int? i) {
                                  //     newProdPro.supplierIndex = i;
                                  //     newProdPro.notify;
                                  //   },
                                  // ),
                                  TitleTextForm(
                                    title: LN.allergens,
                                    pWidth: 0.22,
                                    isReq: false,
                                    borderColor: Colors.black26,
                                    textCltr: newProdPro.allergenCltr,
                                  ),

                                  TitleTextForm(
                                      title: LN.priceRange,
                                      pWidth: 0.22,
                                      isReq: false,
                                      borderColor: Colors.black26,
                                      textCltr: newProdPro.priceRangeCtrl),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        LN.enablePrice,
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
                                            value: newProdPro.enablePriceRange,
                                            size: size,
                                            onChanged: (val) {
                                              newProdPro.enablePriceRange = val;
                                              newProdPro.notify;
                                            },
                                          ),
                                          SizedBox(
                                            width: size.getW(12),
                                          ),
                                          Text(
                                            newProdPro.enablePriceRange
                                                ? LN.active
                                                : LN.inActive,
                                            style: TextStyle(
                                              fontSize: size.getS(16),
                                              color: newProdPro.activateStatus
                                                  ? kSecondaryColor
                                                  : Colors.red.shade700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        LN.productStatus,
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
                                            value: newProdPro.activateStatus,
                                            size: size,
                                            onChanged: (val) {
                                              newProdPro.activateStatus = val;
                                              newProdPro.notify;
                                            },
                                          ),
                                          SizedBox(
                                            width: size.getW(12),
                                          ),
                                          Text(
                                            newProdPro.activateStatus
                                                ? LN.active
                                                : LN.inActive,
                                            style: TextStyle(
                                              fontSize: size.getS(16),
                                              color: newProdPro.activateStatus
                                                  ? kSecondaryColor
                                                  : Colors.red.shade700,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),

                                  TitleDropDown(
                                    title: "Product Type",
                                    hintText: "Product Type",
                                    isReq: false,
                                    pWidth: 0.22,
                                    borderColor: Colors.black26,
                                    indexVal: newProdPro.productTypeIndex,
                                    list: (newProdPro.addSecRes == null ||
                                            newProdPro
                                                    .addSecRes!.productTypes ==
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
                                    title: "Product Price Type",
                                    hintText: "Product Price Type",
                                    isReq: false,
                                    pWidth: 0.22,
                                    borderColor: Colors.black26,
                                    indexVal: newProdPro.pPriceTypeIndex,
                                    list: (newProdPro.addSecRes == null ||
                                            newProdPro.addSecRes!
                                                    .productPriceTypes ==
                                                null)
                                        ? []
                                        : newProdPro
                                            .addSecRes!.productPriceTypes!
                                            .map((e) => e.name ?? '')
                                            .toList(),
                                    onChanged: (int? i) {
                                      newProdPro.pPriceTypeIndex = i;
                                      newProdPro.notify;
                                    },
                                  ),

                                  // TitleDropDown(
                                  //   title: LN.barcodeType,
                                  //   hintText: LN.chooseBarCode,
                                  //   isReq: false,
                                  //   pWidth: 0.24,
                                  //   indexVal: newProdPro.barCodeIndex,
                                  //   list: newProdPro.addSecRes?.barCodeTypes == null
                                  //       ? []
                                  //       : newProdPro.addSecRes!.barCodeTypes!
                                  //           .map((e) => e.value ?? '')
                                  //           .toList(),
                                  //   onChanged: (int? i) {
                                  //     newProdPro.barCodeIndex = i;
                                  //     newProdPro.notify;
                                  //   },
                                  // ),
                                ],
                              ),
                              // SizedBox(
                              //   height: size.getH(24),
                              // ),

                              // Wrap(
                              //   spacing: size.getW(24),
                              //   runSpacing: size.getH(24),
                              //   children: [],
                              // ),
                              SizedBox(
                                height: size.getH(16),
                              ),
                              // if (newProdPro.addSecRes?.channels?.isNotEmpty ?? false)
                              //   Row(
                              //     children: List.generate(
                              //         newProdPro.addSecRes!.channels!.length,
                              //         (index) => Padding(
                              //               padding:
                              //                   EdgeInsets.only(right: size.getW(16)),
                              //               child: _channelSec(size,
                              //                   title: newProdPro.addSecRes!
                              //                           .channels![index].name ??
                              //                       ''),
                              //             )),
                              //   ),
                              // SizedBox(
                              //   height: size.getH(12),
                              // ),
                              // InfoMessageSec(message: LN.addProductMessage),
                              if (newProdPro.addSecRes != null)
                                Padding(
                                  padding:
                                      EdgeInsets.only(bottom: size.getH(12.0)),
                                  child: PPVarientsList(
                                    size: size,
                                    listKey: newProdPro.listKey,
                                    titleCltr: newProdPro.variationTitleCltr,
                                    ppvList: newProdPro.ppvList,
                                    onAdd:
                                        //  (newProdPro.isRetail ?? false)
                                        //     ? null
                                        //     :
                                        () {
                                      newProdPro.addPVarient();
                                    },
                                    remove:
                                        // (newProdPro.isRetail ?? false)
                                        //     ? null
                                        //     :
                                        (int j) {
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
                                                    newProdPro
                                                        .deleteProdVariaton(
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
                                            j: j,
                                            newProdPro: newProdPro,
                                            size: size);
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
                                    isService: false,
                                  ),
                                ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: size.getH(12),
                                    bottom: size.getH(12),
                                    right: 0),
                                decoration: BoxDecoration(
                                    color: kBackgroundColor,
                                    borderRadius: BorderRadius.circular(10)),
                                padding: EdgeInsets.symmetric(
                                    vertical: size.getH(8),
                                    horizontal: size.getW(24)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                          newProdPro.htmlController ??
                                              HtmlEditorController(),
                                      descriptionText:
                                          newProdPro.descriptionText,
                                      height: 200,
                                      onSave: (val) {
                                        newProdPro.descriptionText = val;
                                        newProdPro.notify;
                                      },
                                    ),
                                    SizedBox(
                                      height: size.getH(16),
                                    ),
                                  ],
                                ),
                              ),
                              if (!GlobalCVP.isHospitality)
                                LabelListSec(
                                  size: size,
                                  title: LN.customDesc,
                                  labelList: newProdPro.labelList,
                                  listKey: newProdPro.labelKey,
                                  onAdd: () {
                                    newProdPro.addLabel();
                                  },
                                  remove: (p0) {
                                    newProdPro.removeLabel(
                                      i: p0,
                                      builder: (ctx, animation) =>
                                          LabelSection(animation: animation),
                                    );
                                  },
                                  onChanged: () => newProdPro.notify,
                                ),
                              SizedBox(
                                height: size.getH(16),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 12.0),
                                          child: AdonsSection(
                                            title: LN.addons,
                                            focusNode: focusNode,
                                            textCltr: newProdPro.adonTextCltr,
                                            itemList: newProdPro.adonList
                                                .map((e) => e.name)
                                                .toList(),
                                            onSubmit: (p0) {
                                              if (p0.isEmpty ||
                                                  newProdPro.adonSuggestion ==
                                                      null) return;

                                              final _addOnList =
                                                  newProdPro.adonSuggestion!;

                                              // To clear textfield if unmatch text is submitted
                                              if (!_addOnList
                                                  .map((e) => e.name)
                                                  .toList()
                                                  .contains(p0)) {
                                                newProdPro.adonTextCltr.clear();
                                                return;
                                              }

                                              final _addOn =
                                                  _addOnList.firstWhere(
                                                      (f) => f.name == p0);

                                              // To remove duplicate adons form list
                                              if (newProdPro.adonList
                                                  .map((e) => e.productId)
                                                  .contains(_addOn.id)) {
                                                showToast(
                                                    LN.alreadyListedOnAdons);
                                                newProdPro.adonTextCltr.clear();
                                                return;
                                              }

                                              // Not to submit the same product on adon list while edit
                                              if (newProdPro.editData != null &&
                                                  _addOn.id?.toLowerCase() ==
                                                      newProdPro.editData!.id
                                                          ?.toLowerCase()) {
                                                newProdPro.adonTextCltr.clear();
                                                showToast(
                                                    LN.mainProdCantListed);
                                                return;
                                              }

                                              newProdPro.adonList
                                                  .add(AdonsModel(
                                                name: _addOn.name!,
                                                productId: _addOn.id!,
                                              ));
                                              newProdPro.adonTextCltr.clear();
                                              newProdPro.adonSuggestion = null;
                                              newProdPro.notify;
                                            },
                                            onRemove: (i) {
                                              newProdPro.adonList.removeAt(i);
                                              newProdPro.notify;
                                            },
                                            onChanged: (p0) {
                                              if (newProdPro.addSecRes ==
                                                      null ||
                                                  newProdPro.addSecRes!
                                                          .orderTypes ==
                                                      null) return;

                                              Utils.handleSearch(
                                                  callback: () =>
                                                      newProdPro.getAdonSuggest(
                                                        keyWord: p0,
                                                      ));
                                            },
                                            suggestion:
                                                newProdPro.adonSuggestion ==
                                                            null ||
                                                        newProdPro
                                                            .adonSuggestion!
                                                            .isEmpty
                                                    ? []
                                                    : newProdPro.adonSuggestion!
                                                        .map((e) => e.name!)
                                                        .toSet()
                                                        .toList(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: size.getW(24)),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        bottom: size.getH(12.0)),
                                    child: MacroListSec(
                                      size: size,
                                      title: LN.productMacros,
                                      marcoList: newProdPro.macroList,
                                      listKey: newProdPro.macroKey,
                                      onAdd: () {
                                        newProdPro.addMacros();
                                      },
                                      remove: (p0) {
                                        newProdPro.removeMacro(
                                          i: p0,
                                          builder: (ctx, animation) =>
                                              MacroSection(
                                                  animation: animation),
                                        );
                                      },
                                    ),
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
                                      onsave: newProdPro.loading
                                          ? null
                                          : () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                bool _isNewProduct =
                                                    newProdPro.editData == null;
                                                newProdPro.htmlController
                                                    ?.clearFocus();
                                                FocusScope.of(context)
                                                    .unfocus();
                                                newProdPro.addProduct(
                                                    onBack: widget.onBack,
                                                    scrollController:
                                                        _scrollCltr,
                                                    onPopMsg: (bool val) {
                                                      if (val &&
                                                          _isNewProduct &&
                                                          GlobalCVP
                                                              .isHospitality)
                                                        RecentAddedProducts
                                                            .openAssingProduct(
                                                                context);
                                                    });
                                              } else {
                                                newProdPro.htmlController
                                                    ?.clearFocus();
                                                FocusScope.of(context)
                                                    .unfocus();
                                                showToast(LN.invalidInput);
                                              }
                                            },
                                      loading: newProdPro.loading,
                                      btnText: newProdPro.editData == null
                                          ? LN.addProduct
                                          : LN.updateProduct,
                                      width: newProdPro.editData == null
                                          ? 180
                                          : 200,
                                    ),
                                  // ElevatedButton(
                                  //     style: ButtonStyle(
                                  //         backgroundColor: MaterialStateProperty.all(
                                  //             newProdPro.loading
                                  //                 ? Colors.grey
                                  //                 : kSecondaryColor),
                                  //         padding: MaterialStateProperty.all(
                                  //             EdgeInsets.symmetric(
                                  //                 horizontal: size.getW(24),
                                  //                 vertical: size.getH(8)))),
                                  //     onPressed: newProdPro.loading
                                  //         ? null
                                  //         : () {
                                  //             if (_formKey.currentState!.validate()) {
                                  //               newProdPro.addProduct();
                                  //             }
                                  //           },
                                  //     child: Row(
                                  //       mainAxisSize: MainAxisSize.min,
                                  //       children: [
                                  //         if (newProdPro.editData == null)
                                  //           Padding(
                                  //             padding: EdgeInsets.only(right: size.getW(6)),
                                  //             child: Icon(
                                  //               Icons.add,
                                  //               color: Colors.white,
                                  //               size: size.getS(24),
                                  //             ),
                                  //           ),
                                  //         Text(
                                  //           newProdPro.editData == null
                                  //               ? LN.addProduct
                                  //               : LN.updateProduct,
                                  //           style: TextStyle(
                                  //             fontSize: size.getS(16),
                                  //             color: Colors.white,
                                  //           ),
                                  //         ),
                                  //       ],
                                  //     )),
                                  SizedBox(
                                    width: size.getW(12),
                                  ),
                                  if (newProdPro.editData != null)
                                    LoadButton(
                                      width: 120,
                                      hPad: 2,
                                      btnColor: Colors.red.shade700,
                                      onsave: () {
                                        newProdPro.clear();
                                        newProdPro.notify;
                                      },
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
                  )),
            ),
          ],
        ),
      ),
    );
  }

  // Row _channelSec(Ssize size, {required String title}) {
  //   return Row(
  //     children: [
  //       Container(
  //         decoration: BoxDecoration(
  //           color: kSecondaryColor,
  //           shape: BoxShape.circle,
  //         ),
  //         padding: EdgeInsets.all(size.getW(2)),
  //         child: Icon(
  //           Icons.check,
  //           color: Colors.white,
  //           size: size.getW(24),
  //         ),
  //       ),
  //       SizedBox(
  //         width: size.getW(6),
  //       ),
  //       Text(
  //         title,
  //         style: TextStyle(
  //           fontSize: size.getS(16),
  //           fontFamily: kFontFMedium,
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
