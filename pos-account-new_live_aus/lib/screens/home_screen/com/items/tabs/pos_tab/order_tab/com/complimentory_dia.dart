import 'package:flutter/material.dart';
import 'package:pos_account/config/utils/order_utils.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/menu/place_order/place_order_req.dart';
import 'package:pos_account/model/home/menu/place_order/po_pay_sec_list_res.dart';
import 'package:pos_account/providers/common/invoice_pro.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/menu/orders_pro.dart';
import 'package:pos_account/providers/menu/payment_pro.dart';
import 'package:pos_account/providers/menu/place_order_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/sidebar/order_section/com/order_detail_sec.dart';
import 'package:pos_account/services/printer/com/invoice_print.dart';
import 'package:pos_account/widgets/dialog/msg_dialog.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../config/size_config.dart';
import '../../../../../../../../constant/constant.dart';
import '../../../../../../../../providers/menu/order_tab/order_tab_pro.dart';

class ComplimentorySection extends StatefulWidget {
  final Ssize size;
  final String? curSym;
  final GlobalKey<ScaffoldState> scafKey;

  const ComplimentorySection({
    super.key,
    required this.size,
    this.curSym,
    required this.scafKey,
  });

  @override
  State<ComplimentorySection> createState() => _ComplimentorySectionState();
}

class _ComplimentorySectionState extends State<ComplimentorySection> {
  final ScrollController scrollController = ScrollController();

  late OrderTabPro? orderTabPro;

  late PaymentPro _payPro;
  late OrderPro _orderPro;

