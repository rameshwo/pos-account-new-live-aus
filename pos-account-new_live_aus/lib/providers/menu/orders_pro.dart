import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/order_utils.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/common/table_location.dart';
import 'package:pos_account/model/home/menu/orders/all_orders_res.dart';
import 'package:pos_account/model/home/menu/orders/order_detail_by_id.dart';
import 'package:pos_account/model/home/menu/orders/order_detail_sec_res.dart';
import 'package:pos_account/model/home/menu/orders/sms/order_sms_send.dart';
import 'package:pos_account/model/home/menu/payment/eftpos/eftpos_merchant_log_res.dart';
import 'package:pos_account/model/home/menu/payment/make_pay_res.dart';
import 'package:pos_account/model/home/menu/payment/refund_pay_res.dart';
import 'package:pos_account/model/home/menu/place_order/place_order_req.dart';
import 'package:pos_account/model/home/menu/place_order/place_order_res.dart';
import 'package:pos_account/model/home/menu/place_order/po_make_pay_req.dart';
import 'package:pos_account/model/home/menu/place_order/po_pay_sec_list_res.dart';
import 'package:pos_account/model/home/setting/general/category/restro_table_model.dart';
import 'package:pos_account/model/profile/user_add_sec.dart';
import 'package:pos_account/model/ui_model/amount_class.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/repository/handler.dart';
import 'package:pos_account/screens/home_screen/com/pos_orders/com/order_detail_dialog.dart';
import 'package:pos_account/services/database/shared_pref.dart';

class OrderPro extends ChangeNotifier {
  bool loading = true;

  OrderDetailSecRes? orderDetailSecRes;

  // bool isRetail = false;

  int? channelIndex = 0;
  int? orderTypeIndex;
  int? tableIndex = 0;
  int? channelStatusIndex = 0;

  final searchCltr = TextEditingController();

  String curSym = "";

  // final newOrderStatusList = <TableLocation>[];
  final viewOrderStatusList = <TableLocation>[];
  // final orderChannelList = <TableLocation>[];

  void clear() {
    // loading = true;
    channelIndex = 0;
    orderTypeIndex;
    tableIndex = 0;
    channelStatusIndex = 0;
    searchCltr.clear();
    // orderDetailSecRes = null;
    // orderList.clear();
    isForRefund = false;
    // isRevokePayment = false;
    oDById = null;
  }

  Future<void> getCurSym() async {
    curSym = await SharedPrefs.curSym;
    notify;
  }

  Future<void> getOrDeSec() async {
    getCurSym();
    if (GlobalCVP.isServiceStore)
      orderDetailSecRes = OrderDetailSecRes.fromJson(GlobalCVP.allAddSection);
    //  await Handler.getServiceDeSecList();
    else
      orderDetailSecRes = OrderDetailSecRes.fromJson(GlobalCVP.allAddSection);
    //  await Handler.getOrderDeSecList();
    // setData();

    if ((orderDetailSecRes?.orderChannels?.isNotEmpty ?? false) &&
        (orderDetailSecRes?.orderChannels?.first.id?.isNotEmpty ?? false)) {
      orderDetailSecRes?.orderChannels?.insert(
          0,
          TableLocation(
              id: "", // "00000000-0000-0000-0000-000000000000",
              name: "All",
              value: "All"));
    }

    if ((orderDetailSecRes?.tables?.isNotEmpty ?? false) &&
        (orderDetailSecRes?.tables?.first.id?.isNotEmpty ?? false))
      orderDetailSecRes?.tables?.insert(
          0,
          TableLocation(
              id: "", // "00000000-0000-0000-0000-000000000000",
              name: "All Tables",
              value: "All Tables"));

    if ((orderDetailSecRes?.orderStatus?.isNotEmpty ?? false) &&
        (orderDetailSecRes?.orderStatus?.first.id?.isNotEmpty ?? false))
      orderDetailSecRes?.orderStatus?.insert(
          0,
          TableLocation(
              id: "00000000-0000-0000-0000-000000000000",
              name: "All",
              value: "All"));
    notify;
  }

  // setData() {
  //   if (orderDetailSecRes?.orderStatus != null) {
  //     newOrderStatusList.clear();
  //     for (final e in orderDetailSecRes!.orderStatus!) {
  //       if (!(OrderStatusModel.getStatus(e.value) == OrderStatus.All) &&
  //           !(OrderStatusModel.getStatus(e.value) ==
  //               OrderStatus.PaymentCompleted) &&
  //           !(OrderStatusModel.getStatus(e.value) == OrderStatus.Refund)) {
  //         newOrderStatusList.add(e);
  //       }
  //     }
  //   }
  // }

  void viewOrderSetData({OrderStatus? status}) {
    if (orderDetailSecRes?.orderStatus == null) return;
    viewOrderStatusList.clear();
    for (final e in orderDetailSecRes!.orderStatus!) {
      // if (status == OrderStatus.Pending ||
      //     status == OrderStatus.PaymentPending) {
      //   if (!(OrderStatusModel.getStatus(e.value) == OrderStatus.All) &&
      //       !(OrderStatusModel.getStatus(e.value) ==
      //           OrderStatus.PaymentCompleted) &&
      //       !(OrderStatusModel.getStatus(e.value) == OrderStatus.Refund)) {
      //     viewOrderStatusList.add(e);
      //   }
      // } else if (status == OrderStatus.PaymentCompleted) {
      //   if ((OrderStatusModel.getStatus(e.value) == OrderStatus.OnTheWay) ||
      //       (OrderStatusModel.getStatus(e.value) == OrderStatus.Delivered) ||
      //       (OrderStatusModel.getStatus(e.value) == OrderStatus.Refund)) {
      //     viewOrderStatusList.add(e);
      //   }
      // } else if (status == OrderStatus.OnTheWay) {
      //   if ((OrderStatusModel.getStatus(e.value) == OrderStatus.Delivered) ||
      //       (OrderStatusModel.getStatus(e.value) == OrderStatus.Refund)) {
      //     viewOrderStatusList.add(e);
      //   }
      // } else if (status == OrderStatus.Delivered) {
      //   if ((OrderStatusModel.getStatus(e.value) == OrderStatus.Refund)) {
      //     viewOrderStatusList.add(e);
      //   }
      // }
      final itemStatus = OrderStatusModel.getStatus(e.value);
      if (status == OrderStatus.PaymentPending) {
        if (itemStatus == OrderStatus.PaymentCompleted) {
          viewOrderStatusList.add(e);
        }
      } else if (status == OrderStatus.PaymentPending ||
          status == OrderStatus.PaymentCompleted) {
        if (itemStatus == OrderStatus.OnTheWay ||
            itemStatus == OrderStatus.Delivered) {
          viewOrderStatusList.add(e);
        }
      }
    }
  }

