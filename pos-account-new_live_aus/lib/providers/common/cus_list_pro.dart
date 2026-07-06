import 'package:flutter/material.dart';
import 'package:pos_account/model/home/booking/all_customer.dart';
import 'package:pos_account/repository/handler.dart';

class CusListPro extends ChangeNotifier {
  void get notify => notifyListeners();

  CusListPro() {
    getCustomers(page: 1);
  }

  void clear() {
    searchCusCltr.clear();
    selectedCusId = null;
  }

  bool loadingCus = true;
  int cusPageIndex = 1;
  final int cusPageSize = 10;
  int cusTotalPage = 0;
  final searchCusCltr = TextEditingController();
  final cusDataList = <CusData>[];
  String? selectedCusId;

  Future<void> getCustomers({String key = "", required int page}) async {
    cusPageIndex = page;
    loadingCus = true;
    notify;

    final allCustomer = await Handler.getAllCus(
      keyword: key,
      page: page,
      pageSize: cusPageSize,
    );

    if (allCustomer != null && allCustomer.data != null) {
      cusDataList.clear();
      for (final e in allCustomer.data!) {
        cusDataList.add(e);
      }
      cusTotalPage = allCustomer.total ?? 0;
    }

    loadingCus = false;
    notify;
  }
}
