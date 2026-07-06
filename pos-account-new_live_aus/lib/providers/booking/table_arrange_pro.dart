import 'package:flutter/material.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/model/home/booking/table_status_update_req.dart';
import 'package:pos_account/model/home/setting/general/table_lay/table_lay.dart';
import 'package:pos_account/model/home/setting/general/table_lay/table_loc_status.dart';
import 'package:pos_account/model/home/setting/general/table_number/all_table_asl.dart';
import 'package:pos_account/model/home/setting/table_layout/all_table_add_res.dart';
import 'package:pos_account/model/home/setting/table_layout/all_table_lay_res.dart';
import 'package:pos_account/model/home/setting/table_layout/layout_design_model.dart';
import 'package:pos_account/model/home/setting/table_layout/tr_calender.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/repository/handler.dart';
import 'package:pos_account/services/database/shared_pref.dart';

class TableArrangePro extends ChangeNotifier {
  final double dWidgetHight = 364.0;

  ArrSize _arrSize = ArrSize();

  set setArrSize(ArrSize val) => _arrSize = val;

  ArrSize get tableArea => _arrSize;

  //drag and drop part

  bool doAnimate = false;
  String? tappedId;
  // final scrollCltr = ScrollController();

  void get notify => notifyListeners();

  List<PData>? initTableData;

  refresh() {
    doAnimate = true;
    for (final e in pDList) {
      final offset = getOffset(pData: e);
      if (offset != null) {
        e.left = offset.dx;
        e.top = offset.dy - dWidgetHight; // + scrollCltr.offset;
      }
    }
    notify;

    Future.delayed(Duration(milliseconds: 400), () {
      doAnimate = false;
      pDList.clear();
      notify;
    });
  }

  Future initObject(PData pData) async {
    doAnimate = true;
    final item = initTableData!
            .any((e) => e.id?.toLowerCase() == pData.id?.toLowerCase())
        ? initTableData!
            .firstWhere((e) => e.id?.toLowerCase() == pData.id?.toLowerCase())
        : null;
    final offset = getOffset(pData: pData);
    if (offset != null && item != null) {
      item.left = offset.dx;
      item.top = offset.dy - dWidgetHight; // + scrollCltr.offset;
      notify;
    }
    await Future.delayed(Duration(milliseconds: 400), () {
      doAnimate = false;
      pDList.removeWhere((e) => e.id == pData.id);
      notify;
    });
  }

  final pDList = <PData>[];

  Offset? getOffset({required PData pData}) {
    final rBox = pData.key?.currentContext?.findRenderObject();
    if (rBox == null) return null;
    RenderBox box = rBox as RenderBox;
    return box.localToGlobal(Offset.zero);
  }

  //**    api data data     **//

  AllTableLayAddSecRes? addSecRes;
  int? tableLocationIndex;

  AllTableLayRes? allTableLayRes;

  TableLayReq? editTableData;
  int selectedForEdit = 0;

  bool pageLoad = true;

  Future<void> getAddSection() async {
    setTableLocations();
    addSecRes ??= AllTableLayAddSecRes(tableLocationsWithTables: []);
    if (tableLocations != null) {
      for (final a in tableLocations!) {
        if (!addSecRes!.tableLocationsWithTables!
            .any((b) => b.id?.toLowerCase() == a.id?.toLowerCase()))
          addSecRes!.tableLocationsWithTables!.add(TableLocationsWithTable(
            id: a.id,
            value: a.name,
          ));
      }
    }
    // addSecRes ??= await Handler.getAllTableLayAddSec();
    notifyListeners();
  }