  final orderList = <AllOrderData>[];
  final int _orderPageSize = 9;
  int pageIndex = 1;
  int _orderTotalPage = 0;
  bool isRefresh = false;

  DateTime? _lastCalledAt;

  Future<void> getData({
    int page = 1,
    int? blockRecallWithinSeconds,
  }) async {
    final now = DateTime.now();

    if (blockRecallWithinSeconds != null &&
        _lastCalledAt != null &&
        now.difference(_lastCalledAt!).inSeconds < blockRecallWithinSeconds) {
      isRefresh = false;

      loading = false;
      notify;
      return; // Ignore call
    }

    _lastCalledAt = now;

    String searchKey = "";
    String storeChannelId = "";
    String orderStatusId = "";
    String orderTypeId = "";
    String tableId = "";

    if (orderDetailSecRes == null) await getOrDeSec();

    if (orderDetailSecRes != null) {
      if (channelIndex != null &&
          (orderDetailSecRes?.orderChannels?.isNotEmpty ?? false)) {
        storeChannelId =
            orderDetailSecRes?.orderChannels?[channelIndex!].id ?? '';
        if (orderTypeIndex != null &&
            (orderDetailSecRes?.orderTypes?.isNotEmpty ?? false)) {
          orderTypeId =
              orderDetailSecRes?.orderTypes?[orderTypeIndex!].id ?? '';
        }
      }

      // if (orderTypeIndex != null) {
      //   orderTypeId = orderDetailSecRes?.orderTypes?[orderTypeIndex!].id ?? '';
      // }

      if (channelStatusIndex != null &&
          (orderDetailSecRes?.orderStatus?.isNotEmpty ?? false)) {
        orderStatusId =
            orderDetailSecRes?.orderStatus?[channelStatusIndex!].id ?? '';
      }

      if (tableIndex != null &&
          (orderDetailSecRes?.tables?.isNotEmpty ?? false)) {
        tableId = orderDetailSecRes?.tables?[tableIndex!].id ?? '';
      }
      searchKey = searchCltr.text;
    }

    if (page == 1 || pageIndex * _orderPageSize < _orderTotalPage) {
      pageIndex = page;

      final allOrdersRes = GlobalCVP.isServiceStore
          ? await Handler.getAllServices(
              searchKey: searchKey,
              storeChannelId: storeChannelId,
              orderStatusId: orderStatusId,
              orderTypeId: orderTypeId,
              page: page,
              pageSize: _orderPageSize,
            )
          : await Handler.getAllOrders(
              searchKey: searchKey,
              storeChannelId: storeChannelId,
              orderStatusId: orderStatusId,
              orderTypeId: orderTypeId,
              tableId: tableId,
              page: page,
              pageSize: _orderPageSize,
            );

      if (page == 1) {
        orderList.clear();
      }
      if (allOrdersRes?.data != null) {
        _orderTotalPage = allOrdersRes?.total ?? 0;
        orderList.addAll(allOrdersRes!.data!);
      }
    }

    isRefresh = false;

    loading = false;
    notify;
  }

  /// get order Detail Section
  OrderDetailById? oDById;
  int? orderStatusIndex;

  bool loadStatus = false;

  String? orderId;

  Future<void> getOrderDeById({required String orderId}) async {
    if (orderId.isEmpty) return;

    loading = true;
    notify;

    oDById = await Handler.getOrderDeById(orderId: orderId);

    if (oDById?.orderDetailsViewModel?.orderStatus != null) {
      viewOrderSetData(
          status: OrderStatusModel.getStatus(
              oDById!.orderDetailsViewModel!.orderStatus!));
    }

    loading = false;
    notify;
  }

  Future<void> getOrderTransDetails({required String orderId}) async {
    if (orderId.isEmpty) return;

    loading = true;
    notify;

    oDById = await Handler.getOrderTranById(orderId: orderId);

    loading = false;
    notify;
  }

  Future<bool?> orderStatusUpdate({
    required String orderId,
    required String orderStatusId,
    bool refreshSingleOrder = true,
    // Function(bool)? onPopMsg,
    String? trackingDetail,
  }) async {
    loadStatus = true;
    notify;

    final _status = await Handler.changeOrderStatus(
      orderId: orderId,
      orderStatusId: orderStatusId,
      // onPopMsg: onPopMsg,
      trackingDetail: trackingDetail,
    );
    if (refreshSingleOrder && _status != null && _status) {
      await getOrderDeById(orderId: orderId);
      orderStatusIndex = null;
    }
    loadStatus = false;
    notify;

    return _status;
  }

  // AmountClass getAmount({
  //   String? taxTypeString,
  //   String? taxPercent,
  //   String? price,
  // }) {
  //   double _price = 0.0;
  //   double _taxPercent = 0.0;

  //   final taxType = Utils.getTaxType(taxTypeString);

  //   if (price != null && price.isNotEmpty) {
  //     _price = double.tryParse(price) ?? 0.0;
  //   }

