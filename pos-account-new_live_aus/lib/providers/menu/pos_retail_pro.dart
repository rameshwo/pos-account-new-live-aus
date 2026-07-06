import 'package:flutter/material.dart';
import 'package:pos_account/config/utils/promo_utils.dart';
import 'package:pos_account/config/utils/order_utils.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/constant/strings.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/common/category.dart';
import 'package:pos_account/model/common/table_location.dart';
import 'package:pos_account/model/home/menu/place_order/pos_res/add_sec.dart';
import 'package:pos_account/model/home/menu/place_order/pos_res/pos_cat_res.dart';
import 'package:pos_account/model/home/menu/place_order/pos_res/pos_ingre_res.dart';
import 'package:pos_account/model/home/menu/place_order/retail_pos_res.dart';
import 'package:pos_account/model/home/menu/retail_pos/retail_pos_res.dart';
import 'package:pos_account/model/home/product/barcode/barcode_addsec.dart';
import 'package:pos_account/model/home/product/barcode/barcode_print_res.dart';
import 'package:pos_account/model/home/product/barcode/generate_barcode_req.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/menu/place_order_pro.dart';
import 'package:pos_account/repository/handler.dart';
import 'package:pos_account/repository/if_exception.dart';
import 'package:pos_account/services/database/database/db_local_data.dart';
import 'package:pos_account/services/database/shared_pref.dart';
import '../../model/home/menu/place_order/pos_res/com/feature_product.dart';
import '../../screens/home_screen/com/items/tabs/pos_tab/product_detail_dia.dart';

class PosRetailPro extends ChangeNotifier {
  void get notify => notifyListeners();

  // final HeaderTitles = <RetailTitle>[
  //   RetailTitle(title: LN.category, show: true),
  //   RetailTitle(title: LN.brand, show: true),
  //   RetailTitle(title: LN.product, show: true),
  //   RetailTitle(title: LN.code, show: true),
  //   // RetailTitle(title: LN.barcode, show: true),
  //   RetailTitle(title: LN.action, show: true),
  // ];

  // static List<String> get _headerList => [
  //       // "",
  //       LN.category, LN.brand, LN.product, LN.code, LN.action
  //     ];

  // final tableList = RTableData(
  //   headerList: [
  //     LN.category,
  //     LN.brand,
  //     LN.product,
  //     LN.code,
  //     // "Barcode",
  //     LN.action
  //   ],
  //   hasAction: false,
  //   showCheckBox: false,
  //   // hasActionButton: true,
  // );

  // bool _isOnPos = true;

  // void init({bool isOnPos = true}) {
  //   alphaId = "";
  //   // _isOnPos = isOnPos;
  //   // tableList.headerList =
  //   //     HeaderTitles.where((e) => e.show).map((f) => f.title).toList();
  // }

  // Future<void> checkStatus() async {
  //   final _status = await Handler.getPosChangeStatus();
  //   if (_status?.isDataChanged ?? false) {
  //     await getCats();
  //   }
  // }

  final _allCatwithProdData = <RetailProductRes>[];
  Map<String, ProductData>? _productMap;
  final _allProductData = <ProductData>[];
  final _rawIngreData = <RawLooseIngredientProduct>[];

  Future<FeaturedProduct?> getProductData(
    String? id, {
    required int orderTypeIndex,
  }) async {
    final _idLower = id?.toLowerCase();

    final _p = _allProductData.firstWhere(
      (e) => e.productId?.toLowerCase() == _idLower,
      orElse: () => ProductData(),
    );

    final _prodAsNew = _p.id != null
        ? (ProductData.fromJson(_p.toJson())
          ..parentCatId = _p.parentCatId
          ..promoModel = _p.promoModel)
        : null;

    if (_prodAsNew != null) {
      _setApplyDiscounts(
        _prodAsNew,
        'getProductData: promo empty',
      );

      final _var = ProductVariation(
        id: _prodAsNew.id,
        stockCount: _prodAsNew.stockCount,
        actualPrice: _prodAsNew.actualPrice,
        discountPercentage: _prodAsNew.discountPercentage,
        discountedPrice: _prodAsNew.discountedPrice,
        discount: _prodAsNew.discountPrice,
        unitPrice: _prodAsNew.unitPrice,
        quantity: _prodAsNew.quantity.toDouble(),
        isDefault: true,
        productVariationModifiers: _prodAsNew.comboProducts != null
            ? [
                ProductVariationModifier(
                    modifierItems: List.generate(
                        _prodAsNew.comboProducts!.length,
                        (index) => ModifierItem(
                              productName:
                                  _prodAsNew.comboProducts![index].name,
                              imageUrl:
                                  _prodAsNew.comboProducts![index].imageUrl,
                              isActive: true,
                            )))
              ]
            : [],
        promoModel: _prodAsNew.promoModel,
      );

      final _product = FeaturedProduct()
        ..id = _prodAsNew.productId
        ..categoryId = _prodAsNew.categoryId
        ..name = _prodAsNew.name
        ..salesTax = _prodAsNew.salesTax
        ..imageUrl = _prodAsNew.imageUrl
        ..quantity = _prodAsNew.quantity.toDouble()
        ..parentCatId = _prodAsNew.parentCatId
        ..productType = _prodAsNew.productType
        ..productVariations = [_var];

      return _product;
    }
    return null;
  }

