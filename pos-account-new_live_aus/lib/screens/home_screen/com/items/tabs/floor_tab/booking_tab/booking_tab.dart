import 'package:flutter/material.dart';
import 'package:pos_account/config/responsive.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/common/table_id_name.dart';
import 'package:pos_account/model/home/setting/table_layout/layout_design_model.dart';
import 'package:pos_account/providers/booking/table_resv_pro.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../table_layout/floor_plan_tab.dart';
import 'com/book_customer/book_customer.dart';
import 'com/details/details_header.dart';
import 'com/details/table_resv_detail.dart';

class BookingTab extends StatefulWidget {
  final Function()? onBack;
  final GlobalKey<ScaffoldState>? scafKey;
  const BookingTab({
    super.key,
    this.onBack,
    this.scafKey,
  });

  @override
  State<BookingTab> createState() => _BookingTabState();

  static Future showBookingDia(
    BuildContext context, {
    required Ssize size,
    bool isFromMainScreen = false,
    GlobalKey<ScaffoldState>? scafKey,
    bool isQuick = false,
    DialogFrom dialogFrom = DialogFrom.BookingPage,
  }) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (builder) => SimpleDialog(
              // backgroundColor: kPrimaryColor,
              titlePadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.symmetric(
                  horizontal: size.getW(12), vertical: size.getH(12)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              children: [
                BookCustomer(
                  isQuick: isQuick,
                  onTapTable: (TableResvPro pro) async {
                    if (isFromMainScreen) {
                      Navigator.pop(context, true);
                      return;
                    }
                    final value = await BookingTab.showTableLayoutDia(
                      context,
                      size: size,
                      selectedTableLayId: pro.tableIdName,
                      scafKey: scafKey,
                      dialogFrom: dialogFrom,
                      // pro.tableNoIndex == null || pro.tables.isEmpty
                      //     ? null
                      //     : pro.tables[pro.tableNoIndex!].id,
                    );

                    if (value != null && value is PData) {
                      pro.tableIdName ??= [];
                      final _val = value;

                      if (!(pro.tableIdName?.any((a) =>
                              a.id?.toLowerCase() == value.id?.toLowerCase()) ??
                          false)) {
                        pro.tableIdName?.add(TableIdName(
                            id: _val.id,
                            name: _val.title,
                            mergeId: _val.pElements.isNotEmpty &&
                                    (_val.pElements.first.mergeId?.isNotEmpty ??
                                        false)
                                ? _val.pElements.first.mergeId
                                : null));
                      }
                      // pro.tableIdName = value.id;
                      pro.adultCltr.text = _val.adult ?? '';
                      pro.childCltr.text = _val.child ?? '';
                    }
                    pro.notify;
                  },
                )
              ],
            ));
  }

  static Future showTableLayoutDia(
    BuildContext context, {
    required Ssize size,
    List<TableIdName>? selectedTableLayId,
    GlobalKey<ScaffoldState>? scafKey,
    required DialogFrom dialogFrom,
  }) {
    return showDialog(
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
                FloorPlanTab(
                  key: UniqueKey(),
                  scafKey: scafKey,
                  selectedTableLayId: selectedTableLayId,
                  isDialog: dialogFrom,
                )
              ],
            ));
  }
}