  //   if (taxPercent != null && taxType != TaxType.NoTax) {
  //     _taxPercent = (double.tryParse(taxPercent) ?? 0.0);
  //   }

  //   return AmountClass()
  //     ..taxPercent = _taxPercent
  //     ..price = _price
  //     ..taxType = taxType;
  // }

  void get notify => notifyListeners();

  // run common function
  Future<void> viewOrder(BuildContext ctx, {required String orderId}) async {
    await getOrderDeById(orderId: orderId);
    orderStatusIndex = null;
    if (ctx.mounted) {
      final size = Ssize(ctx);
      showDialog(
          context: ctx,
          useRootNavigator: true,
          builder: (builder) => SimpleDialog(
                // backgroundColor: kPrimaryColor,
                titlePadding: EdgeInsets.zero,
                contentPadding: EdgeInsets.symmetric(
                    horizontal: size.getW(24), vertical: size.getH(24)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                children: [OrderDetailDia()],
              ));
    }
  }

  // new orders

  final tableList = RTableData(
    hasAction: false,
    headerList: [
      LN.orderNo,
      LN.orderDate,
      LN.tableName,
      LN.orderChannel,
      LN.orderStatus,
    ],
  );

  // int? newOrderStatusIndex;
  int newOrderChannelIndex = 0;

  bool loadNewOrder = true;

  int newOrderPage = 1;
  AllOrdersRes? allOrdersForNew;

  Future<void> getAllTableData({required int page}) async {
    newOrderPage = page;
    String statusId = "";
    String storeChannelId = "";
    if (orderDetailSecRes != null &&
        orderDetailSecRes!.orderStatus != null &&
        orderDetailSecRes!.orderStatus!.any((e) =>
            e.value != null && e.value!.toLowerCase().contains('pending'))) {
      statusId = orderDetailSecRes!.orderStatus!
              .firstWhere((e) =>
                  e.value != null && e.value!.toLowerCase().contains('pending'))
              .id ??
          '';
    }
    if (orderDetailSecRes?.orderChannels != null &&
        orderDetailSecRes!.orderChannels!.isNotEmpty) {
      storeChannelId =
          orderDetailSecRes!.orderChannels![newOrderChannelIndex].id ?? '';
    }

    loadNewOrder = true;
    notify;

    allOrdersForNew = await Handler.getAllOrders(
      page: page,
      pageSize: 100,
      orderStatusId: statusId,
      storeChannelId: storeChannelId,
      orderTypeId: "00000000-0000-0000-0000-000000000000",
      tableId: "00000000-0000-0000-0000-000000000000",
    );

    if (allOrdersForNew?.data == null) return;

    tableList.tableDataList = [];

    for (final e in allOrdersForNew!.data!) {
      if (e.status != null && e.status!.toLowerCase().contains('pending'))
        tableList.tableDataList.add(TableDataList(
          id: e.orderId ?? '',
          itemList: [
            e.orderNumber ?? '',
            e.orderDate ?? '',
            e.tableName ?? '',
            e.orderChannel ?? '',
          ],
          statusList: [TableStatus.Pending],
        ));
    }
    loadNewOrder = false;
    notify;
  }

  // Future<void> updateNewOrderStatus() async {
  //   final _orderIds = <String>[];

  //   if (tableList.tableDataList.isEmpty) {
  //     showToast(LN.noItemFound);
  //     return;
  //   }

  //   for (final e in tableList.tableDataList) {
  //     if (e.selected) _orderIds.add(e.id);
  //   }

  //   if (newOrderStatusIndex != null) {
  //     loadNewOrder = true;
  //     notify;

  //     final _status = await Handler.bulkOrderUpdate(
  //         orderStatusId: newOrderStatusList[newOrderStatusIndex!].id ?? '',
  //         orderIds: _orderIds);

  //     if (_status ?? false) {
  //       getAllTableData(page: 1);
  //       getData(page: pageIndex);
  //     }

  //     loadNewOrder = false;
  //     notify;
  //   }
  // }

  Future<PlaceOrderRes?> updateOrderSendToKit() async {
    final orderIds = <String>[];

    for (final e in tableList.tableDataList) {
      if (e.selected) orderIds.add(e.id);
    }

    loadNewOrder = true;
    notify;

    final status = await Handler.bulkOrderSendToKitUpdate(orderIds: orderIds);

    if (status != null) {
      getAllTableData(page: newOrderPage);
      getData(page: pageIndex);
    }

    loadNewOrder = false;
    notify;
    return status;
  }

  Future<bool?> acceptAllOrder() async {
    final orderIds = <String>[];

    for (final e in tableList.tableDataList) {
      if (e.selected) orderIds.add(e.id);
    }

    loadNewOrder = true;
    notify;

    final status = await Handler.bulkAcceptOrder(orderIds: orderIds);
    if (status != null) {
      getAllTableData(page: newOrderPage);
      getData(page: pageIndex);
    }

    loadNewOrder = false;
    notify;
    return status;
  }

  // pos order sent to kitchen
  Future<PlaceOrderRes?> orderSendToKitchen({
    String? orderId,
    bool? printAllItem,
  }) async {
    if (orderId == null) return null;
    loading = true;
    notify;

    PlaceOrderRes? _order;

    if ((GlobalCVP.storeInfo?.isSendToKitchenPrinter ?? false) ||
        (GlobalCVP.storeInfo?.isSendToKitchenDisplay ?? false)) {
      _order = await Handler.orderSentKitchen(
        orderId: orderId,
        printAllItem: printAllItem,
        isSendToPrinter: GlobalCVP.storeInfo?.isSendToKitchenPrinter ?? false,
        isSendToKitchen: GlobalCVP.storeInfo?.isSendToKitchenDisplay ?? false,
      );
    }
    loading = false;
    notify;
    return _order;
  }

  // pos order print invoice
  Future<MakePaymentRes?> orderPrintInvoice(String? orderId) async {
    if (orderId == null) return null;
    loading = true;
    notify;

    final payRes = await Handler.orderPayInvoice(orderId: orderId);

    loading = false;
    notify;

    return payRes;
  }

  // pos order print invoice
  Future<RefundPaymentRes?> orderRefundInvoice(String? orderId) async {
    if (orderId == null) return null;
    loading = true;
    notify;

    final payRes = await Handler.orderRefundInvoice(orderId: orderId);

    loading = false;
    notify;

    return payRes;
  }

  // pos order print invoice
  Future<EftposMerchantLogRes?> eftPosLog(String? orderId) async {
    if (orderId == null) return null;
    loading = true;
    notify;

    final payRes = await Handler.printEftPosMerchantLogs(orderId: orderId);

    loading = false;
    notify;

    return payRes;
  }

  bool isForRefund = false;
  // bool isRevokePayment = false;

  Future<void> getOrderDetailByIdForRefund({required String orderId}) async {
    loading = true;
    notify;
    // print("---------refund orderId------------- $orderId");
    oDById = await Handler.getOrderDeByIdForRefund(orderId: orderId);

    // print("----------refund data ------------- ${oDById?.toJson()}");

    // if (oDById?.orderDetailsViewModel?.orderStatus != null) {
    //   viewOrderSetData(
    //       status: OrderStatusModel.getStatus(
    //           oDById!.orderDetailsViewModel!.orderStatus!));
    // }

    // if (viewOrderStatusList.isNotEmpty &&
    //     oDById?.orderDetailsViewModel?.orderStatus != null) {
    //   orderStatusIndex = viewOrderStatusList.indexWhere(
    //       (e) => e.value == oDById!.orderDetailsViewModel!.orderStatus!);
    // }

    loading = false;
    notify;
  }

  // Future<bool?> makeTableStatusFree({
  //   String? tableId,
  //   String? tableName,
  // }) async {
  //   if (tableId == null || tableId.isEmpty) return null;
  //   final status = await Handler.updateTableStatusFree(
  //       tableId: tableId, tableName: tableName);
  //   return status;
  // }

  OrderAndSetmenu getOrderSetMenuFromOrder({bool isNewOrder = false}) {
    final orderDetail = <OrderDetail>[];
    final _setMenuDetail = <SetMenuOrderDetail>[];
    final ingreList = <RawIngredientOrderDetail>[];

    // split amount update case

    final typeIndex =
        double.tryParse(oDById?.orderDetailsViewModel?.paymentType ?? '0')
                ?.floor() ??
            0; //2- split item
    final isAmountRemain =
        oDById?.orderDetailsViewModel?.remainingAmountOnGiftPay?.inDouble ?? 0;

    final _allowRemove_1 = typeIndex == 2 && isAmountRemain == 0;

    final discountPercent = ((oDById?.orderDiscounts
                    ?.any((a) => a.discountType == DiscountType.General.name) ??
                false)
            ? (oDById?.orderDiscounts
                    ?.firstWhere(
                        (a) => a.discountType == DiscountType.General.name)
                    .discountPercentage
                    ?.inDouble ??
                0.0)
            : 0.0) +
        ((oDById?.orderDiscounts?.any((a) => a.discountType == DiscountType.Voucher.name) ?? false)
            ? (oDById?.orderDiscounts
                    ?.firstWhere(
                        (a) => a.discountType == DiscountType.Voucher.name)
                    .discountPercentage
                    ?.inDouble ??
                0.0)
            : 0.0) +
        ((oDById?.orderDiscounts?.any((a) => a.discountType == DiscountType.Promotion.name) ??
                    false) &&
                typeIndex != 2
            ? (oDById?.orderDiscounts
                    ?.firstWhere((a) => a.discountType == DiscountType.Promotion.name)
                    .discountPercentage
                    ?.inDouble ??
                0.0)
            : 0.0);

    // final voucherDiscount = oDById
    //         ?.orderPaymentDetailsWithPaymentStatusViewModel
    //         ?.voucherDiscountPercentage
    //         ?.inDouble ??
    //     0;
    // final discountPercent = voucherDiscount != 0
    //     ? voucherDiscount
    //     : (oDById?.orderPaymentDetailsWithPaymentStatusViewModel
    //             ?.discountPercentage?.inDouble ??
    //         0);

    // final _pubSurPer =
    //     oDById?.storeTaxSettings?.holidaySurgePercentage?.inDouble ?? 0;
    // final _creSurPer =
    //     oDById?.storeTaxSettings?.creditCardSurgePercentage?.inDouble ?? 0;

    // double _itemPaidChargeIfOrderUpdate = 0.0;

    ///split amount update case

    if (oDById?.setMenuWithPriceDetailsViewModel != null) {
      for (final e in oDById!.setMenuWithPriceDetailsViewModel!) {
        final _isCancelled =
            OrderUtils.getStatusEnum(e.statusId) == OrderStatusEnum.cancel;
        if (!_isCancelled) {
          final quantity = (double.tryParse(e.quantity ?? '1') ?? 1).round();

          final _amount = OrderUtils.getAmount(
            taxTypeString:
                oDById?.orderDetailsViewModel?.taxExclusiveInclusiveType,
            taxPercent: e.taxExclusiveInclusiveValue,
            price: e.setMenuPrice,
            quantity: quantity.toDouble(),
          );

          final _paidQty = e.paidQuantity?.inDouble ?? 0;

          if (_allowRemove_1 && _paidQty > 0) {
            // final _allModiPaidPrice = e.setMenuProductViewModel?.fold<double>(
            //         0.0,
            //         (pV1, e1) =>
            //             pV1 +
            //             (e1.orderItemsPriceModifierViewModels?.fold<double>(
            //                     0.0,
            //                     (pV2, e2) =>
            //                         pV2 + _paidQty * (e2.modifierPrice ?? 0)) ??
            //                 0)) ??
            //     0;

            double _totalPrice =
                _amount.itemPrice * _paidQty; // + _allModiPaidPrice;

            if (discountPercent != 0) {
              _totalPrice = _totalPrice * (1 - (discountPercent / 100));
            }

            // double _tempPrice = _totalPrice;

            // if ((e.isPublicHolidaySurchargeUsed ?? false) && _pubSurPer != 0) {
            //   _tempPrice = _tempPrice * (1 + (_pubSurPer / 100));
            // }

            // if ((e.isCreditCardSurchargeUsed ?? false) && _creSurPer != 0) {
            //   _tempPrice = _tempPrice * (1 + (_creSurPer / 100));
            // }

            // _itemPaidChargeIfOrderUpdate += _tempPrice - _totalPrice;
          }

          final currentPayQty = e.currentPaidQuantity?.inDouble ?? 0;

          final paidAmount = e.paidAmount?.inDouble ?? 0;

          final _kitStatus = OrderUtils.getItemStatusEnum(e.kitchenStatus);

          final _disabled = ((typeIndex == 2 && _paidQty > 0) ||
                  (typeIndex == 2 && currentPayQty != 0)) ||
              ((typeIndex == 3 || typeIndex == 1) &&
                  (_paidQty > 0 || paidAmount > 0)) ||
              _allowRemove_1 && e.quantity?.inDouble == _paidQty ||
              _kitStatus == ItemStatusEnum.preparing ||
              _kitStatus == ItemStatusEnum.prepared;

          final double _cPQ =
              _paidQty != 0 ? quantity.toDouble() - _paidQty : 0.0;

          _setMenuDetail.add(
            SetMenuOrderDetail(
              id: isNewOrder ? "" : e.id,
              setMenuId: e.setMenuId,
              setMenuName: e.setMenuName,
              setMenuQuantity: quantity,
              initQty: quantity,
              paymentType: typeIndex,
              currentPayQty: _cPQ,
              setMenuPrice: _amount.itemPrice,
              partialPayQty: currentPayQty,
              totalSetMenuPrice: _amount.totalPrice,
              disabled: _disabled,
              imgPath: e.image,
              description: e.description ?? '',
              taxType: _amount.taxType,
              taxPercent: _amount.taxPercent,
              originalSellingAmount: _amount.itemPrice.roundToNString(),
              totalTax: _amount.totalTax.roundToNString(),
              orderItemsViewModels: e.setMenuProductViewModel
                  ?.map((f) => OrderItemsViewModel(
                        id: isNewOrder ? "" : f.id,
                        productVariationId: f.productVariationId,
                        productName: f.productName,
                        name: f.name,
                        productVariationName: f.productVariationName,
                        orderItemsPriceModifierViewModels: f
                            .orderItemModifiersViewModels
                            ?.map((e) => isNewOrder ? (e..id = "") : e)
                            .toList(),
                        // removedOrderItemsIngredientsViewModels: f
                        //     .removedOrderItemIngredientViewModels
                        //     ?.map((e) => isNewOrder ? (e..id = "") : e)
                        //     .toList(),
                        quantity: f.quantity,
                      ))
                  .toList(),
              isPubChargeEnable: e.isPublicHolidaySurchargeUsed,
              isCreditChargeEnable: e.isCreditCardSurchargeUsed,
              statusId: e.statusId,
              kitchenStatus: e.kitchenStatus,
              discountPercentage: e.discountPercentage,
            ),
          );
        }
      }
    }

    if (oDById?.productWithPriceDetailsViewModel != null) {
      for (int i = 0;
          i < oDById!.productWithPriceDetailsViewModel!.length;
          i++) {
        final e = oDById!.productWithPriceDetailsViewModel![i];
        final _isCancelled =
            OrderUtils.getStatusEnum(e.statusId) == OrderStatusEnum.cancel;
        if (!_isCancelled) {
          final _quantity = (double.tryParse(e.quantity ?? '1') ?? 1);
          final _amount = OrderUtils.getAmount(
            taxTypeString:
                oDById?.orderDetailsViewModel?.taxExclusiveInclusiveType,
            taxPercent: e.taxPercentage,
            price: e.productPrice,
            quantity: _quantity,
            isNoTax: e.isTaxExempt,
          );

          /// half item //

          final _newKey = Utils.getRandomString(8);

          /// //
          final _paidQty = e.paidQuantity?.inDouble ?? 0;

          if (_allowRemove_1 && _paidQty > 0) {
            // final _allModiPaidPrice = e.orderItemsPriceModifierViewModels
            //         ?.fold<double>(
            //             0.0,
            //             (pV2, e2) =>
            //                 pV2 + _paidQty * (e2.modifierPrice ?? 0)) ??
            //     0;

            double _totalPrice =
                _amount.itemPrice * _paidQty; // + _allModiPaidPrice;

            if (discountPercent != 0) {
              // print("_discountPercent: $_discountPercent");
              _totalPrice = _totalPrice * (1 - (discountPercent / 100));
            }

            // double _tempPrice = _totalPrice;

            // if ((e.isPublicHolidaySurchargeUsed ?? false) && _pubSurPer != 0) {
            //   // print("_pubSurPer: $_pubSurPer");
            //   _tempPrice = _tempPrice * (1 + (_pubSurPer / 100));
            // }

            // if ((e.isCreditCardSurchargeUsed ?? false) && _creSurPer != 0) {
            //   // print("_creSurPer: $_creSurPer");
            //   _tempPrice = _tempPrice * (1 + (_creSurPer / 100));
            // }

            // // print("_tempPrice: $_tempPrice | _totalPrice: $_totalPrice");

            // _itemPaidChargeIfOrderUpdate += _tempPrice - _totalPrice;
          }
          final currentlyPaidQty = e.currentPaidQuantity?.inDouble ?? 0;

          final _paidAmount = e.paidAmount?.inDouble ?? 0;

          final _kitStatus = OrderUtils.getItemStatusEnum(e.kitchenStatus);

          final _deepKitStatus =
              OrderUtils.prodType(e.productType) != ProductType.Item &&
                  (e.orderItemModifiersViewModels?.any((f) {
                        final _st =
                            OrderUtils.getItemStatusEnum(f.kitchenStatus);

                        return _st == ItemStatusEnum.preparing ||
                            _st == ItemStatusEnum.prepared;
                      }) ??
                      false);

          final _disabled = isNewOrder
              ? false
              : (( //(typeIndex == 2 && _paidQty > 0) ||
                      (typeIndex == 2 && currentlyPaidQty != 0)) ||
                  ((typeIndex == 3 || typeIndex == 1) &&
                      (_paidQty > 0 || _paidAmount > 0)) ||
                  _allowRemove_1 && e.quantity?.inDouble == _paidQty ||
                  _kitStatus == ItemStatusEnum.preparing ||
                  _kitStatus == ItemStatusEnum.prepared ||
                  _deepKitStatus);
          // remaining pay quantity
          final double _cPQ =
              _paidQty != 0 ? _quantity.toDouble() - _paidQty : 0.0;
          // kPrint(
          //     "_quantity: $_quantity | currentlyPaidQty; $currentlyPaidQty | _paidQty: $_paidQty | _cPQ: $_cPQ");
          final _isHalforCombo =
              OrderUtils.prodType(e.productType) == ProductType.Half ||
                  OrderUtils.prodType(e.productType) == ProductType.Combo;

          // deal_sec
          final _productPriceType =
              OrderUtils.productPriceType(e.productPriceType);
          final _isDeal = _isHalforCombo &&
              _productPriceType == ProductPriceType.MakeYourOwn;

          if (e.orderItemModifiersViewModels != null && _isDeal)
            for (final a in e.orderItemModifiersViewModels!) {
              a.isHalforCombo = _isHalforCombo;
              if (a.modifierItemsModifierViewModels?.any((d) =>
                      (d.labelName?.toLowerCase().contains('half') ?? false) ||
                      (d.labelName?.toLowerCase().contains('quarter') ??
                          false)) ??
                  false) {
                a.isDealsHalf = true;
                // kPrint("a : ${a.modifierName} ${a.type} ${a.modifierPrice} ");
              }

              if (a.modifierItemsModifierViewModels != null)
                for (final b in a.modifierItemsModifierViewModels!) {
                  // kPrint("b : ${b.modifierName}");
                  b.isHalforCombo = _isHalforCombo;
                  if ((b.labelName?.toLowerCase().contains('half') ?? false) ||
                      (b.labelName?.toLowerCase().contains('quarter') ??
                          false)) {
                    if (b.modifierItemsModifierViewModels != null)
                      for (final c in b.modifierItemsModifierViewModels!) {
                        // kPrint("c : ${c.modifierName}");
                        c.isDealModifier = true;
                      }
                  } else {
                    b.isDealModifier = true;
                  }
                }
            }

          orderDetail.add(OrderDetail(
            id: isNewOrder ? "" : e.id,
            key: _newKey,
            productId: e.productId,
            productVariationId: e.productVariationId,
            // categoryTypeId: e.categoryTypeId,
            catId: e.productCategoryId,
            productName: e.name,
            quantity: _quantity,
            initQty: _quantity,
            currentPayQty: _cPQ,
            paymentType: typeIndex,
            partialPayQty: currentlyPaidQty == 0 ? _paidQty : currentlyPaidQty,
            disabled: _disabled,
            productPrice: _amount.itemPrice,
            originalSellingAmount: _amount.itemPrice.roundToNString(),
            total: _amount.totalPrice,
            totalTax: _amount.totalTax.roundToNString(),
            imgPath: e.image,
            description: e.description ?? '',
            taxType: _amount.taxType,
            taxPercent: _amount.taxPercent,
            discountPercentage: e.discountPercentage,
            orderItemModifiersViewModels: e.orderItemModifiersViewModels
                ?.map((e) => isNewOrder ? (e..id = "") : e
                  ..isHalforCombo = _isHalforCombo)
                .toList(),
            orderItemSelectOptionsViewModels: e.orderItemSelectOptionsViewModels
                ?.map((e) => isNewOrder ? (e..id = "") : e)
                .toList(),
            // orderItemSpiceChoiceViewModel: e.orderItemSpiceChoiceViewModel
            //   ?..id = isNewOrder ? "" : e.orderItemSpiceChoiceViewModel?.id,
            docketGroupName: e.docketGroupName,
            docketGroupSort: e.docketGroupSort?.toString(),
            enableDocketGroupSpliter: e.enableDocketGroupSpliter,
            // isHalfItem: _isHalfnHalf,
            // removedOrderItemsIngredientsViewModels: e
            //     .removedOrderItemIngredientViewModels
            //     ?.map((e) => isNewOrder ? (e..id = "") : e)
            //     .toList(),
            batchNumber: e.batchNumber,
            orderItemsServiceEmployeeViewModels: e
                .orderItemsServiceEmployeeViewModels
                ?.map((e) => isNewOrder ? (e..id = "") : e)
                .toList(),
            bookedTime: (e.bookedTime.inDouble / e.quantity.inDouble)
                .floor()
                .toString(),
            productType: e.productType,
            productPriceType: e.productPriceType,
            isPubChargeEnable: e.isPublicHolidaySurchargeUsed,
            isCreditChargeEnable: e.isCreditCardSurchargeUsed,
            statusId: e.statusId,
            kitchenStatus: e.kitchenStatus,
            preparationType: e.preparationType,
          ));
        }
      }
    }

    if (oDById?.rawIngredientWithPriceDetailsViewModel != null) {
      for (final e in oDById!.rawIngredientWithPriceDetailsViewModel!) {
        final _isCancelled =
            OrderUtils.getStatusEnum(e.statusId) == OrderStatusEnum.cancel;
        if (!_isCancelled) {
          final quantity = (double.tryParse(e.quantity ?? '1') ?? 1);

          final _amount = OrderUtils.getAmount(
            taxTypeString:
                oDById?.orderDetailsViewModel?.taxExclusiveInclusiveType,
            taxPercent: e.taxValue,
            price: e.originalSellingPricePerUnit,
            quantity: quantity.toDouble(),
          );

          final paidQty = e.paidQuantity?.inDouble ?? 0;

          if (_allowRemove_1 && paidQty > 0) {
            double totalPrice = _amount.totalPrice;

            if (discountPercent != 0) {
              totalPrice = totalPrice * (1 - (discountPercent / 100));
            }

            // double _tempPrice = _totalPrice;

            // if ((e.isPublicHolidaySurchargeUsed ?? false) && _pubSurPer != 0) {
            //   _tempPrice = _tempPrice * (1 + (_pubSurPer / 100));
            // }

            // if ((e.isCreditCardSurchargeUsed ?? false) && _creSurPer != 0) {
            //   _tempPrice = _tempPrice * (1 + (_creSurPer / 100));
            // }

            // _itemPaidChargeIfOrderUpdate += _tempPrice - _totalPrice;
          }

          final currentlyPaidQty = e.currentPaidQuantity?.inDouble ?? 0;

          final paidAmount0 = e.paidAmount?.inDouble ?? 0;

          final disabled = ((typeIndex == 2 && paidQty > 0) ||
                  (typeIndex == 2 && currentlyPaidQty != 0)) ||
              ((typeIndex == 3 || typeIndex == 1) &&
                  (paidQty > 0 || paidAmount0 > 0)) ||
              _allowRemove_1 && e.quantity?.inDouble == paidQty;

          final double cPQ = paidQty != 0 ? quantity.toDouble() - paidQty : 0.0;

          ingreList.add(RawIngredientOrderDetail(
            id: isNewOrder ? "" : e.id,
            rawIngredientId: e.rawIngredientId,
            partialPayQty: currentlyPaidQty,
            unitOfMeasurementId: e.unitOfMeasurementId,
            quantity: quantity,
            initQty: quantity,
            paymentType: typeIndex,
            disabled: disabled,
            currentPayQty: cPQ,
            originalSellingPricePerUnit: _amount.itemPrice,
            totalSellingPrice: (_amount.itemPrice * quantity).roundToNString(),
            name: e.name,
            stockCount: double.tryParse(e.stockCount ?? ''),
            taxType: _amount.taxType,
            taxPercent: _amount.taxPercent,
            totalTax: _amount.totalTax.roundToNString(),
            maxToMinConversionFactor: e.maxToMinConversionFactor,
            isPubChargeEnable: e.isPublicHolidaySurchargeUsed,
            isCreditChargeEnable: e.isCreditCardSurchargeUsed,
            statusId: e.statusId,
            discountPercentage: e.discountPercentage,
          ));
        }
      }
    }

    // print("Total: $_itemPaidChargeIfOrderUpdate");

    double _itemPaidChargeIfOrderUpdate = 0.0;
    double _paidDiscount = 0.0;

    final _taxType =
        OrderUtils.getTaxType(GlobalCVP.storeInfo?.taxExclusiveInclusiveType);

    if (_taxType == TaxType.Inclusive) {
      _itemPaidChargeIfOrderUpdate = (oDById
                  ?.orderPaymentDetailsWithPaymentStatusViewModel
                  ?.holidaySurgeAmountWithTax
                  ?.inDouble ??
              0) +
          (oDById?.orderPaymentDetailsWithPaymentStatusViewModel
                  ?.creditCardSurgeAmountWithTax?.inDouble ??
              0) +
          (oDById?.orderPaymentDetailsWithPaymentStatusViewModel
                  ?.serviceChargeAmount?.inDouble ??
              0);

      _paidDiscount = (oDById?.orderPaymentDetailsWithPaymentStatusViewModel
              ?.discountWithTax?.inDouble ??
          0);
    } else {
      _itemPaidChargeIfOrderUpdate = (oDById
                  ?.orderPaymentDetailsWithPaymentStatusViewModel
                  ?.holidaySurgeAmount
                  ?.inDouble ??
              0) +
          (oDById?.orderPaymentDetailsWithPaymentStatusViewModel
                  ?.creditCardSurgeAmount?.inDouble ??
              0) +
          (oDById?.orderPaymentDetailsWithPaymentStatusViewModel
                  ?.serviceChargeAmount?.inDouble ??
              0);
      _paidDiscount = (oDById?.orderPaymentDetailsWithPaymentStatusViewModel
              ?.discount?.inDouble ??
          0);
    }

    return OrderAndSetmenu(
      orderDetailList: orderDetail,
      setMenuList: _setMenuDetail,
      ingreList: ingreList,
      itemPaidChargeIfOrderUpdate: _itemPaidChargeIfOrderUpdate,
      discountPer:
          // _allowRemove_1 // && _itemPaidChargeIfOrderUpdate != 0
          // ?
          discountPercent,
      // : 0.0,
      paymentType: typeIndex,
      paidDiscount: _paidDiscount,
    );
  }

  // send sms //
  Future<void> getSmsCusDetails(String orderId) async {
    selectedCountryCode = 0;
    loading = true;
    notify;
    final res = await Handler.getSmsCusDetails(orderId: orderId);

    countryList = List<UserAddSecData>.from(GlobalCVP.allAddSection["countries"]
        .map((x) => UserAddSecData.fromJson(x)));

    // await Handler.getInitCountryList();

    if (countryList?.any((e) => e.additionalValue == res?.phoneNumberPrefix) ??
        false) {
      selectedCountryCode = countryList?.indexWhere(
              (e) => e.additionalValue == res?.phoneNumberPrefix) ??
          0;
    } else if (countryList?.any((e) => e.name! == "Australia") ?? false) {
      selectedCountryCode =
          countryList?.indexWhere((e) => e.name! == "Australia") ?? 0;
    }

    _smsOrderId = orderId;

    smsNameCltr.text = res?.customerName ?? '';
    smsPhoneCltr.text = res?.phoneNumber ?? '';
    // smsCountryCode = _res?.phoneNumberPrefix ?? '';

    final storeName = GlobalCVP.currentStore?.name ?? '';
    smsMessageCltr.text = """
${LN.hi} ${res?.customerName ?? ''},
${LN.yourOrderReady}.
${LN.thankYou}!

$storeName""";

    loading = false;
    notify;
  }

  List<UserAddSecData>? countryList;
  int selectedCountryCode = 0;

  final smsNameCltr = TextEditingController();
  final smsPhoneCltr = TextEditingController();

  // String smsCountryCode = "";
  String? _smsOrderId;

  final smsMessageCltr = TextEditingController();

  bool sendSmsBtnLoad = false;

  Future<void> sendSmsOrderReady(BuildContext ctx) async {
    sendSmsBtnLoad = true;
    notify;

    await Handler.sendOrderReadySms(
      smsSendReq: OrderSmsSendReq(
        orderId: _smsOrderId,
        message: smsMessageCltr.text,
        phoneNumber: smsPhoneCltr.text,
        phoneNumberPrefix: (countryList?.isNotEmpty ?? false)
            ? countryList![selectedCountryCode].additionalValue
            : "",
      ),
      diaCtx: ctx,
    );
    sendSmsBtnLoad = false;
    notify;
  }

  // change pay methods

  List<PaymentMethodSec>? payMethodList;
  Future<void> getPayMethods() async {
    // updatePayLoad = true;
    // notify;

    payMethodList = List<PaymentMethodSec>.from(GlobalCVP
        .allAddSection["paymentMethods"]
        .map((x) => PaymentMethodSec.fromJson(x)));

    // payMethodList = await Handler.getPayMethods();

    updatePayLoad = false;
    notify;
  }

  bool updatePayLoad = false;

  Future<bool> updatePayMethod(String? id) async {
    if (!(payMethodList?.any((e) => e.isSelected ?? false) ?? false))
      return false;

    final _methodId =
        payMethodList?.firstWhere((e) => e.isSelected ?? false).id;
    updatePayLoad = true;
    notify;

    final _status = await Handler.updatePayMethod(id: id, methodId: _methodId);

    if (_status ?? false) {
      getOrderDeById(orderId: oDById?.orderDetailsViewModel?.orderId ?? '');
      getData();
    }

    updatePayLoad = false;
    notify;

    return _status ?? false;
  }

  void confirmOrderStk({String? orderId}) {
    if (orderId == null) return;
    Handler.confirmOrderSendToKitPrint(data: [
      {
        "OrderId": orderId,
        "SessionId": "",
        "IsOrderPrinted": true,
      }
    ]);
  }

  // revoke order
  Future<void> revokeOrder({String? orderId}) async {
    if (orderId == null) return;

    loading = true;
    notify;

    final _status = await Handler.revokeOrder(orderId: orderId);
    if (_status) {
      channelStatusIndex = (orderDetailSecRes?.orderStatus?.any((a) =>
                  a.name?.toLowerCase().contains('payment pending') ?? false) ??
              false)
          ? orderDetailSecRes?.orderStatus?.indexWhere(
              (a) => a.name?.toLowerCase().contains('payment pending') ?? false)
          : null;
      await getData();
    }
    loading = false;
    notify;
  }
}

enum OrderStatus {
  All,
  Pending,
  OnTheWay,
  PaymentPending,
  PaymentCompleted,
  Delivered,
  Cancel,
  Refund
}

class OrderStatusModel {
  final int? id;
  final String? name;
  final OrderStatus? status;

