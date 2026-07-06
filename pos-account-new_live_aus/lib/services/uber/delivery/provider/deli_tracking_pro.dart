import 'package:flutter/material.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/repository/handler.dart';
import 'package:pos_account/services/database/shared_pref.dart';
import 'package:pos_account/services/uber/delivery/model/track/deli_track_list.dart';
import 'package:pos_account/services/uber/delivery/model/track/status_res.dart';
import 'package:pos_account/services/uber/delivery/model/track/track_detail_res.dart';

class DeliTrackPro extends ChangeNotifier {
  void get notify => notifyListeners();

  bool pageLoad = true;

  /// track deliveries
  int deliveryStatusIndex = 0;

  void clearTrack() {
    pageLoad = true;
    deliveryStatusIndex = 0;
    _orderTotalPage = 0;
    orderList.clear();
  }

  DeliTrackStatus? deliTrackStatus;
  String curSym = '';

  Future<void> getData() async {
    curSym = await SharedPrefs.curSym;
    deliTrackStatus = DeliTrackStatus.fromJson(GlobalCVP.allAddSection);
    // await Handler.getDeliveryStatusList();
    notify;
    getTrackList();
  }

  final int _orderPageSize = 12;
  int pageIndex = 1;
  int _orderTotalPage = 0;

  final orderList = <DeliTrackData>[];

  Future<void> getTrackList({
    int page = 1,
    bool autoUpdate = false,
  }) async {
    String? orderStatusId = "";

    if (deliTrackStatus?.deliveryTrackingStatus?.isNotEmpty ?? false) {
      orderStatusId =
          deliTrackStatus?.deliveryTrackingStatus?[deliveryStatusIndex].id;
    }

    final newOrderList = <DeliTrackData>[];
    List<DeliTrackData>? removedOrderList;

    if (page == 1 || pageIndex * _orderPageSize < _orderTotalPage) {
      if (!autoUpdate) pageIndex = page;

      final res = await Handler.getTrackList(
        trackingStatusId: orderStatusId,
        page: page,
        pageSize: autoUpdate && _orderPageSize < orderList.length
            ? (orderList.length + 1)
            : _orderPageSize,
      );

      if (page == 1 && !autoUpdate) {
        orderList.clear();
      }

      if (res?.data != null) {
        _orderTotalPage = res?.total ?? 0;

        if (autoUpdate) {
          final oldOrderList = <DeliTrackData>[];

          for (final a in res!.data!) {
            if (orderList
                .any((b) => b.id?.toLowerCase() == a.id?.toLowerCase())) {
              oldOrderList.add(a);
            } else {
              newOrderList.add(a);
            }
          }

          removedOrderList = orderList.any((b) => !oldOrderList
                  .any((c) => c.id?.toLowerCase() == b.id?.toLowerCase()))
              ? orderList
                  .where((b) => !oldOrderList
                      .any((c) => c.id?.toLowerCase() == b.id?.toLowerCase()))
                  .toList()
              : null;

          if (removedOrderList?.isNotEmpty ?? false) {
            for (final t in removedOrderList!) {
              final index = orderList.indexWhere(
                  (k) => k.id?.toLowerCase() == t.id?.toLowerCase());

              //remove items which status is changed
              await Future.delayed(Duration(milliseconds: 420), () {
                orderList.removeAt(index);
                notify;
              });
            }
          }

          orderList.clear();
          orderList.addAll(oldOrderList);
        } else {
          orderList.addAll(res!.data!);
        }
      }
    }

    pageLoad = false;
    notify;
  }

  TrackDetailRes? trackDetailRes;

  Future<bool> getTrackDetail({String? trackId}) async {
    if (trackId == null) return false;

    trackDetailRes = await Handler.getTrackDetail(id: trackId);

    return trackDetailRes != null;
  }
}

// class DeliveryStatus {
//   final String title;
//   final String value;

//   DeliveryStatus({required this.title, required this.value});

//   static List<DeliveryStatus> get getStatusList {
//     return [
//       DeliveryStatus(title: "Pending", value: "pending"),
//       DeliveryStatus(title: "Pickup", value: "pickup"),
//       DeliveryStatus(title: "Pickup Complete", value: "pickup_complete"),
//       DeliveryStatus(title: "Drop-Off", value: "dropoff"),
//       DeliveryStatus(title: "Delivered", value: "delivered"),
//       DeliveryStatus(title: "Canceled", value: "canceled"),
//       DeliveryStatus(title: "Returned", value: "returned"),
//       DeliveryStatus(title: "Ongoing", value: "ongoing"),
//     ];
//   }
// }