  Future<void> getAllRetailProducts({bool isServerCall = false}) async {
    if (isServerCall) {
      await _getAllRetailProductsFromServer();
      return;
    }

    final _dbData = await DbLocalData.getAllRetailProducts();
    if (_dbData != null) {
      //set data
      _setAllProdData(_dbData);
      _getAllRetailProductsFromServer();
    } else {
      await _getAllRetailProductsFromServer();
    }
  }

  Future<void> _getAllRetailProductsFromServer() async {
    final _res = await Handler.getRetailPosOrderProduct();
    if (_res != null) {
      await DbLocalData.updateAllRetailProduct(data: _res);
      //setData
      _setAllProdData(_res);
    }
  }

  void _setAllProdData(List<RetailProductRes>? _allData) {
    if (_allData != null) {
      _allCatwithProdData.clear();
      _allProductData.clear();
      _rawIngreData.clear();
      _productMap = {};
      _allCatwithProdData.addAll(_allData);

      for (final a in _allData) {
        if (a.products?.isNotEmpty ?? false)
          for (final b in a.products!) {
            _allProductData.add(
              b
                ..parentCatId = a.id
                ..productType = a.type,
            );

            if (b.id != null) _productMap?.addAll({b.id!.toLowerCase(): b});
          }
        if (a.rawLooseProducts?.isNotEmpty ?? false)
          for (final c in a.rawLooseProducts!) {
            _rawIngreData.add(
              c
                ..parentCatId = a.id
                ..productType = a.type,
            );
          }
      }

      posCatRes = PosScreenCatRes(
        comboCategories: [],
        rawLooseCategories: [],
        productCategories: [],
      );

      for (final a in _allCatwithProdData) {
        final _catData = CategoryData(
          id: a.id,
          name: a.name,
          //  defaultBackGroundColor: a.defaultBackGroundColor,
          // defaultTextColor: a.defaultTextColor,
          // onFocusBackGroundColor: a.onFocusBackGroundColor,
          // onFocusTextColor: a.onFocusTextColor,
          type: a.type,
        );
        if (a.type == "Items")
          posCatRes?.productCategories
              ?.add(_catData..itemViewType = ItemViewType.product);
        else if (a.type == "ComboPacks")
          posCatRes?.comboCategories
              ?.add(_catData..itemViewType = ItemViewType.combo);
        else if (a.type == "RawLooseItems")
          posCatRes?.rawLooseCategories
              ?.add(_catData..itemViewType = ItemViewType.ingre);
      }
      // posCatRes = await Handler.getAllPosOrCats();

      // await getOrderAddSection();
      setOnPosRetailData();
    }
    setOnScreenPosData();
    notify;
  }

  void _setPromOnAllProducts(RetailProductRes res) {
    if (res.products != null)
      for (final a in res.products!) {
        _setApplyDiscounts(a, '_setPromOnAllProducts');
      }
  }

  PosScreenCatRes? posCatRes;
  ItemViewType itemViewType = ItemViewType.product;

