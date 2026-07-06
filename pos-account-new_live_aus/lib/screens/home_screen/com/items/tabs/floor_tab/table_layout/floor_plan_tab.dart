import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/model/common/table_id_name.dart';
import 'package:pos_account/model/home/booking/table_status_update_req.dart';
import 'package:pos_account/model/home/setting/table_layout/layout_design_model.dart';
import 'package:pos_account/providers/booking/table_arrange_pro.dart';
import 'package:pos_account/providers/booking/table_resv_pro.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/menu/orders_pro.dart';
import 'package:pos_account/providers/menu/place_order_pro.dart';
import 'package:pos_account/repository/if_exception.dart';
import 'package:pos_account/screens/custom_drawer/com/logo_sec.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/table_layout/com/table_layout_view.dart';
import 'package:pos_account/screens/home_screen/com/pos_orders/com/pending_order/pending_order.dart';
import 'package:pos_account/widgets/dialog/confirm_dialog.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import 'package:pos_account/widgets/refresh_btn.dart';
import 'package:provider/provider.dart';
import '../../../../../../../ln.dart';
import '../booking_tab/booking_tab.dart';
import 'com/make_it_free_dia.dart';
import 'com/merge_confirm_dialog.dart';
import 'com/reserved_section.dart';
import 'com/switch_table_dia.dart';
import 'com/table_calender_view.dart';

class FloorPlanTab extends StatefulWidget {
  final List<TableIdName>? selectedTableLayId;
  final DialogFrom? isDialog;
  final Function()? onTapResevList;
  final GlobalKey<ScaffoldState>? scafKey;
  const FloorPlanTab({
    super.key,
    this.selectedTableLayId,
    this.isDialog,
    this.onTapResevList,
    this.scafKey,
  });

  @override
  State<FloorPlanTab> createState() => _FloorPlanTabState();
}

