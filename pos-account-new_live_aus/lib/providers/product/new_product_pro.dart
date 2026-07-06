import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:pos_account/config/utils/order_utils.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/common/category.dart';
import 'package:pos_account/model/common/res_datum.dart';
import 'package:pos_account/model/home/product/add_raw_ingre_history_req.dart';
import 'package:pos_account/model/home/product/add_raw_ingre_request.dart';
import 'package:pos_account/model/home/product/new_product/adon_res.dart';
import 'package:pos_account/model/home/product/new_product/all_prod_add_sec.dart';
import 'package:pos_account/model/home/product/new_product/edit_price_res.dart';
import 'package:pos_account/model/home/product/new_product/get_all_products.dart';
import 'package:pos_account/model/home/product/product_data_req.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/repository/handler.dart';
import 'package:pos_account/services/image/image_service.dart';
import '../../model/common/table_location.dart';
import '../../model/home/product/all_raw_ingredient_response.dart';
import '../../model/home/product/raw_ingre_add_sec.dart';
import '../../model/home/product/raw_ingre_history_res.dart';
import '../../model/home/setting/general/category/restro_table_model.dart';
import '../../model/home/setting/general/upload_image_s3_res.dart';

class NewProductPro extends ChangeNotifier {
  bool loading = true;

  final nameCltr = TextEditingController();
  final slugCltr = TextEditingController();
  final allergenCltr = TextEditingController();

  // int? catIndex;
  String? selectedCatId;
  int? brandIndex;
  // int? supplierIndex;
  // int? barCodeIndex;
  int? docketGroupIndex;
  int? productTypeIndex;
  int? pPriceTypeIndex;

  final codeCltr = TextEditingController();

  // int? taxIndex = 0;
  int? salesTaxIndex = 0;
  int? purchaseTaxIndex = 0;
  // int channelIndex = 0;

  final adonList = <AdonsModel>[];
  final adonTextCltr = TextEditingController();

  var listKey = GlobalKey<AnimatedListState>();

  HtmlEditorController? htmlController;
  String descriptionText = ''; // Keep track of the text

  ///[Product_Price_Varient_List]

  final variationTitleCltr = TextEditingController(text: LN.variations);
  final ppvList = <PPVarient>[];
  final pfilterOptionList = <ProductFilterOptions>[];

  //batch key inside multiple variant
  var batchKeyList = <GlobalKey<AnimatedListState>>[
    GlobalKey<AnimatedListState>()
  ];

  //supplier key inside multiple variant
  var supplierKeyList = <GlobalKey<AnimatedListState>>[
    GlobalKey<AnimatedListState>()
  ];

  //modifier key inside multiple variant
  final modifierKeyList = <GlobalKey<AnimatedListState>>[];

  final serviceTypeKeyList = <GlobalKey<AnimatedListState>>[];

  final ingreKeyList = <GlobalKey<AnimatedListState>>[];

  var macroKey = GlobalKey<AnimatedListState>();
  final macroList = <Macros>[];

  var labelKey = GlobalKey<AnimatedListState>();
  final labelList = <LabelModel>[];

  AllProductAddSecRes? addSecRes;
  final categoryList = <Category>[];
  final rawCategoryList = <Category>[];
  final brandList = <Category>[];
  RawIngreAddSectionList? rawIngreAddSectionList;
  ProductDataReq? editData;
  AddRawIngreRequest? editRawIngreData;

  List<AdonRes>? adonSuggestion;

  //ingresec

  final ingCodeCltr = TextEditingController();
  final ingNameCltr = TextEditingController();
  final ingUnitPriceCltr = TextEditingController();
  final ingSellPriceUnitCltr = TextEditingController();
  int? selectedIngPucharseTaxIndex;
  int? selectedIngSalesTaxIndex;
  int? selectedIngCategoryIndex;
  String? selectedRawCatId;
  final ingWastagePercentCltr = TextEditingController();
  int? selectedIngUnitIndex;
  bool isIngActive = false;
  String? editRawIngreId;

  final rawIngreList = <RawIngredientData>[];
  AllRawIngredientResponse? allRawIngreRes;
  RawIngreHistoryResponse? allRawIngreHistoryRes;

  final rawIngreTableList = RTableData(
    headerList: [
      LN.name,
      LN.unitPrice,
      '${LN.sellingPrice} /${LN.unit}',
      LN.category,
      "${LN.available} ${LN.stock}",
      LN.action,
    ],
    hasAction: true,
    showCheckBox: false,
  );

  final rawIngreHistoryTableList = RTableData(
    headerList: [
      LN.date,
      "Actual ${LN.stock}",
      "Wastage ${LN.stock}",
      "Wastage Percentage",
      LN.description,
    ],
    hasAction: false,
    showCheckBox: false,
  );

  void setRawIngreTableList(
    AllRawIngredientResponse? allRawData,
  ) {
    if (allRawData?.data != null) {
      rawIngreTableList.tableDataList = [];
      for (final e in allRawData!.data!) {
        rawIngreTableList.tableDataList.add(
          TableDataList(
            id: e.id ?? '',
            imgList: [],
            itemList: [
              e.name ?? '',
              e.unitPricePerUnit != null && e.unitPricePerUnit != ''
                  ? e.unitPricePerUnit ?? '0.00'
                  : '0.00',
              e.sellingPricePerUnit != null && e.sellingPricePerUnit != ''
                  ? e.sellingPricePerUnit ?? '0.00'
                  : '0.00',
              e.category ?? '',
              e.availiableStock != null && e.availiableStock != ''
                  ? e.availiableStock ?? "0.00"
                  : '0.00',
            ],
            statusList: [],
          ),
        );
      }
    }
    notify;
  }

  void setRawIngreHistoryTableList(
    RawIngreHistoryResponse? allRawData,
  ) {
    if (allRawData?.data != null) {
      rawIngreHistoryTableList.tableDataList = [];
      for (final e in allRawData!.data!) {
        rawIngreHistoryTableList.tableDataList.add(
          TableDataList(
            id: e.id ?? '',
            imgList: [],
            itemList: [
              e.date ?? '',
              e.actualStock != null && e.actualStock != ''
                  ? e.actualStock ?? '0.00'
                  : '0.00',
              e.wastageStock != null && e.wastageStock != ''
                  ? e.wastageStock ?? '0.00'
                  : '0.00',
              e.wastagePercentage != null && e.wastagePercentage != ''
                  ? e.wastagePercentage ?? '0.00'
                  : '0.00',
              e.description ?? '',
            ],
            statusList: [],
          ),
        );
      }
    }
    notify;
  }

  void clearRawListSec() {
    rawIngreList.clear();
    rawSearchCltr.clear();
    rawIngreLoad = true;
    rawIngrePage = 1;
    _rawPageIndex = 1;
    _totalRawPage = 0;
    allRawIngreRes = null;
    rawIngreTableList.tableDataList = [];
  }

  void clearRawHistorySec({bool? all = true}) {
    _rawHisPageIndex = 1;
    rawIngreHistoryLoad = true;
    rawHisActualStockCltr.clear();
    rawHisWastageStockCltr.clear();
    rawHisDescriptionCltr.clear();
    if (all ?? false) {
      rawHisWastagePercentageCltr.clear();
      editRawIngreId = null;
      hisDateCltr.clear();
      rawIngreHistoryTableList.tableDataList = [];
      allRawIngreHistoryRes = null;
    }
  }

  void clearIngreSec() {
    ingCodeCltr.clear();
    ingNameCltr.clear();
    ingUnitPriceCltr.clear();
    ingSellPriceUnitCltr.clear();
    selectedIngPucharseTaxIndex = null;
    selectedIngSalesTaxIndex = null;
    selectedIngCategoryIndex = null;
    ingWastagePercentCltr.clear();
    isIngActive = false;
    selectedIngUnitIndex = null;
    editRawIngreId = null;
    editRawIngreData = null;
  }

  void clearAllIngreSec() {
    ingCodeCltr.clear();
    ingNameCltr.clear();
    ingUnitPriceCltr.clear();
    ingSellPriceUnitCltr.clear();
    selectedIngPucharseTaxIndex = null;
    selectedIngSalesTaxIndex = null;
    selectedIngCategoryIndex = null;
    ingWastagePercentCltr.clear();
    isIngActive = false;
    selectedIngUnitIndex = null;
    rawIngreAddSectionList = null;
    editRawIngreId = null;
    editRawIngreData = null;
    selectedRawCatId = null;
    rawCategoryList.clear();
    rawIngreAddSectionList = null;
    rawIngreList.clear();
  }

