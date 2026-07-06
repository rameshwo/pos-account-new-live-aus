import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:pos_account/config/responsive.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/booking/table_arrange_pro.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'com/table_layout_view.dart';

class ViewTableLayout extends StatefulWidget {
  final String floorId;
  final String floorName;
  const ViewTableLayout({
    super.key,
    required this.floorName,
    required this.floorId,
  });

  @override
  State<ViewTableLayout> createState() => _ViewTableLayoutState();
}

class _ViewTableLayoutState extends State<ViewTableLayout> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getData());
  }

  late TableArrangePro _taPro;

  Future<void> getData() async {
    _taPro = Provider.of<TableArrangePro>(context, listen: false);
    await _taPro.getAddSection();
    await _taPro.getTableLay(
      tableId: widget.floorId,
      doResize: false,
    );
    // final maxScroll = _controller.position.maxScrollExtent;
    // _controller.jumpTo(maxScroll / 2);
    Future.delayed(Duration(milliseconds: 200), () {
      _controller.animateTo(
        _controller.position.maxScrollExtent / 2,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    });

    // _taPro.getData();
  }

  @override
  void dispose() {
    _taPro.editPData = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final taPro = Provider.of<TableArrangePro>(context);
    return Container(
      constraints: BoxConstraints(
        maxHeight: size.height / 1.12,
        minHeight: size.height / 1.5,
      ),
      width: size.width / 1.17,
      child: Processing(
        loading: taPro.editableLoading,
        child: Column(
          children: [
            SizedBox(
              height: size.getH(12),
            ),
            Row(
              children: [
                SizedBox(
                  width: size.getW(12),
                ),
                Text(
                  widget.floorName,
                  style: TextStyle(
                    fontSize: size.getS(20),
                    // fontFamily: ,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: size.getW(24),
                ),
                // IconButton(
                //   onPressed: () {

                //   },
                //   icon: Icon(Icons.edit),
                //   visualDensity: VisualDensity.compact,
                // ),
                LoadButton(
                  vPad: 6,
                  width: 100,
                  onsave: () {
                    if (taPro.addSecRes?.tableLocationsWithTables == null)
                      return;

                    if (taPro.addSecRes!.tableLocationsWithTables!.any((e) =>
                        e.id?.toLowerCase() ==
                        taPro.editTableData?.tableLocationId?.toLowerCase())) {
                      taPro.tableLocationIndex = taPro
                          .addSecRes!.tableLocationsWithTables!
                          .indexWhere((e) =>
                              e.id?.toLowerCase() ==
                              taPro.editTableData?.tableLocationId
                                  ?.toLowerCase());
                      taPro.onCheckedTable();
                    }

                    // taPro.initTableData?.clear();
                    taPro.pDList.clear();

                    if (taPro.editPData != null) {
                      taPro.pDList.addAll(taPro.editPData!);
                    }
                    taPro.notify;

                    GlobalCVP.isForBooking = true;
                    GlobalCVP.setMainPage = MainPage.BookingPage;

                    Navigator.of(context).pop(false);
                  },
                  btnColor: kPrimaryColor,
                  btnText: LN.edit,
                  textColor: Colors.white,
                ),
                // ElevatedButton(
                //     onPressed: () {

                //     },
                //     style: ButtonStyle(
                //         visualDensity: VisualDensity.compact,
                //         backgroundColor:
                //             MaterialStateProperty.all(kPrimaryColor)),
                //     child: Text(
                //       LN.edit,
                //       style: TextStyle(
                //         fontSize: size.getS(14),
                //         // fontFamily: ,
                //         fontWeight: FontWeight.bold,
                //         color: Colors.white,
                //       ),
                //     )),
                // SizedBox(
                //   width: size.getW(12),
                // ),

                // ElevatedButton(
                //     onPressed: null, //() {},
                //     style: ButtonStyle(
                //       visualDensity: VisualDensity.compact,
                //       // backgroundColor: MaterialStateProperty.all(Colors.red),
                //     ),
                //     child: Text(
                //       LN.delete,
                //       style: TextStyle(
                //         fontSize: size.getS(14),
                //         // fontFamily: ,
                //         fontWeight: FontWeight.bold,
                //         color: Colors.white,
                //       ),
                //     )),
                Spacer(),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  icon: Icon(Icons.close, size: size.getS(25)),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            SizedBox(
              height: size.getH(12),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                color: Colors.white,
                child: LayoutBuilder(builder: (context, c) {
                  final _scale = (c.maxHeight / size.height) *
                      (Responsive.isDesktop(context) ? 1.2 : 0.9);
                  // kPrint(
                  //     "${c.maxHeight} ${taPro.layoutDesign?.tableSize?.height}  ${size.height}");

                  return SingleChildScrollView(
                    controller: _controller,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Transform.scale(
                        scale: _scale,
                        // alignment: Alignment.topLeft,
                        child: SizedBox(
                          width:
                              (taPro.layoutDesign?.tableSize?.width ?? 0) + 100,
                          // (_scale < 1 ? 100 : 0),
                          height: (taPro.layoutDesign?.tableSize?.height ?? 0) +
                              100,
                          // (_scale < 1 ? 100 : 0),
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
                              if (taPro.editPData != null &&
                                  taPro.editPData!.isNotEmpty)
                                ...List.generate(
                                    taPro.editPData!.length,
                                    (index) => TableObject(
                                          pData: taPro.editPData![index],
                                          minLeft: taPro.layoutDesign?.tableArea
                                                  ?.minWidth ??
                                              0,
                                        )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
