import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/dashboard/dashboard_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/general/common/common_header.dart';
import 'package:pos_account/widgets/title_pop.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'com/charts/line_chart.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'com/charts/bar_chart.dart';
import 'com/charts/cus_pie_chart.dart';
import 'com/charts/item_list_chart.dart';
import 'com/charts/product_list_chart.dart';
import 'com/charts_section.dart';
import 'com/channel/dash_channel_sec.dart';
import 'com/employee_sales/employee_sales.dart';
import 'com/today_sale_wid.dart';
// import 'com/upgrade_plan.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late DashboardPro dashPro;
  final refreshCltr = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() {
    dashPro = Provider.of<DashboardPro>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      dashPro.getDashboard();
    });
  }

  @override
  void dispose() {
    super.dispose();
    refreshCltr.dispose();
    // dashPro.clear();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final _dashPro = Provider.of<DashboardPro>(context);
    return Column(
      children: [
        CommonHeader(
          child: TitlePop(
              title: "Reports",
              size: size,
              onTap: () {
                GlobalCVP.setMainPage = MainPage.ManagePage;
              }),
        ),
        SizedBox(
          height: size.getH(8),
        ),
        Flexible(
          child: Processing(
            loading: _dashPro.loading,
            align: Alignment.topLeft,
            child: SmartRefresher(
              controller: refreshCltr,
              physics: BouncingScrollPhysics(),
              onRefresh: () async {
                await _dashPro.getDashboard();
                refreshCltr.refreshCompleted();
              },
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: size.getW(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   LN.dashboard,
                    //   style: TextStyle(
                    //     fontSize: size.getS(18),
                    //     // fontFamily: ,
                    //     fontWeight: FontWeight.bold,
                    //     color: Colors.black,
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: size.getH(12),
                    // ),
                    if (GlobalCVP.viewWidget.viewDashBoardSalesSummarySection)
                      TodaySaleWidget(
                        size: size,
                        curSym: _dashPro.curSym,
                        salesData:
                            _dashPro.dashboardRes?.dashBoardStatisticsToday,
                        title: LN.todaySale,
                        // subTitle: LN.salesSummary,
                        subTitle: LN.todaySaleSum,
                        width: double.maxFinite,
                        height: 260,
                      ),
                    SizedBox(height: size.getH(12)),

                    Row(
                      children: [
                        if (GlobalCVP
                            .viewWidget.viewDashBoardSalesByCategorySection)
                          Expanded(
                            flex: 3,
                            child: ChartsSection(
                              size: size,
                              title: LN.salesCat,
                              chart: PieChartSample2(
                                size: size,
                                sales:
                                    _dashPro.dashboardRes?.salesByCategoryModel,
                              ),
                              // width: size.isProt ? 524 : 620,
                            ),
                          ),
                        if (GlobalCVP.viewWidget
                            .viewDashBoardSalesSummoryReportByMonthSection) ...[
                          SizedBox(width: size.getW(6)),
                          Expanded(
                            flex: 4,
                            child: ChartsSection(
                              size: size,
                              // width: size.isProt ? 844 : 864,
                              title: LN.salesReportByMon,
                              chart: BarChartSection(
                                size: size,
                                dashboardRes: _dashPro.dashboardRes,
                                aspectRatio: size.isProt ? 2.9 : 3.1,
                              ),
                            ),
                          )
                        ],
                      ],
                    ),
                    SizedBox(height: size.getH(12)),
                    Row(
                      children: [
                        Expanded(
                          flex: 7,
                          child: ChartsSection(
                            size: size,
                            title: LN.ourChannels,
                            chart: DashChannelSec(dashPro: _dashPro),
                            // width: 1136,
                            // height: 260,
                          ),
                        ),
                        if (GlobalCVP.viewWidget
                            .viewDashBoardRecommendedProductSection) ...[
                          SizedBox(width: size.getW(6)),
                          Expanded(
                            flex: 3,
                            child: ChartsSection(
                              size: size,
                              // width: size.isProt ? 410 : 350,
                              title: LN.payReport,
                              chart: ItemListChart(
                                size: size,
                                curSym: _dashPro.curSym,
                                payList:
                                    _dashPro.dashboardRes?.paymentMethodModel,
                              ),
                            ),
                          )
                        ],
                        // if (GlobalCVP.viewWidget.viewDashBoardInfoAds) ...[
                        //   SizedBox(width: size.getW(6)),
                        //   UpgradePlanWidget(
                        //     size: size,
                        //     height: 400,
                        //     width: 354,
                        //     imageList:
                        //         _dashPro.dashboardRes?.dashboardInfoModel,
                        //     upgrade: () {
                        //       GlobalCVP.pathOfSubsBills =
                        //           PathOfSubsBills.InApp;
                        //       GlobalCVP.setMainPage =
                        //           MainPage.SubscriptionPage;
                        //     },
                        //   )
                        // ],
                      ],
                    ),
                    if (GlobalCVP.isServiceStore) ...[
                      SizedBox(height: size.getH(12)),
                      ChartsSection(
                        size: size,
                        title: "Employee Today Sales",
                        chart: EmployeeSales(dashPro: _dashPro),
                        width: double.infinity,
                        // height: 200,
                      )
                    ],
                    // SizedBox(height: size.getH(24)),
                    // ChartsSection(
                    //   size: size,
                    //   title: LN.ourChannels,
                    //   chart: DashChannelSec(dashPro: _dashPro),
                    //   width: 1164,
                    //   height: 270,
                    // ),

                    SizedBox(height: size.getH(12)),
                    Row(
                      children: [
                        if (GlobalCVP
                            .viewWidget.viewDashBoardSalesByChannelSection)
                          Expanded(
                            flex: 49,
                            child: ChartsSection(
                              size: size,
                              // width: size.isProt ? 844 : 1000, // 728,
                              title: LN.salesByChannel,
                              chart: LineChartSample1(
                                size: size,
                                sales: _dashPro.dashboardRes?.salesChannelModel,
                              ),
                            ),
                          ),
                        if (GlobalCVP.viewWidget
                            .viewDashBoardPaymentReportByPaymentMethodSection) ...[
                          SizedBox(width: size.getW(6)),
                          if (GlobalCVP.viewWidget
                              .viewDashBoardRecommendedProductSection)
                            Expanded(
                              flex: 25,
                              child: ChartsSection(
                                size: size,
                                // width: size.isProt ? 410 : 484,
                                title: GlobalCVP.isServiceStore
                                    ? LN.recommendedServices
                                    : LN.recommProducts,
                                chart: ProductListChart(
                                  size: size,
                                  recomProduct: _dashPro
                                      .dashboardRes?.recommendedProductsModel,
                                ),
                              ),
                            ),
                        ],
                      ],
                    ),
                    SizedBox(
                      height: size.getH(24),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
