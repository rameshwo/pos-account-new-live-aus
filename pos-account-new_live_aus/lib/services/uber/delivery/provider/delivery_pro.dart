import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:intl/intl.dart';
import 'package:pos_account/config/utils/map_utils.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/model/home/menu/orders/delivery/create_deli_pos_req.dart';
import 'package:pos_account/model/home/menu/orders/order_detail_by_id.dart';
import 'package:pos_account/model/home/menu/place_order/all_cus_add_sec.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/repository/handler.dart';
import 'package:pos_account/services/database/shared_pref.dart';
import 'package:pos_account/services/uber/delivery/model/delivery/create_deli_req.dart';

import '../../../../ln.dart';

class DeliveryPro extends ChangeNotifier {
  void get notify => notifyListeners();

  bool pageLoad = true;

  OrderDetailById? orderDetail;

  //pick-up details
  int? pickPhoneCodeIndex;
  final pickNameCltr = TextEditingController();
  final pickPhoneCltr = TextEditingController();
  final pickAddrCltr = TextEditingController();
  final pickNoteCltr = TextEditingController();
  final pickTimeCltr = TextEditingController();

  //delivery details

  int? deliPhoneCodeIndex;
  final deliNameCltr = TextEditingController();
  final deliPhoneCltr = TextEditingController();
  final deliAddrCltr = TextEditingController();
  final deliNoteCltr = TextEditingController();
  final deliTimeCltr = TextEditingController();
  // final deliSellerNoteCltr = TextEditingController();

  CustomerAddSecRes? cusAddSec;
  String? dateFormat;
  // CreateOrg? _uberStore;
  String curSym = "";

  // Future<void> _getUberStore() async {
  //   _uberStore = await UberDeliveryHandler.getOrg();
  // }

  Future<void> getData(OrderDetailById i) async {
    orderDetail = i;
    boxList.clear();
    addNewBox();
    setOrderItem();
    dateFormat = await SharedPrefs.dateFormat;
    curSym = await SharedPrefs.curSym;

    cusAddSec = CustomerAddSecRes.fromJson(GlobalCVP.allAddSection);
    //  await Handler.getAllCusAddSecList();
    setData();
    pageLoad = false;
    notify;
    // _getUberStore();
  }

  setData() {
    if (cusAddSec?.countries?.any((e) => e.isSelected ?? false) ?? false) {
      final phoneIndex =
          cusAddSec!.countries!.indexWhere((e) => e.isSelected ?? false);
      deliPhoneCodeIndex = phoneIndex;
      pickPhoneCodeIndex = phoneIndex;
    }
    // pickup
    pickNameCltr.text = GlobalCVP.storeInfo?.name ?? '';
    // orderDetail?.posDeliveryStoreInformation?.name ?? '';
    pickPhoneCltr.text = GlobalCVP.storeInfo?.phoneNumber ?? '';
    // orderDetail?.posDeliveryStoreInformation?.phoneNumber ?? '';
    pickAddrCltr.text = GlobalCVP.storeInfo?.address ?? '';
    //  orderDetail?.posDeliveryStoreInformation?.address ?? '';

    //delivery
    if (orderDetail?.receiverUserViewModel?.phoneNumber?.isNotEmpty ?? false) {
      deliNameCltr.text = orderDetail?.receiverUserViewModel?.name ?? '';
      deliPhoneCltr.text =
          orderDetail?.receiverUserViewModel?.phoneNumber ?? '';
    } else {
      deliNameCltr.text = orderDetail?.customerUserViewModel?.name ?? '';
      deliPhoneCltr.text =
          orderDetail?.customerUserViewModel?.phoneNumber ?? '';
    }
    deliAddrCltr.text =
        orderDetail?.orderDetailsViewModel?.deliveryAddress ?? '';
    deliTimeCltr.text =
        orderDetail?.orderDetailsViewModel?.pickUpDeliveryDate ?? '';
  }

  int? deliveryIndex;

  FindAutocompletePredictionsResponse? getAutoPlaces;

  Future<void> getPlace(String input, {int? phoneCodeIndex}) async {
    getAutoPlaces = await MapUtils.getPlaces(
        input: input,
        region: cusAddSec?.countries == null || phoneCodeIndex == null
            ? null
            : cusAddSec!.countries![phoneCodeIndex].name);
    notify;
  }