  void setOnPosRetailData() {
    if (itemViewType == ItemViewType.ingre) {
      if (ingreViewList.isNotEmpty) {
        final _newList = <RawLooseIngredientProduct>[];
        for (final a in ingreViewList) {
          if (_rawIngreData
              .any((b) => b.id?.toLowerCase() == a.id?.toLowerCase())) {
            final _thatProd = _rawIngreData
                .firstWhere((b) => b.id?.toLowerCase() == a.id?.toLowerCase());

            final _product =
                RawLooseIngredientProduct.fromJson(_thatProd.toJson())
                  ..parentCatId = _thatProd.parentCatId
                  ..productType = _thatProd.productType;

            _newList.add(_product);
          }
        }
        ingreViewList.clear();
        ingreViewList.addAll(_newList);
        notify;
      }
    } else {
      if (itemViewList.isNotEmpty) {
        final _newList = <ProductData>[];
        for (final a in itemViewList) {
          if (_allProductData
              .any((b) => b.id?.toLowerCase() == a.id?.toLowerCase())) {
            final _thatProd = _allProductData
                .firstWhere((b) => b.id?.toLowerCase() == a.id?.toLowerCase());

            final _product = ProductData.fromJson(_thatProd.toJson())
              ..parentCatId = _thatProd.parentCatId
              ..productType = _thatProd.productType;

            _newList.add(_product);
          }
        }
        itemViewList.clear();
        itemViewList.addAll(_newList);
        notify;
      }
    }

    // order list

    if (placeOrderPro?.orderList.isNotEmpty ?? false) {
      for (int i = 0; i < placeOrderPro!.orderList.length; i++) {
        final a = placeOrderPro!.orderList[i];

        if ((a.id == null || a.id!.isEmpty) &&
            _allProductData.any((b) =>
                b.id?.toLowerCase() == a.productVariationId?.toLowerCase())) {
          final e = _allProductData.firstWhere((b) =>
              b.id?.toLowerCase() == a.productVariationId?.toLowerCase());

          final _var = ProductVariation(
              id: e.id,
              stockCount: e.stockCount,
              actualPrice: e.actualPrice,
              discountPercentage: e.discountPercentage,
              discountedPrice: e.discountedPrice,
              discount: e.discountPrice,
              unitPrice: e.unitPrice,
              quantity: a.quantity ?? 1.0,
              isDefault: true,
              productVariationModifiers: e.comboProducts != null
                  ? [
                      ProductVariationModifier(
                          modifierItems: List.generate(
                              e.comboProducts!.length,
                              (index) => ModifierItem(
                                    productName: e.comboProducts![index].name,
                                    imageUrl: e.comboProducts![index].imageUrl,
                                    isActive: true,
                                  )))
                    ]
                  : []);
          final _product = FeaturedProduct()
            ..id = e.productId
            ..categoryId = e.categoryId
            ..name = e.name
            ..salesTax = e.salesTax
            ..imageUrl = e.imageUrl
            ..quantity = a.quantity ?? 1.0
            ..parentCatId = e.parentCatId
            ..productType = e.productType
            ..productVariations = [_var];

          placeOrderPro!.updateOrderCart(
            product: _product,
            variation: _var,
            catId: _product.categoryId,
            orderDetailIndex: i,
            isVarianceUpdate: true,
            customPrice: a.customPrice,
          );
        }
      }
      notify;
    }

    // raw ingredients

    if (placeOrderPro?.ingreList.isNotEmpty ?? false) {
      for (int i = 0; i < placeOrderPro!.ingreList.length; i++) {
        final a = placeOrderPro!.ingreList[i];

        if (_rawIngreData.any(
            (b) => b.id?.toLowerCase() == a.rawIngredientId?.toLowerCase())) {
          final _thatProd = _rawIngreData.firstWhere(
              (b) => b.id?.toLowerCase() == a.rawIngredientId?.toLowerCase());

          final _rawIngre =
              RawLooseIngredientProduct.fromJson(_thatProd.toJson())
                ..parentCatId = _thatProd.parentCatId
                ..productType = _thatProd.productType;

          placeOrderPro!.updateRawCre(
            rawIngredient: _rawIngre,
            quantity: a.quantity ?? 1.0,
            cartIndex: i,
          );
        }
      }
      notify;
    }
  }

  Future<void> getOrderAddSection({required PlaceOrderPro placeOr}) async {
    retailPosOrderRes = RetailPosOrderRes.fromJson(GlobalCVP.allAddSection);
    // await Handler.getRetailPosOrder();

    GlobalCVP.setStoreInfo = retailPosOrderRes?.storeInformation;
    OrderUtils.statusList = retailPosOrderRes?.orderItemStatus;
    setUpData(placeOr: placeOr);
    //TODO
    // Utils.statusList = retailPosOrderRes?.orderItemStatus;
  }

