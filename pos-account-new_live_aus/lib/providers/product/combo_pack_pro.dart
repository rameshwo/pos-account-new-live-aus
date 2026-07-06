import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:pos_account/config/utils/order_utils.dart';
import 'package:pos_account/model/common/category.dart';
import 'package:pos_account/model/home/product/combo/combo_add_sec.dart';
import 'package:pos_account/model/home/product/combo/combo_pack_res.dart';
import 'package:pos_account/model/home/product/combo/create_combo_req.dart';
import 'package:pos_account/model/home/setting/pos_device/printer_product/printer_prod_detail_res.dart';
import 'package:pos_account/repository/handler.dart';
import 'package:pos_account/services/image/image_service.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ComboPackPro extends ChangeNotifier {
  void get notify => notifyListeners();

  bool loading = true;
  final refreshCltr = RefreshController(initialRefresh: false);
  int _totalPage = 0;
  static const int _pageSize = 10;
  int pageIndex = 1;
  final searchCltr = TextEditingController();
  final comboList = <ComboPackData>[];

  Future<void> getAllCombo({int page = 1}) async {
    if (page == 1 || pageIndex * _pageSize < _totalPage) {
      pageIndex = page;
      final _res = await Handler.getAllComboPack(
        page: page,
        pageSize: _pageSize,
        searchKey: searchCltr.text,
      );

      if (page == 1) {
        comboList.clear();
      }

      if (_res?.data != null) {
        _totalPage = _res?.total ?? 0;
        comboList.addAll(_res!.data!);
      }
    }

    loading = false;
    refreshCltr.loadComplete();
    refreshCltr.refreshCompleted();
    notify;
  }

  bool createPageLoad = true;

  //create-update combo
  final codeCltr = TextEditingController();
  final nameCltr = TextEditingController();
  final categoryList = <Category>[];
  String? selectedCatId;
  bool status = true;
  bool enableAutoCartDetection = true;
  int? salesTaxIndex = 0;
  final barcodeCltr = TextEditingController();
  final slugCltr = TextEditingController();
  final linkCltr = TextEditingController();
  final caloryCltr = TextEditingController();
  String? filePath;
  HtmlEditorController? htmlController;
  String descriptionText = '';
  final channelPriceList = <ComboPriceModel>[];
  final comboGroupList = <ComboGroupModel>[];
  int? productPriceTypeIndex;

  ComboAddSec? comboAddSec;

  Future<void> getAddSec() async {
    comboAddSec = await Handler.getComboAddSec();
    setData();
    createPageLoad = false;
    notify;
  }

  void setData() {
    if (comboAddSec == null) return;

    codeCltr.text = comboAddSec!.code ?? '';

    if (comboAddSec?.salesTaxes != null &&
        comboAddSec!.salesTaxes!.any((e) => (e.isSelected ?? false))) {
      salesTaxIndex =
          comboAddSec!.salesTaxes!.indexWhere((e) => (e.isSelected ?? false));
    }

    if (comboAddSec?.productPriceTypes != null &&
        comboAddSec!.productPriceTypes!.any((e) => (e.isSelected ?? false))) {
      productPriceTypeIndex = comboAddSec!.productPriceTypes!
          .indexWhere((e) => (e.isSelected ?? false));
    }

    categoryList.clear();

    if (comboAddSec?.filterCategories != null) {
      categoryList
          .addAll(OrderUtils.getCatList(comboAddSec!.filterCategories!) ?? []);
    }

    if (comboAddSec!.channels != null)
      for (final a in comboAddSec!.channels!) {
        channelPriceList.add(
          ComboPriceModel(
            channelId: a.id ?? '',
            channelName: a.name ?? '',
            isActive: true,
            disPercentCltr: TextEditingController(),
            disPriceCltr: TextEditingController(),
            newSellingPriceCltr: TextEditingController(),
            sellingPriceCltr: TextEditingController(),
          ),
        );
      }

    comboGroupList.clear();

    comboGroupList.add(ComboGroupModel(
        maxThQtyCltr: TextEditingController(), productList: []));

    if (editData != null) setEditData();
  }

  void getFilePick() async {
    final _file = await ImageService.filePick(
        showRemoveTile: filePath != null &&
            filePath!.isNotEmpty &&
            editData?.imagePath != null &&
            editData!.imagePath!.isNotEmpty);
    if (_file != null) {
      filePath = _file;
      notify;
    }
  }

