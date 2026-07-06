import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/menu/kitchen/kitchen_all_orders.dart';
import 'package:pos_account/providers/kitchen/kitchen_pro.dart';
import 'package:pos_account/widgets/dialog/confirm_dialog.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

class KitOrderTile extends StatefulWidget {
  final KitOrderData data;
  final Function(bool)? priotize;
  final Function()? onStart;
  final KitOrderStatusEnum? kitStatus;
  final KitchenPro? kitPro;

  const KitOrderTile({
    super.key,
    required this.data,
    this.priotize,
    this.onStart,
    this.kitStatus,
    this.kitPro,
  });

  @override
  State<KitOrderTile> createState() => _KitOrderTileState();
}

class _KitOrderTileState extends State<KitOrderTile> {
  final _scrollCltr = ScrollController();

  late ListObserverController observerController =
      ListObserverController(controller: _scrollCltr);

  @override
  void dispose() {
    _scrollCltr.dispose();
    super.dispose();
  }

  Future<void> _scrollToNextItem(int index) async {
    observerController.animateTo(
      index: index,
      duration: Duration(milliseconds: 1200),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final data = widget.data;
    final priotize = widget.priotize;
    final priData = double.tryParse(data.prioritizeSortOrder ?? '') ?? 0;

    final isPriority = priData != 0;
    final btnText = widget.kitStatus == KitOrderStatusEnum.Preparing
        ? "Complete Cooking"
        : widget.kitStatus == KitOrderStatusEnum.Completed
            ? "Recall Order"
            : "Start Preparing";
    final btnColor = widget.kitStatus == KitOrderStatusEnum.Preparing
        ? Colors.green.shade800
        : widget.kitStatus == KitOrderStatusEnum.Completed
            ? Colors.amber.shade800
            : kSecondaryColor;
    return Container(
      margin: EdgeInsets.only(right: 12, bottom: 12),
      height: size.getH(700),
      padding: EdgeInsets.fromLTRB(size.getW(8), size.getH(12), 0, 0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.customerName ?? 'Anonymous',
                      style: TextStyle(
                        fontSize: size.getS(18),
                        fontFamily: kFontFMedium,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      data.orderedDate ?? '',
                      style: TextStyle(
                        fontSize: size.getS(15),
                        fontFamily: kFontFMedium,
                        // fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.blue.withAlpha(60),
                    borderRadius: BorderRadius.circular(5)),
                padding: EdgeInsets.symmetric(
                    vertical: size.getH(4), horizontal: size.getW(12)),
                child: Text(
                  data.orderType ?? '',
                  style: TextStyle(
                    fontSize: size.getS(15),
                    fontFamily: kFontFMedium,
                    color: Colors.blue.shade800,
                  ),
                ),
              ),
              // Container(
              //   decoration: BoxDecoration(
              //       color: Colors.green.withAlpha(60),
              //       borderRadius: BorderRadius.circular(5)),
              //   padding: EdgeInsets.symmetric(
              //       vertical: size.getH(4), horizontal: size.getW(12)),
              //   child: Text(
              //     'New Order',
              //     style: TextStyle(
              //       fontSize: size.getS(15),
              //       fontFamily: kFontFMedium,
              //       color: Colors.green.shade800,
              //     ),
              //   ),
              // ),
            ],
          ),
          // SizedBox(
          //   height: size.getH(4),
          // ),
          Text(
            data.orderNumber ?? '',
            style: TextStyle(
              fontSize: size.getS(16),
              fontFamily: kFontFMedium,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (priotize != null)
            InkWell(
              onTap: () => priotize(isPriority),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: isPriority
                        ? Colors.green.withAlpha(60)
                        : Colors.red.withAlpha(60),
                    borderRadius: BorderRadius.circular(5)),
                padding: EdgeInsets.symmetric(vertical: size.getH(2)),
                alignment: Alignment.center,
                child: Text(
                  isPriority ? 'PRIORITIZED' : 'PRIORITIZE ORDER',
                  style: TextStyle(
                    fontSize: size.getS(14),
                    fontFamily: kFontFMedium,
                    color: isPriority
                        ? Colors.green.shade800
                        : Colors.red.shade800,
                  ),
                ),
              ),
            ),
          Expanded(
              child: ListViewObserver(
            controller: observerController,
            child: Scrollbar(
              controller: _scrollCltr,
              thumbVisibility: true,
              trackVisibility: true,
              thickness: 8,
              radius: Radius.circular(5),
              interactive: true,
              child: ListView(
                controller: _scrollCltr,
                shrinkWrap: true,
                padding: EdgeInsets.only(right: size.getW(12)),
                children: [
                  // _subOrderDetailTile(size,
                  //     title: "Order Date :",
                  //     value: _data.orderDetailsViewModel?.orderedDate),
                  // _subOrderDetailTile(
                  //   size,
                  //   title: "Order Type : ",
                  //   value: _data.orderDetailsViewModel?.orderType,
                  //   isStatus: true,
                  //   statusColor: Colors.blue,
                  // ),

                  _subOrderDetailTile(size,
                      title: "${LN.servedBy} :", value: data.servedBy),
                  // if (_data.tableNumber?.isNotEmpty ?? false)
                  //   _subOrderDetailTile(size,
                  //       title: "Table :", value: _data.tableNumber),
                  if (data.pickUpDeliveryDate?.isNotEmpty ?? false)
                    _subOrderDetailTile(size,
                        title: "PickUp/Delivery Date :",
                        value: data.pickUpDeliveryDate),
                  // if (_data
                  //         .orderDetailsViewModel?.deliveryAddress?.isNotEmpty ??
                  //     false)
                  //   _subOrderDetailTile(size,
                  //       title: "Delivery Address :",
                  //       value: _data.orderDetailsViewModel?.deliveryAddress),

                  // if (_data.productWithGroupPriceDetailsViewModel != null)
                  //   ...List.generate(
                  //       _data.productWithGroupPriceDetailsViewModel!.length,
                  //       (i) {
                  //     if (_data.productWithGroupPriceDetailsViewModel![i]
                  //             .productWithPriceDetailsViewModel !=
                  //         null)
                  //       return Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: List.generate(
                  //             _data
                  //                 .productWithGroupPriceDetailsViewModel![i]
                  //                 .productWithPriceDetailsViewModel!
                  //                 .length, (j) {
                  //           final _item = _data
                  //               .productWithGroupPriceDetailsViewModel![i]
                  //               .productWithPriceDetailsViewModel![j];

                  //           return _itemViewDetail(
                  //             size,
                  //             itemView: ItemViewModel(
                  //               index: j + 1,
                  //               headerTitle:
                  //                   j == 0 ? _item.docketGroupName : null,
                  //               title: _item.name,
                  //               quantity: _item.quantity,
                  //               description: _item.description,
                  //               modifierList:
                  //                   _item.orderItemsPriceModifierViewModels
                  //                       ?.map((e) => ItemModifierViewModel(
                  //                             labelName: e.labelName,
                  //                             title: e.modifierName,
                  //                             quantity: e.quantity?.toString(),
                  //                           ))
                  //                       .toList(),
                  //               removeIngres: _item
                  //                   .removedOrderItemIngredientViewModels
                  //                   ?.map((e) => e.name)
                  //                   .toList(),
                  //               spice:
                  //                   _item.orderItemSpiceChoiceViewModel?.name,
                  //               dataLength: _data
                  //                   .productWithGroupPriceDetailsViewModel![i]
                  //                   .productWithPriceDetailsViewModel!
                  //                   .length,
                  //             ),
                  //           );
                  //         }),
                  //       );
                  //     else
                  //       return SizedBox.shrink();
                  //   }),
                  //
                  if (data.orderItems?.isNotEmpty ?? false) ...[
                    Text(
                      "-----------------------------------------------------",
                      maxLines: 1,
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: size.getW(12)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              LN.items,
                              style: TextStyle(
                                fontSize: size.getS(18),
                                fontFamily: kFontFMedium,
                                color: Colors.black,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          Text(
                            LN.qty,
                            style: TextStyle(
                              fontSize: size.getS(18),
                              fontFamily: kFontFMedium,
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                            ),
                          )
                        ],
                      ),
                    ),
                    ...List.generate(data.orderItems!.length, (i) {
                      final item = data.orderItems![i];
                      final showDocName = (i == 0 ||
                              data.orderItems![i - 1].docketGroupName !=
                                  data.orderItems![i].docketGroupName) &&
                          (item.docketGroupName?.isNotEmpty ?? false);
                      final isdDocketPrepared = showDocName &&
                          data.orderItems!
                              .where((e) =>
                                  e.docketGroupName == item.docketGroupName)
                              .every((f) => f.isPrepared ?? false);

                      return _itemViewDetail(
                        size,
                        itemView: ItemViewModel(
                          index: i + 1,
                          headerTitle:
                              showDocName ? item.docketGroupName : null,
                          isDocketPrepared: isdDocketPrepared,
                          title: item.itemName,
                          quantity: item.quantity,
                          description: item.description,
                          isCancelled: item.isCancelled,
                          modifierList: item.orderItemModifiers
                              ?.map((e) => ItemModifierViewModel(
                                    labelName: e.labelName,
                                    title: e.modifierName,
                                    quantity: e.quantity?.toString(),
                                  ))
                              .toList(),
                          removeIngres: item.orderItemRemovedIngredients
                              ?.map((e) => e.name)
                              .toList(),
                          dataLength: data.orderItems!.length,
                          spice:
                              (item.orderItemSpiceChoices?.isNotEmpty ?? false)
                                  ? item.orderItemSpiceChoices?.first.name
                                  : null,
                          isPrepared: item.isPrepared ?? false,
                          onTapItem: () async {
                            if (item.isPrepared ?? false) {
                              showDialog(
                                  context: context,
                                  builder: (_) {
                                    return ConfirmDialog(
                                      title: "Revert Item Status?",
                                      subTitle:
                                          "You can change the item status if it's not ready yet.",
                                      actionText: LN.yes,
                                      cancelText: LN.no,
                                      onDelete: () async {
                                        widget.kitPro?.orderItemStatusUpdate(
                                          orderId: data.id,
                                          itemId: item.id,
                                          orderNum: data.orderNumber,
                                          isSetmenu: false,
                                          isPrepared: false,
                                        );
                                        return null;
                                      },
                                    );
                                  });
                            } else {
                              final status =
                                  await widget.kitPro?.orderItemStatusUpdate(
                                orderId: data.id,
                                itemId: item.id,
                                orderNum: data.orderNumber,
                                isSetmenu: false,
                                isPrepared: true,
                              );

                              if (status == 2) return;

                              //TODO: sorting

                              final pCount = data.orderItems!.fold<int>(
                                  0,
                                  (pV, eV) =>
                                      pV + ((eV.isPrepared ?? false) ? 1 : 0));

                              final index =
                                  ((data.pickUpDeliveryDate?.isNotEmpty ??
                                              false)
                                          ? 1
                                          : 0) +
                                      4 +
                                      pCount;

                              _scrollToNextItem(index);
                            }
                          },
                        ),
                      );
                    })
                  ],

                  if (data.setMenuOrders?.isNotEmpty ?? false) ...[
                    Text(
                      "-----------------------------------------------------",
                      maxLines: 1,
                    ),
                    // Text(
                    //   "=========================================",
                    //   maxLines: 1,
                    // ),
                    Padding(
                      padding: EdgeInsets.only(right: size.getW(12)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              "Combo Items",
                              style: TextStyle(
                                fontSize: size.getS(18),
                                fontFamily: kFontFMedium,
                                color: Colors.black,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          Text(
                            LN.qty,
                            style: TextStyle(
                              fontSize: size.getS(18),
                              fontFamily: kFontFMedium,
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                            ),
                          )
                        ],
                      ),
                    ),
                    ...List.generate(data.setMenuOrders!.length, (i) {
                      final combo = data.setMenuOrders![i];
                      return _itemViewDetail(
                        size,
                        itemView: ItemViewModel(
                          index: i + 1,
                          title: combo.setMenuName,
                          quantity: combo.quantity,
                          description: combo.description,
                          isCancelled: combo.isCancelled,
                          // isPrepared: _combo.isPrepared ?? false,
                          // onTapItem: () {
                          //   if (_combo.isPrepared ?? false) {
                          //     showDialog(
                          //         context: context,
                          //         builder: (_) {
                          //           return ConfirmDialog(
                          //             title: "Revert Combo Item Status?",
                          //             subTitle:
                          //                 "You can change the item status if it's not ready yet.",
                          //             actionText: LN.yes,
                          //             cancelText: LN.no,
                          //             onDelete: () async {
                          //               widget.kitPro?.orderItemStatusUpdate(
                          //                 orderId: _data.id,
                          //                 itemId: _combo.id,
                          //                 orderNum: _data.orderNumber,
                          //                 isSetmenu: true,
                          //                 isPrepared: false,
                          //               );
                          //               return null;
                          //             },
                          //           );
                          //         });
                          //   } else {
                          //     widget.kitPro?.orderItemStatusUpdate(
                          //       orderId: _data.id,
                          //       itemId: _combo.id,
                          //       orderNum: _data.orderNumber,
                          //       isSetmenu: true,
                          //       isPrepared: true,
                          //     );

                          //     final _pCount = _data.setMenuOrders!.fold<int>(
                          //         0,
                          //         (pV, eV) =>
                          //             pV + ((eV.isPrepared ?? false) ? 1 : 0));

                          //     final _index =
                          //         ((_data.pickUpDeliveryDate?.isNotEmpty ??
                          //                     false)
                          //                 ? 1
                          //                 : 0) +
                          //             4 +
                          //             (_data.orderItems?.length ?? 0) +
                          //             _pCount;

                          //     _scrollToNextItem(_index);
                          //   }
                          // },
                          comboItems: combo.setMenuOrderItems
                              ?.map(
                                (e) => ItemViewModel(
                                  index: 0,
                                  title: e.itemName,
                                  quantity: e.quantity,
                                  description: e.description,
                                  modifierList: e.setMenuOrderItemModifiers
                                      ?.map((e) => ItemModifierViewModel(
                                            labelName: e.labelName,
                                            title: e.modifierName,
                                            quantity: e.quantity?.toString(),
                                          ))
                                      .toList(),
                                  removeIngres: e
                                      .setMenuOrderItemRemovedIngredients
                                      ?.map((e) => e.name)
                                      .toList(),
                                  // spice: e.orderItemSpiceChoiceViewModel?.name,
                                  dataLength: combo.setMenuOrderItems?.length,
                                  isPrepared: e.isPrepared ?? false,
                                  onTapItem: () {
                                    if (e.isPrepared ?? false) {
                                      showDialog(
                                          context: context,
                                          builder: (_) {
                                            return ConfirmDialog(
                                              title:
                                                  "Revert Combo's item Status?",
                                              subTitle:
                                                  "You can change the item status if it's not ready yet.",
                                              actionText: LN.yes,
                                              cancelText: LN.no,
                                              onDelete: () async {
                                                widget.kitPro
                                                    ?.orderItemStatusUpdate(
                                                  orderId: data.id,
                                                  itemId: e.id,
                                                  orderNum: data.orderNumber,
                                                  isSetmenu: true,
                                                  isPrepared: false,
                                                );
                                                return null;
                                              },
                                            );
                                          });
                                    } else {
                                      widget.kitPro?.orderItemStatusUpdate(
                                        orderId: data.id,
                                        itemId: e.id,
                                        orderNum: data.orderNumber,
                                        isSetmenu: true,
                                        isPrepared: true,
                                      );

                                      // final _pCount = _data.setMenuOrders!
                                      //     .fold<int>(
                                      //         0,
                                      //         (pV, eV) =>
                                      //             pV +
                                      //             ((eV.isPrepared ?? false)
                                      //                 ? 1
                                      //                 : 0));

                                      // final _index = ((_data.pickUpDeliveryDate
                                      //                 ?.isNotEmpty ??
                                      //             false)
                                      //         ? 1
                                      //         : 0) +
                                      //     4 +
                                      //     (_data.orderItems?.length ?? 0) +
                                      //     _pCount;

                                      // _scrollToNextItem(_index);
                                    }
                                  },
                                ),
                              )
                              .toList(),
                          dataLength: data.setMenuOrders!.length,
                        ),
                      );
                    })
                  ],
                ],
              ),
            ),
          )),
          ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                    widget.onStart == null ? Colors.grey : btnColor),
                padding: WidgetStateProperty.all(
                  EdgeInsets.symmetric(
                    horizontal: size.getW(12),
                    // vertical: size.getH(8.0)
                  ),
                ),
                visualDensity: VisualDensity.compact,
              ),
              onPressed: widget.onStart,
              child: Text(
                btnText,
                style: TextStyle(
                  fontSize: size.getS(16),
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ))

          // showDialog(
          //     context: context,
          //     builder: (_) => SimpleDialog(
          //           // backgroundColor: kPrimaryColor,
          //           titlePadding: EdgeInsets.zero,
          //           contentPadding: EdgeInsets.symmetric(
          //               horizontal: size.getW(12),
          //               vertical: size.getH(12)),
          //           shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(15)),
          //           children: [KitchenView()],
          //         ));
        ],
      ),
    );
  }

  Widget _subOrderDetailTile(
    Ssize size, {
    String? title,
    String? value,
    bool isStatus = false,
    Color statusColor = Colors.blue,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: size.getH(4)),
      child: Row(
        children: [
          Flexible(
            flex: 4,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title ?? '',
                style: TextStyle(
                  fontSize: size.getS(16),
                  fontFamily: kFontFMedium,
                  color: Colors.black,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Align(
              alignment: Alignment.centerRight,
              child: isStatus
                  ? Container(
                      decoration: BoxDecoration(
                          color: statusColor.withAlpha(60),
                          borderRadius: BorderRadius.circular(5)),
                      padding: EdgeInsets.symmetric(
                          vertical: size.getH(4), horizontal: size.getW(12)),
                      child: Text(
                        value ?? '',
                        style: TextStyle(
                          fontSize: size.getS(15),
                          fontFamily: kFontFMedium,
                          color: statusColor == Colors.blue
                              ? Colors.blue.shade800
                              : statusColor == Colors.red
                                  ? Colors.red.shade800
                                  : statusColor == Colors.amber
                                      ? Colors.amber.shade800
                                      : Colors.green.shade800,
                        ),
                      ),
                    )
                  : Text(
                      value ?? '',
                      style: TextStyle(
                        fontSize: size.getS(16),
                        fontFamily: kFontFMedium,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.right,
                    ),
            ),
          )
        ],
      ),
    );
  }

  Widget _itemViewDetail(
    Ssize size, {
    ItemViewModel? itemView,
  }) {
    if (itemView == null) return SizedBox.shrink();

    itemView.modifierList
        ?.sort((a, b) => a.labelName?.compareTo(b.labelName ?? '') ?? 0);
    final isPrepared = (widget.kitStatus == KitOrderStatusEnum.Preparing &&
            itemView.isPrepared) ||
        widget.kitStatus == KitOrderStatusEnum.Completed;

    final isCancel = itemView.isCancelled ?? false;
    return Padding(
      padding: EdgeInsets.only(right: itemView.index == 0 ? 0 : size.getW(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (itemView.index - 1 != 0 &&
              itemView.index - 1 != itemView.dataLength &&
              itemView.index != 0)
            Divider(
              // height: size.getH(12),
              color: Colors.black87,
            ),
          if (itemView.headerTitle != null) ...[
            Text(
              (itemView.headerTitle ?? ''),
              style: TextStyle(
                fontSize: size.getS(20),
                fontFamily: kFontFMedium,
                color: (itemView.isDocketPrepared &&
                            widget.kitStatus == KitOrderStatusEnum.Preparing) ||
                        widget.kitStatus == KitOrderStatusEnum.Completed
                    ? Colors.black38
                    : Colors.black,
              ),
            ),
            Divider(height: 4),
          ],
          if (isCancel)
            Container(
              decoration: BoxDecoration(
                color: Colors.red.withAlpha(60),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: size.getW(12), vertical: size.getH(2)),
              child: Text(
                "Cancelled",
                style: TextStyle(
                  fontSize: size.getS(15),
                  fontFamily: kFontFMedium,
                  color: Colors.red.shade800,
                ),
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                (itemView.index == 0 ? ' + ' : '${itemView.index}. '),
                style: TextStyle(
                  fontSize: size.getS(18),
                  fontFamily: kFontFMedium,
                  color: isCancel
                      ? Colors.red
                      : isPrepared
                          ? Colors.black38
                          : Colors.black,
                ),
              ),
              Expanded(
                flex: 7,
                child: InkWell(
                  onTap:
                      // itemView.index != 0
                      itemView.comboItems == null &&
                              widget.kitStatus ==
                                  KitOrderStatusEnum.Preparing &&
                              !isCancel
                          ? itemView.onTapItem
                          : null,
                  child: Text(
                    itemView.title ?? '',
                    style: TextStyle(
                      fontSize: size.getS(18),
                      fontFamily: kFontFMedium,
                      color: isCancel
                          ? Colors.red
                          : (isPrepared ? Colors.black38 : Colors.black),
                      decoration: isCancel ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ),
              ),
              if (
                  // itemView.index != 0
                  itemView.comboItems == null) ...[
                if (!isCancel) ...[
                  if (widget.kitStatus == KitOrderStatusEnum.Preparing)
                    InkWell(
                      onTap: itemView.onTapItem,
                      borderRadius: BorderRadius.circular(40),
                      splashColor: Colors.green.withAlpha(50),
                      child: isPrepared
                          ? Icon(
                              Icons.check_circle_rounded,
                              size: size.getS(28),
                              color: Colors.green,
                            )
                          : Icon(
                              Icons.check_circle_rounded,
                              size: size.getS(28),
                              color: Colors.grey,
                            ),
                    )
                  else if (widget.kitStatus == KitOrderStatusEnum.Completed)
                    Icon(
                      Icons.check_circle_rounded,
                      size: size.getS(28),
                      color: Colors.green,
                    )
                ],
                Flexible(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      itemView.quantity?.inQty ?? '',
                      style: TextStyle(
                        fontSize: size.getS(18),
                        fontFamily: kFontFMedium,
                        color: isCancel
                            ? Colors.red
                            : isPrepared
                                ? Colors.black38
                                : Colors.black,
                      ),
                    ),
                  ),
                )
              ]
            ],
          ),
          if (itemView.comboItems != null)
            ...List.generate(
              itemView.comboItems!.length,
              (i) => _itemViewDetail(size, itemView: itemView.comboItems![i]),
            )
          else ...[
            if (itemView.spice?.isNotEmpty ?? false)
              Padding(
                padding: EdgeInsets.only(
                  left: size.getW(12),
                  top: size.getH(6),
                ),
                child: Text(
                  "Spice : ${itemView.spice ?? ''}",
                  style: TextStyle(
                    fontSize: size.getS(16),
                    fontFamily: kFontFRegular,
                    color: isPrepared ? Colors.black38 : Colors.black,
                    height: 1.15,
                  ),
                ),
              ),
            if (itemView.removeIngres?.isNotEmpty ?? false)
              Padding(
                padding: EdgeInsets.only(
                  left: size.getW(12),
                  top: size.getH(6),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Remove ingredients:",
                      style: TextStyle(
                        fontSize: size.getS(16),
                        fontWeight: FontWeight.bold,
                        height: 1.15,
                        color: isPrepared ? Colors.black38 : Colors.black,
                      ),
                    ),
                    ...List.generate(itemView.removeIngres!.length, (i) {
                      return Text(
                        "- ${itemView.removeIngres?[i] ?? ''}",
                        style: TextStyle(
                          fontSize: size.getS(16),
                          fontFamily: kFontFRegular,
                          color: isPrepared ? Colors.black38 : Colors.black,
                          height: 1.15,
                        ),
                      );
                    })
                  ],
                ),
              ),
            if (itemView.modifierList?.isNotEmpty ?? false)
              Padding(
                padding: EdgeInsets.only(left: size.getW(12)),
                child: Column(
                  children: List.generate(
                    itemView.modifierList!.length,
                    (j) {
                      final showLabel = j == 0 ||
                          itemView.modifierList![j - 1].labelName !=
                              itemView.modifierList![j].labelName;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (showLabel) ...[
                            SizedBox(
                              height: size.getH(6),
                            ),
                            Text(
                              "${itemView.modifierList![j].labelName}",
                              style: TextStyle(
                                fontSize: size.getS(16),
                                fontWeight: FontWeight.bold,
                                height: 1.15,
                                color:
                                    isPrepared ? Colors.black38 : Colors.black,
                              ),
                            )
                          ],
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "+ ",
                                style: TextStyle(
                                  fontSize: size.getS(16),
                                  fontFamily: kFontFRegular,
                                  color: isPrepared
                                      ? Colors.black38
                                      : Colors.black,
                                  height: 1.15,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  itemView.modifierList![j].title ?? '',
                                  style: TextStyle(
                                    fontSize: size.getS(16),
                                    fontFamily: kFontFRegular,
                                    color: isPrepared
                                        ? Colors.black38
                                        : Colors.black,
                                    height: 1.15,
                                  ),
                                ),
                              ),
                              Text(
                                itemView.modifierList![j].quantity?.inQty ?? '',
                                style: TextStyle(
                                  fontSize: size.getS(16),
                                  fontFamily: kFontFRegular,
                                  color: isPrepared
                                      ? Colors.black38
                                      : Colors.black,
                                  height: 1.15,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            if (itemView.description?.isNotEmpty ?? false)
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    // border: Border.all(),
                    borderRadius: BorderRadius.circular(5)),
                // padding: EdgeInsets.symmetric(
                //     vertical: size.getH(2), horizontal: size.getW(12)),
                child: Text(
                  'Description: ${itemView.description}',
                  style: TextStyle(
                    fontSize: size.getS(15),
                    fontFamily: kFontFMedium,
                    color: isPrepared
                        ? Colors.yellow.shade200
                        : Colors.yellow.shade900,
                  ),
                ),
              ),
            // ElevatedButton(
            //     style: ButtonStyle(
            //       backgroundColor:
            //           WidgetStateProperty.all(Colors.red.shade700),
            //       padding: WidgetStateProperty.all(
            //         EdgeInsets.symmetric(
            //           horizontal: size.getW(12),
            //           // vertical: size.getH(8.0)
            //         ),
            //       ),
            //       visualDensity: VisualDensity.compact,
            //     ),
            //     onPressed: () {},
            //     child: Text(
            //       "Complete",
            //       style: TextStyle(
            //         fontSize: size.getS(16),
            //         color: Colors.white,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     )),
            // if (itemView.index != 0 && itemView.index != itemView.dataLength)
            //   Divider(
            //     // height: size.getH(12),
            //     color: Colors.black87,
            //   )
          ]
        ],
      ),
    );
  }
}

class ItemViewModel {
  final int index;

  final String? headerTitle;
  final bool isDocketPrepared;
  final String? title;
  final String? quantity;
  final String? description;
  final List<ItemModifierViewModel>? modifierList;
  final List<ItemViewModel>? comboItems;
  final List<String?>? removeIngres;
  final String? spice;
  final int? dataLength;
  final bool isPrepared;
  final Function()? onTapItem;
  final bool? isCancelled;

  ItemViewModel({
    required this.index,
    this.headerTitle,
    this.isDocketPrepared = false,
    this.title,
    this.quantity,
    this.description,
    this.modifierList,
    this.comboItems,
    this.removeIngres,
    this.spice,
    this.dataLength,
    this.isPrepared = false,
    this.onTapItem,
    this.isCancelled,
  });
}

class ItemModifierViewModel {
  final String? labelName;
  final String? title;
  final String? quantity;

  ItemModifierViewModel({
    this.labelName,
    this.title,
    this.quantity,
  });
}
