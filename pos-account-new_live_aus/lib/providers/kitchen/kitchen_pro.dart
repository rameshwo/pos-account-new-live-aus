import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/menu/kitchen/kitchen_all_orders.dart';
import 'package:pos_account/model/home/menu/orders/order_detail_sec_res.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/repository/handler.dart';
import 'package:pos_account/services/database/shared_pref.dart';

class KitchenPro extends ChangeNotifier {
  void get notify => notifyListeners();

  bool loading = true;

  OrderDetailSecRes? orderDetailSecRes;
  int? channelIndex = 0;
  int? orderTypeIndex = 0;
  int? tableIndex = 0;
  int? channelStatusIndex = 0;
  int? orderStatus = 0;

  final searchCltr = TextEditingController();

  final int _orderPageSize = 8;
  int pageIndex = 1;
  int _orderTotalPage = 0;
  final orderList = <KitOrderItem>[];

  final dateCltr = TextEditingController();
  String? dateFormat;

  KitOrderStatusEnum? get kitOrderStatus => channelStatusIndex != null
      ? getKitOrStatus(
          orderDetailSecRes?.orderStatus?[channelStatusIndex!].value)
      : null;

  Future<void> getOrDeSec() async {
    dateFormat = await SharedPrefs.dateFormat;
    setDefaultDate();
    orderDetailSecRes = OrderDetailSecRes.fromJson(GlobalCVP.allAddSection);
    //  await Handler.getKdOrderSecList();
    // loading = false;
    notify;
    getData();
  }

  void setDefaultDate() {
    dateCltr.text =
        DateFormat(dateFormat?.split(' ').first).format(DateTime.now());
  }

  Future<void> getData({
    int page = 1,
    bool autoUpdate = false,
  }) async {
    String searchKey = "";
    String storeChannelId = "";
    String orderStatusId = "";
    String orderTypeId = "";
    String tableId = "";

    if (orderDetailSecRes != null) {
      if (channelIndex != null) {
        storeChannelId =
            orderDetailSecRes!.orderChannels?[channelIndex!].id ?? '';
      }

      if (orderTypeIndex != null) {
        orderTypeId = orderDetailSecRes!.orderTypes?[orderTypeIndex!].id ?? '';
      }

      if (channelStatusIndex != null) {
        orderStatusId =
            orderDetailSecRes!.orderStatus![channelStatusIndex!].id ?? '';
      }

      if (tableIndex != null) {
        tableId = orderDetailSecRes!.tables?[tableIndex!].id ?? '';
      }
      searchKey = searchCltr.text;
    }

    final newOrderList = <KitOrderData>[];
    List<KitOrderItem>? removedOrderList;

    if (page == 1 || pageIndex * _orderPageSize < _orderTotalPage) {
      if (!autoUpdate) pageIndex = page;

      final allOrdersRes = await Handler.getKDOrders(
        searchKey: searchKey,
        storeChannelId: storeChannelId,
        orderStatusId: orderStatusId,
        orderTypeId: orderTypeId,
        tableId: tableId,
        date: dateCltr.text,
        page: page,
        pageSize: autoUpdate && _orderPageSize < orderList.length
            ? (orderList.length + 1)
            : _orderPageSize,
      );

      if (page == 1 && !autoUpdate) {
        orderList.clear();
      }

      if (allOrdersRes?.data != null) {
        _orderTotalPage = allOrdersRes?.total ?? 0;

        if (autoUpdate) {
          final oldOrderList = <KitOrderData>[];

          for (final a in allOrdersRes!.data!) {
            if (orderList.any(
                (b) => b.orderData.id?.toLowerCase() == a.id?.toLowerCase())) {
              oldOrderList.add(a);
            } else {
              newOrderList.add(a);
            }
          }

          removedOrderList = orderList.any((b) => !oldOrderList.any(
                  (c) => c.id?.toLowerCase() == b.orderData.id?.toLowerCase()))
              ? orderList
                  .where((b) => !oldOrderList.any((c) =>
                      c.id?.toLowerCase() == b.orderData.id?.toLowerCase()))
                  .toList()
              : null;

          if (removedOrderList?.isNotEmpty ?? false) {
            for (final t in removedOrderList!) {
              final index = orderList.indexWhere((k) =>
                  k.orderData.id?.toLowerCase() ==
                  t.orderData.id?.toLowerCase());
              await removeItem(index);
            }
          }

          orderList.clear();
          orderList.addAll(
              oldOrderList.map((e) => KitOrderItem(orderData: e)).toList());
        } else {
          orderList.addAll(allOrdersRes!.data!
              .map((e) => KitOrderItem(orderData: e))
              .toList());
        }

        //TODO: sorting

        if (kitOrderStatus == KitOrderStatusEnum.Preparing) {
          final nonZeroList = <KitOrderItem>[];
          final zeroList = <KitOrderItem>[];

          for (final item in orderList) {
            if (item.orderData.prioritizeSortOrder == null ||
                item.orderData.prioritizeSortOrder == "" ||
                item.orderData.prioritizeSortOrder == "0") {
              zeroList.add(item);
            } else {
              nonZeroList.add(item);
            }
          }

          nonZeroList.sort((a, b) => int.parse(a.orderData.prioritizeSortOrder!)
              .compareTo(int.parse(b.orderData.prioritizeSortOrder!)));
          orderList.clear();
          orderList.addAll([...nonZeroList, ...zeroList]);

          orderList.forEach((e) {
            e.orderData.orderItems?.sort(
                (a, b) => (a.isPrepared ?? false) == (b.isPrepared ?? false)
                    ? 0
                    : (a.isPrepared ?? false)
                        ? -1
                        : 1);
            e.orderData.setMenuOrders?.forEach((f) => f.setMenuOrderItems?.sort(
                (a, b) => (a.isPrepared ?? false) == (b.isPrepared ?? false)
                    ? 0
                    : (a.isPrepared ?? false)
                        ? -1
                        : 1));
          });
        }
      }
    }

    loading = false;
    notify;

    // print("_newOrderList : ${_newOrderList.length}");

    if (autoUpdate && newOrderList.isNotEmpty) {
      for (final e in newOrderList) {
        await addItem(KitOrderItem(orderData: e),
            index: kitOrderStatus == KitOrderStatusEnum.Preparing
                ? orderList.length
                : 0);
      }
    }
  }

