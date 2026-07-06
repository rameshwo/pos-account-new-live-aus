// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/order_utils.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/menu/orders/all_orders_res.dart';
import 'package:pos_account/model/home/menu/orders/order_detail_by_id.dart';
import 'package:pos_account/model/ui_model/amount_class.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/menu/orders_pro.dart';
import 'package:pos_account/screens/home_screen/com/pos_orders/com/change_pay_method_dia.dart';
import 'package:pos_account/screens/home_screen/com/show_status.dart';
import 'package:pos_account/widgets/dashline_widget.dart';
import 'package:pos_account/widgets/dialog/msg_dialog.dart';
import 'package:pos_account/widgets/image/image_error.dart';
import 'package:pos_account/widgets/image/network_image_sec.dart';
import 'package:pos_account/widgets/input/dropdown/drop_down.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'pending_order/pending_order.dart';

class _OrderData {
  final String title;

  final List<List<_ODList>> dataList;
  final _ItemType type;
  final bool hasImage;

  _OrderData({
    required this.title,
    required this.dataList,
    this.type = _ItemType.TEXT,
    this.hasImage = false,
  });
}

enum _ItemType { TEXT, IMAGE, STATUS, PRICE, QUANTITY }

class _ODList {
  final String title;
  final String? subTitle;
  final List<String>? modifier;
  final String? status;
  final _ItemType type;
  final bool keepDeviderNext;
  final List<String>? filterOptions;
  final List<String>? ingreList;
  final String? quantity;
  final List<_ODList>? items;
  final Function()? button;

  _ODList({
    required this.title,
    this.subTitle,
    this.status,
    this.modifier,
    this.type = _ItemType.TEXT,
    this.keepDeviderNext = false,
    this.filterOptions,
    this.ingreList,
    this.quantity,
    this.items,
    this.button,
  });
}

class OrderDetailDia extends StatelessWidget {
  OrderDetailDia({
    super.key,
  });

  final _scrollCltrLeft = ScrollController();
  final _scrollCltrRight = ScrollController();

  final TextEditingController trackingTextCltr = TextEditingController();