  void setRawData() {
    loading = false;
    if (rawIngreAddSectionList == null) return;
    ingCodeCltr.text = rawIngreAddSectionList?.code ?? '';
    if (rawIngreAddSectionList?.purchaseTaxes != null &&
        rawIngreAddSectionList!.purchaseTaxes!.isNotEmpty) {
      if (rawIngreAddSectionList!.purchaseTaxes!
          .any((e) => (e.isSelected ?? false))) {
        selectedIngPucharseTaxIndex = rawIngreAddSectionList!.purchaseTaxes!
            .indexWhere((e) => (e.isSelected ?? false));
      } else {
        selectedIngPucharseTaxIndex = 0;
      }
    }

    if (rawIngreAddSectionList?.salesTaxes != null &&
        rawIngreAddSectionList!.salesTaxes!.isNotEmpty) {
      if (rawIngreAddSectionList!.salesTaxes!
          .any((e) => (e.isSelected ?? false))) {
        selectedIngSalesTaxIndex = rawIngreAddSectionList!.salesTaxes!
            .indexWhere((e) => (e.isSelected ?? false));
      } else {
        selectedIngSalesTaxIndex = 0;
      }
    }

    if (rawIngreAddSectionList?.unitOfMeasurements != null &&
        rawIngreAddSectionList!.unitOfMeasurements!.isNotEmpty) {
      if (rawIngreAddSectionList!.unitOfMeasurements!
          .any((e) => (e.isSelected ?? false))) {
        selectedIngUnitIndex = rawIngreAddSectionList!.unitOfMeasurements!
            .indexWhere((e) => (e.isSelected ?? false));
      } else {
        selectedIngUnitIndex = 0;
      }
    }
    rawCategoryList.clear();

    if (rawIngreAddSectionList?.filterCategories != null) {
      rawCategoryList.addAll(
          OrderUtils.getCatList(rawIngreAddSectionList!.filterCategories!) ??
              []);
    }

    if (editRawIngreData == null) return;
    ingCodeCltr.text = editRawIngreData!.code ?? "";
    ingNameCltr.text = editRawIngreData!.name ?? '';
    ingUnitPriceCltr.text = editRawIngreData!.unitPricePerUnit ?? '';
    ingSellPriceUnitCltr.text = editRawIngreData!.sellingPricePerUnit ?? '';
    ingWastagePercentCltr.text = editRawIngreData!.wastagePercentage ?? '';
    isIngActive = editRawIngreData!.isActive ?? false;
    selectedRawCatId = editRawIngreData!.productCategoryId;
    if (rawIngreAddSectionList?.purchaseTaxes != null &&
        editRawIngreData!.purchaseTaxId != null &&
        editRawIngreData!.purchaseTaxId!.isNotEmpty) {
      selectedIngPucharseTaxIndex = rawIngreAddSectionList!.purchaseTaxes!
          .indexWhere((e) => e.id == editRawIngreData!.purchaseTaxId);
    }
    if (rawIngreAddSectionList?.salesTaxes != null &&
        editRawIngreData!.salesTaxId != null &&
        editRawIngreData!.salesTaxId!.isNotEmpty) {
      selectedIngSalesTaxIndex = rawIngreAddSectionList!.salesTaxes!
          .indexWhere((e) => e.id == editRawIngreData!.salesTaxId);
    }
    if (rawIngreAddSectionList?.unitOfMeasurements != null &&
        editRawIngreData!.unitOfMeasurementId != null &&
        editRawIngreData!.unitOfMeasurementId!.isNotEmpty) {
      selectedIngUnitIndex = rawIngreAddSectionList!.unitOfMeasurements!
          .indexWhere((e) => e.id == editRawIngreData!.unitOfMeasurementId);
    }
  }

  bool rawIngreLoad = true;
  bool rawIngreHistoryLoad = true;

  final rawSearchCltr = TextEditingController();

  int rawIngrePage = 1;
  int _rawPageIndex = 1;
  int _rawHisPageIndex = 1;
  final int _rawPageSize = 10;
  final int _rawHisPageSize = 10;
  int _totalRawPage = 0;

  int get getRawIngrePageSize => _rawPageSize;

  int get getRawIngrePage => rawIngrePage;

  int get getTotalRawPage => _totalRawPage;

  int get getRawPage => _rawPageIndex;

  int get getRawHisPage => _rawHisPageIndex;
  int get getRawHisPageSize => _rawHisPageSize;
  set setRawPage(int page) {
    _rawPageIndex = page;
  }

  set setRawHisPage(int page) {
    _rawHisPageIndex = page;
  }

  Future<void> getAllRawIngreList({
    int page = 1,
  }) async {
    rawIngreLoad = true;
    setRawPage = page;
    allRawIngreRes = await Handler.getAllRawIngre(
      page: page,
      pageSize: _rawPageSize,
      searchKey: rawSearchCltr.text,
    );
    if (allRawIngreRes?.data != null) {
      setRawIngreTableList(allRawIngreRes);
    }
    rawIngreLoad = false;
    notify;
  }

  Future<void> getAllRawIngreHistory({
    int page = 1,
  }) async {
    rawIngreHistoryLoad = true;
    setRawPage = page;
    allRawIngreHistoryRes = await Handler.getRawIngreHistory(
      page: page,
      pageSize: _rawHisPageIndex,
      id: editRawIngreId ?? "",
    );
    if (allRawIngreHistoryRes?.data != null) {
      setRawIngreHistoryTableList(allRawIngreHistoryRes);
    }
    rawIngreHistoryLoad = false;
    notify;
  }

  void getRawIngreAddSection() async {
    loading = true;
    rawIngreAddSectionList = await Handler.getRawIngreAddSec();
    setRawData();
    loading = false;
    notify;
  }

  Future<bool?> getEditRawData() async {
    if (editRawIngreId == null) return null;
    loading = true;
    notify;
    editRawIngreData = await Handler.editRawIngre(
      id: editRawIngreId ?? "",
    );
    setRawData();
    rawIngreLoad = false;
    notify;
    return editRawIngreData != null;
  }

  final rawHisActualStockCltr = TextEditingController();
  final rawHisWastageStockCltr = TextEditingController();
  final hisDateCltr = TextEditingController();
  final rawHisWastagePercentageCltr = TextEditingController();
  final rawHisDescriptionCltr = TextEditingController();

  void addRawLooseIngredientStockHistory() async {
    loading = true;
    notify;
    final _reqData = AddRawIngreHistoryRequest()
      ..id = ""
      ..rawLooseIngredientId = editRawIngreId ?? ""
      ..actualStock = rawHisActualStockCltr.text
      ..wastageStock = rawHisWastageStockCltr.text
      ..description = rawHisDescriptionCltr.text
      ..date = hisDateCltr.text
      ..wastagePercentage = rawHisWastagePercentageCltr.text;

    final res = await Handler.addUpRawIngreHistory(
      req: _reqData,
    );

    if (res != null && res == true) {
      productLoad = true;
      notify;
      clearRawHistorySec(all: false);
      getAllRawIngreHistory(page: 1);
      getAllRawIngreList(page: 1);
    }
    loading = false;
    notify;
  }

  void addUpdateRawIngreAddSection() async {
    loading = true;
    notify;

    final _reqData = AddRawIngreRequest()
      ..id = editRawIngreId ?? ""
      ..code = ingCodeCltr.text
      ..name = ingNameCltr.text
      ..unitPricePerUnit = ingUnitPriceCltr.text
      ..sellingPricePerUnit = ingSellPriceUnitCltr.text
      ..wastagePercentage = ingWastagePercentCltr.text
      ..isActive = isIngActive;
    if (rawIngreAddSectionList?.purchaseTaxes != null &&
        rawIngreAddSectionList!.purchaseTaxes!.isNotEmpty &&
        selectedIngPucharseTaxIndex != null) {
      _reqData.purchaseTaxId = rawIngreAddSectionList
          ?.purchaseTaxes?[selectedIngPucharseTaxIndex!].id;
    }

    if (rawIngreAddSectionList?.salesTaxes != null &&
        rawIngreAddSectionList!.salesTaxes!.isNotEmpty &&
        selectedIngSalesTaxIndex != null) {
      _reqData.salesTaxId =
          rawIngreAddSectionList?.salesTaxes?[selectedIngSalesTaxIndex!].id;
    }

    if (rawIngreAddSectionList!.unitOfMeasurements != null &&
        rawIngreAddSectionList!.unitOfMeasurements!.isNotEmpty &&
        selectedIngUnitIndex != null) {
      _reqData.unitOfMeasurementId =
          rawIngreAddSectionList?.unitOfMeasurements?[selectedIngUnitIndex!].id;
    }

    if (rawIngreAddSectionList?.filterCategories != null &&
        selectedRawCatId != null &&
        selectedRawCatId!.isNotEmpty) {
      _reqData.productCategoryId = selectedRawCatId;
    }
    final res = await Handler.addRawIngre(
      req: _reqData,
    );

    if (res != null && res == true) {
      productLoad = true;
      notify;
      clearAllIngreSec();
      getRawIngreAddSection();
    }
    loading = false;
    notify;
  }

  // GetAllProductRes? getAllProductRes;

  List<String>? deletedProductMacrosId;
  List<String>? deletedProductLabelsId;
  List<String>? deletedProductBatchesId;
  List<String>? deletedProductSuppliersId;
  List<String>? deletedProductModifiersId;
  List<String>? deletedServiceTypeId;
  List<String>? deletedProductVariantSpicesId;
  List<String>? deletedRawIngreId;

  bool? isRetail;

  bool activateStatus = true;
  bool enablePriceRange = false;
  final priceRangeCtrl = TextEditingController();
  final estimateTimeRangeCltr = TextEditingController();
  bool enableEstTime = false;

  final serviceTypeDefault = <String>["Male Only", "Female Only", "Unisex"];

  Future<void> getData() async {
    // final _loginRes = await DbLocalData.getLoginRes();
    // if (_loginRes.storeDetailsLoginResponseViewModels != null &&
    //     _loginRes.storeDetailsLoginResponseViewModels!
    //         .any((e) => e.isActive != null && e.isActive!)) {
    // final _store = _loginRes.storeDetailsLoginResponseViewModels
    //     ?.firstWhere((e) => e.isActive != null && e.isActive!);
    // isRetail = _store?.isRetail ?? false;
    // }
    if (editData == null) {
      addSecRes = await Handler.getAllProductAddSection();
    }
    setChannel();
    setData();
    notify;
    searchProdCltr.clear();
  }

  Future<void> getEditData(
      {required String id, ScrollController? scrollController}) async {
    loading = true;
    notify;
    editData = await Handler.editProducts(
      reqStoredId: id,
    );
    setData();
    notify;
    // Future.delayed(Duration(milliseconds: 1000), () {
    //   scrollController?.animateTo(
    //     0,
    //     duration: Duration(milliseconds: 700),
    //     curve: Curves.easeInOutCubic,
    //   );
    // });
  }