  void setTableLocationData() {
    if ((addSecRes?.tableLocationsWithTables?.isNotEmpty ?? false) &&
        // (addSecRes!.tableLocationsWithTables!.first.tables == null ||
        //     addSecRes!.tableLocationsWithTables!.first.tables!.isEmpty) &&
        tableStatus != null) {
      for (final a in addSecRes!.tableLocationsWithTables!) {
        final _tableList = tableStatus!
            .where(
                (b) => b.tableLocationId?.toLowerCase() == a.id?.toLowerCase())
            .toList();

        a.tables = _tableList
            .map((c) => TableImageList(
                  id: c.tableId,
                  name: c.tableName,
                  image: c.image,
                ))
            .toList();
      }
    }
  }

  TableReservationCalender? tableReservationCalender;

  Future<void> getCalenderData() async {
    // tableReservationCalender = await Handler.getTableReservCalender();
    // notifyListeners();
  }

  Future<void> getData() async {
    allTableLayRes = await Handler.getAllTableLayout();
    pageLoad = false;
    notifyListeners();
  }

  onCheckedTable() {
    if (addSecRes == null ||
        addSecRes!.tableLocationsWithTables == null ||
        tableLocationIndex == null ||
        addSecRes!.tableLocationsWithTables![tableLocationIndex!].tables ==
            null) return;

    initTableData = <PData>[];
    for (final e
        in addSecRes!.tableLocationsWithTables![tableLocationIndex!].tables!) {
      // if (
      //     e.isSelect &&
      //     !pDList.any((f) => f.id?.toLowerCase() == e.id?.toLowerCase()))
      initTableData!.add(PData(
        key: GlobalKey(),
        id: e.id,
        title: e.name,
        image: e.image,
      ));
    }
  }

  bool updateLoad = false;

  Future<void> addUpTableLay() async {
    // if (pDList.isEmpty) return;
    final data = TableLayReq();
    if (editTableData != null) {
      data.id = editTableData!.id;
      data.tableLocationId = editTableData?.tableLocationId;
    }
    // if (addSecRes != null &&
    //     addSecRes!.tableLocationsWithTables != null &&
    //     tableLocationIndex != null) {
    //   data.tableLocationId =
    //       addSecRes!.tableLocationsWithTables![tableLocationIndex!].id;
    // }
    data.tableSettings = layoutDesignModelToJson(LayoutDesignModel(
        tableSize: TableSize(
          height: tableArea.height,
          width: tableArea.width,
        ),
        tableArea: TableArea(
          minWidth: tableArea.minWidth,
          minHeight: tableArea.minHeight,
          maxWidth: tableArea.maxWidth,
          maxHeight: tableArea.maxHeight,
        ),
        pDataList: pDList));
    updateLoad = true;
    notify;

    await Handler.addUpTableLay(tableLayReq: data);

    updateLoad = false;
    notify;
  }

  bool editableLoading = false;
  List<PData>? editPData;
  LayoutDesignModel? layoutDesign;

  Future<void> editTableLay({required String layoutId}) async {
    editableLoading = true;
    editPData = null;
    notify;

    editTableData = await Handler.editTableLayout(id: layoutId);
    setData();

    editableLoading = false;
    notify;
  }

  Future<void> getTableLay({
    required String tableId,
    bool doResize = false,
  }) async {
    editableLoading = true;
    editPData = null;
    notify;

    editTableData = await Handler.getTableLayout(tableId: tableId);
    setTablesAddSec();
    setData(doResize: doResize);

    editableLoading = false;
    notify;
  }

  void setTablesAddSec() {
    if (editTableData != null &&
        (addSecRes?.tableLocationsWithTables?.any((a) =>
                a.id?.toLowerCase() ==
                editTableData?.tableLocationId?.toLowerCase()) ??
            false)) {
      final _tabLocation = addSecRes!.tableLocationsWithTables!.firstWhere(
          (a) =>
              a.id?.toLowerCase() ==
              editTableData?.tableLocationId?.toLowerCase());

      _tabLocation.tables = editTableData?.tables
          ?.map((c) => TableImageList(
                id: c.id,
                name: c.name,
                image: c.imageUrl,
              ))
          .toList();
    }
  }