  Future<RetailProductRes> _getRetailData({
    int page = 1,
    int pageSize = 10,
    String parentCatId = "",
    String subCatId = "",
    String searchKey = "",
    String alphaKey = "",
    String brandId = "",
    String promoId = "",
    ItemViewType itemViewType = ItemViewType.product,
  }) async {
    final _retailProductRes = RetailProductRes(
      id: parentCatId,
      type: itemViewType.name,
      subCategories: [],
      products: [],
      alphaList: [],
      rawLooseProducts: [],
    );

    if (_allProductData.isEmpty) {
      await getAllRetailProducts();
    }

    if (itemViewType == ItemViewType.ingre) {
      final _alphaList = _rawIngreData
          .where((product) => (parentCatId.isEmpty ||
              product.parentCatId?.toLowerCase() == parentCatId.toLowerCase()))
          .map((item) => (item.name?.trim().isNotEmpty ?? false)
              ? item.name!.trim()[0].toUpperCase()
              : '')
          .where((letter) => letter.isNotEmpty)
          .toSet()
          .toList()
        ..sort();

      _retailProductRes.alphaList = _alphaList;

      // Filter products by catId if provided
      final _filteredIngre = _rawIngreData.where((ingre) {
        final name = ingre.name?.trim().toLowerCase() ?? '';
        final parentId = ingre.parentCatId?.toLowerCase() ?? '';
        final _subCatId = ingre.categoryId?.toLowerCase() ?? '';

        final matchesParent =
            parentCatId.isEmpty || parentId == parentCatId.toLowerCase();

        final matchesSubCat =
            subCatId.isEmpty || _subCatId == subCatId.toLowerCase();
        final matchesSearch =
            searchKey.isEmpty || name.contains(searchKey.toLowerCase());
        final matchesAlpha = alphaKey.isEmpty ||
            (name.isNotEmpty && name[0] == alphaKey.toLowerCase());

        return matchesParent && matchesSearch && matchesAlpha && matchesSubCat;
      }).toList();
      // created new data so , there will be no change on orginal data structure
      final _newFilteredData = _filteredIngre
          .map((e) => RawLooseIngredientProduct.fromJson(e.toJson())
            ..parentCatId = e.parentCatId
            ..productType = e.productType)
          .toList();

      if (page <= 0) page = 1;

      final startIndex = (page - 1) * pageSize;
      final endIndex = startIndex + pageSize;

      for (int i = startIndex;
          i < endIndex && i < _newFilteredData.length;
          i++) {
        _retailProductRes.rawLooseProducts!.add(_newFilteredData[i]);
      }
    } else {
      final _alphaList = _allProductData
          .where((product) => (parentCatId.isEmpty ||
              product.parentCatId?.toLowerCase() == parentCatId.toLowerCase()))
          .map((item) => (item.name?.trim().isNotEmpty ?? false)
              ? item.name!.trim()[0].toUpperCase()
              : '')
          .where((letter) => letter.isNotEmpty)
          .toSet()
          .toList()
        ..sort();

      _retailProductRes.alphaList = _alphaList;

      // Filter products by catId if provided
      final _filteredProducts = _allProductData
          .where((product) =>
              (parentCatId.isEmpty ||
                  product.parentCatId?.toLowerCase() ==
                      parentCatId.toLowerCase()) &&
              (subCatId.isEmpty ||
                  product.categoryId?.toLowerCase() ==
                      subCatId.toLowerCase()) &&
              (brandId.isEmpty ||
                  product.brandId?.toLowerCase() == brandId.toLowerCase()) &&
              (searchKey.isEmpty ||
                  (product.name
                          ?.toLowerCase()
                          .contains(searchKey.toLowerCase()) ??
                      true) ||
                  (product.barcodeNumber
                          ?.toLowerCase()
                          .contains(searchKey.toLowerCase()) ??
                      false)) &&
              (alphaKey.isEmpty ||
                  ((product.name?.trim().isNotEmpty ?? false) &&
                      product.name?.trim()[0].toLowerCase() ==
                          alphaKey.toLowerCase())))
          .toList();

      // created new data so , there will be no change on orginal data structure

      final _newFilteredData = <ProductData>[];
      for (final e in _filteredProducts) {
        final clone = ProductData.fromJson(e.toJson())
          ..parentCatId = e.parentCatId
          ..productType = e.productType;

        // Promo filter

        if (promoId.isNotEmpty)
          _setApplyDiscounts(clone, '_getPosData: promo empty',
              promoId: promoId);

        if (promoId.isEmpty || clone.promoModel != null) {
          _newFilteredData.add(clone);
        }
      }

      if (page <= 0) page = 1;

      final startIndex = (page - 1) * pageSize;
      final endIndex = startIndex + pageSize;

      for (int i = startIndex;
          i < endIndex && i < _newFilteredData.length;
          i++) {
        _retailProductRes.products!.add(_newFilteredData[i]);
      }
    }
    if (parentCatId.isNotEmpty && subCatId.isEmpty) {
      final _subCatList = _allCatwithProdData
              .any((a) => a.id?.toLowerCase() == parentCatId.toLowerCase())
          ? (_allCatwithProdData
                  .firstWhere(
                      (a) => a.id?.toLowerCase() == parentCatId.toLowerCase())
                  .subCategories ??
              [])
          : <SubCategory>[];

      _retailProductRes.subCategories = _subCatList;
    }

    if (promoId.isEmpty) _setPromOnAllProducts(_retailProductRes);

    return _retailProductRes;
  }

  int pagiPage = 1;

  final searchCltr = TextEditingController();
  RetailPosOrderRes? retailPosOrderRes;
  // RetailPosOrderRes? _initPosRes;

  PlaceOrderPro? placeOrderPro;
  String selectedCatId = "";
  String selectedBrandId = "";

  final List<int> pageSizeList = [5, 10, 20, 50];
  int pageSizeIndex = 1;
  int pageIndex = 1;

  bool pageLoad = true;
  // String alphaId = "";
  final int _pageSize = 20;
  final itemViewList = <ProductData>[];
  final ingreViewList = <RawLooseIngredientProduct>[];
  List<SubCategory>? subCategoryList;
  int? selectedSubCatIndex;
  List<String>? alphaList;

  String? _subCatId;
  String? selectedAlpha;

