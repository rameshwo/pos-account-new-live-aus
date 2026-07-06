import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/setting/table_layout/layout_design_model.dart';
import 'package:pos_account/providers/booking/table_arrange_pro.dart';
import 'package:pos_account/repository/if_exception.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/table_layout/com/table_layout_view.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import 'package:provider/provider.dart';

class SwitchTableDia extends StatefulWidget {
  final String? selectedTableLayId;
  final String? orderId;

  const SwitchTableDia({
    super.key,
    this.selectedTableLayId,
    this.orderId,
  });

  @override
  State<SwitchTableDia> createState() => _SwitchTableDiaState();
}

class _SwitchTableDiaState extends State<SwitchTableDia> {
  int? selectedForEdit;

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

  Widget _header(Ssize size, TableArrangePro taPro) {
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
                          isSelected: selectedForEdit == index,
                          onTap: () async {
                            _selectedTableId = null;
                            // _tableResv.tableId = null;
                            selectedForEdit = index;
                            _loading = true;
                            taPro.notify;
                            final _newPData = await _taPro.getTableStatus2(
                              id: taPro.addSecRes!
                                  .tableLocationsWithTables![index].id!,
                            );

                            _setData(_newPData);

                            _loading = false;
                            taPro.notify;
                          },
                        );
                      } else
                        return SizedBox.shrink();
                    }),
                  ),
                ),
        ),
      ],
    );
  }

  String? _selectedTableId;
  late TableArrangePro _taPro;

  List<PData>? _newData;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getData();
    });
  }

  void _getData() {
    _taPro = Provider.of<TableArrangePro>(context, listen: false);
    selectedForEdit = _taPro.selectedForEdit;
    _setData(_taPro.editPData);
    _loading = false;
    _taPro.notify;
  }

  void _setData(List<PData>? editPData) {
    _newData = editPData
        ?.map(
          (e) => PData.fromJson(e.toJson())
            ..key = GlobalKey()
            ..title = e.title
            ..image = e.image
            ..adult = e.adult
            ..child = e.child
            ..pElements = e.pElements,
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final taPro = Provider.of<TableArrangePro>(context);

    return Processing(
      loading: _loading,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: size.height / 1.12,
          minHeight: size.height / 5,
        ),
        width: size.width / 1.17,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Switch Table",
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
            SizedBox(height: size.getH(12)),
            _header(size, taPro),
            if (_loading)
              Container()
            else ...[
              if ((taPro.addSecRes?.tableLocationsWithTables?.isNotEmpty ??
                      false) &&
                  (_newData?.isNotEmpty ?? false))
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 7,
                        child: SingleChildScrollView(
                          child: FittedBox(
                            fit: BoxFit
                                .contain, // Makes sure the content fits without overflowing
                            child: SizedBox(
                              width: taPro.layoutWidth + 500,
                              height: taPro.layoutHeight + 100,
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
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  ...List.generate(_newData!.length, (index) {
                                    final pData = _newData![index];
                                    final selected = pData.id?.toLowerCase() ==
                                        _selectedTableId?.toLowerCase();
                                    return TableObject(
                                      isSelected: selected,
                                      prevSelected: pData.id?.toLowerCase() ==
                                          widget.selectedTableLayId,
                                      pData: pData,
                                      minLeft: taPro.layoutDesign?.tableArea
                                              ?.minWidth ??
                                          0,
                                      onTap: () async {
                                        if (_selectedTableId == pData.id) {
                                          _selectedTableId = "";
                                        } else {
                                          if (pData.pElements.first.status ==
                                              FloorTblStatus.Occupied) {
                                            IfException.showMessage(
                                                message:
                                                    "Table is already occupied");
                                            return;
                                          }

                                          _selectedTableId = pData.id;
                                        }
                                        taPro.notify;
                                      },
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Center(child: NoItemsSec(size: size, title: LN.noFloorSetup)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.getH(28)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    LoadButton(
                      btnColor: Colors.red,
                      btnText: "Cancel",
                      hPad: 12,
                      vPad: 8,
                      onsave: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(
                      width: size.getW(8),
                    ),
                    LoadButton(
                      btnText: "Confirm",
                      hPad: 12,
                      vPad: 8,
                      width: 200,
                      loading: taPro.switchButtonLoad,
                      onsave: () async {
                        final _status = await taPro.switchTable(
                          orderId: widget.orderId,
                          tableId: _selectedTableId,
                        );

                        if (_status) {
                          Navigator.pop(context, _selectedTableId);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
            SizedBox(
              height: size.getH(24),
            ),
          ],
        ),
      ),
    );
  }
}