  void setData() {
    loading = false;

    if (addSecRes == null) return;

    codeCltr.text = addSecRes!.code ?? '';
    // if (addSecRes?.taxInclusiveExclusive != null &&
    //     addSecRes!.taxInclusiveExclusive!.any((e) => (e.isSelected ?? false))) {
    //   taxIndex = addSecRes!.taxInclusiveExclusive!
    //       .indexWhere((e) => (e.isSelected ?? false));
    // }

    if (addSecRes?.salesTaxes != null &&
        addSecRes!.salesTaxes!.any((e) => (e.isSelected ?? false))) {
      salesTaxIndex =
          addSecRes!.salesTaxes!.indexWhere((e) => (e.isSelected ?? false));
    }

    if (addSecRes?.purchaseTaxes != null &&
        addSecRes!.purchaseTaxes!.any((e) => (e.isSelected ?? false))) {
      purchaseTaxIndex =
          addSecRes!.purchaseTaxes!.indexWhere((e) => (e.isSelected ?? false));
    }

    categoryList.clear();

    if (addSecRes?.filterCategories != null) {
      categoryList
          .addAll(OrderUtils.getCatList(addSecRes!.filterCategories!) ?? []);
    }

    if (addSecRes!.productTypes!.any((e) => e.isSelected ?? false)) {
      productTypeIndex =
          addSecRes!.productTypes!.indexWhere((e) => e.isSelected ?? false);
    }

    if (addSecRes!.productPriceTypes!.any((e) => e.isSelected ?? false)) {
      pPriceTypeIndex = addSecRes!.productPriceTypes!
          .indexWhere((e) => e.isSelected ?? false);
    }

    // if (addSecRes?.filterCategoriesWithFilterTypes != null) {
    //   categoryList.clear();
    //   if (addSecRes!.filterCategoriesWithFilterTypes!
    //       .any((e) => e.identifier == "1")) {
    //     final _catList = addSecRes!.filterCategoriesWithFilterTypes!
    //         .firstWhere((e) => e.identifier == "1")
    //         .childernCategories;

    //     categoryList.addAll(getCatList(_catList) ?? []);
    //   }

    //   brandList.clear();
    //   if (addSecRes!.filterCategoriesWithFilterTypes!
    //       .any((e) => e.identifier == "2")) {
    //     final _brandList = addSecRes!.filterCategoriesWithFilterTypes!
    //             .firstWhere((e) => e.identifier == "2")
    //             .childernCategories ??
    //         [];
    //     brandList.addAll(getCatList(_brandList) ?? []);
    //   }
    // }

    if (editData == null) return;

    // if (_addSecRes!.orderTypes != null &&
    //     editData!.channelId != null &&
    //     editData!.channelId!.isNotEmpty) {
    //   orderTypeIndex = _addSecRes!.orderTypes!
    //       .indexWhere((e) => e.id == editData!.channelId);
    // }
    // if (editData!.orderTypeProductPriceWithVariations != null &&
    //     editData!.orderTypeProductPriceWithVariations!.isNotEmpty) {
    //   orderTypeInex = addSecRes!.orderTypes!.indexWhere((e) =>
    //       e.id ==
    //       editData!.orderTypeProductPriceWithVariations![0].orderTypeId);
    // }
    setChannel();
    deletedProductBatchesId = null;
    deletedProductSuppliersId = null;
    deletedProductMacrosId = null;
    deletedProductLabelsId = null;
    deletedServiceTypeId = null;
    deletedRawIngreId = null;
    deletedProductVariantSpicesId = null;
    // deletedProductVariantsId = null;

    nameCltr.text = editData!.name ?? '';
    slugCltr.text = editData!.slug ?? '';

    descriptionText = editData!.description ?? '';

    allergenCltr.text = editData!.allergens ?? '';
    // if (_addSecRes!.productCategories != null &&
    //     editData!.productCategoryId != null &&
    //     editData!.productCategoryId!.isNotEmpty)

    selectedCatId = editData!.productCategoryId;

    // _addSecRes!.productCategories!
    //     .firstWhere((e) => e.categoryId == editData!.productCategoryId)
    //     .categoryId;

    // selectedBrandId = editData!.brandId;

    if ((editData?.brandId?.isNotEmpty ?? false) &&
        (addSecRes?.brands?.any((e) => e.id == editData!.brandId) ?? false))
      brandIndex =
          addSecRes!.brands!.indexWhere((e) => e.id == editData!.brandId);

    if ((editData?.productTypeId?.isNotEmpty ?? false) &&
        (addSecRes?.productTypes?.any((e) =>
                e.id?.toLowerCase() ==
                editData!.productTypeId?.toLowerCase()) ??
            false)) {
      productTypeIndex = addSecRes!.productTypes!.indexWhere(
          (e) => e.id?.toLowerCase() == editData!.productTypeId?.toLowerCase());
    }

    if ((editData?.productPriceTypeId?.isNotEmpty ?? false) &&
        (addSecRes?.productPriceTypes?.any((e) =>
                e.id?.toLowerCase() ==
                editData!.productPriceTypeId?.toLowerCase()) ??
            false)) {
      pPriceTypeIndex = addSecRes!.productPriceTypes!.indexWhere((e) =>
          e.id?.toLowerCase() == editData!.productPriceTypeId?.toLowerCase());
    }
    codeCltr.text = editData!.code ?? '';

    // if (addSecRes!.taxInclusiveExclusive != null &&
    //     editData!.taxExclusiveInclusiveId != null &&
    //     editData!.taxExclusiveInclusiveId!.isNotEmpty)
    //   taxIndex = addSecRes!.taxInclusiveExclusive!
    //       .indexWhere((e) => e.id == editData!.taxExclusiveInclusiveId);

    if ((editData!.salesTaxId?.isNotEmpty ?? false) &&
        (addSecRes?.salesTaxes?.any((e) => e.id == editData!.salesTaxId) ??
            false))
      salesTaxIndex = addSecRes!.salesTaxes!
          .indexWhere((e) => e.id == editData!.salesTaxId);

    if ((editData!.purchaseTaxId?.isNotEmpty ?? false) &&
        (addSecRes?.purchaseTaxes
                ?.any((e) => e.id == editData!.purchaseTaxId) ??
            false))
      purchaseTaxIndex = addSecRes!.purchaseTaxes!
          .indexWhere((e) => e.id == editData!.purchaseTaxId);

    // if (addSecRes!.suppliers != null &&
    //     editData!.supplierId != null &&
    //     editData!.supplierId!.isNotEmpty)
    //   supplierIndex =
    //       addSecRes!.suppliers!.indexWhere((e) => e.id == editData!.supplierId);

    if (editData!.docketGroupId != null &&
        editData!.docketGroupId!.isNotEmpty &&
        (addSecRes?.docketGroups?.any((e) => e.id == editData!.docketGroupId) ??
            false))
      docketGroupIndex = addSecRes!.docketGroups!
          .indexWhere((e) => e.id == editData!.docketGroupId);

    // if (editData!.barCodeTypeStoreId != null &&
    //     editData!.barCodeTypeStoreId!.isNotEmpty &&
    //     (addSecRes?.barCodeTypes
    //             ?.any((e) => e.id == editData!.barCodeTypeStoreId) ??
    //         false))
    //   barCodeIndex = addSecRes!.barCodeTypes!
    //       .indexWhere((e) => e.id == editData!.barCodeTypeStoreId);

    activateStatus = editData!.isActive ?? false;
    enablePriceRange = editData!.enablePriceRange ?? false;
    priceRangeCtrl.text = editData!.priceRange ?? '';
    estimateTimeRangeCltr.text = editData!.estimatedTimeRange ?? '';
    enableEstTime = editData?.enableTimeRange ?? false;

    // for (final e in ppvList) {
    //   if (editData!.productVariations != null &&
    //       editData!.orderTypeProductPriceWithVariations!
    //           .map((g) => g.orderTypeId)
    //           .toList()
    //           .contains(e.orderTypeId)) {
    //     final _oTProduct = editData!.orderTypeProductPriceWithVariations!
    //         .firstWhere((f) => f.orderTypeId == e.orderTypeId);

    //     e.id = _oTProduct.id ?? '';
    //     e.orderTypeName = _oTProduct.orderTypeName ?? '';

    //     activateStatus = _oTProduct.isActive ?? false;
    //     e.pVList.clear();
    if (editData!.productVariations != null) {
      ppvList.clear();
      listKey = GlobalKey<AnimatedListState>();
      for (final a in editData!.productVariations!) {
        batchKeyList.add(GlobalKey<AnimatedListState>());
        supplierKeyList.add(GlobalKey<AnimatedListState>());
        modifierKeyList.add(GlobalKey<AnimatedListState>());
        serviceTypeKeyList.add(GlobalKey<AnimatedListState>());
        ingreKeyList.add(GlobalKey<AnimatedListState>());
        final spiceChoices = addSecRes?.spiceChoices ?? [];
        final selectedSpices =
            a.productVariationSpiceChoiceModifierGroup?.modifierItems ?? [];

        //
        final _channels = <PVChannelPrice>[];
        if (a.productVariationChannelPrices != null)
          for (final z in a.productVariationChannelPrices!) {
            if (addSecRes?.channels?.any(
                    (e) => e.id?.toLowerCase() == z.channelId?.toLowerCase()) ??
                false) {
              final _cName = addSecRes?.channels
                  ?.firstWhere(
                      (e) => e.id?.toLowerCase() == z.channelId?.toLowerCase())
                  .name;
              _channels.add(PVChannelPrice(
                id: z.id ?? '',
                channelId: z.channelId ?? '',
                channelName: _cName ?? '',
                sellingPriceCltr: TextEditingController(text: z.actualPrice),
                disPriceCltr: TextEditingController(text: z.discountPrice),
                disPercentCltr:
                    TextEditingController(text: z.discountPercentage),
                newSellingPriceCltr:
                    TextEditingController(text: z.discountedPrice),
                // variablePriceMode: _cPrice.variablePriceMode ?? false,
                isActive: z.isActive ?? false,
              ));
            }
          }

        ppvList.add(PPVarient(
          spices: GlobalCVP.isHospitality
              ? List.generate(spiceChoices.length, (index) {
                  final e = spiceChoices[index];
                  final selectedSpice = selectedSpices.firstWhere(
                      (spice) =>
                          spice.name?.toLowerCase() == e.name?.toLowerCase(),
                      orElse: () => ModifierRawSpiceItem());
                  return TableLocation(
                    id: selectedSpice.id,
                    name: e.name,
                    additionalValue:
                        a.productVariationSpiceChoiceModifierGroup?.id ??
                            addSecRes?.spiceChoiceModifierGroup?.id,
                    isSelected: selectedSpice.isActive ?? false,
                  );
                })
              : [],
          batches: a.batches == null || a.batches!.isEmpty
              ? <Batch>[
                  Batch(
                    id: '',
                    stockCountCltr: TextEditingController(),
                    batchExpiryCltr: TextEditingController(),
                    batchNoCltr: TextEditingController(),
                  )
                ]
              : List.generate(a.batches!.length, (index) {
                  final b = a.batches?[index];
                  return Batch(
                    isEdit: true,
                    id: b?.id ?? '',
                    stockCountCltr: TextEditingController(text: b?.stock),
                    batchExpiryCltr: TextEditingController(text: b?.expiryDate),
                    batchNoCltr: TextEditingController(text: b?.batchNo),
                    runningStockCltr:
                        TextEditingController(text: b?.runningStock),
                    addStockCltr:
                        TextEditingController(text: b?.additionalStock),
                  );
                }),
          suppliers: (a.productVariationSuppliers?.isNotEmpty ?? false)
              ? List.generate(a.productVariationSuppliers!.length, (index) {
                  final b = a.productVariationSuppliers?[index];
                  final supIndex = (addSecRes?.suppliers?.any((e) =>
                              e.id?.toLowerCase() ==
                              b?.supplierId?.toLowerCase()) ??
                          false)
                      ? addSecRes?.suppliers?.indexWhere((e) =>
                          e.id?.toLowerCase() == b?.supplierId?.toLowerCase())
                      : null;
                  return Supplier(
                    id: b?.id ?? '',
                    supplierIndex: supIndex,
                    codeCltr: TextEditingController(text: b?.supplierItemCode),
                  );
                })
              : <Supplier>[
                  Supplier(
                    id: '',
                    codeCltr: TextEditingController(),
                  )
                ],
          serviceTypeDefault: a.serviceGender,
          rawIngre: GlobalCVP.isHospitality &&
                  (a.productVariationRawIngredientModifierGroup?.modifierItems
                          ?.isNotEmpty ??
                      false)
              ? List.generate(
                  a.productVariationRawIngredientModifierGroup!.modifierItems!
                      .length, (index) {
                  final _ingre = a.productVariationRawIngredientModifierGroup!
                      .modifierItems![index];

                  final _ingreIndex = (addSecRes?.rawLooseIngredients?.any(
                              (c) =>
                                  c.id?.toLowerCase() ==
                                  _ingre.rawIngredientId?.toLowerCase()) ??
                          false)
                      ? addSecRes?.rawLooseIngredients?.indexWhere((c) =>
                          c.id?.toLowerCase() ==
                          _ingre.rawIngredientId?.toLowerCase())
                      : null;
                  final _ingreName = (_ingre.name?.isNotEmpty ?? false)
                      ? _ingre.name
                      : (_ingreIndex != null
                          ? (addSecRes
                                  ?.rawLooseIngredients?[_ingreIndex].name ??
                              '')
                          : "");
                  return RawIngre(
                    id: _ingre.id ?? '',
                    nameCltr: TextEditingController(text: _ingreName),
                    status: _ingre.isActive ?? false,
                    ingreIndex: _ingreIndex,
                    qtySmallCltr: TextEditingController(text: _ingre.quantity),
                    qtyLargeCltr: TextEditingController(
                        text: ((_ingre.quantity?.inDouble ?? 0) / 1000)
                            .formatDouble),
                    rootId: a.productVariationRawIngredientModifierGroup?.id ??
                        addSecRes?.rawIngredientModifierGroup?.id,
                  );
                })
              : <RawIngre>[],
          // serviceType: (a.productVariationServiceItems?.isNotEmpty ?? false)
          //     ? List.generate(
          //         a.productVariationServiceItems!.length,
          //         (index) => ServiceType(
          //               id: a.productVariationServiceItems![index].id ?? '',
          //               typeCltr: TextEditingController(
          //                   text:
          //                       a.productVariationServiceItems![index].name),
          //             ))
          //     : <ServiceType>[],
          // modifiers: a.productVariationPriceGroupModifiers == null ||
          //         a.productVariationPriceGroupModifiers!.isEmpty
          //     ? <Modifier>[
          //         // Modifier(
          //         //   id: '',
          //         //   modifierNameCltr: TextEditingController(),
          //         //   modifierPriceCltr: TextEditingController(),
          //         // )
          //       ]
          //     : List.generate(a.productVariationPriceGroupModifiers!.length,
          //         (index) {
          //         final _b = a.productVariationPriceGroupModifiers?[index];
          //         final _index = (addSecRes?.productPriceModifierGroups?.any(
          //                     (e) =>
          //                         e.id?.toLowerCase() ==
          //                         _b?.productPriceModifierGroupId
          //                             ?.toLowerCase()) ??
          //                 false)
          //             ? addSecRes?.productPriceModifierGroups?.indexWhere(
          //                 (e) =>
          //                     e.id?.toLowerCase() ==
          //                     _b?.productPriceModifierGroupId?.toLowerCase())
          //             : null;
          //         return Modifier(
          //           modifierLabelIndex: _index,
          //           modifierNameList: _b?.productVariationPriceModifiers ==
          //                   null
          //               ? []
          //               : List.generate(
          //                   _b!.productVariationPriceModifiers!.length, (i) {
          //                   final _c = _b.productVariationPriceModifiers![i];
          //                   final _modiIndex = (addSecRes
          //                               ?.productPriceModifers
          //                               ?.any((e) =>
          //                                   e.id?.toLowerCase() ==
          //                                   _c.productPriceModifierId
          //                                       ?.toLowerCase()) ??
          //                           false)
          //                       ? addSecRes?.productPriceModifers?.indexWhere(
          //                           (e) =>
          //                               e.id?.toLowerCase() ==
          //                               _c.productPriceModifierId
          //                                   ?.toLowerCase())
          //                       : null;
          //                   return ModifierName(
          //                     id: _c.id ?? '',
          //                     modifierNameIndex: _modiIndex,
          //                     modifierNameCltr:
          //                         TextEditingController(text: _c.name),
          //                     modifierPriceCltr:
          //                         TextEditingController(text: _c.price),
          //                     estTimeCltr: TextEditingController(
          //                         text: _c.estimatedTime),
          //                     status: _c.isActive ?? false,
          //                   );
          //                 }),
          //         );
          //       }),
          id: a.id ?? '',
          nameCltr: TextEditingController(text: a.name),
          // priceCltr: TextEditingController(text: a.price),
          stockCountCltr: TextEditingController(text: a.stockCount),
          minSACountCltr: TextEditingController(text: a.minimumStockAlertCount),
          maxSACountCltr: TextEditingController(text: a.maximumStockAlertCount),
          caloryCltr: TextEditingController(
              text: GlobalCVP.isServiceStore ? a.estimatedTime : a.calories),
          isDefault: a.isDefault ?? false,
          // discountCLtr: TextEditingController(text: a.discountPrice),
          unitPriceCltr: TextEditingController(text: a.unitPrice),
          codeCltr: TextEditingController(text: a.code),
          barcodeCltr: TextEditingController(text: a.barCodeNumber),
          expiryDateCltr: TextEditingController(text: a.expiryDate),
          sortOrderCltr: TextEditingController(text: a.sortOrder?.toString()),
          isActive: a.isActive,
          channels: _channels,
        ));
      }
    }

    //productFilterOptions
    if (editData!.productFilterOptions != null) {
      pfilterOptionList.clear();
      for (final f in editData!.productFilterOptions!) {
        pfilterOptionList.add(ProductFilterOptions(
            id: f.id,
            filterTypeId: f.filterTypeId,
            filterTypeOptionsId: f.filterTypeOptionsId,
            type: f.type));
      }
    }
    // }
    // }
    // product macros

    if (editData!.productMacros != null &&
        editData!.productMacros!.isNotEmpty) {
      macroList.clear();
      macroKey = GlobalKey<AnimatedListState>();
      for (final e in editData!.productMacros!) {
        macroList.add(Macros(
            id: e.id ?? '',
            name: TextEditingController(text: e.name),
            value: TextEditingController(text: e.value)));
      }
    }

    if (editData!.productCustomDescriptions != null &&
        editData!.productCustomDescriptions!.isNotEmpty) {
      labelList.clear();
      labelKey = GlobalKey<AnimatedListState>();

      for (final e in editData!.productCustomDescriptions!) {
        final htmlController = HtmlEditorController();

        // Create the LabelModel first without setting the description
        final label = LabelModel(
          id: e.identifier ?? "",
          titleCltr: TextEditingController(text: e.labelName ?? ''),
          htmlCltr: htmlController,
          description: e.descripiton ?? '',
          sortOrderCltr: TextEditingController(text: "${e.sortOrder ?? ''}"),
          identCltr: TextEditingController(text: e.identifier ?? ''),
        );

        // Add the LabelModel to the list
        labelList.add(label);
        // WidgetsBinding.instance?.addPostFrameCallback((_) async {
        //   await Future.delayed(Duration(milliseconds: 300));
        //   try {
        //     _htmlController.setText(e.descripiton ?? '');
        //   } catch (error) {
        //     debugPrint("Error setting text: $error");
        //   }
        // });
      }
    }

    //adons
    if (editData!.addOnProducts != null) {
      adonList.clear();
      for (final a in editData!.addOnProducts!) {
        adonList.add(AdonsModel(
          id: a.id ?? '',
          productId: a.productId ?? '',
          name: a.name ?? '',
        ));
      }
    }

    setFilepath = editData!.imageUrl;
  }

