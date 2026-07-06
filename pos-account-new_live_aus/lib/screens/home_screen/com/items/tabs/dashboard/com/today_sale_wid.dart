import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/dashboard/dashboard_res.dart';
import 'package:pos_account/providers/cus_val_pro.dart';

class TodaySaleWidget extends StatelessWidget {
  const TodaySaleWidget({
    super.key,
    required this.size,
    this.height = 324,
    this.curSym = '',
    required this.title,
    this.subTitle = '',
    this.salesData,
    this.width = 844,
  });

  final Ssize size;
  final double height;
  final String curSym;
  final String title;
  final String subTitle;
  final DashBoardStatisticsToday? salesData;
  final double width;

  static final colorList = [
    Color(0xfffb7d99),
    Color(0xffff957a),
    Color(0xff3cd856),
    Color(0xffbf82ff),
  ];

  static final iconList = [
    Icons.graphic_eq,
    Icons.category_rounded,
    Icons.add_task_sharp,
    Icons.person_outline_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    final _salesList = <_SalesModel>[
      if (GlobalCVP.viewWidget.viewDashBoardSalesSummaryTotalSales)
        _SalesModel(
          title: LN.totalSales,
          subTitle: "$curSym${salesData?.totalSales ?? '0.00'}".negPrice(),
        ),
      if (GlobalCVP.viewWidget.viewDashBoardSalesSummaryTotalOrders)
        _SalesModel(
          title: GlobalCVP.isServiceStore ? LN.totalServices : LN.totalOrders,
          subTitle: (double.tryParse(salesData?.totalOrders ?? '0') ?? 0)
              .round()
              .toString(),
        ),
      if (GlobalCVP.viewWidget.viewDashBoardSalesSummaryTotalRefund)
        _SalesModel(
          title: LN.totalRefund,
          subTitle: "$curSym${salesData?.totalRefund ?? '0.00'}".negPrice(),
        ),
      if (GlobalCVP.viewWidget.viewDashBoardSalesSummaryTotalCustomers)
        _SalesModel(
          title: LN.totalCus,
          subTitle: (double.tryParse(salesData?.totalCustomer ?? '0') ?? 0)
              .round()
              .toString(),
        ),
      _SalesModel(
        title: "Total Discount",
        subTitle: "$curSym${salesData?.totalDiscount ?? '0.00'}".negPrice(),
      ),
      _SalesModel(
        title: "Total Tax",
        subTitle: "$curSym${salesData?.totalTax ?? '0.00'}".negPrice(),
      ),
    ];
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: SizedBox(
        width: size.getW(width),
        height: size.getH(height),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.getW(12)),
          child: Align(
            alignment: Alignment.bottomLeft, // Alignment.centerLeft,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: size.getS(16),
                      fontFamily: kFontFMedium,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                    ),
                  ),
                  // Row(
                  //   children: [
                  //     Text(
                  //       title,
                  //       style: TextStyle(
                  //         fontSize: size.getS(16),
                  //         fontFamily: kFontFMedium,
                  //         fontWeight: FontWeight.bold,
                  //         color: kPrimaryColor,
                  //       ),
                  //     ),
                  // Spacer(),
                  // TextButton(
                  //     onPressed: () {},
                  //     style: ButtonStyle(
                  //         padding: WidgetStateProperty.all(
                  //             EdgeInsets.symmetric(
                  //                 vertical: 2, horizontal: size.getW(12))),
                  //         shape: WidgetStateProperty.all(
                  //             RoundedRectangleBorder(
                  //                 borderRadius: BorderRadius.circular(5),
                  //                 side: BorderSide(color: Colors.grey)))),
                  //     child: Row(
                  //       children: [
                  //         Icon(
                  //           Icons.calendar_today_sharp,
                  //           size: size.getW(24),
                  //           color: Color(0xffbf82ff),
                  //         ),
                  //         SizedBox(
                  //           width: size.getW(12),
                  //         ),
                  //         Text(
                  //           "Date Range",
                  //           style: TextStyle(
                  //               fontSize: size.getS(16),
                  //               color: Colors.black,
                  //               fontFamily: kFontFMedium),
                  //         ),
                  //       ],
                  //     ))
                  // ],
                  // ),
                  SizedBox(
                    height: size.getH(12),
                  ),
                  Text(
                    subTitle,
                    style: TextStyle(
                      fontSize: size.getS(16),
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(
                    height: size.getH(24),
                  ),
                  Row(
                    children: [
                      ...List.generate(
                        _salesList.length,
                        (index) => Expanded(
                          child: Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: size.getW(8)),
                            child: DashHeaderTile(
                              size: size,
                              backColor: colorList[index % colorList.length],
                              title: _salesList[index].title,
                              subTitle: _salesList[index].subTitle,
                              iconData: iconList[index % iconList.length],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: size.getH(24),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DashHeaderTile extends StatelessWidget {
  final Ssize size;
  final Color backColor;
  final String title;
  final String subTitle;
  final IconData iconData;
  const DashHeaderTile({
    super.key,
    required this.size,
    required this.backColor,
    required this.title,
    required this.subTitle,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backColor.withAlpha(200),
      shadowColor: Colors.transparent,
      elevation: 12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: size.getH(16), horizontal: size.getW(12)),
        child: SizedBox(
          width: size.getW(200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                  backgroundColor: backColor,
                  radius: size.getS(21),
                  child: Icon(
                    iconData,
                    color: Colors.white,
                    size: size.getS(25),
                  )),
              SizedBox(
                height: size.getH(12),
              ),
              Text(
                subTitle,
                style: TextStyle(
                  fontSize: size.getS(16),
                  fontFamily: kFontFMedium,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: size.getH(8),
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: size.getS(14),
                  fontFamily: kFontFRegular,
                  color: Colors.black,
                ),
                maxLines: 1,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _SalesModel {
  final String title;
  final String subTitle;
  _SalesModel({
    required this.title,
    required this.subTitle,
  });
}
