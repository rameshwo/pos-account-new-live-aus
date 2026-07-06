import 'package:flutter/material.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/model/home/menu/place_order/pos_res/com/feature_product.dart';
import 'package:pos_account/widgets/load_btn.dart';

import 'package:provider/provider.dart';

import '../../../../../../../config/size_config.dart';
import '../../../../../../../config/utils/utils.dart';
import '../../../../../../../config/validator.dart';
import '../../../../../../../providers/menu/place_order_pro.dart';
import '../variance_3/variance_item.dart';

class NewModiSec2 extends StatefulWidget {
  final List<ModifierItem>? modifierItems;
  final String title;
  final String? maxThresholdQuantity;
  final String? selectionType;
  final Function({bool? isItemSelected})? update;
  final Function()? onSave;
  final double itemQty;
  const NewModiSec2({
    super.key,
    this.modifierItems,
    required this.title,
    this.maxThresholdQuantity,
    required this.update,
    this.itemQty = 1,
    this.selectionType,
    this.onSave,
  });

  @override
  State<NewModiSec2> createState() => _NewModiSec2State();
}

class _NewModiSec2State extends State<NewModiSec2>
    with SingleTickerProviderStateMixin {
  void _grouping() {
    // widget.modifierItems?.sort((x, y) => (x.productName ?? '')
    //     .toLowerCase()
    //     .compareTo((y.productName ?? '').toLowerCase()));

    load();
  }

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _grouping();
    });
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _controller.forward();
  }

  void load({bool? isItemSelected}) {
    if (widget.update != null)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.update!(isItemSelected: isItemSelected);
        _placePro.notify;
      });
  }

  bool canAddorUpdate(int j, {bool isQty = false}) {
    final _modi = widget.modifierItems![j];
    final _totalGroupQty = widget.modifierItems?.fold<double>(
            0, (pV, e) => pV + ((e.isActive ?? false) ? (e.quantity) : 0)) ??
        0;
    final _maxThreshold = widget.maxThresholdQuantity?.inDouble ?? 0;
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
  }

  void _updateQty(bool? val, int j, bool canUpdate) async {
    final _modi = widget.modifierItems![j];

    if (val == null) {
      _modi.quantity = (await Utils.textQty(_modi.quantity.toDouble()));
    } else if (val) {
      if (canUpdate) {
        _modi.quantity++;
      }
    } else {
      if (_modi.quantity < 2) {
        widget.modifierItems![j].isActive = false;
        load();
        return;
      }
      _modi.quantity--;
    }
    load();
  }

  late PlaceOrderPro _placePro;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _modifiers = widget.modifierItems;
    _placePro = Provider.of<PlaceOrderPro>(context);
    final size = Ssize(context);
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: SingleChildScrollView(
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Text.rich(
                            TextSpan(
                              text: widget.title,
                              children: [
                                if ((widget.maxThresholdQuantity?.inDouble ??
                                        0) !=
                                    0)
                                  TextSpan(
                                    text:
                                        " (Choose items upto ${widget.maxThresholdQuantity ?? ''})",
                                    style: TextStyle(
                                      fontSize: size.getS(16),
                                      // fontFamily: kFontFMedium,
                                      color: kSecondaryColor,
                                    ),
                                  )
                              ],
                            ),
                            style: TextStyle(
                              fontSize: size.getS(18),
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          // const Spacer(),
                          // IconButton(
                          //     onPressed: () {
                          //       Navigator.pop(context);
                          //     },
                          //     icon: Icon(
                          //       Icons.close,
                          //       size: 40.r,
                          //     ))
                        ],
                      ),
                    ),
                    const Divider(
                      color: Colors.black45,
                    ),
                    // SizedBox(
                    //   height: 0.h,
                    // ),
                    if (_modifiers?.isNotEmpty ?? false)
                      Flexible(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(_modifiers!.length, (j) {
                              final _modifier = _modifiers[j];
                              final _price = _modifier.actualPrice.inDouble;
                              final _disPrice =
                                  _modifier.discountedPrice.inDouble;
                              final _isActive = _modifier.isActive ?? false;

                              final _canSelect = canAddorUpdate(j);
                              final _canUpdate = canAddorUpdate(j, isQty: true);

                              final _itemQty = (_modifier.isActive ?? false) &&
                                      widget.itemQty != 1
                                  ? widget.itemQty
                                  : 1.0;

                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: size.getW(16)),
                                    child: Row(
                                      children: [
                                        VarianceItem.qtyIcon(size,
                                            margin: EdgeInsets.zero,
                                            isDefault: _isActive,
                                            title: '-', onTap: () {
                                          _updateQty(false, j, false);
                                        }),
                                        Expanded(
                                            child: InkWell(
                                          onTap: () {
                                            if (!(_modifier.isActive ??
                                                false)) {
                                              if (!_canSelect) {
                                                return;
                                              }
                                            }

                                            if (!(widget.selectionType
                                                    ?.toLowerCase()
                                                    .contains('multi') ??
                                                false)) {
                                              _modifiers.forEach((e) {
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
                                                              fontSize:
                                                                  size.getS(18),
                                                              fontFamily:
                                                                  kFontFMedium,
                                                              color: _isActive
                                                                  ? kSecondaryColor
                                                                  : Colors
                                                                      .black,
                                                              height: 1.1,
                                                            ),
                                                            maxLines: 1,
                                                            textAlign:
                                                                TextAlign.left,
                                                          ),
                                                        ),
                                                      Flexible(
                                                        child: Text(
                                                          (_modifier.productName ??
                                                                  '') +
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
                                                            fontSize:
                                                                size.getS(17),
                                                            fontFamily:
                                                                kFontFMedium,
                                                            color: _isActive
                                                                ? kSecondaryColor
                                                                : _canSelect
                                                                    ? Colors
                                                                        .black
                                                                    : Colors
                                                                        .grey,
                                                            height: 1.1,
                                                          ),
                                                          maxLines: 2,
                                                          textAlign:
                                                              TextAlign.left,
                                                        ),
                                                      ),
                                                      if (_isActive)
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left:
                                                                      size.getW(
                                                                          12)),
                                                          child: Icon(
                                                            Icons.check,
                                                            color:
                                                                kSecondaryColor,
                                                            size: size.getS(24),
                                                          ),
                                                        ),
                                                      if ((_modifier.isActive ??
                                                              false) &&
                                                          _modifier
                                                                  .maxThresholdQuantity
                                                                  .inDouble ==
                                                              _modifier
                                                                  .quantity)
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left:
                                                                      size.getW(
                                                                          12)),
                                                          decoration: BoxDecoration(
                                                              color: Colors.red
                                                                  .withOpacity(
                                                                      0.1),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          25)),
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      size.getW(
                                                                          12),
                                                                  vertical: size
                                                                      .getH(4)),
                                                          child: Text(
                                                            'max',
                                                            style: TextStyle(
                                                              fontSize:
                                                                  size.getS(12),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .red.shade700,
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
                                                        color: Colors.green
                                                            .withOpacity(0.1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25)),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                size.getW(12),
                                                            vertical:
                                                                size.getH(4)),
                                                    child: Text(
                                                      'Free',
                                                      style: TextStyle(
                                                        fontSize: size.getS(12),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors
                                                            .green.shade700,
                                                      ),
                                                    ),
                                                  )
                                                else
                                                  Text.rich(TextSpan(
                                                      text:
                                                          "${_placePro.curSym}${(_price * _modifier.quantity * _itemQty).formatDouble}",
                                                      style: TextStyle(
                                                        fontSize: size.getS(
                                                            _disPrice != 0
                                                                ? 15
                                                                : 18),
                                                        fontFamily:
                                                            kFontFMedium,
                                                        color: _isActive
                                                            ? kSecondaryColor
                                                            : _canSelect
                                                                ? Colors.black
                                                                : Colors.grey,
                                                        decoration:
                                                            _disPrice != 0
                                                                ? TextDecoration
                                                                    .lineThrough
                                                                : null,
                                                      ),
                                                      children: [
                                                        if (_disPrice != 0)
                                                          TextSpan(
                                                              text:
                                                                  " ${_placePro.curSym}${(_disPrice * _modifier.quantity).formatDouble}",
                                                              style: TextStyle(
                                                                fontSize: size
                                                                    .getS(18),
                                                                decoration:
                                                                    TextDecoration
                                                                        .none,
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
                                          _updateQty(true, j, _canUpdate);
                                        }),
                                      ],
                                    ),
                                  ),
                                  if (_modifiers.length - 1 != j) Divider(),
                                ],
                              );
                            }),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: size.getH(12),
          ),
          Padding(
            padding: EdgeInsets.all(size.getS(8)),
            child: LoadButton(
                width: double.infinity,
                btnText: "Confirm",
                fontSize: 16,
                // vPad: 20,
                onsave: widget.onSave ??
                    () {
                      Navigator.pop(context);
                    }),
          ),
        ],
      ),
    );
  }
}
