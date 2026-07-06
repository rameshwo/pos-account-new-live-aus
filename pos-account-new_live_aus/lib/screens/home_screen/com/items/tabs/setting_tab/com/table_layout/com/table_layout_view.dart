import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/setting/table_layout/layout_design_model.dart';
import 'package:pos_account/providers/booking/table_arrange_pro.dart';
import 'package:pos_account/screens/home_screen/com/table_arrange/com/draw_line_section.dart';
import 'package:pos_account/screens/home_screen/com/table_arrange/com/resizable_table.dart';
import 'package:pos_account/widgets/loading.dart';

class TableLayView extends StatelessWidget {
  final Ssize size;
  final Function()? onBack;
  final Function()? onEdit;
  final TableArrangePro taPro;
  const TableLayView(
      {super.key,
      required this.size,
      this.onBack,
      required this.taPro,
      this.onEdit});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(onPressed: onBack, icon: Icon(Icons.arrow_back)),
              Text(
                taPro.allTableLayRes?.data?[taPro.selectedForEdit]
                        .tableLocationName ??
                    ''
                // LN.roundTable,
                ,
                style: TextStyle(
                  fontSize: size.getS(18),
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Spacer(),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(kPrimaryColor)),
                  onPressed: onEdit,
                  child: Text(
                    LN.edit,
                    style: TextStyle(
                      fontSize: size.getS(16),
                      color: Colors.white,
                    ),
                  ))
            ],
          ),
          SizedBox(
            height: taPro.layoutDesign?.tableSize?.height ?? size.height,
            child: Processing(
              loading: taPro.editableLoading,
              child: Stack(
                children: [
                  DottedBorder(
                    color: Colors.grey.shade400,
                    borderType: BorderType.RRect,
                    strokeWidth: 3,
                    dashPattern: [24, 12],
                    radius: Radius.circular(15),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  if (taPro.editPData != null && taPro.editPData!.isNotEmpty)
                    ...List.generate(
                        taPro.editPData!.length,
                        (index) => TableObject(
                              pData: taPro.editPData![index],
                              minLeft:
                                  taPro.layoutDesign?.tableArea?.minWidth ?? 0,
                              // itemBuilder: (_) {
                              //   return [
                              //     CusPopupMenuItem(
                              //       child: LoadButton(
                              //         width: double.infinity,
                              //         btnText: LN.viewOrder,
                              //         btnColor: kSecondaryColor,
                              //       ),
                              //     ),
                              //     CusPopupMenuItem(
                              //       child: LoadButton(
                              //         width: double.infinity,
                              //         btnText: LN.pay,
                              //         btnColor: kPrimaryColor,
                              //       ),
                              //     ),
                              //   ];
                              // },
                            )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TableObject extends StatelessWidget {
  final PData pData;
  final double minLeft;
  final bool isSelected;
  final bool prevSelected;
  // final List<CusPopupMenuEntry> Function(BuildContext)? itemBuilder;
  final Function()? onTap;
  final List<String?>? mergeIds;
  const TableObject({
    super.key,
    required this.pData,
    this.minLeft = 0.0,
    // this.itemBuilder,
    this.onTap,
    this.isSelected = false,
    this.prevSelected = false,
    this.mergeIds,
  });

  @override
  Widget build(BuildContext context) {
    const double minTop = 12;
    final size = Ssize(context);
    // pData.status = "Available";
    // pData.statusColor = Colors.green.shade500;

    if (pData.objectType == ObjectType.Line) {
      return DrawLineSection(
        pData: pData,
        minLeft: minLeft,
        minTop: minTop,
      );
    } else {
      return AnimatedPositioned(
        duration: Duration(milliseconds: 300),
        left: pData.left - minLeft - size.getS(8) + 40,
        top: pData.top - minTop - size.getS(8) - (isSelected ? 10 : 0) + 40,
        child: InkWell(
          onTap: onTap,
          // tooltip: pData.title,
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.circular(10),
          // ),
          // offset: Offset(0, 60),
          // itemBuilder: itemBuilder ?? (_) => [],
          child: DottedBorder(
            color: prevSelected
                ? Colors.grey.shade500
                : isSelected
                    ? kSecondaryColor
                    : Colors.transparent,
            radius: Radius.circular(20),
            strokeCap: StrokeCap.round,
            borderType: BorderType.RRect,
            strokeWidth: 4,
            dashPattern: [12, 20],
            padding: EdgeInsets.all(size.getS(8)),
            child: Stack(
              alignment: Alignment.center,
              children: [
                ReSiTable(
                  key: pData.key,
                  pData: pData,
                  mergeIds: mergeIds,
                ),
                if (pData.title?.isNotEmpty ?? false)
                  Container(
                    margin: EdgeInsets.only(top: size.getH(2)),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                    child: Column(
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: size.getW(12)),
                          child: Text(
                            pData.title ?? '',
                            style: TextStyle(
                              fontSize: size.getS(16),
                              fontFamily: kFontFMedium,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        if (pData.pElements.isNotEmpty &&
                            pData.pElements.first.status.name.isNotEmpty)
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.getW(8),
                                vertical: size.getH(6)),
                            margin: EdgeInsets.only(bottom: size.getH(6)),
                            decoration: BoxDecoration(
                                color: pData.pElements.first.statusColor,
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(
                              pData.pElements.first.status.name,
                              style: TextStyle(
                                fontSize: size.getS(12),
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                // if (isSelected)
                //   Positioned(
                //     bottom: 0,
                //     child: Container(
                //       height: size.getH(32),
                //       margin: EdgeInsets.only(bottom: size.getH(8)),
                //       padding: EdgeInsets.symmetric(horizontal: size.getW(12)),
                //       decoration: BoxDecoration(
                //           color: Colors.blue.shade700,
                //           borderRadius: BorderRadius.circular(5)),
                //       alignment: Alignment.center,
                //       child: Text(
                //         LN.selected,
                //         style: TextStyle(
                //           fontSize: size.getS(18),
                //           fontWeight: FontWeight.bold,
                //           color: Colors.white,
                //         ),
                //       ),
                //     ),
                //   ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
