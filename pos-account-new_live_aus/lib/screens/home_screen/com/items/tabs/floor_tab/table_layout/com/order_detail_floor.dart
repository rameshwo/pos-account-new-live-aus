import 'package:flutter/material.dart';
import 'package:pos_account/config/utils/order_utils.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/booking/order_item_detail_floor.dart';
import 'package:pos_account/providers/booking/table_resv_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/sidebar/sidebar_section/com/item_detail.dart';
import 'package:provider/provider.dart';

class FloorOrderDetail extends StatelessWidget {
  const FloorOrderDetail({super.key});

  List<String> _modiList({List<Modifiermodifier>? modifiers}) {
    String _labelName = "";
    final _modifiers = <String>[];
    if (modifiers != null)
      for (final m in modifiers) {
        if ((m.modifierName?.isNotEmpty ?? false)) {
          String _modifierText = "";
          final _isHalfOrCombo =
              OrderUtils.prodType(m.productType) != ProductType.Item;

          if (_labelName != m.labelName) {
            _labelName = m.labelName ?? '';
            _modifierText = "$_labelName\n";
          }
          final _qty = m.quantity?.inDouble ?? 0;

          _modifierText +=
              " + ${_qty == 0 ? '' : '${_qty.formatDouble} x '}${m.modifierName!}";
          _modifiers.add(_modifierText);

          if (_isHalfOrCombo && m.modifierItemModifiers != null) {
            _modifiers.addAll(_modiList(
                modifiers: m.modifierItemModifiers!
                  ..where((a) => a.type == Type.GENERAL).toList()));
          }
        }
      }

    return _modifiers;
  }

  @override
  Widget build(BuildContext context) {
    final _tableResv = Provider.of<TableResvPro>(context);
    final size = Ssize(context);
    final _allOrders = _tableResv.orderDetailsById?.values
        .where((list) => list != null)
        .expand((a) => a!)
        .toList();

    return _tableResv.orderLoad
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Items",
                style: TextStyle(
                  fontSize: size.getS(18),
                  color: Colors.black,
                  fontFamily: kFontFMedium,
                  decoration: TextDecoration.underline,
                ),
              ),
              if (_allOrders != null)
                ...List.generate(_allOrders.length, (i) {
                  final _e = _allOrders[i];

                  final _prodType = OrderUtils.prodType(_e.productType);
                  final _isItem = _prodType == ProductType.Item;
                  List<String>? _modifiers;

                  // modifiers

                  if (_e.modifiers != null) {
                    _modifiers = [];

                    _modifiers.addAll(_modiList(
                        modifiers: _e.modifiers
                            ?.where((a) => a.type == Type.GENERAL)
                            .toList()));
                  }

                  // ingredents

                  List<String>? _ingredients;

                  final _ingre = _e.modifiers
                      ?.where((a) => a.type == Type.RAW_INGREDIENT)
                      .toList();

                  if (_ingre != null) {
                    _ingredients = [];
                    for (final p in _ingre) {
                      _ingredients.add(p.modifierName ?? '');
                    }
                  }

                  final _spiceList = _e.modifiers
                      ?.where((a) => a.type == Type.SPICE_CHOICE)
                      .toList();
                  final _spice = ((_spiceList?.isNotEmpty ?? false)
                      ? "\n- ${_spiceList?.first.modifierName ?? ''}"
                      : "");

                  final _kitStatusEnum =
                      OrderUtils.getItemStatusEnum(_e.kitchenStatus);

                  final _statusEnum =
                      OrderUtils.getStatusEnumFromStr(_e.status);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ItemDetail(
                        title: ((_e.quantity?.inDouble ?? 0) == 0
                                ? "  "
                                : "${_e.quantity.inDouble.formatDouble} x ") +
                            (_e.itemName ?? '') +
                            _spice,
                        docketGroupName: _e.docketGroupName,
                        price: 0.0,
                        outOfStockMessage: '',
                        modifier: !_isItem ? null : _modifiers,
                        ingredients: _ingredients,
                        comboItem: !_isItem
                            ? _e.modifiers?.map((m) {
                                final _deepSpiceList = m.modifierItemModifiers
                                    ?.where((a) => a.type == Type.SPICE_CHOICE)
                                    .toList();
                                final _deepSpice = ((_deepSpiceList
                                            ?.isNotEmpty ??
                                        false)
                                    ? "\n    Spice - ${_deepSpiceList?.first.modifierName ?? ''}"
                                    : "");

                                final _modifiers = <String>[];
                                if (m.modifierItemModifiers != null) {
                                  _modifiers
                                      .add(" + ${m.modifierName!}$_deepSpice");

                                  _modifiers.addAll(_modiList(
                                      modifiers: m.modifierItemModifiers!
                                          .where((a) => a.type == Type.GENERAL)
                                          .toList()));
                                }

                                // ingredents

                                List<String>? _deepIngreList;

                                final _deepIngre = m.modifierItemModifiers
                                    ?.where(
                                        (a) => a.type == Type.RAW_INGREDIENT)
                                    .toList();

                                if (_deepIngre != null) {
                                  _deepIngreList = [];
                                  for (final pn in _deepIngre) {
                                    _deepIngreList.add(pn.modifierName ?? '');
                                  }
                                }

                                final _deepKitStatusEnum =
                                    OrderUtils.getItemStatusEnum(
                                        m.kitchenStatus);

                                return ComboItem(
                                  title: _prodType == ProductType.Half
                                      ? m.labelName
                                      : null,
                                  modifier: _modifiers,
                                  ingredients: _deepIngreList,
                                  quantity: null,
                                  rootName: _prodType == ProductType.Half
                                      ? null
                                      : _prodType == ProductType.Combo
                                          ? m.labelName
                                          : LN.modifiers,
                                  itemStatus: _deepKitStatusEnum ==
                                          ItemStatusEnum.preparing
                                      ? ItemStatus.Preparing
                                      : _deepKitStatusEnum ==
                                              ItemStatusEnum.prepared
                                          ? ItemStatus.Prepared
                                          : _deepKitStatusEnum ==
                                                  ItemStatusEnum.pending
                                              ? ItemStatus.Pending
                                              : ItemStatus.None,
                                );
                              }).toList()
                            : null,
                        itemStatus: _kitStatusEnum == ItemStatusEnum.preparing
                            ? ItemStatus.Preparing
                            : _kitStatusEnum == ItemStatusEnum.prepared
                                ? ItemStatus.Prepared
                                : _kitStatusEnum == ItemStatusEnum.pending
                                    ? ItemStatus.Pending
                                    : ItemStatus.None,
                        isItemView: true,
                        statusEnum: _statusEnum,
                      ),
                      Divider(),
                    ],
                  );
                })
            ],
          );
  }
}
