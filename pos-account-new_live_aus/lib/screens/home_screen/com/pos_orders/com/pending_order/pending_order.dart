import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/order_utils.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/booking/all_customer.dart';
import 'package:pos_account/model/home/menu/orders/all_orders_res.dart';
import 'package:pos_account/model/home/menu/orders/order_detail_by_id.dart';
import 'package:pos_account/model/home/menu/place_order/order_tab/order_tab_req.dart';
import 'package:pos_account/model/home/setting/table_layout/layout_design_model.dart';
import 'package:pos_account/model/ui_model/amount_class.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/menu/orders_pro.dart';
import 'package:pos_account/providers/menu/place_order_pro.dart';
import 'package:pos_account/services/printer/com/send_to_kitchen_print.dart';
import 'package:pos_account/services/uber/delivery/view/delivery_order/delivery_order_dia.dart';
import 'package:pos_account/widgets/dialog/confirm_dialog.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'com/accept_order_dia.dart';
import 'com/pending_order_tile.dart';

class PendingOrder extends StatelessWidget {
  final GlobalKey<ScaffoldState>? scafKey;
  final OrderPro orderPro;
  final RefreshController? refreshController;
  const PendingOrder({
    super.key,
    required this.orderPro,
    this.scafKey,
    this.refreshController,
  });

