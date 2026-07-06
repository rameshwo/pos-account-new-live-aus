// import 'dart:convert';
// import 'dart:developer';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/setting/table_layout/layout_design_model.dart';
import 'package:pos_account/providers/booking/table_arrange_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/general/common/common_header.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'com/draw_line_section.dart';
import 'com/resizable_table.dart';
import 'com/table_back.dart';

class TableArrangeUI extends StatefulWidget {
  final Function()? onBack;
  const TableArrangeUI({super.key, this.onBack});

  @override
  State<TableArrangeUI> createState() => _TableArrangeUIState();
}

class _TableArrangeUIState extends State<TableArrangeUI> {
  late TableArrangePro taPro;
  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    taPro = Provider.of<TableArrangePro>(context, listen: false);
    await Future.delayed(Duration(milliseconds: 500));
    final xratio =
        taPro.tableArea.width / (taPro.layoutDesign?.tableSize?.width ?? 0);

    final yratio =
        taPro.tableArea.height / (taPro.layoutDesign?.tableSize?.height ?? 0);

    final areaRatio = xratio * yratio;

    // print(
    //     "${taPro.tableArea.width}/${(taPro.layoutDesign?.tableSize?.width ?? 0)}  $_yratio $_areaRatio");

    for (final e in taPro.pDList) {
      e.left = e.left * xratio;
      e.top = e.top * yratio;
      e.size = e.size * areaRatio;
    }