  Future<void> getItemData({
    int page = 1,
    String searchKey = "",
    String? subCatId,
  }) async {
    if (page == 1) {
      _subCatId = subCatId;
      if (_subCatId == null) {
        subCategoryList = null;
      }
    }

    if (itemViewType == ItemViewType.ingre) {
      if (page == 1 || pageIndex * _pageSize <= ingreViewList.length) {
        pageIndex = page;
        final _res = await _getRetailData(
          page: page,
          pageSize: _pageSize,
          searchKey: searchKey,
          parentCatId: selectedCatId,
          subCatId: _subCatId ?? '',
          alphaKey: selectedAlpha ?? '',
          itemViewType: ItemViewType.ingre,
        );

        if (page == 1) {
          ingreViewList.clear();
          itemViewList.clear();
          alphaList = _res.alphaList;
          if (_subCatId == null) {
            subCategoryList = _res.subCategories;
            selectedSubCatIndex = null;
          }
        }

        if (_res.rawLooseProducts?.isNotEmpty ?? false) {
          ingreViewList.addAll(_res.rawLooseProducts!);
        }
      }
    } else {
      String brandId = selectedBrandId;

      if (page == 1 || pageIndex * _pageSize <= itemViewList.length) {
        pageIndex = page;
        final _res = await _getRetailData(
          page: page,
          pageSize: _pageSize,
          searchKey: searchKey,
          parentCatId: selectedCatId.contains(Strings.staticPromoId)
              ? ""
              : selectedCatId,
          subCatId: _subCatId ?? '',
          brandId: brandId,
          alphaKey: selectedAlpha ?? '',
          promoId: promoId ?? '',
        );

        if (page == 1) {
          itemViewList.clear();
          ingreViewList.clear();
          if (_subCatId == null) {
            subCategoryList = _res.subCategories;
            selectedSubCatIndex = null;
          }
          alphaList = _res.alphaList;
        }

        if (_res.products?.isNotEmpty ?? false) {
          itemViewList.addAll(_res.products!);
        }
      }
    }
    pageLoad = false;
    notify;
  }

  RetailProductRes? retailProducts;

  Future<void> getData() async {
    await getItemData(
      page: 1,
      searchKey: "",
      subCatId: null,
    );

    pageLoad = false;
    notify;
  }

  // void setupTable() {
  //   if (retailPosOrderRes?.products?.data != null) {
  //     tableList.tableDataList = [];
  //     for (final e in retailPosOrderRes!.products!.data!) {
  //       tableList.tableDataList.add(TableDataList(
  //         id: e.id ?? '',
  //         // imgList: [e.image],
  //         itemList: [
  //           if (tableList.headerList.any((a) => a == LN.category))
  //             e.category ?? '',
  //           if (tableList.headerList.any((a) => a == LN.brand)) e.brand ?? '',
  //           if (tableList.headerList.any((a) => a == LN.product))
  //             e.retailProductName ?? '',
  //           if (tableList.headerList.any((a) => a == LN.code)) e.code ?? '',
  //           // if (tableList.headerList.any((a) => a == LN.barcode))
  //           //   e.barCodeNumber ?? '',
  //         ],
  //         statusList: [],
  //         actionWidget: _isOnPos
  //             ? [
  //                 PosRetailWidget.posActionWidget(
  //                   e: e,
  //                   placeOrderPro: placeOrderPro,
  //                   posRetailPro: posRetailPro,
  //                 )
  //               ]
  //             : [PosRetailWidget.addProductActionWidget(e: e)],
  //       ));
  //     }
  //   }
  // }

  final brandList = <Category>[];

  void setUpData({required PlaceOrderPro placeOr}) {
    placeOrderPro ??= placeOr;

    if (retailPosOrderRes?.brands?.isNotEmpty ?? false) {
      brandList.clear();

      retailPosOrderRes?.brands
          ?.sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));

      if (retailPosOrderRes?.brands?.first.id?.isNotEmpty ?? false)
        retailPosOrderRes?.brands
            ?.insert(0, TableLocation(id: "", name: "All", value: "All"));