  void setData({bool doResize = false}) {
    // editPData = null;
    if (editTableData != null && editTableData!.tableSettings != null) {
      layoutDesign = layoutDesignModelFromJson(editTableData!.tableSettings!);
      // log(json.encode(layoutDesign?.toJson()));

      final _wRatio = layoutWidth / (layoutDesign?.tableSize?.width ?? 1);
      final _hRatio = layoutHeight / (layoutDesign?.tableSize?.height ?? 1);
      final _aRatio = _wRatio * _hRatio;

      // print("$_wRatio $_hRatio $_aRatio");

      if (layoutDesign?.pDataList != null)
        for (final e in layoutDesign!.pDataList!) {
          e.key = GlobalKey();
          if (doResize) {
            e.left = _wRatio * e.left;
            e.top = _hRatio * e.top;
            e.size = _aRatio * e.size;
          }
        }
      if (doResize) {
        layoutDesign?.tableSize?.height = layoutHeight;
        layoutDesign?.tableSize?.width = layoutWidth;

        layoutDesign?.tableArea?.minWidth =
            (layoutDesign?.tableArea?.minWidth ?? 0) * _wRatio;
        layoutDesign?.tableArea?.maxWidth =
            (layoutDesign?.tableArea?.maxWidth ?? 0) * _wRatio;

        layoutDesign?.tableArea?.minHeight =
            (layoutDesign?.tableArea?.minHeight ?? 0) * _hRatio;
        layoutDesign?.tableArea?.maxHeight =
            (layoutDesign?.tableArea?.maxHeight ?? 0) * _hRatio;
      }
      editPData = layoutDesign?.pDataList;

      // log(json.encode(editPData?.map((a) => a.toJson()).toList()));
    }
    // log(jsonEncode(layoutDesign?.toJson()));
    if (selectedForEdit == 0)
      selectedForEdit = addSecRes?.tableLocationsWithTables
              ?.indexWhere((a) => a.tables?.isNotEmpty ?? false) ??
          0;

    if (editPData != null &&
        editTableData?.tableLocationId != null &&
        (addSecRes?.tableLocationsWithTables?.isNotEmpty ?? false)) {
      for (final e in editPData!) {
        if (addSecRes!.tableLocationsWithTables!.any((f) =>
            f.id?.toLowerCase() ==
            editTableData!.tableLocationId?.toLowerCase())) {
          final tableImgData = addSecRes!.tableLocationsWithTables!
                  .firstWhere((f) =>
                      f.id?.toLowerCase() ==
                      editTableData!.tableLocationId?.toLowerCase())
                  .tables ??
              [];
          if (tableImgData
              .any((g) => g.id?.toLowerCase() == e.id?.toLowerCase())) {
            final tableData = tableImgData
                .firstWhere((g) => g.id?.toLowerCase() == e.id?.toLowerCase());
            // e.key = GlobalKey();
            e.title = tableData.name;
            e.image = tableData.image;
            e.adult = tableData.adultCapacity;
            e.child = tableData.childCapacity;
            // log(json.encode(e.toJson()));
          }
        }
      }
    }
  }

  List<TableLocationStatusModel>? tableLocations;

  void setTableLocations() {
    if (GlobalCVP.allAddSection['tableLocations'] != null)
      tableLocations = List<TableLocationStatusModel>.from(GlobalCVP
          .allAddSection['tableLocations']
          .map((x) => TableLocationStatusModel.fromJson(x)));
  }

  double layoutHeight = 1;
  double layoutWidth = 1;

  List<TableReservationStatus>? tableStatus;