class _FloorPlanTabState extends State<FloorPlanTab> {
  @override
  void initState() {
    super.initState();
    _tableResv = Provider.of<TableResvPro>(context, listen: false);
    _taPro = Provider.of<TableArrangePro>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) => getData());
  }

  late TableArrangePro _taPro;

  // String? selectedTableLayId;

  late TableResvPro _tableResv;

  final _formKey = GlobalKey<FormState>();

  Future<void> getData() async {
    _tableResv.tableIdName = widget.selectedTableLayId;

    final _placeOrderPro = Provider.of<PlaceOrderPro>(context, listen: false);
    _defaultOrderType(_placeOrderPro);

    if (widget.isDialog == null || widget.isDialog == DialogFrom.BookingPage)
      _tableResv.getData();
    // selectedTableLayId = widget.selectedTableLayId;

    await _taPro.getAddSection();

    if (_taPro.addSecRes?.tableLocationsWithTables?.isNotEmpty ?? false) {
      if (_taPro.tableStatus != null) {
        await _taPro.getTableStatus(
            id: _taPro.addSecRes?.tableLocationsWithTables?.first.id ?? '',
            serverLoad: false,
            doPageLoad: false,
            doResize: true);
      }
      await _taPro.getTableStatus(
          id: _taPro.addSecRes?.tableLocationsWithTables?.first.id ?? '',
          serverLoad: true,
          doPageLoad: false,
          doResize: true);
    }
    if (_taPro.pageLoad) {
      _taPro.pageLoad = false;
      _taPro.notify;
    }

    _isDiaTableSelected = widget.isDialog == DialogFrom.PosPage &&
        (GlobalCVP.pathOfPOS == PathOfPOS.FloorPlan ||
            (GlobalCVP.pathOfPOS == PathOfPOS.Init &&
                (_placeOrderPro.reOrder?.tableIds?.isNotEmpty ?? false))) &&
        (_taPro.editPData?.any((a) =>
                (_tableResv.tableIdName?.any(
                        (b) => b.id?.toLowerCase() == a.id?.toLowerCase()) ??
                    false) &&
                (a.pElements.isNotEmpty &&
                    a.pElements.first.status == FloorTblStatus.Occupied)) ??
            false);

    // if (widget.isDialog == null || widget.isDialog == DialogFrom.BookingPage)
    //   _taPro.getCalenderData();
  }

  void _defaultOrderType(PlaceOrderPro placeOrderPro) {
    if (placeOrderPro.isDine) {
      if ((placeOrderPro.initAddSec?.orderTypes?.any((e) =>
              !(e.additionalValue?.toString().toLowerCase().contains('dine') ??
                  false)) ??
          false)) {
        placeOrderPro.orderTypeIndex = placeOrderPro.initAddSec!.orderTypes!
            .indexWhere((e) => !(e.additionalValue
                    ?.toString()
                    .toLowerCase()
                    .contains('dine') ??
                false));
      }
    }
  }

  @override
  void dispose() {
    // _taPro.pageLoad = true;
    _taPro.selectedForEdit = 0;
    // _taPro.editPData = null;
    // _taPro.layoutDesign = null;
    _tableResv.orderDetailsById = null;
    // placeOrderPData = null;
    super.dispose();
  }

  Widget _header(
      Ssize size, TableArrangePro taPro, PlaceOrderPro placeOrderPro) {
    return Row(
      children: [
        Expanded(
          child: taPro.addSecRes?.tableLocationsWithTables == null
              ? SizedBox.shrink()
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  child: Row(
                    children: List.generate(
                        taPro.addSecRes!.tableLocationsWithTables!.length,
                        (index) {
                      if (taPro.addSecRes!.tableLocationsWithTables![index]
                              .tables?.isNotEmpty ??
                          false) {
                        return tableTab(
                          size,
                          title: taPro.addSecRes!
                              .tableLocationsWithTables![index].value,
                          isSelected: taPro.selectedForEdit == index,
                          onTap: () {
                            _selectedTableId = null;
                            _tableResv.tableIdName = null;
                            _tableResv.orderDetailsById = null;
                            if (index >= 0) {
                              taPro.selectedForEdit = index;
                            }
                            taPro.editableLoading = true;
                            taPro.notify;
                            if (index >= 0) {
                              _taPro.getTableStatus(
                                id: taPro.addSecRes
                                        ?.tableLocationsWithTables?[index].id ??
                                    '',
                                doResize: true,
                                serverLoad: false,
                                doPageLoad: true,
                              );
                            }
                          },
                        );
                      } else
                        return SizedBox.shrink();
                    }),
                  ),
                ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.getW(12)),
          child: RefreshBtn(
            size: size,
            onTap: taPro.pageLoad
                ? null
                : () {
                    taPro.pageLoad = true;
                    _selectedTableId = null;
                    _tableResv.tableIdName = null;
                    _tableResv.orderDetailsById = null;
                    _defaultOrderType(placeOrderPro);
                    taPro.notify;

                    final _locations =
                        taPro.addSecRes?.tableLocationsWithTables ?? [];
                    final _index = taPro.selectedForEdit;

                    if (_index >= 0 && _index < _locations.length) {
                      taPro.getTableStatus(
                        id: _locations[_index].id ?? '',
                        doResize: true,
                      );
                      taPro.getCalenderData();
                    }
                  },
          ),
        ),
        // if (widget.onTapResevList != null)
        //   Flexible(
        //     child: ElevatedButton(
        //         style: ButtonStyle(
        //             backgroundColor: MaterialStateProperty.all(kSecondaryColor),
        //             padding: MaterialStateProperty.all(EdgeInsets.symmetric(
        //                 horizontal: size.getW(12), vertical: size.getH(8)))),
        //         onPressed: widget.onTapResevList,
        //         child: Row(
        //           mainAxisSize: MainAxisSize.min,
        //           children: [
        //             Text(
        //               LN.reservationList,
        //               style: TextStyle(
        //                 fontSize: size.getS(16),
        //                 color: Colors.white,
        //                 fontWeight: FontWeight.bold,
        //               ),
        //             ),
        //             SizedBox(
        //               width: size.getW(8),
        //             ),
        //             Icon(Icons.arrow_forward)
        //           ],
        //         )),
        //   )
      ],
    );
  }

  List<TableIdName>? _selectedTableId;

  bool _isDiaTableSelected = false;

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final taPro = Provider.of<TableArrangePro>(context);
    final tableResv = Provider.of<TableResvPro>(context);
    final placeOrderPro = Provider.of<PlaceOrderPro>(context);

    // taPro.layoutHeight = size.height -
    //     10 -
    //     size.getH(106.451087) -
    //     GlobalCVP.safeAreaPadding.top -
    //     GlobalCVP.safeAreaPadding.bottom;

    taPro.layoutHeight = size.height -
        10 -
        size.getH(24) -
        size.getH(83) -
        GlobalCVP.safeAreaPadding.top -
        GlobalCVP.safeAreaPadding.bottom;
    taPro.layoutWidth =
        (kFlexMiddleProt * size.width) / (kFlexLeft + kFlexMiddleProt) -
            size.getW(48) -
            4;

    final _isUpdateOrderFromPOS = widget.isDialog == DialogFrom.PosPage &&
        (_selectedTableId?.any((a) => a.orderId?.isNotEmpty ?? false) ?? false);
    // print("layout width: ${taPro.layoutWidth}");
    // print("layout height: ${taPro.layoutHeight} ");
    // kPrint(
    //     "${taPro.pageLoad} -- ${(taPro.addSecRes?.tableLocationsWithTables?.isNotEmpty ?? false)} && ${(taPro.editPData?.isNotEmpty ?? false)}");

    return Processing(
      loading: taPro.pageLoad || taPro.editableLoading,
      child: Container(
        constraints: widget.isDialog == null
            ? null
            : BoxConstraints(
                maxHeight: size.height / 1.12,
                minHeight: size.height / 5,
              ),
        width: widget.isDialog == null ? null : size.width / 1.17,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.isDialog == null)
              Row(
                children: [
                  Expanded(
                    flex: kFlexLeft,
                    child: LogoSection(
                      size: size,
                    ),
                  ),
                  Expanded(
                      flex: kFlexMiddleProt,
                      child: _header(size, taPro, placeOrderPro))
                ],
              ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.getW(8)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: widget.isDialog == null
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: size.getH(12)),
                    if (widget.isDialog != null)
                      Row(
                        children: [
                          Text(
                            LN.floorPlan,
                            style: TextStyle(
                              fontSize: size.getS(20),
                              // fontFamily: ,ph
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Spacer(),
                          IconButton(
                              visualDensity: VisualDensity.compact,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.close,
                                size: size.getS(24),
                                color: Colors.black,
                              )),
                        ],
                      ),
                    if (widget.isDialog != null) ...[
                      SizedBox(height: size.getH(12)),
                      _header(size, taPro, placeOrderPro)
                    ],
                    if (taPro.pageLoad
                        // || taPro.editableLoading
                        )
                      Container()
                    else if ((taPro.addSecRes?.tableLocationsWithTables
                                ?.isNotEmpty ??
                            false) &&
                        (taPro.editPData?.isNotEmpty ?? false))
                      Expanded(
                        child: SizedBox(
                          width:
                              widget.isDialog == null ? null : size.width / 1.5,
                          child: Row(
                            mainAxisAlignment: widget.isDialog == null
                                ? MainAxisAlignment.start
                                : MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 7,
                                child: SingleChildScrollView(
                                  child: FittedBox(
                                    fit: BoxFit
                                        .contain, // Makes sure the content fits without overflowing
                                    child: SizedBox(
                                      width: taPro.layoutWidth + 100,
                                      height: taPro.layoutHeight + 100,
                                      // width: tableWidth +
                                      //     100, // Content will be scaled to fit this size
                                      // height: tableHeight + 100,
                                      child: Stack(
                                        children: [
                                          DottedBorder(
                                            color: Colors.transparent,
                                            borderType: BorderType.RRect,
                                            strokeWidth: 3,
                                            dashPattern: [24, 12],
                                            radius: Radius.circular(15),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                          ...List.generate(
                                              taPro.editPData!.length, (index) {
                                            final pData =
                                                taPro.editPData![index];
                                            final selected = tableResv
                                                    .tableIdName
                                                    ?.any((a) =>
                                                        a.id?.toLowerCase() ==
                                                            pData.id
                                                                ?.toLowerCase() ||
                                                        (pData.pElements
                                                                .isNotEmpty &&
                                                            a.mergeId != null &&
                                                            a.mergeId ==
                                                                pData
                                                                    .pElements
                                                                    .first
                                                                    .mergeId)) ??
                                                false;

                                            return TableObject(
                                              isSelected: selected,
                                              prevSelected:
                                                  _isDiaTableSelected &&
                                                      selected,
                                              pData: pData,
                                              mergeIds: taPro.editPData
                                                      ?.expand(
                                                          (a) => a.pElements)
                                                      .map((b) => b.mergeId)
                                                      .toSet()
                                                      .toList() ??
                                                  [],
                                              minLeft: taPro.layoutDesign
                                                      ?.tableArea?.minWidth ??
                                                  0,
                                              onTap: _isDiaTableSelected
                                                  ? () {
                                                      if (widget.isDialog ==
                                                              DialogFrom
                                                                  .PosPage &&
                                                          GlobalCVP.pathOfPOS ==
                                                              PathOfPOS.Init &&
                                                          (placeOrderPro
                                                                  .reOrder
                                                                  ?.orderId
                                                                  ?.isNotEmpty ??
                                                              false)) {
                                                        IfException.showMessage(
                                                            message:
                                                                "Please clear the order from the cart, then try selecting the table again.");
                                                        return;
                                                      }
                                                    }
                                                  : () async {
                                                      if (selected) {
                                                        _selectedTableId = [];
                                                        // tableResv.tableId = null;
                                                        tableResv.tableIdName?.removeWhere((a) =>
                                                            a.id?.toLowerCase() ==
                                                                pData.id ||
                                                            (pData.pElements
                                                                    .isNotEmpty &&
                                                                a.mergeId !=
                                                                    null &&
                                                                a.mergeId ==
                                                                    pData
                                                                        .pElements
                                                                        .first
                                                                        .mergeId));

                                                        // tableResv.orderDetails =
                                                        //     null;

                                                        if (tableResv
                                                                    .tableIdName ==
                                                                null ||
                                                            tableResv
                                                                .tableIdName!
                                                                .isEmpty)
                                                          _defaultOrderType(
                                                              placeOrderPro);
                                                        // taPro.notify;
                                                        // await Future.delayed(
                                                        //     Duration(
                                                        //         milliseconds:
                                                        //             0)); //600
                                                        _selectedTableId = null;

                                                        if (widget.isDialog ==
                                                                null &&
                                                            pData.pElements
                                                                .isNotEmpty)
                                                          tableResv.removeOrderDetails(
                                                              orderId: pData
                                                                      .pElements
                                                                      .isNotEmpty
                                                                  ? pData
                                                                      .pElements
                                                                      .first
                                                                      .orderId
                                                                  : null);

                                                        taPro.notify;
                                                      } else {
                                                        if (widget.isDialog !=
                                                            null) {
                                                          final _isOccupy = pData
                                                                  .pElements
                                                                  .isNotEmpty &&
                                                              pData
                                                                      .pElements
                                                                      .first
                                                                      .status ==
                                                                  FloorTblStatus
                                                                      .Occupied;
                                                          final _hasOccupy = tableResv
                                                                  .tableIdName
                                                                  ?.any((a) =>
                                                                      a.floorTblStatus ==
                                                                      FloorTblStatus
                                                                          .Occupied) ??
                                                              false;
                                                          if (_isOccupy ||
                                                              _hasOccupy) {
                                                            if (widget.isDialog ==
                                                                    DialogFrom
                                                                        .PosPage &&
                                                                GlobalCVP
                                                                        .pathOfPOS ==
                                                                    PathOfPOS
                                                                        .Init &&
                                                                (placeOrderPro
                                                                        .reOrder
                                                                        ?.orderId
                                                                        ?.isNotEmpty ??
                                                                    false) &&
                                                                (placeOrderPro
                                                                            .reOrder
                                                                            ?.tableIds ==
                                                                        null ||
                                                                    placeOrderPro
                                                                        .reOrder!
                                                                        .tableIds!
                                                                        .isEmpty)) {
                                                              IfException
                                                                  .showMessage(
                                                                      message:
                                                                          "Table is already occupied");
                                                              return;
                                                            }

                                                            tableResv
                                                                .tableIdName = [];
                                                            _selectedTableId =
                                                                [];
                                                          }
                                                          // IfException.showMessage(
                                                          //     message:
                                                          //         "Table is already occupied");
                                                          // return;
                                                        }

                                                        //TODO: remove it's function once socket is applied
                                                        // taPro.getTableStatus(
                                                        //   id: taPro
                                                        //           .addSecRes
                                                        //           ?.tableLocationsWithTables?[
                                                        //               taPro
                                                        //                   .selectedForEdit]
                                                        //           .id ??
                                                        //       '',
                                                        //   doResize: true,
                                                        //   serverLoad: false,
                                                        //   doPageLoad: false,
                                                        // );
                                                        // _selectedTableId = [];
                                                        tableResv
                                                            .tableIdName ??= [];

                                                        final _newtableId =
                                                            TableIdName(
                                                          id: pData.id,
                                                          name: pData.title,
                                                          floorTblStatus: pData
                                                                  .pElements
                                                                  .isNotEmpty
                                                              ? pData.pElements
                                                                  .first.status
                                                              : FloorTblStatus
                                                                  .Available,
                                                          mergeId: pData
                                                                      .pElements
                                                                      .isNotEmpty &&
                                                                  (pData
                                                                          .pElements
                                                                          .first
                                                                          .mergeId
                                                                          ?.isNotEmpty ??
                                                                      false)
                                                              ? pData.pElements
                                                                  .first.mergeId
                                                              : null,
                                                        );

                                                        tableResv.tableIdName
                                                            ?.add(_newtableId);

                                                        // if (tableResv.tableIdName
                                                        //         ?.any((a) =>
                                                        //             a.floorTblStatus !=
                                                        //             FloorTblStatus
                                                        //                 .Available) ??
                                                        //     false) {
                                                        //   tableResv.tableIdName = [];
                                                        //   tableResv.tableIdName
                                                        //       ?.add(_newtableId);
                                                        // }

                                                        // tableResv.tableId = pData.id;

                                                        if (
                                                            // widget.isDialog ==
                                                            //       null &&
                                                            pData.pElements
                                                                .isNotEmpty)
                                                          tableResv.getOrderDetails(
                                                              id: pData
                                                                      .pElements
                                                                      .first
                                                                      .orderId ??
                                                                  '');
                                                        if (!placeOrderPro
                                                                .isDine &&
                                                            (placeOrderPro
                                                                    .initAddSec
                                                                    ?.orderTypes
                                                                    ?.any((e) =>
                                                                        e.additionalValue ==
                                                                            3 ||
                                                                        e.additionalValue
                                                                            .toString()
                                                                            .toLowerCase()
                                                                            .contains('dine')) ??
                                                                false)) {
                                                          placeOrderPro.orderTypeIndex = placeOrderPro
                                                              .initAddSec!
                                                              .orderTypes!
                                                              .indexWhere((e) =>
                                                                  e.additionalValue ==
                                                                      3 ||
                                                                  e.additionalValue
                                                                      .toString()
                                                                      .toLowerCase()
                                                                      .contains(
                                                                          'dine'));
                                                        }

                                                        taPro.notify;
                                                        await Future.delayed(
                                                            Duration(
                                                                milliseconds:
                                                                    0));

                                                        // _selectedTableId ??= [];

                                                        // final _selectedTab = taPro
                                                        //         .editPData
                                                        //         ?.where((a) => (tableResv
                                                        //                 .tableIdName
                                                        //                 ?.any((c) =>
                                                        //                     a.pElements
                                                        //                         .isNotEmpty &&
                                                        //                     c.mergeId ==
                                                        //                         a.pElements.first
                                                        //                             .mergeId) ??
                                                        //             false))
                                                        //         .toList() ??
                                                        //     [];

                                                        // _selectedTableId =
                                                        //     _selectedTab
                                                        //         .map((f) => f.id)
                                                        //         .toList();

                                                        taPro.notify;
                                                      }

                                                      final _selectedTab =
                                                          taPro.editPData
                                                                  ?.where((a) {
                                                                final _status =
                                                                    (tableResv
                                                                            .tableIdName
                                                                            ?.any((c) {
                                                                          // kPrint(
                                                                          //     "${c.name} ${c.mergeId} ${a.pElements.length} ${a.pElements.isNotEmpty ? a.pElements.first.mergeId : '--'}");
                                                                          final _s1 =
                                                                              (c.id?.toLowerCase() == a.id?.toLowerCase()) || (a.pElements.isNotEmpty && c.mergeId != null && c.mergeId == a.pElements.first.mergeId);
                                                                          return _s1;
                                                                        }) ??
                                                                        false);

                                                                // kPrint(
                                                                //     "${a.title} $_status");

                                                                return _status;
                                                              }).toList() ??
                                                              [];

                                                      // for (final a
                                                      //     in taPro.editPData!) {
                                                      //   kPrint("${a.title}::");
                                                      //   for (final b
                                                      //       in a.pElements) {
                                                      //     kPrint(
                                                      //         "${a.title} ${b.mergeId}");
                                                      //   }
                                                      // }
                                                      // kPrint(
                                                      //     "${_selectedTab.length} ${_selectedTab.map((a) => a.title).toList()}");

                                                      _selectedTableId =
                                                          _selectedTab
                                                              .map((f) =>
                                                                  TableIdName(
                                                                    id: f.id,
                                                                    name:
                                                                        f.title,
                                                                    floorTblStatus: f
                                                                            .pElements
                                                                            .isNotEmpty
                                                                        ? f
                                                                            .pElements
                                                                            .first
                                                                            .status
                                                                        : FloorTblStatus
                                                                            .Available,
                                                                    orderId: f
                                                                            .pElements
                                                                            .isNotEmpty
                                                                        ? f
                                                                            .pElements
                                                                            .first
                                                                            .orderId
                                                                        : null,
                                                                    mergeId: f
                                                                            .pElements
                                                                            .isNotEmpty
                                                                        ? f
                                                                            .pElements
                                                                            .first
                                                                            .mergeId
                                                                        : null,
                                                                  ))
                                                              .toList();
                                                      // kPrint(
                                                      //     "_selectedTableId: ${_selectedTableId?.length}");

                                                      if ((tableResv.tableIdName
                                                                      ?.isNotEmpty ??
                                                                  false) &&
                                                              widget.isDialog !=
                                                                  null
                                                          //     &&
                                                          // pData.pElements.first
                                                          //         .status !=
                                                          //     FloorTblStatus
                                                          //         .Occupied
                                                          ) {
                                                        popUpAction(
                                                          popCtx: context,
                                                          action: PopUpAction
                                                              .PlaceOrder,
                                                          pData: pData,
                                                          pElements: pData
                                                              .pElements.first,
                                                          size: size,
                                                        );
                                                      }
                                                      if (widget.isDialog ==
                                                          null) {
                                                        placeOrderPro.clear();
                                                      }
                                                    },
                                              // itemBuilder: (ctx) => [
                                              //   CusPopupMenuItem(
                                              //     padding: EdgeInsets.symmetric(
                                              //         horizontal: size.getW(4)),
                                              //     child: ReservedSection(
                                              //       pData: pData,
                                              //       isDialog: widget.isDialog,
                                              //       onTapAction: (ac, pElements) =>
                                              //           popUpAction(
                                              //         popCtx: ctx,
                                              //         action: ac,
                                              //         pData: pData,
                                              //         pElements: pElements,
                                              //         size: size,
                                              //       ),
                                              //     ),
                                              //   ),
                                              // ],
                                            );
                                          }),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // if (taPro.editPData?.any((e) =>
                              //         e.id?.toLowerCase() ==
                              //         tableResv.tableId?.toLowerCase()) ??
                              //     false)
                              if (widget.isDialog == null)
                                Flexible(
                                  flex: 3,
                                  child: Form(
                                    key: _formKey,
                                    child: Card(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: size.getW(8)),
                                      child: AnimatedSwitcher(
                                          duration: Duration(milliseconds: 0),
                                          transitionBuilder:
                                              (child, animation) {
                                            // Define the slide transition
                                            return FadeTransition(
                                              opacity: animation,
                                              child: SlideTransition(
                                                position: Tween<Offset>(
                                                  begin: Offset(0.0,
                                                      0.1), // Start from the right
                                                  end: Offset
                                                      .zero, // End at the original position
                                                ).animate(animation),
                                                child: child,
                                              ),
                                            );
                                          },
                                          child:
                                              // _selectedTableId != null &&
                                              //         _selectedTableId!.isEmpty
                                              //     ? Container()
                                              //     :
                                              Padding(
                                            key: ValueKey(_selectedTableId),
                                            padding:
                                                EdgeInsets.all(size.getS(12)),
                                            child: ReservedSection(
                                              pData: (taPro.editPData?.any((e) =>
                                                          _selectedTableId?.any((g) =>
                                                              g.id?.toLowerCase() ==
                                                              e.id
                                                                  ?.toLowerCase()) ??
                                                          false) ??
                                                      false)
                                                  ? taPro.editPData!
                                                      .where((e) =>
                                                          _selectedTableId?.any((g) =>
                                                              g.id?.toLowerCase() ==
                                                              e.id?.toLowerCase()) ??
                                                          false)
                                                      .toList()
                                                  : null,
                                              isDialog: widget.isDialog,
                                              onTapAction: (ac, pElements) =>
                                                  popUpAction(
                                                popCtx: context,
                                                action: ac,
                                                pData: (taPro.editPData?.any((e) =>
                                                            _selectedTableId?.any((g) =>
                                                                g.id?.toLowerCase() ==
                                                                e.id
                                                                    ?.toLowerCase()) ??
                                                            false) ??
                                                        false)
                                                    ? taPro.editPData!.firstWhere((e) =>
                                                        _selectedTableId?.any((g) =>
                                                            g.id?.toLowerCase() ==
                                                            e.id?.toLowerCase()) ??
                                                        false)
                                                    : null,
                                                pElements: pElements,
                                                size: size,
                                              ),
                                              placeOrderPro: placeOrderPro,
                                              taPro: taPro,
                                              // showReservation: _taPro
                                              //         .tableReservationCalender
                                              //         ?.data
                                              //         ?.any((t) =>
                                              //             t.tableId
                                              //                 ?.toLowerCase() ==
                                              //             _selectedTableId
                                              //                 ?.toLowerCase()) ??
                                              //     false,
                                            ),
                                          )
                                          // : (_selectedTableId != null &&
                                          //         _selectedTableId!.isEmpty)
                                          //     ? Container()
                                          //     : TableSelectionGuide(),
                                          ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      )
                    else
                      Expanded(
                          child: Align(
                              alignment: Alignment.topCenter,
                              child: NoItemsSec(
                                  size: size, title: LN.noFloorSetup))),
                    if (widget.isDialog != null &&
                        (taPro.editPData?.isNotEmpty ?? false))
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            size.getH(24), 0, size.getH(24), size.getH(24)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // LoadButton(
                            //   btnColor: Colors.red,
                            //   btnText: LN.clear,
                            //   hPad: 12,
                            //   vPad: 8,
                            //   onsave: () {
                            //     // textCltr.clear();
                            //   },
                            // ),
                            SizedBox(
                              width: size.getW(8),
                            ),

                            LoadButton(
                              btnText: _isUpdateOrderFromPOS
                                  ? "Update Order"
                                  : "Confirm",
                              hPad: 12,
                              vPad: 8,
                              loading: taPro.editableLoading,
                              onsave: () async {
                                if (_isUpdateOrderFromPOS) {
                                  taPro.editableLoading = true;
                                  taPro.notify;
                                  await PendingOrder.updateOrder(context,
                                      orderId: _selectedTableId
                                              ?.firstWhere((a) =>
                                                  a.orderId?.isNotEmpty ??
                                                  false)
                                              .orderId ??
                                          "",
                                      updateOrderType: false);
                                  taPro.editableLoading = false;
                                  taPro.notify;
                                }
                                Navigator.pop(context, true);
                              },
                            ),
                          ],
                        ),
                      )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget tableTab(
    Ssize size, {
    String? title,
    bool isSelected = false,
    Function()? onTap,
  }) {
    return Card(
      margin: EdgeInsets.only(right: size.getW(16)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      color: isSelected ? kPrimaryColor : Colors.grey.shade300,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: size.getH(8.0), horizontal: size.getW(24)),
          child: Text(
            title ?? '',
            style: TextStyle(
              fontSize: size.getS(18),
              fontFamily: kFontFMedium,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  // bool _isFromMainScreen = false;

  // PData? placeOrderPData;

  Future<void> popUpAction({
    required BuildContext popCtx,
    required PopUpAction action,
    PData? pData,
    PDataElements? pElements,
    required Ssize size,
  }) async {
    // if (action == PopUpAction.Reserve && widget.isDialog != null) {
    //   Navigator.of(context)
    //     ..pop()
    //     ..pop(pData);
    //   return;
    // } else if (widget.isDialog != null) {
    //   return;
    // }

    // Navigator.pop(popCtx);

    if (!mounted) return;

    final tableResv = Provider.of<TableResvPro>(context, listen: false);

    // tableResv.tableIdName ??= [];

    // if (!(tableResv.tableIdName
    //         ?.any((a) => a.id?.toLowerCase() == pData?.id?.toLowerCase()) ??
    //     false)) {
    //   tableResv.tableIdName
    //       ?.add(TableIdName(id: pData?.id, name: pData?.title));
    // }
    // tableResv.tableId = pData?.id;

    final _placeOrderPro = Provider.of<PlaceOrderPro>(context, listen: false);

    if (action == PopUpAction.Reserve) {
      // if (!_isFromMainScreen) {
      //   tableResv.clear();
      //   await tableResv.getData();
      //   tableResv.loadiing = false;
      //   // selectedTableLayId = pData?.id;
      // }
      // tableResv.tableId = pData?.id;
      tableResv.adultCltr.text = pData?.adult?.toString() ?? '';
      tableResv.childCltr.text = pData?.child?.toString() ?? '';
      tableResv.initDateSetup(isQuick: true, placeOrderPro: _placeOrderPro);

      BookingTab.showBookingDia(
        context,
        size: size,
        isFromMainScreen: true,
        scafKey: widget.scafKey,
        isQuick: true,
      ).then((value) {
        // if (value != null && value is bool)
        //   _isFromMainScreen = value;
        // else
        //   _isFromMainScreen = false;

        _taPro.getTableStatus(
          id: _taPro.addSecRes!
                  .tableLocationsWithTables![_taPro.selectedForEdit].id ??
              '',
          serverLoad: true,
          doPageLoad: false,
          doResize: true,
        );
        _taPro.getCalenderData();
      });
    } else if (action == PopUpAction.PlaceOrder) {
      if (widget.isDialog == null &&
          !(_formKey.currentState?.validate() ?? false)) return;

      // when table needs to be changed then user will update it from dialog, so order won't be refresh. But user can't update table from table screen
      // if (widget.isDialog == null){}
      if (_placeOrderPro.reOrder?.tableIds?.isNotEmpty ?? false)
        _placeOrderPro.reOrder = null;
      // _placeOrderPro.clear();
      // _placeOrderPro.tableId = pData?.id;
      // for (final a in _selectedTableId! // tableResv.tableIdName!
      //     ) {
      //   kPrint("${a.name} ${a.mergeId}");
      // }

      // kPrint('isPlaceOrderMerge: $_isNewTableWithMerge');

      // return;

      List<TableIdName>? _optimizedTables;

      if (widget.isDialog == null && _selectedTableId != null) {
        final _newTableCount = _selectedTableId?.fold<double>(
                0,
                (e, a) =>
                    e + ((a.mergeId == null || a.mergeId!.isEmpty) ? 1 : 0)) ??
            0;
        final _isNewTableWithMerge = _newTableCount > 1 ||
            ((_selectedTableId
                        ?.any((a) => a.mergeId == null || a.mergeId!.isEmpty) ??
                    false) &&
                (_selectedTableId?.any((a) => a.mergeId?.isNotEmpty ?? false) ??
                    false));

        if (_isNewTableWithMerge) {
          final _newTableIdModel = _selectedTableId!
              .map((a) => TableIdName.fromJson(a.toJson())
                ..floorTblStatus = a.floorTblStatus
                ..orderId = a.orderId
                ..mergeId = a.mergeId
                ..imageUrl = a.imageUrl
                ..selected = a.selected)
              .toList();
          final _newTableData = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return MergeConfirmDialog(tableList: _newTableIdModel);
              });

          if (_newTableData != null && _newTableData is List<TableIdName>) {
            _optimizedTables = _newTableData;
          } else {
            return;
          }
        }
      }

      _placeOrderPro.tableIdName = _optimizedTables ?? _selectedTableId;
      // placeOrderPData = pData;
      tableResv.orderDetailsById = null;

      if (widget.isDialog == null) {
        Future.delayed(Duration(milliseconds: 300), () {
          GlobalCVP.setMainPage = MainPage.HomePage;
          GlobalCVP.setCurrentPage(
              GlobalCVP.tabs.indexWhere((element) => element.title == LN.pos));
          GlobalCVP.pathOfPOS = PathOfPOS.FloorPlan;
          GlobalCVP.notify;
        });
      } else {
        tableResv.notify;
      }
    } else if (action == PopUpAction.Occupy) {
      showDialog(
          context: context,
          builder: (builder) => ConfirmDialog(
                title: LN.tableOccupation,
                subTitle: LN.wannaOccupyTable,
                actionText: LN.yes,
                cancelText: LN.no,
                onDelete: () async {
                  tableResv.tableRsvNo = "";
                  // final _data = tableResv.initDateSetup(
                  //     isQuick: true, placeOrderPro: _placeOrderPro);
                  // _data.id = "";
                  final _data = _selectedTableId
                      ?.map((a) => TableStatusUpdateReq(
                            tableid: a.id,
                            status: FloorTblStatus.Occupied.name,
                          ))
                      .toList();
                  _taPro.editableLoading = true;
                  _taPro.occupyBtnLoad = true;
                  _taPro.notify;

                  final _status = await _taPro.updateTableStatus(data: _data);
                  if (_status) {
                    // tableResv.getData();
                    tableResv.orderDetailsById = null;
                  }

                  _taPro.editableLoading = false;
                  _taPro.occupyBtnLoad = false;
                  _taPro.notify;
                  return null;
                },
                onCancel: () {
                  Navigator.pop(context);
                },
              ));
    } else if (action == PopUpAction.ViewOrder) {
      final orderPro = Provider.of<OrderPro>(context, listen: false);
      orderPro.viewOrder(context, orderId: pElements?.orderId ?? "");
    } else if (action == PopUpAction.Pay) {
      if (widget.scafKey != null)
        await PendingOrder.payNow(
          context,
          orderId: pElements?.orderId ?? "",
          scaffKey: widget.scafKey!,
          orderPath: PathOfOrder.FLOORPATH,
        );
      await Future.delayed(Duration(seconds: 1));
      tableResv.tableIdName = null;
      _selectedTableId = null;
      _defaultOrderType(_placeOrderPro);
      tableResv.orderDetailsById = null;
      _taPro.notify;
    } else if (action == PopUpAction.UpdateOrder) {
      PendingOrder.updateOrder(context,
          orderId: pElements?.orderId ?? "", updateOrderType: false);
    } else if (action == PopUpAction.MakeItFree) {
      final _occupyTables = <TableStatusUpdateReq>[];

      if (_selectedTableId != null)
        for (final a in _selectedTableId!) {
          // kPrint("_occupyTables: ${a.name} ${a.floorTblStatus}");
          if (a.floorTblStatus == FloorTblStatus.Occupied)
            _occupyTables.add(TableStatusUpdateReq(
                tableid: a.id, name: a.name, orderId: a.orderId));
        }

      if (_occupyTables.length > 1)
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return MakeItFreeDia(
                model: _occupyTables,
                onDone: (_data) async {
                  _taPro.editableLoading = true;
                  _taPro.makeItFreeBtnLoad = true;
                  _taPro.notify;
                  final _status = await _taPro.updateTableStatus(data: _data);

                  if (_status) {
                    tableResv.tableIdName = null;
                    _selectedTableId = null;
                    _defaultOrderType(_placeOrderPro);
                    tableResv.orderDetailsById = null;
                  }

                  _taPro.editableLoading = false;
                  _taPro.makeItFreeBtnLoad = false;
                  _taPro.notify;
                },
              );
            });
      else
        showDialog(
            context: context,
            builder: (builder) => ConfirmDialog(
                  title: LN.makeTableFree,
                  subTitle: LN.wannaTableFree,
                  actionText: LN.yes,
                  cancelText: LN.no,
                  onDelete: () async {
                    // final _data = tableResv.initDateSetup(isQuick: true);
                    // _data.id = pElements?.reservId;
                    final _data = _selectedTableId
                        ?.map((a) => TableStatusUpdateReq(
                              tableid: a.id,
                              status: FloorTblStatus.Available.name,
                            ))
                        .toList();
                    _taPro.editableLoading = true;
                    _taPro.makeItFreeBtnLoad = true;
                    _taPro.notify;
                    final _status = await _taPro.updateTableStatus(data: _data);

                    if (_status) {
                      tableResv.tableIdName = null;
                      _selectedTableId = null;
                      _defaultOrderType(_placeOrderPro);
                      tableResv.orderDetailsById = null;
                    }

                    _taPro.editableLoading = false;
                    _taPro.makeItFreeBtnLoad = false;
                    _taPro.notify;
                    return null;
                  },
                ));
    } else if (action == PopUpAction.ViewCalender) {
      final events = <Event>[];
      if (_taPro.tableReservationCalender?.data == null) return;

      _taPro.tableReservationCalender!.data!.forEach((f) {
        if (pData?.id?.toLowerCase() == f.tableId?.toLowerCase()) {
          events.add(Event(
            title: f.customerName,
            adult: f.adult,
            child: f.child,
            startDate: f.dateTimeFrom,
            endDate: f.dateTimeTo,
          ));
        }
      });

      showDialog(
          context: context,
          builder: (ctx) => SimpleDialog(
                backgroundColor: kBackgroundColor,
                titlePadding: EdgeInsets.zero,
                contentPadding: EdgeInsets.symmetric(horizontal: size.getW(0)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                children: [
                  TableCalenderView(
                    tableName: pData?.title,
                    events: events,
                  )
                ],
              ));
    } else if (action == PopUpAction.SwitchTable) {
      final _val = await showDialog(
          context: context,
          barrierDismissible: true,
          builder: (builder) => SimpleDialog(
                // backgroundColor: kPrimaryColor,
                titlePadding: EdgeInsets.zero,
                contentPadding: EdgeInsets.symmetric(
                    horizontal: size.getW(12), vertical: size.getH(4)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                children: [
                  SwitchTableDia(
                    key: UniqueKey(),
                    selectedTableLayId: pData?.id,
                    orderId: pElements?.orderId,
                  )
                ],
              ));
      if (_val != null && _val is String) {
        // _taPro.editableLoading = true;
        // _taPro.notify;
        if (!(tableResv.tableIdName
                ?.any((a) => a.id?.toLowerCase() == _val.toLowerCase()) ??
            false)) {
          tableResv.tableIdName
              ?.add(TableIdName(id: _val, name: "", mergeId: ""));
        }

        if (!(_selectedTableId
                ?.any((a) => a.id?.toLowerCase() == _val.toLowerCase()) ??
            false)) {
          _selectedTableId?.add(TableIdName(id: _val, name: "", mergeId: ""));
        }
        // tableResv.tableId = _val;
        _taPro.getTableStatus(
          id: _taPro.addSecRes
                  ?.tableLocationsWithTables?[_taPro.selectedForEdit].id ??
              '',
          doResize: true,
          serverLoad: true,
          doPageLoad: false,
        );
        tableResv.getOrderDetails(id: pElements?.orderId ?? '');
        await Future.delayed(Duration(milliseconds: 0)); //300

        tableResv.tableIdName = [];
        _selectedTableId = [];

        if (!(tableResv.tableIdName?.any((f) => f.id == _val) ?? false))
          tableResv.tableIdName?.add(TableIdName(id: _val));

        if (!(_selectedTableId?.any((f) => f.id == _val) ?? false))
          _selectedTableId?.add(TableIdName(id: _val));

        tableResv.orderDetailsById = null;

        // _selectedTableId = _val;
        _taPro.notify;

        _taPro.getCalenderData();
      }
    } else if (action == PopUpAction.MergeTable) {
      showDialog(
          context: context,
          builder: (builder) => ConfirmDialog(
                title: "Merge Table",
                subTitle: "Click 'yes' to merge table",
                actionText: LN.yes,
                cancelText: LN.no,
                onDelete: () async {
                  // final _data = tableResv.initDateSetup(isQuick: true);
                  // _data.id = pElements?.reservId;
                  final _data = _selectedTableId
                      ?.map((a) => TableStatusUpdateReq(
                            tableid: a.id,
                            orderId: a.orderId ?? '',
                          ))
                      .toList();
                  // log(json.encode(_data?.map((a) => a.toJson()).toList()));
                  _taPro.editableLoading = true;
                  _taPro.mergeTableBtnLoad = true;
                  _taPro.notify;
                  final _status =
                      await _taPro.mergeTable(data: _data, init: false);

                  if (_status) {
                    tableResv.tableIdName = null;
                    _selectedTableId = null;
                    _defaultOrderType(_placeOrderPro);
                    tableResv.orderDetailsById = null;
                  }

                  _taPro.editableLoading = false;
                  _taPro.mergeTableBtnLoad = false;
                  _taPro.notify;
                  return null;
                },
              ));
    }
  }
}
