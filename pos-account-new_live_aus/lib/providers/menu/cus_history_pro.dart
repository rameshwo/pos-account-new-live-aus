import 'package:flutter/material.dart';
import 'package:pos_account/model/home/menu/customer/customer_order_history.dart';
import 'package:pos_account/repository/handler.dart';
import 'package:pos_account/services/database/shared_pref.dart';

class CusHistoryPro extends ChangeNotifier {
  void get notify => notifyListeners();

  final cusNameCltr = TextEditingController();

  bool pageLoad = false;

  CustomerHistory? customerHistory;

  final customerOrderList = <CustomerOrderData>[];

  String? selectedOrderId;

  String? curSym;

  int orderPageIndex = 1;
  final int orderPageSize = 10;
  int orderTotalPage = 0;

  Future<void> getCusSym() async {
    curSym = await SharedPrefs.curSym;
  }

  Future<void> getOrderData({
    String? cusId,
    int page = 1,
  }) async {
    if (cusId == null || cusId.isEmpty) return;

    pageLoad = true;
    orderPageIndex = page;
    notify;

    customerHistory = await Handler.getCusOrders(
        cusId: cusId, page: page, pageSize: orderPageSize);
    if (customerHistory?.customerOrders?.data != null) {
      customerOrderList.clear();
      customerOrderList.addAll(customerHistory!.customerOrders!.data!);
      orderTotalPage = customerHistory?.customerOrders?.total ?? 0;
    }

    pageLoad = false;
    notify;
  }

  bool viewOrderLoading = false;
  bool copyOrderLoading = false;

  bool isOrderCopied = false;

  clear() {
    cusNameCltr.clear();
    customerHistory = null;
    customerOrderList.clear();
    selectedOrderId = null;
    viewOrderLoading = false;
    copyOrderLoading = false;
    isOrderCopied = false;
  }
}