  // int? orderTypeInex;

  void onClickSpices() {}

  setChannel() {
    // if (_addSecRes != null &&
    //     _addSecRes!.orderTypes != null &&
    //     _addSecRes!.orderTypes!.isNotEmpty) {

    // listKey = GlobalKey<AnimatedListState>();
    //clear adons on change
    adonList.clear();
    adonSuggestion = null;
    //
    // if (orderTypeInex != null) {
    ppvList.clear();
    ppvList.add(PPVarient(
        spices: (addSecRes?.spiceChoices ?? [])
            .map(
                (e) => TableLocation.fromJson((e..isSelected = false).toJson()))
            .toList(),
        batches: <Batch>[
          Batch(
            id: '',
            stockCountCltr: TextEditingController(),
            batchExpiryCltr: TextEditingController(),
            batchNoCltr: TextEditingController(),
          )
        ],
        suppliers: <Supplier>[
          Supplier(
            id: '',
            codeCltr: TextEditingController(),
          )
        ],
        // modifiers: [],
        // serviceType: [],
        rawIngre: [],
        nameCltr: TextEditingController(text: ""),
        // priceCltr: TextEditingController(),
        stockCountCltr: TextEditingController(),
        minSACountCltr: TextEditingController(),
        maxSACountCltr: TextEditingController(),
        caloryCltr: TextEditingController(),
        sortOrderCltr: TextEditingController(),
        // discountCLtr: TextEditingController(),
        unitPriceCltr: TextEditingController(),
        codeCltr: TextEditingController(),
        barcodeCltr: TextEditingController(text: ''),
        isDefault: true,
        expiryDateCltr: TextEditingController(),
        channels: addSecRes?.channels == null
            ? []
            : List.generate(
                addSecRes!.channels!.length,
                (index) => PVChannelPrice(
                      channelId: addSecRes!.channels![index].id ?? '',
                      channelName: addSecRes!.channels![index].name ?? '',
                      // isActive: addSecRes!.channels![index].isSelected ?? false,
                      sellingPriceCltr: TextEditingController(text: '0.00'),
                      disPriceCltr: TextEditingController(),
                      disPercentCltr: TextEditingController(),
                      newSellingPriceCltr: TextEditingController(),
                    ))));
    listKey = GlobalKey<AnimatedListState>();
    modifierKeyList.add(GlobalKey<AnimatedListState>());
    serviceTypeKeyList.add(GlobalKey<AnimatedListState>());
    ingreKeyList.add(GlobalKey<AnimatedListState>());

    // labelList.clear();
    // labelList.add(LabelModel(
    //   titleCltr: TextEditingController(text: "Description"),
    //   htmlCltr: HtmlEditorController(),
    //   sortOrderCltr: TextEditingController(),
    //   identCltr: TextEditingController(),
    // ));
    // labelKey = GlobalKey<AnimatedListState>();

    // pvListofList.add(PVListofList(
    //   orderTypeId: _addSecRes!.orderTypes![orderTypeInex!].id ?? '',
    //   orderTypeName: _addSecRes!.orderTypes![orderTypeInex!].value ?? '',
    //   pVList: <PPVarient>[
    //     PPVarient(
    //       nameCltr: TextEditingController(text: LN.regular),
    //       priceCltr: TextEditingController(),
    //       stockCountCltr: TextEditingController(),
    //       minSACountCltr: TextEditingController(),
    //       maxSACountCltr: TextEditingController(),
    //       caloryCltr: TextEditingController(),
    //       discountCLtr: TextEditingController(),
    //       isDefault: true,
    //     )
    //   ],
    // ));
    // print(pvListofList[0].orderTypeName);

    // }
    // List.generate(_addSecRes!.orderTypes!.length, (index) {
    //   pvListofList.add(PVListofList(
    //     orderTypeId: _addSecRes!.orderTypes![index].id ?? '',
    //     pVList: <PPVarient>[],
    //   ));
    //   listKey.add(GlobalKey<AnimatedListState>());
    // });
    // }
  }