      for (final a in retailPosOrderRes!.brands!)
        brandList.add(Category(
          categoryId: a.id,
          categoryName: a.name,
        ));
    }

    if (placeOrderPro != null) {
      placeOrderPro!.staffList = retailPosOrderRes?.staffs;
      placeOrderPro!.initAddSec ??= PosScreenAddSec();
      placeOrderPro!.initAddSec?.orderTypes = retailPosOrderRes?.orderTypes;
      placeOrderPro!.taxExclusiveInclusiveType =
          retailPosOrderRes?.storeInformation?.taxExclusiveInclusiveType;
      if (retailPosOrderRes?.storeInformation?.holidaySurcharge?.isActive ??
          false) {
        placeOrderPro!.holidaySurgePercentage = retailPosOrderRes
            ?.storeInformation?.holidaySurcharge?.holidaySurgePercentage;
      }
      if (retailPosOrderRes?.storeInformation?.creditCardSurCharge?.isActive ??
          false) {
        placeOrderPro!.creCardSurChargePercentage = retailPosOrderRes
            ?.storeInformation?.creditCardSurCharge?.creditCardSurgePercentage;
      }
      GlobalCVP.stockExceedRestriction =
          !(retailPosOrderRes?.storeInformation?.enableOutOfStockSales ??
              false);

      placeOrderPro!.loading = false;
      placeOrderPro!.notify;
    }

    if (retailPosOrderRes?.storeInformation?.isBatch ?? false) {
      placeOrderPro?.stockDeductType = "Batch";
    } else if (retailPosOrderRes?.storeInformation?.isFiFo ?? false) {
      placeOrderPro?.stockDeductType = "FiFo";
    }
  }

  // Barcode Scan

  Future<void> getProductFromBarCode(
      String? barcode, BuildContext context) async {
    if (barcode == null) return;
    pageLoad = true;
    notify;

    FeaturedProduct? _product;

    if (_allProductData
        .any((e) => e.barcodeNumber?.toLowerCase() == barcode.toLowerCase())) {
      final _prodAsNew = _allProductData.firstWhere(
          (e) => e.barcodeNumber?.toLowerCase() == barcode.toLowerCase());

      final p = _prodAsNew.id != null
          ? (ProductData.fromJson(_prodAsNew.toJson())
            ..parentCatId = _prodAsNew.parentCatId
            ..promoModel = _prodAsNew.promoModel)
          : null;

      if (p == null) return;

      _setApplyDiscounts(p, 'getProductData: promo empty: barcode');

      _product = FeaturedProduct()
        ..id = p.productId
        ..varId = p.id
        ..categoryId = p.categoryId
        ..name = p.name
        ..salesTax = p.salesTax
        ..imageUrl = p.imageUrl
        ..quantity = p.quantity.toDouble()
        ..parentCatId = p.parentCatId
        ..productType = p.productType
        ..productVariations = [
          ProductVariation(
            id: p.id,
            stockCount: p.stockCount,
            actualPrice: p.actualPrice,
            discountPercentage: p.discountPercentage,
            discountedPrice: p.discountedPrice,
            discount: p.discountPrice,
            unitPrice: p.unitPrice,
            quantity: p.quantity.toDouble(),
            isDefault: true,
            productVariationModifiers: p.comboProducts != null
                ? [
                    ProductVariationModifier(
                        modifierItems: List.generate(
                            p.comboProducts!.length,
                            (index) => ModifierItem(
                                  productName: p.comboProducts![index].name,
                                  imageUrl: p.comboProducts![index].imageUrl,
                                )))
                  ]
                : [],
            promoModel: p.promoModel,
          )
        ];
    } else {
      IfException.showMessage(message: LN.noProductFound);
      // _product =
      //     await Handler.getProductDetailByBarcode(barcodeNumber: barcode);
    }

    pageLoad = false;
    notify;

    if (_product?.productVariations?.isNotEmpty ?? false) {
      if ((_product?.productVariations?.first.stockCount?.isNotEmpty ??
              false) &&
          (_product?.productVariations?.first.stockCount?.inDouble ?? 0) <= 0) {
        IfException.showMessage(message: LN.productOutOfStock);
        return;
      }

      if ((placeOrderPro?.initAddSec?.storeInformation?.isBatch ?? false) ||
          (retailPosOrderRes?.storeInformation?.isBatch ?? false)) {
        if ((_product?.productVariations?.isNotEmpty ?? false) &&
            (_product?.productVariations?.first.productVariationBatchStocks
                    ?.isNotEmpty ??
                false)) {
          final batchCount = _product!
              .productVariations!.first.productVariationBatchStocks!.length;

          if (batchCount > 1) {
            selectVarience(
              context,
              // catTypeId: _product.categoryTypeId,
              featuredProduct: _product,
              curSym: placeOrderPro?.curSym ?? '',
              productType: _product.productType,
            );
            return;
          } else {
            _product.productVariations?.first.productVariationBatchStocks?.first
                .isActive = true;
            if (OrderUtils.outOfBatchStock(
                selectedVariance: _product.productVariations?.first)) {
              return;
            }
          }
        }
      }

      if (placeOrderPro != null &&
          _product != null &&
          (_product.productVariations?.isNotEmpty ?? false)) {
        placeOrderPro!.updateOrderCart(
          product: _product,
          variation: _product.productVariations!.first,
        );
      }
    } else {
      // final _res = await getComboFromBarCode(barcode);

      // if (_res != null) {
      //   placeOrderPro?.comboDetailById = _res;
      //   placeOrderPro?.setRetailCombo(true);
      //   placeOrderPro?.updateSetMenuOnCart();
      // } else {
      //   showToast(LN.noProductFound);
      // }
    }
  }

  selectVarience(
    BuildContext context, {
    // String? catTypeId,
    FeaturedProduct? featuredProduct,
    required String curSym,
    String? productType,
  }) {
    placeOrderPro?.productDetailView = null;

    placeOrderPro?.getProductData(
      featuredProduct?.id,
      featuredProduct: featuredProduct,
      isPosTab: true,
    );

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (builder) => SimpleDialog(
              backgroundColor: kSecondaryColor,
              titlePadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              children: [
                ProductDetailDia(
                  product: featuredProduct,
                  // catTypeId: catTypeId,
                  curSym: curSym,
                  quantity: 1,
                  isPosTab: true,
                  productType: featuredProduct?.productType,
                ),
              ],
            ));
  }

  //retail Promotion

  // promotions
  Future<void> getAllPromotions() async {
    PromoUtils.dateFormatString = await SharedPrefs.dateFormat;
    PromoUtils.promotionRes = await Handler.getAllPromotions();
    PromoUtils.currentPromotion = PromoUtils.getPromoTitle();
    PromoUtils.setNearestPromoDuration();
    setOnScreenPosData();
  }

  String? promoId;

  void setOnScreenPosData() {
    // final initAddSec = placeOrder.initAddSec;
    // final orderTypeIndex = placeOrder.orderTypeIndex;
    // String _channelId = '';

    // if ((initAddSec?.orderTypes?.isNotEmpty ?? false) &&
    //     orderTypeIndex >= 0 &&
    //     orderTypeIndex < initAddSec!.orderTypes!.length) {
    //   _channelId = initAddSec.orderTypes![orderTypeIndex].channelId ?? '';
    // }

    // 🔹 Pre-build a lookup map for O(1) access

    // 🔹 Helper to clone + filter + discount
    ProductData? _prepareProduct(ProductData? source) {
      if (source == null) return null;
      final orig = _productMap?[source.id?.toLowerCase() ?? ""];
      if (orig == null) return null;

      final clone = ProductData.fromJson(orig.toJson())
        ..parentCatId = orig.parentCatId;

      // channel filter
      // if (_channelId.isNotEmpty) {
      //   clone.productVariations = clone.productVariations
      //       ?.where(
      //           (e) => e.channelId?.toLowerCase() == _channelId.toLowerCase())
      //       .toList();
      // }

      // discount
      if (promoId?.isNotEmpty ?? false) {
        if (!_setApplyDiscounts(clone, 'setOnScreenPosData: promo not empty',
            promoId: promoId)) return null;
      } else {
        _setApplyDiscounts(clone, 'setOnScreenPosData: promo empty');
      }

      return clone;
    }

    // ------------------------
    // ITEM VIEW
    // ------------------------
    if (itemViewList.isNotEmpty) {
      final _newList = <ProductData>[];

      for (var item in itemViewList) {
        final prepared = _prepareProduct(item);
        if (prepared != null) _newList.add(prepared);
      }

      itemViewList
        ..clear()
        ..addAll(_newList);

      notify; // looks like this should be notifyListeners()?
    }

    // ------------------------
    // PRODUCT DETAIL
    // ------------------------
    // final _p1 = placeOrder.productDetailView?.productListViewModel;
    // if (_p1 != null) {
    //   final prepared = _prepareProduct(_p1);
    //   if (prepared != null) {
    //     // Preserve default variation
    //     final _defaultVarId = _p1.productVariations
    //         ?.firstWhere((c) => c.isDefault ?? false,
    //             orElse: () => ProductVariation())
    //         .id;

    //     prepared.quantity = _p1.quantity;
    //     productDetailView?.productListViewModel = prepared;

    //     if (_defaultVarId != null) {
    //       final defaultVar = prepared.productVariations?.firstWhere(
    //           (d) => d.id?.toLowerCase() == _defaultVarId.toLowerCase(),
    //           orElse: () => ProductVariation());
    //       if (defaultVar?.id != null) defaultVar?.isDefault = true;
    //     }

    //     placeOrder.varianceLoading = true;
    //     notify;

    //     Future.delayed(const Duration(milliseconds: 600), () {
    //       placeOrder.varianceLoading = false;
    //       notify;
    //     });
    //   }
    // }
  }

  bool _setApplyDiscounts(ProductData e, String path, {String? promoId}) {
    final _promo = PromoUtils.get(
        productId: e.productId, promoId: promoId, variationId: e.id);
    if (_promo != null &&
        (promoId == null ||
            _promo.promoId.toLowerCase() == promoId.toLowerCase())) {
      final _promoPrice = _getPromoPrice(_promo, actualPrice: e.actualPrice);
      e.discountedPrice = _promoPrice?.discountedPrice;
      e.discountPercentage = _promoPrice?.discountPercent;
      e.discountPrice = _promoPrice?.discountAmount;
      e.promoModel = _promoPrice;
    }

    return true;
  }

  PromoModel? _getPromoPrice(PromoModel _promo,
      {required String? actualPrice}) {
    if (_promo.discountAmount != null) {
      final _disPer = PromoUtils.getPromoDisPercent(
        disValue: _promo.discountAmount,
        price: actualPrice,
      );

      _promo.discountPercent = _disPer;

      final _discountedAmount =
          (actualPrice?.inDouble ?? 0) - (_promo.discountAmount.inDouble);
      if (_discountedAmount < 0) {
        _promo.discountedPrice = '0';
        _promo.discountPercent = '100';
        _promo.discountAmount = actualPrice;
      } else {
        _promo.discountedPrice = _discountedAmount.formatDouble;
      }
    } else if (_promo.discountPercent != null) {
      final _disAmount = PromoUtils.getPromoDisAmount(
        disPercent: _promo.discountPercent,
        price: actualPrice,
      );
      _promo.discountAmount = _disAmount;

      final _discountedAmount =
          (actualPrice?.inDouble ?? 0) - (_promo.discountAmount.inDouble);

      if (_discountedAmount < 0) {
        _promo.discountedPrice = '0';
        _promo.discountPercent = '100';
        _promo.discountAmount = actualPrice;
      } else {
        _promo.discountedPrice = _discountedAmount.formatDouble;
      }
    }

    return _promo;
  }

  // Future<ComboDetailById?> getComboFromBarCode(String? barcode) async {
  //   if (barcode == null) return null;
  //   pageLoad = true;
  //   notify;

  //   final _res = await Handler.getComboDetailByBarcode(barcodeNumber: barcode);

  //   pageLoad = false;
  //   notify;

  //   return _res;
  // }

  void clear() {
    searchCltr.clear();
    retailPosOrderRes = null;
    // _initPosRes = null;
    placeOrderPro = null;
    // brandIndex = 0;
    selectedBrandId = "";
    pageSizeIndex = 1;
    pageIndex = 1;
    pageLoad = true;
    // tableList.tableDataList = [];
    // alphaId = "";
    selectedAlpha = null;
    alphaList = null;
  }

  void clearAll() {
    searchCltr.clear();
    promoId = null;
    retailPosOrderRes = null;
    // _initPosRes = null;
    placeOrderPro = null;
    selectedCatId = "";
    selectedSubCatIndex = null;
    subCategoryList = null;
    itemViewList.clear();
    ingreViewList.clear();
    // brandIndex = 0;
    selectedBrandId = "";
    pageSizeIndex = 1;
    pageIndex = 1;
    pageLoad = true;
    // tableList.tableDataList = [];
    // alphaId = "";
    selectedAlpha = null;
  }

  //BAR CODE GENERATE

  BarcodeAddSec? barcodeAddSec;
  int? printerIndex;
  int? barcodeTypeIndex;
  bool generateLoading = false;
  final numBarcodeCltr = TextEditingController();

  Future<void> getBarcodeSec() async {
    barcodeAddSec = await Handler.getBarcodeSec();
  }

  GenerateBarcodeReq _generateBarcodeReq(
    String variationId, {
    bool isGenerate = true,
  }) {
    final req = GenerateBarcodeReq(
      productVariationId: variationId,
    );

    if (barcodeAddSec?.posPrinters != null &&
        barcodeAddSec!.posPrinters!.isNotEmpty &&
        printerIndex != null) {
      req.storePosPrinterId = barcodeAddSec!.posPrinters![printerIndex!].id;
    }
    if (isGenerate) {
      if (barcodeAddSec?.barCodeTypes != null &&
          barcodeAddSec!.barCodeTypes!.isNotEmpty &&
          barcodeTypeIndex != null) {
        req.barCodeTypeStoreId =
            barcodeAddSec!.barCodeTypes![barcodeTypeIndex!].id;
      }
    } else {
      req.numberOfBarCode = int.tryParse(numBarcodeCltr.text);
    }

    return req;
  }

  Future<void> generateBarcode({
    required String variationId,
    BuildContext? diaCtx,
  }) async {
    generateLoading = true;
    notify;

    await Handler.generateBarcode(
      data: _generateBarcodeReq(variationId),
      diaCtx: diaCtx,
    );

    generateLoading = false;
    notify;
  }

  Future<BarcodePrintRes?> printBarcode({
    required String variationId,
    BuildContext? diaCtx,
  }) async {
    generateLoading = true;
    notify;
    final data = await Handler.printBarcode(
      data: _generateBarcodeReq(variationId, isGenerate: false),
      diaCtx: diaCtx,
    );

    generateLoading = false;
    notify;
    return data;
  }

  void barcodeClear() {
    barcodeAddSec = null;
    printerIndex = null;
    barcodeTypeIndex = null;
    numBarcodeCltr.clear();
  }

  PosRetailPro? posRetailPro;

  // pos retail
//   FeaturedProduct? retailProductDetail;

//   Future<void> getProductDetail({
//     String? varId,
//   }) async {
//     if (varId == null) return;
//     retailProductDetail = null;

//     pageLoad = true;
//     notify;

//     retailProductDetail =
//         await Handler.getProductDetailByVarId(prodVarId: varId);

//     pageLoad = false;
//     notify;
//   }
}

class RetailTitle {
  final String title;
  bool show;

  RetailTitle({required this.title, required this.show});
}
