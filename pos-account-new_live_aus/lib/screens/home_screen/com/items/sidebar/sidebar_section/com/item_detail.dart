// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/order_utils.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/menu/place_order_pro.dart';
import 'package:pos_account/widgets/image/image_error.dart';
import 'package:provider/provider.dart';
import '../../../../../../../ln.dart';
import '../../../../../../../model/common/table_location.dart';
import '../../../../../../../widgets/dialog/custom_dialog.dart';
import '../../../com/cus_expansion.dart';

enum ItemStatus {
  None,
  BatchExpire,
  Paid,
  PartialPaid,
  Pending,
  Preparing,
  Prepared
}

class ItemDetail extends StatelessWidget {
  final String? imgPath;
  final String title;
  final List<String?>? modifier;
  final List<String?>? ingredients;
  final bool? isOrderItem;
  final double price;
  final double quantity;
  final double? total;
  final Function()? onDelete;
  final TextEditingController? descCltr;
  final String hintText;
  final Function(String?)? onChangedDesc;
  final Function()? onTap;
  final Function()? onTapDes;
  final String? curSym;
  final Function()? updateQtyUp;
  final Function()? updateQtyDown;
  final Function()? onTapQty;
  final Function()? onTapPrice;
  // final bool isHalfItem;
  final List<ComboItem>? comboItem;
  final ItemStatus itemStatus;
  final bool isOutOfStock;
  final String? outOfStockMessage;
  final String? docketGroupName;
  final List<TableLocation>? docketGroupList;
  final int? orderListIndex;
  final OrderStatusEnum statusEnum;
  final bool isItemView;
  final bool isSecondScreen;

  const ItemDetail({
    super.key,
    this.imgPath,
    required this.title,
    required this.price,
    this.isOrderItem = false,
    this.quantity = 1,
    this.total,
    this.onDelete,
    this.descCltr,
    this.hintText = "",
    this.onChangedDesc,
    this.onTap,
    this.onTapDes,
    this.curSym,
    this.modifier,
    this.updateQtyUp,
    this.updateQtyDown,
    this.onTapQty,
    this.onTapPrice,
    // this.isHalfItem = false,
    this.ingredients,
    this.comboItem,
    this.itemStatus = ItemStatus.None,
    this.isOutOfStock = false,
    required this.outOfStockMessage,
    this.docketGroupName,
    this.docketGroupList,
    this.orderListIndex,
    this.statusEnum = OrderStatusEnum.none,
    this.isItemView = false,
    this.isSecondScreen = false,
  });

  double get fontUp => isSecondScreen ? 2 : 0;

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final String _qty = quantity / quantity.round() == 1
        ? quantity.round().toString()
        : quantity.toString();

    String _comboProductRootName = "";