  List<String> findDeletedProductVariantSpicesId() {
    deletedProductVariantSpicesId = [];
    for (final a in ppvList) {
      for (final b in a.spices) {
        if (b.isSelected == false && b.additionalValue != null) {
          deletedProductVariantSpicesId?.add(b.additionalValue!);
        }
      }
    }
    return deletedProductVariantSpicesId ?? [];
  }

  Future<void> addProduct({
    ScrollController? scrollController,
    dynamic Function(bool)? onPopMsg,
    dynamic Function()? onBack,
  }) async {
    loading = true;
    notify;

    final reqData = ProductDataReq()
      ..id = editData == null ? "" : editData!.id
      ..name = nameCltr.text
      ..slug = slugCltr.text
      ..code = codeCltr.text
      // ..description = ""
      ..description = descriptionText
      ..allergens = allergenCltr.text
      ..deletedProductMacrosIds = deletedProductMacrosId
      ..deletedProductBatchIds = deletedProductBatchesId
      ..deletedProductVariationSuppliersIds = deletedProductSuppliersId
      ..deletedServiceItemsIds = deletedServiceTypeId
      ..deletedProductVariationIngredientsIds = deletedRawIngreId
      ..deletedProductVariationSpiceChoicesIds =
          findDeletedProductVariantSpicesId()
      // ..deletedProductLabelsIds = deletedProductLabelsId

      // ..deletedProductVariationsIds = deletedProductVariantsId
      ..isActive = activateStatus
      ..enablePriceRange = enablePriceRange
      ..priceRange = priceRangeCtrl.text
      ..estimatedTimeRange = estimateTimeRangeCltr.text
      ..enableTimeRange = enableEstTime;

    if (addSecRes != null) {
      // if (_addSecRes!.productCategories != null &&
      //     _addSecRes!.productCategories!.isNotEmpty &&
      //     catIndex != null)
      reqData.productCategoryId = selectedCatId;
      // _addSecRes!.productCategories![catIndex!].categoryId;

      // _reqData.brandId = selectedBrandId;

      if (addSecRes!.brands != null &&
          addSecRes!.brands!.isNotEmpty &&
          brandIndex != null)
        reqData.brandId = addSecRes!.brands![brandIndex!].id;

      if ((addSecRes?.productTypes?.isNotEmpty ?? false) &&
          productTypeIndex != null) {
        reqData.productTypeId = addSecRes!.productTypes![productTypeIndex!].id;
      }

      if ((addSecRes?.productPriceTypes?.isNotEmpty ?? false) &&
          pPriceTypeIndex != null) {
        reqData.productPriceTypeId =
            addSecRes!.productPriceTypes![pPriceTypeIndex!].id;
      }

      // if (addSecRes!.taxInclusiveExclusive != null &&
      //     addSecRes!.taxInclusiveExclusive!.isNotEmpty &&
      //     taxIndex != null)
      //   _reqData.taxExclusiveInclusiveId =
      //       addSecRes!.taxInclusiveExclusive![taxIndex!].id;

      if (addSecRes!.salesTaxes != null &&
          addSecRes!.salesTaxes!.isNotEmpty &&
          salesTaxIndex != null)
        reqData.salesTaxId = addSecRes!.salesTaxes![salesTaxIndex!].id;

      if (addSecRes!.purchaseTaxes != null &&
          addSecRes!.purchaseTaxes!.isNotEmpty &&
          purchaseTaxIndex != null)
        reqData.purchaseTaxId = addSecRes!.purchaseTaxes![purchaseTaxIndex!].id;

      // if (addSecRes!.suppliers != null &&
      //     addSecRes!.suppliers!.isNotEmpty &&
      //     supplierIndex != null)
      //   reqData.supplierId = addSecRes!.suppliers![supplierIndex!].id;

      if (addSecRes!.docketGroups != null &&
          addSecRes!.docketGroups!.isNotEmpty &&
          docketGroupIndex != null)
        reqData.docketGroupId = addSecRes!.docketGroups![docketGroupIndex!].id;

      // if (addSecRes!.barCodeTypes != null &&
      //     addSecRes!.barCodeTypes!.isNotEmpty &&
      //     barCodeIndex != null)
      //   _reqData.barCodeTypeStoreId =
      //       addSecRes!.barCodeTypes![barCodeIndex!].id;

      // _reqData.channelId = _addSecRes!.channelWithOrderTypes![channelIndex].id;
    }
    // _reqData.orderTypeProductPriceWithVariations ??=
    //     <OrderTypeProductPriceWithVariation>[];
    reqData.productVariations ??= [];
    var newPPVList = ppvList;
    for (var a in newPPVList) {
      a.batches.removeWhere((element) =>
          (element.stockCountCltr.text.isEmpty ||
              element.stockCountCltr.text == "") &&
          (element.batchNoCltr.text.isEmpty || element.batchNoCltr.text == ""));
      a.suppliers.removeWhere((e) =>
          (e.codeCltr.text.isEmpty || e.codeCltr.text == "") &&
          e.supplierIndex == null);

      final selectedSpices = a.spices
          .map((spice) => ModifierRawSpiceItem(
                id: spice.id ?? "",
                name: spice.name,
                isActive: spice.isSelected ?? false,
                rawIngredientId: "",
              ))
          .toList();

      final _spiceChoiceGroupId = (a.spices.isNotEmpty &&
              (a.spices.first.additionalValue?.toString().isNotEmpty ?? false))
          ? (a.spices.first.additionalValue?.toString() ?? '')
          : (addSecRes?.spiceChoiceModifierGroup?.id ?? '');

      final _rawIngreGroupId = a.rawIngre.isNotEmpty &&
              (a.rawIngre.first.rootId?.isNotEmpty ?? false)
          ? (a.rawIngre.first.rootId ?? '')
          : (addSecRes?.rawIngredientModifierGroup?.id ?? '');

      reqData.productVariations!.add(InventoryProductVariation(
          id: a.id,
          productVariationSpiceChoiceModifierGroup:
              GlobalCVP.isHospitality && _spiceChoiceGroupId.isNotEmpty
                  ? ProductVariationSpiceChoiceModifierGroup(
                      id: _spiceChoiceGroupId,
                      modifierItems: selectedSpices,
                    )
                  : null,
          productVariationModifierGroups: editData?.productVariations
                      ?.any((z) => z.id?.toLowerCase() == a.id.toLowerCase()) ??
                  false
              ? editData?.productVariations
                  ?.firstWhere((z) => z.id?.toLowerCase() == a.id.toLowerCase())
                  .productVariationModifierGroups
              : [],
          batches: List.generate(a.batches.length, (index) {
            return ProductBatch(
              id: a.batches[index].id,
              batchNo: a.batches[index].batchNoCltr.text,
              expiryDate: a.batches[index].batchExpiryCltr.text,
              stock: a.batches[index].stockCountCltr.text,
              runningStock: a.batches[index].runningStockCltr?.text,
              additionalStock: a.batches[index].addStockCltr?.text,
            );
          }),
          productVariationSuppliers: List.generate(a.suppliers.length, (index) {
            return ProductVariationSupplier(
              id: a.suppliers[index].id,
              supplierId: ((addSecRes?.suppliers?.isNotEmpty ?? false) &&
                      a.suppliers[index].supplierIndex != null)
                  ? (addSecRes
                      ?.suppliers?[a.suppliers[index].supplierIndex!].id)
                  : '',
              supplierItemCode: a.suppliers[index].codeCltr.text,
            );
          }),
          serviceGender: a.serviceTypeDefault,
          productVariationRawIngredientModifierGroup:
              GlobalCVP.isHospitality && _rawIngreGroupId.isNotEmpty
                  ? ProductVariationRawIngredientModifierGroup(
                      id: _rawIngreGroupId,
                      modifierItems: List.generate(a.rawIngre.length, (index) {
                        return ModifierRawSpiceItem(
                          id: a.rawIngre[index].id,
                          name: a.rawIngre[index].nameCltr.text,
                          rawIngredientId: a.rawIngre[index].ingreIndex != null
                              ? (addSecRes
                                  ?.rawLooseIngredients?[
                                      a.rawIngre[index].ingreIndex!]
                                  .id)
                              : null,
                          isActive: a.rawIngre[index].status,
                          quantity: a.rawIngre[index].qtySmallCltr.text,
                        );
                      }))
                  : null,
          // productVariationServiceItems:
          //     List.generate(a.serviceType.length, (index) {
          //   return ProductVariationServiceItem(
          //     id: a.serviceType[index].id,
          //     name: a.serviceType[index].typeCltr.text,
          //   );
          // }),
          // productVariationPriceGroupModifiers:
          //     List.generate(a.modifiers.length, (index) {
          //   final _groupId = a.modifiers[index].modifierLabelIndex != null
          //       ? (addSecRes
          //           ?.productPriceModifierGroups?[
          //               a.modifiers[index].modifierLabelIndex!]
          //           .id)
          //       : "";

          //   final String? _groupName =
          //       a.modifiers[index].modifierLabelIndex != null
          //           ? (addSecRes
          //               ?.productPriceModifierGroups?[
          //                   a.modifiers[index].modifierLabelIndex!]
          //               .name)
          //           : "";

          //   return ProductVariationPriceGroupModifier(
          //     productPriceModifierGroupId: _groupId,
          //     productVariationPriceModifiers: List.generate(
          //         a.modifiers[index].modifierNameList.length, (i) {
          //       final _modiId =
          //           a.modifiers[index].modifierNameList[i].modifierNameIndex !=
          //                   null
          //               ? (addSecRes
          //                   ?.productPriceModifers?[a.modifiers[index]
          //                       .modifierNameList[i].modifierNameIndex!]
          //                   .id)
          //               : "";
          //       return ProductVariationPriceModifier(
          //         id: a.modifiers[index].modifierNameList[i].id,
          //         productPriceModifierId: _modiId,
          //         productPriceModifierGroupId: _groupId,
          //         labelName: _groupName,
          //         name: a.modifiers[index].modifierNameList[i].modifierNameCltr
          //             .text,
          //         price: a.modifiers[index].modifierNameList[i]
          //             .modifierPriceCltr.text,
          //         estimatedTime:
          //             a.modifiers[index].modifierNameList[i].estTimeCltr.text,
          //         isActive: a.modifiers[index].modifierNameList[i].status,
          //       );
          //     }),
          //   );
          // }),
          // price: a.priceCltr.text,
          name: a.nameCltr.text,
          stockCount: a.stockCountCltr.text,
          minimumStockAlertCount: a.minSACountCltr.text,
          maximumStockAlertCount: a.maxSACountCltr.text,
          calories: GlobalCVP.isServiceStore ? "" : a.caloryCltr.text,
          estimatedTime: GlobalCVP.isServiceStore ? a.caloryCltr.text : "",
          isDefault: a.isDefault,
          // discount: a.discountCLtr.text,
          unitPrice: a.unitPriceCltr.text,
          labelName: variationTitleCltr.text,
          code: a.codeCltr.text,
          barCodeNumber: a.barcodeCltr.text,
          sortOrder: a.sortOrderCltr.text.inDouble.round(),
          expiryDate: a.expiryDateCltr.text,
          isActive: a.isActive,
          productVariationChannelPrices:
              List.generate(a.channels.length, (index) {
            return ProductVariationChannelPrice(
              id: a.channels[index].id,
              channelId: a.channels[index].channelId,
              actualPrice: a.channels[index].sellingPriceCltr.text,
              discountPrice: a.channels[index].disPriceCltr.text,
              discountPercentage: a.channels[index].disPercentCltr.text,
              discountedPrice: a.channels[index].newSellingPriceCltr.text,
              isActive: a.channels[index].isActive,
              // variablePriceMode: a.channels[index].variablePriceMode,
            );
          })));
    }

    reqData.productFilterOptions ??= [];
    for (final f in pfilterOptionList) {
      reqData.productFilterOptions!.add(ProductFilterOptions(
        id: f.id,
        filterTypeId: f.filterTypeId,
        filterTypeOptionsId: f.filterTypeOptionsId,
        type: f.type,
      ));
    }

    // for (final a in pvListofList) {
    //   if (a.pVList.isNotEmpty)
    //     _reqData.orderTypeProductPriceWithVariations!
    //         .add(OrderTypeProductPriceWithVariation(
    //       id: a.id,
    //       orderTypeId: a.orderTypeId,
    //       orderTypeName: a.orderTypeName,
    //       isActive: activateStatus,
    //       productVariations: List<ProductVariation>.generate(
    //           a.pVList.length,
    //           (i) => ProductVariation(
    //                 id: a.pVList[i].id,
    //                 price: a.pVList[i].priceCltr.text,
    //                 name: a.pVList[i].nameCltr.text,
    //                 stockCount: a.pVList[i].stockCountCltr.text,
    //                 minimumStockAlertCount: a.pVList[i].minSACountCltr.text,
    //                 maximumStockAlertCount: a.pVList[i].maxSACountCltr.text,
    //                 calories: a.pVList[i].caloryCltr.text,
    //                 isDefault: a.pVList[i].isDefault,
    //                 discount: a.pVList[i].discountCLtr.text,
    //               )),
    //     ));
    // }
// product macros
    reqData.productMacros = <ProductMacro>[];

    for (final e in macroList) {
      reqData.productMacros!.add(ProductMacro(
        id: e.id,
        name: e.name.text,
        value: e.value.text,
      ));
    }

    reqData.productCustomDescriptions = <ProductCustomDescription>[];

    for (final e in labelList) {
      reqData.productCustomDescriptions!.add(ProductCustomDescription(
        labelName: e.titleCltr.text,
        isActive: e.isActive,
        descripiton: e.description,
        identifier: e.identCltr.text,
        sortOrder: int.tryParse(e.sortOrderCltr.text),
      ));
    }

    reqData.addOnProducts ??= <AddOnProduct>[];
    for (final a in adonList) {
      reqData.addOnProducts!.add(AddOnProduct(
        id: a.id,
        productId: a.productId,
        name: a.name,
      ));
    }

    reqData.isImageDeleted = getFilePath == null || getFilePath!.isEmpty;
    reqData.productImageFileName = '';
    reqData.imageUrl = editData?.imageUrl ?? '';

    if (getFilePath?.isNotEmpty ?? false) {
      if (!(getFilePath?.contains('https') ?? false)) {
        final _compressedFile =
            await ImageService.compressFileFors3(getFilePath!);
        final _imageUploadStatus = await Handler.uploadImageOnUrl(
            contentType: uploadImageS3Res?.contentType,
            url: uploadImageS3Res?.uploadUrl,
            filepath: _compressedFile);

        if (_imageUploadStatus ?? false) {
          reqData.productImageFileName = uploadImageS3Res?.fileName ?? '';
        }
      } else {
        reqData.productImageFileName = editData?.productImageFileName ?? '';
      }
    } else {
      reqData.productImageFileName = '';
    }

    final status = await Handler.addUpProducts(
      productDataReq: reqData,
      onPopMsg: onPopMsg,
    );
    loading = false;
    notify;
    if (status != null && status) {
      bool isEdit = editData?.id != null;
      clear();
      // getData();
      // productLoad = true;
      // notify;
      // getAllProducts(page: getPage);
      if (isEdit) {
        onBack?.call();
      } else {
        Future.delayed(Duration(milliseconds: 300), () {
          scrollController?.animateTo(
            0,
            duration: Duration(milliseconds: 700),
            curve: Curves.easeInOutCubic,
          );
        });
      }
    }
  }