  List<_OrderData> getData(OrderDetailById? oDById, {required String cur}) {
    final orderData = <_OrderData>[];
    final taxType = GlobalCVP.storeInfo?.taxExclusiveInclusiveType;
    if (oDById != null) {
      orderData.add(_OrderData(
        title: "Customer Details",
        dataList: [
          [
            _ODList(
              title: LN.cusName,
              subTitle: oDById.customerUserViewModel?.name?.isNotEmpty ?? false
                  ? oDById.customerUserViewModel?.name
                  : LN.anonymous,
            ),
            _ODList(
              title: LN.email,
              subTitle: oDById.customerUserViewModel?.email?.isNotEmpty ?? false
                  ? oDById.customerUserViewModel?.email
                  : LN.na,
            ),
            _ODList(
              title: LN.phone,
              subTitle:
                  oDById.customerUserViewModel?.phoneNumber?.isNotEmpty ?? false
                      ? oDById.customerUserViewModel?.phoneNumber
                      : LN.na,
            ),
            _ODList(
              title: LN.message,
              subTitle: oDById.customerUserViewModel?.message ?? LN.na,
            ),
          ]
        ],
      ));

      if (oDById.receiverUserViewModel != null && !GlobalCVP.isServiceStore)
        orderData.add(_OrderData(
          title: LN.receiverDetails,
          dataList: [
            [
              _ODList(
                title: LN.receiverName,
                subTitle: oDById.receiverUserViewModel?.name ?? LN.na,
              ),
              _ODList(
                title: LN.email,
                subTitle: oDById.receiverUserViewModel?.email ?? LN.na,
              ),
              _ODList(
                title: LN.phone,
                subTitle: oDById.receiverUserViewModel?.phoneNumber ?? LN.na,
              ),
              _ODList(
                title: LN.message,
                subTitle: oDById.receiverUserViewModel?.message ?? LN.na,
              ),
            ]
          ],
        ));

      orderData.add(_OrderData(
        title: GlobalCVP.isServiceStore ? "Service Detail" : LN.orderDetailU,
        dataList: [
          [
            _ODList(
              title: GlobalCVP.isServiceStore ? "${LN.serviceNo}." : LN.orderNo,
              subTitle: oDById.orderDetailsViewModel?.orderNumber ?? LN.na,
            ),
            _ODList(
              title: GlobalCVP.isServiceStore ? LN.serviceType : LN.orderTypeU,
              subTitle: oDById.orderDetailsViewModel?.orderType ?? LN.na,
            ),
            _ODList(
              title: GlobalCVP.isServiceStore
                  ? LN.serviceChannel
                  : LN.orderChannel,
              subTitle: oDById.orderDetailsViewModel?.orderChannel ?? LN.na,
            ),
            _ODList(
              title:
                  GlobalCVP.isServiceStore ? LN.serviceStatus : LN.orderStatus,
              subTitle: oDById.orderDetailsViewModel?.orderStatus ?? LN.na,
              type: _ItemType.STATUS,
            ),
            _ODList(
              title: GlobalCVP.isServiceStore ? LN.serviceDate : LN.orderDate,
              subTitle: oDById.orderDetailsViewModel?.orderedDate ?? LN.na,
            ),
            if (!GlobalCVP.isRetailStore &&
                !GlobalCVP.isServiceStore &&
                (oDById.orderDetailsViewModel?.tableNumber?.isNotEmpty ??
                    false))
              _ODList(
                title: LN.tableNo,
                subTitle: oDById.orderDetailsViewModel?.tableNumber ?? LN.na,
              ),
            if (oDById.orderDetailsViewModel?.pickUpDeliveryDate?.isNotEmpty ??
                false)
              _ODList(
                title: LN.picDeliDate,
                subTitle:
                    oDById.orderDetailsViewModel?.pickUpDeliveryDate ?? LN.na,
              ),
            if (oDById.orderDetailsViewModel?.deliveryAddress?.isNotEmpty ??
                false)
              _ODList(
                title: LN.deliveryAdd,
                subTitle:
                    oDById.orderDetailsViewModel?.deliveryAddress ?? LN.na,
              ),
            if (oDById.orderDetailsViewModel?.trackingNumber?.isNotEmpty ??
                false)
              _ODList(
                title: LN.trackNumber,
                subTitle: oDById.orderDetailsViewModel!.trackingNumber!,
              ),
            if (oDById.orderDetailsViewModel?.description != null &&
                oDById.orderDetailsViewModel!.description!.isNotEmpty)
              _ODList(
                title: LN.description,
                subTitle: oDById.orderDetailsViewModel!.description!,
              ),
            if (oDById.orderDetailsViewModel?.comments?.isNotEmpty ?? false)
              _ODList(
                title: LN.comments,
                subTitle: oDById.orderDetailsViewModel!.comments!,
              ),
            if (!GlobalCVP.isServiceStore &&
                (oDById.orderDetailsViewModel?.orderProcessBy?.isNotEmpty ??
                    false))
              _ODList(
                title: LN.orderProcessBy,
                subTitle: oDById.orderDetailsViewModel?.orderProcessBy ?? LN.na,
              ),
            if (oDById.orderDetailsViewModel?.paymentProcessBy?.isNotEmpty ??
                false)
              _ODList(
                title: LN.payProcessBy,
                subTitle:
                    oDById.orderDetailsViewModel?.paymentProcessBy ?? LN.na,
              ),
            if (GlobalCVP.isHospitality &&
                (oDById.orderDetailsViewModel?.kitchenStatus?.isNotEmpty ??
                    false))
              _ODList(
                title: "Kitchen Status",
                subTitle: oDById.orderDetailsViewModel?.kitchenStatus ?? LN.na,
                type: _ItemType.STATUS,
              ),
          ]
        ],
      ));

      if (oDById.orderTabViewModel != null && GlobalCVP.isHospitality)
        orderData.add(_OrderData(
          title: "Order Tab Detail",
          dataList: [
            [
              _ODList(
                title: "Tab Name",
                subTitle: oDById.orderTabViewModel?.tabIndentification ?? LN.na,
              ),
              _ODList(
                  title: "No of Customers",
                  subTitle: oDById.orderTabViewModel?.noOfCustomer ?? LN.na),
              _ODList(
                title: "Tab Limit",
                subTitle: oDById.orderTabViewModel?.tabLimit ?? LN.na,
              ),
            ]
          ],
        ));

      orderData.add(_OrderData(
        title: _orderStatus == OrderStatus.Refund
            ? LN.refundAmtDetail
            : LN.amountDetails,
        type: _ItemType.PRICE,
        dataList: <List<_ODList>>[
          [
            if (OrderUtils.getTaxType(taxType) == TaxType.Exclusive)
              _ODList(
                  title: LN.subTotal,
                  subTitle: oDById.orderDetailsViewModel?.totalAmount == null
                      ? LN.na
                      : (cur +
                              ((double.tryParse(oDById.orderDetailsViewModel!
                                                  .totalAmount ??
                                              '0.0') ??
                                          0.0) -
                                      (double.tryParse(oDById
                                                  .orderDetailsViewModel!
                                                  .taxAmount ??
                                              '0.0') ??
                                          0.0))
                                  .roundToNString())
                          .negPrice()),
            _ODList(
                title: LN.taxAmount,
                subTitle: oDById.orderDetailsViewModel?.taxAmount == null
                    ? LN.na
                    : (cur + oDById.orderDetailsViewModel!.taxAmount!)
                        .negPrice()),
            _ODList(
                title: _orderStatus == OrderStatus.Refund
                    ? LN.refundAmount
                    : LN.totalAmount,
                subTitle: oDById.orderDetailsViewModel?.totalAmount == null
                    ? LN.na
                    : (cur + oDById.orderDetailsViewModel!.totalAmount!)
                        .negPrice()),
            // if (oDById.orderDetailsViewModel?.description != null &&
            //     oDById.orderDetailsViewModel!.description!.isNotEmpty)
            //   _ODList(
            //       title: LN.description,
            //       subTitle: oDById.orderDetailsViewModel!.description!)
          ]
        ],
      ));
      if (oDById.productWithPriceDetailsViewModel?.isNotEmpty ?? false)
        orderData.add(_OrderData(
          title: _orderStatus == OrderStatus.Refund
              ? (GlobalCVP.isServiceStore
                  ? "Refunded Service with Price Details"
                  : LN.refundProdPrice)
              : (GlobalCVP.isServiceStore
                  ? "Service with Price Details"
                  : LN.productWPriceD),
          hasImage: true,
          dataList: List.generate(
              oDById.productWithPriceDetailsViewModel!.length, (i) {
            String _labelName = "";
            final _prodType = OrderUtils.prodType(
                oDById.productWithPriceDetailsViewModel?[i].productType);
            final _isHalf = _prodType == ProductType.Half;
            final _isHalfnCombo = _isHalf || _prodType == ProductType.Combo;

            final _deepModifier = <String>[];
            String? _deepSpice;
            List<String>? _deepIngredients;

            final _modifierList = ((oDById.productWithPriceDetailsViewModel?[i]
                        .orderItemModifiersViewModels?.isNotEmpty ??
                    false)
                ? oDById.productWithPriceDetailsViewModel![i]
                    .orderItemModifiersViewModels!
                    .whereModiType2(ModifierType.modifier)
                    .map((e) {
                    String _modifierText = "";

                    if (
                        // _prodType != ProductType.Combo &&
                        _labelName != e.labelName) {
                      _labelName = e.labelName ?? '';
                      _modifierText = "$_labelName\n";
                    }

                    if (_isHalfnCombo &&
                        e.modifierItemsModifierViewModels != null) {
                      String _deepLabelName = "";

                      for (final f in e.modifierItemsModifierViewModels!
                          .whereModiType2(ModifierType.modifier)) {
                        String _deepModifText = "";

                        if (_deepLabelName != f.labelName) {
                          _deepLabelName = f.labelName ?? '';
                          _deepModifText = "$_deepLabelName\n";
                        }

                        // deal_sec

                        final _deepQtyString = ((f.quantity ?? 0.0) /
                                oDById.productWithPriceDetailsViewModel![i]
                                    .quantity!.inDouble)
                            .formatDouble;

                        _deepModifier.add(
                            "$_deepModifText+ $_deepQtyString X ${f.modifierName}${oDById.productWithPriceDetailsViewModel![i].quantity!.inDouble != 1 ? ' (each)' : ''}${f.totalModifierPrice != 0.0 ? " ($cur${(f.totalModifierPrice)?.roundToNString()})" : ""}");

                        if (f.modifierItemsModifierViewModels != null) {
                          String _doubleDeepLabelName = "";

                          for (final g in f.modifierItemsModifierViewModels!
                              .whereModiType2(ModifierType.modifier)) {
                            String _doubleDeepModifText = "";

                            if (_doubleDeepLabelName != g.labelName) {
                              _doubleDeepLabelName = g.labelName ?? '';
                              _doubleDeepModifText = "$_doubleDeepLabelName\n";
                            }

                            _deepModifier.add(
                                "$_doubleDeepModifText+ ${g.modifierName}${g.totalModifierPrice != 0.0 ? " ($cur${(g.totalModifierPrice)?.roundToNString()})" : ""}");
                          }

                          final _doubleDeepIngre = f
                              .modifierItemsModifierViewModels
                              ?.whereModiType2(ModifierType.rawingre);

                          if (_doubleDeepIngre != null) {
                            String _doubleDeepRawLabelName = "";
                            // _deepIngredients = [];
                            for (final r in _doubleDeepIngre) {
                              String _doubleDeepRawText = "";

                              if (_doubleDeepRawLabelName != r.labelName) {
                                _doubleDeepRawLabelName = r.labelName ?? '';
                                _doubleDeepRawText =
                                    "$_doubleDeepRawLabelName\n";
                              }
                              _deepModifier.add(
                                  "$_doubleDeepRawText- ${r.modifierName}");
                            }
                          }
                        }
                      }

                      final _deepSpiceList = e.modifierItemsModifierViewModels
                          ?.whereModiType2(ModifierType.spice);
                      _deepSpice = ((_deepSpiceList?.any((a) => a.isActive) ??
                              false)
                          ? "\n- ${_deepSpiceList?.firstWhere((a) => a.isActive).modifierName ?? ''}"
                          : "");

                      final _deepIngre = e.modifierItemsModifierViewModels
                          ?.whereModiType2(ModifierType.rawingre);

                      if (_deepIngre != null) {
                        _deepIngredients = [];
                        for (final q in _deepIngre) {
                          if (q.isActive) {
                            _deepIngredients?.add(q.modifierName ?? '');
                          }
                        }
                      }
                    }

                    final _qtyString = ((e.quantity ?? 0.0) /
                            oDById.productWithPriceDetailsViewModel![i]
                                .quantity!.inDouble)
                        .formatDouble;

                    return "$_modifierText+ $_qtyString X ${e.modifierName}${oDById.productWithPriceDetailsViewModel![i].quantity!.inDouble != 1 ? ' (each)' : ''}${_isHalfnCombo ? (_deepSpice ?? '') : ' ($cur${(e.totalModifierPrice)?.roundToNString()})'}";
                  }).toList()
                : [LN.na]);

            final staffList = ((oDById.productWithPriceDetailsViewModel?[i]
                        .orderItemsServiceEmployeeViewModels?.isNotEmpty ??
                    false)
                ? oDById.productWithPriceDetailsViewModel![i]
                    .orderItemsServiceEmployeeViewModels!
                    .map((e) {
                    return "- ${e.employeeName}";
                  }).toList()
                : [LN.na]);

            double _modifierPrice = (oDById.productWithPriceDetailsViewModel![i]
                    .orderItemModifiersViewModels
                    ?.fold<double>(
                        0,
                        (pV, e) =>
                            pV +
                            (e.isActive
                                ? ((e.totalModifierPrice ?? 0) +
                                    (e.modifierItemsModifierViewModels?.fold<double>(
                                            0,
                                            (pV1, e1) =>
                                                pV1 +
                                                (e1.isActive
                                                    ? ((e1.totalModifierPrice ??
                                                            0) +
                                                        (e1.modifierItemsModifierViewModels
                                                                ?.fold<double>(
                                                                    0,
                                                                    (pV2, e2) =>
                                                                        pV2 + (e2.isActive ? (e2.totalModifierPrice ?? 0.0) : 0.0)) ??
                                                            0.0))
                                                    : 0.0)) ??
                                        0))
                                : 0)) ??
                0);

            final _status = OrderUtils.getStatusEnum(
                oDById.productWithPriceDetailsViewModel?[i].statusId);

            final _spice = oDById.productWithPriceDetailsViewModel?[i]
                .orderItemModifiersViewModels
                ?.whereModiType2(ModifierType.spice);
            final _ingreList = oDById.productWithPriceDetailsViewModel?[i]
                .orderItemModifiersViewModels
                ?.whereModiType2(ModifierType.rawingre);

            return [
              _ODList(
                title: "",
                subTitle:
                    oDById.productWithPriceDetailsViewModel?[i].image ?? LN.na,
                type: _ItemType.IMAGE,
              ),
              _ODList(
                title: (LN.name),
                subTitle: // (_firstHalfItem ? "Half n'half\n" : "") +
                    (oDById.productWithPriceDetailsViewModel?[i].name ??
                            LN.na) +
                        ((_spice?.isNotEmpty ?? false)
                            ? ("\n- ${_spice?.first.modifierName ?? ''}")
                            : ""),
                status: _status == OrderStatusEnum.cancel
                    ? LN.canceled
                    : _status == OrderStatusEnum.hold
                        ? "onHold"
                        : null,
                filterOptions: oDById.productWithPriceDetailsViewModel?[i]
                            .orderItemSelectOptionsViewModels ==
                        null
                    ? null
                    : oDById.productWithPriceDetailsViewModel![i]
                        .orderItemSelectOptionsViewModels!
                        .map((e) =>
                            "${e.selectOptionName ?? ''} : ${e.selectOptionValue ?? ''}")
                        .toList(),
                ingreList: _isHalfnCombo
                    ? _deepIngredients
                    : _ingreList?.map((e) => e.modifierName ?? '').toList(),
                modifier: _isHalfnCombo ? _modifierList : null,
              ),
              _ODList(
                title: GlobalCVP.isServiceStore ? LN.extra : LN.modifier,
                modifier: _isHalfnCombo ? _deepModifier : _modifierList,
              ),
              _ODList(
                title: LN.quantity,
                subTitle:
                    "${(double.tryParse(oDById.productWithPriceDetailsViewModel?[i].quantity ?? '1') ?? 1)}",
                type: _ItemType.QUANTITY,
              ),
              _ODList(
                title: LN.total,
                subTitle: (oDById.productWithPriceDetailsViewModel?[i].total ==
                        null
                    ? LN.na
                    : (cur +
                            ((double.tryParse(oDById
                                                .productWithPriceDetailsViewModel![
                                                    i]
                                                .total ??
                                            '') ??
                                        0) +
                                    _modifierPrice)
                                .roundToNString())
                        .negPrice()),
              ),
              if (oDById.productWithPriceDetailsViewModel?[i].description !=
                      null &&
                  oDById.productWithPriceDetailsViewModel![i].description!
                      .isNotEmpty)
                _ODList(
                  title: LN.description,
                  subTitle:
                      oDById.productWithPriceDetailsViewModel![i].description!,
                ),
              if (GlobalCVP.isServiceStore &&
                  (oDById.productWithPriceDetailsViewModel?[i]
                          .orderItemsServiceEmployeeViewModels?.isNotEmpty ??
                      false))
                _ODList(
                  title: LN.assignedStaffs,
                  modifier: staffList,
                ),
              if (GlobalCVP.isHospitality &&
                  (oDById.productWithPriceDetailsViewModel?[i].kitchenStatus
                          ?.isNotEmpty ??
                      false))
                _ODList(
                  title: "KD Status",
                  subTitle: oDById
                          .productWithPriceDetailsViewModel?[i].kitchenStatus ??
                      '',
                  type: _ItemType.STATUS,
                ),
            ];
          }),
        ));

      if (oDById.setMenuWithPriceDetailsViewModel?.isNotEmpty ?? false)
        orderData.add(_OrderData(
          title: _orderStatus == OrderStatus.Refund
              ? LN.refundComboPrice
              : LN.setmenuWPD,
          hasImage: true,
          dataList: List.generate(
              oDById.setMenuWithPriceDetailsViewModel!.length, (i) {
            final _total = (double.tryParse(
                        oDById.setMenuWithPriceDetailsViewModel?[i].total ??
                            '') ??
                    0) +
                (oDById.setMenuWithPriceDetailsViewModel?[i]
                        .setMenuProductViewModel
                        ?.fold<double>(
                      0,
                      (pV1, e1) =>
                          pV1 +
                          (e1.orderItemModifiersViewModels?.fold<double>(
                                  0,
                                  (pV2, e2) =>
                                      pV2 + (e2.totalModifierPrice ?? 0)) ??
                              0),
                    ) ??
                    0);

            return [
              _ODList(
                title: "",
                subTitle:
                    oDById.setMenuWithPriceDetailsViewModel?[i].image ?? LN.na,
                type: _ItemType.IMAGE,
              ),
              _ODList(
                title: LN.name,
                subTitle:
                    oDById.setMenuWithPriceDetailsViewModel?[i].setMenuName ??
                        LN.na,
                status: OrderUtils.getStatusEnum(oDById
                            .setMenuWithPriceDetailsViewModel?[i].statusId) ==
                        OrderStatusEnum.cancel
                    ? LN.canceled
                    : null,
              ),
              _ODList(
                title: LN.quantity,
                subTitle:
                    oDById.setMenuWithPriceDetailsViewModel?[i].quantity ??
                        LN.na,
              ),
              _ODList(
                  title: LN.total,
                  subTitle: (cur + _total.roundToNString()).negPrice()),
              _ODList(
                title: LN.items,
                items: oDById.setMenuWithPriceDetailsViewModel == null
                    ? null
                    : List.generate(
                        oDById.setMenuWithPriceDetailsViewModel![i]
                            .setMenuProductViewModel!.length, (j) {
                        final _item = oDById
                            .setMenuWithPriceDetailsViewModel![i]
                            .setMenuProductViewModel![j];
                        String labelName = "";

                        return _ODList(
                          title: "",
                          subTitle: "${j + 1}. ${_item.name}",
                          // (_item.orderItemSpiceChoiceViewModel?.name != null
                          //     ? "\n- ${_item.orderItemSpiceChoiceViewModel!.name}"
                          //     : ""),
                          modifier:
                              _item.orderItemModifiersViewModels?.map((e) {
                            String modifierText = "";

                            if (labelName != e.labelName) {
                              labelName = e.labelName ?? '';
                              modifierText = "$labelName\n";
                            }

                            modifierText +=
                                "+ ${e.modifierName ?? ''} ($cur${e.totalModifierPrice?.roundToNString()})";

                            return modifierText;
                          }).toList(),
                          // ingreList: _item.removedOrderItemIngredientViewModels
                          //     ?.map((e) => e.name ?? '')
                          //     .toList(),
                          quantity: _item.quantity,
                          keepDeviderNext: oDById
                                      .setMenuWithPriceDetailsViewModel![i]
                                      .setMenuProductViewModel!
                                      .length -
                                  1 !=
                              j,
                        );
                      }),
              ),
              if (oDById.setMenuWithPriceDetailsViewModel?[i].description
                      ?.isNotEmpty ??
                  false)
                _ODList(
                  title: LN.description,
                  subTitle:
                      oDById.setMenuWithPriceDetailsViewModel![i].description!,
                ),
            ];
          }),
        ));

      if (oDById.rawIngredientWithPriceDetailsViewModel?.isNotEmpty ?? false)
        orderData.add(_OrderData(
          title: _orderStatus == OrderStatus.Refund
              ? LN.refund + LN.rawIngre
              : LN.rawIngre,
          hasImage: false,
          dataList: List.generate(
              oDById.rawIngredientWithPriceDetailsViewModel!.length, (i) {
            final _total = (double.tryParse(oDById
                        .rawIngredientWithPriceDetailsViewModel?[i]
                        .totalSellingPrice ??
                    '') ??
                0);

            return [
              // _ODList(
              //   title: "",
              //   subTitle:
              //       oDById.rawIngredientWithPriceDetailsViewModel?[i].image ?? LN.na,
              //   type: _ItemType.IMAGE,
              // ),
              _ODList(
                title: LN.name,
                subTitle:
                    oDById.rawIngredientWithPriceDetailsViewModel?[i].name ??
                        LN.na,
                status: OrderUtils.getStatusEnum(oDById
                            .rawIngredientWithPriceDetailsViewModel?[i]
                            .statusId) ==
                        OrderStatusEnum.cancel
                    ? LN.canceled
                    : null,
              ),
              _ODList(
                title: LN.quantity,
                subTitle: oDById
                        .rawIngredientWithPriceDetailsViewModel?[i].quantity ??
                    LN.na,
              ),
              _ODList(
                  title: LN.total,
                  subTitle: (cur + _total.roundToNString()).negPrice()),
            ];
          }),
        ));
    }
    return orderData;
  }