    return Padding(
      padding: EdgeInsets.only(
          top: size.getH(isItemView ? 4 : 16),
          bottom: size.getH(isItemView ? 0 : 8),
          right: size.getW(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // if (isOutOfStock)
          AnimatedContainer(
              margin: EdgeInsets.only(left: size.getW(60)),
              duration: Duration(milliseconds: 400),
              height: isOutOfStock && (outOfStockMessage?.isNotEmpty ?? false)
                  ? size.getH(28)
                  : 0,
              decoration: BoxDecoration(
                color: Colors.red.withAlpha(50),
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: size.getW(12), vertical: size.getH(4)),
              child: Text(
                outOfStockMessage ?? '',
                style: TextStyle(
                  color: Colors.red.shade800,
                  fontSize: size.getS(14 + fontUp),
                  fontFamily: kFontFMedium,
                ),
                textAlign: TextAlign.center,
              )),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imgPath != null) ...[
                InkWell(
                  onTap: () {
                    if (isOrderItem == true && !GlobalCVP.isRetailStore)
                      CustomDialog.showCustomDialog(
                        backgroundColor: Colors.white,
                        titleSize: 20,
                        title: "Choose Docket Group",
                        context: context,
                        content: DocketChooseDia(
                          docketGroupSort: (docketGroupList?.any((element) =>
                                      element.name?.toLowerCase() ==
                                      docketGroupName?.toLowerCase()) ??
                                  false)
                              ? docketGroupList!
                                  .firstWhere((element) =>
                                      element.name?.toLowerCase() ==
                                      docketGroupName?.toLowerCase())
                                  .additionalValue
                              : '',
                          docketGroupName: docketGroupName ?? '',
                          docketGroupList: docketGroupList,
                          orderListIndex: orderListIndex!,
                          docketGroupId: (docketGroupList?.any((element) =>
                                      element.name?.toLowerCase() ==
                                      docketGroupName?.toLowerCase()) ??
                                  false)
                              ? docketGroupList!
                                  .firstWhere((element) =>
                                      element.name?.toLowerCase() ==
                                      docketGroupName?.toLowerCase())
                                  .id!
                              : '',
                        ),
                      );
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                              imageUrl: imgPath!,
                              height: size.getW(48),
                              width: size.getW(48),
                              fit: BoxFit
                                  .cover, // Changed to cover to fill the space
                              placeholder: (_, __) =>
                                  ImageError.notSupportIcon(_, __, __),
                              errorWidget: (docketGroupName != null &&
                                      docketGroupName!.isNotEmpty)
                                  ? (context, url, error) => Container()
                                  : ImageError.notSupportIcon)),
                      if (docketGroupName != null &&
                          docketGroupName!.isNotEmpty)
                        Container(
                          width: size.getW(48),
                          height: size.getW(48),
                          decoration: BoxDecoration(
                            color: Colors.black.withAlpha(120),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            docketGroupName?.substring(0, 1) ?? "",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16 + fontUp,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  width: size.getW(12),
                )
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: onTap,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (comboItem == null)
                                  _itemDetail(
                                    size,
                                    itemTitle: title,
                                    itemModifier: modifier,
                                    itemIngreList: ingredients,
                                  )
                                else
                                  CusExpansion(
                                    title: _itemDetail(
                                      size,
                                      itemTitle: title,
                                      itemModifier: modifier,
                                      itemIngreList: ingredients,
                                    ),
                                    showMoreText: "View Items",
                                    showLessText: "Hide Items",
                                    initiallyExpanded: isItemView,
                                    children:
                                        List.generate(comboItem!.length, (i) {
                                      bool _isComboProductRootNameSame =
                                          _comboProductRootName.isNotEmpty &&
                                              _comboProductRootName ==
                                                  comboItem![i].rootName;
                                      if (_comboProductRootName !=
                                          comboItem![i].rootName) {
                                        _comboProductRootName =
                                            comboItem![i].rootName ?? '';
                                      }

                                      return Padding(
                                        padding: EdgeInsets.only(
                                            left:
                                                isItemView ? size.getW(12) : 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: _itemDetail(
                                                size,
                                                itemTitle: comboItem![i]
                                                            .title ==
                                                        null
                                                    ? null
                                                    : "${i + 1}. ${comboItem![i].title}",
                                                itemModifier:
                                                    comboItem![i].modifier,
                                                itemIngreList:
                                                    comboItem![i].ingredients,
                                                isCombo: true,
                                                quantity:
                                                    comboItem![i].quantity,
                                                rootName:
                                                    _isComboProductRootNameSame
                                                        ? null
                                                        : comboItem![i]
                                                            .rootName,
                                              ),
                                            ),
                                            if (comboItem![i].itemStatus !=
                                                ItemStatus.None)
                                              _itemStatus(
                                                  size,
                                                  comboItem![i].itemStatus,
                                                  false),
                                            if (comboItem!.length - 1 != i)
                                              Divider(
                                                color: Colors.black87,
                                                thickness: 0.5,
                                              ),
                                          ],
                                        ),
                                      );
                                    }),
                                  ),
                                if (itemStatus != ItemStatus.None &&
                                    !isItemView)
                                  _itemStatus(size, itemStatus, isItemView),
                                // if (comboItem?.isNotEmpty ?? false)
                                //   ...List.generate(comboItem!.length, (i) {
                                //     return Column(
                                //       crossAxisAlignment:
                                //           CrossAxisAlignment.start,
                                //       mainAxisSize: MainAxisSize.min,
                                //       children: [
                                //         _itemDetail(
                                //           size,
                                //           itemTitle:
                                //               "${i + 1}. ${comboItem![i].title}",
                                //           itemModifier: comboItem![i].modifier,
                                //           itemIngreList:
                                //               comboItem![i].ingredients,
                                //           isCombo: true,
                                //         ),
                                //         if (comboItem!.length - 1 != i)
                                //           Divider(
                                //             color: Colors.black87,
                                //             thickness: 0.5,
                                //           ),
                                //       ],
                                //     );
                                //   })
                              ],
                            ),
                          ),
                        ),
                        // if (!isHalfItem)
                        if (!isItemView)
                          _disableSection(
                            readOnly: !isSecondScreen &&
                                (updateQtyDown == null || updateQtyUp == null),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: updateQtyDown,
                                  child: Card(
                                    margin: EdgeInsets.only(left: size.getW(6)),
                                    color: updateQtyDown == null
                                        ? Colors.grey.shade400
                                        : kSecondaryColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: size.getH(7),
                                          horizontal: size.getW(13)),
                                      child: Text(
                                        '-',
                                        style: TextStyle(
                                          fontSize: size.getS(16),
                                          fontFamily: kFontFBold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: onTapQty,
                                  child: Card(
                                    margin: EdgeInsets.only(left: size.getW(6)),
                                    color: kSecondaryColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: size.getH(7),
                                          horizontal: size.getW(15)),
                                      child: Text(
                                        _qty,
                                        style: TextStyle(
                                          fontSize: size.getS(16),
                                          fontFamily: kFontFBold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: updateQtyUp,
                                  child: Card(
                                    margin: EdgeInsets.only(left: size.getW(6)),
                                    color: updateQtyUp == null
                                        ? Colors.grey.shade400
                                        : kSecondaryColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: size.getH(7),
                                          horizontal: size.getW(13)),
                                      child: Text(
                                        '+',
                                        style: TextStyle(
                                          fontSize: size.getS(16),
                                          fontFamily: kFontFBold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        else if (itemStatus != ItemStatus.None)
                          _itemStatus(size, itemStatus, isItemView)
                      ],
                    ),
                    // if (!isHalfItem)
                    if (!isItemView)
                      _disableSection(
                        readOnly: !isSecondScreen && onTap == null,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                InkWell(
                                  onTap: onTapPrice,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        (curSym ?? '') + price.roundToNString(),
                                        style: TextStyle(
                                          fontSize: size.getS(16 + fontUp),
                                          color: Colors.black,
                                        ),
                                        maxLines: 1,
                                      ),
                                      if (onTapPrice != null) ...[
                                        SizedBox(
                                          width: size.getW(8),
                                        ),
                                        Icon(
                                          Icons.edit_sharp,
                                          color: Colors.grey,
                                          size: size.getW(25 + fontUp),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: size.getW(8),
                                ),
                                if (descCltr != null)
                                  InkWell(
                                      onTap: onChangedDesc == null
                                          ? null
                                          : () {
                                              CustomDialog.showNotesDialog(
                                                title: LN.addNote,
                                                context: context,
                                                descCltr: descCltr!,
                                                onChangedDesc: (text) {
                                                  onChangedDesc!(text);
                                                },
                                              );
                                            },
                                      child: Row(
                                        children: [
                                          Text(
                                            LN.addNote,
                                            style: TextStyle(
                                              fontSize: size.getS(12 + fontUp),
                                            ),
                                          ),
                                          SizedBox(
                                            width: size.getW(8),
                                          ),
                                          Icon(
                                            Icons.edit_note,
                                            size: size.getW(25 + fontUp),
                                            color: Colors.grey,
                                          ),
                                        ],
                                      )),
                              ],
                            ),
                            if (!isItemView)
                              Flexible(
                                child: Text(
                                  total == null
                                      ? ""
                                      : (curSym ?? '') +
                                          (total ?? 0).roundToNString(),
                                  style: TextStyle(
                                    fontSize: size.getS(16 + fontUp),
                                    color: Colors.black,
                                    fontFamily: kFontFBold,
                                  ),
                                  maxLines: 2,
                                ),
                              ),
                          ],
                        ),
                      ),
                    if (descCltr?.text.isNotEmpty ?? false)
                      Padding(
                        padding: EdgeInsets.only(
                          top: size.getH(8),
                        ),
                        child: IntrinsicHeight(
                          child: InkWell(
                            onTap: isItemView
                                ? null
                                : () {
                                    CustomDialog.showNotesDialog(
                                      title: LN.addNote,
                                      context: context,
                                      descCltr: descCltr!,
                                      onChangedDesc: (text) {
                                        onChangedDesc!(text);
                                      },
                                    );
                                  },
                            child: Container(
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.grey.shade300,
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: size.getH(4)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Text(
                                    //   LN.notes,
                                    //   style: TextStyle(
                                    //     fontSize: size.getS(14),
                                    //     fontFamily: kFontFMedium,
                                    //   ),
                                    // ),
                                    // SizedBox(
                                    //   width: size.getW(8),
                                    // ),
                                    Flexible(
                                      child: Text(
                                        descCltr!.text,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontSize: size.getS(14 + fontUp),
                                          color: Colors.black,
                                          fontFamily: kFontFMedium,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (statusEnum == OrderStatusEnum.hold ||
                        statusEnum == OrderStatusEnum.cancel)
                      Container(
                        decoration: BoxDecoration(
                          color: statusEnum == OrderStatusEnum.hold
                              ? Colors.amber.shade800
                              : Colors.red,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: size.getW(12), vertical: size.getH(2)),
                        child: Text(
                          statusEnum == OrderStatusEnum.hold
                              ? "onHold"
                              : "Cancelled",
                          style: TextStyle(
                            fontSize: size.getS(14 + fontUp),
                            color: Colors.white,
                            fontFamily: kFontFMedium,
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _itemStatus(Ssize size, ItemStatus _itemStatus, bool _itemView) {
    // final _orderItem
    if (statusEnum == OrderStatusEnum.cancel) return SizedBox.square();
    return Container(
      decoration: _itemView
          ? BoxDecoration(
              color: _itemStatus == ItemStatus.BatchExpire
                  ? Colors.red.shade700
                  : _itemStatus == ItemStatus.Preparing
                      ? Colors.orange.shade700
                      : Colors.green.shade700,
              borderRadius: BorderRadius.circular(25))
          : null,
      padding: _itemView
          ? EdgeInsets.symmetric(
              horizontal: size.getW(12), vertical: size.getH(4))
          : null,
      child: Text(
        _itemStatus == ItemStatus.BatchExpire
            ? 'Batch Expired'
            : _itemStatus == ItemStatus.Paid
                ? LN.paid
                : _itemStatus == ItemStatus.PartialPaid
                    ? 'Partial Paid'
                    : _itemStatus == ItemStatus.Preparing
                        ? 'Preparing'
                        : _itemStatus == ItemStatus.Prepared
                            ? 'Prepared'
                            : _itemStatus == ItemStatus.Pending
                                ? 'Pending'
                                : '',
        style: TextStyle(
          fontSize: size.getS(14 + fontUp),
          color: _itemView
              ? Colors.white
              : _itemStatus == ItemStatus.BatchExpire
                  ? Colors.red.shade700
                  : _itemStatus == ItemStatus.Preparing
                      ? Colors.orange.shade700
                      : Colors.green.shade700,
          fontFamily: kFontFMedium,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _itemDetail(
    Ssize size, {
    String? itemTitle,
    List<String?>? itemModifier,
    List<String?>? itemIngreList,
    bool isCombo = false,
    String? quantity,
    String? rootName,
  }) {
    final _c = fontUp == 2
        ? 1.2
        : isItemView
            ? 1.2
            : 1.0;
    return _disableSection(
      readOnly: !isSecondScreen && onTap == null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (itemTitle != null)
            Text(
              itemTitle,
              style: TextStyle(
                fontSize: size.getS(isCombo ? 15 : 16) * _c,
                color: Colors.black,
                fontFamily: kFontFMedium,
              ),
            ),
          if ((double.tryParse(quantity ?? '') ?? 0) == 0.5)
            Container(
              decoration: BoxDecoration(
                color: kSecondaryColor.withOpacity(1),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: size.getW(16)),
              child: Text(
                LN.half,
                style: TextStyle(
                  fontSize: size.getS(15) * _c,
                  fontFamily: kFontFMedium,
                  color: Colors.white,
                ),
              ),
            ),
          if (itemModifier?.isNotEmpty ?? false) ...[
            if (rootName != null)
              Text(
                rootName,
                style: TextStyle(
                  fontSize: size.getS(isCombo ? 14.5 : 15) * _c,
                  color: kTempColor,
                  fontFamily: kFontFMedium,
                  decoration: TextDecoration.underline,
                ),
              ),
            // SizedBox(height: size.getH(4)),
            ...List.generate(
                itemModifier!.length,
                (i) => Padding(
                      padding: EdgeInsets.only(
                        top: size.getH(
                            itemModifier[i]!.contains('\n') ? size.getH(2) : 0),
                      ),
                      child: Text(
                        itemModifier[i] ?? '',
                        style: TextStyle(
                          fontSize: size.getS(isCombo ? 14.5 : 15) * _c,
                          color: (itemModifier[i]?.contains(' - ') ?? false)
                              ? Colors.amber.shade900
                              : kTempColor,
                          fontFamily: kFontFMedium,
                          height: 1.3,
                        ),
                      ),
                    ))
          ],
          if (itemIngreList?.isNotEmpty ?? false) ...[
            Text(
              LN.removeIngredients,
              style: TextStyle(
                fontSize: size.getS(isCombo ? 14.5 : 15) * _c,
                color: Colors.amber.shade900,
                fontFamily: kFontFMedium,
                decoration: TextDecoration.underline,
              ),
            ),
            ...List.generate(
                itemIngreList!.length,
                (index) => Text(
                      " - ${itemIngreList[index]}",
                      style: TextStyle(
                        fontSize: size.getS(isCombo ? 14 : 15) * _c,
                        color: Colors.amber.shade900,
                        fontFamily: kFontFMedium,
                      ),
                    ))
          ]
        ],
      ),
    );
  }

  Widget _disableSection({bool readOnly = false, required Widget child}) {
    return IgnorePointer(
      ignoring: readOnly,
      child: Opacity(
        opacity: readOnly ? 0.5 : 1,
        child: child,
      ),
    );
  }
}

class DocketItemInitial extends StatelessWidget {
  final String docketGroupInitial;
  final Function() onTap;

  const DocketItemInitial(
      {required this.docketGroupInitial, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        height: size.getW(48),
        width: size.getW(48),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            docketGroupInitial.isNotEmpty
                ? docketGroupInitial.substring(0, 1)
                : '',
            style: TextStyle(
              fontSize: size.getS(24),
              color: Colors.black,
              fontFamily: kFontFMedium,
            ),
          ),
        ),
      ),
    );
  }
}

class ComboItem {
  final String? imgPath;
  final String? title;
  final List<String?>? modifier;
  final List<String?>? ingredients;
  final String? quantity;
  final String? rootName;
  final ItemStatus itemStatus;

  ComboItem({
    this.imgPath,
    this.title,
    this.modifier,
    this.ingredients,
    this.quantity,
    this.rootName,
    this.itemStatus = ItemStatus.None,
  });
}

class DocketChooseDia extends StatefulWidget {
  final List<TableLocation>? docketGroupList;
  String docketGroupName;
  String docketGroupId;
  dynamic docketGroupSort;
  final int orderListIndex;

  DocketChooseDia(
      {this.docketGroupList,
      required this.orderListIndex,
      required this.docketGroupName,
      required this.docketGroupSort,
      required this.docketGroupId,
      super.key});

  @override
  State<DocketChooseDia> createState() => _DocketChooseDiaState();
}

class _DocketChooseDiaState extends State<DocketChooseDia> {
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final pro = Provider.of<PlaceOrderPro>(context);
    final size = Ssize(context);

    return SizedBox(
      width: size.getW(300),
      child: CupertinoScrollbar(
        // isAlwaysShown: false,
        controller: scrollController,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.docketGroupList?.isEmpty ?? true
                  ? Text(
                      "No Docket Group Found",
                      style: TextStyle(
                        fontSize: size.getS(16),
                        color: CupertinoColors.systemGrey,
                        fontFamily: kFontFMedium,
                      ),
                      textAlign: TextAlign.center,
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: List.generate(
                        widget.docketGroupList?.length ?? 0,
                        (i) => InkWell(
                          onTap: () {
                            pro.setOrderItemDocketGroupName(
                              docketGroupName:
                                  widget.docketGroupList?[i].name ?? '',
                              index: widget.orderListIndex,
                              docketGroupId:
                                  widget.docketGroupList?[i].id ?? '',
                              docketGroupSort:
                                  widget.docketGroupList?[i].additionalValue ??
                                      '',
                            );
                            pro.notify;
                            Navigator.pop(context);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 2),
                                child: Text(
                                  widget.docketGroupList?[i].name ?? '',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: size.getS(17),
                                    fontFamily:
                                        widget.docketGroupList?[i].name ==
                                                widget.docketGroupName
                                            ? kFontFBold
                                            : kFontFMedium,
                                    height: 2,
                                    color: widget.docketGroupList?[i].name ==
                                            widget.docketGroupName
                                        ? kSecondaryColor
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              Divider(
                                color: Colors.grey.shade400,
                                thickness: 0.5,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CupertinoButton(
                    minSize: 0,
                    borderRadius: BorderRadius.circular(5),
                    onPressed: () {
                      pro.setOrderItemDocketGroupName(
                        docketGroupName: "",
                        index: widget.orderListIndex,
                        docketGroupId: "",
                        docketGroupSort: "",
                      );
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Remove Docket",
                      style: TextStyle(
                        fontSize: size.getS(16),
                        color: CupertinoColors.destructiveRed,
                        fontFamily: kFontFMedium,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