  @override
  void initState() {
    super.initState();
    orderTabPro = Provider.of<OrderTabPro>(context, listen: false);
    if ((orderTabPro?.selectedTabs?.isNotEmpty ?? false) &&
        (orderTabPro?.selectedTabs?.first.orderId?.isNotEmpty ?? false)) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _paySetData());
    }
  }

  Future<void> _paySetData() async {
    final _placePro = Provider.of<PlaceOrderPro>(context, listen: false);

    _payPro = Provider.of<PaymentPro>(context, listen: false);
    _payPro.isOnPaymentScreen = true;
    _payPro.orderId = orderTabPro?.selectedTabs?.first.orderId;
    _payPro.isCheckPubHoCharge = false;
    _payPro.isCheckCreCarCharge = false;
    _payPro.isCheckServiceCharge = false;
    _payPro.isDeliveryCheck = false;
    _payPro.isItemUpdated = false;

    _orderPro = Provider.of<OrderPro>(context, listen: false);
    _payPro.updateOrderLoad = true;
    _payPro.notify;

    await _orderPro.getOrderTransDetails(
        orderId: orderTabPro?.selectedTabs?.first.orderId ?? '');

    _payPro.orderDetailById = _orderPro.oDById;

    _payPro.taxExclusiveInclusiveType =
        GlobalCVP.storeInfo?.taxExclusiveInclusiveType;

    // final _paidDetail =
    //     _payPro.orderDetailById?.orderPaymentDetailsWithPaymentStatusViewModel;

    _payPro.paymentType = PaymentType.FullPayment;

    _payPro.setMenuList.clear();
    _payPro.orderList.clear();
    _payPro.ingreList.clear();

    ////////////////// set menu /////////////////////////////
    ///

    if (_orderPro.oDById?.setMenuWithPriceDetailsViewModel != null) {
      // if (_isIncompletePayOnItem) {
      for (final e in _orderPro.oDById!.setMenuWithPriceDetailsViewModel!) {
        final _initQty = (double.tryParse(e.quantity ?? '1') ?? 1);

        final _paidQuantity = (double.tryParse(e.paidQuantity ?? '0') ?? 0);

        final _currentPayingQuantity =
            (double.tryParse(e.currentPaidQuantity ?? '0') ?? 0);

        final _amount = OrderUtils.getAmount(
          taxTypeString: _orderPro
              .oDById?.orderDetailsViewModel?.taxExclusiveInclusiveType,
          taxPercent: e.taxExclusiveInclusiveValue,
          price: e.setMenuPrice,
          quantity:
              _currentPayingQuantity != 0 ? _currentPayingQuantity : _initQty,
        );

        double _qty = 0;

        if (_payPro.onPayScreenFor == OnPayScreenFor.Refund) {
          _qty = 0;
        } else if (_payPro.paymentType == PaymentType.SplitByItem) {
          if (_currentPayingQuantity != 0) {
            _qty = _currentPayingQuantity;
          } else if (_initQty - _paidQuantity > 0) {
            _qty = _initQty - _paidQuantity;
          } else {
            _qty = 0;
          }
        } else {
          _qty = _initQty;
        }

        final _statusEnum = OrderUtils.getStatusEnum(e.statusId);
        final _blocked = _statusEnum == OrderStatusEnum.hold ||
            _statusEnum == OrderStatusEnum.cancel;

        if (!_blocked) {
          _payPro.setMenuList.add(SetMenuOrderDetail(
            id: e.id,
            setMenuId: e.setMenuId,
            setMenuName: e.setMenuName,
            setMenuQuantity: _qty.toInt(),
            initQty: _initQty.toInt(),
            paidQuantity: _paidQuantity,
            // currentPayQty: ,
            setMenuPrice: _amount.itemPrice,
            originalSellingAmount: _amount.itemPrice.roundToNString(),
            totalSetMenuPrice: _amount.itemPrice * _qty,
            imgPath: e.image,
            description: e.description ?? '',
            taxType: _amount.taxType,
            taxPercent: _amount.taxPercent,
            totalTax: _amount.totalTax.roundToNString(),
            orderItemsViewModels: e.setMenuProductViewModel
                ?.map((f) => OrderItemsViewModel(
                      productVariationId: f.productVariationId,
                      productName: f.productName,
                      name: f.name,
                      productVariationName: f.productVariationName,
                      orderItemsPriceModifierViewModels:
                          f.orderItemModifiersViewModels,
                      // removedOrderItemsIngredientsViewModels:
                      //     f.removedOrderItemIngredientViewModels,
                      quantity: f.quantity,
                    ))
                .toList(),
            disabled: false,
            isSelected: _payPro.paymentType == PaymentType.SplitByItem
                ? _currentPayingQuantity != 0
                : true,
            isPubChargeEnable: e.isPublicHolidaySurchargeUsed,
            isCreditChargeEnable: e.isCreditCardSurchargeUsed,
          ));
        }
      }
    }

    ////////////////// order details /////////////////////////////
    ///

    if (_orderPro.oDById?.productWithPriceDetailsViewModel != null) {
      // if (_isIncompletePayOnItem) {
      for (int i = 0;
          i < _orderPro.oDById!.productWithPriceDetailsViewModel!.length;
          i++) {
        final e = _orderPro.oDById!.productWithPriceDetailsViewModel![i];

        final _initQty = (double.tryParse(e.quantity ?? '1') ?? 1);

        final _paidQuantity = (double.tryParse(e.paidQuantity ?? '0') ?? 0);

        final _currentPayingQuantity =
            (double.tryParse(e.currentPaidQuantity ?? '0') ?? 0);

        final _amount = OrderUtils.getAmount(
          taxTypeString: _orderPro
              .oDById?.orderDetailsViewModel?.taxExclusiveInclusiveType,
          taxPercent: e.taxPercentage,
          price: e.productPrice,
          quantity:
              _currentPayingQuantity != 0 ? _currentPayingQuantity : _initQty,
          isNoTax: e.isTaxExempt,
        );

        double _qty = 0;

        if (_payPro.onPayScreenFor == OnPayScreenFor.Refund) {
          _qty = 0;
        } else if (_payPro.paymentType == PaymentType.SplitByItem) {
          if (_currentPayingQuantity != 0) {
            _qty = _currentPayingQuantity;
          } else if (_initQty - _paidQuantity > 0) {
            _qty = _initQty - _paidQuantity;
          } else {
            _qty = 0;
          }
        } else {
          _qty = _initQty;
        }

        /// //

        final _statusEnum = OrderUtils.getStatusEnum(e.statusId);
        final _blocked = _statusEnum == OrderStatusEnum.hold ||
            _statusEnum == OrderStatusEnum.cancel;

        if (!_blocked) {
          final _isHalforCombo =
              OrderUtils.prodType(e.productType) == ProductType.Half ||
                  OrderUtils.prodType(e.productType) == ProductType.Combo;

          _payPro.orderList.add(OrderDetail(
            id: e.id,
            productId: e.productId,
            productVariationId: e.productVariationId,
            // categoryTypeId: e.categoryTypeId,
            productName: e.name,
            quantity: _qty,
            initQty: _initQty,
            paidQuantity: _paidQuantity,
            productPrice: _amount.itemPrice,
            originalSellingAmount: _amount.itemPrice.roundToNString(),
            total: _amount.itemPrice * _qty,
            imgPath: e.image,
            description: e.description ?? '',
            taxType: _amount.taxType,
            totalTax: _amount.totalTax.roundToNString(),
            taxPercent: _amount.taxPercent,
            orderItemModifiersViewModels: e.orderItemModifiersViewModels
                ?.map((e) => e..isHalforCombo = _isHalforCombo)
                .toList(),
            // orderItemSpiceChoiceViewModel: e.orderItemSpiceChoiceViewModel,
            // isHalfItem: Utils.isHalfnHalf(e.productType),
            // removedOrderItemsIngredientsViewModels:
            //     e.removedOrderItemIngredientViewModels,
            disabled: false,
            isSelected: _payPro.paymentType == PaymentType.SplitByItem
                ? _currentPayingQuantity != 0
                : true,
            batchId: e.batchId,
            batchNumber: e.batchNumber,
            orderItemsServiceEmployeeViewModels:
                e.orderItemsServiceEmployeeViewModels,
            productType: e.productType,
            productPriceType: e.productPriceType,
            isPubChargeEnable: e.isPublicHolidaySurchargeUsed,
            isCreditChargeEnable: e.isCreditCardSurchargeUsed,
          ));
        }
      }
    }

    ////////////////// raw ingredients /////////////////////////////
    ///
    if (_orderPro.oDById?.rawIngredientWithPriceDetailsViewModel != null) {
      // if (_isIncompletePayOnItem) {
      for (final e
          in _orderPro.oDById!.rawIngredientWithPriceDetailsViewModel!) {
        final _initQty = (double.tryParse(e.quantity ?? '0') ?? 0);

        final _paidQuantity = (double.tryParse(e.paidQuantity ?? '0') ?? 0);

        final _currentPayingQuantity =
            (double.tryParse(e.currentPaidQuantity ?? '0') ?? 0);

        final _amount = OrderUtils.getAmount(
          taxTypeString: _orderPro
              .oDById?.orderDetailsViewModel?.taxExclusiveInclusiveType,
          taxPercent: e.taxValue,
          price: e.originalSellingPricePerUnit,
          quantity:
              _currentPayingQuantity != 0 ? _currentPayingQuantity : _initQty,
        );

        double _qty = 0;

        if (_payPro.onPayScreenFor == OnPayScreenFor.Refund) {
          _qty = 0;
        } else if (_payPro.paymentType == PaymentType.SplitByItem) {
          if (_currentPayingQuantity != 0) {
            _qty = _currentPayingQuantity;
          } else if (_initQty - _paidQuantity > 0) {
            _qty = _initQty - _paidQuantity;
          } else {
            _qty = 0;
          }
        } else {
          _qty = _initQty;
        }

        final _statusEnum = OrderUtils.getStatusEnum(e.statusId);
        final _blocked = _statusEnum == OrderStatusEnum.hold ||
            _statusEnum == OrderStatusEnum.cancel;

        if (!_blocked) {
          _payPro.ingreList.add(RawIngredientOrderDetail(
            id: e.id,
            rawIngredientId: e.rawIngredientId,
            unitOfMeasurementId: e.unitOfMeasurementId,
            quantity: _qty,
            originalSellingPricePerUnit: _amount.itemPrice,
            totalSellingPrice: (_amount.itemPrice * _qty).roundToNString(),
            name: e.name,
            stockCount: double.tryParse(e.stockCount ?? ''),
            taxType: _amount.taxType,
            taxPercent: _amount.taxPercent,
            totalTax: _amount.totalTax.roundToNString(),
            paidQuantity: _paidQuantity,
            initQty: _initQty,
            disabled: false,
            isSelected: _payPro.paymentType == PaymentType.SplitByItem
                ? _currentPayingQuantity != 0
                : true,
            isPubChargeEnable: e.isPublicHolidaySurchargeUsed,
            isCreditChargeEnable: e.isCreditCardSurchargeUsed,
          ));
        }
      }
    }

    _payPro.commentCltr.text =
        _orderPro.oDById?.orderDetailsViewModel?.comments ?? '';

    _payPro.orderTypes = _placePro.initAddSec?.orderTypes;
    _payPro.orderTypeIndex = _placePro.orderTypeIndex;
    // _payPro.clear();

    _payPro.placeReqData = PrevPlaceReqData(
      description: _orderPro.oDById?.orderDetailsViewModel?.description,
      // channelPlatform: _orderPro.oDById?.orderDetailsViewModel?.orderChannel,
      isRetail: false,
      customerUserViewModel: _orderPro.oDById?.customerUserViewModel,
    );

    _payPro.placeReqData!.tableIdName =
        _orderPro.oDById!.orderDetailsViewModel!.tables;
    _payPro.placeReqData!.staffId =
        _orderPro.oDById!.orderDetailsViewModel!.staffId;

    // _payPro.discountPercentCltr.text = orderTabPro?.selectedPercent ?? '0.00';
// _payPro.onChangedPayAmount();
    _payPro.cusAddSec();

    if (_orderPro.oDById?.orderDetailsViewModel?.customerId?.isNotEmpty ??
        false) {
      // String _searchKey = "";

      // if (_orderPro.oDById?.customerUserViewModel?.email?.isNotEmpty ?? false) {
      //   _searchKey = _orderPro.oDById!.customerUserViewModel!.email!;
      // } else if (_orderPro
      //         .oDById?.customerUserViewModel?.phoneNumber?.isNotEmpty ??
      //     false) {
      //   _searchKey = _orderPro.oDById!.customerUserViewModel!.phoneNumber!;
      // }

      _payPro.searchCustomer("",
          cusId: _orderPro.oDById!.orderDetailsViewModel!.customerId);
    }

    _payPro.notify;

    // await _payPro.getData(doUpdate: true);
    await orderTabPro?.getAddSec();
    _payPro.getCurSym();
    _payPro.setData();

    _payPro.updateOrderLoad = false;
    _payPro.notify;
    _payPro.onChangedPayAmount();
  }

  Future<void> makePay({required PaymentPro payPro}) async {
    payPro.paySecListRes = PoPaySecListRes(
      discounts: orderTabPro?.compDisRes?.discounts,
      paymentMethods: null,
      isComplimentary: true,
    );

    final _status = await payPro.makePayment();

    if (_status ?? false) {
      if (payPro.makePaymentRes?.isPaymentCompleted ?? false) {
        final _invoicePro = Provider.of<InvoicePro>(CUS_CTX!, listen: false);
        _invoicePro.printInvoice = InvoicePrint.cIPrintInvoice(
          payPro
              .makePaymentRes!.printingInvoiceDetailsResponseViewModels!.first,
          curSym: payPro.curSym ?? '',
          url: payPro.makePaymentRes!.url,
        );

        _invoicePro.invoiceType = InvoiceType.Payment;

        Navigator.pop(context, true);

        Future.delayed(Duration(milliseconds: 300), () {
          MsgDia.show(CUS_CTX!,
              title: "Payment Completed",
              diaType: DiaType.success,
              desc: "Payment has been completed successfully",
              showCloseIcon: true,
              autoHideSecond: 2, onPop: () {
            GlobalCVP.setEndDValue = 2;
            widget.scafKey.currentState!.openEndDrawer();
            InvoicePrint.spdPosInvoice(CUS_CTX!,
                paymentRes: _payPro.makePaymentRes, isCashPayment: true);
          });
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    // orderTabPro?.selectedComp = null;
    orderTabPro?.selectedPercent = null;
    scrollController.dispose();
    _payPro.setMenuList.clear();
    _payPro.orderList.clear();
    _payPro.ingreList.clear();
    _payPro.clear();
    _payPro.isOnPaymentScreen = false;
    orderTabPro?.compDisRes = null;
    // discounts!.forEach((e) {
    //   e.isSelected = false;
    // });
    WidgetsBinding.instance.addPostFrameCallback((_) => _payPro.notify);
    _orderPro.orderId = null;
    _orderPro.oDById = null;
    _orderPro.isForRefund = false;
    // _orderPro.isRevokePayment = false;
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final tabPro = Provider.of<OrderTabPro>(context);
    final payPro = Provider.of<PaymentPro>(context);
    final _hasOrder = (tabPro.selectedTabs?.isNotEmpty ?? false) &&
        (tabPro.selectedTabs?.first.orderId?.isNotEmpty ?? false);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.size.getW(12)),
      child: Row(
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   'This will result in a ${widget.curSym ?? ""}0.00 total for all items on each tab',
                //   style: TextStyle(fontSize: widget.size.getS(16)),
                // ),
                SizedBox(height: widget.size.getH(8)),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: size.getW(12),
                  runSpacing: size.getH(10),
                  children: tabPro.percentList.map((percent) {
                    return InkWell(
                      onTap: () {
                        tabPro.onSelectPercent(percent: percent);
                        payPro.discountPercentCltr.text =
                            tabPro.selectedPercent ?? '';
                        payPro.onChangedPayAmount();
                      },
                      child: Container(
                        width: size.getW(60),
                        height: size.getH(50),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: tabPro.selectedPercent == percent
                                ? kSecondaryColor
                                : Colors.grey.shade200,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(
                            "$percent%",
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: size.getS(18),
                              fontFamily: kFontFMedium,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: widget.size.getH(16)),
                Text(
                  "Reason for comp",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: widget.size.getS(16)),
                ),
                SizedBox(height: widget.size.getH(16)),
                if (tabPro.compDisRes?.discounts != null)
                  Expanded(
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: Scrollbar(
                        thickness: 8,
                        // isAlwaysShown: true,
                        trackVisibility: true,
                        controller: scrollController,
                        radius: const Radius.circular(10),
                        child: ListView.separated(
                          controller: scrollController,
                          itemBuilder: (_, i) {
                            final comp = tabPro.compDisRes!.discounts![i];
                            final _isSelected = comp.isSelected ?? false;
                            return InkWell(
                              onTap: () {
                                tabPro.compDisRes!.discounts!.forEach((e) {
                                  e.isSelected = false;
                                });

                                comp.isSelected = true;

                                payPro.notify;
                                // tabPro.onSelectComp(
                                //   comp: comp,
                                //   value: tabPro.selectedComp == comp
                                //       ? false
                                //       : true,
                                // );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: size.getH(4),
                                    horizontal: size.getW(12)),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: _isSelected
                                        ? kSecondaryColor
                                        : Colors.transparent,
                                    width: 1,
                                  ),
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      comp.name ?? '',
                                      style: TextStyle(
                                        fontSize: size.getS(16),
                                        color: Colors.black,
                                        fontFamily: kFontFMedium,
                                      ),
                                    ),
                                    const Spacer(),
                                    //dot circle checkbox
                                    Checkbox(
                                      value: _isSelected,
                                      onChanged: (value) {
                                        tabPro.compDisRes!.discounts!
                                            .forEach((e) {
                                          e.isSelected = false;
                                        });

                                        comp.isSelected = true;

                                        payPro.notify;
                                        // tabPro.onSelectComp(
                                        //   comp: comp,
                                        //   value: value,
                                        // );
                                      },
                                      shape: CircleBorder(),
                                      activeColor: kSecondaryColor,
                                    ),
                                    SizedBox(width: size.getW(8)),
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (_, __) => Divider(height: 0),
                          itemCount: tabPro.compDisRes!.discounts!.length,
                        ),
                      ),
                    ),
                  ),
                // SizedBox(height: widget.size.getH(16)),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     LoadButton(
                //       btnText: "Done",
                //       onsave: () {
                //         // Handle done action
                //         Navigator.of(context).pop();
                //       },
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
          if (_hasOrder)
            Flexible(
                child: Column(
              children: [
                Expanded(
                    child: OrderDetailSec(payPro: payPro, isPrimary: false)),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.only(left: size.getW(12)),
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                payPro.loadingPay
                                    ? Colors.grey.shade400
                                    : Colors.amber.shade400),
                            padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(
                                    horizontal: size.getW(8),
                                    vertical: size.getH(12)))),
                        onPressed: payPro.loadingPay
                            ? null
                            : () {
                                makePay(payPro: payPro);
                              },
                        child: payPro.loadingPay
                            ? Loading()
                            : Text(
                                "Done",
                                style: TextStyle(
                                  fontSize: size.getS(16),
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                  ),
                )
              ],
            ))
        ],
      ),
    );
  }
}
