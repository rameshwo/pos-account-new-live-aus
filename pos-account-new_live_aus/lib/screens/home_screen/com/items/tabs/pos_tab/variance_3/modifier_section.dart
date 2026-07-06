import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/model/home/menu/place_order/pos_res/com/feature_product.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'variance_item.dart';

class ModifierSection extends StatefulWidget {
  final List<ProductVariationModifier> productPriceModifiers;
  final String curSym;
  final Function({bool? isItemSelected})? update;
  final double width;
  final double itemQty;
  const ModifierSection({
    super.key,
    required this.productPriceModifiers,
    required this.curSym,
    required this.update,
    this.width = 200,
    this.itemQty = 1,
  });

  @override
  State<ModifierSection> createState() => _ModifierSectionState();
}

class _ModifierSectionState extends State<ModifierSection> {
  final _grouplist = <ProductVariationModifier>[];
  // int _selectedIndex = 0;

  void _grouping() {
    // log(json
    //     .encode(widget.productPriceModifiers.map((e) => e.toJson()).toList()));
    for (final a in widget.productPriceModifiers) {
      // a.modifierItems?.sort((x, y) => (x.productName ?? '')
      //     .toLowerCase()
      //     .compareTo((y.productName ?? '').toLowerCase()));
      _grouplist.add(a);
      // if (_grouplist.any((b) => b.name == a.name)) {
      //   final _modifierList =
      //       _grouplist.firstWhere((b) => b.name == a.name);
      //   _modifierList.modifierItems?.add(a);
      // } else {
      //   _grouplist.add(GroupModifier(labelName: a.name, modifierList: [a]));
      // }
    }
    load();
  }

  @override
  void initState() {
    _grouping();
    super.initState();
  }

