import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:pos_account/config/utils/map_utils.dart';
import 'package:pos_account/config/utils/promo_utils.dart';
import 'package:pos_account/config/utils/order_utils.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/constant/date_format_keys.dart';
import 'package:pos_account/constant/strings.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/auth/store_detail_res.dart';
import 'package:pos_account/model/common/table_id_name.dart';
import 'package:pos_account/model/common/table_location.dart';
import 'package:pos_account/model/home/booking/all_customer.dart';
import 'package:pos_account/model/home/menu/payment/cus_loyal_res.dart';
import 'package:pos_account/model/home/menu/place_order/all_cus_add_sec.dart';
import 'package:pos_account/model/home/menu/place_order/menu_schedule_res.dart';
import 'package:pos_account/model/home/menu/place_order/pos_res/add_sec.dart';
import 'package:pos_account/model/home/menu/place_order/pos_res/all_pos_products.dart';
import 'package:pos_account/model/home/menu/place_order/pos_res/com/combo_detail_by_id.dart';
import 'package:pos_account/model/home/menu/place_order/pos_res/com/feature_product.dart';
import 'package:pos_account/model/home/menu/place_order/delivery/cus_delivery_data.dart';
import 'package:pos_account/model/home/menu/place_order/delivery/deli_dis_res.dart';
import 'package:pos_account/model/home/menu/place_order/place_order_req.dart';
import 'package:pos_account/model/home/menu/place_order/po_make_pay_req.dart';
import 'package:pos_account/model/home/menu/place_order/pos_res/pos_cat_res.dart';
import 'package:pos_account/model/home/menu/place_order/pos_res/pos_combo_res.dart';
import 'package:pos_account/model/home/menu/place_order/pos_res/pos_ingre_res.dart';
import 'package:pos_account/model/home/menu/place_order/pos_res/pos_product_res.dart';
import 'package:pos_account/model/home/menu/place_order/product_detail_view_model.dart';
import 'package:pos_account/model/home/menu/signal_r/place_order_info.dart';
import 'package:pos_account/model/ui_model/amount_class.dart';
import 'package:pos_account/providers/auth/auth_pro.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/repository/handler.dart';
import 'package:pos_account/repository/if_exception.dart';
import 'package:pos_account/services/database/database/db_local_data.dart';
import 'package:pos_account/services/database/shared_pref.dart';
import 'package:pos_account/services/language/translate.dart';
import 'package:pos_account/widgets/dialog/confirm_dialog.dart';
import 'package:pos_account/widgets/dialog/msg_dialog.dart';
import '../../services/signal_core/utils/stk_event_utils.dart';
import '../../model/home/menu/place_order/pos_res/popular_products_res.dart';

class PlaceOrderPro extends ChangeNotifier {
  bool loading = true;
  bool orderTabLoading = false;
  FocusNode? desFocus;
  // LoginRes? loginRes;
  // int? selectedStore;
  String? curSym;
  // final String channelPlatForm = "POSMobile";

  // List<OrderTypeRes>? listOrderType;
  // AllPosOrderSecRes? initRes;
  // AllPosOrderSecRes? productsRes;

// neutral either isRetailScreen true or false
  // List<TableLocation>? tableList;
  // String tableName = "";
  List<TableIdName>? tableIdName;

  List<TableLocation>? staffList;
  String? taxExclusiveInclusiveType;
  String? holidaySurgePercentage;
  String? creCardSurChargePercentage;

  // final menuRes = <MenuRes>[];

  // int? tableIndex;
  // String? tableId;
  int? waiterIndex = 0;
  bool showManageTab = false;
  int orderTypeIndex = 0;
  final noOfCustomer = TextEditingController();
  String? orderTabId = "";
  String? orderTabLimit;
  String orderTabName = "";

  final setMenuList = <SetMenuOrderDetail>[];
  final orderList = <OrderDetail>[];
  final descCltr = TextEditingController();

  final ingreList = <RawIngredientOrderDetail>[];

  bool loadStKtBtn = false;
  bool loadPlaceOr = false;
  // PlaceOrderRes? placeOrderRes;
  PlaceOrderInfo? placeOrderInfo;

  // bool isRetail = false;
  // bool isRetailScreen = false;
  bool? isTrialExp;

  final searchCltr = TextEditingController();

  int? brandIndex;

  FeaturedProduct? selectedSetMenuProduct;

  /// new  //

  PosScreenCatRes? posCatRes;
  String selectedCatId = "";
  String? categoryTitle;
  PosScreenAddSec? initAddSec;

  int pageIndex = 1;
  final int _pageSize = 12;
  final itemViewList = <FeaturedProduct>[];
  List<SubCategory>? subCategoryList;
  List<String>? alphaList;
  final comboViewList = <ComboProduct>[];
  final ingreViewList = <RawLooseIngredientProduct>[];

  List<String>? docketNameList;

  ItemViewType itemViewType = ItemViewType.product;

  ///
  /// --- /////

  double get taxPercentDDS =>
      initAddSec?.storeInformation?.taxPercentage?.inDouble ??
      10; // tax percent for delivery, discount and surcharges

  void clear() {
    setMenuList.clear();
    orderList.clear();
    ingreList.clear();
    descCltr.clear();
    noOfCustomer.clear();
    clearCusData();
    // tableIndex = null;
    // tableId = null;
    tableIdName = null;
    orderTabId = "";
    orderTabLimit = null;
    searchCltr.clear();
    // tableName = "";
    orderTabName = "";
    brandIndex = null;
    // alphaId = "";
    selectedAlpha = null;
    promoId = null;
    selectedSetMenuProduct = null;
    showManageTab = false;
    isAnyItemJustCancelled = false;
  }

  void clearInitData() {
    // posCatRes = null;
    selectedCatId = "";
    // alphaId = "";
    selectedAlpha = null;
    promoId = null;
    categoryTitle = null;
    initAddSec = null;
    itemViewList.clear();
    subCategoryList = null;
    docketNameList = null;
    alphaList = null;
    comboViewList.clear();
    ingreViewList.clear();

    itemViewType = ItemViewType.product;
  }

  set initStore(StoreDetailRes? store) {
    curSym = store?.currencySymbol;
    notify;
  }

  // Future<void> getFromDB() async {
  //   if (isRetailScreen) return;

  //   final _dbMenuList = await DbLocalData.getInitProd();

  //   if (_dbMenuList != null) {
  //     initRes = _dbMenuList;
  //     productsRes = AllPosOrderSecRes.fromJson(_dbMenuList.toJson());
  //     setData();
  //     // log("init res length: ${initRes?.productsWithCategories?.length}");
  //     // productsRes = getProductRes(
  //     //   // oTIndex: orderTypeIndex,
  //     //   drawerIndex: _drawerIndex,
  //     // );
  //     notify;
  //   }
  // }

  // Future<void> getListOrderType() async {
  //   final _listOrderType = await Handler.getListOrderType();
  //   if (_listOrderType != null) {
  //     listOrderType = _listOrderType;
  //     if (_listOrderType.any((e) => e.isSelected ?? false))
  //       orderTypeIndex =
  //           _listOrderType.indexWhere((e) => e.isSelected ?? false);
  //   }
  //   notify;
  // }

  void setOnScreenPosData() {
    String _channelId = '';

    if ((initAddSec?.orderTypes?.isNotEmpty ?? false) &&
        orderTypeIndex >= 0 &&
        orderTypeIndex < initAddSec!.orderTypes!.length) {
      _channelId = initAddSec!.orderTypes![orderTypeIndex].channelId ?? '';
    }

    // 🔹 Pre-build a lookup map for O(1) access

    // 🔹 Helper to clone + filter + discount
    FeaturedProduct? _prepareProduct(FeaturedProduct? source) {
      if (source == null) return null;
      final orig = _productMap?[source.id?.toLowerCase() ?? ""];
      if (orig == null) return null;

      final clone = FeaturedProduct.fromJson(orig.toJson())
        ..parentCatId = orig.parentCatId;

      // channel filter
      if (_channelId.isNotEmpty) {
        clone.productVariations = clone.productVariations
            ?.where(
                (e) => e.channelId?.toLowerCase() == _channelId.toLowerCase())
            .toList();
      }

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
      final _newList = <FeaturedProduct>[];

      for (var item in itemViewList) {
        final prepared = _prepareProduct(item);
        if (prepared != null) _newList.add(prepared);
      }

      itemViewList
        ..clear()
        ..addAll(_newList);

      notify; // looks like this should be notifyListeners()?
    }

    // order list

    // if (orderList.isNotEmpty) {
    //   for (int i = 0; i < orderList.length; i++) {
    //     final a = orderList[i];

    //     if ((a.id == null || a.id!.isEmpty) &&
    //         _allProductData.any(
    //             (b) => b.id?.toLowerCase() == a.productId?.toLowerCase())) {
    //       final _thatProd = _allProductData.firstWhere(
    //           (b) => b.id?.toLowerCase() == a.productId?.toLowerCase());

    //       final _product = FeaturedProduct.fromJson(_thatProd.toJson())
    //         ..parentCatId = _thatProd.parentCatId;

    //       if (_channelId.isNotEmpty) {
    //         final _channelVarList = _product.productVariations
    //             ?.where((e) =>
    //                 e.channelId?.toLowerCase() == _channelId.toLowerCase())
    //             .toList();
    //         _product.productVariations = _channelVarList;
    //       }

    //       final _variation = _product.productVariations?.firstWhere((c) =>
    //           c.id?.toLowerCase() == a.productVariationId?.toLowerCase());

    //       _setApplyDiscounts(_product, promoId: promoId);

    //       updateOrderCart(
    //         product: _product..quantity = (a.quantity ?? 1.0),
    //         variation: _variation
    //           ?..quantity = (a.quantity ?? 1.0)
    //           ..actualPrice = _variation.actualPrice
    //           ..unitPrice = _variation.unitPrice
    //           ..discountPercentage = _variation.discountPercentage,
    //         catId: _product.categoryId,
    //         orderDetailIndex: i,
    //         isVarianceUpdate: true,
    //         customPrice: a.customPrice,
    //       );
    //     }
    //   }
    //   notify;
    // }

    // ------------------------
    // PRODUCT DETAIL
    // ------------------------
    final _p1 = productDetailView?.productListViewModel;
    if (_p1 != null) {
      final prepared = _prepareProduct(_p1);
      if (prepared != null) {
        // Preserve default variation
        final _defaultVarId = _p1.productVariations
            ?.firstWhere((c) => c.isDefault ?? false,
                orElse: () => ProductVariation())
            .id;

        prepared.quantity = _p1.quantity;
        productDetailView?.productListViewModel = prepared;

        if (_defaultVarId != null) {
          final defaultVar = prepared.productVariations?.firstWhere(
              (d) => d.id?.toLowerCase() == _defaultVarId.toLowerCase(),
              orElse: () => ProductVariation());
          if (defaultVar?.id != null) defaultVar?.isDefault = true;
        }

        varianceLoading = true;
        notify;

        Future.delayed(const Duration(milliseconds: 600), () {
          varianceLoading = false;
          notify;
        });
      }
    }
  }

  Future<void> getOrderAddSection() async {
    initAddSec = PosScreenAddSec.fromJson(GlobalCVP.allAddSection);
    GlobalCVP.setStoreInfo = initAddSec?.storeInformation;
    // await Handler.getAllPosOrAddSec();
    OrderUtils.statusList = initAddSec?.orderItemStatus;
    setData();
  }

  List<TableLocation>? orderNoteList;

  void setOrderNotes() {
    if (GlobalCVP.allAddSection['orderNotes'] != null)
      orderNoteList = List<TableLocation>.from(GlobalCVP
          .allAddSection['orderNotes']
          .map((x) => TableLocation.fromJson(x)));
  }

  Future<void> init() async {
    // initAddSec = await Handler.getAllPosOrAddSec();
    getOrderAddSection();
    // getItemData();
    getInitData();
    getCusAddSec();
  }

  Future<void> getInitData({
    int page = 1,
    String searchKey = "",
  }) async {
    getItemData(
      page: page,
      searchKey: searchKey,
    );
    // if (itemViewType == ItemViewType.product //||
    //     // (itemViewType == ItemViewType.combo && !GlobalCVP.isRetailScreen)
    //     )
    //   getItemData(
    //     page: page,
    //     searchKey: searchKey,
    //   );
    // else if (itemViewType == ItemViewType.combo)
    //   getComboData(
    //     page: page,
    //     searchKey: searchKey,
    //   );
    // else if (itemViewType == ItemViewType.ingre)
    //   getIngreData(
    //     page: page,
    //     searchKey: searchKey,
    //   );
  }

  Future<void> getPopularProducts() async {
    _popularProductIds = await Handler.getPopularProducts();
    // kPrint("_popularProductIds: ${_popularProductIds?.length}");
  }

  // bool initProductLoad = true;

  Future<void> getAllProducts({
    bool isServerCall = false,
    bool serverCallLater = true,
  }) async {
    if (isServerCall) {
      await _getAllProductsFromServer();
      return;
    }

    final _dbData = await DbLocalData.getAllPosProducts();
    if (_dbData != null) {
      if (isServerCall || (!isServerCall && _allCatwithProdData.isEmpty))
        _allCatwithProdData = List<AllPosProductRes>.from(
            _dbData.map((x) => AllPosProductRes.fromJson(x)));
      if (isServerCall || (!isServerCall && _allSortCatProdData.isEmpty))
        _allSortCatProdData = List<AllPosProductRes>.from(
            _dbData.map((x) => AllPosProductRes.fromJson(x)));

      _setAllProdData(_allCatwithProdData);
      if (serverCallLater) {
        _getAllProductsFromServer();
      }
    } else {
      await _getAllProductsFromServer();
    }
  }

  Future<void> _getAllProductsFromServer() async {
    final _res = await Handler.getAllPosOrProductsV2();
    // initProductLoad = false;
    if (_res != null) {
      await DbLocalData.updateAllPosProduct(data: _res);
      //setData
      _allCatwithProdData = List<AllPosProductRes>.from(
          _res.map((x) => AllPosProductRes.fromJson(x)));
      _allSortCatProdData = List<AllPosProductRes>.from(
          _res.map((x) => AllPosProductRes.fromJson(x)));
      _setAllProdData(_allCatwithProdData);
    }
    await getPopularProducts();
  }

  List<AllPosProductRes> _allCatwithProdData = [];
  List<AllPosProductRes> _allSortCatProdData = [];

  List<FeaturedProduct> _allProductData = [];

  List<PopularProductRes>? _popularProductIds;
  List<FeaturedProduct> popularProducts = [];

  Map<String, FeaturedProduct>? _productMap;

  void _setAllProdData(List<AllPosProductRes>? _allData) {
    if (_allData != null) {
      _allProductData = []; // to view all product data even from order item
      _productMap = {};
      final _tempPopProducts = <FeaturedProduct>[];
      popularProducts = [];

      posCatRes = PosScreenCatRes(
        comboCategories: [],
        rawLooseCategories: [],
        productCategories: [],
      );

      for (final a in _allData) {
        bool _hasFilteredProduct = false;

        for (final b in a.products!) {
          final _isInSlot = (menuslot?.every((m) => m.products == null) ??
                  true) ||
              ((menuslot?.any((m) => m.products?.isNotEmpty ?? false) ??
                      false) &&
                  (menuslot?.any((m) =>
                          m.products?.any(
                              (e) => e.toLowerCase() == b.id?.toLowerCase()) ??
                          false) ??
                      false));

          if (_isInSlot) {
            _hasFilteredProduct = true;
          }

          _allProductData.add(
            b..parentCatId = a.id,
          );
          if (b.id != null) _productMap?.addAll({b.id!.toLowerCase(): b});

          if ((_popularProductIds?.any(
                      (c) => c.id?.toLowerCase() == b.id?.toLowerCase()) ??
                  false) &&
              (!_tempPopProducts
                  .any((d) => d.id?.toLowerCase() == b.id?.toLowerCase()))) {
            _tempPopProducts.add(b);
          }
        }

        if (_hasFilteredProduct) {
          posCatRes?.productCategories?.add(CategoryData(
            id: a.id,
            name: a.name,
            type: a.type,
            defaultBackGroundColor: a.defaultBackGroundColor,
            defaultTextColor: a.defaultTextColor,
            onFocusBackGroundColor: a.onFocusBackGroundColor,
            onFocusTextColor: a.onFocusTextColor,
            itemViewType: ItemViewType.product,
          ));
        }
      }

      if (_tempPopProducts.isNotEmpty) {
        final _popCatData = CategoryData(
          id: 'popular-product-cat-id',
          name: "Popular",
          type: "Items",
          itemViewType: ItemViewType.product,
        );

        if ((posCatRes?.productCategories?.isNotEmpty ?? false) &&
            posCatRes?.productCategories?.first.id != _popCatData.id) {
          posCatRes?.productCategories?.insert(0, _popCatData);

          final _poProdMap = {
            for (var b in _tempPopProducts) b.id?.toLowerCase(): b
          };

          for (final p in _popularProductIds!) {
            final match = _poProdMap[p.id?.toLowerCase()];
            if (match != null) {
              popularProducts.add(match..parentCatId = 'popular-product-cat-id'
                  // ..categoryId = 'popular-product-cat-id',
                  );
            }
          }

          _allProductData.addAll(popularProducts);

          if (_allCatwithProdData.first.id != _popCatData.id)
            _allCatwithProdData.insert(
                0,
                AllPosProductRes(
                    id: _popCatData.id,
                    name: _popCatData.name,
                    type: _popCatData.type,
                    products: popularProducts));

          if (_allSortCatProdData.first.id != _popCatData.id)
            _allSortCatProdData.insert(
                0,
                AllPosProductRes(
                    id: _popCatData.id,
                    name: _popCatData.name,
                    type: _popCatData.type,
                    products: popularProducts));
        }
      }

      setOnScreenPosData();
      notify;
    }
  }