  Future<void> getAdonSuggest({required String keyWord}) async {
    adonSuggestion = await Handler.getAllProductByStore(keyWord: keyWord);
    notify;
  }

  Future<void> deleteProdVariaton({required int index}) async {
    final data = SRDatum(
      id: ppvList[index].id,
      name: ppvList[index].nameCltr.text,
    );
    await Handler.deleteProductVarient(dataList: [data]);
  }

  void clear({bool init = false}) {
    nameCltr.clear();
    descriptionText = '';
    slugCltr.clear();
    allergenCltr.clear();
    selectedCatId = null;
    brandIndex = null;
    productTypeIndex = null;
    pPriceTypeIndex = null;
    // taxIndex = null;
    // supplierIndex = null;
    docketGroupIndex = null;
    // barCodeIndex = null;
    // channelIndex = 0;
    adonList.clear();
    adonTextCltr.clear();
    adonSuggestion = null;
    editData = null;
    htmlController = null;
    htmlController = HtmlEditorController();
    setFilepath = null;
    // orderTypeInex = null;
    codeCltr.text = addSecRes?.code ?? '';
    // taxIndex = 0;
    salesTaxIndex = 0;
    purchaseTaxIndex = 0;
    setChannel();
    deletedProductMacrosId = null;
    deletedProductLabelsId = null;
    deletedProductBatchesId = null;
    deletedProductSuppliersId = null;
    deletedServiceTypeId = null;
    deletedRawIngreId = null;
    // deletedProductVariantsId = null;
    macroList.clear();
    macroKey = GlobalKey<AnimatedListState>();

    labelList.clear();
    labelKey = GlobalKey<AnimatedListState>();

    batchKeyList.clear();
    batchKeyList.add(GlobalKey<AnimatedListState>());

    supplierKeyList.clear();
    supplierKeyList.add(GlobalKey<AnimatedListState>());
    modifierKeyList.clear();
    serviceTypeKeyList.clear();
    ingreKeyList.clear();
    ppvList.clear();
    brandList.clear();
    activateStatus = true;
    enablePriceRange = false;
    priceRangeCtrl.clear();
    estimateTimeRangeCltr.clear();
    enableEstTime = false;
    setData();
    clearExpand();
  }