  void load({bool? isItemSelected}) {
    if (widget.update != null)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.update!(isItemSelected: isItemSelected);
      });
  }

  bool canAddorUpdate(int i, int j, {bool isQty = false}) {
    final _modi = _grouplist[i].modifierItems![j];
    final _totalGroupQty = _grouplist[i].modifierItems?.fold<double>(
            0, (pV, e) => pV + ((e.isActive ?? false) ? (e.quantity) : 0)) ??
        0;
    final _maxThreshold = _grouplist[i].maxThresholdQuantity?.inDouble ?? 0;
    final _maxModiQty = _modi.maxThresholdQuantity?.inDouble ?? 0;

    /// Check against group-level threshold
    if (_maxThreshold > 0 && _totalGroupQty >= _maxThreshold) {
      return false;
    }

    /// Check against modifier-level threshold
    if (_maxModiQty > 0) {
      return isQty
          ? _modi.quantity < _maxModiQty
          : _modi.quantity <= _maxModiQty;
    }

    /// Fallback when no thresholds are set
    return true;

    // if (_maxThreshold > 0) {
    //   //
    //   if (_maxModiQty > 0) {
    //     //
    //     return _totalGroupQty < _maxThreshold &&
    //         (isQty
    //             ? _maxModiQty > _modi.quantity
    //             : _maxModiQty >= _modi.quantity); //1
    //   } else {
    //     //
    //     return (isQty
    //         ? _totalGroupQty > _modi.quantity
    //         : _totalGroupQty >= _modi.quantity);
    //   }
    // } else {
    //   //
    //   if (_maxModiQty > 0) {
    //     //
    //     return (isQty
    //         ? _maxModiQty > _modi.quantity
    //         : _maxModiQty >= _modi.quantity);
    //   } else {
    //     //
    //     return true;
    //   }
    // }
  }

  void _updateQty(bool? val, int i, int j, bool canUpdate) async {
    final _modi = _grouplist[i].modifierItems![j];

    if (val == null) {
      _modi.quantity = (await Utils.textQty(_modi.quantity.toDouble()));
    } else if (val) {
      if (canUpdate) {
        _modi.quantity++;
      }
    } else {
      if (_modi.quantity < 2) {
        _grouplist[i].modifierItems![j].isActive = false;
        load();
        return;
      }
      _modi.quantity--;
    }
    load();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    if (_grouplist.isEmpty ||
        (_grouplist.length == 1 &&
            (_grouplist.first.modifierItems == null ||
                _grouplist.first.modifierItems!.isEmpty)))
      return SizedBox.shrink();
    else
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: size.getH(12)),
          ...List.generate(_grouplist.length, (i) {
            if (_grouplist[i].modifierItems == null ||
                _grouplist[i].modifierItems!.isEmpty) return SizedBox.shrink();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.15),
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: size.getW(24), vertical: size.getH(12)),
                  child: Text.rich(
                    TextSpan(text: _grouplist[i].name ?? "Extra", children: [
                      if ((_grouplist[i].maxThresholdQuantity?.inDouble ?? 0) !=
                          0)
                        TextSpan(
                          text:
                              " (Choose items upto ${_grouplist[i].maxThresholdQuantity ?? ''})",
                          style: TextStyle(
                            fontSize: size.getS(16),
                            // fontFamily: kFontFMedium,
                            color: kSecondaryColor,
                          ),
                        )
                    ]),
                    style: TextStyle(
                      fontSize: size.getS(18),
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  height: size.getH(8),
                ),
                if (_grouplist.isNotEmpty)
                  ...List.generate(_grouplist[i].modifierItems!.length, (j) {
                    final _modifier = _grouplist[i].modifierItems![j];
                    final _price = _modifier.actualPrice.inDouble;
                    final _disPrice = _modifier.discountedPrice.inDouble;
                    final _isEstTime = (GlobalCVP.isServiceStore &&
                        (_modifier.estimatedTime?.isNotEmpty ?? false));
                    final _isActive = _modifier.isActive ?? false;

                    final _canSelect = canAddorUpdate(i, j);
                    final _canUpdate = canAddorUpdate(i, j, isQty: true);

                    final _itemQty =
                        (_modifier.isActive ?? false) && widget.itemQty != 1
                            ? widget.itemQty
                            : 1.0;

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: size.getW(16)),
                          child: Row(
                            children: [
                              VarianceItem.qtyIcon(size,
                                  margin: EdgeInsets.zero,
                                  isDefault: _isActive,
                                  title: '-', onTap: () {
                                _updateQty(false, i, j, false);
                              }),
                              Expanded(
                                  child: InkWell(
                                onTap: () {
                                  if (!(_modifier.isActive ?? false)) {
                                    if (!_canSelect) {
                                      return;
                                    }
                                  }

                                  if (!(_grouplist[i]
                                          .selectionType
                                          ?.toLowerCase()
                                          .contains('multi') ??
                                      false)) {
                                    _grouplist[i].modifierItems?.forEach((e) {
                                      e.isActive = false;
                                    });
                                  }
                                  _modifier.isActive =
                                      !(_modifier.isActive ?? false);

                                  if (!(_modifier.isActive ?? false))
                                    _modifier.quantity = 1;
                                  load(isItemSelected: true);
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: size.getW(8)),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            if (_isActive)
                                              SizedBox(
                                                width: size.getW(32),
                                                child: Text(
                                                  "${_modifier.quantity.formatDouble} x ",
                                                  style: TextStyle(
                                                    fontSize: size.getS(18),
                                                    fontFamily: kFontFMedium,
                                                    color: _isActive
                                                        ? kSecondaryColor
                                                        : Colors.black,
                                                    height: 1.1,
                                                  ),
                                                  maxLines: 1,
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                            Flexible(
                                              child: Text(
                                                (_modifier.productName ?? '') +
                                                    (_modifier.variationName
                                                                ?.trim()
                                                                .isNotEmpty ??
                                                            false
                                                        ? ' (${_modifier.variationName ?? ''})'
                                                        : '') +
                                                    (_itemQty != 1
                                                        ? ' (each)'
                                                        : ''),
                                                style: TextStyle(
                                                  fontSize: size.getS(17),
                                                  fontFamily: kFontFMedium,
                                                  color: _isActive
                                                      ? kSecondaryColor
                                                      : _canSelect
                                                          ? Colors.black
                                                          : Colors.grey,
                                                  height: 1.1,
                                                ),
                                                maxLines: 2,
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                            if (_isEstTime)
                                              Container(
                                                margin: EdgeInsets.only(
                                                    left: size.getW(12)),
                                                decoration: BoxDecoration(
                                                  color: kSecondaryColor
                                                      .withOpacity(0.15),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: size.getW(12),
                                                    vertical: size.getH(2)),
                                                child: Text(
                                                  "● ${Utils.convertMinutesToHours(_modifier.estimatedTime, true)}",
                                                  style: TextStyle(
                                                    fontSize: size.getS(17),
                                                    fontWeight: FontWeight.bold,
                                                    color: kSecondaryColor,
                                                  ),
                                                ),
                                              ),
                                            if (_isActive)
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: size.getW(12)),
                                                child: Icon(
                                                  Icons.check,
                                                  color: kSecondaryColor,
                                                  size: size.getS(24),
                                                ),
                                              ),
                                            if ((_modifier.isActive ?? false) &&
                                                _modifier.maxThresholdQuantity
                                                        .inDouble ==
                                                    _modifier.quantity)
                                              Container(
                                                margin: EdgeInsets.only(
                                                    left: size.getW(12)),
                                                decoration: BoxDecoration(
                                                    color: Colors.red
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25)),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: size.getW(12),
                                                    vertical: size.getH(4)),
                                                child: Text(
                                                  'max',
                                                  style: TextStyle(
                                                    fontSize: size.getS(12),
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red.shade700,
                                                  ),
                                                ),
                                              )
                                          ],
                                        ),
                                      ),
                                      if (_modifier.isFree ?? false)
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: size.getW(12)),
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.green.withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(25)),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: size.getW(12),
                                              vertical: size.getH(4)),
                                          child: Text(
                                            'Free',
                                            style: TextStyle(
                                              fontSize: size.getS(12),
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green.shade700,
                                            ),
                                          ),
                                        )
                                      else
                                        Text.rich(TextSpan(
                                            text:
                                                "${widget.curSym}${(_price * _modifier.quantity * _itemQty).formatDouble}",
                                            style: TextStyle(
                                              fontSize: size.getS(
                                                  _disPrice != 0 ? 15 : 18),
                                              fontFamily: kFontFMedium,
                                              color: _isActive
                                                  ? kSecondaryColor
                                                  : _canSelect
                                                      ? Colors.black
                                                      : Colors.grey,
                                              decoration: _disPrice != 0
                                                  ? TextDecoration.lineThrough
                                                  : null,
                                            ),
                                            children: [
                                              if (_disPrice != 0)
                                                TextSpan(
                                                    text:
                                                        " ${widget.curSym}${(_disPrice * _modifier.quantity).formatDouble}",
                                                    style: TextStyle(
                                                      fontSize: size.getS(18),
                                                      decoration:
                                                          TextDecoration.none,
                                                    ))
                                            ])),
                                      // Text(
                                      //   "${widget.curSym}${_price * _grouplist[i].modifierItems![j].quantity}",
                                      //   style: TextStyle(
                                      //     fontSize: size.getS(18),
                                      //     fontFamily: kFontFMedium,
                                      //     color: _isActive
                                      //         ? kSecondaryColor
                                      //         : Colors.black,
                                      //   ),
                                      //   textAlign: TextAlign.center,
                                      //   maxLines: 1,
                                      // ),
                                    ],
                                  ),
                                ),
                              )),
                              VarianceItem.qtyIcon(size,
                                  margin: EdgeInsets.zero,
                                  isDefault: _isActive,
                                  title: '+', onTap: () {
                                _updateQty(true, i, j, _canUpdate);
                              }),
                            ],
                          ),
                        ),
                        if (_grouplist[i].modifierItems!.length - 1 != j)
                          Divider(),
                      ],
                    );
                  }),
                SizedBox(
                  height: size.getH(8),
                ),
              ],
            );
          }),
          SizedBox(height: size.getH(8)),
        ],
      );
  }
}

// class GroupModifier {
//   final String? labelName;
//   final List<ProductVariationModifier>? modifierList;

//   GroupModifier({
//     this.labelName,
//     this.modifierList,
//   });
// }