  bool _setApplyDiscounts(FeaturedProduct e, String path, {String? promoId}) {
    if (e.productVariations == null) return false;
    // if (e.name == "Adv 4 Qytar") kPrint("${e.name} $path");

    for (final b in e.productVariations!) {
      final _promo =
          PromoUtils.get(productId: e.id, variationId: b.id, promoId: promoId);
      // if (e.name == "Adv 4 Qytar")
      //   kPrint(
      //       "$path  ::${b.name} ${b.id} ${_promo?.name} | ${_promo?.discountAmount} | ${_promo?.discountPercent} $promoId");

      if (_promo != null &&
          (promoId == null ||
              _promo.promoId.toLowerCase() == promoId.toLowerCase())) {
        // if (_promo.discountAmount != null) {
        //   final _disPer = PromoUtils.getPromoDisPercent(
        //     disValue: _promo.discountAmount,
        //     price: b.actualPrice,
        //   );

        //   _promo.discountPercent = _disPer;

        //   final _discountedAmount =
        //       (b.actualPrice?.inDouble ?? 0) - (_promo.discountAmount.inDouble);
        //   if (_discountedAmount < 0) {
        //     b.discountedPrice = '0';
        //     b.discountPercentage = '100';
        //     b.discount = b.actualPrice;
        //   } else {
        //     b.discountedPrice = _discountedAmount.formatDouble;
        //     b.discountPercentage = _promo.discountPercent;
        //     b.discount = _promo.discountAmount;
        //   }
        // } else if (_promo.discountPercent != null) {
        //   final _disAmount = PromoUtils.getPromoDisAmount(
        //     disPercent: _promo.discountPercent,
        //     price: b.actualPrice,
        //   );
        //   _promo.discountAmount = _disAmount;

        //   final _discountedAmount =
        //       (b.actualPrice?.inDouble ?? 0) - (_promo.discountAmount.inDouble);

        //   if (_discountedAmount < 0) {
        //     b.discountedPrice = '0';
        //     b.discountPercentage = '100';
        //     b.discount = b.actualPrice;
        //   } else {
        //     b.discountedPrice = _discountedAmount.formatDouble;
        //     b.discountPercentage = _promo.discountPercent;
        //     b.discount = _disAmount;
        //   }
        // }

        final _promoPrice = _getPromoPrice(_promo, actualPrice: b.actualPrice);
        b.discountedPrice = _promoPrice?.discountedPrice;
        b.discountPercentage = _promoPrice?.discountPercent;
        b.discount = _promoPrice?.discountAmount;

        b.promoModel = _promoPrice;
      }

      if (b.productVariationModifiers != null) {
        for (final c in b.productVariationModifiers!) {
          if (c.modifierItems != null) {
            for (final d in c.modifierItems!) {
              final _modiPromo = PromoUtils.get(
                  productId: d.productId, variationId: d.variationId);

              // if (d.productName == "Margherita Pizza")
              //   kPrint("${d.productName} $path");

              if (_modiPromo != null &&
                  (promoId == null ||
                      _modiPromo.promoId.toLowerCase() ==
                          promoId.toLowerCase())) {
                final _modiPromoPrice =
                    _getPromoPrice(_modiPromo, actualPrice: d.actualPrice);

                // if (d.productName == "Margherita Pizza")
                //   kPrint(
                //       "-- ${d.productName} ${_modiPromoPrice?.discountedPrice}");

                d.discountedPrice = _modiPromoPrice?.discountedPrice;
                // d.discountPercentage = _modiPromoPrice?.discountPercent;
                // d.discount = _modiPromoPrice?.discountAmount;

                d.promoModel = _modiPromoPrice;
              }
            }
          }
        }
      }
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

  void _setPromOnAllProducts(PosProductRes res) {
    if (res.products != null)
      for (final a in res.products!) {
        // print("1. PRODUCT: ${a.name}");
        _setApplyDiscounts(a, '_setPromOnAllProducts');
      }
  }

  // String channel = "",
  // String searchKey = "",
  // String alphaKey = "",

  Future<PosProductRes> _getPosData({
    int page = 1,
    int pageSize = 10,
    String parentCatId = "",
    String subCatId = "",
    String channelId = "",
    String searchKey = "",
    String alphaKey = "",
    String promoId = "",
    String docket = "",
    List<MenuSchedule>? menuslot,
  }) async {
    // kPrint(
    //     """parentCatId: $parentCatId\n subCatId: $subCatId\n channelId: $channelId\n searchKey: $searchKey\n alphaKey: $alphaKey\n promoId: $promoId\n docket: $docket""");
    if (_allProductData.isEmpty) {
      await getAllProducts();
    }

    final res = PosProductRes(
      subCategories: [],
      products: [],
      alphaList: [],
      docketList: [],
    );

    // Pre-lowercase all filters
    final _lowerParentCatId = parentCatId.toLowerCase();
    final _lowerSubCatId = subCatId.toLowerCase();
    final _lowerSearchKey = searchKey.toLowerCase();
    final _lowerAlphaKey = alphaKey.toLowerCase();
    final _lowerDocket = docket.toLowerCase();

    // Containers to build in single loop
    final Set<String> alphaSet = {};
    final Map<String, int> docketSortMap = {}; // docketName -> min sort
    final Map<String, String> docketNameMap = {}; // for null/empty handling
    final List<FeaturedProduct> filteredProducts = [];

    // kPrint("Slot Products : ${menuslot?.map((e) => e.products).toList()}");

    // sort order

    List<AllPosProductRes>? _finalAllProductData;

    if (parentCatId.isNotEmpty) {
      final _catData = _allSortCatProdData
          .firstWhere((a) => a.id?.toLowerCase() == parentCatId.toLowerCase());
      sortItems(_catData.products!, true);
      _finalAllProductData = _allSortCatProdData;
    } else {
      _finalAllProductData = _allCatwithProdData;
    }

    if (menuslot != null) {
      _setAllProdData(_finalAllProductData);
    }

    // Single pass loop
    for (final product in _allProductData) {
      // skip invalid

      // final _isInSlot = menuslot?.products == null ||
      //     ((menuslot?.products?.isNotEmpty ?? false) &&
      //         (menuslot?.products?.any(
      //                 (e) => e.toLowerCase() == product.id?.toLowerCase()) ??
      //             false));

      final _isInSlot = (menuslot?.every((m) => m.products == null) ?? true) ||
          ((menuslot?.any((m) => m.products?.isNotEmpty ?? false) ?? false) &&
              (menuslot?.any((m) =>
                      m.products?.any((e) =>
                          e.toLowerCase() == product.id?.toLowerCase()) ??
                      false) ??
                  false));

      if ((product.productVariations?.isEmpty ?? true) ||
          (product.name?.isEmpty ?? true) ||
          !_isInSlot) continue;

      final _name = product.name?.trim() ?? "";

      // alpha collection
      if (parentCatId.isEmpty ||
          product.parentCatId?.toLowerCase() == _lowerParentCatId) {
        if (_name.isNotEmpty) {
          alphaSet.add(_name[0].toUpperCase());
        }
      }

      // docket collection
      final dName = product.docketGroupName ?? "Others";
      final dSort = int.tryParse(product.docketGroupSort ?? "") ?? 0;
      docketSortMap[dName] =
          dSort < (docketSortMap[dName] ?? dSort) ? dSort : dSort;
      docketNameMap[dName] = dName;

      // ---- Filtering ----
      final _parentMatch = parentCatId.isEmpty ||
          (product.parentCatId?.toLowerCase() == _lowerParentCatId);
      final _subCatMatch = subCatId.isEmpty ||
          (product.categoryId?.toLowerCase() == _lowerSubCatId);
      final _searchMatch =
          searchKey.isEmpty || _name.toLowerCase().contains(_lowerSearchKey);
      final _alphaMatch = alphaKey.isEmpty ||
          (_name.isNotEmpty && _name[0].toLowerCase() == _lowerAlphaKey);
      final _productPriceTypeMatch =
          !(product.productPriceType?.toLowerCase().contains('variable') ??
              false);
      final _docketMatch = docket.isEmpty ||
          (product.docketGroupName?.toLowerCase() == _lowerDocket) ||
          (_lowerDocket == 'others' &&
              (product.docketGroupName == null ||
                  product.docketGroupName!.trim().isEmpty));
//       if (_parentMatch) kPrint('''${product.name}
// _parentMatch: $_parentMatch &&
//         _subCatMatch:  $_subCatMatch &&
//         _searchMatch:  $_searchMatch &&
//        _alphaMatch:   $_alphaMatch &&
//        _productPriceTypeMatch:  $_productPriceTypeMatch &&
//         _docketMatch:  $_docketMatch''');

      // if (product.name == "kids pancake") {
      //   kPrint(
      //       "product: ${product.name} _parentMatch: $_parentMatch, _subCatMatch: $_subCatMatch, _searchMatch: $_searchMatch, _alphaMatch: $_alphaMatch, _productPriceTypeMatch: $_productPriceTypeMatch, _docketMatch: $_docketMatch");
      // }

      if (_parentMatch &&
          _subCatMatch &&
          _searchMatch &&
          _alphaMatch &&
          _productPriceTypeMatch &&
          _docketMatch) {
        final clone = FeaturedProduct.fromJson(product.toJson())
          ..parentCatId = product.parentCatId;

        // kPrint("promoId: $promoId");

        // Promo filter
        if (promoId.isNotEmpty)
          _setApplyDiscounts(clone, '_getPosData: promo empty',
              promoId: promoId);

        if (channelId.isNotEmpty) {
          clone.productVariations = clone.productVariations
              ?.where(
                  (e) => e.channelId?.toLowerCase() == channelId.toLowerCase())
              .toList();
        }

        // kPrint("promoId: $promoId");

        if (clone.productVariations?.isNotEmpty ?? false) {
          if (promoId.isEmpty ||
              (clone.productVariations?.any((p) => p.promoModel != null) ??
                  false)) {
            if (!filteredProducts
                .any((z) => z.id?.toLowerCase() == clone.id?.toLowerCase())) {
              filteredProducts.add(clone);
            }
          }
        }
      }
    }

    // Build alpha list
    res.alphaList = alphaSet.toList()..sort();

    // Build docket list
    if (docketSortMap.isNotEmpty && docketSortMap.length > 1) {
      final docketList = docketSortMap.keys.toList()
        ..sort((a, b) {
          if (a == "Others" && b != "Others") return 1;
          if (b == "Others" && a != "Others") return -1;
          return (docketSortMap[a] ?? 0).compareTo(docketSortMap[b] ?? 0);
        });
      res.docketList = docketList;
    }

// Pagination after filtering
    if (page <= 0) page = 1;
    final startIndex = (page - 1) * pageSize;
    final endIndex = (startIndex + pageSize).clamp(0, filteredProducts.length);

    for (int i = startIndex; i < endIndex; i++) {
      final prod = filteredProducts[i];
      res.products!.add(prod);
    }

    // Subcategories if parentCatId only
    if (parentCatId.isNotEmpty && subCatId.isEmpty) {
      res.subCategories = _finalAllProductData
              .firstWhere(
                  (a) => a.id?.toLowerCase() == parentCatId.toLowerCase(),
                  orElse: () => AllPosProductRes(id: "", subCategories: []))
              .subCategories ??
          [];
    }

    if (promoId.isEmpty) _setPromOnAllProducts(res);

    return res;
  }

  void sortItems(List<FeaturedProduct> items, bool sortByOrder) {
    items.sort((a, b) {
      if (sortByOrder) {
        // Sort by sortOrder (ascending)
        int orderA = a.sortOrder ?? 0;
        int orderB = b.sortOrder ?? 0;
        return orderA.compareTo(orderB);
      } else {
        // Sort alphabetically by name (fallback key: 'name')
        String nameA = (a.name ?? '').toLowerCase();
        String nameB = (b.name ?? '').toLowerCase();
        return nameA.compareTo(nameB);
      }
    });
  }

  String? _subCatId;
  String? selectedAlpha;
  String? promoId;
  String? _currentDocketName;
  List<MenuSchedule>? menuslot;

  Future<void> getItemData({
    int page = 1,
    String searchKey = "",
    String? subCatId,
    String? docketName,
  }) async {
    itemViewType = ItemViewType.product;
    // print('1-------------------');
    // String brandId = "";
    // if (brandIndex != null && (initAddSec?.brands?.isNotEmpty ?? false)) {
    //   brandId = initAddSec?.brands?[brandIndex!].id ?? '';
    // }

    if (page == 1) {
      _subCatId = subCatId;
      if (_subCatId == null) {
        subCategoryList = null;
      }
      _currentDocketName = docketName;
      if (_currentDocketName == null) {
        docketNameList = null;
      }
    }

    if (initAddSec == null) {
      await getOrderAddSection();
    }

    String _channelId = '';

    if ((initAddSec?.orderTypes?.isNotEmpty ?? false) &&
        orderTypeIndex >= 0 &&
        orderTypeIndex < initAddSec!.orderTypes!.length) {
      _channelId = initAddSec!.orderTypes![orderTypeIndex].channelId ?? '';
    }

    if (page == 1 || pageIndex * _pageSize <= itemViewList.length) {
      pageIndex = page;
      final _res = await _getPosData(
        page: page,
        pageSize: _pageSize,
        searchKey: searchKey,
        parentCatId:
            selectedCatId.contains(Strings.staticPromoId) ? "" : selectedCatId,
        subCatId: _subCatId ?? '',
        channelId: _channelId,
        alphaKey: selectedAlpha ?? '',
        promoId: promoId ?? '',
        docket: _currentDocketName ?? '',
        menuslot: menuslot,
      );
      // await Future.delayed(Duration(milliseconds: 100));

      // print('2--------${_res.products?.length}-----------');

      // page: page,
      // pageSize: _pageSize,
      // catId: _subCatId ?? selectedCatId,
      // brandId: brandId,
      // channelEnum: (initAddSec?.orderTypes?.isNotEmpty ?? false)
      //     ? (initAddSec!.orderTypes![orderTypeIndex].orderTypeChannel
      //             ?.trim() ??
      //         (reOrder?.orderChannelEnum?.trim()))
      //     : '',
      // searchKey: searchKey,
      // alphaId: alphaId ?? "",

      if (page == 1) {
        itemViewList.clear();
        if (_subCatId == null) {
          subCategoryList = _res.subCategories;
          selectedSubCatIndex = null;
        }
        if (_currentDocketName == null) {
          docketNameList = _res.docketList;
          selectedDocketIndex = null;
        }
        alphaList = _res.alphaList;
      }

      if (_res.products?.isNotEmpty ?? false) {
        itemViewList.addAll(_res.products!);
      }
    }

    loading = false;
    notify;
  }

  Future<void> getComboData({
    int page = 1,
    String searchKey = "",
    String? subCatId,
  }) async {
    itemViewType = ItemViewType.combo;

    if (page == 1) {
      _subCatId = subCatId;
      if (_subCatId == null) {
        subCategoryList = null;
      }
    }

    if (page == 1 || pageIndex * _pageSize <= comboViewList.length) {
      pageIndex = page;
      final res = await Handler.getAllPosComboProducts(
        page: page,
        pageSize: _pageSize,
        catId: _subCatId ?? selectedCatId,
        channelEnum: (initAddSec?.orderTypes?.isNotEmpty ?? false) &&
                (orderTypeIndex >= 0 &&
                    orderTypeIndex < initAddSec!.orderTypes!.length)
            ? (initAddSec!.orderTypes![orderTypeIndex].orderTypeChannel
                    ?.trim() ??
                (reOrder?.orderChannelEnum?.trim()))
            : '',
        searchKey: searchKey,
        alphaId: selectedAlpha ?? "",
      );

      if (page == 1) {
        comboViewList.clear();
        if (_subCatId == null) {
          subCategoryList = res?.subCategories;
          selectedSubCatIndex = null;
        }
      }

      if (res?.comboProducts?.isNotEmpty ?? false) {
        comboViewList.addAll(res!.comboProducts!);
      }
    }

    loading = false;
    notify;
  }

  Future<void> getIngreData({
    int page = 1,
    String searchKey = "",
    String? subCatId,
  }) async {
    itemViewType = ItemViewType.ingre;

    if (page == 1) {
      _subCatId = subCatId;
      if (_subCatId == null) {
        subCategoryList = null;
      }
    }

    if (page == 1 || pageIndex * _pageSize <= ingreViewList.length) {
      pageIndex = page;
      final res = await Handler.getAllPosRawIngredients(
        page: page,
        pageSize: _pageSize,
        catId: _subCatId ?? selectedCatId,
        channelEnum: (initAddSec?.orderTypes?.isNotEmpty ?? false) &&
                (orderTypeIndex >= 0 &&
                    orderTypeIndex < initAddSec!.orderTypes!.length)
            ? (initAddSec!.orderTypes![orderTypeIndex].orderTypeChannel
                    ?.trim() ??
                (reOrder?.orderChannelEnum?.trim()))
            : '',
        searchKey: searchKey,
        alphaId: selectedAlpha ?? "",
      );

      if (page == 1) {
        ingreViewList.clear();
        if (_subCatId == null) {
          subCategoryList = res?.subCategories;
          selectedSubCatIndex = null;
        }
      }

      if (res?.rawLooseIngredientProducts?.isNotEmpty ?? false) {
        ingreViewList.addAll(res!.rawLooseIngredientProducts!);
      }
    }

    loading = false;
    notify;
  }

  ComboDetailById? comboDetailById;

  Future<void> getComboDetailById({String? id}) async {
    if (id == null) return;

    comboDetailById = await Handler.getSetMenuDetailById(id: id);

    loading = false;
    notify;
  }

  PosDataPath posDataPath = PosDataPath.Menu;
  int? selectedSubCatIndex;
  // String? alphaId = "";
  int? selectedDocketIndex;

  // Future<void> getData({
  //   bool initLoad = false,
  //   String? catId,
  // }) async {
  //   // String orderTypeId = "";
  //   String productCatId = "";
  //   String brandId = "";

  //   if (catId?.isNotEmpty ?? false) {
  //     productCatId = catId!;
  //   } else if (initRes?.productsWithCategories != null &&
  //       initRes!.productsWithCategories!.isNotEmpty &&
  //       _drawerIndex != null) {
  //     productCatId =
  //         initRes!.productsWithCategories![_drawerIndex!].categoryId ?? '';
  //   }

  //   if (initLoad) {
  //     // orderTypeIndex = 0;

  //     if (listOrderType == null) await getListOrderType();
  //   }

  //   if (initRes?.brands != null && brandIndex != null) {
  //     brandId = initRes!.brands![brandIndex!].id ?? "";
  //   }

  //   // if (listOrderType != null && listOrderType!.isNotEmpty) {
  //   //   orderTypeId = listOrderType![orderTypeIndex].id ?? '';
  //   // }

  //   final _response = await Handler.getAllPosOrSecList(
  //     orderTypeId: (listOrderType?.isNotEmpty ?? false)
  //         ? (listOrderType![orderTypeIndex].id ?? '')
  //         : '',
  //     catId: productCatId,
  //     brandId: brandId,
  //     channelEnum: (listOrderType?.isNotEmpty ?? false)
  //         ? (listOrderType![orderTypeIndex].orderTypeChannel?.trim() ??
  //             (reOrder?.orderChannelEnum?.trim()))
  //         : '',
  //   );
  //   // if (initLoad && _productsRes != null) {
  //   //   menuRes.clear();
  //   // }
  //   if (_response != null) productsRes = _response;

  //   if (productsRes == null) {
  //     loading = false;
  //     notifyListeners();
  //     return;
  //   }

  //   if (productsRes != null && productCatId.isEmpty) {
  //     DbLocalData.updateInitProd(menu: productsRes!).then((_) => getFromDB());
  //     setData();
  //   }

  //   // if (menuRes.isEmpty ||
  //   //     !menuRes
  //   //         .any((e) => e.catId.toLowerCase() == productCatId.toLowerCase())) {
  //   //   menuRes.add(MenuRes(
  //   //     catId: productCatId,
  //   //     productRes: _productsRes,
  //   //   ));
  //   // } else {
  //   //   menuRes.firstWhere((e) => e.catId == productCatId).productRes =
  //   //       _productsRes;
  //   // }

  //   // productsRes = getProductRes(
  //   //   // oTIndex: orderTypeIndex,
  //   //   drawerIndex: _drawerIndex,
  //   // );
  //   loading = false;
  //   notifyListeners();
  //   if (initLoad) getCusAddSec();
  // }

  // AllPosOrderSecRes? getProductRes({
  //   // int? oTIndex,
  //   int? drawerIndex,
  // }) {
  //   // log("$oTIndex $drawerIndex");
  //   if (menuRes.isNotEmpty) {
  //     // String _otId = "";
  //     String _pcId = "";

  //     // if (listOrderType != null && listOrderType!.isNotEmpty && oTIndex != null)
  //     //   _otId = listOrderType![oTIndex].id ?? '';

  //     if (initRes != null &&
  //         initRes!.productsWithCategories != null &&
  //         initRes!.productsWithCategories!.isNotEmpty &&
  //         drawerIndex != null) {
  //       _pcId = initRes!.productsWithCategories![drawerIndex].categoryId ?? '';
  //     }

  //     // log("ot $_otId catid $_pcId ${menuRes.length}");
  //     if (menuRes.any((e) => e.catId.toLowerCase() == _pcId.toLowerCase())) {
  //       final _menuRes = menuRes
  //           .firstWhere((e) => e.catId.toLowerCase() == _pcId.toLowerCase());
  //       // log(jsonEncode(_menuRes.productRes?.toJson()));
  //       return _menuRes.productRes;
  //     }
  //   }
  // }

  void setOrderItemDocketGroupName(
      {required String docketGroupName,
      required int index,
      required String docketGroupId,
      required dynamic docketGroupSort}) {
    if (orderList.isNotEmpty) {
      orderList[index].docketGroupName =
          docketGroupName.isNotEmpty ? docketGroupName : "";
      orderList[index].docketGroupId = docketGroupId;
      orderList[index].docketGroupName = docketGroupName;
      orderList[index].docketGroupSort = docketGroupSort.toString();
    }
    notify;
  }

  getDockeGroupInitialFromOrderItem(int index) {
    if (orderList.isNotEmpty) {
      return orderList[index].docketGroupName;
    }
    if (setMenuList.isNotEmpty) {
      return setMenuList[index].docketGroupName;
    }
    return "";
  }

  void setData() {
    if (initAddSec == null) return;

    // if (reTable) tableList = initAddSec?.tables;
    if ((initAddSec?.brands?.isNotEmpty ?? false) &&
        (initAddSec?.brands?.first.id?.isNotEmpty ?? false))
      initAddSec?.brands
          ?.insert(0, TableLocation(id: "", name: "All", value: "All"));

    staffList = initAddSec?.staffs;
    taxExclusiveInclusiveType =
        initAddSec?.storeInformation?.taxExclusiveInclusiveType;
    if (initAddSec?.storeInformation?.holidaySurcharge?.isActive ?? false) {
      holidaySurgePercentage = initAddSec
          ?.storeInformation?.holidaySurcharge?.holidaySurgePercentage;
    }
    if (initAddSec?.storeInformation?.creditCardSurCharge?.isActive ?? false) {
      creCardSurChargePercentage = initAddSec
          ?.storeInformation?.creditCardSurCharge?.creditCardSurgePercentage;
    }
    if (initAddSec?.storeInformation?.isBatch ?? false) {
      stockDeductType = "Batch";
    } else if (initAddSec?.storeInformation?.isFiFo ?? false) {
      stockDeductType = "FiFo";
    }
    GlobalCVP.stockExceedRestriction =
        !(initAddSec?.storeInformation?.enableOutOfStockSales ?? false);
  }

  // void setFeaturedProduct() {
  //   if (initRes?.productsWithCategories?.any((e) => e.isFeatured ?? false) ??
  //       false) {
  //     final _feaProductCats = initRes!.productsWithCategories!
  //         .firstWhere((e) => e.isFeatured ?? false);

  //     _feaProductCats.products = initRes!.featuredProducts;
  //     if (productsRes?.productsWithCategories
  //             ?.any((e) => e.isFeatured ?? false) ??
  //         false) {
  //       final _prodRes = productsRes?.productsWithCategories
  //           ?.firstWhere((e) => e.isFeatured ?? false);
  //       _prodRes?.products = initRes!.featuredProducts;
  //     }
  //   }
  // }

  // Future<void> scrollToItem({bool? isProduct, bool isHalf = false}) async {
  //   await Future.delayed(Duration(milliseconds: 400));
  //   // isProduct==null ? raw | false? combo | true? product
  //   //
  //   int _index = 0;
  //   if (isProduct == false) {
  //     _index = setMenuList.length;
  //   } else if (isProduct == true) {
  //     _index = setMenuList.length + orderList.length;
  //   } else {
  //     _index = setMenuList.length + orderList.length + ingreList.length;
  //   }

  //   // print("scroll to $_index, product: $isProduct, isHalf: $isHalf");

  //   OrderItems.observerController.animateTo(
  //     index: _index - 1 - (isHalf ? 1 : 0),
  //     duration: Duration(milliseconds: 1200),
  //     curve: Curves.ease,
  //   );
  // }

// upIndex : updateIndex of cart

  void updateSetMenuOnCart({int? upIndex}) {
    // setMenuList.clear();

    final setMenu = comboDetailById;

    if (setMenu == null) return;

    final quantity = setMenu.quantity;

    // if (upIndex != null) {
    //   _quantity = setMenuList[upIndex].setMenuQuantity ?? 1;
    // }

    final price = (setMenu.discountedPrice?.inDouble ?? 0) == 0
        ? setMenu.actualPrice
        : setMenu.discountedPrice;

    final _amount = OrderUtils.getAmount(
      taxTypeString: taxExclusiveInclusiveType,
      taxPercent: setMenu.taxExclusiveInclusiveValue,
      price: price,
      quantity: quantity.toDouble(),
      actualPrice: setMenu.actualPrice,
      // discountPercent: _setMenu.discountPercentage,
    );
    final setMenuOrder = SetMenuOrderDetail(id: "", orderItemsViewModels: []);

    for (final b in setMenu.setMenuProductListViewModelWithCategory!) {
      if (b.setMenuProductListViewModels!.any((c) => c.isSelected)) {
        setMenuOrder.setMenuId = setMenu.id;
        setMenuOrder.setMenuQuantity = quantity;
        setMenuOrder.initQty = quantity;
        setMenuOrder.setMenuPrice = _amount.itemPrice;
        if (itemViewList.any((e) => e.id == setMenu.id)) {
          var docketGroupName = itemViewList
                  .firstWhere((e) => e.id == setMenu.id)
                  .docketGroupName ??
              "";

          setMenuOrder.docketGroupName =
              docketGroupName.isNotEmpty ? docketGroupName.substring(0, 1) : "";
        }

        setMenuOrder.totalSetMenuPrice = _amount.totalPrice;
        setMenuOrder.setMenuName = setMenu.setMenuName;
        setMenuOrder.imgPath = setMenu.image;
        setMenuOrder.originalSellingAmount = price;
        setMenuOrder.totalTax = _amount.totalTax.roundToN().roundToNString();
        setMenuOrder.discountPercentage = setMenu.discountPercentage;
        setMenuOrder.discountWithoutTax = _amount.discount.roundToNString();
        setMenuOrder.discountWithTax = _amount.discountWithTax.roundToNString();
        setMenuOrder.actualPrice = setMenu.actualPrice;

        setMenuOrder.taxPercent = _amount.taxPercent;
        setMenuOrder.taxType = _amount.taxType;
        // _setMenuOrder.outOfStockMessage = _setMenu.outOfStockMessage;

        for (final y in b.setMenuProductListViewModels!) {
          if (y.tempComboProduct?.isNotEmpty ?? false)
            for (final f in y.tempComboProduct!) {
              // print("${f?.productName} ${f?.isSelected} ${f?.updateId}");

              if (f != null && f.isSelected) {
                final getItem = _getComboItem(
                  f: f,
                  upIndex: upIndex,
                  taxPercent: setMenu.taxExclusiveInclusiveValue,
                  setMenuQty: quantity.toDouble(),
                );

                setMenuOrder.orderItemsViewModels!.add(getItem);
              }
            }
          y.tempComboProduct = null;
        }
      }
    }
    if (setMenuOrder.orderItemsViewModels!.isNotEmpty) {
      if (upIndex != null) {
        setMenuOrder.id = setMenuList[upIndex].id;
        setMenuList[upIndex] = setMenuOrder;
      } else {
        setMenuList.insert(0, setMenuOrder);
      }
    }
    if (reOrder?.orderId != null) {
      isAnyItemJustCancelled = true;
    }

    // Future.delayed(Duration(milliseconds: 200), () {
    notify;
    //   if (upIndex == null) scrollToItem(isProduct: false);
    // });
  }

  OrderItemsViewModel _getComboItem({
    required FeaturedProduct f,
    int? upIndex,
    String? taxPercent,
    double? setMenuQty,
  }) {
    // modifiers

    List<OrderItemsPriceModifierViewModel>? modifierList;

    final _varModiList =
        f.productVariationModifiers?.whereModiType(ModifierType.modifier);

    if (_varModiList != null) {
      modifierList = [];
      for (final g in _varModiList) {
        for (final h in g.modifierItems!) {
          final _modifierAmount = OrderUtils.getAmount(
            taxTypeString: taxExclusiveInclusiveType,
            taxPercent: h.salesTax,
            price: (h.isFree ?? false)
                ? '0'
                : h.discountedPrice.inDouble != 0
                    ? h.discountedPrice
                    : h.actualPrice,
            quantity: h.quantity.toDouble(),
            orderTypeId: orderTypeId,
            taxRules: h.taxRules,
            taxRuleIndex: f.taxRuleIndex,
            isNoTax: h.isTaxExempt,
          );
          final _data = OrderItemsPriceModifierViewModel(
            id: upIndex == null ? "" : h.updateId,
            priceVariationModifierId: h.id,
            modifierName: g.name,
            modifierPrice: _modifierAmount.itemPrice.roundToN(),
            quantity: h.quantity.toDouble(),
            totalTax: _modifierAmount.totalTax.roundToN(),
            totalModifierPrice: _modifierAmount.totalPrice.roundToN(),
            labelName: g.name,
            isActive: h.isActive ?? false,
            isTaxExempt: h.isTaxExempt,
          );

          modifierList.add(_data);
          h.isActive = false;
        }
      }
    }

    // ingredients
    List<RemovedOrderItemsIngredientsViewModel>? ingredients;

    if (f.productIngredients?.isNotEmpty ?? false) {
      ingredients = [];
      for (final e in f.productIngredients!) {
        // print("ingre :: ${e.name} ${e.isActive}");
        ingredients.add(RemovedOrderItemsIngredientsViewModel(
          id: upIndex == null ? "" : (e.id ?? ''),
          name: e.name,
          isActive: e.isActive,
        ));
        e.isActive = false;
      }
    }

    // item
    return OrderItemsViewModel(
      id: upIndex == null ? "" : (f.updateId ?? ''),
      productVariationId: f.id,
      productName: f.name,
      productVariationName: f.productVariationName,
      orderItemsPriceModifierViewModels: modifierList,
      removedOrderItemsIngredientsViewModels: ingredients,
      quantity: f.quantity.toString(),
    );
  }

  void removeSetmenu(int index) {
    // if (initRes!.setMenus!.any((e) => e.id == id))
    //   for (final f in initRes!.setMenus!
    //       .firstWhere((e) => e.id == id)
    //       .setMenuProductListViewModelWithCategory!) {
    //     for (final g in f.setMenuProductListViewModels!) {
    //       g.isSelected = false;
    //     }
    //   }
    setMenuList.removeAt(index);
    notify;
  }

  void setRetailCombo(bool isSelectAll) {
    if (isSelectAll)
      comboDetailById?.setMenuProductListViewModelWithCategory?.forEach((a) {
        a.setMenuProductListViewModels?.forEach((b) {
          b.isSelected = true;
          // b.quantity = 1;
          b.tempComboProduct = [
            FeaturedProduct.fromJson(b.toJson())..isSelected = true
            // ..quantity = b.quantity
            // ..productPriceModifiers?.forEach((v) => v.isActive = true)
          ];
        });
      });
  }

  bool loadCancelItem = false;
  bool isAnyItemJustCancelled = false;

  Future<bool?> cancelPlaceOrderItem(
    BuildContext context, {
    required String orderId,
    required ItemCancelType type,
    required List<String> itemIds,
    required List<String> setmenuId,
  }) async {
    loadCancelItem = true;
    notify;

    final status = await Handler.cancelPlaceOrderItem(
      orderId: orderId,
      type: type,
      itemIds: itemIds,
      setmenuId: setmenuId,
    );

    if (status ?? false) {
      isAnyItemJustCancelled = true;
      await onPlaceOrder(
        context,
        isSentToKt: type == ItemCancelType.setmenu,
        isUpdateAfterCancelled: true,
      );
    }

    loadCancelItem = false;
    notify;

    return status;
  }

  // clearSelectedSetMenu() {
  //   if (initRes?.setMenus == null) return;
  //   for (final a in initRes!.setMenus!) {
  //     if (a.setMenuProductListViewModelWithCategory == null) return;
  //     for (final b in a.setMenuProductListViewModelWithCategory!) {
  //       if (b.setMenuProductListViewModels == null) return;
  //       for (final c in b.setMenuProductListViewModels!) {
  //         c.isSelected = false;
  //       }
  //     }
  //   }
  // }

  List<OrderItemsPriceModifierViewModel> _modiAdd({
    required ProductVariationModifier e,
    ProductType productType = ProductType.Item,
    ProductPriceType? productPriceType,
    int? orderDetailIndex,
    required double itemQty,
    required int taxRuleIndex,
    String? rootProductType,
  }) {
    final _modifierList = <OrderItemsPriceModifierViewModel>[];

    final isComboOrHalf =
        productType == ProductType.Half || productType == ProductType.Combo;

    final isDeal = productType == ProductType.Combo &&
        productPriceType == ProductPriceType.MakeYourOwn;

    final _rootProdctType = OrderUtils.prodType(rootProductType);

    for (final f in e.modifierItems!) {
      final _prodType = OrderUtils.prodType(f.productType);

      // if (f.isActive ?? false) {
      //   kPrint("Before: ${f.productName} | ${f.quantity} | $itemQty");
      //   // log(json.encode(_data.toJson()));
      // }

      final _modifierAmount = OrderUtils.getAmount(
        taxTypeString: taxExclusiveInclusiveType,
        taxPercent: f.salesTax,
        price:
            // deal's half half price
            isDeal && _prodType == ProductType.Half
                ? f.halfItemPrice?.formatDouble
                : isDeal && _rootProdctType == ProductType.Half
                    ? '0.0'
                    : isDeal && _prodType == ProductType.Item
                        ? (f.discountedPrice.inDouble != 0
                            ? f.discountedPrice
                            : f.actualPrice)
                        : ((isComboOrHalf && !isDeal) ||
                                    (isDeal && f.productType != null)) ||
                                (f.isFree ?? false)
                            ? '0'
                            : f.discountedPrice.inDouble != 0
                                ? f.discountedPrice
                                : f.actualPrice,
        quantity: (f.isActive ?? false) ? (f.quantity * itemQty) : f.quantity,
        orderTypeId: orderTypeId,
        taxRules: f.taxRules,
        taxRuleIndex: taxRuleIndex,
        isNoTax: f.isTaxExempt,
      );

      // if (f.isActive ?? false) {
      //   // log(json.encode(e.toJson()));
      //   kPrint(
      //       "${f.productName} ${f.halfItemPrice} $productType $isComboOrHalf $productPriceType");
      // }

      final _data = OrderItemsPriceModifierViewModel(
        id: orderDetailIndex == null ? "" : f.updateId,
        priceVariationModifierId: f.id,
        modifierName: isComboOrHalf
            ? (f.productName ?? '') +
                ((f.variationName?.trim().isNotEmpty ?? false)
                    ? " (${f.variationName ?? ''})"
                    : "")
            : f.productName,
        modifierPrice: _modifierAmount.itemPrice.roundToN(),
        quantity: (f.isActive ?? false) ? (f.quantity * itemQty) : f.quantity,
        totalTax: _modifierAmount.totalTax.roundToN(),
        totalModifierPrice: _modifierAmount.totalPrice.roundToN(),
        labelName: e.name,
        isActive: f.isActive ?? false,
        estimatedTime: f.estimatedTime,
        isHalforCombo: isComboOrHalf,
        type: f.productType,
        taxPercent: _modifierAmount.taxPercent.formatDouble,
        taxRules: f.taxRules,
        isTaxExempt: f.isTaxExempt,
        isDealsHalf: isDeal && _prodType == ProductType.Half,
        isDealModifier: isDeal && f.productType == null,
        variationName: f.variationName,
      );

      // if (f.isActive ?? false) {
      //   kPrint(
      //       "After:  ${f.productName} | ${f.quantity} |${_data.quantity} | $itemQty");
      //   // log(json.encode(_data.toJson()));
      // }

      if (isComboOrHalf && f.modifierItemModifiers != null) {
        final _moreModi = <OrderItemsPriceModifierViewModel>[];

        for (final g in f.modifierItemModifiers!) {
          _moreModi.addAll(_modiAdd(
              e: g,
              orderDetailIndex: orderDetailIndex,
              itemQty: itemQty,
              taxRuleIndex: taxRuleIndex,
              productType: isDeal ? productType : ProductType.Item,
              productPriceType: isDeal ? productPriceType : null,
              rootProductType: isDeal ? f.productType : null));
        }

        _data.modifierItemsModifierViewModels ??= [];
        _data.modifierItemsModifierViewModels?.addAll(_moreModi);
      }

      _modifierList.add(_data);
    }

    return _modifierList;
  }

  Future<bool> updateOrderCart({
    required FeaturedProduct product,
    ProductVariation? variation,
    String? catId,
    // String? catTypeId,
    int? orderDetailIndex,
    String? customDesc,
    // List<OrderItemSelectOptionsViewModels>? orderItemSelectOptionsViewModel,
    String? customPrice,
    bool isVarianceUpdate = false,
  }) async {
    //check item is on hold or not
    if (orderList
        .any((a) => a.productId?.toLowerCase() == product.id?.toLowerCase())) {
      final _dupOrderList = orderList
          .where((a) => a.productId?.toLowerCase() == product.id?.toLowerCase())
          .toList();
      if (_dupOrderList.any((b) =>
          OrderUtils.getStatusEnum(b.statusId) == OrderStatusEnum.hold)) {
        final _status = await showDialog(
            context: CUS_CTX!,
            builder: (_) => ConfirmDialog(
                  title:
                      "${product.name ?? ''} is already on hold in your cart",
                  titleSize: 18,
                  subTitle:
                      "The item is already on hold, Do you want to add it again?",
                  actionText: LN.yes,
                  cancelText: LN.cancel,
                  onDelete: () async {
                    return true;
                  },
                ));
        if (_status != null && _status is bool && _status) {
        } else {
          return false;
        }
      }
    }
    // log(json.encode(product.toJson()));

    //
    final _prodType = OrderUtils.prodType(product.productType);
    // final _prodPriceType =
    //     OrderUtils.productPriceType(product.productPriceType);
    final isHalfnHalf = _prodType == ProductType.Half;
    final isCombo = _prodType == ProductType.Combo;

    // final _isDeal = _prodType == ProductType.Combo &&
    //     _prodPriceType == ProductPriceType.HighestPrice;

    // final _promDiscount =
    //     OrderUtils.getPromDiscount(variation?.discountedPromotions);

    final _finalItemPriceString = isHalfnHalf
        ? variation?.actualPrice
        // : ((_promDiscount?.isOfferStart ?? false) &&
        //         (_promDiscount?.tsCount?.inDouble ?? 0) <= product.quantity)
        //     ? _promDiscount?.discountedPrice
        : variation?.discountedPrice.inDouble != null &&
                ((variation?.discountedPrice.inDouble ?? 0) > 0 ||
                    (variation?.discountPercentage?.inDouble ?? 0) >= 99)
            ? variation?.discountedPrice
            : variation?.actualPrice;

    final _comboAdditionalPrice = isCombo
        ? (variation?.productVariationModifiers?.fold<double>(
                0,
                (e1, v1) =>
                    e1 +
                    (v1.modifierItems?.fold<double>(
                            0,
                            (e2, v2) =>
                                e2 +
                                ((v2.isActive ?? false)
                                    ? (v2.additionalPrice?.inDouble ?? 0.0)
                                    : 0.0)) ??
                        0.0)) ??
            0.0)
        : 0.0;

    final finalItemPrice = ((_finalItemPriceString?.inDouble ?? 0) +
            (isHalfnHalf
                ? (variation?.additionalPrice?.inDouble ?? 0)
                : _comboAdditionalPrice))
        .roundToNString();

    final _nonPromPrice = (variation?.discountedPrice.inDouble != null &&
            ((variation?.discountedPrice.inDouble ?? 0) > 0 ||
                (variation?.discountPercentage?.inDouble ?? 0) >= 99))
        ? variation?.discountedPrice
        : variation?.actualPrice;

    final _actualPrice =
        ((variation?.actualPrice?.inDouble ?? 0) + _comboAdditionalPrice)
            .formatDouble;

    // log(jsonEncode(product.toJson()));
    final _amount = OrderUtils.getAmount(
      taxTypeString: taxExclusiveInclusiveType,
      taxPercent: product.salesTax,
      price: customPrice ?? finalItemPrice,
      quantity: product.quantity,
      actualPrice:
          isHalfnHalf || (variation?.discountedPrice.inDouble ?? 0) <= 0
              ? null
              : _actualPrice,
      orderTypeId: orderTypeId,
      taxRules: product.taxRules,
      taxRuleIndex: product.taxRuleIndex,
      isNoTax: product.isTaxExempt,
    );

    // modifiers

    List<OrderItemsPriceModifierViewModel>? _modifierList;

    final _varModiList = variation?.productVariationModifiers;

    if (_varModiList != null) {
      _modifierList = [];
      if (!isHalfnHalf)
        _varModiList.sort((_a, _b) => _b.name != null && _a.name != null
            ? _b.name!.compareTo(_a.name!)
            : 0);
      for (final e in _varModiList) {
        if (e.modifierItems != null) {
          final _data = _modiAdd(
            e: e,
            productType: OrderUtils.prodType(product.productType),
            productPriceType:
                OrderUtils.productPriceType(product.productPriceType),
            orderDetailIndex: orderDetailIndex,
            itemQty: product.quantity,
            taxRuleIndex: product.taxRuleIndex,
          );
          _modifierList.addAll(_data);
        }
      }
    }

    // filter options
    List<OrderItemSelectOptionsViewModels>? _selectedFilters;
    List<DeletedOrderItemId>? _deletedFiterOptionList;
    final _selectedFilter = getSelectedFilter();

    if (isVarianceUpdate && _selectedFilter != null) {
      _selectedFilters = [];
      _deletedFiterOptionList = [];

      for (final b in _selectedFilter) {
        if (b.isDeleted == null || b.isDeleted == false) {
          _selectedFilters.add(b);
        } else if (b.id?.isNotEmpty ?? false) {
          _deletedFiterOptionList.add(DeletedOrderItemId(id: b.id!));
        }
      }
    }

    // log(json.encode(_selectedFilters?.map((e) => e.toJson()).toList()));

    // spice choice

    // OrderItemSpiceChoiceViewModel? _spices;

    // final _spiceList =
    //     variation?.productVariationModifiers?.whereModiType(ModifierType.spice);

    // final _spice = (_spiceList?.isNotEmpty ?? false) ? _spiceList?.first : null;

    // if (product.selectedSpiceId != null &&
    //     (_spice?.modifierItems?.any((e) =>
    //             e.id?.toLowerCase() ==
    //             product.selectedSpiceId?.toLowerCase()) ??
    //         false)) {
    //   final _spiceTemp = _spice!.modifierItems!.firstWhere(
    //       (e) => e.id?.toLowerCase() == product.selectedSpiceId?.toLowerCase());
    //   _spices = OrderItemSpiceChoiceViewModel(
    //     id: orderDetailIndex == null
    //         ? ""
    //         : (product.spiceUpdateId ??
    //             ''), // is updated below if there is an id
    //     spiceChoiceId: _spiceTemp.id,
    //     name: _spiceTemp.name,
    //   );
    //   product.selectedSpiceId = null;
    // }

    // ingredients
    // List<RemovedOrderItemsIngredientsViewModel>? _ingredients;

    // final _ingreList = variation?.productVariationModifiers
    //     ?.whereModiType(ModifierType.rawingre);

    // final _ingre = (_ingreList?.isNotEmpty ?? false) ? _ingreList?.first : null;

    // if (_ingre?.modifierItems?.isNotEmpty ?? false) {
    //   _ingredients = [];
    //   for (final e in _ingre!.modifierItems!) {
    //     _ingredients.add(RemovedOrderItemsIngredientsViewModel(
    //       id: orderDetailIndex == null ? "" : (e.id ?? ''),
    //       name: e.name,
    //       isActive: e.isActive ?? false,
    //     ));
    //     e.isActive = false;
    //   }
    // }

    // staffs
    List<OrderItemsServiceEmployeeViewModel>? staffList;

    if (variation?.productVariationServiceEmployees?.isNotEmpty ?? false) {
      staffList = [];
      for (final e in variation!.productVariationServiceEmployees!) {
        staffList.add(OrderItemsServiceEmployeeViewModel(
          id: orderDetailIndex == null ? "" : (e.updateId ?? ''),
          employeeId: e.id,
          isSelected: e.isSelected,
        ));
        e.isSelected = false;
      }
    }

    String? _batchNumber;
    String? _batchId;
    bool _isbatchExpired = false;
    String? _batchStock;

    if (variation?.productVariationBatchStocks?.any((e) => e.isActive) ??
        false) {
      final batchData =
          variation?.productVariationBatchStocks?.firstWhere((e) => e.isActive);
      _batchNumber = batchData?.batchNumber;
      _batchId = batchData?.batchId;
      _batchStock = batchData?.stockCount;
      try {
        if (batchData?.expiryDate?.isNotEmpty ?? false)
          _isbatchExpired = GET_DATE_FORMAT(dateFormat ?? '')
                  .parse(batchData?.expiryDate ?? '')
                  .difference(DateTime.now())
                  .inDays <
              0;
      } catch (e) {
        //
      }
      // _batchData?.isActive = false;
    }

    if (orderDetailIndex != null && variation != null
        //  && orderList[orderDetailIndex].productVariationId?.toLowerCase() == variation.id?.toLowerCase()

        ) {
      //   if (orderList[orderDetailIndex].orderItemSpiceChoiceViewModel?.id !=
      //           null &&
      //       _spices != null) {
      //     _spices.id =
      //         orderList[orderDetailIndex].orderItemSpiceChoiceViewModel?.id;
      //   }

      orderList[orderDetailIndex]
        ..productName = (product.name ?? '') //+ ' (${variation.name ?? ''})'
        ..productPrice = _amount.itemPrice
        ..quantity = product.quantity
        ..initQty = product.quantity
        ..productVariationId = variation.id
        ..total = _amount.totalPrice.roundToN()
        ..productVariationName = variation.name
        ..originalSellingAmount = _amount.itemPrice.roundToNString()
        ..discountPercentage = variation.discountPercentage
        ..discountWithoutTax = _amount.discount.roundToNString()
        ..discountWithTax = _amount.discountWithTax.roundToNString()
        ..totalTax = _amount.totalTax.roundToN().roundToNString()
        ..unitCost = variation.unitPrice
        // ..categoryTypeId = catTypeId
        ..docketGroupName = product.docketGroupName
        ..docketGroupId = product.docketGroupId
        // not in use for server request
        ..imgPath = product.imageUrl
        ..taxPercent = _amount.taxPercent
        ..taxType = _amount.taxType
        ..actualPrice = variation.actualPrice
        ..orderItemModifiersViewModels = _modifierList
        ..orderItemSelectOptionsViewModels = _selectedFilters
        // ..deletedOrderItemModifierIds = _deletedModifierList
        ..deletedOrderItemSelectOptionsIds = _deletedFiterOptionList
        // ..orderItemSpiceChoiceViewModel = _spices
        ..totalTax = _amount.totalTax.roundToN().roundToNString()
        ..docketGroupName = product.docketGroupName
        ..docketGroupSort = product.docketGroupSort
        ..enableDocketGroupSpliter = product.enableDocketGroupSpliter ?? false
        // ..removedOrderItemsIngredientsViewModels = _ingredients
        // ..promDiscount = _promDiscount
        ..nonPromPrice = _nonPromPrice
        ..batchNumber = _batchNumber
        ..batchId = _batchId
        ..isBatchExpired = _isbatchExpired
        ..orderItemsServiceEmployeeViewModels = staffList
        ..outOfStockMessage = variation.outOfStockMessage
        ..bookedTime = variation.estimatedTime
        ..productType = product.productType
        ..productPriceType = product.productPriceType
        ..customPrice = customPrice
        ..taxRules = product.taxRules
        ..taxRuleIndex = product.taxRuleIndex
        ..preparationType = (product.taxRules?.isNotEmpty ?? false)
            ? (product.taxRules?[product.taxRuleIndex].taxRuleName ?? '')
            : "";
    } else {
      final _newKey = Utils.getRandomString(8);
      orderList.insert(
        0,
        OrderDetail(
          productId: product.id,
          productName: (product.name ?? '')
          // + (variation?.name != null && variation!.name!.isNotEmpty ? " (${variation.name})" : "")
          ,
          productPrice: _amount.itemPrice,
          quantity: product.quantity,
          description: customDesc ?? "",
          initQty: product.quantity,
          productVariationId: variation?.id,
          total: _amount.totalPrice,
          productVariationName: variation?.name,
          originalSellingAmount: _amount.itemPrice.roundToNString(),
          discountPercentage: variation?.discountPercentage,
          discountWithoutTax: _amount.discount.roundToNString(),
          discountWithTax: _amount.discountWithTax.roundToNString(),
          totalTax: _amount.totalTax.roundToN().roundToNString(),
          unitCost: variation?.unitPrice,
          // categoryTypeId: catTypeId,

          // not in use for server request
          imgPath: product.imageUrl,
          taxPercent: _amount.taxPercent,
          taxType: _amount.taxType,
          catId: catId,
          // drawerI: getDI,
          // orderTypeI: orderTypeIndex,
          actualPrice: variation?.actualPrice,
          key: _newKey,
          orderItemModifiersViewModels: _modifierList,
          stockCount: double.tryParse(variation?.stockCount ?? '')?.floor(),
          orderItemSelectOptionsViewModels: _selectedFilters,
          // orderItemSpiceChoiceViewModel: _spices,
          docketGroupName: product.docketGroupName,
          docketGroupSort: product.docketGroupSort,
          enableDocketGroupSpliter: product.enableDocketGroupSpliter ?? false,
          // removedOrderItemsIngredientsViewModels: _ingredients,
          // promDiscount: _promDiscount,
          nonPromPrice: _nonPromPrice,
          batchNumber: _batchNumber,
          batchId: _batchId,
          isBatchExpired: _isbatchExpired,
          batchStock: double.tryParse(_batchStock ?? '')?.floor(),
          orderItemsServiceEmployeeViewModels: staffList,
          outOfStockMessage: variation?.outOfStockMessage,
          bookedTime: variation?.estimatedTime,
          productType: product.productType,
          productPriceType: product.productPriceType,
          statusId: OrderUtils.getStatusId(OrderStatusEnum.release),
          customPrice: customPrice,
          taxRules: product.taxRules,
          taxRuleIndex: product.taxRuleIndex,
          preparationType: (product.taxRules?.isNotEmpty ?? false)
              ? (product.taxRules?[product.taxRuleIndex].taxRuleName ?? '')
              : "",
        ),
      );
    }

    // log(json.encode(orderList.map((e) => e.toJson()).toList()));
    if (reOrder?.orderId != null) {
      isAnyItemJustCancelled = true;
    }

    notify;
    // if (orderDetailIndex == null) scrollToItem(isProduct: true);
    return true;
  }

  List<OrderItemSelectOptionsViewModels>? getSelectedFilter() {
    if (productDetailView?.filterCategoriesWithChildernFilterOptions == null)
      return null;
    final fiterData = <OrderItemSelectOptionsViewModels>[];

    for (final a
        in productDetailView!.filterCategoriesWithChildernFilterOptions!) {
      final data = OrderItemSelectOptionsViewModels(
          id: a.id,
          filterTypeId: a.filterCategoryId,
          selectOptionName: a.filterCategoryName,
          selectOptionValue: a.filterTypeOptions!
              .where((c) => c.isSelected)
              .map((d) => d.filterCategoryOptionName ?? '')
              .toList()
              .join(","),
          filterTypeOptionsId: a.filterTypeOptions!
              .where((c) => c.isSelected)
              .map((d) => d.filterCategoryOptionId ?? '')
              .toList()
              .join(","));

      // log(jsonEncode(_data.toJson()));
      if (a.childernCategories != null &&
          a.childernCategories!.isNotEmpty &&
          a.childSelectedIndex != null) {
        final optionValue = <String>[];
        final optionId = <String>[];

        for (final e in a.childernCategories!) {
          if (e.filterTypeOptions != null &&
              e.filterTypeOptions!.any((f) => f.isSelected)) {
            final selected = e.filterTypeOptions!.where((g) => g.isSelected);

            optionId.addAll(
                selected.map((i) => i.filterCategoryOptionId ?? '').toList());

            optionValue.addAll(selected
                .map((h) =>
                    "${e.filterCategoryName ?? ''}(${h.filterCategoryOptionName ?? ''})")
                .toList());
          }
        }
        if (optionId.isNotEmpty) {
          fiterData.add(
            OrderItemSelectOptionsViewModels(
              id: a.id,
              filterTypeId: a.filterCategoryId,
              selectOptionName: a.filterCategoryName,
              selectOptionValue: optionValue.join(','),
              filterTypeOptionsId: optionId.join(','),
            ),
          );
        }
      } else if (a.filterTypeOptions != null &&
          a.filterTypeOptions!.any((b) => b.isSelected)) {
        fiterData.add(data..isDeleted = null);
      } else if (a.id?.isNotEmpty ?? false) {
        fiterData.add(data..isDeleted = true);
        // print("2. deleted Id : ${a.id}");
      }
    }

    // log(jsonEncode(_fiterData.map((e) => e.toJson()).toList()));

    return fiterData;
  }

  void updateRawCre({
    RawLooseIngredientProduct? rawIngredient,
    double quantity = 0.0,
    int? cartIndex,
  }) {
    final _amount = OrderUtils.getAmount(
      taxTypeString: taxExclusiveInclusiveType,
      taxPercent: rawIngredient?.salesTax,
      price: rawIngredient?.sellingPricePerUnit,
      quantity: quantity,
    );

    final rawIngre = RawIngredientOrderDetail(
      id: cartIndex != null ? ingreList[cartIndex].id : "",
      unitOfMeasurementId: rawIngredient?.unitOfMeasurementId,
      rawIngredientId: rawIngredient?.id,
      originalSellingPricePerUnit:
          double.tryParse(rawIngredient?.sellingPricePerUnit ?? ''),
      quantity: quantity,
      totalSellingPrice: _amount.totalPrice.roundToNString(),
      totalTax: _amount.totalTax.roundToNString(),

      ///
      name: rawIngredient?.name,
      stockCount: double.tryParse(rawIngredient?.availiableStock ?? ''),
      taxPercent: _amount.taxPercent,
      taxType: _amount.taxType,
      initQty: quantity,
      //  outOfStockMessage: rawIngredient?.outOfStockMessage,
    );

    if (cartIndex != null)
      ingreList[cartIndex] = rawIngre;
    else
      ingreList.insert(0, rawIngre);

    if (reOrder?.orderId != null) {
      isAnyItemJustCancelled = true;
    }
    notify;

    // if (cartIndex == null) scrollToItem(isProduct: null);
  }

  // AmountClass getAmount({
  //   String? taxTypeString,
  //   String? taxPercent,
  //   String? price,
  //   int? quantity,
  // }) {
  //   double _taxPercent = 0.0;
  //   double _taxValue = 0.0;
  //   double _price = 0.0;
  //   int _quantity = quantity ?? 1;

  //   final _taxType = Utils.getTaxType(taxTypeString);

  //   if (taxPercent != null && _taxType != TaxType.NoTax) {
  //     _taxPercent = (double.tryParse(taxPercent) ?? 0.0);
  //   }

  //   if (price != null && price.isNotEmpty) {
  //     _price = double.tryParse(price) ?? 0.0;
  //   }

  //   if (_taxType == TaxType.Inclusive) {
  //     _taxValue = _taxPercent / (100 + _taxPercent);
  //   } else if (_taxType == TaxType.Exclusive) {
  //     _taxValue = _taxPercent / 100;
  //   }

  //   return AmountClass()
  //     ..taxPercent = _taxPercent
  //     ..price = _price
  //     ..taxType = _taxType
  //     ..totalTax = _taxValue * _price * _quantity
  //     ..totalPrice = _price * _quantity;
  // }

  String get orderTypeId => (initAddSec?.orderTypes?.isNotEmpty ?? false) &&
          (orderTypeIndex >= 0 &&
              orderTypeIndex < initAddSec!.orderTypes!.length)
      ? (initAddSec?.orderTypes?[orderTypeIndex].id ?? '')
      : "";

  AmountClass get getAllAmount {
    final _amount = OrderUtils.orderAmount(
      setMenuList: setMenuList,
      orderList: orderList,
      ingreList: ingreList,
      taxTypeString: taxExclusiveInclusiveType ?? '',
      onPayScreenFor: OnPayScreenFor.Cart,
      orderTypeId: orderTypeId,
    );

    double tempTaxRate = 0.0;

    if (_amount.taxType == TaxType.Inclusive) {
      tempTaxRate = (taxPercentDDS / (100 + taxPercentDDS));
    } else if (_amount.taxType == TaxType.Exclusive) {
      tempTaxRate = (taxPercentDDS / 100);
    }

    /// delivery ////////
    if (isDelivery) {
      final deliveryAmt = double.tryParse(delivertAmtCltr.text) ?? 0;
      final deliveryTax = deliveryAmt * tempTaxRate;

      _amount.totalTax += deliveryTax;

      if (_amount.taxType == TaxType.Inclusive) {
        _amount.totalPrice += deliveryAmt;
      } else {
        _amount.totalPrice += deliveryAmt + deliveryTax;
      }
    }
    // final _amount = AmountClass();
    // for (final a in setMenuList) {
    //   _amount.taxType = a.taxType ?? TaxType.NoTax;
    //   if (a.totalSetMenuPrice != null) {
    //     _amount.price += a.totalSetMenuPrice!;
    //     double _taxValue = 0.0;
    //     if (a.taxType == TaxType.Inclusive) {
    //       _taxValue = a.taxPercent / (100 + a.taxPercent);
    //     } else {
    //       _taxValue = a.taxPercent / 100;
    //     }
    //     _amount.totalTax += a.totalSetMenuPrice! * _taxValue;
    //   }
    // }

    // for (final b in orderList) {
    //   _amount.taxType = b.taxType!;
    //   if (b.total != null) {
    //     final _mTotal = b.orderItemsPriceModifierViewModels
    //         ?.fold<double>(0, (pV, e) => pV + (e.totalModifierPrice ?? 0));

    //     double _totalItemPrice = b.total! + (_mTotal ?? 0);

    //     _amount.price += _totalItemPrice;
    //     double _taxValue = 0.0;
    //     if (b.taxType == TaxType.Inclusive) {
    //       _taxValue = b.taxPercent / (100 + b.taxPercent);
    //     } else {
    //       _taxValue = b.taxPercent / 100;
    //     }

    //     _amount.totalTax += _totalItemPrice * _taxValue;
    //   }
    // }

    // if (_amount.taxType == TaxType.Inclusive) {
    //   _amount.totalPrice = _amount.price;
    // } else {
    //   _amount.totalPrice = (_amount.price + _amount.totalTax);
    // }

    return _amount;
  }

  // AmountClass get _getAmountForRemovalItem {
  //   final _amount = Utils.orderAmount(
  //       setMenuList: setMenuList,
  //       orderList: orderList,
  //       ingreList: ingreList,
  //       taxTypeString: taxExclusiveInclusiveType ?? '',
  //       onPayScreenFor: OnPayScreenFor.Cart);

  //   double _tempTaxRate = 0.0;

  //   if (_amount.taxType == TaxType.Inclusive) {
  //     _tempTaxRate = (taxPercentDDS / (100 + taxPercentDDS));
  //   } else if (_amount.taxType == TaxType.Exclusive) {
  //     _tempTaxRate = (taxPercentDDS / 100);
  //   }

  //   /// delivery ////////
  //   if (isDelivery && _amount.totalPrice != 0) {
  //     final _deliveryAmt = double.tryParse(delivertAmtCltr.text) ?? 0;
  //     final _deliveryTax = _deliveryAmt * _tempTaxRate;

  //     _amount.totalTax += _deliveryTax;

  //     if (_amount.taxType == TaxType.Inclusive) {
  //       _amount.totalPrice += _deliveryAmt;
  //     } else {
  //       _amount.totalPrice += _deliveryAmt + _deliveryTax;
  //     }
  //   }

  //   return _amount;
  // }

  ReOrder? reOrder;
  String? stockDeductType;

  Future<bool?> onPlaceOrder(
    BuildContext context, {
    bool isSentToKt = false,
    String? cusName,
    bool isUpdateAfterCancelled = false,
    Future<void> Function()? runFun,
  }) async {
    // if (!(GlobalCVP.isRetailScreen ?? false)) return null;

    // placeOrderRes = null;
    placeOrderInfo = null;

    final placeOrder = PlaceOrderReq();
    placeOrder.orderId = reOrder?.orderId ?? '';

    placeOrder.deviceIdentifierId = GlobalCVP.userStoresRes?.id;
    placeOrder.isSendToKitchenPrinter =
        GlobalCVP.storeInfo?.isSendToKitchenPrinter;
    placeOrder.isSendToKitchenDisplay =
        GlobalCVP.storeInfo?.isSendToKitchenDisplay;

    if (cusName?.isNotEmpty ?? false) {
      // _placeOrder.customerName = cusName;
      placeOrder.customerAddRequestModel = CustomerViewModel(
        id: _customerId ?? '',
        name: cusNameCltr.text,
        email: cusEmailCltr.text,
        phoneNumber: cusPhoneCltr.text,
        postalCode: cusPostalCodeCltr.text,
        isMarketingPromotionEnabled: _isLoyalEnabled,
        isLoyaltyEnabled: _isMarketEnabled,
      );
      if (customerTypeIndex != null &&
          (customerAddSecRes?.customerType?.isNotEmpty ?? false)) {
        placeOrder.customerAddRequestModel?.customerTypeId =
            customerAddSecRes!.customerType![customerTypeIndex!].id;
      }

      if (countryIndex != null &&
          (customerAddSecRes?.countries?.isNotEmpty ?? false)) {
        placeOrder.customerAddRequestModel?.countryId =
            customerAddSecRes!.countries![countryIndex!].id;
      }

      if (phoneCodeIndex != null &&
          (customerAddSecRes?.countries?.isNotEmpty ?? false)) {
        placeOrder.customerAddRequestModel?.countryPhoneNumberPrefixId =
            customerAddSecRes!.countries![phoneCodeIndex!].id;
      }

      final deliAmount = double.tryParse(delivertAmtCltr.text);

      if (deliAmount != null) {
        placeOrder.orderDeliveryRequestModel ??= OrderDeliveryRequestModel();
        placeOrder.orderDeliveryRequestModel?.id = "";
        placeOrder.orderDeliveryRequestModel?.latitude = "$_lat";
        placeOrder.orderDeliveryRequestModel?.longitude = "$_long";
        placeOrder.orderDeliveryRequestModel?.pickUpDeliveryDateTime =
            dateTimeCltr.text;
        placeOrder.orderDeliveryRequestModel?.pickUpDeliveryNote =
            deliNoteCltr.text;
        placeOrder.orderDeliveryRequestModel?.distanceInKm =
            deliveryDisRes?.distanceInKm;
        placeOrder.orderDeliveryRequestModel?.distanceInMile =
            deliveryDisRes?.distanceInMile;

        if (selectedCusDeliveryIndex != null && cusDeliveryData.isNotEmpty) {
          final deliData = cusDeliveryData[selectedCusDeliveryIndex!];
          placeOrder.orderDeliveryRequestModel?.id = deliData.id;
          placeOrder.orderDeliveryRequestModel?.deliveryLocation =
              deliData.deliveryLocation;
          placeOrder.orderDeliveryRequestModel?.latitude = deliData.latitude;
          placeOrder.orderDeliveryRequestModel?.longitude = deliData.longitude;
        } else if (addressCltr.text.isNotEmpty) {
          placeOrder.orderDeliveryRequestModel?.deliveryLocation =
              addressCltr.text;
        }

        if (getTaxType == TaxType.Inclusive) {
          placeOrder.orderDeliveryRequestModel?.deliveryAmount =
              (deliAmount * (1 - getTaxCoff)).roundToNString();
          placeOrder.orderDeliveryRequestModel?.deliveryAmountWithTax =
              deliAmount.roundToNString();
        } else {
          placeOrder.orderDeliveryRequestModel?.deliveryAmount =
              deliAmount.roundToNString();
          placeOrder.orderDeliveryRequestModel?.deliveryAmountWithTax =
              (deliAmount * (1 + getTaxCoff)).roundToNString();
        }
      }
    }

    // if (initRes!.orderTypes != null)
    //   _placeOrder.orderTypeStoreId =
    //       initRes!.orderTypes![orderTypeIndex ?? 0].id;

    if (initAddSec?.orderTypes?.isNotEmpty ?? false) {
      if (initAddSec!.orderTypes!.length > orderTypeIndex) {
        placeOrder.orderTypeStoreId =
            initAddSec?.orderTypes![orderTypeIndex].id;
      } else {
        IfException.showMessage(message: "Please select order type");
        return null;
      }
    }

    // if (tableList != null && tableList!.isNotEmpty && tableIndex != null)
    //   _placeOrder.tableId = tableList![tableIndex!].id;
    placeOrder.tables = tableIdName;
    placeOrder.orderTabId = orderTabId;

    if (staffList != null && staffList!.isNotEmpty && waiterIndex != null)
      placeOrder.staffId = staffList![waiterIndex!].id;

    placeOrder.noOfCustomerOnTable = noOfCustomer.text;

    // _amount.price.roundToNString();

    placeOrder.description = descCltr.text;

    orderList.forEach((a) {
      final _modifierTotalEstTime = a.orderItemModifiersViewModels?.fold<int>(0,
              (pV, eV) => pV + (int.tryParse(eV.estimatedTime ?? '') ?? 0)) ??
          0;

      final totalEstTime =
          (((int.tryParse(a.bookedTime ?? '') ?? 0) + _modifierTotalEstTime) *
                  (a.quantity?.floor() ?? 0))
              .toString();
      a.bookedTime = totalEstTime;
    });

    if (isUpdateAfterCancelled) {
      // final _amount = _getAmountForRemovalItem;
      // final _totalAmt =
      //     _amount.totalPrice * (1 - ((reOrder?.discountPer ?? 0) / 100)) +
      //         (reOrder?.itemPaidChargeIfOrderUpdate ?? 0);

      placeOrder.totalAmount = '0.00'; // _totalAmt.nonNan().roundToNString();
      placeOrder.taxAmount =
          '0.00'; // _amount.totalTax.nonNan().roundToNString();
      placeOrder.totalWithoutTaxAmount = '0.00';
      // (_amount.totalPrice.nonNan() - _amount.totalTax.nonNan())
      //     .roundToNString();
      placeOrder.orderDeliveryRequestModel?.deliveryAmount = '0.00';

      placeOrder.orderDeliveryRequestModel?.deliveryAmountWithTax = '0.00';

      placeOrder.orderDetails = [];
      for (final a in orderList) {
        if (a.id != null && a.id!.isNotEmpty) {
          placeOrder.orderDetails!.add(a);
        }
      }

      placeOrder.setMenuOrderDetails = [];
      for (final b in setMenuList) {
        if (b.id != null && b.id!.isNotEmpty) {
          if (b.orderItemsViewModels != null) {
            final itemList = <OrderItemsViewModel>[];
            for (final c in b.orderItemsViewModels!) {
              if (!c.isCancelled) {
                itemList.add(c);
              }
            }
            b.orderItemsViewModels = itemList;
          }

          placeOrder.setMenuOrderDetails!.add(b);
        }
      }

      placeOrder.rawIngredientOrderDetails = [];
      for (final a in ingreList) {
        if (a.id != null && a.id!.isNotEmpty) {
          placeOrder.rawIngredientOrderDetails!.add(a);
        }
      }
    } else {
      final _amount = getAllAmount;

      final _totalAmt = (reOrder?.paymentType == 2)
          ? (_amount.totalPrice -
              (reOrder?.paidDiscount ?? 0.0) +
              (reOrder?.itemPaidChargeIfOrderUpdate ?? 0.0))
          : (_amount.totalPrice * (1 - ((reOrder?.discountPer ?? 0) / 100))) +
              (reOrder?.itemPaidChargeIfOrderUpdate ?? 0);

      // kPrint(
      //     "_totalAmt $_totalAmt | totalPrice ${_amount.totalPrice} | paidDiscount:  ${reOrder?.paidDiscount} itemPaidChargeIfOrderUpdate: ${reOrder?.itemPaidChargeIfOrderUpdate} | paymentType: ${reOrder?.paymentType} | discountPer: ${reOrder?.discountPer}");

      placeOrder.totalAmount = _totalAmt.nonNan().roundToNString();
      placeOrder.taxAmount = _amount.totalTax.nonNan().roundToNString();

      placeOrder.totalWithoutTaxAmount =
          (_amount.totalPrice.nonNan() - _amount.totalTax.nonNan())
              .roundToNString();

      // order details //

      final placedOrderList = List<OrderDetail>.from(
          List<dynamic>.from(orderList.map((x) => x.toJson()))
              .map((y) => OrderDetail.fromJson(y)));

      placeOrder.orderDetails = placedOrderList.map((e) {
        //modifiers
        List<OrderItemsPriceModifierViewModel>? _modifierList;
        List<DeletedOrderItemId>? _deletedModifierList;
        List<DeletedOrderItemId>? _deletedDeepModifierList;
        List<DeletedOrderItemId>? _deletedDoubleDeepModifierList;

        // log(json.encode(
        //     e.orderItemModifiersViewModels?.map((e) => e.toJson()).toList()));

        if (e.orderItemModifiersViewModels != null) {
          _modifierList = [];
          _deletedModifierList = [];
          _deletedDeepModifierList = [];
          _deletedDoubleDeepModifierList = [];
          for (final a in e.orderItemModifiersViewModels!) {
            // log(json.encode(a.modifierItemsModifierViewModels
            //     ?.map((e) => e.toJson())
            //     .toList()));

            if (a.modifierItemsModifierViewModels != null) {
              for (final b in a.modifierItemsModifierViewModels!) {
                // log("${b.modifierName} ${b.isActive} ${b.id}");
                if (!b.isActive && (b.id?.isNotEmpty ?? false)) {
                  _deletedDeepModifierList.add(DeletedOrderItemId(id: b.id));
                }

                if (b.modifierItemsModifierViewModels != null) {
                  for (final c in b.modifierItemsModifierViewModels!) {
                    // log("${b.modifierName} ${b.isActive} ${b.id}");
                    if (!c.isActive && (c.id?.isNotEmpty ?? false)) {
                      _deletedDoubleDeepModifierList
                          .add(DeletedOrderItemId(id: c.id));
                    }
                  }
                }
              }
            }
            if (a.isActive) {
              final _modiList = _placeModiList(
                  orderItemsPriceModifierViewModels:
                      a.modifierItemsModifierViewModels);
              _modifierList.add(a..modifierItemsModifierViewModels = _modiList);
            } else if (a.id?.isNotEmpty ?? false) {
              _deletedModifierList.add(DeletedOrderItemId(id: a.id));
            }
            //
          }
        }

        // print(_deletedDeepModifierList);

        // ingredients
        // List<RemovedOrderItemsIngredientsViewModel>? _ingredients;
        // List<DeletedOrderItemId>? _deletedIngredients;

        // if (e.removedOrderItemsIngredientsViewModels != null) {
        //   _ingredients = [];
        //   _deletedIngredients = [];
        //   for (final b in e.removedOrderItemsIngredientsViewModels!) {
        //     if (b.isActive) {
        //       _ingredients.add(b);
        //     } else if (b.id.isNotEmpty) {
        //       _deletedIngredients.add(DeletedOrderItemId(id: b.id));
        //     }
        //   }
        // }

        // staffs
        List<OrderItemsServiceEmployeeViewModel>? staffList;
        List<DeletedOrderItemId>? deletedStaffIds;

        // print(e.orderItemsServiceEmployeeViewModels?.map((e) => e.toJson()));

        if (e.orderItemsServiceEmployeeViewModels != null) {
          staffList = [];
          deletedStaffIds = [];
          for (final b in e.orderItemsServiceEmployeeViewModels!) {
            if (b.isSelected) {
              staffList.add(b);
            } else if (b.id.isNotEmpty) {
              deletedStaffIds.add(DeletedOrderItemId(id: b.id));
            }
          }
        }

        return e
          ..orderItemModifiersViewModels = _modifierList
          ..deletedOrderItemModifierIds = _deletedModifierList
          // ..removedOrderItemsIngredientsViewModels = _ingredients
          // ..deletedRemovedOrderItemIngredientsIds = _deletedIngredients
          ..orderItemsServiceEmployeeViewModels = staffList
          ..deletedOrderItemServiceEmployeeIds = deletedStaffIds
          ..deletedModifierItemModifierIds = (_deletedDeepModifierList ?? []) +
              (_deletedDoubleDeepModifierList ?? []);
      }).toList();

      // set menu //
      final placedSetmenuList = List<SetMenuOrderDetail>.from(
          List<dynamic>.from(setMenuList.map((x) => x.toJson()))
              .map((y) => SetMenuOrderDetail.fromJson(y)));

      placeOrder.setMenuOrderDetails = placedSetmenuList.map((f) {
        if (f.orderItemsViewModels != null)
          for (final e in f.orderItemsViewModels!) {
            //modifiers
            List<OrderItemsPriceModifierViewModel>? modifierList;
            List<DeletedOrderItemId>? deletedModifierList;

            if (e.orderItemsPriceModifierViewModels != null) {
              modifierList = [];
              deletedModifierList = [];
              for (final a in e.orderItemsPriceModifierViewModels!) {
                if (a.isActive) {
                  modifierList.add(a);
                } else if (a.id?.isNotEmpty ?? false) {
                  deletedModifierList.add(DeletedOrderItemId(id: a.id));
                }
              }
            }

            // ingredients
            List<RemovedOrderItemsIngredientsViewModel>? ingredients;
            List<DeletedOrderItemId>? deletedIngredients;

            if (e.removedOrderItemsIngredientsViewModels != null) {
              ingredients = [];
              deletedIngredients = [];
              for (final b in e.removedOrderItemsIngredientsViewModels!) {
                // print("ingre :: ${b.name} ${b.isActive}");
                if (b.isActive) {
                  ingredients.add(b);
                } else if (b.id.isNotEmpty) {
                  deletedIngredients.add(DeletedOrderItemId(id: b.id));
                }
              }
            }

            e
              ..orderItemsPriceModifierViewModels = modifierList
              ..deletedOrderItemModifierIds = deletedModifierList
              ..removedOrderItemsIngredientsViewModels = ingredients
              ..deletedRemovedOrderItemIngredientsIds = deletedIngredients;
          }

        return f;
      }).toList();

      // ingredients //
      final placeIngreList = List<RawIngredientOrderDetail>.from(
          List<dynamic>.from(ingreList.map((x) => x.toJson()))
              .map((y) => RawIngredientOrderDetail.fromJson(y)));

      placeOrder.rawIngredientOrderDetails = placeIngreList;

      //  -- ingredients //
    }

    // _placeOrder.channelPlatForm = channelPlatForm;
    // _placeOrder.isRetail = isRetail;
    placeOrder.isSendToKitchen = isSentToKt;
    placeOrder.stockDeductType = stockDeductType;

    //TODO: check place order request
    // log(jsonEncode(placeOrder.toJson()));
    // return null;

    placeOrderInfo = await Handler.placeOrder(
      placeOrderRes: placeOrder,
      isUpdateAfterCancelled: isUpdateAfterCancelled,
    );

    kPrint("${placeOrderInfo == null}");

    if (placeOrderInfo != null) {
      if (runFun != null) await runFun();

      if (isSentToKt &&
          (GlobalCVP.storeInfo?.isSendToKitchenPrinter ?? false)) {
        orderSendToKitchen(plOrInfo: placeOrderInfo);
      }

      // TODO: DONOT GO TO PAY SCREEN
      // if (isSentToKt &&
      //     (GlobalCVP.storeInfo?.isSendToKitchenPrinter ?? false)) {
      //   final _res = await Handler.posOrderStkPrinter(req: placeOrderInfo!);
      //   final _askToPrint = _res?.askForPrintConfirmation ?? false;

      //   if (!_askToPrint) {
      //     _res?.askForPrintConfirmation = false;
      //     StkUtils.sendTokitchenOrder(res: _res);
      //   }
      // MsgDia.show(
      //   context,
      //   headerAnimation: false,
      //   diaType: DiaType.success,
      //   title: 'Order Confirmed',
      //   desc: 'The order has been successfully sent to the kitchen.',
      //   showCloseIcon: true,
      //   dismissOnTouchOut: false,
      //   onPop: () {},
      //   btnOK: _askToPrint
      //       ? Padding(
      //           padding: EdgeInsets.symmetric(vertical: 16),
      //           child: Row(
      //             children: [
      //               Expanded(
      //                 child: Container(),
      //               ),
      //               Expanded(
      //                 child: LoadButton(
      //                   btnColor: Colors.white,
      //                   textColor: Colors.black,
      //                   shape: RoundedRectangleBorder(
      //                       side: BorderSide(color: Colors.black54),
      //                       borderRadius: BorderRadiusGeometry.circular(5)),
      //                   btnText: LN.close,
      //                   hPad: 12,
      //                   vPad: 8,
      //                   fontSize: 18,
      //                   onsave: () {
      //                     if (context.mounted && Navigator.canPop(context))
      //                       Navigator.pop(context);
      //                   },
      //                 ),
      //               ),
      //               SizedBox(
      //                 width: 12,
      //               ),
      //               Expanded(
      //                 flex: 2,
      //                 child: LoadButton(
      //                   btnText: "Print Docket",
      //                   hPad: 12,
      //                   vPad: 8,
      //                   fontSize: 18,
      //                   onsave: () {
      //                     _res?.askForPrintConfirmation = false;
      //                     StkUtils.sendTokitchenOrder(res: _res);
      //                     if (context.mounted && Navigator.canPop(context))
      //                       Navigator.pop(context);
      //                   },
      //                 ),
      //               ),
      //             ],
      //           ),
      //         )
      //       : null,
      // );
      // if (!_askToPrint)
      //   Future.delayed(Duration(seconds: 2), () {
      //     if (!_askToPrint && context.mounted && Navigator.canPop(context))
      //       Navigator.pop(context);
      //   });
      // }
    }

    // if (placeOrderRes != null && updateReOrder) {
    //   Future.delayed(Duration(milliseconds: 400), () {
    //     reOrder = null;
    //   });
    //   // notify;
    // }
    return placeOrderInfo != null;
  }

  Future<void> orderSendToKitchen({
    PlaceOrderInfo? plOrInfo,
  }) async {
    Handler.orderSentKitchen(
      orderId: plOrInfo?.orderId,
      printAllItem: plOrInfo?.printAllItems,
      sessionId: plOrInfo?.sessionId,
      posDeviceId: plOrInfo?.posDeviceId,
      isSendToKitchen: plOrInfo?.isSendToKitchenDisplay ?? false,
      isSendToPrinter: plOrInfo?.isSendToKitchenPrinter ?? false,
    ).then((_res) {
      StkEventUtils.sendTokitchenOrder(
          res: _res, sessionId: plOrInfo?.sessionId ?? '');
    });
  }

  List<OrderItemsPriceModifierViewModel> _placeModiList(
      {List<OrderItemsPriceModifierViewModel>?
          orderItemsPriceModifierViewModels}) {
    final _modifierList = <OrderItemsPriceModifierViewModel>[];
    if (orderItemsPriceModifierViewModels != null) {
      for (final a in orderItemsPriceModifierViewModels) {
        if (a.isActive) {
          final _newA = OrderItemsPriceModifierViewModel.fromJson(a.toJson());

          if (a.modifierItemsModifierViewModels?.isNotEmpty ?? false) {
            final _data = _placeModiList(
                orderItemsPriceModifierViewModels:
                    a.modifierItemsModifierViewModels);

            _newA.modifierItemsModifierViewModels = _data;
          }

          _modifierList.add(_newA);
        }
      }
    }
    return _modifierList;
  }

  // List<ProductFilterOption>? filterOptions;
  ProductDetailViewModel? productDetailView;
  bool varianceLoading = false;

  // product view
  void getProductData(
    String? id, {
    List<OrderItemSelectOptionsViewModels>? filterTypeList,
    FeaturedProduct? featuredProduct,
    bool isPosTab = false,
    FeaturedProduct? retailProduct,
  }) {
    varianceLoading = true;
    notify;

    final _idLower = id?.toLowerCase();

    if (!isPosTab) {
      if (retailProduct != null) {
        productDetailView = ProductDetailViewModel(
          productListViewModel: retailProduct,
        );
      } else {
        final _channelId = (initAddSec?.orderTypes?.isNotEmpty ?? false) &&
                (orderTypeIndex >= 0 &&
                    orderTypeIndex < initAddSec!.orderTypes!.length)
            ? (initAddSec?.orderTypes?[orderTypeIndex].channelId)
            : null;

        final _p = _allProductData.firstWhere(
          (e) => e.id?.toLowerCase() == _idLower,
          orElse: () => FeaturedProduct(),
        );

        final _prodAsNew = _p.id != null
            ? (FeaturedProduct.fromJson(_p.toJson())
              ..parentCatId = _p.parentCatId)
            : null;

        if (_prodAsNew != null) {
          _setApplyDiscounts(
            _prodAsNew,
            'getProductData: promo empty',
          );
        }

        if (_prodAsNew != null) {
          if (_channelId?.isNotEmpty ?? false) {
            final _channelLower = _channelId!.toLowerCase();
            _prodAsNew.productVariations = _prodAsNew.productVariations
                ?.where((e) => e.channelId?.toLowerCase() == _channelLower)
                .toList();
          } else {
            _prodAsNew.productVariations = _p.productVariations;
          }
        }

        productDetailView = ProductDetailViewModel(
          productListViewModel: _prodAsNew,
        );
      }
    } else if (featuredProduct != null) {
      final _featProduct = FeaturedProduct.fromJson(featuredProduct.toJson());
      productDetailView =
          ProductDetailViewModel(productListViewModel: _featProduct);
      productDetailView?.filterCategoriesWithChildernFilterOptions =
          _featProduct.filterTypeFilterOptions;
    }

    // ------------------------
    // SET FILTER DATA
    // ------------------------
    if (productDetailView?.filterCategoriesWithChildernFilterOptions != null &&
        filterTypeList != null) {
      // Pre-build map for O(1) filter lookup
      final filterMap = {
        for (var f in filterTypeList) f.filterTypeId?.toLowerCase(): f
      };

      for (final a
          in productDetailView!.filterCategoriesWithChildernFilterOptions!) {
        final key = a.filterCategoryId?.toLowerCase();
        final _options = filterMap[key];
        if (_options == null) continue;

        a.id = _options.id;
        final _optionIds = _options.filterTypeOptionsId?.toLowerCase();

        if (_optionIds == null) continue;

        if ((a.childernCategories
                ?.any((z) => z.filterTypeOptions?.isNotEmpty ?? false)) ??
            false) {
          for (final e in a.childernCategories!) {
            if (e.filterTypeOptions != null)
              for (final f in e.filterTypeOptions!) {
                if (f.filterCategoryOptionId?.toLowerCase() != null &&
                    _optionIds
                        .contains(f.filterCategoryOptionId!.toLowerCase())) {
                  a.childSelectedIndex = 0;
                  f.isSelected = true;
                }
              }
          }
        } else {
          if (a.filterTypeOptions != null)
            for (final d in a.filterTypeOptions!) {
              if (d.filterCategoryOptionId?.toLowerCase() != null &&
                  _optionIds
                      .contains(d.filterCategoryOptionId!.toLowerCase())) {
                d.isSelected = true;
              }
            }
        }
      }
    }

    // ------------------------
    // PRODUCT DETAIL SYNC
    // ------------------------
    final _product = productDetailView?.productListViewModel;

    final _prodPriceType =
        OrderUtils.productPriceType(_product?.productPriceType);

    if (_product != null &&
        (featuredProduct?.productVariations?.isNotEmpty ?? false)) {
      _product.quantity = featuredProduct!.quantity;

      final _selectedVar = (featuredProduct.productVariations
                  ?.any((a) => a.isDefault ?? false) ??
              false)
          ? featuredProduct.productVariations
              ?.firstWhere((a) => a.isDefault ?? false)
          : featuredProduct.productVariations?.first;
      if (_selectedVar != null && _product.productVariations != null) {
        final _selectedVarId = _selectedVar.id?.toLowerCase();

        // build lookups
        final modMap = {
          if (_selectedVar.productVariationModifiers != null)
            for (var p in featuredProduct.productVariations!)
              if (p.productVariationModifiers != null)
                for (var m in p.productVariationModifiers!)
                  if (m.modifierItems != null)
                    for (var item in m.modifierItems!)
                      item.id?.toLowerCase(): item
        };

        final staffMap = {
          if (_selectedVar.productVariationServiceEmployees != null)
            for (var s in _selectedVar.productVariationServiceEmployees!)
              s.id?.toLowerCase(): s
        };
        final batchMap = {
          if (_selectedVar.productVariationBatchStocks != null)
            for (var b in _selectedVar.productVariationBatchStocks!)
              b.batchNumber?.toLowerCase(): b
        };

        for (final a in _product.productVariations!) {
          // promotion
          try {
            final _var = featuredProduct.productVariations
                ?.firstWhere((b) => b.id?.toLowerCase() == a.id?.toLowerCase());
            if (_var?.promoModel != null) a.promoModel = _var?.promoModel;
          } catch (_) {
            //
          }
          // default variation
          a.isDefault = a.id?.toLowerCase() == _selectedVarId;

          // modifiers
          if (a.productVariationModifiers != null)
            for (final b in a.productVariationModifiers!) {
              if (b.modifierItems != null)
                for (final c in b.modifierItems!) {
                  final match = modMap[c.id?.toLowerCase()];
                  if (match != null) {
                    // if (match.isActive ?? false)
                    // kPrint(
                    //     "Porduc : ${c.productName} ${c.isActive} ${match.isActive}");
                    c.updateId = match.updateId;
                    c.isActive = match.isActive;
                    c.quantity = _prodPriceType ==
                            ProductPriceType.FixedPriceFixedProduct
                        ? ((match.maxThresholdQuantity?.inDouble ?? 0) == 0
                            ? 1
                            : (match.maxThresholdQuantity?.inDouble ?? 1.0))
                        : match.quantity;
                    c.halfItemPrice = match.halfItemPrice;
                    if (match.promoModel != null)
                      c.promoModel = match.promoModel;
                  }
                }
            }

          // staff
          if (a.productVariationServiceEmployees != null)
            for (final f in a.productVariationServiceEmployees!) {
              final match = staffMap[f.id?.toLowerCase()];
              if (match != null) {
                f.id = match.id;
                f.updateId = match.updateId;
                f.isSelected = match.isSelected;
              } else {
                f.isSelected = false;
              }
            }

          // batch
          if (a.productVariationBatchStocks != null)
            for (final f in a.productVariationBatchStocks!) {
              final match = batchMap[f.batchNumber?.toLowerCase()];
              f.isActive = match?.isActive ?? false;
            }
        }
      }
    }

    varianceLoading = false;
    notify;
  }

  bool changeStoreLoad = false;

  Future<StoreDetailRes?> onChangeStore({
    String? storeId,
    bool initLoad = false,
  }) async {
    storeId ??= await SharedPrefs.storeId;
    dateFormat = await SharedPrefs.dateFormat;

    if (storeId.isEmpty) {
      MsgDia.show(
        CUS_CTX,
        headerAnimation: false,
        diaType: DiaType.error,
        title: LN.noStoreSelected,
        autoHideSecond: 1,
      );
      return null;
    }
    StoreDetailRes? _storeData;
    if (!initLoad) {
      changeStoreLoad = true;
      GlobalCVP.isInitApiCalled = false;
      notify;
      final _activeStatus = await Handler.onChangeStore(storeId: storeId);
      if (_activeStatus ?? false) {
        await SharedPrefs.setStoreId(storeId);

        final _tagFcm = GlobalCVP.userStoresRes?.userType !=
                UserTypeEnum.AppTestUser.name &&
            GlobalCVP.userStoresRes?.userType != UserTypeEnum.SuperAdmin.name;

        if (_tagFcm && (GlobalCVP.userStoresRes?.id?.isNotEmpty ?? false)) {
          await Handler.tagFcmTokenDevice(
              deviceId: GlobalCVP.userStoresRes!.id!);
        }
        _storeData = await Handler.getStoreDetail();
        await DbLocalData.updateStoreData(data: _storeData);
      }
    } else {
      _storeData = GlobalCVP.currentStore;
    }

    if (_storeData != null) {
      curSym = _storeData.currencySymbol ?? '';
      await SharedPrefs.setStoreId(_storeData.storeId ?? '');
      await DbLocalData.updateStoreData(data: _storeData);

      if (_storeData.languageCode != null && _storeData.languageCode != LN.ln) {
        Translate.translate(langCode: _storeData.languageCode!);
      }

      reOrder = null;
    }

    changeStoreLoad = false;
    GlobalCVP.isInitApiCalled = true;
    notify;
    return _storeData;
  }

  Future<bool?> orderStatusUpdate(BuildContext context,
      {Function(bool)? onPopMsg, bool isSentToKt = false}) async {
    final _cartList = setMenuList
            .where((a) =>
                OrderUtils.getStatusEnum(a.statusId) != OrderStatusEnum.cancel)
            .toList()
            .length +
        orderList
            .where((a) =>
                OrderUtils.getStatusEnum(a.statusId) != OrderStatusEnum.cancel)
            .toList()
            .length +
        ingreList
            .where((a) =>
                OrderUtils.getStatusEnum(a.statusId) != OrderStatusEnum.cancel)
            .toList()
            .length;
    if (_cartList == 0 &&
        reOrder?.orderId != null &&
        reOrder?.cancelOrderStatusId != null) {
      bool? _status;

      await onPlaceOrder(context,
          isSentToKt: isSentToKt,
          isUpdateAfterCancelled: true, runFun: () async {
        _status = await Handler.changeOrderStatus(
          orderId: reOrder?.orderId ?? '',
          orderStatusId: reOrder?.cancelOrderStatusId ?? "",
          // onPopMsg: onPopMsg,
        );
      });

      // final _status = await Handler.changeOrderStatus(
      //   orderId: reOrder?.orderId ?? '',
      //   orderStatusId: reOrder?.cancelOrderStatusId ?? "",
      //   // onPopMsg: onPopMsg,
      // );
      if (_status ?? false) {
        reOrder = null;
        noOfCustomer.clear();
        delivertAmtCltr.clear();
        clear();
        notify;
      }

      return _status;
    }
    return null;
  }

  void get notify => notifyListeners();

  //drawer Index

  // int? _drawerIndex;
  // int? get getDI => _drawerIndex;
  // set setDI(int? val) {
  //   _drawerIndex = val;
  //   notify;
  // }

  ///////////////////////////////////////////////////////////
  ///////////////// customer details ////////////////////////

  // delivery data

  bool loadOnAddCus = false;

  final addressCltr = TextEditingController();

  DeliveryDisRes? deliveryDisRes;
  final delivertAmtCltr = TextEditingController();

  final dateTimeCltr = TextEditingController();
  final deliNoteCltr = TextEditingController();

  String? dateFormat;
  // String? _deliveryPrice;

  double? _lat, _long;

  final cusDeliveryData = <CusDeliveryData>[];
  int? selectedCusDeliveryIndex;

  FindAutocompletePredictionsResponse? getAutoPlaces;

  Future<void> getPlace(String input) async {
    getAutoPlaces = await MapUtils.getPlaces(
        input: input,
        postalCode: cusPostalCodeCltr.text,
        region: countryIndex == null
            ? null
            : customerAddSecRes?.countries?[countryIndex!].value);
    notify;
  }

  Future<void> getLocation(
    String? placeId, {
    String? address,
  }) async {
    final location = await MapUtils.getLocation(placeId);
    if (location == null) return;

    _lat = location.place?.latLng?.lat;
    _long = location.place?.latLng?.lng;

    getDeliveryAmount(
        lat: "${_lat ?? ""}",
        long: "${_long ?? ""}",
        address: address,
        isNewLoc: true);
  }

  Future<void> getDeliveryAmount({
    String? lat,
    String? long,
    String? id,
    String? userId,
    String? address,
    bool isNewLoc = false,
  }) async {
    final lat0 = lat == null || double.tryParse(lat) == null ? null : lat;
    final long0 = long == null || double.tryParse(long) == null ? null : long;

    loadOnAddCus = true;
    notify;

    deliveryDisRes = await Handler.getDeliveryAmount(
      id: id,
      lat: lat0,
      long: long0,
      address: address,
    );

    if (id != null
        // deliveryDisRes?.distanceInKm == null ||
        //   deliveryDisRes?.distanceInMile == null
        ) {
      final _storeType = OrderUtils.getTaxType(
          initAddSec?.storeInformation?.taxExclusiveInclusiveType);
      if (_storeType == TaxType.Inclusive) {
        delivertAmtCltr.text = deliveryDisRes?.deliveryAmountWithTax ??
            deliveryDisRes?.deliveryAmount ??
            '';
      } else {
        delivertAmtCltr.text = deliveryDisRes?.deliveryAmount ?? '';
      }
    } else {
      delivertAmtCltr.text = deliveryDisRes?.deliveryAmount ?? '';
    }

    if (deliveryDisRes != null && isNewLoc) {
      if (cusDeliveryData.any((a) => a.deliveryLocation == addressCltr.text)) {
        selectedCusDeliveryIndex = cusDeliveryData
            .indexWhere((a) => a.deliveryLocation == addressCltr.text);
      } else if (addressCltr.text.isNotEmpty) {
        cusDeliveryData.insert(
            0,
            CusDeliveryData(
              deliveryLocation: addressCltr.text,
              latitude: lat0?.toString(),
              longitude: long0?.toString(),
            ));
        selectedCusDeliveryIndex = 0;
      }

      addressCltr.clear();
    }

    // uberdelivery

    // final _store =
    //     (GlobalCVP.loginRes?.storeDetailsLoginResponseViewModels?.isNotEmpty ??
    //                 false) &&
    //             GlobalCVP.selectedStore != null
    //         ? GlobalCVP.loginRes!
    //             .storeDetailsLoginResponseViewModels![GlobalCVP.selectedStore!]
    //         : null;

    // final _deliRes = await DeliveryPro.createQuote(
    //     lat: _lat.inDouble,
    //     lon: _long.inDouble,
    //     storeAddress: initAddSec?.posDeliveryStoreInformation?.address ?? '',
    //     dropAddress:
    //         cusDeliveryData[selectedCusDeliveryIndex!].deliveryLocation ?? '');

    // delivertAmtCltr.text = ((_deliRes?.fee ?? 0) / 100).roundToNString();

    loadOnAddCus = false;
    notify;
  }

  bool get isDelivery =>
      (initAddSec?.orderTypes?.isNotEmpty ?? false) &&
      (initAddSec!.orderTypes!.length > orderTypeIndex) &&
      (initAddSec?.orderTypes?[orderTypeIndex].additionalValue == 2 ||
          (initAddSec?.orderTypes?[orderTypeIndex].additionalValue
                  .toString()
                  .toLowerCase()
                  .contains('deliver') ??
              false));

  bool get isPickUp =>
      (initAddSec?.orderTypes?.isNotEmpty ?? false) &&
      (initAddSec!.orderTypes!.length > orderTypeIndex) &&
      (initAddSec?.orderTypes?[orderTypeIndex].additionalValue == 1 ||
          (initAddSec?.orderTypes?[orderTypeIndex].additionalValue
                  .toString()
                  .toLowerCase()
                  .contains('pick') ??
              false));

  bool get isDine =>
      (initAddSec?.orderTypes?.isNotEmpty ?? false) &&
      (initAddSec!.orderTypes!.length > orderTypeIndex) &&
      (initAddSec?.orderTypes?[orderTypeIndex].additionalValue == 3 ||
          (initAddSec?.orderTypes?[orderTypeIndex].additionalValue
                  .toString()
                  .toLowerCase()
                  .contains('dine') ??
              false));

  CustomerAddSecRes? customerAddSecRes;

  final cusNameCltr = TextEditingController();
  final cusEmailCltr = TextEditingController();
  final cusPhoneCltr = TextEditingController();
  final cusPostalCodeCltr = TextEditingController();

  int? customerTypeIndex;
  int? phoneCodeIndex;
  int? countryIndex;
  String? _customerId;
  bool _isLoyalEnabled = false;
  bool _isMarketEnabled = false;

  Future<void> getCusAddSec() async {
    dateFormat = await SharedPrefs.dateFormat;
    customerAddSecRes = CustomerAddSecRes.fromJson(GlobalCVP.allAddSection);
    //await Handler.getAllCusAddSecList();
    _setCusAddSecData();
  }

  _setCusAddSecData() {
    if (customerAddSecRes?.customerType?.any((e) => e.isSelected ?? false) ??
        false) {
      customerTypeIndex = customerAddSecRes!.customerType!
          .indexWhere((e) => e.isSelected ?? false);
    }
    if (customerAddSecRes?.countries?.any((e) => e.isSelected ?? false) ??
        false) {
      phoneCodeIndex = customerAddSecRes!.countries!
          .indexWhere((e) => e.isSelected ?? false);
      countryIndex = customerAddSecRes!.countries!
          .indexWhere((e) => e.isSelected ?? false);
    }

    notify;
  }

  void setCustomerData(CusData cusData) {
    _customerId = cusData.id ?? "";
    cusNameCltr.text = cusData.name ?? "";
    cusEmailCltr.text = cusData.email ?? "";
    cusPhoneCltr.text = cusData.phoneNumber ?? "";
    cusPostalCodeCltr.text = cusData.postalCode ?? "";
    _isLoyalEnabled = cusData.isLoyaltyEnabled ?? false;
    _isMarketEnabled = cusData.isMarketingPromotionEnabled ?? false;

    if (customerAddSecRes?.customerType
            ?.any((e) => e.name == cusData.customerType) ??
        false) {
      customerTypeIndex = customerAddSecRes!.customerType!
          .indexWhere((e) => e.name == cusData.customerType);
    }

    if (customerAddSecRes?.countries?.any(
            (e) => e.id?.toLowerCase() == cusData.countryId?.toLowerCase()) ??
        false) {
      countryIndex = customerAddSecRes!.countries!.indexWhere(
          (e) => e.id?.toLowerCase() == cusData.countryId?.toLowerCase());
    }

    if (customerAddSecRes?.countries?.any((e) =>
            e.id?.toLowerCase() ==
            cusData.countryPhoneNumberPrefixId?.toLowerCase()) ??
        false) {
      phoneCodeIndex = customerAddSecRes!.countries!.indexWhere((e) =>
          e.id?.toLowerCase() ==
          cusData.countryPhoneNumberPrefixId?.toLowerCase());
    }
    notify;
  }

  Future<void> getCusDeliveryAddress({
    String? id,
    String? name,
  }) async {
    if (id == null || name == null) return;

    loadOnAddCus = true;
    notify;
    final data = await Handler.getCusDeliveryAddress(id: id, name: name);

    if (data != null)
      for (final e in data)
        if (e.deliveryLocation?.isNotEmpty ?? false) cusDeliveryData.add(e);

    loadOnAddCus = false;
    notify;
  }

  Future<CusForLoyalityRes?> searchCustomer(String val, {String? cusId}) async {
    CusForLoyalityRes? cusLoyalData;
    cusLoyalData = await Handler.searchCustomer(phoneNumber: val, cusId: cusId);

    // _cusLoyalData ??= await Handler.searchCustomer(email: val);

    if (customerAddSecRes == null) await getCusAddSec();

    final cusData = CusData(
      id: cusLoyalData?.id,
      name: cusLoyalData?.customerName,
      email: cusLoyalData?.email,
      phoneNumber: cusLoyalData?.phoneNumber,
      postalCode: cusLoyalData?.postalCode,
      countryPhoneNumberPrefixId: cusLoyalData?.countryPhoneNumberPrefixId,
      countryId: cusLoyalData?.countryId,
      isLoyaltyEnabled: cusLoyalData?.loyaltyEnabled,
      isMarketingPromotionEnabled: cusLoyalData?.isMarketingPromotionEnabled,
      customerType: customerAddSecRes != null &&
              customerAddSecRes!.customerType!.any((e) =>
                  e.id?.toLowerCase() ==
                  cusLoyalData?.customerTypeId?.toLowerCase())
          ? customerAddSecRes!.customerType!
              .firstWhere((e) =>
                  e.id?.toLowerCase() ==
                  cusLoyalData?.customerTypeId?.toLowerCase())
              .name
          : null,
    );
    setCustomerData(cusData);
    return cusLoyalData;
  }

  Future<bool> checkTableStatus({String? tableId}) async {
    final _status = await Handler.checkTableStatus(tableId: tableId);
    return _status ?? false;
  }

  Future<void> getStoreChargeInfo() async {
    final _storeInfo = await Handler.getStoreChargeInfo();
    await GlobalCVP.updateStoreInfo(data: _storeInfo);
    getOrderAddSection();
  }

  Future<void> getStoreInfo() async {
    final _storeInfo = await Handler.syncStoreInfo();
    await GlobalCVP.updateStoreInfo(data: _storeInfo);
    getOrderAddSection();
  }

  /// retail pos screen //
  // Future<void> getRetailCats() async {
  //   posCatRes = PosScreenCatRes();
  //   if (itemViewType == ItemViewType.combo) {
  //     posCatRes?.comboCategories = await Handler.getRetailComboCats();
  //     posCatRes?.comboCategories
  //         ?.forEach((a) => a.itemViewType = ItemViewType.combo);
  //   } else if (itemViewType == ItemViewType.ingre) {
  //     posCatRes?.rawLooseCategories = await Handler.getRetailIngreCats();
  //     posCatRes?.rawLooseCategories
  //         ?.forEach((b) => b.itemViewType = ItemViewType.ingre);
  //   }
  // }

  // promotions
  Future<void> getAllPromotions() async {
    String _dateFormat = await SharedPrefs.dateFormat;
    if (_dateFormat.isEmpty) {
      _dateFormat = GlobalCVP.storeInfo?.dateFormat ?? '';
      SharedPrefs.setDateFormat(_dateFormat);
    }
    PromoUtils.dateFormatString = _dateFormat;
    PromoUtils.promotionRes = await Handler.getAllPromotions();
    PromoUtils.currentPromotion = PromoUtils.getPromoTitle();
    PromoUtils.setNearestPromoDuration();
    setOnScreenPosData();
  }

  // void manageHalfOrder() {
  //   if (!orderList.any((e) => e.quantity == 0.5)) return;

  //   final _halfItemId = <HalfItemId>[];

  //   for (int i = 0; i < orderList.length; i++) {
  //     final a = orderList[i];
  //     if (a.quantity == 0.5) {
  //       _halfItemId
  //           .add(HalfItemId(id: a.id, index: i, key: Utils.getRandomString(6)));
  //     } else {
  //       a.halfGroupKey = Utils.getRandomString(6);
  //     }
  //   }

  //   for (int i = 0; i < _halfItemId.length; i++) {
  //     if (i % 2 == 0 && i + 1 < _halfItemId.length) {
  //       final _first = orderList[_halfItemId[i].index];
  //       final _second = orderList[_halfItemId[i + 1].index];

  //       if ((_first.productPrice ?? 0) > (_second.productPrice ?? 0)) {
  //         // _first.total = _first.productPrice;
  //         // _second.total = 0;
  //         _second.hideTotal = true;

  //         _first.halfGroupKey = _halfItemId[i].key;
  //         _second.halfGroupKey = _halfItemId[i].key;

  //         _first.halfGroupAmount = _first.productPrice?.roundToNString();
  //         _second.halfGroupAmount = _first.productPrice?.roundToNString();
  //       } else {
  //         // _first.total = 0;
  //         _first.hideTotal = true;
  //         // _second.total = _second.productPrice;

  //         _first.halfGroupKey = _halfItemId[i + 1].key;
  //         _second.halfGroupKey = _halfItemId[i + 1].key;

  //         _first.halfGroupAmount = _second.productPrice?.roundToNString();
  //         _second.halfGroupAmount = _second.productPrice?.roundToNString();
  //       }
  //     }
  //   }

  //   if (_halfItemId.length % 2 != 0) {
  //     final _last = orderList[_halfItemId.last.index];
  //     _last.hideTotal = false;
  //     _last.halfGroupKey = _halfItemId.last.key;
  //     _last.halfGroupAmount = _last.total?.roundToNString();
  //   }

  //   final _newOrderList = <OrderDetail>[];

  //   final _halfOrder = orderList.where((e) => e.quantity == 0.5).toList();

  //   _newOrderList.addAll(_halfOrder);

  //   final _fullOrder = orderList.where((e) => e.quantity != 0.5).toList();

  //   _newOrderList.addAll(_fullOrder);

  //   Future.delayed(Duration(milliseconds: 400), () {
  //     orderList.clear();

  //     orderList.addAll(_newOrderList);
  //     notify;
  //   });
  // }

  ///////////////// customer details ////////////////////////
  ///////////////////////////////////////////////////////////

  TaxType? get getTaxType {
    TaxType? taxType;
    if (orderList.isNotEmpty) {
      taxType = orderList.first.taxType;
    } else if (setMenuList.isNotEmpty) {
      taxType = setMenuList.first.taxType;
    }

    return taxType;
  }

  double get getTaxCoff {
    return 1 -
        OrderUtils.withoutTaxCoff(
            taxTypeString: taxExclusiveInclusiveType ?? '',
            taxPercent: taxPercentDDS);
  }

  void clearCusData({bool clearNoCus = true}) {
    cusNameCltr.clear();
    addressCltr.clear();
    getAutoPlaces = null;
    deliveryDisRes = null;
    delivertAmtCltr.clear();
    cusEmailCltr.clear();
    cusPhoneCltr.clear();
    cusPostalCodeCltr.clear();
    _customerId = null;
    _isLoyalEnabled = false;
    _isMarketEnabled = false;
    dateTimeCltr.clear();
    deliNoteCltr.clear();
    _lat = null;
    _long = null;
    cusDeliveryData.clear();
    selectedCusDeliveryIndex = null;
    if (clearNoCus) noOfCustomer.clear();
    _customerId = null;
    _isLoyalEnabled = false;
    _isMarketEnabled = false;
  }

  void reset() {
    loading = true;
    // listOrderType = null;
    // initRes = null;

    // tableList = null;
    // tableName = "";
    staffList = null;
    taxExclusiveInclusiveType = null;
    holidaySurgePercentage = null;
    creCardSurChargePercentage = null;
    // productsRes = null;
    // menuRes.clear();
    waiterIndex = 0;
    orderTypeIndex = 0;
    setMenuList.clear();
    orderList.clear();
    ingreList.clear();
    descCltr.clear();
    // alphaId = "";
    // tableIndex = null;
    // tableId = null;
    tableIdName = null;
    orderTabId = "";
    orderTabLimit = null;
    orderTabName = "";
    loadStKtBtn = false;
    loadPlaceOr = false;
    // placeOrderRes = null;
    placeOrderInfo = null;
    // isRetail = false;
    isTrialExp = null;
    searchCltr.clear();
    posDataPath = PosDataPath.Menu;
    reOrder = null;
    changeStoreLoad = false;
    // _drawerIndex = null;
    selectedSubCatIndex = null;
    noOfCustomer.clear();
    selectedSetMenuProduct = null;
    isAnyItemJustCancelled = false;
    clearCusData();
    desFocus = null;
    curSym = null;
    orderTabLoading = false;
    showManageTab = false;
    brandIndex = null;
    posCatRes = null;
    selectedCatId = "";
    categoryTitle = null;
    initAddSec = null;
    pageIndex = 1;
    itemViewList.clear();
    subCategoryList = null;
    alphaList = null;
    comboViewList.clear();
    ingreViewList.clear();
    docketNameList = null;
    itemViewType = ItemViewType.product;
    _allProductData = [];
    _allCatwithProdData = [];
    _allSortCatProdData = [];
    _productMap = null;
    _subCatId = null;
    selectedAlpha = null;
    promoId = null;
    _currentDocketName = null;
    comboDetailById = null;
    posDataPath = PosDataPath.Menu;
    selectedSubCatIndex = null;
    selectedDocketIndex = null;
    stockDeductType = null;
    productDetailView = null;
    varianceLoading = false;
    changeStoreLoad = false;
    getAutoPlaces = null;
    loadOnAddCus = false;
    customerAddSecRes = null;
    _popularProductIds = null;
    popularProducts = [];
    // initProductLoad = true;
  }

  ProductVariation? selectedvarCombo;
  ProductVariation? selectedvarHalfnHalf;

  ModifierItem? currentSelectedModifier;

  ModifierItem? firstHalf;
  ModifierItem? secondHalf;

  ModifierItem? thirdHalf;
  ModifierItem? fourthHalf;

  HalfItemTypeEnum selectedHalfEnum = HalfItemTypeEnum.first;

  //keypad data
  Future<List<FeaturedProduct>> getVariableProducts() async {
    if (_allProductData.isEmpty) {
      await getAllProducts();
    }
    final _channelId = (initAddSec?.orderTypes?.isNotEmpty ?? false) &&
            (orderTypeIndex >= 0 &&
                orderTypeIndex < initAddSec!.orderTypes!.length)
        ? (initAddSec?.orderTypes?[orderTypeIndex].channelId ?? '')
        : "";

    var _newFilteredData = _allProductData
        .map((e) =>
            FeaturedProduct.fromJson(e.toJson())..parentCatId = e.parentCatId)
        .toList();

    final filteredProducts = _newFilteredData.where((product) {
      final _productPriceTypeMatch =
          product.productPriceType?.toLowerCase().contains('variable') ?? false;
      final _channelVarList = product.productVariations
          ?.where(
            (e) =>
                _channelId.isEmpty ||
                e.channelId?.toLowerCase() == _channelId.toLowerCase(),
          )
          .toList();
      product.productVariations = _channelVarList;

      return _productPriceTypeMatch;
    }).toList();

    return filteredProducts;
  }

  // Barcode Scan
  Future<void> getProductFromBarCode(
    String? barcode, {
    Function({FeaturedProduct? featuredProduct})? openVariance,
  }) async {
    if (barcode == null) return;

    FeaturedProduct? _featProduct;
    // ProductVariation? _selectedVar;

    final _channelId = (initAddSec?.orderTypes?.isNotEmpty ?? false)
        ? (initAddSec?.orderTypes?[orderTypeIndex].channelId ?? '')
        : '';

    if (_allProductData.any((e) =>
        e.productVariations?.any((f) =>
            f.barcodeNumber?.toLowerCase() == barcode.toLowerCase() &&
            f.channelId?.toLowerCase() == _channelId.toLowerCase()) ??
        false)) {
      final _serverFeatProd = _allProductData.firstWhere((e) =>
          e.productVariations?.any((f) =>
              f.barcodeNumber?.toLowerCase() == barcode.toLowerCase() &&
              f.channelId?.toLowerCase() == _channelId.toLowerCase()) ??
          false);

      _featProduct = FeaturedProduct.fromJson(_serverFeatProd.toJson())
        ..parentCatId = _serverFeatProd.parentCatId
        ..productVariations = [];

      // _selectedVar = _featProduct.productVariations?.firstWhere(
      //     (e) => e.barcodeNumber?.toLowerCase() == barcode.toLowerCase());

      if (_serverFeatProd.productVariations != null)
        for (final a in _serverFeatProd.productVariations!) {
          if (a.channelId?.toLowerCase() == _channelId.toLowerCase()) {
            if (a.barcodeNumber?.toLowerCase() == barcode.toLowerCase()) {
              a.isDefault = true;
            } else {
              a.isDefault = false;
            }

            _featProduct.productVariations?.add(a);
          }
        }
    } else {
      IfException.showMessage(message: LN.noProductFound);
      return;
    }

    final _variation = (_featProduct.productVariations?.isNotEmpty ?? false) &&
            (_featProduct.productVariations?.any((a) => a.isDefault ?? false) ??
                false)
        ? _featProduct.productVariations
            ?.firstWhere((a) => a.isDefault ?? false)
        : null;

    final _isDirectAddToCart = (((_variation?.productVariationModifiers ==
                    null ||
                (_variation?.productVariationModifiers != null &&
                    _variation!.productVariationModifiers!.isEmpty)) ||
            (_variation!.productVariationModifiers!.every(
                (a) => a.modifierItems == null || a.modifierItems!.isEmpty))) &&
        (_featProduct.filterTypeFilterOptions == null ||
            (_featProduct.filterTypeFilterOptions != null &&
                _featProduct.filterTypeFilterOptions!.isEmpty)) &&
        (_featProduct.taxRules == null ||
            ((_featProduct.taxRules != null &&
                (_featProduct.taxRules!.isEmpty ||
                    _featProduct.taxRules!.length == 1)))));

    if (_isDirectAddToCart) {
      final variation = _featProduct.productVariations?.first;

      if (GlobalCVP.stockExceedRestriction &&
          variation?.stockCount != null &&
          variation!.stockCount!.isNotEmpty &&
          variation.stockCount.inDouble <= 0) {
        IfException.showMessage(message: LN.productOutOfStock);
        return;
      }
      _featProduct.quantity = 1;

      updateOrderCart(
        product: _featProduct,
        variation: variation,
        catId: _featProduct.categoryId,
      ).then((value) {
        if (value) {
          IfException.showMessage(message: LN.addCartSuccess, isError: false);
        }
      });
    } else {
      if (openVariance != null) openVariance(featuredProduct: _featProduct);
      return;
    }
  }

  void setHalfProdByVarIdForDeal(ModifierItem? modiItem) {
    try {
      final _featProd = _allProductData.firstWhere((a) =>
          a.productVariations?.any((b) =>
              b.id?.toLowerCase() == modiItem?.variationId?.toLowerCase()) ??
          false);
      final _varData = _featProd.productVariations?.firstWhere(
          (b) => b.id?.toLowerCase() == modiItem?.variationId?.toLowerCase());

      final _newModiList = <ProductVariationModifier>[];

      for (final a in _varData!.productVariationModifiers!) {
        final _replacedData = ProductVariationModifier(
          name: a.name,
          selectionType: a.selectionType,
          maxThresholdQuantity: a.maxThresholdQuantity,
          isRequired: a.isRequired,
          productVariationId: a.productVariationId,
          type: a.type,
          modifierItems: a.modifierItems
              ?.map((b) => ModifierItem.fromJson(b.toJson()))
              .toList(),
        );

        // if (a.modifierItems != null) {
        //   final _data1 =
        //       (modiItem?.modifierItemModifiers?.any((b) => b.name == a.name) ??
        //               false)
        //           ? modiItem?.modifierItemModifiers
        //               ?.firstWhere((b) => b.name == a.name)
        //           : null;

        //   for (final b in a.modifierItems!) {
        //     final _data2 =
        //         (_data1?.modifierItems?.any((c) => c.id == b.id) ?? false)
        //             ? _data1?.modifierItems?.firstWhere((c) => c.id == b.id)
        //             : null;

        //     // kPrint("${_data2?.productName} ${_data2?.actualPrice}");
        //     _replacedData.modifierItems?.add(
        //       ModifierItem.fromJson(b.toJson())
        //         ..isActive = _data2?.isActive
        //         ..halfItemPrice = _data2?.halfItemPrice,
        //     );
        //     //

        // kPrint(_data2?.modifierItemModifiers?.map((e) => e.toJson()));

        // if (b.modifierItemModifiers != null) {
        //   for (final c in b.modifierItemModifiers!) {
        //     if (c.modifierItems != null) {
        //       final _data3 = (_data2?.modifierItemModifiers
        //                   ?.any((z) => z.name == c.name) ??
        //               false)
        //           ? _data2?.modifierItemModifiers
        //               ?.firstWhere((z) => z.name == c.name)
        //           : null;

        //       for (final d in c.modifierItems!) {
        //         if (_data3?.modifierItems?.any((y) => y.id == d.id) ??
        //             false) {
        //           final _data4 = _data3?.modifierItems
        //               ?.firstWhere((y) => y.id == d.id);

        //           d.isActive = _data4?.isActive;

        //           if (_data4?.isActive ?? false)
        //             kPrint("${_data4?.productName} ${_data4?.isActive}");
        //         }
        //       }
        //     }
        //   }
        // }

        // kPrint(
        //     "${_data2?.productName} ${_data2?.isActive}${_data2?.actualPrice} ${_data2?.halfItemPrice}");
        //   }
        // }

        _newModiList.add(_replacedData);
      }
      modiItem?.modifierItemModifiers = [];

      modiItem?.modifierItemModifiers?.addAll(_newModiList);
    } catch (e) {
      // kPrint("Error : $e");
    }
  }
}

class AssetTitle {
  final int id;
  final String assetPath;
  final String title;

  AssetTitle({required this.assetPath, required this.title, required this.id});
}

class ReOrder {
  String? orderId;
  String? orderNumber;
  String? orderChannelEnum;
  String? cancelOrderStatusId;
  double itemPaidChargeIfOrderUpdate;
  final double discountPer;
  final String? status;
  final int? paymentType;
  final double paidDiscount;
  final List<String?>? tableIds;

  ReOrder({
    this.orderId,
    this.orderNumber,
    this.orderChannelEnum,
    this.cancelOrderStatusId,
    this.itemPaidChargeIfOrderUpdate = 0.0,
    this.discountPer = 0.0,
    this.status,
    this.paymentType,
    this.paidDiscount = 0.0,
    this.tableIds,
  });

// used for customer display to tranfer data
  factory ReOrder.fromJson(Map<String, dynamic> json) => ReOrder(
        orderId: json["orderId"],
        orderNumber: json["orderNumber"],
        orderChannelEnum: json["orderChannelEnum"],
        cancelOrderStatusId: json["cancelOrderStatusId"],
        tableIds: json["tableIds"] == null
            ? []
            : List<String>.from(json["tableIds"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "orderNumber": orderNumber,
        "orderChannelEnum": orderChannelEnum,
        "cancelOrderStatusId": cancelOrderStatusId,
        "tableIds":
            tableIds == null ? [] : List<dynamic>.from(tableIds!.map((x) => x)),
      };
}

class HalfItemId {
  final String? id;
  final int index;
  final String key;
  // final double unitPrice;

  HalfItemId({
    required this.id,
    required this.index,
    required this.key,
    // required this.unitPrice,
  });
}

enum PosDataPath { Menu, Drawer, Order }

enum HalfItemTypeEnum { first, second, third, fourth }