  void addPVarient() {
    ppvList.add(PPVarient(
        spices: (addSecRes?.spiceChoices ?? [])
            .map(
                (e) => TableLocation.fromJson((e..isSelected = false).toJson()))
            .toList(),
        batches: <Batch>[
          Batch(
            id: '',
            stockCountCltr: TextEditingController(),
            batchExpiryCltr: TextEditingController(),
            batchNoCltr: TextEditingController(),
          )
        ],
        suppliers: <Supplier>[
          Supplier(
            id: '',
            codeCltr: TextEditingController(),
          )
        ],
        // modifiers: [],
        // serviceType: [],
        rawIngre: [],
        nameCltr: TextEditingController(
            // text: LN.regular
            ),
        // priceCltr: TextEditingController(),
        stockCountCltr: TextEditingController(),
        minSACountCltr: TextEditingController(),
        maxSACountCltr: TextEditingController(),
        caloryCltr: TextEditingController(),
        isDefault: ppvList.isEmpty,
        // discountCLtr: TextEditingController(),
        unitPriceCltr: TextEditingController(),
        codeCltr: TextEditingController(),
        barcodeCltr: TextEditingController(text: ''),
        expiryDateCltr: TextEditingController(),
        sortOrderCltr: TextEditingController(),
        channels: addSecRes?.channels == null
            ? []
            : List.generate(
                addSecRes!.channels!.length,
                (index) => PVChannelPrice(
                      channelId: addSecRes!.channels![index].id ?? '',
                      channelName: addSecRes!.channels![index].name ?? '',
                      // isActive: addSecRes!.channels![index].isSelected ?? false,
                      sellingPriceCltr: TextEditingController(text: '0.00'),
                      disPriceCltr: TextEditingController(),
                      disPercentCltr: TextEditingController(),
                      newSellingPriceCltr: TextEditingController(),
                    ))));
    listKey.currentState!
        .insertItem(ppvList.length - 1, duration: Duration(milliseconds: 400));
    batchKeyList.add(GlobalKey<AnimatedListState>());
    supplierKeyList.add(GlobalKey<AnimatedListState>());
    modifierKeyList.add(GlobalKey<AnimatedListState>());
    serviceTypeKeyList.add(GlobalKey<AnimatedListState>());
    ingreKeyList.add(GlobalKey<AnimatedListState>());
    // notifyListeners();
  }

  void removePVarient({
    required int j,
    required Widget Function(BuildContext, Animation<double>) builder,
  }) {
    // deletedProductVariantsId ??= <String>[];
    // deletedProductVariantsId!.add(ppvList[j].id);
    bool wasDefault = ppvList[j].isDefault;

    listKey.currentState!
        .removeItem(j, builder, duration: Duration(milliseconds: 400));
    ppvList.removeAt(j);

    if (wasDefault) {
      if (ppvList.isNotEmpty) {
        ppvList.first.isDefault = true;
      }
    }
    // notifyListeners();
  }

  // Macros

  void addMacros() {
    macroList.add(
        Macros(name: TextEditingController(), value: TextEditingController()));
    macroKey.currentState!.insertItem(macroList.length - 1,
        duration: Duration(milliseconds: 400));
  }

  void removeMacro({
    required int i,
    required Widget Function(BuildContext, Animation<double>) builder,
  }) {
    deletedProductMacrosId ??= <String>[];
    deletedProductMacrosId!.add(macroList[i].id);
    macroKey.currentState!
        .removeItem(i, builder, duration: Duration(milliseconds: 400));
    macroList.removeAt(i);
    // notifyListeners();
  }

  void addBatches(int vIndex) {
    ppvList[vIndex].batches.add(Batch(
        id: '',
        stockCountCltr: TextEditingController(),
        batchExpiryCltr: TextEditingController(),
        batchNoCltr: TextEditingController()));
    batchKeyList[vIndex].currentState?.insertItem(
        ppvList[vIndex].batches.length - 1,
        duration: Duration(milliseconds: 400));
    // notify;
  }

  void removeBatches(
      {required int batchIndex,
      required int variantIndex,
      required Widget Function(BuildContext, Animation<double>) builder}) {
    deletedProductBatchesId ??= <String>[];
    deletedProductBatchesId!.add(ppvList[variantIndex].batches[batchIndex].id);
    batchKeyList[variantIndex]
        .currentState!
        .removeItem(batchIndex, builder, duration: Duration(milliseconds: 400));
    ppvList[variantIndex].batches.removeAt(batchIndex);
    // notify;
  }

  List<String> findDeletedSpicesId(
    List<SelectedSpices>? originalSpices,
    List<SelectedSpices>? currentSpices,
  ) {
    if (originalSpices == null) return [];

    final deletedProductCategoryIds = <String>[];

    for (final originalCategory in originalSpices) {
      final matchingCategory = currentSpices?.firstWhere(
        (currentCategory) =>
            currentCategory.spiceChoiceId == originalCategory.spiceChoiceId,
        orElse: () => SelectedSpices(),
      );

      if (matchingCategory?.spiceChoiceId == null) {
        if (originalCategory.id != null) {
          deletedProductCategoryIds.add(originalCategory.id!);
        }
      }
    }

    return deletedProductCategoryIds;
  }

  void addSupplier(int vIndex) {
    ppvList[vIndex].suppliers.add(Supplier(
          id: '',
          codeCltr: TextEditingController(),
        ));
    supplierKeyList[vIndex].currentState?.insertItem(
        ppvList[vIndex].suppliers.length - 1,
        duration: Duration(milliseconds: 400));
    // notify;
  }

  void removeSupplier(
      {required int supIndex,
      required int variantIndex,
      required Widget Function(BuildContext, Animation<double>) builder}) {
    deletedProductSuppliersId ??= <String>[];
    deletedProductSuppliersId!
        .add(ppvList[variantIndex].suppliers[supIndex].id);
    supplierKeyList[variantIndex]
        .currentState!
        .removeItem(supIndex, builder, duration: Duration(milliseconds: 400));
    ppvList[variantIndex].suppliers.removeAt(supIndex);
    // notify;
  }

  //modifiers

  // void addModifier(int vIndex) {
  //   ppvList[vIndex].modifiers.add(Modifier(
  //         modifierNameList: [],
  //       ));
  //   modifierKeyList[vIndex].currentState?.insertItem(
  //       ppvList[vIndex].modifiers.length - 1,
  //       duration: Duration(milliseconds: 400));
  //   // notify;
  // }

  // void removeModifier(
  //     {required int modifierLabelIndex,
  //     required int variantIndex,
  //     required Widget Function(BuildContext, Animation<double>) builder}) {
  //   deletedProductModifiersId ??= <String>[];
  //   // final id = ppvList[variantIndex].modifiers[modifierLabelIndex];

  //   // deletedProductModifiersId!.add(id ?? '');
  //   modifierKeyList[variantIndex].currentState!.removeItem(
  //       modifierLabelIndex, builder,
  //       duration: Duration(milliseconds: 400));
  //   ppvList[variantIndex].modifiers.removeAt(modifierLabelIndex);
  //   // notify;
  // }

  //service Type

  // void addServiceType(int vIndex) {
  //   ppvList[vIndex].serviceType.add(ServiceType(
  //         typeCltr: TextEditingController(),
  //       ));
  //   serviceTypeKeyList[vIndex].currentState?.insertItem(
  //       ppvList[vIndex].serviceType.length - 1,
  //       duration: Duration(milliseconds: 400));
  //   // notify;
  // }

  // void removeServiceType({
  //   required int serviceIndex,
  //   required int variantIndex,
  //   required Widget Function(BuildContext, Animation<double>) builder,
  // }) {
  //   deletedServiceTypeId ??= <String>[];
  //   deletedServiceTypeId!
  //       .add(ppvList[variantIndex].serviceType[serviceIndex].id);
  //   serviceTypeKeyList[variantIndex].currentState!.removeItem(
  //       serviceIndex, builder,
  //       duration: Duration(milliseconds: 400));
  //   ppvList[variantIndex].serviceType.removeAt(serviceIndex);
  // }

  //raw ingredients

  void addRawIngre(int vIndex) {
    ppvList[vIndex].rawIngre.add(RawIngre(
          nameCltr: TextEditingController(),
          qtySmallCltr: TextEditingController(),
          qtyLargeCltr: TextEditingController(),
        ));
    ingreKeyList[vIndex].currentState?.insertItem(
        ppvList[vIndex].rawIngre.length - 1,
        duration: Duration(milliseconds: 400));
    // notify;
  }

  void removeRawIngre({
    required int ingreIndex,
    required int variantIndex,
    required Widget Function(BuildContext, Animation<double>) builder,
  }) {
    deletedRawIngreId ??= <String>[];
    deletedRawIngreId!.add(ppvList[variantIndex].rawIngre[ingreIndex].id);
    ingreKeyList[variantIndex]
        .currentState!
        .removeItem(ingreIndex, builder, duration: Duration(milliseconds: 400));
    ppvList[variantIndex].rawIngre.removeAt(ingreIndex);
  }

  //Labels

  void addLabel() {
    labelList.add(LabelModel(
      titleCltr: TextEditingController(),
      htmlCltr: HtmlEditorController(),
      sortOrderCltr: TextEditingController(),
      identCltr: TextEditingController(),
    ));
    labelKey.currentState!.insertItem(labelList.length - 1,
        duration: Duration(milliseconds: 400));
  }