  Future<void> getTableStatus({
    required String id,
    bool serverLoad = true,
    bool doPageLoad = false,
    bool doResize = true,
  }) async {
    if (id.isEmpty) return;

    if (doPageLoad) {
      editPData = null;
      pageLoad = true;
      notify;
    }

    if (serverLoad) {
      tableStatus = await Handler.getTableStatus();
      setTableLocationData();
    } else {
      tableStatus ??= await Handler.getTableStatus();
    }

    // kPrint(tableStatus?.map((a) => "${a.status} ${a.mergedId}").toList());

    final _tableLoc =
        (tableLocations?.any((a) => a.id?.toLowerCase() == id.toLowerCase()) ??
                false)
            ? tableLocations
                ?.firstWhere((a) => a.id?.toLowerCase() == id.toLowerCase())
            : null;

    if (_tableLoc != null)
      editTableData = TableLayReq(
        tableLocationId: _tableLoc.id,
        // tableStatus?.tableLocationId,
        tableSettings: _tableLoc.layout,
        // tableStatus?.tablelayoutSettings,
      );
    setData(doResize: doResize);

    if (tableStatus == null || editPData == null) {
      editableLoading = false;
      pageLoad = false;
      notify;
      return;
    }

    // set Status

    final curSym = await SharedPrefs.curSym;

    final Map<String, int> mergeCountMap = {};

    for (final item in editPData!) {
      if (tableStatus?.any(
              (c) => c.tableId?.toLowerCase() == item.id?.toLowerCase()) ??
          false) {
        final tableData = tableStatus
            ?.where((c) => c.tableId?.toLowerCase() == item.id?.toLowerCase())
            .toList();
        for (final pE in tableData!) {
          final id = pE.mergedId;
          if (id != null) mergeCountMap[id] = (mergeCountMap[id] ?? 0) + 1;
        }
      }
    }

    for (final a in editPData!) {
      a.pElements = [];

      if (tableStatus
              ?.any((c) => c.tableId?.toLowerCase() == a.id?.toLowerCase()) ??
          false) {
        final tableData = tableStatus
            ?.where((c) => c.tableId?.toLowerCase() == a.id?.toLowerCase())
            .toList();

        a.pElements = tableData!.map((e) {
          final pStatus = getUITableStatus(
            status: e.status,
            orderId: e.orderId,
            // reservTime: e.reservedTime,
            // reservType: e.reserveType,
          );

          return PDataElements(
              // reservedType: e.reserveType,
              cusName: e.customerName,
              // reservedTime: e.reservedTime,
              amount: "$curSym${e.amount?.roundToNString() ?? ''}",
              orderId: e.orderId,
              mergeId: mergeCountMap[e.mergedId] != null &&
                      mergeCountMap[e.mergedId]! > 1
                  ? e.mergedId
                  : null,
              orderNo: e.orderNumber,
              // adult: e.adult,
              // reservId: e.tableReservationsId,
              status: pStatus,
              statusColor: _getTableColor(pStatus));
        }).toList();

        if (a.pElements.isNotEmpty &&
            (a.pElements.first.status != FloorTblStatus.Occupied ||
                (a.pElements.first.status == FloorTblStatus.Occupied &&
                    (a.pElements.first.orderId == null ||
                        a.pElements.first.orderId!.isEmpty)))) {
          a.pElements = [a.pElements.first];
        }

        // a.reservedType = _tableData.reserveType;
        // a.cusName = _tableData.customerName;
        // a.reservedTime = _tableData.reservedTime;
        // a.amount = "$_curSym${_tableData.amount?.roundToNString() ?? ''}";
        // a.orderId = _tableData.orderId;
        // a.adult = _tableData.adult;
        // a.reservId = _tableData.tableReservationsId;

        // a.status = getUITableStatus(
        //   status: _tableData.status,
        //   orderId: _tableData.orderId,
        //   reservTime: _tableData.reservedTime,
        //   reservType: _tableData.reserveType,
        // );
        // a.statusColor = _getTableColor(a.status);
      }
    }

    editableLoading = false;
    pageLoad = false;
    notify;
  }

  bool makeItFreeBtnLoad = false;
  bool occupyBtnLoad = false;

