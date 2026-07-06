import 'package:flutter/material.dart';
import 'package:pos_account/model/home/menu/place_order/order_tab/comp_dis_res.dart';
import 'package:pos_account/model/home/menu/place_order/order_tab/order_tab_req.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/repository/handler.dart';

import '../../../config/utils/utils.dart';
import '../../../model/common/table_location.dart';

class OrderTabPro extends ChangeNotifier {
  void get notify => notifyListeners();

  final tableIdCltr = TextEditingController();
  final tabLimitCltr = TextEditingController();

  List<OrderTabReq>? openTabs;
  bool actionTapped = false;
  List<OrderTabReq>? closedTabs;
  List<OrderTabReq>? selectedTabs;
  String? orderStatusId;
  String? openStatusId;
  bool isClosedTab = false;
  List<TableLocation>? orderStatusList;
  bool loading = true;

  Future<void> init() async {
    final res = OrderTabSection.fromJson(GlobalCVP.allAddSection);
    // await Handler.getAllOrderTabSection();
    orderStatusList = res.orderStatus;

    if (orderStatusList?.isNotEmpty ?? false) {
      orderStatusId = orderStatusList?.first.id;
      await getOrderTabs();
    }
  }

  void onSelectTabCheckBox(OrderTabReq ticket, bool? value) {
    if (value == true) {
      selectedTabs = [];
      selectedTabs?.add(ticket);
    } else {
      selectedTabs?.removeWhere((element) => element.id == ticket.id);
    }
    notify;
  }

  Future<void> getOrderTabs({
    bool isClosed = false,
  }) async {
    if (orderStatusId == null || orderStatusId!.isEmpty) {
      return;
    }
    Utils.handleSearch(
        dispose: () {},
        callback: () async {
          if (!isClosed)
            openTabs = await Handler.getAllOrderTabs(
                orderStatusId: orderStatusId ?? "");
          else
            closedTabs = await Handler.getAllOrderTabs(
                orderStatusId: orderStatusId ?? "");
          loading = false;
          notify;
        });
  }

  Future<void> addTab({
    String noOfCus = "",
    Function()? action,
  }) async {
    final _req = OrderTabReq(
      id: editId,
      tabIdentification: tableIdCltr.text,
      noOfCustomer: noOfCus,
      tabLimit: tabLimitCltr.text,
    );

    final _status = await Handler.createUpdateOrderTab(req: _req);

    if (_status ?? false) {
      if (action != null) action();
      clear();
      getOrderTabs();
    }
    loading = false;
    notify;
  }

  String editId = "";

  Future<String?> editTab(String id) async {
    loading = true;
    notify;

    final _editData = await Handler.editOrderTab(id: id);

    if (_editData != null) {
      editId = _editData.id ?? '';
      tableIdCltr.text = _editData.tabIdentification ?? '';
      tabLimitCltr.text = _editData.tabLimit ?? '';
    }
    loading = false;
    return _editData?.noOfCustomer;
  }

  CompDisRes? compDisRes;

  Future<void> getAddSec() async {
    compDisRes = await Handler.getCompAddSec();
  }

  // String? selectedCompId;
  String? selectedPercent;
  List<String> compList = [
    "Employee Discount",
    "Customer Discount",
    "Manager Discount",
    "Staff Discount",
  ];
  final percentList = ["5", "10", "20", "25", "50", "75", "100"];

  // void onSelectComp({String? comp, bool? value}) {
  //   if (value == true) {
  //     selectedComp = comp;
  //   } else {
  //     selectedComp = null;
  //   }
  //   notify;
  // }

  void onSelectPercent({String? percent}) {
    if (percent == selectedPercent) {
      selectedPercent = null;
    } else {
      selectedPercent = percent;
    }
    notify;
  }

  void clear() {
    tableIdCltr.clear();
    tabLimitCltr.clear();
    editId = "";
  }

  void cDispose() {
    openTabs = null;
    closedTabs = null;
    loading = true;
    actionTapped = false;
    orderStatusList = null;
    orderStatusId = null;
    isClosedTab = false;
    // selectedCompId = null;
    selectedPercent = null;
    selectedTabs = null;
  }

  Future<bool?> cancelorder({
    required String orderId,
  }) async {
    loading = true;
    notify;

    final _status = await Handler.cancelOrderTab(orderId: orderId);

    if (_status ?? false) {
    } else {
      loading = false;
      notify;
    }
    return _status;
  }
}
