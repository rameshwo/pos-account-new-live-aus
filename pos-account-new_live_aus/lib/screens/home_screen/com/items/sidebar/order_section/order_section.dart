import 'package:flutter/material.dart';
import 'package:pos_account/config/dual_display/dual_display_config.dart';
import 'package:pos_account/config/utils/promo_utils.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/order_utils.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/menu/place_order/place_order_req.dart';
import 'package:pos_account/model/home/menu/place_order/po_make_pay_req.dart';
import 'package:pos_account/model/ui_model/amount_class.dart';
import 'package:pos_account/providers/booking/table_arrange_pro.dart';
import 'package:pos_account/providers/common/eftpro.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/menu/orders_pro.dart';
import 'package:pos_account/providers/menu/payment_pro.dart';
import 'package:pos_account/providers/menu/place_order_pro.dart';
import 'package:pos_account/widgets/dialog/msg_dialog.dart';
import 'package:provider/provider.dart';
import 'com/customer_info/customer_info.dart';
import 'com/order_detail_sec.dart';
import 'com/pay_method/payment_section.dart';

class OrderSection extends StatefulWidget {
  final Function(PaySummary?)? payNow;
  final PlaceOrderPro placeOrderPro;
  final PathOfOrder pathOfOrder;
  const OrderSection(
      {super.key,
      this.payNow,
      required this.placeOrderPro,
      required this.pathOfOrder});

  @override
  State<OrderSection> createState() => _OrderSectionState();
}

class _OrderSectionState extends State<OrderSection> {
  final _formKey = GlobalKey<FormState>();
  late PaymentPro _payPro;

  OrderPro? _orderPro;