  String? loadingId;

  Future<bool?> updateOrderStatus(
    String? orderId, {
    required KitOrderStatusEnum kitOrSt,
  }) async {
    final orderStatusId = getOrderStatusId(kitOrSt);
    if (orderStatusId == null || orderId == null) return null;

    loadingId = orderId;
    loading = true;
    notify;

    final status = await Handler.kitOrderStatusUpdate(
        orderId: orderId, orderStatusId: orderStatusId);

    if (status ?? false) {
      showToast(
        "Order Status is updated successfully",
        backgroundColor: Colors.amber.shade800,
        textStyle: TextStyle(
            color: Colors.white, fontFamily: kFontFMedium, fontSize: 16),
      );
    }

    loadingId = null;
    loading = false;
    notify;

    return status;
  }

  KitOrderStatusEnum getKitOrStatus(String? val) {
    if (val != null && val.toLowerCase().contains("complete"))
      return KitOrderStatusEnum.Completed;
    else if (val != null && val.toLowerCase().contains("prepar"))
      return KitOrderStatusEnum.Preparing;
    else
      return KitOrderStatusEnum.NewOrders;
  }

  String? getOrderStatusId(KitOrderStatusEnum val) {
    if (orderDetailSecRes?.orderStatus
            ?.any((e) => getKitOrStatus(e.value) == val) ??
        false) {
      final data = orderDetailSecRes?.orderStatus
          ?.firstWhere((e) => getKitOrStatus(e.value) == val)
          .id;
      return data;
    } else
      return null;
  }

  Future<void> priorOrder(bool val, {String? orderId}) async {
    final dataList = <Map<String, String>>[];
    if (!val) {
      for (int i = 0; i < orderList.length; i++) {
        final priData =
            double.tryParse(orderList[i].orderData.prioritizeSortOrder ?? '') ??
                0;
        if (i == 0 || priData != 0) {
          dataList.add({
            "OrderId": orderList[i].orderData.id ?? '',
            "PrioritizeOrder": "${i + 1}",
          });
        }
      }
    } else if (orderId != null) {
      dataList.add({
        "OrderId": orderId,
        "PrioritizeOrder": "0",
      });
    }

    await Handler.kitPriorOrder(dataList: dataList);
  }