  String _discountAmount({required OrderDetailById oDById}) {
    String discountAmount = "0.00";

    // if (_orderStatus == OrderStatus.Pending ||
    //     _orderStatus == OrderStatus.PaymentPending) {
    //   double _total = 0.0;

    //   if (oDById.productWithPriceDetailsViewModel != null)
    //     _total += oDById.productWithPriceDetailsViewModel!.fold<double>(
    //       0.0,
    //       (p, e) =>
    //           p +
    //           ((e.isCancelled == null || !e.isCancelled!)
    //               ? (double.tryParse(e.total ?? '0') ?? 0)
    //               : 0),
    //     );

    //   if (oDById.setMenuWithPriceDetailsViewModel != null)
    //     _total += oDById.setMenuWithPriceDetailsViewModel!.fold<double>(
    //       0.0,
    //       (p, e) =>
    //           p +
    //           ((e.isCancelled == null || !e.isCancelled!)
    //               ? (double.tryParse(e.total ?? '0') ?? 0)
    //               : 0),
    //     );

    //   final _disPercentString = oDById
    //           .orderPaymentDetailsWithPaymentStatusViewModel
    //           ?.discountPercentage ??
    //       '0';
    //   final _discountPercent = double.parse(_disPercentString) / 100;

    //   _discountAmount = (_total * _discountPercent).roundToNString();
    // } else
    if (OrderUtils.getTaxType(GlobalCVP.storeInfo?.taxExclusiveInclusiveType) ==
        TaxType.Inclusive) {
      discountAmount = oDById
              .orderPaymentDetailsWithPaymentStatusViewModel?.discountWithTax ??
          '0.0';
    } else {
      discountAmount =
          oDById.orderPaymentDetailsWithPaymentStatusViewModel?.discount ??
              '0.0';
    }

    return discountAmount;
  }

