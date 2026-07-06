import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pos_account/config/responsive.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/menu/orders_pro.dart';
import 'package:pos_account/widgets/input/dropdown/drop_down.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../widgets/input/text_form/text_form_widget.dart';
import '../../../../widgets/refresh_btn.dart';
import 'com/new_order_dia.dart';
import 'com/order_header.dart';
import 'com/pending_order/pending_order.dart';

class OrdersSection extends StatefulWidget {
  final GlobalKey<ScaffoldState> scafKey;

  const OrdersSection({
    super.key,
    required this.scafKey,
  });

  @override
  State<OrdersSection> createState() => _OrdersSectionState();
}

class _OrdersSectionState extends State<OrdersSection> {
  OrderPro? _orderP;
  final refreshCltr = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
  }

  getData() async {
    _orderP = Provider.of<OrderPro>(context, listen: false);
    if (_orderP != null) {
      await _orderP!.getOrDeSec();
      _orderP!.getData();
    }
  }

  showNewOrderDia({required Ssize size}) {
    return showDialog(
        context: context,
        builder: (builder) => SimpleDialog(
              backgroundColor: kBackgroundColor,
              titlePadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.symmetric(horizontal: size.getW(24)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              children: [NewOrderDia()],
            ));
  }

  @override
  void dispose() {
    _orderP?.clear();
    refreshCltr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderP = Provider.of<OrderPro>(context);
    final size = Ssize(context);
    final double _c =
        (Platform.isIOS ? (Responsive.isMobile(context) ? 2.4 : 1.2) : 1) *
            (Responsive.isDesktop(context) ? -65 : -80);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.getW(12.0)),
      child: Processing(
          loading: orderP.loading,
          align: Alignment.topLeft,
          // Order UI update
          child: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (ctx, _) => [
              SliverAppBar(
                automaticallyImplyLeading: false,
                excludeHeaderSemantics: true,
                expandedHeight: SData<double>(data: [
                  size.getH(379 + _c),
                  size.getH(319 + _c),
                  size.getH(379 + _c),
                  size.getH(379 + _c),
                  size.getH(369 + _c),
                  size.getH(279 + _c),
                  size.getH(279 + _c),
                  size.getH(229 + _c),
                  size.getH(209 + _c),
                ]).get(context),

                //  Responsive.isMobile(context) ||
                //         Responsive.isMobileLarge(context)
                //     ? size.getH(300)
                //     : (size.isProt && Responsive.isTablet(context))
                //         ? size.getH(300)
                //         : Responsive.isTablet(context)
                //             ? size.getH(224)
                //             : (size.isProt && Responsive.isTabletLarge(context))
                //                 ? size.getH(260)
                //                 : Responsive.isTabletLarge(context)
                //                     ? size.getH(200)
                //                     : size.getH(190),
                backgroundColor: kBackgroundColor,
                shadowColor: Colors.transparent,
                floating: true,
                pinned: true,
                centerTitle: false,
                title: _titleRow(
                  size: size,
                  orderP: orderP,
                ),
                actions: [Container()],
                titleSpacing: 0,
                toolbarHeight: size.getH(80),
                flexibleSpace: FlexibleSpaceBar(
                  background: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: size.getH(65)),
                      Flexible(
                        child: OrderHeader(
                          orderPro: orderP,
                          onTapOrder: (int i) {
                            orderP.channelStatusIndex = i;
                            orderP.loading = true;
                            orderP.notify;
                            orderP.getData();
                          },
                        ),
                      ),
                      Divider(
                        color: Colors.black54,
                        thickness: 0.6,
                      ),
                    ],
                  ),
                ),
              )
            ],
            body: PendingOrder(
              scafKey: widget.scafKey,
              orderPro: orderP,
              refreshController: refreshCltr,
            ),
          )),
    );
  }

  Widget _titleRow({
    required Ssize size,
    required OrderPro orderP,
  }) {
    return Column(children: [
      if (orderP.orderDetailSecRes != null)
        Row(
          // runSpacing: 12,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // SizedBox(
            //   width: size.getW(210),
            //   child: TitleDropDown(
            //     title: GlobalCVP.isServiceStore
            //         ? LN.serviceChannel
            //         : LN.orderChannel,
            //     titleFontSize: 16,
            //     titleGap: 4,
            //     vPad: 14,
            //     hintText: LN.orderChannel,
            //     indexVal: orderPro.channelIndex,
            //     list: orderPro.orderDetailSecRes?.orderChannels == null
            //         ? []
            //         : orderPro.orderDetailSecRes!.orderChannels!
            //             .map((e) => e.name ?? '')
            //             .toList(),
            //     borderRadius: 5,
            //     borderColor: Colors.black26,
            //     fontWeight: FontWeight.bold,
            //     onChanged: (p0) {
            //       orderPro.channelIndex = p0;
            //       // orderPro.orderTypeIndex = 0;
            //       // orderPro.channelStatusIndex = 0;
            //       orderPro.loading = true;
            //       orderPro.notify;
            //       orderPro.getData();
            //     },
            //   ),
            // ),

            // SizedBox(
            //   width: size.getW(210),
            //   child: TitleDropDown(
            //     title: GlobalCVP.isServiceStore
            //         ? "Service Order Type"
            //         : LN.orderType,
            //     titleFontSize: 16,
            //     titleGap: 4, vPad: 14,
            //     hintText: GlobalCVP.isServiceStore
            //         ? "Service Order Type"
            //         : LN.orderType,
            //     indexVal: orderPro.orderTypeIndex,
            //     list: orderPro.orderDetailSecRes?.orderTypes == null
            //         ? []
            //         : orderPro.orderDetailSecRes!.orderTypes!
            //             .map((e) => e.name ?? '')
            //             .toList(),
            //     borderRadius: 5,
            //     fontWeight: FontWeight.bold,
            //     borderColor: Colors.black26,
            //     onChanged: (p0) {
            //       orderPro.orderTypeIndex = p0;
            //       orderPro.loading = true;
            //       orderPro.notify;
            //       orderPro.getData();
            //     },
            //     // hPad: 0,
            //   ),
            // ),
            // SizedBox(
            //   width: size.getW(12),
            // ),
            if (GlobalCVP.isHospitality) ...[
              SizedBox(
                width: size.getW(210),
                child: DropDownList(
                  // title: LN.table,
                  // titleFontSize: 16,
                  // titleGap: 4,
                  vPad: 12,

                  hint: LN.tableNumber,
                  indexValue: orderP.tableIndex,
                  list: orderP.orderDetailSecRes == null ||
                          orderP.orderDetailSecRes!.tables == null
                      ? []
                      : orderP.orderDetailSecRes!.tables!
                          .map((e) => e.name ?? '')
                          .toList(),
                  borderRadius: 5,
                  fontWeight: FontWeight.bold,
                  borderColor: Colors.black26,
                  onChange: (p0) {
                    orderP.tableIndex = p0;
                    orderP.loading = true;
                    orderP.notify;
                    orderP.getData();
                  },
                ),
              ),
              SizedBox(
                width: size.getW(12),
              ),
              // SizedBox(
              //   width: size.getW(210),
              //   child: TitleDropDown(
              //     title: GlobalCVP.isServiceStore
              //         ? LN.serviceStatus
              //         : LN.orderStatus,
              //     titleFontSize: 16,
              //     titleGap: 4,
              //     vPad: 14,
              //     hintText: LN.status,
              //     indexVal: orderPro.channelStatusIndex,
              //     list: orderPro.orderDetailSecRes?.orderStatus == null
              //         ? []
              //         : orderPro.orderDetailSecRes!.orderStatus!
              //             .map((e) => e.name ?? '')
              //             .toList(),
              //     borderRadius: 5,
              //     borderColor: Colors.black26,
              //     fontWeight: FontWeight.bold,
              //     onChanged: (p0) {
              //       if (p0 == null) return;

              //       onTapOrder!(p0);
              //     },
              //   ),
              // ),
              // SizedBox(
              //   width: size.getW(12),
              // ),
            ],
            SizedBox(
              width: size.getW(300),
              child: TextFormWidget(
                borderColor: Colors.black12,
                borderRadius: 10,
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey,
                  size: size.getS(24),
                ),
                vPad: 12,
                cltr: orderP.searchCltr,
                hintText: GlobalCVP.isServiceStore
                    ? LN.serviceNumber
                    : LN.orderNumber,
                onChanged: (p0) {
                  Utils.handleSearch(callback: () async {
                    orderP.loading = true;
                    orderP.notify;
                    await orderP.getData();
                  });
                },
              ),
            ),
            SizedBox(
              width: size.getW(12),
            ),
            if (GlobalCVP.viewWidget.viewOrdersRefreshButton)
              RefreshBtn(
                size: size,
                onTap: orderP.isRefresh
                    ? null
                    : () async {
                        orderP.loading = true;
                        orderP.isRefresh = true;
                        // orderP.orderList.clear();
                        // orderPro.channelIndex = 0;
                        orderP.orderTypeIndex = null;
                        orderP.tableIndex = 0;
                        orderP.searchCltr.clear();
                        orderP.channelStatusIndex = 0;
                        orderP.notify;
                        await orderP.getOrDeSec();
                        orderP.getData();
                      },
              ),
            SizedBox(width: size.getW(12)),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...[
                        if (!GlobalCVP.isRetailStore &&
                            GlobalCVP.viewWidget.viewTrackUberDeliveryButton &&
                            !GlobalCVP.isServiceStore)
                          _headerButton(
                            size,
                            iconData: Icons.delivery_dining_sharp,
                            title: LN.trackDelivery,
                            onTap: () {
                              if (GlobalCVP.getMainPage !=
                                  MainPage.DeliveryPage)
                                GlobalCVP.setMainPage = MainPage.DeliveryPage;
                            },
                            btnColor: Colors.green,
                          ),
                        SizedBox(width: size.getW(12))
                      ],
                      // ...[
                      //   if (!GlobalCVP.isRetailStore &&
                      //       !GlobalCVP.isServiceStore)
                      //     _headerButton(
                      //       size,
                      //       iconData: Icons.food_bank_outlined,
                      //       title: LN.goToKitchen,
                      //       onTap: () {
                      //         if (GlobalCVP.getMainPage != MainPage.KitchenPage)
                      //           GlobalCVP.setMainPage = MainPage.KitchenPage;
                      //       },
                      //       btnColor: Colors.amber.shade800,
                      //     ),
                      //   SizedBox(width: size.getW(12))
                      // ],
                      // if (GlobalCVP.viewWidget.viewNewOrdersButton &&
                      //     !GlobalCVP.isServiceStore)
                      //   _headerButton(size,
                      //       iconData: Icons.menu,
                      //       title: GlobalCVP.isServiceStore
                      //           ? LN.newServices
                      //           : LN.newOrders,
                      //       onTap: orderP.orderDetailSecRes == null
                      //           ? null
                      //           : () {
                      //               orderP.newOrderChannelIndex = 0;
                      //               showNewOrderDia(size: size);
                      //             })
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
    ]);
  }

  Widget _headerButton(
    Ssize size, {
    IconData? iconData,
    required String title,
    Function()? onTap,
    Color btnColor = Colors.red,
    Color textColor = Colors.white,
  }) {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(btnColor),
            padding: WidgetStateProperty.all(EdgeInsets.symmetric(
                horizontal: size.getW(16),
                vertical: size.getH(size.isDesktop ? 16 : 8)))),
        onPressed: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (iconData != null) ...[
              Icon(
                iconData,
                size: size.getS(25),
                color: textColor,
              ),
              SizedBox(
                width: size.getW(8),
              )
            ],
            Text(
              title,
              style: TextStyle(
                fontSize: size.getS(16),
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ));
  }
}
