import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/common/res_datum.dart';
import 'package:pos_account/model/home/setting/general/category/restro_table_model.dart';
import 'paginated_table_data.dart';
import 'restro_data_source.dart';

enum MoreFun {
  Edit,
  View,
  Generate,
  Connect,
  None,
  Assign,
  Commission,
  StockHistory
}

class TableData extends StatefulWidget {
  final RTableData tableData;
  final List<String> Function(int)? popUpMenuItems;
  final Function(List<SRDatum>)? deleteItem;
  final Function(SRDatum, MoreFun)? onAction;
  final Function(int)? selectItem;
  final Function(int)? paginate;
  final int? total;
  final int page;
  final int pageSize;
  final int sortColumnIndex;
  final bool showDeleteBtn;

  const TableData({
    super.key,
    required this.tableData,
    this.deleteItem,
    this.selectItem,
    this.paginate,
    this.total,
    required this.page,
    this.pageSize = 10,
    this.onAction,
    this.popUpMenuItems,
    this.sortColumnIndex = 1,
    this.showDeleteBtn = true,
  });

  @override
  State<TableData> createState() => _TableDataState();
}

class _TableDataState extends State<TableData> {
  bool sortAscending = true;
  late int sortColumnIndex;

  load() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    setData(widget.sortColumnIndex);
    super.initState();
  }

  setData(int index) {
    sortColumnIndex = index;
    load();
  }

  void onSort(int columnIndex, bool ascending) {
    int tempIndex = 0;
    if (widget.tableData.tableDataList.first.imgList != null) {
      tempIndex = widget.tableData.tableDataList.first.imgList!.length;
    }

    if (widget.tableData.tableDataList.first.itemList.first is Widget) return;

    if (widget.tableData.tableDataList.first.itemList.length > columnIndex ||
        (tempIndex != 0 &&
            (widget.tableData.tableDataList.first.itemList.length + tempIndex) >
                columnIndex)) {
      setData(columnIndex);
    }
    if (sortColumnIndex < tempIndex) return;
    sortAscending = !sortAscending;
    int index = sortColumnIndex - tempIndex;
    widget.tableData.tableDataList.sort((a, b) {
      // Guard: index must exist in both lists
      if (index >= a.itemList.length || index >= b.itemList.length) {
        return 0; // keep original order
      }

      final aValue = a.itemList[index];
      final bValue = b.itemList[index];

      final aNum = double.tryParse(aValue);
      final bNum = double.tryParse(bValue);

      if (aNum != null && bNum != null) {
        return ascending ? aNum.compareTo(bNum) : bNum.compareTo(aNum);
      }

      return ascending ? aValue.compareTo(bValue) : bValue.compareTo(aValue);
    });

    load();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    if (widget.tableData.tableDataList.isEmpty)
      return Container();
    else
      return SizedBox(
        width: double.infinity,
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            Column(
              children: [
                if (widget.showDeleteBtn)
                  AnimatedContainer(
                    duration: Duration(milliseconds: 400),
                    height: widget.tableData.tableDataList
                                .where((e) => e.selected)
                                .toList()
                                .length <
                            2
                        ? 0
                        : 24,
                  ),
                SizedBox(
                  width: double.infinity,
                  child: PaginatedTableData(
                    horizontalMargin:
                        size.getW(widget.tableData.showCheckBox ? 0 : 10),
                    checkboxHorizontalMargin: 0,
                    dataRowHeight: size.getH(72),
                    columnSpacing: size.getW(24),
                    showCheckboxColumn: widget.tableData.showCheckBox,
                    rowsPerPage: widget.tableData.tableDataList.isNotEmpty
                        ? widget.tableData.tableDataList.length
                        : 1,
                    totalLength: widget.total ?? 0,
                    page: widget.page,
                    sortColumnIndex: sortColumnIndex,
                    sortAscending: sortAscending,
                    pageSize: widget.pageSize,
                    onPageNext: widget.paginate != null &&
                            (widget.page * widget.pageSize <
                                (widget.total ?? 0))
                        ? () {
                            widget.paginate!(widget.page + 1);
                          }
                        : null,
                    onPagePrev: widget.paginate != null && ((widget.page) > 1)
                        ? () {
                            widget.paginate!(widget.page - 1);
                          }
                        : null,
                    columns: List<DataColumn>.generate(
                        widget.tableData.headerList.length,
                        (index) => DataColumn(
                              label: Text(
                                widget.tableData.headerList[index],
                                style: TextStyle(
                                  fontFamily: kFontFMedium,
                                  fontStyle: FontStyle.normal,
                                  fontSize: size.getS(16),
                                ),
                              ),
                              onSort: onSort,
                            )),
                    source: RestroDataSource(
                      restroList: widget.tableData.tableDataList,
                      hasAction: widget.tableData.hasAction,
                      // hasActionButton: widget.tableData.hasActionButton,
                      popUpMenuItems: widget.popUpMenuItems,
                      selective: widget.tableData.showCheckBox,
                      size: size,
                      onTapAction: (String val, restro) {
                        if (val.contains(LN.delete)) {
                          if (widget.deleteItem != null)
                            widget.deleteItem!([
                              SRDatum(
                                id: restro.id,
                                name: restro.itemList[
                                        widget.tableData.nameIndex] is String
                                    ? restro
                                        .itemList[widget.tableData.nameIndex]
                                    : "",
                              )
                            ]);
                        } else if (widget.onAction != null) {
                          var moreFun = MoreFun.None;
                          if (val.contains(LN.edit)) {
                            moreFun = MoreFun.Edit;
                          } else if (val.contains(LN.view) ||
                              val.contains(LN.viewQr)) {
                            moreFun = MoreFun.View;
                          } else if (val.contains(LN.genQr)) {
                            moreFun = MoreFun.Generate;
                          } else if (val.contains(LN.connect) ||
                              val.contains(LN.useThisDevice) ||
                              val.contains(LN.pair) ||
                              val.contains(LN.create)) {
                            moreFun = MoreFun.Connect;
                          } else if (val.contains("Assign Service") ||
                              val.contains("Tag Products")) {
                            moreFun = MoreFun.Assign;
                          } else if (val.contains("Commission")) {
                            moreFun = MoreFun.Commission;
                          } else if (val.contains("Stock History")) {
                            moreFun = MoreFun.StockHistory;
                          }
                          widget.onAction!(
                            SRDatum(
                              id: restro.id,
                              name: restro.itemList[widget.tableData.nameIndex]
                                      is String
                                  ? restro.itemList[widget.tableData.nameIndex]
                                  : "",
                            ),
                            moreFun,
                          );
                        }
                      },
                      selectedDataFun: () {
                        if (widget.selectItem != null)
                          widget.selectItem!(widget.tableData.tableDataList
                              .where((e) => e.selected)
                              .toList()
                              .length);
                      },
                    ),
                  ),
                ),
              ],
            ),
            widget.showDeleteBtn &&
                    widget.tableData.tableDataList
                            .where((e) => e.selected)
                            .toList()
                            .length >
                        1
                ? Positioned(
                    top: 0,
                    right: 4,
                    child: SizedBox(
                      width: size.getW(90),
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all(Colors.red.shade700),
                              padding: WidgetStateProperty.all(
                                  EdgeInsets.symmetric(
                                      horizontal: size.getW(8),
                                      vertical: size.getH(6)))),
                          onPressed: () {
                            final gonnaDelete = widget.tableData.tableDataList
                                .where((e) => e.selected)
                                .toList();
                            final pCatList = List.generate(
                                gonnaDelete.length,
                                (index) => SRDatum(
                                      id: gonnaDelete[index].id,
                                      name: gonnaDelete[index].itemList[widget
                                              .tableData.nameIndex] is String
                                          ? gonnaDelete[index].itemList[
                                              widget.tableData.nameIndex]
                                          : "",
                                    ));
                            if (widget.deleteItem != null)
                              widget.deleteItem!(pCatList);
                          },
                          child: Text(
                            LN.delete,
                            style: TextStyle(
                              fontSize: size.getS(16),
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    ),
                  )
                : SizedBox.shrink()
          ],
        ),
      );
  }
}