  List<List<_ODList>> getPayDetails(OrderDetailById? oDById,
      {required String cur}) {
    final odList = <List<_ODList>>[];
    if (oDById?.orderPaymentDetailsWithPaymentStatusViewModel
            ?.orderPaymentsDetailsViewModels !=
        null) {
      odList.add([
        _ODList(
          title: LN.transStatus,
          subTitle: oDById!.orderPaymentDetailsWithPaymentStatusViewModel!
                  .paymentStatus ??
              LN.na,
          type: _ItemType.STATUS,
        ),
        _ODList(
          title: LN.discountAmt,
          subTitle: ((_orderStatus == OrderStatus.Refund ? '' : '-') +
                  cur +
                  _discountAmount(oDById: oDById))
              .negPrice(),
          type: _ItemType.TEXT,
        ),
        _ODList(
          title: (GlobalCVP.storeInfo?.taxExclusiveInclusiveType
                      ?.toLowerCase()
                      .contains('week') ??
                  false)
              ? LN.weekendSur
              : LN.holiSurgeAmt,
          subTitle: (cur +
                  (oDById.orderPaymentDetailsWithPaymentStatusViewModel
                          ?.holidaySurgeAmountWithTax ??
                      '0.0'))
              .negPrice(),
          type: _ItemType.TEXT,
        ),
        _ODList(
          title: LN.ccSurgeAmt,
          subTitle: (cur +
                  (oDById.orderPaymentDetailsWithPaymentStatusViewModel
                          ?.creditCardSurgeAmountWithTax ??
                      '0.0'))
              .negPrice(),
          type: _ItemType.TEXT,
        ),
        if ((oDById.orderPaymentDetailsWithPaymentStatusViewModel
                    ?.serviceChargeAmount?.inDouble ??
                0) !=
            0)
          _ODList(
            title: "Service Charge",
            subTitle: (cur +
                    (oDById.orderPaymentDetailsWithPaymentStatusViewModel
                            ?.serviceChargeAmount ??
                        '0.0'))
                .negPrice(),
            type: _ItemType.TEXT,
          ),
        _ODList(
          title: LN.deliAmt,
          subTitle: ((_orderStatus == OrderStatus.Refund ? '-' : '') +
                  cur +
                  (OrderUtils.getTaxType(
                              GlobalCVP.storeInfo?.taxExclusiveInclusiveType) ==
                          TaxType.Inclusive
                      ? (oDById.orderPaymentDetailsWithPaymentStatusViewModel
                              ?.deliveryAmountWithTax ??
                          '0.0')
                      : (oDById.orderPaymentDetailsWithPaymentStatusViewModel
                              ?.deliveryAmount ??
                          '0.0')))
              .negPrice(),
          type: _ItemType.TEXT,
        )
      ]);
      for (final e in oDById.orderPaymentDetailsWithPaymentStatusViewModel!
          .orderPaymentsDetailsViewModels!) {
        odList.add([
          _ODList(
            title: LN.paymentMethod,
            subTitle: e.paymentMethod ?? LN.na,
            button: () {
              if (orderP.loadStatus) return;

              orderP.getPayMethods().then((_) {
                if (orderP.payMethodList?.isNotEmpty ?? false) {
                  for (final g in orderP.payMethodList!) {
                    if (g.value == e.paymentMethod) {
                      g.isSelected = true;
                    } else
                      g.isSelected = false;
                  }
                  ChangePayMethodDia.show(id: e.id);
                }
              });
            },
          ),
          _ODList(title: LN.cusName, subTitle: e.customerName ?? LN.na),
          if (_orderStatus != OrderStatus.Refund)
            _ODList(
              title: LN.tipAmount,
              subTitle: (cur + (e.tipAmount ?? '0.0')),
              // keepDeviderNext: true,
            ),
          _ODList(
              title: _orderStatus == OrderStatus.Refund
                  ? LN.refundAmount
                  : LN.paidAmount,
              subTitle: (cur + (e.paidAmount ?? '0.0')).negPrice())
        ]);
      }
    }
    return odList;
  }