  @override
  void initState() {
    super.initState();
    _payPro = Provider.of<PaymentPro>(context, listen: false);
    _orderPro = Provider.of<OrderPro>(context, listen: false);
    _taPro = Provider.of<TableArrangePro>(context, listen: false);
    _eftPro = Provider.of<EftPro>(mounted ? context : CUS_CTX!, listen: false);
    _setInitData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setData();
    });
  }

  _setInitData() {
    _payPro.isOnPaymentScreen = true;
    _payPro.isUpdatingOrder = false;
    if (widget.pathOfOrder == PathOfOrder.MENUPATH) {
      _payPro.orderId = widget.placeOrderPro.placeOrderInfo?.orderId;
      // if (mounted)
      //   Future.delayed(
      //       Duration(milliseconds: 300),
      //       () => SendToKitchenPrint.spdSendToKitchen(
      //             context,
      //             order: widget.placeOrderPro.placeOrderRes,
      //             showLoading: false,
      //           ));
    } else {
      _payPro.orderId = _orderPro?.orderId;

      if (_orderPro?.isForRefund ?? false) {
        _payPro.onPayScreenFor = OnPayScreenFor.Refund;
        _payPro.refundTextCltr.clear();
      } else {
        _payPro.onPayScreenFor = OnPayScreenFor.Payment;
      }
    }
    keyPadFocus();
  }

  void keyPadFocus() {
    _payPro.KeyPadfocusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _payPro.KeyPadfocusNode?.addListener(() {
        if (!(_payPro.KeyPadfocusNode?.hasFocus ?? false) &&
            _payPro.cusForLoyalityRes != null) {
          _payPro.showCusKeyPad = false;
          _payPro.notify;
        }
      });
    });
  }

  Future<void> setData() async {
    _payPro.isCheckPubHoCharge = false;
    _payPro.isCheckCreCarCharge = false;
    _payPro.isCheckServiceCharge = false;
    _payPro.isDeliveryCheck = false;
    _payPro.isItemUpdated = false;
    // _payPro.isRevokePayment = _orderPro?.isRevokePayment ?? false;
    _payPro.updateOrderLoad = true;
    _payPro.notify;

    await _payPro.getData();

    if (_payPro.onPayScreenFor == OnPayScreenFor.Refund) {
      await _orderPro?.getOrderDetailByIdForRefund(
          orderId: _payPro.orderId ?? "");
      // check if all the products are refunded or not
      _checkifAllRefunded();
    } else {
      await _orderPro?.getOrderTransDetails(orderId: _payPro.orderId ?? '');
    }

    await widget.placeOrderPro.getStoreChargeInfo();

    _payPro.updateOrderLoad = false;

    if (_orderPro?.oDById == null && mounted) {
      Navigator.pop(context);
      return;
    }
    _payPro.loading = true;

    _payPro.orderDetailById = _orderPro?.oDById;
    _payPro.taxExclusiveInclusiveType =
        GlobalCVP.storeInfo?.taxExclusiveInclusiveType;

    final paidDetail =
        _payPro.orderDetailById?.orderPaymentDetailsWithPaymentStatusViewModel;

    if (paidDetail?.orderPaymentsDetailsViewModels?.isNotEmpty ?? false) {
      _payPro.remainingAmount = double.tryParse(_orderPro
              ?.oDById
              ?.orderPaymentDetailsWithPaymentStatusViewModel
              ?.remainingAmount ??
          '0');
    }

    if (_orderPro?.oDById?.orderDetailsViewModel?.paymentType?.isNotEmpty ??
        false) {
      final _typeIndex = double.tryParse(
                  _orderPro?.oDById?.orderDetailsViewModel?.paymentType ?? '0')
              ?.floor() ??
          0;
      // if (_payPro.isRevokePayment) {
      //   _payPro.paymentType = PaymentType.FullPayment;
      // } else
      if (PaymentType.values.length > _typeIndex) {
        if (_typeIndex == 3) {
          _payPro.paymentType = PaymentType.PartialPayment;
          _payPro.isSplitPerPerson = true;
        } else {
          _payPro.paymentType = PaymentType.values[_typeIndex];
        }
      }
    }

    final giftRemainingPay = _orderPro?.oDById?.orderDetailsViewModel
            ?.remainingAmountOnGiftPay?.inDouble ??
        0;
    // print("_giftRemainingPay: $_giftRemainingPay");

    if (giftRemainingPay != 0) {
      _payPro.remainingOnGiftPay =
          _orderPro?.oDById?.orderDetailsViewModel?.remainingAmountOnGiftPay;
    }

    _payPro.setMenuList.clear();
    _payPro.orderList.clear();
    _payPro.ingreList.clear();

    ////////////////// set menu /////////////////////////////
    ///

    if (_orderPro?.oDById?.setMenuWithPriceDetailsViewModel != null) {
      // if (_isIncompletePayOnItem) {
      for (final e in _orderPro!.oDById!.setMenuWithPriceDetailsViewModel!) {
        final initQty = (double.tryParse(e.quantity ?? '1') ?? 1);

        final paidQuantity = (double.tryParse(e.paidQuantity ?? '0') ?? 0);

        final currentPayingQuantity =
            (double.tryParse(e.currentPaidQuantity ?? '0') ?? 0);

        final _amount = OrderUtils.getAmount(
          taxTypeString: _orderPro
              ?.oDById?.orderDetailsViewModel?.taxExclusiveInclusiveType,
          taxPercent: e.taxExclusiveInclusiveValue,
          price: e.setMenuPrice,
          quantity:
              currentPayingQuantity != 0 ? currentPayingQuantity : initQty,
        );

        double qty = 0;

        if (_payPro.onPayScreenFor == OnPayScreenFor.Refund) {
          qty = 0;
        } else if (_payPro.paymentType == PaymentType.SplitByItem) {
          if (currentPayingQuantity != 0) {
            qty = currentPayingQuantity;
          } else if (initQty - paidQuantity > 0) {
            qty = initQty - paidQuantity;
          } else {
            qty = 0;
          }
        } else {
          qty = initQty;
        }
        final _statusEnum = OrderUtils.getStatusEnum(e.statusId);
        final _blocked = _statusEnum == OrderStatusEnum.hold ||
            _statusEnum == OrderStatusEnum.cancel;

        if (!_blocked) {
          _payPro.setMenuList.add(SetMenuOrderDetail(
            id: e.id,
            setMenuId: e.setMenuId,
            setMenuName: e.setMenuName,
            setMenuQuantity: qty.toInt(),
            initQty: initQty.toInt(),
            paidQuantity: paidQuantity,
            // currentPayQty: ,
            setMenuPrice: _amount.itemPrice,
            originalSellingAmount: _amount.itemPrice.roundToNString(),
            totalSetMenuPrice: _amount.itemPrice * qty,
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
            disabled: _payPro.paymentType == PaymentType.SplitByItem
                ? giftRemainingPay != 0
                : false,
            isSelected: _payPro.paymentType == PaymentType.SplitByItem
                ? currentPayingQuantity != 0
                : true,
            isPubChargeEnable: e.isPublicHolidaySurchargeUsed,
            isCreditChargeEnable: e.isCreditCardSurchargeUsed,
            discountPercentage: e.discountPercentage,
            statusId: e.statusId,
            kitchenStatus: e.kitchenStatus,
          ));
        }
      }
    }

    ////////////////// order details /////////////////////////////
    ///

    if (_orderPro?.oDById?.productWithPriceDetailsViewModel != null) {
      // if (_isIncompletePayOnItem) {
      for (int i = 0;
          i < _orderPro!.oDById!.productWithPriceDetailsViewModel!.length;
          i++) {
        final e = _orderPro!.oDById!.productWithPriceDetailsViewModel![i];

        final _initQty = (double.tryParse(e.quantity ?? '1') ?? 1);

        final _paidQuantity = (double.tryParse(e.paidQuantity ?? '0') ?? 0);

        final currentPayingQuantity =
            (double.tryParse(e.currentPaidQuantity ?? '0') ?? 0);

        final _amount = OrderUtils.getAmount(
          taxTypeString: _orderPro
              ?.oDById?.orderDetailsViewModel?.taxExclusiveInclusiveType,
          taxPercent: e.taxPercentage,
          price: e.productPrice,
          quantity:
              currentPayingQuantity != 0 ? currentPayingQuantity : _initQty,
        );

        double _qty = 0;

        if (_payPro.onPayScreenFor == OnPayScreenFor.Refund) {
          _qty = 0;
        } else if (_payPro.paymentType == PaymentType.SplitByItem) {
          if (currentPayingQuantity != 0) {
            _qty = currentPayingQuantity;
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

          if (_payPro.paymentType == PaymentType.SplitByItem &&
              _initQty <= _paidQuantity) {
            _payPro.payOnZeroSplitByItem ??= true;
          } else {
            _payPro.payOnZeroSplitByItem = false;
          }
          // deal_sec
          final _productPriceType =
              OrderUtils.productPriceType(e.productPriceType);
          final _isDeal = _isHalforCombo &&
              _productPriceType == ProductPriceType.MakeYourOwn;

          if (e.orderItemModifiersViewModels != null && _isDeal)
            for (final a in e.orderItemModifiersViewModels!) {
              a.isHalforCombo = _isHalforCombo;
              if (a.modifierItemsModifierViewModels != null)
                for (final b in a.modifierItemsModifierViewModels!) {
                  // kPrint("b : ${b.modifierName}");
                  b.isHalforCombo = _isHalforCombo;
                  if ((b.labelName?.toLowerCase().contains('half') ?? false) ||
                      (b.labelName?.toLowerCase().contains('quarter') ??
                          false)) {
                    if (b.modifierItemsModifierViewModels != null)
                      for (final c in b.modifierItemsModifierViewModels!) {
                        // kPrint("c : ${c.modifierName}");
                        c.isDealModifier = true;
                      }
                  } else {
                    b.isDealModifier = true;
                  }
                }
            }

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
            disabled: _payPro.paymentType == PaymentType.SplitByItem
                ? giftRemainingPay != 0
                : false,
            isSelected: _payPro.paymentType == PaymentType.SplitByItem
                ? currentPayingQuantity != 0
                : true,
            batchId: e.batchId,
            batchNumber: e.batchNumber,
            orderItemsServiceEmployeeViewModels:
                e.orderItemsServiceEmployeeViewModels,
            productType: e.productType,
            productPriceType: e.productPriceType,
            isPubChargeEnable: e.isPublicHolidaySurchargeUsed,
            isCreditChargeEnable: e.isCreditCardSurchargeUsed,
            discountPercentage: e.discountPercentage,
            statusId: e.statusId,
            kitchenStatus: e.kitchenStatus,
            preparationType: e.preparationType,
          ));

          // print(
          //     " $_initQty <= $_paidQuantity $_statusEnum ${_payPro.payOnZeroSplitByItem}");
        }
      }
    }

    ////////////////// raw ingredients /////////////////////////////
    ///
    if (_orderPro?.oDById?.rawIngredientWithPriceDetailsViewModel != null) {
      // if (_isIncompletePayOnItem) {
      for (final e
          in _orderPro!.oDById!.rawIngredientWithPriceDetailsViewModel!) {
        final initQty = (double.tryParse(e.quantity ?? '0') ?? 0);

        final paidQuantity = (double.tryParse(e.paidQuantity ?? '0') ?? 0);

        final currentPayingQuantity =
            (double.tryParse(e.currentPaidQuantity ?? '0') ?? 0);

        final _amount = OrderUtils.getAmount(
          taxTypeString: _orderPro
              ?.oDById?.orderDetailsViewModel?.taxExclusiveInclusiveType,
          taxPercent: e.taxValue,
          price: e.originalSellingPricePerUnit,
          quantity:
              currentPayingQuantity != 0 ? currentPayingQuantity : initQty,
        );

        double qty = 0;

        if (_payPro.onPayScreenFor == OnPayScreenFor.Refund) {
          qty = 0;
        } else if (_payPro.paymentType == PaymentType.SplitByItem) {
          if (currentPayingQuantity != 0) {
            qty = currentPayingQuantity;
          } else if (initQty - paidQuantity > 0) {
            qty = initQty - paidQuantity;
          } else {
            qty = 0;
          }
        } else {
          qty = initQty;
        }

        final _statusEnum = OrderUtils.getStatusEnum(e.statusId);
        final _blocked = _statusEnum == OrderStatusEnum.hold ||
            _statusEnum == OrderStatusEnum.cancel;
        if (!_blocked) {
          _payPro.ingreList.add(RawIngredientOrderDetail(
            id: e.id,
            rawIngredientId: e.rawIngredientId,
            unitOfMeasurementId: e.unitOfMeasurementId,
            quantity: qty,
            originalSellingPricePerUnit: _amount.itemPrice,
            totalSellingPrice: (_amount.itemPrice * qty).roundToNString(),
            name: e.name,
            stockCount: double.tryParse(e.stockCount ?? ''),
            taxType: _amount.taxType,
            taxPercent: _amount.taxPercent,
            totalTax: _amount.totalTax.roundToNString(),
            paidQuantity: paidQuantity,
            initQty: initQty,
            disabled: _payPro.paymentType == PaymentType.SplitByItem
                ? giftRemainingPay != 0
                : false,
            isSelected: _payPro.paymentType == PaymentType.SplitByItem
                ? currentPayingQuantity != 0
                : true,
            isPubChargeEnable: e.isPublicHolidaySurchargeUsed,
            isCreditChargeEnable: e.isCreditCardSurchargeUsed,
            discountPercentage: e.discountPercentage,
            statusId: e.statusId,
          ));
        }
      }
    }
    if (GlobalCVP.storeInfo?.holidaySurcharge?.isActive ?? false) {
      _payPro.holidaySurCharge = double.tryParse(
          GlobalCVP.storeInfo?.holidaySurcharge?.holidaySurgePercentage ??
              '0.0');

      _payPro.isCheckPubHoCharge = GlobalCVP
              .storeInfo?.holidaySurcharge?.autoEnableHoliaySurgePercentage ??
          false;
    }
    if (GlobalCVP.storeInfo?.creditCardSurCharge?.isActive ?? false) {
      _payPro.creCardCltr.text =
          GlobalCVP.storeInfo?.creditCardSurCharge?.creditCardSurgePercentage ??
              '';

      _payPro.isCheckCreCarCharge = GlobalCVP.storeInfo?.creditCardSurCharge
              ?.autoEnableCreditCardSurgePercentage ??
          false;
    }

    if (_payPro.isDineIn &&
        (GlobalCVP.storeInfo?.serviceCharge?.isActive ?? false)) {
      _payPro.serviceChargePerCltr.text =
          GlobalCVP.storeInfo?.serviceCharge?.serviceChargePercentage ?? '';

      _payPro.isCheckServiceCharge = GlobalCVP
              .storeInfo?.serviceCharge?.autoEnableServiceChargePercentage ??
          false;
    }

    final customCCSurPercent = _orderPro
            ?.oDById
            ?.orderPaymentDetailsWithPaymentStatusViewModel
            ?.creditCardSurchargePercentage
            ?.inDouble ??
        0;
    if (customCCSurPercent != 0) {
      _payPro.creCardCltr.text = customCCSurPercent.toString();
    }

    final customServiceChargePercent = _orderPro
            ?.oDById
            ?.orderPaymentDetailsWithPaymentStatusViewModel
            ?.serviceChargePercentage
            ?.inDouble ??
        0;

    if (customServiceChargePercent != 0) {
      _payPro.serviceChargePerCltr.text = customServiceChargePercent.toString();
    }

    _payPro.splitPerPersonCltr.text =
        _orderPro?.oDById?.orderDetailsViewModel?.noOfCustomerOnTable ?? '1';

    _payPro.commentCltr.text =
        _orderPro?.oDById?.orderDetailsViewModel?.comments ?? '';

    if (widget.pathOfOrder == PathOfOrder.MENUPATH) {
      _payPro.orderTypes = widget.placeOrderPro.initAddSec?.orderTypes;
      _payPro.orderTypeIndex = widget.placeOrderPro.orderTypeIndex;

      // widget.placeOrderPro.clearSelectedSetMenu();
      widget.placeOrderPro.clear();
      widget.placeOrderPro.notify;
    } else {
      _payPro.orderTypes = widget.placeOrderPro.initAddSec?.orderTypes;
      // if (_orderPro?.oDById?.orderDetailsViewModel != null &&
      //     _orderPro?.orderDetailSecRes?.orderChannels != null) {
      //   _payPro.orderTypes = _orderPro!.orderDetailSecRes!.orderChannels
      //       ?.map((e) => OrderTypeRes(
      //             id: e.id,
      //             value: e.value,
      //             name: e.name,
      //             additionalValue: e.additionalValue,
      //             isSelected: e.isSelected,
      //           ))
      //       .toList();
      // }

      if (_payPro.orderTypes != null &&
          _payPro.orderTypes!.any((e) =>
              e.value == _orderPro?.oDById?.orderDetailsViewModel?.orderType)) {
        _payPro.orderTypeIndex = _payPro.orderTypes!.indexWhere((e) =>
            e.value == _orderPro?.oDById?.orderDetailsViewModel?.orderType);
      }
    }

    // final _hSurCharge =
    //     double.tryParse(_paidDetail?.holidaySurgeAmountWithTax ?? '');

    // final _creCharge =
    //     double.tryParse(_paidDetail?.creditCardSurgeAmount ?? '');

    // if (_payPro.remainingAmount != null && _payPro.remainingAmount != 0) {
    //   if (_hSurCharge != null && _hSurCharge != 0) {
    //     _payPro.isCheckPubHoCharge = true;
    //   } else {
    //     _payPro.isCheckPubHoCharge = false;
    //   }

    //   if (_creCharge != null && _creCharge != 0) {
    //     _payPro.isCheckCreCarCharge = true;
    //   } else {
    //     _payPro.isCheckCreCarCharge = false;
    //   }
    // }

    if (_payPro.onPayScreenFor == OnPayScreenFor.Payment) {
      _payPro.isDeliveryCheck = true;
    } else {
      _payPro.refundDeliveryDisable = false;

      final isDeliveryEnable =
          _orderPro?.oDById?.orderDetailsViewModel?.isDeliveryEnable ?? false;

      if ((_orderPro?.oDById?.productWithPriceDetailsViewModel?.any((e) =>
                  e.total.inDouble >
                  e.quantity.inDouble * e.productPrice.inDouble) ??
              false) ||
          (_orderPro?.oDById?.setMenuWithPriceDetailsViewModel?.any((e) =>
                  e.total.inDouble >
                  e.quantity.inDouble * e.setMenuPrice.inDouble) ??
              false) ||
          (_orderPro?.oDById?.rawIngredientWithPriceDetailsViewModel?.any((e) =>
                  e.totalSellingPrice.inDouble >
                  e.quantity.inDouble *
                      e.originalSellingPricePerUnit.inDouble) ??
              false)) {
        if (!isDeliveryEnable) {
          _payPro.refundDeliveryDisable = true;
        }
      }
    }

    await _setPlaceOrReqFromOrder();

    _setDiscountAmount();
    _autoFillCustomer();

    if (_payPro.paymentType == PaymentType.PartialPayment)
      _payPro.isSplitPayFinal = true;
    else
      _payPro.isSplitPayFinal = false;

    _payPro.notify;

    await _payPro.setData(
        doUpdate: true,
        totalAmount: double.tryParse(
                _payPro.orderDetailById?.orderDetailsViewModel?.totalAmount ??
                    '') ??
            0);
    _checkAndSetEftPendingCase();
    _payPro.onChangedPayAmount();
    _payPro.onChangedPayAmount();
  }

  Future<void> _setPlaceOrReqFromOrder() async {
    // final _store =
    //     (GlobalCVP.loginRes?.storeDetailsLoginResponseViewModels != null &&
    //             GlobalCVP.loginRes!.storeDetailsLoginResponseViewModels!
    //                 .any((e) => e.isActive != null && e.isActive!))
    //         ? GlobalCVP.loginRes?.storeDetailsLoginResponseViewModels
    //             ?.firstWhere((e) => e.isActive != null && e.isActive!)
    //         : null;

    _payPro.placeReqData = PrevPlaceReqData(
      description: _orderPro?.oDById?.orderDetailsViewModel?.description,
      // channelPlatform: _orderPro?.oDById?.orderDetailsViewModel?.orderChannel,
      isRetail: GlobalCVP.isRetailStore,
      customerUserViewModel: _orderPro?.oDById?.customerUserViewModel,
    );

    if (_orderPro?.orderDetailSecRes == null) {
      await _orderPro?.getOrDeSec();
    }

    if (_orderPro?.orderDetailSecRes?.orderStatus != null &&
        _orderPro!.orderDetailSecRes!.orderStatus!.any(
            (e) => e.value == OrderStatusModel.getString(OrderStatus.Cancel))) {
      _payPro.placeReqData!.cancelStatusId = _orderPro
          ?.orderDetailSecRes!.orderStatus!
          .firstWhere(
              (e) => e.value == OrderStatusModel.getString(OrderStatus.Cancel))
          .id;
    }

    if (_orderPro?.oDById?.orderDetailsViewModel != null) {
      // _payPro.placeReqData!.tableId =
      //     _orderPro!.oDById!.orderDetailsViewModel!.tableId;
      _payPro.placeReqData!.tableIdName =
          _orderPro!.oDById!.orderDetailsViewModel!.tables;
      _payPro.placeReqData!.staffId =
          _orderPro!.oDById!.orderDetailsViewModel!.staffId;
    }
  }

  void _autoFillCustomer() {
    if (_orderPro?.oDById?.orderDetailsViewModel?.customerId?.isNotEmpty ??
        false) {
      // String _searchKey = "";

      // if (_orderPro?.oDById?.customerUserViewModel?.email?.isNotEmpty ??
      //     false) {
      //   _searchKey = _orderPro!.oDById!.customerUserViewModel!.email!;
      // } else if (_orderPro
      //         ?.oDById?.customerUserViewModel?.phoneNumber?.isNotEmpty ??
      //     false) {
      //   _searchKey = _orderPro!.oDById!.customerUserViewModel!.phoneNumber!;
      // }

      _payPro.searchCustomer("",
          cusId: _orderPro?.oDById?.orderDetailsViewModel?.customerId);
    }
    if (widget.pathOfOrder == PathOfOrder.ORDERPATH ||
        widget.pathOfOrder == PathOfOrder.FLOORPATH ||
        widget.placeOrderPro.reOrder?.orderId != null) {
      widget.placeOrderPro.reOrder = null;
    }
  }

  void _setDiscountAmount() {
    if (_orderPro?.oDById?.orderPaymentDetailsWithPaymentStatusViewModel ==
        null) return;

    final oDById = _orderPro!.oDById!;

    if (_payPro.isOrderTypeDelivery) {
      final _taxType =
          OrderUtils.getTaxType(GlobalCVP.storeInfo?.taxExclusiveInclusiveType);

      if (_taxType == TaxType.Inclusive) {
        _payPro.deliveryTextCltr.text = _orderPro
                ?.oDById
                ?.orderPaymentDetailsWithPaymentStatusViewModel
                ?.deliveryAmountWithTax ??
            '';
      } else {
        _payPro.deliveryTextCltr.text = _orderPro
                ?.oDById
                ?.orderPaymentDetailsWithPaymentStatusViewModel
                ?.deliveryAmount ??
            '';
      }

      if ((double.tryParse(_payPro.deliveryTextCltr.text) ?? 0) == 0) {
        _payPro.deliveryTextCltr.clear();
      }
    }
    ////
    ///
    OrderDiscountModel? _generalDiscount;
    OrderDiscountModel? _voucherDiscount;
    // OrderDiscountModel? _promoDiscount;

    if (oDById.orderDiscounts != null) {
      for (final a in oDById.orderDiscounts!) {
        if (a.discountType?.toLowerCase() ==
            DiscountType.General.name.toLowerCase()) {
          _generalDiscount = a;
        } else if (a.discountType?.toLowerCase() ==
            DiscountType.Voucher.name.toLowerCase()) {
          _voucherDiscount = a;
        }
        // else if (a.discountType?.toLowerCase() ==
        //     DiscountType.Promotion.name.toLowerCase()) {
        //   _promoDiscount = a;
        // }
      }
    }

    _payPro.discountPercentCltr.text =
        _generalDiscount?.discountPercentage ?? '';

    if (_generalDiscount != null && _payPro.paySecListRes?.discounts != null)
      for (final b in _payPro.paySecListRes!.discounts!) {
        if ((_generalDiscount.discountTypeId != null &&
                b.id?.toLowerCase() ==
                    _generalDiscount.discountTypeId?.toLowerCase()) ||
            (b.name?.toLowerCase() == _generalDiscount.name?.toLowerCase())) {
          b.isSelected = true;
        } else {
          b.isSelected = false;
        }
      }

    if (_voucherDiscount != null) {
      _payPro.voucherDiscountPercent = _voucherDiscount.discountPercentage;
    }

    if ((double.tryParse(_payPro.discountPercentCltr.text) ?? 0) == 0) {
      _payPro.discountPercentCltr.clear();
    }

    _payPro.onChangedPayAmount();
    _payPro.cusAddSec();
  }

  late TableArrangePro _taPro;

  Future<void> _tableStatusUpdate() async {
    if (GlobalCVP.getOrPath == PathOfOrder.FLOORPATH) {
      // await _orderPro?.makeTableStatusFree(
      //   tableId: _orderPro?.oDById?.orderDetailsViewModel?.tableId,
      //   tableName: _orderPro?.oDById?.orderDetailsViewModel?.tableNumber,
      // );
      if (_taPro.layoutDesign != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _taPro.getTableStatus(
              serverLoad: true,
              doPageLoad: false,
              id: _taPro.addSecRes!
                      .tableLocationsWithTables![_taPro.selectedForEdit].id ??
                  '');
        });
      }
    }
    // else if (widget.pathOfOrder == PathOfOrder.ORDERPATH) {
    _orderPro?.getData();
    // }
  }

  void _checkifAllRefunded() {
    final isAllRefunded =
        (_orderPro?.oDById?.productWithPriceDetailsViewModel == null ||
                _orderPro!.oDById!.productWithPriceDetailsViewModel!.isEmpty ||
                _orderPro!.oDById!.productWithPriceDetailsViewModel!.every(
                    (e) => (double.tryParse(e.quantity ?? '') ?? 0) <= 0)) &&
            (_orderPro
                        ?.oDById?.setMenuWithPriceDetailsViewModel ==
                    null ||
                _orderPro!.oDById!.setMenuWithPriceDetailsViewModel!.isEmpty ||
                _orderPro!.oDById!.setMenuWithPriceDetailsViewModel!
                    .every(
                        (e) =>
                            (double.tryParse(e.quantity ?? '') ?? 0) <= 0)) &&
            (_orderPro
                        ?.oDById?.rawIngredientWithPriceDetailsViewModel ==
                    null ||
                _orderPro!
                    .oDById!.rawIngredientWithPriceDetailsViewModel!.isEmpty ||
                _orderPro!.oDById!.rawIngredientWithPriceDetailsViewModel!
                    .every(
                        (e) => (double.tryParse(e.quantity ?? '') ?? 0) <= 0));

    // print('object : $_isAllRefunded');

    if (isAllRefunded && mounted) {
      MsgDia.show(context,
          headerAnimation: false,
          diaType: DiaType.info,
          title: LN.allItemRefund,
          autoHideSecond: 2, onPop: () {
        Navigator.pop(context);
      });
    }
  }

  late EftPro _eftPro;

  void _checkAndSetEftPendingCase() {
    _eftPro.isOnPayScreen = true;
    _eftPro.removePayReqData('_checkAndSetEftPendingCase');
    _eftPro.removeRefundReqData();
  }

  @override
  void dispose() {
    _eftPro.isOnPayScreen = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _payPro.setMenuList.clear();
      _payPro.orderList.clear();
      _payPro.ingreList.clear();
      _payPro.clear();
      _payPro.isOnPaymentScreen = false;
      _payPro.holidaySurCharge = null;
      _payPro.isCheckPubHoCharge = false;
      _payPro.serviceChargePerCltr.clear();
      _payPro.isCheckServiceCharge = false;
      _payPro.creCardCltr.clear();
      _payPro.isCheckCreCarCharge = false;

      _payPro.notify;
      if (!_payPro.isUpdatingOrder) {
        widget.placeOrderPro.reOrder = null;
        widget.placeOrderPro.clear();
      }
      _orderPro?.orderId = null;
      _orderPro?.oDById = null;
      _orderPro?.isForRefund = false;
      PromoUtils.promoOnTotalOrder = null;
      // _orderPro?.isRevokePayment = false;

      widget.placeOrderPro.notify;
    });

    // widget.placeOrderPro.clearSelectedSetMenu();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final payPro = Provider.of<PaymentPro>(context);
    if (DualDisplayConfig.adsPattern?.pattern != null &&
        DualDisplayConfig.adsPattern?.pattern != DualDisPattern.none) {
      DualDisplayConfig.sendData(isPayScreen: true);
    }
    return Form(
      key: _formKey,
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 4,
        color: Colors.white,
        shadowColor: Colors.grey[200],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: size.getH(4.0)),
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: CustomerInfoSec(),
              ),
              VerticalDivider(color: Colors.black38, thickness: 0.5),
              Expanded(
                  flex: 6,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: size.getH(2.0)),
                    child: OrderDetailSec(
                        payPro: payPro,
                        refresh: _payPro.updateOrderLoad
                            ? null
                            : () {
                                _setInitData();
                                setData();
                              }),
                  )),
              VerticalDivider(color: Colors.black38, thickness: 0.5),
              Expanded(
                  flex: 6,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: size.getH(2.0)),
                    child: PaymentSection(
                      eftReturnValue: payPro.eftReturnValue,
                      payNow: (PaySummary? paySummary) async {
                        if (paySummary != null) {
                          if (widget.payNow != null) widget.payNow!(paySummary);
                          _tableStatusUpdate();
                        } else {
                          await setData();
                        }
                      },
                      payPro: payPro,
                      formKey: _formKey,
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

// 1358