  Future<bool> updateTableStatus({
    List<TableStatusUpdateReq>? data,
    // bool showToast = true,
  }) async {
    if (data == null) return false;

    // editableLoading = true;
    // notify;

    final _status = await Handler.updateTableStatus(data: data);

    // editableLoading = false;
    // notify;
    if (_status ?? false) {
      //TODO:REMOVE when firebase update
      // getTableStatus(
      //     id: addSecRes!.tableLocationsWithTables![selectedForEdit].id ?? '',
      //     serverLoad: true,
      //     doPageLoad: false,
      //     doResize: true);
      return true;
    }
    return false;
  }

  bool mergeTableBtnLoad = false;

  Future<bool> mergeTable({
    List<TableStatusUpdateReq>? data,
    bool init = true,
  }) async {
    if (data == null) return false;

    final _status = await Handler.mergeTable(req: data);

    if (_status ?? false) {
      //TODO:REMOVE when firebase update
      // getTableStatus(
      //     id: addSecRes!.tableLocationsWithTables![selectedForEdit].id ?? '',
      //     serverLoad: true,
      //     doPageLoad: false,
      //     doResize: true);
      return true;
    }
    return false;
  }

  FloorTblStatus getUITableStatus({
    String? status,
    String? orderId,
    int? reservTime,
    String? reservType,
  }) {
    final status0 = status?.toLowerCase();
    if ((status0 == 'pending' || status0 == 'confirmed') &&
        (reservTime != null && reservTime > 0) &&
        (orderId == null || orderId.isEmpty)) {
      return FloorTblStatus.Reserved;
    } else if (status0 == 'occupied' ||
        (status0 == 'pending' && (orderId?.isNotEmpty ?? false))) {
      return FloorTblStatus.Occupied;
    } else
      return FloorTblStatus.Available;
  }

  Color _getTableColor(FloorTblStatus status) {
    if (status == FloorTblStatus.Reserved)
      return Colors.amber.shade800;
    else if (status == FloorTblStatus.Occupied)
      return Colors.red.shade600;
    else
      return Colors.green;
  }