  void _acceptOrder({
    required BuildContext ctx,
    required OrderPro orderPro,
  }) {
    PendingOrder(
      orderPro: orderPro,
    ).acceptOrder(
      ctx,
      allOrderData: AllOrderData(
        orderId: orderPro.oDById?.orderDetailsViewModel?.orderId,
        orderNumber: orderPro.oDById?.orderDetailsViewModel?.orderNumber,
        customerName: orderPro.oDById?.customerUserViewModel?.name,
        tableName: orderPro.oDById?.orderDetailsViewModel?.tableNumber,
        totalAmount: orderPro.oDById?.orderDetailsViewModel?.totalAmount,
        status: orderPro.oDById?.orderDetailsViewModel?.orderStatus,
        orderDate: orderPro.oDById?.orderDetailsViewModel?.orderedDate,
        // statusEnumValue:
        orderChannel: orderPro.oDById?.orderDetailsViewModel?.orderChannel,
      ),
      refreshOrder: true,
    );
  }

  static OrderStatus? get _orderStatus => OrderStatusModel.getStatus(
      orderP.oDById?.orderDetailsViewModel?.orderStatus);

  bool get _isPayComplete {
    // final _paidAmount = orderP
    //         .oDById
    //         ?.orderPaymentDetailsWithPaymentStatusViewModel
    //         ?.orderPaymentsDetailsViewModels
    //         ?.fold<double>(
    //             0,
    //             (pV, nVe) =>
    //                 pV + (double.tryParse(nVe.paidAmount ?? '') ?? 0)) ??
    //     0;

    // final _totalAmount = double.tryParse(
    //         orderP.oDById?.orderDetailsViewModel?.totalAmount ?? '') ??
    //     0;

    //(_paidAmount - _totalAmount).abs() <= 0.01 &&

    return false;
    // _orderStatus == OrderStatus.PaymentPending;
  }