  // static Future<CreateQuoteRes?> createQuote({
  //   double? lat,
  //   double? lon,
  //   required String storeAddress,
  //   required String dropAddress,
  //   // String? cusPhoneNumber,
  //   // double totalAmount = 100,
  // }) async {
  //   final req = CreateQuoteReq(
  //     pickupAddress: storeAddress,
  //     dropoffAddress: dropAddress,
  //     // pickupLatitude: _store?.latitude?.inDouble,
  //     // pickupLongitude: _store?.longitude?.inDouble,
  //     // dropoffLatitude: lat,
  //     // dropoffLongitude: lon,
  //   );
  //   final res = await UberDeliveryHandler.createQuote(req: req);

  //   return res;
  // }

  // CreateQuoteRes? _quoteRes;
  bool createLoad = false;

  // CreateDeliveryRes? deliveryRes;

  Future<bool?> createDelivery() async {
    final totalAmount =
        ((orderDetail?.orderDetailsViewModel?.totalAmount?.inDouble ?? 0) * 100)
            .floor();

    final phonePrefix = cusAddSec!.countries != null &&
            deliPhoneCodeIndex != null
        ? cusAddSec!.countries![deliPhoneCodeIndex!].additionalValue as String
        : '';

    final newDateFormat = DateFormat(dateFormat);

    pageLoad = true;
    createLoad = true;
    notify;

    // final _quoteRes = await createQuote(
    //     storeAddress: pickAddrCltr.text, dropAddress: deliAddrCltr.text);

    final req = CreateDeliveryReq(
      pickupName: pickNameCltr.text,
      pickupAddress: pickAddrCltr.text,
      pickupPhoneNumber: "$phonePrefix${pickPhoneCltr.text}",
      dropoffName: deliNameCltr.text,
      dropoffAddress: deliAddrCltr.text,
      dropoffPhoneNumber: "$phonePrefix${deliPhoneCltr.text}",
      manifestItems: boxList.any((e) => e.itemList.isNotEmpty)
          ? boxList
              .where((e) => e.itemList.isNotEmpty)
              .map(
                (a) => ManifestItem(
                  name: a.title + a.itemList.map((b) => b.title).toString(),
                  quantity: double.tryParse(a.quantity ?? '')?.floor(),
                  price: ((a.price?.inDouble ?? 0) * 100).floor(),
                  vatPercentage: (a.taxValue.inDouble * 100).floor(),
                  size: a.sizeIndex != null
                      ? DeliSizeEnum.values[a.sizeIndex!].name
                      : null,
                  dimensions: Dimensions(
                      length: a.lengthCltr.text.inDouble.floor(),
                      height: a.heightCltr.text.inDouble.floor(),
                      depth: a.depthCltr.text.inDouble.floor()),
                  mustBeUpright: a.mustUpRight,
                  weight: a.weightCltr.text.inDouble.floor(),
                ),
              )
              .toList()
          : null,
      pickupBusinessName: pickNameCltr.text,
      // pickupLatitude: _store?.latitude?.inDouble,
      // pickupLongitude: _store?.longitude?.inDouble,
      pickupNotes: pickNoteCltr.text,
      dropoffBusinessName: "",
      // dropoffLatitude: ,
      // dropoffLongitude: ,
      dropoffNotes: deliNoteCltr.text,
      // dropoffSellerNotes: deliSellerNoteCltr.text,
      manifestTotalValue: totalAmount,
      // quoteId: _quoteRes?.id,
      pickupReadyDt:
          "${(pickTimeCltr.text.isNotEmpty ? newDateFormat.parse(pickTimeCltr.text) : DateTime.now()).toIso8601String()}Z",
      dropoffReadyDt:
          "${(pickTimeCltr.text.isNotEmpty ? newDateFormat.parse(pickTimeCltr.text) : DateTime.now()).add(Duration(minutes: 1)).toIso8601String()}Z",
      pickupDeadlineDt:
          "${newDateFormat.parse(deliTimeCltr.text).subtract(Duration(minutes: 30)).toIso8601String()}Z",
      dropoffDeadlineDt:
          "${newDateFormat.parse(deliTimeCltr.text).toIso8601String()}Z",
      // externalStoreId: _uberStore?.organizationId,
    );

    // deliveryRes ??= await UberDeliveryHandler.createDelivery(req: req);

    // if (deliveryRes != null) {
    final deliReq = CreateDeliPosReq(
      orderId: orderDetail?.orderDetailsViewModel?.orderId,
      // quoteId: _quoteRes?.id,
      // deliveryId: deliveryRes?.id,
      deliveryLocation: deliAddrCltr.text,
      deliveryLatitude: "",
      deliveryLongitude: "",
      deliveryPhoneNumber: "$phonePrefix${deliPhoneCltr.text}",
      deliveryDropOffNotes: deliNoteCltr.text,
      deliverableAction: "",
      pickupLocation: pickAddrCltr.text,
      pickUpPhoneNumber: "$phonePrefix${pickPhoneCltr.text}",
      pickUpDropOffNotes: pickNoteCltr.text,
      pickUpLongitude: "",
      pickUpLatitude: "",
      deliveryItems:
          json.encode(req.manifestItems?.map((e) => e.toJson()).toList()),
      pickUpTime: pickTimeCltr.text,
      // trackingUrl: deliveryRes?.trackingUrl,
      deliveryTrackingRequest: json.encode(req.toJson()),
      // deliveryTrackingResponse: json.encode(deliveryRes?.toJson()),
      totalAmount: orderDetail?.orderDetailsViewModel?.totalAmount,
    );

    final status = await Handler.createPosDelivery(req: deliReq);
    if (status ?? false) {
      // deliveryRes = null;
      return true;
    }
    // }

    pageLoad = false;
    createLoad = false;
    notify;

    return false;
  }