  Future<List<PData>?> getTableStatus2({
    required String id,
  }) async {
    if (id.isEmpty) return null;
    // final _tableStatus2 = await Handler.getTableStatus();

    final _tableLoc =
        (tableLocations?.any((a) => a.id?.toLowerCase() == id.toLowerCase()) ??
                false)
            ? tableLocations
                ?.firstWhere((a) => a.id?.toLowerCase() == id.toLowerCase())
            : null;

    final _editTableData2 = _tableLoc != null
        ? TableLayReq(
            tableLocationId: _tableLoc.id,
            // _tableStatus2?.tableLocationId,
            tableSettings: _tableLoc.layout,
            // _tableStatus2?.tablelayoutSettings,
          )
        : null;

    // setData
    if (_editTableData2?.tableSettings != null) {
      final _layoutDesign2 =
          layoutDesignModelFromJson(_editTableData2!.tableSettings!);
      final _wRatio = layoutWidth / (_layoutDesign2.tableSize?.width ?? 1);
      final _hRatio = layoutHeight / (_layoutDesign2.tableSize?.height ?? 1);
      final _aRatio = _wRatio * _hRatio;

      if (_layoutDesign2.pDataList != null)
        for (final e in _layoutDesign2.pDataList!) {
          e.key = GlobalKey();

          e.left = _wRatio * e.left;
          e.top = _hRatio * e.top;
          e.size = _aRatio * e.size;
        }

      _layoutDesign2.tableSize?.height = layoutHeight;
      _layoutDesign2.tableSize?.width = layoutWidth;

      _layoutDesign2.tableArea?.minWidth =
          (_layoutDesign2.tableArea?.minWidth ?? 0) * _wRatio;
      _layoutDesign2.tableArea?.maxWidth =
          (_layoutDesign2.tableArea?.maxWidth ?? 0) * _wRatio;

      _layoutDesign2.tableArea?.minHeight =
          (_layoutDesign2.tableArea?.minHeight ?? 0) * _hRatio;
      _layoutDesign2.tableArea?.maxHeight =
          (_layoutDesign2.tableArea?.maxHeight ?? 0) * _hRatio;

      final _editPData2 = _layoutDesign2.pDataList;

      if (_editPData2 != null &&
          _editTableData2.tableLocationId != null &&
          (addSecRes?.tableLocationsWithTables?.isNotEmpty ?? false)) {
        for (final e in _editPData2) {
          if (addSecRes!.tableLocationsWithTables!.any((f) =>
              f.id?.toLowerCase() ==
              _editTableData2.tableLocationId?.toLowerCase())) {
            final _tableImgData = addSecRes!.tableLocationsWithTables!
                .firstWhere((f) =>
                    f.id?.toLowerCase() ==
                    _editTableData2.tableLocationId?.toLowerCase())
                .tables!;

            if (_tableImgData
                .any((g) => g.id?.toLowerCase() == e.id?.toLowerCase())) {
              final _tableData = _tableImgData.firstWhere(
                  (g) => g.id?.toLowerCase() == e.id?.toLowerCase());
              e.title = _tableData.name;
              e.image = _tableData.image;
              e.adult = _tableData.adultCapacity;
              e.child = _tableData.childCapacity;
            }
          }
        }
      }
      if (tableStatus == null || _editPData2 == null) return null;

      final _curSym = await SharedPrefs.curSym;

      for (final a in _editPData2) {
        a.pElements = [];

        if (tableStatus
                ?.any((c) => c.tableId?.toLowerCase() == a.id?.toLowerCase()) ??
            false) {
          final _tableData2 = tableStatus
              ?.where((c) => c.tableId?.toLowerCase() == a.id?.toLowerCase())
              .toList();

          a.pElements = _tableData2!.map((e) {
            final _pStatus = getUITableStatus(
              status: e.status,
              orderId: e.orderId,
              // reservTime: e.reservedTime,
              // reservType: e.reserveType,
            );
            return PDataElements(
                // reservedType: e.reserveType,
                cusName: e.customerName,
                // reservedTime: e.reservedTime,
                amount: "$_curSym${e.amount?.roundToNString() ?? ''}",
                orderId: e.orderId,
                orderNo: e.orderNumber,
                mergeId: e.mergedId,
                // adult: e.adult,
                // reservId: e.tableReservationsId,
                status: _pStatus,
                statusColor: _getTableColor(_pStatus));
          }).toList();

          if (a.pElements.isNotEmpty &&
              (a.pElements.first.status != FloorTblStatus.Occupied ||
                  (a.pElements.first.status == FloorTblStatus.Occupied &&
                      (a.pElements.first.orderId == null ||
                          a.pElements.first.orderId!.isEmpty)))) {
            a.pElements = [a.pElements.first];
          }
        }
      }
      return _editPData2;
    }
    return null;
  }

  bool switchButtonLoad = false;

  Future<bool> switchTable({
    String? orderId,
    String? tableId,
    dynamic Function(bool)? onPopMsg,
  }) async {
    switchButtonLoad = true;
    notify;

    final _status = await Handler.switchTable(
      tableId: tableId,
      orderId: orderId,
      onPopMsg: onPopMsg,
    );

    switchButtonLoad = false;
    notify;

    return _status ?? false;
  }

  void clearAll() {
    addSecRes = null;
    tableLocations = null;
    tableStatus = null;
  }
}

class ArrSize {
  final double minWidth;
  final double minHeight;
  final double maxWidth;
  final double maxHeight;
  final double height;
  final double width;

  ArrSize({
    this.minWidth = 0.0,
    this.minHeight = 0.0,
    this.maxWidth = 0.0,
    this.maxHeight = 0.0,
    this.height = 0.0,
    this.width = 0.0,
  });
}