  static late OrderPro orderP;

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    orderP = Provider.of<OrderPro>(context);

    final orderData = getData(orderP.oDById, cur: orderP.curSym);
    final payDetails = getPayDetails(orderP.oDById, cur: orderP.curSym);

    final IsStatusOnTheWay = orderP.orderStatusIndex != null &&
        orderP.viewOrderStatusList.isNotEmpty &&
        orderP.viewOrderStatusList.length > orderP.orderStatusIndex! &&
        OrderStatusModel.getStatus(
                orderP.viewOrderStatusList[orderP.orderStatusIndex!].value) ==
            OrderStatus.OnTheWay;

    return Processing(
      loading: orderP.loadStatus || orderP.updatePayLoad,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: size.height / 1.2,
          minHeight: size.height / 5,
        ),
        width: size.width / 1.12,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  orderP.oDById?.orderDetailsViewModel?.orderNumber ?? '',
                  style: TextStyle(
                    fontSize: size.getS(20),
                    color: kPrimaryColor,
                    fontFamily: kFontFMedium,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close))
              ],
            ),
            Divider(
              color: Colors.black87,
              thickness: 0.6,
            ),
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 21,
                    child: Scrollbar(
                      controller: _scrollCltrLeft,
                      trackVisibility: true,
                      interactive: true,
                      thickness: 10,
                      radius: Radius.circular(40),
                      child: SingleChildScrollView(
                        controller: _scrollCltrLeft,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ...List.generate(
                                orderData.length,
                                (index) => OrDeDataTile(
                                      size: size,
                                      orderData: orderData[index],
                                    ))
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: size.getW(12),
                  ),
                  if (payDetails.isNotEmpty)
                    Flexible(
                        flex: 10,
                        child: Scrollbar(
                          controller: _scrollCltrRight,
                          trackVisibility: true,
                          interactive: true,
                          thickness: 10,
                          radius: Radius.circular(40),
                          child: SingleChildScrollView(
                            controller: _scrollCltrRight,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ...List.generate(
                                    payDetails.length,
                                    (i) => Container(
                                          margin: EdgeInsets.only(
                                              bottom: size.getH(8),
                                              right: size.getW(8)),
                                          padding: payDetails[i][0].type ==
                                                  _ItemType.STATUS
                                              ? null
                                              : EdgeInsets.symmetric(
                                                  vertical: size.getH(12),
                                                  horizontal: size.getW(16)),
                                          decoration: BoxDecoration(
                                              color: payDetails[i][0].type ==
                                                      _ItemType.STATUS
                                                  ? null
                                                  : Colors.blue.withAlpha(40),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ...List.generate(
                                                  payDetails[i].length,
                                                  (j) => Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          vertical: 8.0,
                                                        ),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Flexible(
                                                                  flex: 3,
                                                                  child: Row(
                                                                    children: [
                                                                      Flexible(
                                                                        child:
                                                                            Text(
                                                                          payDetails[i][j]
                                                                              .title,
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                size.getS(15),
                                                                            color:
                                                                                Colors.black,
                                                                            fontFamily:
                                                                                kFontFMedium,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      if (payDetails[i][j]
                                                                              .button !=
                                                                          null)
                                                                        Container(
                                                                          margin:
                                                                              EdgeInsets.only(left: size.getW(12)),
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.blue.withOpacity(0.1),
                                                                              borderRadius: BorderRadius.circular(25),
                                                                              border: Border.all(color: Colors.blue)),
                                                                          child:
                                                                              Material(
                                                                            color:
                                                                                Colors.transparent,
                                                                            borderRadius:
                                                                                BorderRadius.circular(25),
                                                                            child:
                                                                                InkWell(
                                                                              onTap: payDetails[i][j].button,
                                                                              borderRadius: BorderRadius.circular(25),
                                                                              child: Padding(
                                                                                padding: EdgeInsets.symmetric(horizontal: size.getW(12), vertical: size.getH(2)),
                                                                                child: Text(
                                                                                  LN.update,
                                                                                  style: TextStyle(
                                                                                    color: Colors.blue.shade700,
                                                                                    fontSize: size.getS(12),
                                                                                    fontFamily: kFontFMedium,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Flexible(
                                                                    child: payDetails[i][j].type ==
                                                                            _ItemType.STATUS
                                                                        ? ShowStatus(
                                                                            size:
                                                                                size,
                                                                            title:
                                                                                payDetails[i][j].subTitle ?? '',
                                                                            fontSize:
                                                                                13,
                                                                          )
                                                                        : Text(
                                                                            payDetails[i][j].subTitle ??
                                                                                '',
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: size.getS(15),
                                                                              color: Colors.black,
                                                                              fontFamily: kFontFBold,
                                                                            ),
                                                                          )),
                                                              ],
                                                            ),
                                                            if (payDetails[i][j]
                                                                .keepDeviderNext)
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            16.0),
                                                                child:
                                                                    HDashDivider(),
                                                              )
                                                          ],
                                                        ),
                                                      ))
                                            ],
                                          ),
                                        )),
                              ],
                            ),
                          ),
                        ))
                ],
              ),
            ),
            if (!GlobalCVP.isServiceStore &&
                (_isPayComplete ||
                    _orderStatus == OrderStatus.PaymentCompleted))
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.getW(16.0)),
                child: Row(
                  children: [
                    // if (orderP.oDById?.orderDetailsViewModel?.orderStatus !=
                    //         null &&
                    //     (orderP.oDById!.orderDetailsViewModel!.orderStatus!
                    //         .toLowerCase()
                    //         .contains('pending')))
                    //   LoadButton(
                    //     btnText: "+ ${LN.newOrder}",
                    //     vPad: 8,
                    //     onsave: () {
                    //       Navigator.pop(context);
                    //       final _placeOrderPro =
                    //           Provider.of<PlaceOrderPro>(context, listen: false);
                    //       _placeOrderPro.clear();
                    //       _placeOrderPro.reOrder = ReOrder(
                    //         orderId:
                    //             orderP.oDById?.orderDetailsViewModel?.orderId,
                    //         orderNumber:
                    //             orderP.oDById?.orderDetailsViewModel?.orderNumber,
                    //       );
                    //       if (_placeOrderPro.initRes?.tables != null &&
                    //           _placeOrderPro.initRes!.tables!.any((e) =>
                    //               e.name ==
                    //               orderP.oDById?.orderDetailsViewModel
                    //                   ?.tableNumber)) {
                    //         _placeOrderPro.tableIndex =
                    //             _placeOrderPro.initRes!.tables!.indexWhere((e) =>
                    //                 e.name ==
                    //                 orderP.oDById?.orderDetailsViewModel
                    //                     ?.tableNumber);
                    //       }

                    //       GlobalCVP.setMainPage = MainPage.HomePage;

                    //       Future.delayed(Duration(milliseconds: 200), () {
                    //         int _posIndex = 1;
                    //         if (GlobalCVP.tabs.any((e) => e == LN.pos)) {
                    //           _posIndex =
                    //               GlobalCVP.tabs.indexWhere((e) => e == LN.pos);
                    //         }
                    //         if (GlobalCVP.getHPTIndex != _posIndex) {
                    //           if (GlobalCVP.tabCltr != null)
                    //             GlobalCVP.tabCltr!.index = _posIndex;
                    //         }
                    //       });
                    //     },
                    //   ),
                    Spacer(),
                    if (IsStatusOnTheWay)
                      SizedBox(
                        width: size.getW(300),
                        child: TextFormWidget(
                          borderColor: Colors.black45,
                          cltr: trackingTextCltr,
                          hintText: LN.trackNumber,
                        ),
                      ),
                    SizedBox(width: size.getW(12)),
                    SizedBox(
                      width: size.getW(260),
                      child: DropDownList(
                        hint: GlobalCVP.isServiceStore
                            ? LN.chooseServiceStatus
                            : LN.chooseOrderStatus,
                        vPad: 8,
                        indexValue: orderP.orderStatusIndex,
                        list: orderP.viewOrderStatusList.isEmpty
                            ? []
                            : orderP.viewOrderStatusList
                                .map((e) => e.value ?? "")
                                .toList(),
                        borderRadius: 5,
                        textColor: Colors.white,
                        fillColor: kPrimaryColor,
                        dropDownColor: kPrimaryColor,
                        borderColor: kPrimaryColor,
                        iconEnableColor: Colors.white,
                        hintTextColor: Colors.white,
                        fontWeight: FontWeight.bold,
                        onChange: (p0) {
                          orderP.orderStatusIndex = p0;
                          orderP.notify;
                        },
                      ),
                    ),
                    SizedBox(
                      width: size.getW(12),
                    ),
                    if (GlobalCVP.viewWidget.viewUpdateOrderStatusButton)
                      LoadButton(
                        btnText: LN.update,
                        loading: orderP.loadStatus,
                        vPad: 8,
                        onsave: orderP.loadStatus
                            ? null
                            : () {
                                if (orderP.orderStatusIndex != null &&
                                    orderP.viewOrderStatusList.isNotEmpty &&
                                    orderP.oDById != null) {
                                  orderP
                                      .orderStatusUpdate(
                                        orderId: orderP.oDById!
                                            .orderDetailsViewModel!.orderId!,
                                        orderStatusId: orderP
                                                .viewOrderStatusList[
                                                    orderP.orderStatusIndex!]
                                                .id ??
                                            "",
                                        trackingDetail: IsStatusOnTheWay
                                            ? trackingTextCltr.text
                                            : null,
                                      )
                                      .then((_) => orderP.getData(
                                            page: orderP.pageIndex,
                                          ));
                                } else {
                                  MsgDia.show(
                                    CUS_CTX,
                                    headerAnimation: false,
                                    diaType: DiaType.warning,
                                    title: LN.orderStatusNotChoosen,
                                    autoHideSecond: 1,
                                  );
                                }
                              },
                      ),
                  ],
                ),
              )
            else if (_orderStatus == OrderStatus.Pending)
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(kSecondaryColor),
                      padding: WidgetStateProperty.all(
                        EdgeInsets.symmetric(
                          horizontal: size.getW(16),
                          // vertical: size.getH(8.0)
                        ),
                      ),
                    ),
                    onPressed: () =>
                        _acceptOrder(ctx: context, orderPro: orderP),
                    child: Text(
                      LN.acceptOrder,
                      style: TextStyle(
                        fontSize: size.getS(16),
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
              )
          ],
        ),
      ),
    );
  }
}

