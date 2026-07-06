import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/model/home/setting/table_layout/layout_design_model.dart';
import 'package:pos_account/providers/booking/table_arrange_pro.dart';
import 'static_table.dart';

class TableBackground extends StatelessWidget {
  final TableArrangePro taPro;
  const TableBackground({
    super.key,
    required this.size,
    required this.taPro,
  });

  final Ssize size;

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            flex: kFlexLeft,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: size.getH(8)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: Column(
                children: [
                  if (taPro.addSecRes?.tableLocationsWithTables != null &&
                      taPro.tableLocationIndex != null)
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: size.getH(8), horizontal: size.getW(12)),
                      child: Text(
                        taPro
                                .addSecRes!
                                .tableLocationsWithTables![
                                    taPro.tableLocationIndex!]
                                .value ??
                            '',
                        style: TextStyle(
                          fontSize: size.getS(18),
                          fontFamily: kFontFMedium,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                      ),
                    ),
                  // DropDownList(
                  //   indexValue: taPro.tableLocationIndex,
                  //   hint: LN.chooseTable,
                  //   borderColor: Colors.grey.shade400,
                  //   fontSize: 14,
                  //   list: taPro.addSecRes == null ||
                  //           taPro.addSecRes!.tableLocationsWithTables == null
                  //       ? []
                  //       : taPro.addSecRes!.tableLocationsWithTables!
                  //           .map((e) => e.value ?? '')
                  //           .toList(),
                  //   onChange: (p0) {
                  //     taPro.tableLocationIndex = p0;
                  //     taPro.onCheckedTable();
                  //     taPro.notify;
                  //   },
                  // ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          if (taPro.initTableData?.isNotEmpty ?? false)
                            ...List.generate(taPro.initTableData!.length,
                                (index) {
                              if (!taPro.pDList.any((e) =>
                                  e.id == taPro.initTableData![index].id))
                                return GestureDetector(
                                  onDoubleTap: () {
                                    final offset = taPro.getOffset(
                                        pData: taPro.initTableData![index]);
                                    // print(_offset); //Offset(55.9, 137.0)
                                    final pd = PData(
                                      key: taPro.initTableData![index].key,
                                      id: taPro.initTableData![index].id,
                                      title: taPro.initTableData![index].title,
                                      image: taPro.initTableData![index].image,
                                      objectType: ObjectType.Table,
                                    );
                                    if (offset != null) {
                                      pd.left = offset.dx - 4;
                                      pd.top = offset.dy -
                                          74; //+ taPro.scrollCltr.offset;
                                    }

                                    taPro.pDList.add(pd);
                                    taPro.doAnimate = true;
                                    Future.delayed(Duration(milliseconds: 300),
                                        () {
                                      taPro.pDList
                                          .firstWhere((e) => e.id == pd.id)
                                        ..top = 16
                                        ..left = 216;
                                      taPro.notify;
                                      Future.delayed(
                                          Duration(milliseconds: 400), () {
                                        taPro.doAnimate = false;
                                      });
                                    });
                                    taPro.notify;
                                  },
                                  // onLongPressEnd: (details) {
                                  //   taPro.pData[index].isTapped = false;
                                  //   taPro.notify;
                                  // },
                                  // onPanEnd: (details) {
                                  //   taPro.pData[index].isTapped = false;
                                  //   taPro.notify;
                                  // },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      top: 16,
                                    ),
                                    child: StatTable(
                                      key: taPro.initTableData![index].key,
                                      pData: taPro.initTableData![index],
                                    ),
                                  ),
                                );
                              else
                                return SizedBox.shrink();
                            }),
                          SizedBox(
                            height: size.getH(12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )),
        // SizedBox(
        //   width: size.getW(12),
        // ),
        Expanded(
          flex: kFlexMiddleProt,
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: size.getH(12), horizontal: size.getW(24)),
            child: DottedBorder(
              color: Colors.grey.shade400,
              borderType: BorderType.RRect,
              strokeWidth: 3,
              dashPattern: [24, 12],
              radius: Radius.circular(15),
              child: LayoutBuilder(builder: (context, constr) {
                final arrSize = ArrSize(
                  minWidth: size.width - constr.maxWidth - size.getW(24),
                  minHeight: size.height - constr.maxHeight - size.getH(12),
                  maxWidth: size.width - size.getW(24) - size.getW(72),
                  maxHeight: constr.maxHeight +
                      size.getH(12) -
                      size.getH(24) -
                      size.getH(44),
                  height: constr.maxHeight,
                  width: constr.maxWidth,
                );
                taPro.setArrSize = arrSize;
                // taPro.minWidth = size.width - constr.maxWidth - size.getW(24);
                // taPro.minHeight =
                //     size.height - constr.maxHeight - size.getH(12);

                // taPro.maxWidth = size.width - size.getW(24) - size.getW(72);
                // taPro.maxHeight = size.height -
                //     size.getH(24) -
                //     taPro.minHeight -
                //     size.getH(44);
                // print(
                //     "init =(${taPro.minWidth}, ${taPro.minHeight}) last = (${taPro.maxWidth}, ${taPro.maxHeight})");
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                );
              }),
            ),
          ),
        ),
        // SizedBox(
        //   width: size.getW(12),
        // ),
      ],
    );
  }
}
