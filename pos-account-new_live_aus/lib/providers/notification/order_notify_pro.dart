import 'package:flutter/material.dart';
import 'package:pos_account/model/notification/new_order_notifi.dart';
import 'package:pos_account/repository/handler.dart';
import 'package:pos_account/services/database/database/db_local_data.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class OrderNotifyPro extends ChangeNotifier {
  // List<NewOrderNotifi>? _serverOrders;
  NewOrderDbModel? databaseOrders;

  Future<void> getData() async {
    databaseOrders = await DbLocalData.getOrdersNotify();
    notify;
    await _serverData();
  }

  Future<void> _serverData() async {
    //TODO: switch server if main server down
    // await Handler.checkServer();
    final serverOrders = await Handler.getAllNewOrdNoti();

    final order = NewOrderDbModel(
      newOrders: serverOrders,
    );

    databaseOrders = order;
    notify;
    DbLocalData.updateOrderNotify(order: order);
  }

  // Future<void> _storeInLocalDB() async {
  //   final _order = NewOrderDbModel(
  //     newOrders: _getAllOrders,
  //   );
  //   await DbLocalData.updateOrderNotify(order: _order);
  //   databaseOrders = await DbLocalData.getOrdersNotify();
  //   notify;
  // }

  Future<bool?> updateSeenStatus({String? id}) async {
    if (id == null) return null;
    // if (databaseOrders == null || databaseOrders!.newOrders == null) return;

    // databaseOrders!.newOrders!.firstWhere((e) => e.id == id).isSeen = true;

    // await DbLocalData.updateOrderNotify(order: databaseOrders!);
    // notify;

    // await Handler.updateOrdNotifi(id: id).then((value) {
    //   print("value:::$value");
    //   if (value == true) getData();
    // });

    final stauts = await Handler.updateOrdNotifi(id: id);
    if (stauts ?? false) {
      _serverData();
    }

    return stauts;
  }

  List<String> get countOrderId {
    return _getAllOrders
        .where((e) => e.isSeen == null || !e.isSeen!)
        .toList()
        .map((f) => f.id ?? '')
        .toList();
  }

  List<NewOrderNotifi> get _getAllOrders {
    final tempOrder = <NewOrderNotifi>[];
    if (databaseOrders?.newOrders != null) {
      tempOrder.addAll(databaseOrders!.newOrders!);
    }
    return tempOrder;
  }

  // List<NewOrderNotifi> get _getAllOrders {
  //   final _tempOrder = <NewOrderNotifi>[];

  //   if (_serverOrders != null) {
  //     _tempOrder.addAll(_serverOrders!);
  //   }
  //   if (databaseOrders != null && databaseOrders!.newOrders != null) {
  //     for (final e in databaseOrders!.newOrders!) {
  //       if (_tempOrder.any((f) => f.id?.toLowerCase() == e.id?.toLowerCase())) {
  //         _tempOrder
  //             .firstWhere((g) => g.id?.toLowerCase() == e.id?.toLowerCase())
  //             .isSeen = e.isSeen;
  //       } else {
  //         _tempOrder.add(e);
  //       }
  //     }
  //   }

  //   final _idList = _tempOrder.map((e) => e.id ?? '').toSet().toList();
  //   final _newOrder = <NewOrderNotifi>[];
  //   for (final e in _idList) {
  //     if (_tempOrder.any((f) => f.id?.toLowerCase() == e.toLowerCase()))
  //       _newOrder.add(_tempOrder
  //           .firstWhere((f) => f.id?.toLowerCase() == e.toLowerCase()));
  //   }
  //   return _newOrder;
  // }

  void get notify => notifyListeners();

  ///testing :TODO:

  // int? length;

  // Future<void> testFunction() async {
  //   Utils.testFunction(
  //       function: Handler.getAllNewOrdNoti(),
  //       setUp: (_res) {
  //         length = _res?.length;
  //         notify;
  //       });
  // }

  final notificationList = <NewOrderNotifi>[];
  int pageIndex = 1;
  final int _pageSize = 10;
  int _totalPage = 0;

  RefreshController? refreshCltr;
  bool pageLoad = true;

  void initNotificationScreen() {
    refreshCltr = RefreshController(initialRefresh: false);
    Future.delayed(Duration(milliseconds: 400), () {
      notify;
    });
  }

  Future<void> getAllNotification({int page = 1}) async {
    if (page == 1 || pageIndex * _pageSize < _totalPage) {
      pageIndex = page;

      final getAllNotification = await Handler.getAllNotification(
        page: page,
        pageSize: _pageSize,
      );

      if (page == 1) {
        notificationList.clear();
      }

      if (getAllNotification?.data != null) {
        _totalPage = getAllNotification?.total ?? 0;
        notificationList.addAll(getAllNotification!.data!);
      }
    }

    refreshCltr?.loadComplete();
    refreshCltr?.refreshCompleted();

    pageLoad = false;
    notify;
  }

  bool loadMarkAll = false;

  Future<bool?> markAllAsSeen() async {
    loadMarkAll = true;
    notify;

    final status = await Handler.markAllNotifySeen();
    if (status ?? false) {
      getAllNotification(page: 1);
      _serverData();
    }

    loadMarkAll = false;
    notify;

    return status;
  }

  void clear() {
    pageLoad = true;
    pageIndex = 1;
    _totalPage = 0;
    notificationList.clear();
    if (refreshCltr != null) refreshCltr!.dispose();
  }
}