  Future<void> acceptOrder(
    BuildContext ctx, {
    AllOrderData? allOrderData,
    bool refreshOrder = false,
  }) {
    final size = Ssize(ctx);
    return showDialog(
        context: ctx,
        builder: (builder) => SimpleDialog(
              // backgroundColor: kPrimaryColor,
              titlePadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.symmetric(
                  horizontal: size.getW(24), vertical: size.getH(24)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              children: [
                AcceptOrderDia(
                  allOrder: allOrderData,
                  orderPro: orderPro,
                  isRetail: GlobalCVP.isRetailStore,
                  onTapBtn: () {
                    orderPro.loading = true;
                    orderPro.notify;
                    Navigator.pop(ctx);

                    orderPro
                        .orderStatusUpdate(
                      orderId: allOrderData?.orderId ?? "",
                      orderStatusId:
                          _getOrderStatusId(OrderStatus.PaymentPending),
                      refreshSingleOrder: refreshOrder,
                    )
                        .then((val) {
                      if (val ?? false) {
                        if (!GlobalCVP.isRetailStore) {
                          orderPro
                              .orderSendToKitchen(
                                  orderId: allOrderData?.orderId,
                                  printAllItem: true)
                              .then((value) {
                            if (value != null) {
                              SendToKitchenPrint.stkPos(ctx, order: value,
                                  runSuccessFun: () async {
                                orderPro.confirmOrderStk(
                                    orderId: value.orderId);
                              });
                            }
                          });
                          // StkEventUtils.sendToKitchen(
                          //   orderId: allOrderData?.orderId,
                          //   stkPrinter: true,
                          //   stkDisplay: true,
                          // );
                        }
                      }
                      orderPro.getData();
                    });
                  },
                )
              ],
            ));
  }

  void cancelOrder(BuildContext ctx, {AllOrderData? allOrderData}) {
    showDialog(
        context: ctx,
        builder: (builder) => ConfirmDialog(
              title: LN.cancelOrder,
              subTitle: LN.aystcOrder,
              actionText: LN.yes,
              cancelText: LN.no,
              onDelete: () async {
                orderPro.loading = true;
                orderPro.notify;
                orderPro
                    .orderStatusUpdate(
                      orderId: allOrderData?.orderId ?? "",
                      orderStatusId: _getOrderStatusId(OrderStatus.Cancel),
                      refreshSingleOrder: false,
                    )
                    .then((_) => orderPro.getData(
                          page: orderPro.pageIndex,
                        ));
                return null;
              },
            ));
  }

  String _getOrderStatusId(OrderStatus orderStatus) {
    final value = OrderStatusModel.getString(orderStatus);
    if (orderPro.orderDetailSecRes?.orderStatus != null &&
        orderPro.orderDetailSecRes!.orderStatus!.any((e) => e.value == value)) {
      return orderPro.orderDetailSecRes!.orderStatus!
          .firstWhere((e) => e.value == value)
          .id!;
    } else
      return "";
  }

  static Future<void> payNow(
    BuildContext context, {
    required String orderId,
    required GlobalKey<ScaffoldState> scaffKey,
    bool isForRefund = false,
    // bool isRevokePay = false,
    PathOfOrder orderPath = PathOfOrder.ORDERPATH,
  }) async {
    final _orderPro = Provider.of<OrderPro>(context, listen: false);
    GlobalCVP.setOrPath = orderPath;
    GlobalCVP.setEndDValue = 1;
    _orderPro.isForRefund = isForRefund;
    // _orderPro.isRevokePayment = isRevokePay;
    _orderPro.orderId = orderId;
    // await orderPro.getOrderDetailById(orderId: orderId);
    // if (scaffKey != null)
    Future.delayed(Duration(milliseconds: 300), () {
      scaffKey.currentState!.openEndDrawer();
    });
  }

  static Future<void> updateOrder(
    BuildContext context, {
    String? orderId,
    bool? fromOrderTab,
    OrderTabReq? orderTabReq,
    OrderDetailById? oDById,
    bool updateOrderType = true,
  }) async {
    final _placeOrderPro = Provider.of<PlaceOrderPro>(context, listen: false);
    final _orderPro = Provider.of<OrderPro>(context, listen: false);

    if ((fromOrderTab ?? false) &&
        (_placeOrderPro.orderTabId?.isNotEmpty ?? false) &&
        _placeOrderPro.orderTabId?.toLowerCase() ==
            orderTabReq?.id?.toLowerCase()) {
      GlobalCVP.jumpToTabOnSetPage = false;
      _placeOrderPro.orderTabLoading = false;

      GlobalCVP.setMainPage = MainPage.HomePage;

      Future.delayed(Duration(milliseconds: 200), () {
        GlobalCVP.setMainPage = MainPage.HomePage;
        GlobalCVP.setCurrentPage(
          GlobalCVP.tabs.indexWhere((element) => element.title == LN.pos),
        );
        GlobalCVP.notify;
      });
      return;
    }

    _placeOrderPro.reOrder = null;
    _placeOrderPro.clear();
    if (fromOrderTab ?? false) {
      _placeOrderPro.orderTabId = orderTabReq?.id ?? '';
      _placeOrderPro.orderTabName = orderTabReq?.tabIdentification ?? '';
      _placeOrderPro.orderTabLimit = orderTabReq?.tabLimit;
    }

    // get order details and set data
    if (oDById != null) {
      _orderPro.oDById = oDById;
    } else {
      await _orderPro.getOrderTransDetails(orderId: orderId ?? "");
    }

    if (_placeOrderPro.initAddSec?.staffs != null &&
        _orderPro.oDById?.orderDetailsViewModel?.staffId != null &&
        _placeOrderPro.initAddSec!.staffs!.any((e) =>
            e.id?.toLowerCase() ==
            _orderPro.oDById!.orderDetailsViewModel!.staffId?.toLowerCase())) {
      _placeOrderPro.waiterIndex = _placeOrderPro.initAddSec!.staffs!
          .indexWhere((e) =>
              e.id?.toLowerCase() ==
              _orderPro.oDById!.orderDetailsViewModel?.staffId?.toLowerCase());
    }

    _orderPro.oDById?.orderDetailsViewModel?.tables?.forEach((a) => a
      ..orderId = _orderPro.oDById!.orderDetailsViewModel!.orderId
      ..floorTblStatus = FloorTblStatus.Occupied);

    _placeOrderPro.tableIdName =
        _orderPro.oDById?.orderDetailsViewModel?.tables;
    // _placeOrderPro.tableName =
    //     _orderPro.oDById?.orderDetailsViewModel?.tableNumber ?? '';
    _placeOrderPro.orderTabId = _orderPro.oDById?.orderTabViewModel?.id ?? '';
    _placeOrderPro.orderTabLimit =
        _orderPro.oDById?.orderTabViewModel?.tabLimit ?? '';
    _placeOrderPro.orderTabName =
        _orderPro.oDById?.orderTabViewModel?.tabIndentification ?? '';
    _placeOrderPro.descCltr.text =
        _orderPro.oDById?.orderDetailsViewModel?.description ?? '';
    _placeOrderPro.noOfCustomer.text =
        _orderPro.oDById?.orderDetailsViewModel?.noOfCustomerOnTable ?? '';

    // if (_placeOrderPro.initRes?.tables != null &&
    //     _placeOrderPro.initRes!.tables!.any((e) =>
    //         e.id?.toLowerCase() ==
    //         orderPro.oDById!.orderDetailsViewModel?.tableId?.toLowerCase())) {
    //   _placeOrderPro.tableIndex = _placeOrderPro.initRes!.tables!.indexWhere(
    //     (e) =>
    //         e.id?.toLowerCase() ==
    //         orderPro.oDById?.orderDetailsViewModel?.tableId?.toLowerCase(),
    //   );
    // }

    if (_placeOrderPro.initAddSec?.orderTypes == null) {
      await _placeOrderPro.init();
    }

    if (updateOrderType &&
        _placeOrderPro.initAddSec?.orderTypes != null &&
        _orderPro.oDById?.orderDetailsViewModel?.orderType != null &&
        _placeOrderPro.initAddSec!.orderTypes!.any((e) =>
            e.id?.toLowerCase() ==
            _orderPro.oDById!.orderDetailsViewModel!.orderTypeId
                ?.toLowerCase())) {
      _placeOrderPro.orderTypeIndex = _placeOrderPro.initAddSec!.orderTypes!
          .indexWhere((e) =>
              e.id?.toLowerCase() ==
              _orderPro.oDById!.orderDetailsViewModel?.orderTypeId
                  ?.toLowerCase());
    }

    _placeOrderPro.setMenuList.clear();
    _placeOrderPro.orderList.clear();
    _placeOrderPro.ingreList.clear();

    final orderData = _orderPro.getOrderSetMenuFromOrder();

    _placeOrderPro.orderList.addAll(orderData.orderDetailList);
    _placeOrderPro.setMenuList.addAll(orderData.setMenuList);
    _placeOrderPro.ingreList.addAll(orderData.ingreList);

    // _placeOrderPro.manageHalfOrder();

    String? _cancelOrderStatusId;

    if (_orderPro.orderDetailSecRes?.orderStatus == null) {
      await _orderPro.getOrDeSec();
    }

    if (_orderPro.orderDetailSecRes?.orderStatus?.any(
            (e) => e.value == OrderStatusModel.getString(OrderStatus.Cancel)) ??
        false) {
      _cancelOrderStatusId = _orderPro.orderDetailSecRes!.orderStatus!
          .firstWhere(
              (e) => e.value == OrderStatusModel.getString(OrderStatus.Cancel))
          .id;
    }

    _placeOrderPro.reOrder = ReOrder(
      orderId: orderId,
      orderNumber: _orderPro.oDById?.orderDetailsViewModel?.orderNumber,
      orderChannelEnum:
          _orderPro.oDById?.orderDetailsViewModel?.orderChannelEnum,
      cancelOrderStatusId: _cancelOrderStatusId,
      itemPaidChargeIfOrderUpdate: orderData.itemPaidChargeIfOrderUpdate,
      discountPer: orderData.discountPer,
      status: _orderPro.oDById?.orderDetailsViewModel?.kitchenStatus,
      paymentType: orderData.paymentType,
      paidDiscount: orderData.paidDiscount,
      tableIds: _orderPro.oDById?.orderDetailsViewModel?.tables
          ?.map((a) => a.id)
          .toList(),
    );

    /// customer info update
    // String _searchKey = "";

    // if (_orderPro.oDById?.customerUserViewModel?.email?.isNotEmpty ?? false) {
    //   _searchKey = _orderPro.oDById!.customerUserViewModel!.email!;
    // } else if (_orderPro
    //         .oDById?.customerUserViewModel?.phoneNumber?.isNotEmpty ??
    //     false) {
    //   _searchKey = _orderPro.oDById!.customerUserViewModel!.phoneNumber!;
    // }

    final orderDetail = _orderPro.oDById;

    if (orderDetail?.customerUserViewModel?.name?.isNotEmpty ?? false) {
      _placeOrderPro.setCustomerData(CusData(
        id: orderDetail?.customerUserViewModel?.id ?? '',
        name: orderDetail?.customerUserViewModel?.name,
        email: orderDetail?.customerUserViewModel?.email,
        phoneNumber: orderDetail?.customerUserViewModel?.phoneNumber,
      ));

      if (orderDetail?.orderDetailsViewModel?.orderType
              ?.toLowerCase()
              .contains('deliver') ??
          false) {
        _placeOrderPro.dateTimeCltr.text =
            orderDetail?.orderDetailsViewModel?.pickUpDeliveryDate ?? '';
        _placeOrderPro.deliNoteCltr.text =
            orderDetail?.orderDetailsViewModel?.pickUpDeliveryNote ?? '';

        String deliAmount = "";
        if (OrderUtils.getTaxType(
                GlobalCVP.storeInfo?.taxExclusiveInclusiveType) ==
            TaxType.Inclusive) {
          deliAmount = orderDetail
                  ?.orderPaymentDetailsWithPaymentStatusViewModel
                  ?.deliveryAmountWithTax ??
              '';
        } else {
          deliAmount = orderDetail
                  ?.orderPaymentDetailsWithPaymentStatusViewModel
                  ?.deliveryAmount ??
              '';
        }
        _placeOrderPro.cusDeliveryData.clear();
        _placeOrderPro
            .getCusDeliveryAddress(
                id: orderDetail?.customerUserViewModel?.id,
                name: orderDetail?.customerUserViewModel?.name)
            .then((_) {
          if (_placeOrderPro.cusDeliveryData.any((e) =>
              e.deliveryLocation?.toLowerCase() ==
              orderDetail?.orderDetailsViewModel?.deliveryAddress
                  ?.toLowerCase())) {
            _placeOrderPro.selectedCusDeliveryIndex =
                _placeOrderPro.cusDeliveryData.indexWhere((e) =>
                    e.deliveryLocation?.toLowerCase() ==
                    orderDetail?.orderDetailsViewModel?.deliveryAddress
                        ?.toLowerCase());
            final data = _placeOrderPro
                .cusDeliveryData[_placeOrderPro.selectedCusDeliveryIndex!];
            _placeOrderPro
                .getDeliveryAmount(
              id: data.id,
              userId: data.userId,
              lat: data.latitude,
              long: data.longitude,
              address: data.deliveryLocation,
            )
                .then((_) {
              if (deliAmount.isNotEmpty) {
                _placeOrderPro.delivertAmtCltr.text = deliAmount;
              }
            });
          }
        });
      }
    }

    _placeOrderPro.posDataPath = PosDataPath.Order;
    GlobalCVP.jumpToTabOnSetPage = false;
    _placeOrderPro.orderTabLoading = false;

    GlobalCVP.setMainPage = MainPage.HomePage;

    Future.delayed(Duration(milliseconds: 200), () {
      GlobalCVP.setMainPage = MainPage.HomePage;
      GlobalCVP.setCurrentPage(
        GlobalCVP.tabs.indexWhere((element) => element.title == LN.pos),
      );
      GlobalCVP.notify;
    });
  }

  void refundOrder(BuildContext ctx, {AllOrderData? allOrderData}) {
    showDialog(
        context: ctx,
        builder: (builder) => ConfirmDialog(
              title: LN.refundPay,
              subTitle: LN.sureToRefund,
              actionText: LN.yes,
              cancelText: LN.no,
              onDelete: () async {
                GlobalCVP.setOrPath = PathOfOrder.ORDERPATH;
                GlobalCVP.setEndDValue = 1;
                orderPro.isForRefund = true;
                orderPro.orderId = allOrderData?.orderId ?? '';
                // orderPro
                //     .getOrderDetailByIdForRefund(
                //         orderId: allOrderData?.orderId ?? '')
                //     .then((_) {
                if (scafKey != null)
                  Future.delayed(Duration(milliseconds: 300), () {
                    scafKey!.currentState!.openEndDrawer();
                  });
                // });

                // orderPro.loading = true;
                // orderPro.notify;
                // orderPro
                //     .orderStatusUpdate(
                //       orderId: allOrderData?.orderId ?? "",
                //       orderStatusId: _getOrderStatusId(OrderStatus.Refund),
                //       refreshSingleOrder: false,
                //     )
                //     .then((_) => orderPro.getData(
                //           page: orderPro.pageIndex,
                //         ));
                return null;
              },
            ));
  }

  Future<void> deliverOrder(BuildContext ctx,
      {AllOrderData? allOrderData}) async {
    if (allOrderData?.orderId == null) return;

    await orderPro.getOrderDeById(orderId: allOrderData?.orderId ?? '');

    if (orderPro.oDById == null) return;

    showDialog(
        context: ctx,
        builder: (builder) => DeliveryOrderDia(orderDetail: orderPro.oDById!)
        // ConfirmDialog(
        //       title: LN.orderDeli,
        //       subTitle: LN.sureToOrderDeli,
        //       actionText: LN.yes,
        //       cancelText: LN.no,
        //       onDelete: () async {
        //         orderPro.loading = true;
        //         orderPro.notify;
        //         orderPro
        //             .orderStatusUpdate(
        //               orderId: allOrderData?.orderId ?? "",
        //               orderStatusId: _getOrderStatusId(OrderStatus.Delivered),
        //               refreshSingleOrder: false,
        //             )
        //             .then((_) => orderPro.getData(
        //                   page: orderPro.pageIndex,
        //                 ));
        //         return null;
        //       },
        //     )
        );
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final allOrderList = orderPro.orderList;
    // if (orderPro.loading && allOrderList.isEmpty)
    //   return Container();
    // else
    if (refreshController != null && allOrderList.isNotEmpty)
      return SmartRefresher(
        controller: refreshController!,
        enablePullUp: true,
        onLoading: () {
          orderPro
              .getData(page: orderPro.pageIndex + 1)
              .then((value) => refreshController!.loadComplete());
        },
        onRefresh: () {
          orderPro
              .getData(page: 1)
              .then((value) => refreshController!.refreshCompleted());
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: size.getH(4),
              ),
              allOrderList.isEmpty
                  ? NoItemsSec(size: size, title: LN.noOrdersPlaced)
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisExtent:
                            size.getH(GlobalCVP.isRetailStore ? 350 : 384),
                        crossAxisCount: size.isProt ? 2 : 3,
                        mainAxisSpacing: size.getW(12),
                        crossAxisSpacing: size.getW(12),
                      ),
                      itemCount: allOrderList.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => PendingOrderTile(
                        scafKey: scafKey,
                        allOrder: allOrderList[index],
                        orderPro: orderPro,
                        onTapOrderBtn: orderPro.loading
                            ? null
                            : (OBAction p0) {
                                if (p0 == OBAction.View) {
                                  orderPro.viewOrder(
                                    context,
                                    orderId: allOrderList[index].orderId ?? "",
                                  );
                                } else if (p0 == OBAction.Accept) {
                                  acceptOrder(context,
                                      allOrderData: allOrderList[index]);
                                } else if (p0 == OBAction.Cancel) {
                                  // show dialog
                                  cancelOrder(context,
                                      allOrderData: allOrderList[index]);
                                } else if (p0 == OBAction.Pay) {
                                  // pay section
                                  if (scafKey != null)
                                    payNow(context,
                                        orderId:
                                            allOrderList[index].orderId ?? "",
                                        scaffKey: scafKey!);
                                } else if (p0 == OBAction.Update) {
                                  updateOrder(
                                    context,
                                    orderId: allOrderList[index].orderId,
                                  );
                                } else if (p0 == OBAction.Refund) {
                                  refundOrder(
                                    context,
                                    allOrderData: allOrderList[index],
                                  );
                                } else if (p0 == OBAction.Delivery) {
                                  deliverOrder(
                                    context,
                                    allOrderData: allOrderList[index],
                                  );
                                }
                                //  else if (p0 == OBAction.Revoke) {
                                //   if (scafKey != null)
                                //     payNow(
                                //       context,
                                //       orderId:
                                //           allOrderList[index].orderId ?? "",
                                //       scaffKey: scafKey!,
                                //       // isRevokePay: true,
                                //     );
                                // }
                              },
                      ),
                    ),
              // Wrap(
              //     spacing: size.getW(12),
              //     runSpacing: size.getW(12),
              //     children: [
              //       ...List.generate(
              //         allOrderList.length,
              //         (index) => PendingOrderTile(
              //           scafKey: scafKey,
              //           allOrder: allOrderList[index],
              //           orderPro: orderPro,
              //           onTapOrderBtn: orderPro.loading
              //               ? null
              //               : (OBAction p0) {
              //                   if (p0 == OBAction.View) {
              //                     orderPro.viewOrder(
              //                       context,
              //                       orderId:
              //                           allOrderList[index].orderId ?? "",
              //                     );
              //                   } else if (p0 == OBAction.Accept) {
              //                     acceptOrder(context,
              //                         allOrderData: allOrderList[index]);
              //                   } else if (p0 == OBAction.Cancel) {
              //                     // show dialog
              //                     cancelOrder(context,
              //                         allOrderData: allOrderList[index]);
              //                   } else if (p0 == OBAction.Pay) {
              //                     // pay section
              //                     if (scafKey != null)
              //                       payNow(context,
              //                           orderId:
              //                               allOrderList[index].orderId ??
              //                                   "",
              //                           scaffKey: scafKey!);
              //                   } else if (p0 == OBAction.Update) {
              //                     updateOrder(
              //                       context,
              //                       orderId: allOrderList[index].orderId,
              //                     );
              //                   } else if (p0 == OBAction.Refund) {
              //                     refundOrder(
              //                       context,
              //                       allOrderData: allOrderList[index],
              //                     );
              //                   } else if (p0 == OBAction.Delivery) {
              //                     deliverOrder(
              //                       context,
              //                       allOrderData: allOrderList[index],
              //                     );
              //                   } else if (p0 == OBAction.Revoke) {
              //                     if (scafKey != null)
              //                       payNow(
              //                         context,
              //                         orderId:
              //                             allOrderList[index].orderId ?? "",
              //                         scaffKey: scafKey!,
              //                         isRevokePay: true,
              //                       );
              //                   }
              //                 },
              //         ),
              //       )
              //     ],
              //   ),
              SizedBox(
                height: size.getH(24),
              ),
            ],
          ),
        ),
      );
    else if (orderPro.loading)
      return Container();
    else
      return Align(
        alignment: Alignment.topCenter,
        child: NoItemsSec(size: size, title: LN.noOrdersPlaced),
      );
  }
}