class _BookingTabState extends State<BookingTab> {
  late TableResvPro _tableResv;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getData());
  }

  getData() async {
    _tableResv = Provider.of<TableResvPro>(context, listen: false);
    await _tableResv.getData();
    _tableResv.getAllTableResv(page: 1);
  }

  paginate(int page) {
    _tableResv.getAllTableResv(page: page);
  }

  @override
  void dispose() {
    _tableResv.clear2();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final tableResv = Provider.of<TableResvPro>(context);
    const double _c = 36;
    return Processing(
      loading: tableResv.loadiing,
      child: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (ctx, innerBoxScrolled) => [
          SliverAppBar(
            floating: true,
            snap: false,
            centerTitle: false,
            pinned: true,
            backgroundColor: kBackgroundColor,
            toolbarHeight: SData<double>(data: [
              size.getH(308 - _c),
              size.getH(142 - _c),
              size.getH(208 - _c),
              size.getH(142 - _c),
              size.getH(198 - _c),
              size.getH(188 - _c),
              size.getH(212 - _c),
              size.getH(132 - _c),
              size.getH(118 - _c),
            ]).get(context),
            forceElevated: innerBoxScrolled,
            leadingWidth: 0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row(
                //   children: [
                //     if (widget.onBack != null)
                //       IconButton(
                //           visualDensity: VisualDensity.compact,
                //           onPressed: widget.onBack,
                //           icon: Icon(
                //             Icons.arrow_back,
                //             color: Colors.black,
                //           )),
                //     Text(
                //       LN.tableBookResv,
                //       style: TextStyle(
                //         fontSize: size.getS(18),
                //         fontFamily: kFontFMedium,
                //         fontWeight: FontWeight.bold,
                //         color: Colors.black,
                //       ),
                //     ),
                //     Spacer(),
                //     ElevatedButton(
                //         style: ButtonStyle(
                //             backgroundColor:
                //                 MaterialStateProperty.all(kSecondaryColor),
                //             padding: MaterialStateProperty.all(
                //                 EdgeInsets.symmetric(
                //                     horizontal: size.getW(24),
                //                     vertical: size.getH(8)))),
                //         onPressed: tableResv.loadiing
                //             ? null
                //             : () {
                //                 // BookingTab.showTableLayoutDia(context,
                //                 //         size: size)
                //                 //     .then((value) {
                //                 //   if (value != null && value is String) {
                //                 tableResv.clear();
                //                 tableResv.getCountryList();

                //                 // if (tableResv.tables.any((e) =>
                //                 //     e.id?.toLowerCase() ==
                //                 //     value.toLowerCase())) {
                //                 //   tableResv.tableNoIndex =
                //                 //       tableResv.tables.indexWhere((e) =>
                //                 //           e.id?.toLowerCase() ==
                //                 //           value.toLowerCase());
                //                 // }
                //                 BookingTab.showBookingDia(
                //                   context,
                //                   size: size,
                //                   scafKey: widget.scafKey,
                //                 );
                //                 //   }
                //                 // });
                //               },
                //         child: Row(
                //           mainAxisSize: MainAxisSize.min,
                //           children: [
                //             Icon(
                //               Icons.add,
                //               size: size.getS(25),
                //               color: Colors.white,
                //             ),
                //             SizedBox(
                //               width: size.getW(8),
                //             ),
                //             Text(
                //               LN.newBooking,
                //               style: TextStyle(
                //                 fontSize: size.getS(16),
                //                 color: Colors.white,
                //                 fontWeight: FontWeight.bold,
                //               ),
                //             )
                //           ],
                //         ))
                //   ],
                // ),
                SizedBox(
                  height: size.getH(12),
                ),
                DetailsHeader(
                  size: size,
                  tableResv: tableResv,
                  scafKey: widget.scafKey,
                ),
                SizedBox(
                  height: size.getH(8),
                ),
              ],
            ),
            // bottom: PreferredSize(
            //     child: DetailsHeader(
            //       size: size,
            //       tableResv: tableResv,
            //     ),
            //     preferredSize: Size.fromHeight(size.getH(120))),
          ),
        ],
        body: Stack(
          children: [
            tableResv.bookingList.isNotEmpty
                ? SmartRefresher(
                    controller: tableResv.bookingRefreshCltr,
                    enablePullUp: true,
                    onLoading: () {
                      paginate(tableResv.bookPageIndex + 1);
                    },
                    onRefresh: () {
                      paginate(1);
                    },
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: size.getW(12)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: size.getH(12),
                          ),
                          TableResvDetail(
                            size: size,
                            tableResv: tableResv,
                          ),
                          SizedBox(
                            height: size.getH(24),
                          ),
                        ],
                      ),
                    ),
                  )
                : !tableResv.loadiing && tableResv.bookingList.isEmpty
                    ? Align(
                        alignment: Alignment.topLeft,
                        child: NoItemsSec(
                          size: size,
                          title: LN.noBookFound,
                        ),
                        // NotFoundWidget(size: size, title: "No Booking Found"),
                      )
                    : Container(),
            // PaginateButton(
            //   total: tableResv.allTableRsrv?.total ?? 0,
            //   pageSize: 12,
            //   pageIndex: tableResv.detailPage,
            //   next: () => paginate(tableResv.detailPage + 1),
            //   prev: () => paginate(tableResv.detailPage - 1),
            // ),
          ],
        ),
      ),
    );
  }
}