  /// return 1: only item status update | return 2: order update
  Future<int?> orderItemStatusUpdate({
    String? orderId,
    String? itemId,
    bool isSetmenu = false,
    bool isPrepared = true,
    String? orderNum,
  }) async {
    if (itemId == null) return null;

    loadingId = itemId;
    loading = true;
    notify;

    final status = await Handler.kitOrderItemStatusUpdate(
      orderId: orderId,
      orderItemIds: isSetmenu ? null : [itemId],
      setmenuIds: isSetmenu ? [itemId] : null,
      isPrepared: isPrepared,
    );

    if (status ?? false) {
      showToast(
        LN.orderStatusChangeSucc,
        backgroundColor: Colors.green.shade800,
        textStyle: TextStyle(
            color: Colors.white, fontFamily: kFontFMedium, fontSize: 16),
      );
    }

    loadingId = null;
    loading = false;
    notify;

    if (status ?? false) {
      final updatedData = await _getOrderData(orNum: orderNum ?? "");

      if (updatedData != null &&
          orderList.any(
              (a) => a.orderData.id?.toLowerCase() == orderId?.toLowerCase())) {
        final orderIndex = orderList.indexWhere(
            (b) => b.orderData.id?.toLowerCase() == orderId?.toLowerCase());

        //TODO: sorting

        updatedData.orderData
          ..orderItems?.sort(
              (a, b) => (a.isPrepared ?? false) == (b.isPrepared ?? false)
                  ? 0
                  : (a.isPrepared ?? false)
                      ? -1
                      : 1)
          ..setMenuOrders?.forEach((e) => e.setMenuOrderItems?.sort(
              (a, b) => (a.isPrepared ?? false) == (b.isPrepared ?? false)
                  ? 0
                  : (a.isPrepared ?? false)
                      ? -1
                      : 1));

        orderList[orderIndex] = updatedData;
        notify;

        if ((orderList[orderIndex]
                    .orderData
                    .orderItems
                    ?.every((c) => c.isPrepared ?? false) ??
                false) &&
            (orderList[orderIndex].orderData.setMenuOrders?.every((c) =>
                    c.setMenuOrderItems?.every((d) => d.isPrepared ?? false) ??
                    false) ??
                false)) {
          final stat = await updateOrderStatus(
            orderId,
            kitOrSt: KitOrderStatusEnum.Completed,
          );
          if (stat ?? false) {
            await removeItem(orderIndex);
            return 2;
          }
        }
      }
    }

    return 1;
  }

  Future<KitOrderItem?> _getOrderData({
    String orNum = "",
  }) async {
    String storeChannelId = "";
    String orderStatusId = "";
    String orderTypeId = "";
    String tableId = "";

    if (orderDetailSecRes != null) {
      if (channelIndex != null) {
        storeChannelId =
            orderDetailSecRes!.orderChannels?[channelIndex!].id ?? '';
      }

      if (orderTypeIndex != null) {
        orderTypeId = orderDetailSecRes!.orderTypes?[orderTypeIndex!].id ?? '';
      }

      if (channelStatusIndex != null) {
        orderStatusId =
            orderDetailSecRes!.orderStatus![channelStatusIndex!].id ?? '';
      }

      if (tableIndex != null) {
        tableId = orderDetailSecRes!.tables?[tableIndex!].id ?? '';
      }
    }

    final res = await Handler.getKDOrders(
      searchKey: orNum,
      storeChannelId: storeChannelId,
      orderStatusId: orderStatusId,
      orderTypeId: orderTypeId,
      tableId: tableId,
      date: dateCltr.text,
      page: 1,
      pageSize: 1,
    );
    if (res?.data?.isNotEmpty ?? false) {
      return KitOrderItem(orderData: res!.data!.first);
    }
    return null;
  }

  // widget add and remove functions
  bool isPriotizing = false;
  int get _id => Random().nextInt(10000);

  Future<void> addItem(KitOrderItem item, {int index = 0}) async {
    isPriotizing = true;
    orderList.insert(
        index,
        item
          ..tempId = _id
          ..show = false
          ..showOpa = false);
    notify;
    await Future.delayed(Duration(milliseconds: 300), () {
      orderList[index].show = true;
      notify;
    });
    await Future.delayed(Duration(milliseconds: 520), () {
      orderList[index].showOpa = true;
      isPriotizing = false;
      notify;
    });
  }

  Future<void> removeItem(int index) async {
    isPriotizing = true;
    orderList[index].showOpa = false;
    notify;

    await Future.delayed(Duration(milliseconds: 300), () {
      orderList[index].show = false;

      notify;
    });

    await Future.delayed(Duration(milliseconds: 420), () {
      orderList.removeAt(index);
      isPriotizing = false;
      notify;
    });
  }

  void clear() {
    loading = true;
    channelIndex = 0;
    orderTypeIndex = 0;
    tableIndex = 0;
    channelStatusIndex = 0;
    searchCltr.clear();
    orderDetailSecRes = null;
    setDefaultDate();
  }
}

class KitOrderItem {
  bool show;
  bool showOpa;
  KitOrderData orderData;
  int? tempId;

  KitOrderItem({
    this.show = true,
    this.showOpa = true,
    this.tempId,
    required this.orderData,
  });

  factory KitOrderItem.fromJson(Map<String, dynamic> json) => KitOrderItem(
        orderData: KitOrderData.fromJson(json["kitOrderData"]),
      );

  Map<String, dynamic> toJson() => {
        "kitOrderData": orderData.toJson(),
      };
}

enum KitOrderStatusEnum { NewOrders, Preparing, Completed }
