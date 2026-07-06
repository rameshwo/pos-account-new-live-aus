import 'package:flutter/material.dart';
import 'package:pos_account/model/home/setting/general/order_status_res.dart';
import 'package:pos_account/repository/handler.dart';

class OrderStatusPro extends ChangeNotifier {
  void get notify => notifyListeners();

  bool pageLoad = true;
  bool buttonLoad = false;

  void clear() {
    pageLoad = true;
    buttonLoad = false;
  }

  List<AllOrderStatusRes>? allOrderStatusList;

  Future<void> getData() async {
    allOrderStatusList = await Handler.getAllOrderStatus(page: 1);

    pageLoad = false;
    notify;
  }

  Future<void> updateData() async {
    if (allOrderStatusList == null) return;

    pageLoad = true;
    buttonLoad = true;
    notify;

    await Handler.updateOrderStatus(data: allOrderStatusList!);

    pageLoad = false;
    buttonLoad = false;
    notify;
  }
}