  void removeLabel({
    required int i,
    required Widget Function(BuildContext, Animation<double>) builder,
  }) {
    deletedProductLabelsId ??= <String>[];
    deletedProductLabelsId!.add(labelList[i].id);
    labelKey.currentState!
        .removeItem(i, builder, duration: Duration(milliseconds: 400));
    labelList.removeAt(i);
    // notifyListeners();
  }

  //file picker section
  String? _filePath;
  String? get getFilePath => _filePath;

  set setFilepath(String? val) {
    _filePath = val;
  }

  void getFilePick() async {
    final _hasImage = (getFilePath != null && getFilePath!.isNotEmpty) ||
        (editData?.imageUrl != null && editData!.imageUrl!.isNotEmpty);

    final file = await ImageService.filePick(showRemoveTile: _hasImage);
    if (file != null) {
      uploadImage();
      setFilepath = file;
      notify;
    }
  }

  int _pageIndex = 1;
  static const int _pageSize = 21;

  int get getPage => _pageIndex;

  set setPage(int val) {
    _pageIndex = val;
  }

  // recently added product list

  final searchProdCltr = TextEditingController();
  // int? orderTypeRecentIndex;
  bool productLoad = true;

  // final refreshCltr = RefreshController(initialRefresh: false);
  int _totalPage = 0;

  final productList = <ProductData>[];

  void clearRecentAddSec() {
    selectedCatId = null;
    searchProdCltr.clear();
    notify;
  }

  Future<void> getAllProducts({int page = 1}) async {
    // String _orderTypeId = "";
    String catId = "";
    // if (orderTypeRecentIndex != null && addSecRes?.orderTypes != null) {
    //   _orderTypeId = addSecRes!.orderTypes![orderTypeRecentIndex!].id ?? '';
    // }

    if (selectedCatId != null) {
      catId = selectedCatId ?? '';
    }
    if (page == 1 || _pageIndex * _pageSize < _totalPage) {
      setPage = page;
      final getAllProductRes = await Handler.getAllProducts(
        page: page,
        searchKey: searchProdCltr.text,
        // orderTypeId: _orderTypeId,
        pageSize: _pageSize,
        categoryId: catId,
      );

      if (page == 1) {
        productList.clear();
      }

      if (getAllProductRes?.data != null) {
        _totalPage = getAllProductRes?.total ?? 0;
        productList.addAll(getAllProductRes!.data!);
      }
    }
    productLoad = false;

    // refreshCltr.loadComplete();
    // refreshCltr.refreshCompleted();
    notify;
  }

  Future<void> deleteData({required List<SRDatum> dataList}) async {
    final status = await Handler.deleteProducts(dataList: dataList);
    if (status != null && status) {
      for (var e in dataList) {
        if (productList.any((f) => e.id == f.id))
          productList.removeWhere((f) => e.id == f.id);
      }
    }
  }

  Future<void> deactivateData({required List<SRDatum> dataList}) async {
    final status = await Handler.deactivateProducts(dataList: dataList);
    if (status != null && status) {
      getAllProducts(page: getPage);
    }
  }

  bool isMultipleSelected = false;
  final selectedProduct = <String>[];

  void get notify => notifyListeners();

  /// [Product_Price_Update]

  bool priceLoad = true;

  List<EditPriceRes>? priceData;

  Future<void> editProductPrice({required String productId}) async {
    priceData = await Handler.editProdPrice(pId: productId);
    priceLoad = false;
    notify;
  }

  bool updatePriceLoad = false;

  Future<bool?> updateProductPrice() async {
    if (priceData == null) return false;
    updatePriceLoad = true;
    notify;
    final status = await Handler.updateProdPrice(editedPrice: priceData!);
    updatePriceLoad = false;
    notify;
    return status;
  }

  bool batchExpand = true;
  Function()? batchExFun;

  bool modifierExpand = true;
  Function()? modifierExFun;

  // bool serviceTypeExpand = true;
  // Function()? serviceTypeExFun;

  bool ingreExpand = true;
  Function()? ingreExFun;

  bool supplierExpand = true;
  Function()? supExFun;

  void clearExpand() {
    batchExpand = true;
    batchExFun = null;
    modifierExpand = true;
    modifierExFun = null;
    // serviceTypeExpand = true;
    // serviceTypeExFun = null;
    supplierExpand = true;
    supExFun = null;
    ingreExpand = true;
    ingreExFun = null;
  }

  UploadImageS3Res? uploadImageS3Res;

  Future<void> uploadImage() async {
    uploadImageS3Res = await Handler.uploadUrls3(
      fileName: "ProductImages",
      identifier: "product-image",
    );
  }
}

// class PVListofList {
//   String id;
//   final String? orderTypeId;
//   String orderTypeName;
//   final List<PPVarient> pVList;

//   PVListofList({
//     this.id = "",
//     this.orderTypeId,
//     this.orderTypeName = "",
//     required this.pVList,
//   });
// }

///[Product_Price_Varient]

class PPVarient {
  final List<Batch> batches;
  final List<Supplier> suppliers;
  final List<TableLocation> spices;
  final String id;
  final TextEditingController nameCltr;
  // final TextEditingController priceCltr;
  final TextEditingController stockCountCltr;
  final TextEditingController unitPriceCltr;
  final TextEditingController minSACountCltr; //minimum stock alert count
  final TextEditingController maxSACountCltr; //maximun stock alert count
  final TextEditingController
      caloryCltr; // calory will use as estimate time for service store
  bool isDefault;
  // final TextEditingController discountCLtr;
  final TextEditingController codeCltr;
  final TextEditingController barcodeCltr;
  final TextEditingController expiryDateCltr;
  final TextEditingController sortOrderCltr;
  final List<PVChannelPrice> channels;
  bool isActive;
  // final List<Modifier> modifiers;
  String? serviceTypeDefault;
  // final List<ServiceType> serviceType;
  final List<RawIngre> rawIngre;

  PPVarient({
    this.id = "",
    required this.nameCltr,
    // required this.priceCltr,
    required this.stockCountCltr,
    required this.unitPriceCltr,
    required this.minSACountCltr,
    required this.maxSACountCltr,
    required this.caloryCltr,
    this.isDefault = false,
    // required this.discountCLtr,
    required this.codeCltr,
    required this.barcodeCltr,
    required this.expiryDateCltr,
    required this.sortOrderCltr,
    required this.channels,
    this.batches = const [],
    this.suppliers = const [],
    this.isActive = false,
    // this.modifiers = const [],
    this.serviceTypeDefault,
    // this.serviceType = const [],
    this.spices = const [],
    this.rawIngre = const [],
  });
}

class PVChannelPrice {
  String id;
  String channelId;
  String channelName;
  bool isActive;
  // bool variablePriceMode;
  final TextEditingController sellingPriceCltr;
  final TextEditingController disPriceCltr;
  final TextEditingController disPercentCltr;
  final TextEditingController newSellingPriceCltr;

  PVChannelPrice({
    this.id = "",
    this.channelId = "",
    this.channelName = "",
    this.isActive = true,
    required this.sellingPriceCltr,
    // this.variablePriceMode = false,
    required this.disPriceCltr,
    required this.disPercentCltr,
    required this.newSellingPriceCltr,
  });
}

class Batch {
  final String id;
  final TextEditingController batchNoCltr;
  final TextEditingController stockCountCltr;
  final TextEditingController batchExpiryCltr;
  final TextEditingController? runningStockCltr;
  final TextEditingController? addStockCltr;
  final bool? isEdit;

  Batch({
    this.id = "",
    this.isEdit = false,
    required this.stockCountCltr,
    required this.batchExpiryCltr,
    required this.batchNoCltr,
    this.runningStockCltr,
    this.addStockCltr,
  });
}

class Supplier {
  String id;
  int? supplierIndex;
  final TextEditingController codeCltr;

  Supplier({
    this.id = "",
    this.supplierIndex,
    required this.codeCltr,
  });
}

class ServiceType {
  final String id;
  final TextEditingController typeCltr;

  ServiceType({
    this.id = "",
    required this.typeCltr,
  });
}

class RawIngre {
  final String id;
  int? ingreIndex;
  final TextEditingController nameCltr;
  final TextEditingController qtySmallCltr;
  final TextEditingController qtyLargeCltr;
  bool status;
  final String? rootId;

  RawIngre({
    this.id = "",
    this.ingreIndex,
    required this.nameCltr,
    required this.qtySmallCltr,
    required this.qtyLargeCltr,
    this.status = true,
    this.rootId,
  });
}

class Modifier {
  int? modifierLabelIndex;
  final List<ModifierName> modifierNameList;

  Modifier({
    this.modifierLabelIndex,
    this.modifierNameList = const [],
  });
}

class ModifierName {
  final String id;
  int? modifierNameIndex;
  final TextEditingController modifierNameCltr;
  final TextEditingController modifierPriceCltr;
  final TextEditingController estTimeCltr;
  bool status;

  ModifierName({
    this.id = "",
    this.modifierNameIndex,
    required this.modifierNameCltr,
    required this.modifierPriceCltr,
    required this.estTimeCltr,
    this.status = false,
  });
}

class Macros {
  final String id;
  final TextEditingController name;
  final TextEditingController value;

  Macros({
    this.id = "",
    required this.name,
    required this.value,
  });
}

class AdonsModel {
  final String id;
  final String productId;
  final String name;

  AdonsModel({
    this.id = "",
    this.productId = "",
    this.name = "",
  });
}

class LabelModel {
  final String id;
  final TextEditingController titleCltr;
  final HtmlEditorController htmlCltr;
  String? description;
  final TextEditingController sortOrderCltr;
  final TextEditingController identCltr;
  bool isActive;

  LabelModel({
    this.id = "",
    required this.titleCltr,
    required this.htmlCltr,
    this.description,
    required this.sortOrderCltr,
    required this.identCltr,
    this.isActive = true,
  });
}

class SelectedSpices {
  String? id;
  String? spiceChoiceId;
  int? vIndex;

  SelectedSpices({
    this.id,
    this.spiceChoiceId,
    this.vIndex,
  });

  factory SelectedSpices.fromJson(Map<String, dynamic> json) => SelectedSpices(
        id: json["id"],
        spiceChoiceId: json["spiceChoiceId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "spiceChoiceId": spiceChoiceId,
      };
}