// combo group model

  void addComboGroup() {
    comboGroupList.add(ComboGroupModel(
        maxThQtyCltr: TextEditingController(), productList: []));
    notify;
  }

  // combo add update

  bool btnLoad = false;

  Future<bool> addUpCombo({
    dynamic Function(bool)? onPopMsg,
  }) async {
    final _req = CreateUpComboReq()
      ..id = editData == null ? "" : editData!.id
      ..code = codeCltr.text
      ..name = nameCltr.text
      ..productCategoryId = selectedCatId
      ..barcodeNumber = barcodeCltr.text
      ..slug = slugCltr.text
      ..link = linkCltr.text
      ..calories = caloryCltr.text
      ..isActive = status
      ..enableAutoCartDetection = enableAutoCartDetection
      ..description = descriptionText;

    if (comboAddSec!.salesTaxes != null &&
        comboAddSec!.salesTaxes!.isNotEmpty &&
        salesTaxIndex != null)
      _req.salesTaxId = comboAddSec!.salesTaxes![salesTaxIndex!].id;

    if ((comboAddSec?.productPriceTypes?.isNotEmpty ?? false) &&
        productPriceTypeIndex != null)
      _req.productPriceTypeId =
          comboAddSec!.productPriceTypes![productPriceTypeIndex!].id;

    _req.dealChannelPrices = List.generate(
      channelPriceList.length,
      (index) => DealChannelPrice(
        id: channelPriceList[index].id,
        channelId: channelPriceList[index].channelId,
        // channel: channelPriceList[index].channelName,
        actualPrice: channelPriceList[index].sellingPriceCltr.text,
        discountPrice: channelPriceList[index].disPriceCltr.text,
        discountPercentage: channelPriceList[index].disPercentCltr.text,
        discountedPrice: channelPriceList[index].newSellingPriceCltr.text,
        isActive: channelPriceList[index].isActive,
      ),
    );

    _req.dealModifiers = List.generate(
        comboGroupList.length,
        (i) => DealModifier(
              id: comboGroupList[i].id,
              modifierGroupId:
                  (comboAddSec?.modifierGroups?.isNotEmpty ?? false) &&
                          comboGroupList[i].groupIndex != null
                      ? comboAddSec!
                          .modifierGroups![comboGroupList[i].groupIndex!].id
                      : "",
              selectionTypeId:
                  (comboAddSec?.modifierGroups?.isNotEmpty ?? false) &&
                          comboGroupList[i].typeIndex != null
                      ? comboAddSec!
                          .selectionTypes![comboGroupList[i].typeIndex!].id
                      : "",
              maxThresholdQuantity: comboGroupList[i].maxThQtyCltr.text,
              isActive: true,
              modifierItems: List.generate(
                  comboGroupList[i].productList.length,
                  (j) => ModifierItem(
                        id: comboGroupList[i].productList[j].id,
                        name: comboGroupList[i].productList[j].name,
                        productVariationId:
                            comboGroupList[i].productList[j].productId,
                        // maxThresholdQuantity: "1",
                        isActive: comboGroupList[i].productList[j].isActive,
                        isRequired: comboGroupList[i].productList[j].isReq,
                        availableQuantity:
                            comboGroupList[i].productList[j].qtyCltr?.text,
                        additionalPrice:
                            comboGroupList[i].productList[j].priceCltr?.text,
                      )),
              isRequired: comboGroupList[i].isRequired,
            ));

    createPageLoad = true;
    btnLoad = true;
    notify;

    final _status = await Handler.createUpComboReq(
      req: _req,
      imagePath:
          (filePath != null && filePath!.contains('http')) ? null : filePath,
      onPopMsg: onPopMsg,
    );

    createPageLoad = false;
    btnLoad = false;
    notify;

    return _status ?? false;
  }

  CreateUpComboReq? editData;

  Future<bool> getEditData({
    required String id,
  }) async {
    loading = true;
    createPageLoad = true;
    notify;
    editData = await Handler.editComboPack(id: id);
    // setEditData();
    if (editData == null) createPageLoad = false;
    loading = false;
    notify;

    return editData != null;
  }

  void setEditData() {
    if (comboAddSec == null || editData == null) return;

    codeCltr.text = editData!.code ?? '';
    nameCltr.text = editData!.name ?? '';

    selectedCatId = editData!.productCategoryId;
    status = editData!.isActive ?? false;
    enableAutoCartDetection = editData?.enableAutoCartDetection ?? false;

    if (comboAddSec?.salesTaxes != null &&
        comboAddSec!.salesTaxes!.any((e) =>
            e.id?.toLowerCase() == editData?.salesTaxId?.toLowerCase())) {
      salesTaxIndex = comboAddSec!.salesTaxes!.indexWhere(
          (e) => e.id?.toLowerCase() == editData?.salesTaxId?.toLowerCase());
    }

    if (comboAddSec?.productPriceTypes != null &&
        comboAddSec!.productPriceTypes!.any((e) =>
            e.id?.toLowerCase() ==
            editData?.productPriceTypeId?.toLowerCase())) {
      productPriceTypeIndex = comboAddSec!.productPriceTypes!.indexWhere((e) =>
          e.id?.toLowerCase() == editData?.productPriceTypeId?.toLowerCase());
    }
    barcodeCltr.text = editData!.barcodeNumber ?? '';
    slugCltr.text = editData!.slug ?? '';
    linkCltr.text = editData!.link ?? '';
    caloryCltr.text = editData!.calories ?? '';
    filePath = editData!.imagePath;
    descriptionText = editData!.description ?? '';

    if (editData!.dealChannelPrices != null)
      for (final e in editData!.dealChannelPrices!) {
        if (channelPriceList.any(
            (a) => a.channelId.toLowerCase() == e.channelId?.toLowerCase())) {
          final _channel = channelPriceList.firstWhere(
              (b) => b.channelId.toLowerCase() == e.channelId?.toLowerCase());
          _channel.id = e.id ?? '';
          // _channel.channelId = e.channelId ?? '';
          // _channel.channelName = e.channel ?? '';
          _channel.isActive = e.isActive ?? false;
          _channel.disPercentCltr.text = e.discountPercentage ?? '';
          _channel.disPriceCltr.text = e.discountPrice ?? '';
          _channel.newSellingPriceCltr.text = e.discountedPrice ?? '';
          _channel.sellingPriceCltr.text = e.actualPrice ?? '';
        } else {
          channelPriceList.add(
            ComboPriceModel(
              id: e.id ?? '',
              channelId: e.channelId ?? '',
              // channelName: e.channel ?? '',
              isActive: e.isActive ?? false,
              disPercentCltr: TextEditingController(text: e.discountPercentage),
              disPriceCltr: TextEditingController(text: e.discountPrice),
              newSellingPriceCltr:
                  TextEditingController(text: e.discountedPrice),
              sellingPriceCltr: TextEditingController(text: e.actualPrice),
            ),
          );
        }
      }

    if (editData!.dealModifiers != null) {
      comboGroupList.clear();
      for (final e in editData!.dealModifiers!) {
        comboGroupList.add(ComboGroupModel(
          id: e.id ?? '',
          groupIndex: comboAddSec?.modifierGroups?.any((f) =>
                      f.id?.toLowerCase() ==
                      e.modifierGroupId?.toLowerCase()) ??
                  false
              ? comboAddSec?.modifierGroups?.indexWhere((f) =>
                  f.id?.toLowerCase() == e.modifierGroupId?.toLowerCase())
              : null,
          typeIndex: comboAddSec?.selectionTypes?.any((f) =>
                      f.id?.toLowerCase() ==
                      e.selectionTypeId?.toLowerCase()) ??
                  false
              ? comboAddSec?.selectionTypes?.indexWhere((f) =>
                  f.id?.toLowerCase() == e.selectionTypeId?.toLowerCase())
              : null,
          maxThQtyCltr: TextEditingController(text: e.maxThresholdQuantity),
          productList: e.modifierItems
                  ?.map((f) => ComboGroupProduct(
                        id: f.id ?? '',
                        productId: f.productVariationId ?? '',
                        name: f.name ?? '',
                        isActive: f.isActive ?? false,
                        // isSelected: f.isDefault ?? false,
                        qtyCltr: TextEditingController(
                            text: f.availableQuantity ?? ''),
                        priceCltr: TextEditingController(
                            text: f.additionalPrice ?? ''),
                        isReq: f.isRequired ?? false,
                        // catId: "",
                      ))
                  .toList() ??
              [],
          isRequired: e.isRequired ?? false,
        ));
      }
    }

    if (comboGroupList.isEmpty) {
      addComboGroup();
    }
  }

  Future<bool> deleteCombo({
    required String id,
    String? name,
  }) async {
    loading = true;
    notify;
    final _status = await Handler.deleteComboPack(id: id, name: name);
    loading = false;
    notify;

    return _status != null;
  }

  void clear({bool doAllClear = true}) {
    channelPriceList.clear();
    searchCltr.clear();
    codeCltr.clear();
    nameCltr.clear();
    selectedCatId = null;
    status = true;
    enableAutoCartDetection = true;
    salesTaxIndex = 0;
    productPriceTypeIndex = null;
    barcodeCltr.clear();
    slugCltr.clear();
    linkCltr.clear();
    caloryCltr.clear();
    filePath = null;
    htmlController = null;
    htmlController = HtmlEditorController();
    descriptionText = '';
    btnLoad = false;
    editData = null;

    if (doAllClear) {
      loading = true;
      comboList.clear();
      createPageLoad = true;
      categoryList.clear();
    } else {
      setData();
    }
  }
}

class ComboPriceModel {
  String id;
  String channelId;
  String channelName;
  bool isActive;
  // bool variablePriceMode;
  final TextEditingController sellingPriceCltr;
  final TextEditingController disPriceCltr;
  final TextEditingController disPercentCltr;
  final TextEditingController newSellingPriceCltr;

  ComboPriceModel({
    this.id = "",
    this.channelId = "",
    this.channelName = "",
    this.isActive = false,
    required this.sellingPriceCltr,
    // this.variablePriceMode = false,
    required this.disPriceCltr,
    required this.disPercentCltr,
    required this.newSellingPriceCltr,
  });
}

class ComboGroupModel {
  final String id;
  int? groupIndex;
  int? typeIndex;
  final TextEditingController maxThQtyCltr;
  List<ComboGroupProduct> productList;
  bool isRequired;

  ComboGroupModel({
    this.id = "",
    this.groupIndex,
    this.typeIndex,
    required this.maxThQtyCltr,
    this.productList = const [],
    this.isRequired = true,
  });
}