    // log(json.encode(taPro.pDList.map((e) => e.toJson()).toList()));
    _loading = false;
    taPro.notify;
  }

  bool _loading = true;

  @override
  void dispose() {
    _loading = true;
    taPro.tappedId = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final taPro = Provider.of<TableArrangePro>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SizedBox(
        //   height: size.getH(8),
        // ),
        SizedBox(
          height: size.getH(83),
          child: CommonHeader(
            child: Row(
              children: [
                InkWell(
                    onTap: widget.onBack,
                    child:
                        Icon(Icons.arrow_back_outlined, size: size.getW(25))),
                SizedBox(
                  width: size.getW(12),
                ),
                Text(
                  "Table Arrangement",
                  style: TextStyle(
                    fontSize: size.getS(24),
                    fontFamily: kFontFRegular,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: size.getW(12),
                ),
                Material(
                  color: Colors.white,
                  child: InkWell(
                    onTap: () {
                      final _data = PData(
                        id: Utils.getRandomString(15),
                        key: GlobalKey(),
                        objectType: ObjectType.Line,
                        top: 50,
                        left: 250,
                        lineData: LineData(
                          startPoint: [0, 25],
                          endPoint: [200, 25],
                          strokeWidth: 4,
                          lineColor: 0x00ff0000,
                        ),
                      );
                      taPro.pDList.add(_data);
                      taPro.notify;
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade600),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: size.getW(12), vertical: size.getH(2)),
                        child: Row(
                          children: [
                            Container(
                              height: 1.1,
                              width: size.getW(16),
                              color: Colors.black,
                            ),
                            SizedBox(
                              width: size.getW(4),
                            ),
                            Text("Draw Line",
                                style: TextStyle(
                                  fontSize: size.getS(16),
                                  fontFamily: kFontFRegular,
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(left: size.getW(12)),
                    padding: EdgeInsets.symmetric(
                        horizontal: size.getW(12), vertical: size.getH(4)),
                    decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline,
                            color: Colors.blue.shade900, size: size.getS(18)),
                        SizedBox(
                          width: size.getW(4),
                        ),
                        Text(
                          LN.tapMoveTableSpace,
                          style: TextStyle(
                            color: Colors.blue.shade900,
                            fontSize: size.getS(14),
                          ),
                        ),
                      ],
                    )),
                Spacer(),
                Row(
                  children: [
                    LoadButton(
                      vPad: 6,
                      hPad: 4,
                      btnColor: Colors.red.shade700,
                      onsave: () {
                        taPro.refresh();
                      },
                      btnText: LN.clearTables,
                      fontSize: 16,
                    ),
                    SizedBox(width: size.getW(12)),
                    LoadButton(
                      vPad: 6,
                      hPad: 4,
                      btnColor: kSecondaryColor,
                      loading: taPro.updateLoad,
                      loadingText:
                          taPro.editTableData == null ? "Saving" : "Updating",
                      onsave: () {
                        taPro.addUpTableLay();
                      },
                      btnText: taPro.editTableData == null ? LN.add : LN.update,
                      fontSize: 16,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Expanded(
            child: Processing(
          loading: taPro.updateLoad,
          child: Stack(
            children: [
              TableBackground(
                size: size,
                taPro: taPro,
              ),
              if (!_loading && taPro.pDList.isNotEmpty)
                ...List.generate(
                    taPro.pDList.length,
                    (index) => SelectedObj(
                          pData: taPro.pDList[index],
                          taPro: taPro,
                          removeLine: (val) {
                            if (val == null) return;
                            taPro.pDList.removeWhere((e) => e.id == val.id);
                            taPro.notify;
                          },
                        )),
            ],
          ),
        )),
      ],
    );
  }
}

class SelectedObj extends StatelessWidget {
  final TableArrangePro taPro;
  final PData pData;
  final Function(PData?)? removeLine;
  const SelectedObj({
    super.key,
    required this.taPro,
    required this.pData,
    this.removeLine,
  });

  @override
  Widget build(BuildContext context) {
    if (pData.objectType == ObjectType.Line) {
      return DrawLineSection(
        dotColor: Colors.red,
        pData: pData,
        minOffset: Offset(taPro.tableArea.minWidth, taPro.tableArea.minHeight),
        maxOffset: Offset(taPro.tableArea.maxWidth, taPro.tableArea.maxHeight),
        removeLine: removeLine,
      );
    } else
      return AnimatedPositioned(
        duration: taPro.doAnimate ? Duration(milliseconds: 300) : Duration.zero,
        left: pData.left,
        top: pData.top,
        child: GestureDetector(
            onPanUpdate: (details) {
              pData.left = math.max(0, pData.left + (details.delta.dx));
              pData.top = math.max(0, pData.top + (details.delta.dy));

              if (pData.left > taPro.tableArea.maxWidth) {
                pData.left = taPro.tableArea.maxWidth - 1;
              }

              if (pData.top > taPro.tableArea.maxHeight) {
                pData.top = taPro.tableArea.maxHeight - 1;
              }

              ////////printing data
              // print("left: ${pData.left} top: ${pData.top}");
              // print(
              //     "left: ${pData.left} > ${size.width - size.getW(48)} top: ${pData.top} > ${taPro.tableArea.maxHeight}");
              // left: 1190.859375 > 1258.6711297071129 top: 693.9788818359375 > 833.3355648535564
              taPro.notify;
            },
            onDoubleTap: () {
              taPro.initObject(pData);
            },
            onPanStart: (details) {
              // pData.isTapped = true;
              taPro.tappedId = null;
              taPro.notify;
            },
            onPanEnd: (details) {
              // pData.isTapped = false;
              // taPro.notify;
              // print("left: ${pData.left + 28} === ${taPro.tableArea.minWidth}");
              if (pData.left + 46 < taPro.tableArea.minWidth) {
                //28 try later
                taPro.initObject(pData);
              }
              // if ( _taPro.selectedPData!.left < 135) {
              //   _taPro.initObject(_taPro.pData[index].id);
              // }
            },
            onTap: () {
              if (taPro.tappedId == pData.id)
                taPro.tappedId = null;
              else
                taPro.tappedId = pData.id;
              taPro.notify;
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReSiTable(
                  pData: pData,
                  onSizeUpdate: (double val) {
                    pData.size = val;
                    taPro.notify;
                  },
                  onRotUpdate: (double val) {
                    pData.angle = val;
                    taPro.notify;
                  },
                  tappedId: taPro.tappedId,
                ),
                if (taPro.tappedId != pData.id &&
                    (pData.title?.isNotEmpty ?? false))
                  Container(
                    margin: EdgeInsets.only(top: 12),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      pData.title ?? '',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: kFontFMedium,
                        color: Colors.black,
                      ),
                    ),
                  )
              ],
            )),
      );
  }
}