class OrDeDataTile extends StatelessWidget {
  final Ssize size;
  final _OrderData orderData;
  const OrDeDataTile({
    super.key,
    required this.size,
    required this.orderData,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: size.getW(12)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: size.getH(8),
          ),
          Text(
            orderData.title,
            style: TextStyle(
              fontSize: size.getS(18),
              color: kPrimaryColor,
              fontFamily: kFontFMedium,
              fontWeight: FontWeight.bold,
            ),
          ),
          orderData.dataList.isEmpty
              ? Text(
                  LN.noDataFound,
                  style: TextStyle(
                    fontSize: size.getS(16),
                    color: Colors.black,
                    fontFamily: kFontFBold,
                  ),
                )
              : Container(
                  padding: orderData.type == _ItemType.PRICE
                      ? EdgeInsets.symmetric(horizontal: 8, vertical: 4)
                      : null,
                  decoration: orderData.type == _ItemType.PRICE
                      ? BoxDecoration(
                          color: Colors.green.withAlpha(50),
                          borderRadius: BorderRadius.circular(5))
                      : null,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...List.generate(orderData.dataList.length, (i) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: orderData.dataList.length > 1
                                  ? EdgeInsets.only(bottom: size.getH(16))
                                  : EdgeInsets.zero,
                              decoration: BoxDecoration(
                                color: null,
                              ),
                              child: Wrap(
                                spacing: size.getW(16),
                                runSpacing: size.getH(16),
                                children: [
                                  ...List.generate(
                                      orderData.dataList[i].length,
                                      (j) => SizedBox(
                                            width: size.getW(
                                                orderData.dataList[i][j].type ==
                                                        _ItemType.IMAGE
                                                    ? 74
                                                    : orderData.hasImage
                                                        ? (j == 1 ? 200 : 120)
                                                        : 148),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                if (orderData.dataList[i][j]
                                                    .title.isNotEmpty)
                                                  Wrap(
                                                    children: [
                                                      Text(
                                                        orderData.dataList[i][j]
                                                            .title,
                                                        style: TextStyle(
                                                          fontSize:
                                                              size.getS(16),
                                                          color: Colors.black,
                                                          fontFamily:
                                                              kFontFBold,
                                                        ),
                                                      ),
                                                      if (orderData
                                                              .dataList[i][j]
                                                              .status !=
                                                          null)
                                                        ShowStatus(
                                                          title: orderData
                                                              .dataList[i][j]
                                                              .status!,
                                                          size: size,
                                                          fontSize: 12,
                                                        )
                                                    ],
                                                  ),
                                                if (orderData
                                                        .dataList[i][j].type ==
                                                    _ItemType.STATUS)
                                                  ShowStatus(
                                                    title: orderData
                                                            .dataList[i][j]
                                                            .subTitle ??
                                                        '',
                                                    size: size,
                                                    fontSize: 12,
                                                  )
                                                else if (orderData
                                                        .dataList[i][j].type ==
                                                    _ItemType.IMAGE)
                                                  Center(
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              60),
                                                      child: NetworkImageSec(
                                                        image: orderData
                                                            .dataList[i][j]
                                                            .subTitle,
                                                        height: size.getS(60),
                                                        width: size.getS(60),
                                                        boxFit: BoxFit.cover,
                                                        errWidget: ImageError
                                                            .notSupportIcon(
                                                                context,
                                                                "",
                                                                ""),
                                                      ),
                                                    ),
                                                  )
                                                else if (orderData
                                                        .dataList[i][j]
                                                        .items
                                                        ?.isNotEmpty ??
                                                    false)
                                                  ...List.generate(
                                                    orderData.dataList[i][j]
                                                        .items!.length,
                                                    (k) => _itemContain(
                                                        data: orderData
                                                            .dataList[i][j]
                                                            .items![k],
                                                        isInItem: true),
                                                  )
                                                else
                                                  _itemContain(
                                                      data: orderData
                                                          .dataList[i][j]),
                                              ],
                                            ),
                                          )),
                                  if (orderData.dataList.length - 1 != i)
                                    Divider(
                                      color: Colors.black26,
                                      thickness: 0.5,
                                    ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: size.getH(12)),
            child: HDashDivider(),
          ),
        ],
      ),
    );
  }

  Widget _itemContain({
    required _ODList data,
    bool isInItem = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (data.subTitle?.isNotEmpty ?? false)
          Text(
            data.subTitle ?? '',
            style: TextStyle(
              fontSize: size.getS(data.type == _ItemType.QUANTITY ? 16 : 15),
              color: Colors.black,
              fontFamily: kFontFMedium,
            ),
          ),
        if ((double.tryParse(data.quantity ?? '') ?? 0) == 0.5)
          Container(
            decoration: BoxDecoration(
              color: kSecondaryColor.withAlpha(100),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.symmetric(horizontal: size.getW(16)),
            child: Text(
              LN.half,
              style: TextStyle(
                fontSize: size.getS(15),
                fontFamily: kFontFMedium,
                color: Colors.white,
              ),
            ),
          ),
        if (data.modifier?.isNotEmpty ?? false) ...[
          if (isInItem) ...[
            Text(
              "${LN.modifiers}:",
              style: TextStyle(
                fontSize: size.getS(15),
                color: kTempColor,
                fontFamily: kFontFMedium,
              ),
            ),
            // SizedBox(height: size.getH(4)),
          ],
          ...List.generate(
              data.modifier!.length,
              (k) => Padding(
                    padding: EdgeInsets.only(
                      bottom: size.getH(2),
                      top: size.getH(
                          data.modifier![k].contains('\n') ? size.getH(8) : 0),
                    ),
                    child: Text(
                      data.modifier![k],
                      style: TextStyle(
                        fontSize: size.getS(15),
                        color: data.modifier![k].contains('- ')
                            ? Colors.amber.shade900
                            : kTempColor,
                        fontFamily: kFontFMedium,
                        height: 1.3,
                      ),
                    ),
                  ))
        ],
        if (data.ingreList?.isNotEmpty ?? false) ...[
          Text(
            LN.removeIngredients,
            style: TextStyle(
              fontSize: size.getS(14),
              color: Colors.amber.shade900,
              fontFamily: kFontFMedium,
            ),
          ),
          ...List.generate(
              data.ingreList!.length,
              (k) => Text.rich(
                    TextSpan(
                        text: "- ",
                        children: [
                          TextSpan(
                              text: data.ingreList![k],
                              style: TextStyle(
                                fontFamily: kFontFMedium,
                                decoration: TextDecoration.lineThrough,
                              ))
                        ],
                        style: TextStyle(
                          fontSize: size.getS(14),
                          color: Colors.amber.shade900,
                        )),
                  ))
        ],
        if (data.filterOptions?.isNotEmpty ?? false)
          Wrap(
            spacing: size.getW(4),
            runSpacing: size.getH(4),
            children: List.generate(
                data.filterOptions!.length,
                (index) => Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: size.getW(8), vertical: size.getH(2)),
                      decoration: BoxDecoration(
                          color: kSecondaryColor,
                          borderRadius: BorderRadius.circular(5)),
                      child: Text.rich(
                        TextSpan(
                          text: data.filterOptions![index],
                          style: TextStyle(
                            fontSize: size.getS(13),
                            color: Colors.white,
                            fontFamily: kFontFMedium,
                          ),
                        ),
                      ),
                    )),
          ),
        if (data.keepDeviderNext)
          Divider(
            color: Colors.black87,
            thickness: 0.6,
          ),
      ],
    );
  }
}
