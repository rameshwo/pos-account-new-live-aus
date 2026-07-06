import 'package:flutter/material.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/common/res_datum.dart';
import 'package:pos_account/model/home/setting/general/category/restro_table_model.dart';
import 'package:pos_account/model/home/setting/general/order_type/get_all_orders.dart';
import 'package:pos_account/model/home/setting/general/order_type/order_type_add_req.dart';
import 'package:pos_account/model/home/setting/general/order_type/order_type_add_sec.dart';
import 'package:pos_account/model/ui_model/tablelist_model.dart';
import 'package:pos_account/repository/handler.dart';

class OrderTypePro extends ChangeNotifier {
  static List<String> get _headerList => [
        LN.channel,
        LN.sortNo,
        LN.orderType,
        // LN.posOrderType,
        // LN.onlineOrderType,
        LN.isActive,
        // 'Is Default',
        LN.action,
      ];
  //order type
  GetAllOrderTypeRes? _getAllData;
  final _tableList = RTableData(
    headerList: _headerList,
  );

  var tableData = <TLModel>[];

  void init() {
    _tableList.headerList = _headerList;
    tableData = <TLModel>[
      TLModel(
        title: LN.sort,
        isReq: true,
        tableCltr: TextEditingController(),
        textInputType: TextInputType.number,
      ),
      TLModel(
        title: LN.displayName,
        isReq: true,
        tableCltr: TextEditingController(),
      ),
      // TLModel(
      //   title: LN.channelType,
      //   isReq: false,
      //   tableCltr: TextEditingController(),
      //   suffixIcon: PopupMenuButton(
      //       offset: Offset(0, -60),
      //       itemBuilder: (context) {
      //         return [
      //           PopupMenuItem(
      //               child: Text(
      //             "Please enter the valid channel. '1' for POS '2' for Online.",
      //             style: TextStyle(
      //               color: Colors.black87,
      //               fontFamily: kFontFMedium,
      //             ),
      //           ))
      //         ];
      //       },
      //       child: Icon(
      //         Icons.info,
      //         color: kPrimaryColor,
      //         size: 24,
      //       )),
      // ),
    ];
  }

  bool loading = true;

  // bool isPosOrderType = false;
  // bool isOnlineOrderType = false;

  OrderTypeAddSecRes? _orderTypeAddSecRes;
  OrderTypeAddReq? editOrderData;

  int _page = 1;

  int get getPage => _page;

  set setPage(int val) {
    _page = val;
  }

  void clear() {
    itemId = "";
    status = true;
    enableCusPopUp = true;
    enableTableSelection = false;
    _channelIndex = null;
    channelTypeIndex = null;
    _otIndex = null;
    // _isDefault = true;
    for (var e in tableData) {
      e.tableCltr.clear();
    }
    // isPosOrderType = false;
    // isOnlineOrderType = false;
    searchCltr.clear();
  }

  String itemId = "";

  Future<void> getOrderTypeAddSec() async {
    _orderTypeAddSecRes = await Handler.getOrderTypeAddSec();
  }

  final searchCltr = TextEditingController();

  Future<void> getData({int page = 1}) async {
    setPage = page;
    _getAllData = await Handler.getAllOrderTypes(
        page: page, searchKey: searchCltr.text.toLowerCase());
    if (_getAllData?.data != null) {
      _tableList.tableDataList = [];
      for (var e in _getAllData!.data!) {
        _tableList.tableDataList.add(TableDataList(
          id: e.id!,
          itemList: [
            e.channelName ?? '',
            e.sortOrder?.toString() ?? '',
            e.orderType ?? ''
          ],
          statusList: [
            // (e.isPosOrderType ?? false) ? TableStatus.Yes : TableStatus.No,
            // (e.isOnlineOrderType ?? false) ? TableStatus.Yes : TableStatus.No,
            (e.isActive != null && e.isActive!)
                ? TableStatus.Active
                : TableStatus.Inactive,
            // (e.isDefault != null && e.isDefault!)
            //     ? TableStatus.Active
            //     : TableStatus.Inactive
          ],
        ));
      }
    }
    loading = false;
    notifyListeners();
  }

  OrderTypeAddSecRes? get getAddSec => _orderTypeAddSecRes;

  GetAllOrderTypeRes? get getAllOrderTypes => _getAllData;

  RTableData get getTableList => _tableList;

  Future<void> addUpData({required List<OrderTypeAddReq> tableList}) async {
    loading = true;
    notifyListeners();
    final isAddSuccess =
        await Handler.addUpOrderTypes(orderTypeList: tableList);
    loading = false;
    notifyListeners();
    if (isAddSuccess != null && _getAllData!.total != null) {
      if (_getAllData!.total! - (getPage * 10) < 10) {
        await getData(page: getPage);
      }
    }
  }

  Future<void> deleteData({required List<SRDatum> dataList}) async {
    final status = await Handler.deleteOrderType(dataList: dataList);
    if (status != null && status) {
      for (var e in dataList) {
        getTableList.tableDataList.removeWhere((f) => e.id == f.id);
      }
      notifyListeners();
    }
  }

  Future<void> editData({required String id}) async {
    editOrderData = await Handler.editOrderTypes(reqStoredId: id);
  }

  int _countSelected = 0;

  int get getSelectedCount => _countSelected;

  set setCount(int val) {
    _countSelected = val;
    notifyListeners();
  }

  bool status = true;
  bool enableCusPopUp = true;
  bool enableTableSelection = false;

  int? _channelIndex;

  int? get getChannelIndex => _channelIndex;

  set setChannelIndex(int? val) {
    _channelIndex = val;
    notifyListeners();
  }

  int? channelTypeIndex;

  int? _otIndex;

  int? get getOTIndex => _otIndex;

  set setOTIndex(int? val) {
    _otIndex = val;
    notifyListeners();
  }

  // bool _isDefault = true;

  // bool get getDefault => _isDefault;

  // set setDefault(bool val) {
  //   _isDefault = val;
  //   notifyListeners();
  // }

  void notify() {
    notifyListeners();
  }
}
