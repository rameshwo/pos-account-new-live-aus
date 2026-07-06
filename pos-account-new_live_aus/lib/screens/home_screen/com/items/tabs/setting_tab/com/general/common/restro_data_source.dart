import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/setting/general/category/restro_table_model.dart';
import 'package:pos_account/widgets/image/image_error.dart';

////// Data source class for obtaining row data for PaginatedDataTable.
class RestroDataSource extends DataTableSource {
  // int _selectedCount = 0;

  final List<TableDataList> restroList;
  final Function(String, TableDataList)? onTapAction;
  final bool hasAction;
  final bool selective;
  final Ssize size;
  final Function()? selectedDataFun;
  final List<String> Function(int)? popUpMenuItems;

  RestroDataSource({
    required this.restroList,
    this.onTapAction,
    this.selectedDataFun,
    this.hasAction = true,
    this.popUpMenuItems,
    this.selective = true,
    required this.size,
  });

  List<PopupMenuItem<String>> _getMenuItems({List<String>? dataList}) {
    dataList ??= [
      LN.edit,
      LN.delete,
    ];
    return dataList
        .map((e) => PopupMenuItem(
            value: e,
            child: Text(
              e,
              style: TextStyle(fontSize: size.getS(16)),
            )))
        .toList();
  }

  DataCell statusDataCell(int rowIndex, int statusIndex) {
    if (restroList[rowIndex].statusList[statusIndex] == TableStatus.None) {
      return DataCell(Container());
    } else {
      return DataCell(Container(
          width: size.getW(100),
          decoration: BoxDecoration(
              color:
                  getStatusColor(restroList[rowIndex].statusList[statusIndex])
                      .backColor,
              borderRadius: BorderRadius.circular(5)),
          padding: EdgeInsets.symmetric(
              horizontal: size.getW(4), vertical: size.getH(4)),
          child: Text(
            restroList[rowIndex].statusList[statusIndex].name,
            style: TextStyle(
              color:
                  getStatusColor(restroList[rowIndex].statusList[statusIndex])
                      .textColor,
              fontFamily: kFontFMedium,
              fontSize: size.getS(14),
            ),
            textAlign: TextAlign.center,
          )));
    }
  }

  DataCell actionDataCell(int index, int j) {
    return DataCell(restroList[index].actionWidget![j]);
  }

  DataCell popUpAction(int index) {
    return DataCell(
      PopupMenuButton(
        padding: EdgeInsets.zero,
        itemBuilder: (context) => _getMenuItems(
            dataList: popUpMenuItems == null ? null : popUpMenuItems!(index)),
        onSelected: onTapAction != null
            ? (String val) => onTapAction!(val, restroList[index])
            : null,
        child: Container(
          color: Colors.transparent,
          width: size.getW(100),
          height: size.getH(48),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.more_vert,
                size: size.getS(24),
              ),
              Flexible(
                  child: Icon(Icons.keyboard_arrow_down, size: size.getS(24))),
            ],
          ),
        ),
      ),
    );
  }

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= restroList.length) return null;
    // final RestroTableModel restro = restroList[index];
    return DataRow.byIndex(
      index: index,
      selected: restroList[index].selected,
      onSelectChanged: !selective
          ? null
          : (bool? value) {
              if (value == null) return;
              if (restroList[index].selected != value) {
                restroList[index].selected = value;
                notifyListeners();
              }
              if (selectedDataFun != null) selectedDataFun!();
            },
      cells: <DataCell>[
        if (restroList[index].imgList != null &&
            restroList[index].imgList!.isNotEmpty)
          ...List.generate(
              restroList[index].imgList!.length,
              (j) => DataCell(
                    Align(
                      alignment: Alignment.center,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(200),
                        child: restroList[index].imgList![j] == null
                            ? SizedBox.shrink()
                            : restroList[index].imgList![j]!.contains('assets/')
                                ? Image.asset(
                                    restroList[index].imgList![j]!,
                                    fit: BoxFit.cover,
                                    width: size.getW(40),
                                    height: size.getH(40),
                                  )
                                : CachedNetworkImage(
                                    imageUrl: restroList[index].imgList![j]!,
                                    fit: BoxFit.cover,
                                    width: size.getW(40),
                                    height: size.getH(40),
                                    placeholder: ImageError.load,
                                    errorWidget: (ctx, _, __) =>
                                        ImageError.noItemImage(
                                            ctx, size.getH(40), size.getW(40)),
                                    //     SvgPicture.asset(
                                    //   "assets/svg/others/avatar.svg",
                                    //   fit: BoxFit.cover,
                                    //   width: size.getW(40),
                                    //   height: size.getH(40),
                                    // ),
                                  ),
                      ),
                    ),
                  )),
        ...List.generate(
            restroList[index].itemList.length,
            (j) => DataCell(Row(
                  children: [
                    if (j == 0) ...[
                      if ((restroList[index].image?.isNotEmpty ?? false))
                        Padding(
                          padding: EdgeInsets.only(right: size.getW(16)),
                          child: CachedNetworkImage(
                            imageUrl: restroList[index].image!,
                            fit: BoxFit.cover,
                            width: size.getW(40),
                            height: size.getH(40),
                            placeholder: ImageError.load,
                            errorWidget: (ctx, _, __) => ImageError.noItemImage(
                                ctx, size.getH(40), size.getW(40)),
                          ),
                        )
                      else if (restroList
                          .any((a) => a.image?.isNotEmpty ?? false))
                        Padding(
                          padding: EdgeInsets.only(right: size.getW(16)),
                          child: ImageError.noItemImage(
                              size.context, size.getH(40), size.getW(40)),
                        )
                    ],
                    restroList[index].itemList[j] is String
                        ? SizedBox(
                            width: restroList[index]
                                        .itemList[j]
                                        .toString()
                                        .length >
                                    40
                                ? size.getW(180)
                                : null,
                            child: SelectableText(
                                restroList[index].itemList[j].toString(),
                                style: TextStyle(
                                  fontSize: size.getS(16),
                                )),
                          )
                        : restroList[index].itemList[j] is Widget
                            ? restroList[index].itemList[j]
                            : SizedBox()
                  ],
                ))),
        ...List.generate(restroList[index].statusList.length,
            (j) => statusDataCell(index, j)),
        if (restroList[index].actionWidget != null)
          ...List.generate(restroList[index].actionWidget!.length,
              (j) => actionDataCell(index, j)),
        if (hasAction) popUpAction(index)
      ],
    );
  }

  @override
  int get rowCount => restroList.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount =>
      restroList.where((e) => e.selected).toList().length;
}