  const OrderStatusModel({this.id, this.name, this.status});

  static List<OrderStatusModel> get orderStatus {
    final status = [
      OrderStatusModel(id: 0, name: "All", status: OrderStatus.All),
      OrderStatusModel(id: 1, name: "Pending", status: OrderStatus.Pending),
      OrderStatusModel(
          id: 2, name: "Payment Pending", status: OrderStatus.PaymentPending),
      OrderStatusModel(
          id: 3,
          name: "Payment Completed",
          status: OrderStatus.PaymentCompleted),
      OrderStatusModel(id: 4, name: "On the Way", status: OrderStatus.OnTheWay),
      OrderStatusModel(id: 5, name: "Delivered", status: OrderStatus.Delivered),
      OrderStatusModel(id: 6, name: "Cancel", status: OrderStatus.Cancel),
      OrderStatusModel(id: 7, name: "Refund", status: OrderStatus.Refund),
    ];
    return status;
  }

  static OrderStatus? getStatus(String? val) {
    if (orderStatus.any((e) => e.name == val)) {
      return orderStatus.firstWhere((f) => f.name == val).status;
    }
    return null;
  }

  static String? getString(OrderStatus status) {
    if (orderStatus.any((e) => e.status == status)) {
      return orderStatus.firstWhere((f) => f.status == status).name;
    }
    return null;
  }
}

class OrderAndSetmenu {
  final List<SetMenuOrderDetail> setMenuList;
  final List<OrderDetail> orderDetailList;
  final List<RawIngredientOrderDetail> ingreList;
  final double itemPaidChargeIfOrderUpdate;
  final double discountPer;
  final int? paymentType;
  final double paidDiscount;

  OrderAndSetmenu({
    required this.setMenuList,
    required this.orderDetailList,
    required this.ingreList,
    this.itemPaidChargeIfOrderUpdate = 0.0,
    this.discountPer = 0.0,
    this.paymentType,
    this.paidDiscount = 0.0,
  });
}