  void clear() {
    pageLoad = true;
    orderDetail = null;
    //pickup
    pickPhoneCodeIndex = null;
    pickNameCltr.clear();
    pickPhoneCltr.clear();
    pickAddrCltr.clear();
    pickNoteCltr.clear();
    pickTimeCltr.clear();

    //delivery
    deliPhoneCodeIndex = null;
    deliNameCltr.clear();
    deliPhoneCltr.clear();
    deliNoteCltr.clear();
    deliAddrCltr.clear();
    // deliSellerNoteCltr.clear();
    deliTimeCltr.clear();
    deliveryIndex = null;
    getAutoPlaces = null;
    // _quoteRes = null;
    boxList.clear();
    boxId = 1;
    orderItemList.clear();
    createLoad = false;
    // deliveryRes = null;
  }

  /// box setup
  final boxList = <ItemBoxModel>[];
  int boxId = 1;

  void addNewBox() {
    final id = boxList.isEmpty ? 1 : boxList.last.id + 1;
    boxList.add(ItemBoxModel(
      id: id,
      title: '${LN.box} $id',
      itemList: [],
      weightCltr: TextEditingController(),
      lengthCltr: TextEditingController(),
      heightCltr: TextEditingController(),
      depthCltr: TextEditingController(),
    ));
  }

  final orderItemList = <AllOrderItem>[];

  setOrderItem() {
    orderItemList.addAll([
      ...orderDetail?.productWithPriceDetailsViewModel?.map((e) {
            final vName = (e.productVariationName?.trim().isNotEmpty ?? false)
                ? "(${e.productVariationName})"
                : "";
            return AllOrderItem(
              id: e.id,
              title: "${e.productName}$vName",
              quantity: e.quantity,
              totalPrice: e.total,
              taxValue: e.taxPercentage,
            );
          }).toList() ??
          [],
      ...orderDetail?.setMenuWithPriceDetailsViewModel
              ?.map((e) => AllOrderItem(
                    id: e.id,
                    title: e.setMenuName,
                    quantity: e.quantity,
                    totalPrice: e.total,
                    taxValue: e.taxExclusiveInclusiveValue,
                  ))
              .toList() ??
          [],
      ...orderDetail?.rawIngredientWithPriceDetailsViewModel
              ?.map((e) => AllOrderItem(
                    id: e.id,
                    title: e.name,
                    quantity: e.quantity,
                    totalPrice: e.totalSellingPrice,
                    taxValue: e.taxValue,
                  ))
              .toList() ??
          [],
    ]);
  }
}

class ItemBoxModel {
  final int id;
  final String title;
  final List<AllOrderItem> itemList;
  final TextEditingController weightCltr;
  int? sizeIndex;
  final TextEditingController lengthCltr;
  final TextEditingController heightCltr;
  final TextEditingController depthCltr;
  String? quantity;
  String? price;
  String? taxValue;
  bool mustUpRight;

  ItemBoxModel({
    required this.id,
    required this.title,
    required this.itemList,
    required this.weightCltr,
    this.sizeIndex,
    required this.lengthCltr,
    required this.heightCltr,
    required this.depthCltr,
    this.quantity,
    this.price,
    this.taxValue,
    this.mustUpRight = false,
  });
}

class AllOrderItem {
  final String? title;
  final String? id;
  final String? quantity;
  final String? totalPrice;
  final String? taxValue;
  bool isSelected;

  AllOrderItem({
    this.title,
    this.id,
    this.isSelected = false,
    this.quantity,
    this.totalPrice,
    this.taxValue,
  });
}

enum DeliSizeEnum { small, medium, large }
