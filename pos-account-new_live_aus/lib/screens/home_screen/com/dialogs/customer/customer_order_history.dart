import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/booking/all_customer.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/menu/cus_history_pro.dart';
import 'package:pos_account/providers/menu/orders_pro.dart';
import 'package:pos_account/providers/menu/place_order_pro.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/paginate_sec.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CusOrderHistorySection extends StatelessWidget {
  final String customerId;
  final CusData? cusData;

  CusOrderHistorySection({
    super.key,
    required this.customerId,
    this.cusData,
  });

  void pagination(int page, {required CusHistoryPro cusHisPro}) {
    cusHisPro.getOrderData(cusId: customerId, page: page);
  }

  late CusHistoryPro cusHisPro;

  Future<void> _orderView({
    required BuildContext context,
    String? orderId,
  }) async {
    if (orderId == null) return;

    cusHisPro.viewOrderLoading = true;
    cusHisPro.notify;

    final orderP = Provider.of<OrderPro>(context, listen: false);
    await orderP.viewOrder(context, orderId: orderId);

    cusHisPro.viewOrderLoading = false;
    cusHisPro.notify;
  }

  Future<void> _orderCopy({
    required BuildContext context,
    String? orderId,
  }) async {
    if (orderId == null) return;

    cusHisPro.copyOrderLoading = true;
    cusHisPro.notify;

    final orderPro = Provider.of<OrderPro>(context, listen: false);
    await orderPro.getOrderTransDetails(orderId: orderId);

// setData For order Copy
    final placeOrderPro = Provider.of<PlaceOrderPro>(context, listen: false);

    placeOrderPro.descCltr.text =
        orderPro.oDById?.orderDetailsViewModel?.description ?? '';
    placeOrderPro.noOfCustomer.text =
        orderPro.oDById?.orderDetailsViewModel?.noOfCustomerOnTable ?? '';

    if (placeOrderPro.initAddSec?.orderTypes == null) {
      await placeOrderPro.init();
    }

    if (placeOrderPro.initAddSec?.orderTypes != null &&
        orderPro.oDById?.orderDetailsViewModel?.orderType != null &&
        placeOrderPro.initAddSec!.orderTypes!.any((e) =>
            e.value == orderPro.oDById!.orderDetailsViewModel!.orderType)) {
      placeOrderPro.orderTypeIndex = placeOrderPro.initAddSec!.orderTypes!
          .indexWhere((e) =>
              e.value == orderPro.oDById!.orderDetailsViewModel?.orderType);
    }

    placeOrderPro.setMenuList.clear();
    placeOrderPro.orderList.clear();
    placeOrderPro.ingreList.clear();

    final orderData = orderPro.getOrderSetMenuFromOrder(isNewOrder: true);

    placeOrderPro.orderList.addAll(orderData.orderDetailList);
    placeOrderPro.setMenuList.addAll(orderData.setMenuList);
    placeOrderPro.ingreList.addAll(orderData.ingreList);
//////

    showToast(
      "Order copied to cart successfully",
      backgroundColor: Colors.green,
      textStyle: TextStyle(
          color: Colors.white, fontFamily: kFontFMedium, fontSize: 16),
    );

    cusHisPro.copyOrderLoading = false;
    cusHisPro.isOrderCopied = true;
    cusHisPro.notify;

    _continueBtn(context, cusData: cusData);
    //
  }

  late BuildContext _ctx;

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    _ctx = context;
    cusHisPro = Provider.of<CusHistoryPro>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              LN.orderHistory,
              style: TextStyle(
                fontSize: size.getS(20),
                color: Colors.black,
              ),
            ),
            if (cusHisPro.customerHistory?.totalSales != null)
              Text(
                "${LN.totalSales} : ${cusHisPro.curSym}${cusHisPro.customerHistory?.totalSales ?? ''}",
                style: TextStyle(
                  fontSize: size.getS(20),
                  color: Colors.black,
                ),
              ),
          ],
        ),
        SizedBox(
          height: size.getH(12),
        ),
        AnimatedSwitcher(
            duration: Duration(milliseconds: 400),
            child: cusHisPro.customerHistory != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        margin: EdgeInsets.zero,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Table(
                              border: TableBorder.all(
                                width: 0.7,
                                color: Colors.black54,
                              ),
                              children: [
                                TableRow(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 0.5,
                                          color: Colors.black54,
                                        ),
                                        color: Colors.grey[200]),
                                    children: [
                                      _tableContent(size,
                                          text: LN.date, isHeader: true),
                                      _tableContent(size,
                                          text: LN.number, isHeader: true),
                                      _tableContent(size,
                                          text: LN.channel, isHeader: true),
                                      _tableContent(size,
                                          text: LN.totalAmount, isHeader: true),
                                    ]),
                              ],
                            ),
                            Table(
                              border: TableBorder.all(
                                width: 0.7,
                                color: Colors.black54,
                              ),
                              children: [
                                if (cusHisPro.customerHistory?.customerOrders
                                        ?.data !=
                                    null)
                                  ...List.generate(
                                      cusHisPro.customerOrderList.length, (i) {
                                    final cusOrderData =
                                        cusHisPro.customerOrderList[i];
                                    final isSelected =
                                        cusHisPro.selectedOrderId ==
                                            cusOrderData.orderId;
                                    return TableRow(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 0.5,
                                            color: Colors.black54,
                                          ),
                                          color: isSelected
                                              ? kSecondaryColor
                                              : null,
                                        ),
                                        children: [
                                          TableRowInkWell(
                                              onTap: () => onTapContent(
                                                  cusOrderData.orderId),
                                              child: _tableContent(
                                                size,
                                                text: cusOrderData.orderDate,
                                                isSelected: isSelected,
                                              )),
                                          TableRowInkWell(
                                            onTap: () => onTapContent(
                                                cusOrderData.orderId),
                                            child: _tableContent(
                                              size,
                                              text: cusOrderData.orderNumber,
                                              isSelected: isSelected,
                                            ),
                                          ),
                                          TableRowInkWell(
                                            onTap: () => onTapContent(
                                                cusOrderData.orderId),
                                            child: _tableContent(
                                              size,
                                              text: cusOrderData.orderChannel,
                                              isSelected: isSelected,
                                            ),
                                          ),
                                          TableRowInkWell(
                                            onTap: () => onTapContent(
                                                cusOrderData.orderId),
                                            child: _tableContent(
                                              size,
                                              text:
                                                  "${cusHisPro.curSym ?? ''}${cusOrderData.totalAmount ?? 0.0}",
                                              isSelected: isSelected,
                                            ),
                                          ),
                                        ]);
                                  })
                              ],
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: AnimatedSwitcher(
                                duration: Duration(milliseconds: 400),
                                child: cusHisPro.selectedOrderId != null
                                    ? Wrap(
                                        children: [
                                          LoadButton(
                                              vPad: 8,
                                              hPad: 4,
                                              width: 132,
                                              btnText: LN.viewOrder,
                                              btnColor: kPrimaryColor,
                                              loading:
                                                  cusHisPro.viewOrderLoading,
                                              onsave: () => _orderView(
                                                  context: context,
                                                  orderId: cusHisPro
                                                      .selectedOrderId)),
                                          SizedBox(
                                            width: size.getW(12),
                                          ),
                                          LoadButton(
                                              vPad: 8,
                                              hPad: 4,
                                              width: 132,
                                              btnText: "Copy Order",
                                              btnColor: kTempColor,
                                              loading:
                                                  cusHisPro.copyOrderLoading,
                                              onsave: () => _orderCopy(
                                                  context: context,
                                                  orderId: cusHisPro
                                                      .selectedOrderId)),
                                        ],
                                      )
                                    : SizedBox.shrink()),
                          ),
                          // Spacer(),
                          PaginateButton(
                            total: cusHisPro.orderTotalPage,
                            pageSize: cusHisPro.orderPageSize,
                            pageIndex: cusHisPro.orderPageIndex,
                            next: () => pagination(cusHisPro.orderPageIndex + 1,
                                cusHisPro: cusHisPro),
                            prev: () => pagination(cusHisPro.orderPageIndex - 1,
                                cusHisPro: cusHisPro),
                          ),
                        ],
                      ),
                    ],
                  )
                : Center(
                    child: Text(
                      "* ${LN.selectCusOrderHistory} *",
                      style: TextStyle(
                        fontSize: size.getS(18),
                        color: Colors.black45,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  )),
      ],
    );
  }

  void onTapContent(String? orderId) {
    if (cusHisPro.selectedOrderId == orderId) {
      cusHisPro.selectedOrderId = null;
      cusHisPro.isOrderCopied = false;
      final placeOrderPro = Provider.of<PlaceOrderPro>(_ctx, listen: false);
      placeOrderPro.orderList.clear();
      placeOrderPro.setMenuList.clear();
    } else
      cusHisPro.selectedOrderId = orderId;
    cusHisPro.notify;
  }

  Widget _tableContent(
    Ssize size, {
    String? text,
    bool isHeader = false,
    bool isSelected = false,
  }) {
    return Padding(
      padding: isHeader
          ? EdgeInsets.symmetric(
              vertical: size.getH(12), horizontal: size.getW(8))
          : EdgeInsets.all(size.getW(8)),
      child: Text(
        text ?? '',
        style: TextStyle(
          fontSize: size.getS(16),
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: isHeader ? FontWeight.bold : null,
        ),
      ),
    );
  }

  static void _continueBtn(
    BuildContext context, {
    CusData? cusData,
    final PageController? pageCltr,
  }) async {
    final _placeOrder = Provider.of<PlaceOrderPro>(context, listen: false);
    if (cusData != null) {
      _placeOrder.setCustomerData(cusData);
    }

    if (_placeOrder.initAddSec!.orderTypes == null) {
      await _placeOrder.init();
    }

    if (_placeOrder.isDelivery) {
      _placeOrder.cusDeliveryData.clear();
      _placeOrder.getCusDeliveryAddress(id: cusData?.id, name: cusData?.name);
    }

    if (GlobalCVP.getMainPage != MainPage.HomePage) {
      await pageCltr?.animateToPage(0,
          duration: Duration(milliseconds: 350), curve: Curves.easeInOut);

      GlobalCVP.setMainPage = MainPage.HomePage;
    }

    Future.delayed(Duration(milliseconds: 200), () {
      GlobalCVP.setMainPage = MainPage.HomePage;
      GlobalCVP.setCurrentPage(
        GlobalCVP.tabs.indexWhere((element) => element.title == LN.pos),
      );
    });

    Navigator.pop(context);
  }

  static Widget newOrderButton(
    BuildContext context, {
    CusData? cusData,
    String buttonText = "Continue",
    final PageController? pageCltr,
    Alignment align = Alignment.bottomRight,
  }) {
    return Align(
      alignment: align,
      child: LoadButton(
        vPad: 8,
        hPad: 8,
        width: 180,
        btnText: buttonText,
        btnColor: kSecondaryColor,
        onsave: () async {
          _continueBtn(context, cusData: cusData, pageCltr: pageCltr);
        },
      ),
    );
  }
}
