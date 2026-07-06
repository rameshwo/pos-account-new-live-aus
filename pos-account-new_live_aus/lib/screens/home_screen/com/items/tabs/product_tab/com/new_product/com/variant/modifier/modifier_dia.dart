import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pos_account/config/utils/order_utils.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/model/home/product/product_data_req.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/product/new_product_pro.dart';
import 'package:pos_account/widgets/input/dropdown/title_drop_down.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/switch_adap.dart';
import 'package:provider/provider.dart';

class ModifierDialog extends StatefulWidget {
  final int varIndex;
  const ModifierDialog({super.key, required this.varIndex});

  static Future show(
    BuildContext context, {
    required int varIndex,
  }) async {
    return await showCupertinoDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return SimpleDialog(
            contentPadding: EdgeInsets.zero,
            insetPadding: EdgeInsets.zero,
            titlePadding: EdgeInsets.zero,
            children: [
              ModifierDialog(
                varIndex: varIndex,
              )
            ],
          );
        });
  }

  @override
  _ModifierDialogState createState() => _ModifierDialogState();
}

class _ModifierDialogState extends State<ModifierDialog> {
  int? expandIndex = 0;

  late NewProductPro newProdPro;

  final _modiItemInputList = <_ModiItemInput>[];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getData();
    });
  }

  List<ProductVariationModifierGroup>? _prevModiGroup;

  void _getData() {
    final _prodPro = Provider.of<NewProductPro>(context, listen: false);
    final _modiGroup =
        (_prodPro.editData?.productVariations?.isNotEmpty ?? false) &&
                (widget.varIndex < _prodPro.editData!.productVariations!.length)
            ? (_prodPro.editData?.productVariations?[widget.varIndex]
                .productVariationModifierGroups)
            : null;
    _prevModiGroup = _modiGroup
        ?.map((e) => ProductVariationModifierGroup.fromJson(e.toJson()))
        .toList();
    if (_modiGroup != null) {
      for (int i = 0; i < _modiGroup.length; i++) {
        _modiItemInputList.add(_ModiItemInput(
          maxRootTQtyCltr:
              TextEditingController(text: _modiGroup[i].maxThresholdQuantity),
          productTypeList: [],
          customTypeList: [],
          ingreItemTypeList: [],
        ));
        if (_modiGroup[i].modifierItems != null) {
          for (final b in _modiGroup[i].modifierItems!.getProductssOnly) {
            _modiItemInputList[i].productTypeList.add(_ModiItemTypeInput(
                nameCltr: TextEditingController(text: b.name),
                priceCltr: TextEditingController(text: b.price),
                maxChildTQtyCltr:
                    TextEditingController(text: b.maxThresholdQuantity)));
          }

          for (final b in _modiGroup[i].modifierItems!.getCustomOnly) {
            _modiItemInputList[i].customTypeList.add(_ModiItemTypeInput(
                nameCltr: TextEditingController(text: b.name),
                priceCltr: TextEditingController(text: b.price),
                maxChildTQtyCltr:
                    TextEditingController(text: b.maxThresholdQuantity)));
          }

          for (final b in _modiGroup[i].modifierItems!.getIngredientsOnly) {
            _modiItemInputList[i].ingreItemTypeList.add(_ModiItemTypeInput(
                  nameCltr: TextEditingController(text: b.name),
                  priceCltr: TextEditingController(text: b.price),
                  maxChildTQtyCltr:
                      TextEditingController(text: b.maxThresholdQuantity),
                  qtyCltr:
                      TextEditingController(text: b.rawLooseIngredientQuantity),
                ));
          }
        }
      }
    }
    _prodPro.notify;
  }

  @override
  void dispose() {
    _modiItemInputList.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    newProdPro = Provider.of<NewProductPro>(context);
    return Container(
      width: size.getW(1200),
      constraints: BoxConstraints(
        minHeight: size.getH(300),
        maxHeight: size.getH(700),
      ),
      padding: EdgeInsets.fromLTRB(
          size.getW(24), size.getH(16), size.getW(24), size.getH(24)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Edit Assigned Modifier for ${newProdPro.editData?.name ?? ''}',
                    style: TextStyle(
                      fontSize: size.getS(20),
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: size.getH(4)),
                  Text(
                    'Modify the details of each group and its items.',
                    style: TextStyle(
                      fontSize: size.getS(16),
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              IconButton(
                  onPressed: () {
                    newProdPro.editData?.productVariations?[widget.varIndex]
                        .productVariationModifierGroups = _prevModiGroup;
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.close,
                    size: size.getS(25),
                  ))
            ],
          ),
          Flexible(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if ((newProdPro.editData?.productVariations?.isNotEmpty ??
                          false) &&
                      (widget.varIndex >= 0 &&
                          widget.varIndex <
                              newProdPro.editData!.productVariations!.length) &&
                      newProdPro.editData?.productVariations?[widget.varIndex]
                              .productVariationModifierGroups !=
                          null)
                    ...List.generate(
                        newProdPro.editData!.productVariations![widget.varIndex]
                            .productVariationModifierGroups!.length, (index) {
                      return _buildSeafoodSection(
                        size,
                        index: index,
                      );
                    }),
                  SizedBox(height: size.getH(24)),
                  Align(
                    alignment: Alignment.centerRight,
                    child: LoadButton(
                      hPad: 4,
                      width: 240,
                      btnText: "Update All Modifiers",
                      onsave: () {
                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeafoodSection(
    Ssize size, {
    required int index,
  }) {
    final _modifierGroup = newProdPro
        .editData!
        .productVariations![widget.varIndex]
        .productVariationModifierGroups![index];

    final _selectionTypeIndex = newProdPro.addSecRes?.selectionTypes?.any((e) =>
                e.id?.toLowerCase() ==
                _modifierGroup.selectionTypeId?.toLowerCase()) ??
            false
        ? newProdPro.addSecRes?.selectionTypes?.indexWhere((e) =>
            e.id?.toLowerCase() ==
            _modifierGroup.selectionTypeId?.toLowerCase())
        : null;

    final _modifierName = newProdPro.addSecRes?.modifierGroups?.any((a) =>
                a.id?.toLowerCase() ==
                _modifierGroup.modifierGroupId?.toLowerCase()) ??
            false
        ? newProdPro.addSecRes?.modifierGroups
            ?.firstWhere((a) =>
                a.id?.toLowerCase() ==
                _modifierGroup.modifierGroupId?.toLowerCase())
            .name
        : null;

    final _onlyProduct = _modifierGroup.modifierItems!.getProductssOnly;
    final _onlyCustom = _modifierGroup.modifierItems!.getCustomOnly;
    final _onlyIngredient = _modifierGroup.modifierItems!.getIngredientsOnly;

    return Card(
      elevation: 1,
      margin: EdgeInsets.symmetric(
          horizontal: size.getW(12), vertical: size.getH(12)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey[300]!),
      ),
      child: Padding(
        padding: EdgeInsets.all(size.getS(16)),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          if (expandIndex == index)
                            expandIndex = null;
                          else
                            expandIndex = index;

                          newProdPro.notify;
                        },
                        child: Row(
                          children: [
                            Icon(
                              expandIndex == index
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: Colors.grey[500],
                              size: size.getS(25),
                            ),
                            SizedBox(width: size.getW(12)),
                            Expanded(
                              child: Text(
                                _modifierName ?? '',
                                style: TextStyle(
                                  fontSize: size.getS(18),
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: size.getH(8)),
                      Padding(
                        padding: EdgeInsets.only(left: size.getW(32)),
                        child: Row(
                          children: [
                            Expanded(
                              child: TitleDropDown(
                                title: 'Selection Type',
                                borderColor: Colors.black38,
                                list:
                                    newProdPro.addSecRes?.selectionTypes == null
                                        ? []
                                        : newProdPro.addSecRes?.selectionTypes
                                                ?.map((e) => e.name ?? '')
                                                .toList() ??
                                            [],
                                titleFontSize: 16,
                                vPad: 8,
                                indexVal: _selectionTypeIndex,
                                onChanged: (val) {
                                  if (val == null) return;

                                  _modifierGroup.selectionTypeId = newProdPro
                                      .addSecRes?.selectionTypes?[val].id;
                                  newProdPro.notify;
                                },
                              ),
                            ),
                            SizedBox(width: size.getW(24)),
                            Expanded(
                              child: TitleTextForm(
                                isReq: false,
                                title: 'Max Threshold Quantity',
                                borderColor: Colors.black38,
                                vPad: 9,
                                onChanged: (val) {
                                  _modifierGroup.maxThresholdQuantity = val;
                                },
                                textCltr: _modiItemInputList.isNotEmpty
                                    ? _modiItemInputList[index].maxRootTQtyCltr
                                    : TextEditingController(
                                        text: _modifierGroup
                                            .maxThresholdQuantity),
                                fontSize: 16,
                                hintText: 'Enter max quantity',
                                textInputType: TextInputType.number,
                              ),
                            ),
                            Expanded(
                              child: Container(),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(
                      'Is Active',
                      style: TextStyle(
                        fontSize: size.getS(16),
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: size.getH(8)),
                    SwitchAdap(
                      size: size,
                      value: _modifierGroup.isActive ?? false,
                      onChanged: (value) {
                        _modifierGroup.isActive = value;
                        newProdPro.notify;
                      },
                    )
                  ],
                ),
              ],
            ),
            if (expandIndex == index) ...[
              SizedBox(height: size.getH(16)),
              if (_onlyProduct.isNotEmpty)
                ...List.generate(_onlyProduct.length, (index2) {
                  return _buildCustomSection(
                    size,
                    modifier: _onlyProduct[index2],
                    index1: index,
                    index2: index2,
                    type: _ModiType.product,
                  );
                }),
              if (_onlyCustom.isNotEmpty)
                ...List.generate(_onlyCustom.length, (index2) {
                  return _buildCustomSection(
                    size,
                    modifier: _onlyCustom[index2],
                    index1: index,
                    index2: index2,
                    type: _ModiType.custom,
                  );
                }),
              if (_onlyIngredient.isNotEmpty)
                ...List.generate(_onlyIngredient.length, (index3) {
                  return _buildCustomSection(
                    size,
                    modifier: _onlyIngredient[index3],
                    index1: index,
                    index2: index3,
                    type: _ModiType.ingre,
                  );
                }),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCustomSection(
    Ssize size, {
    ProductVariationModifierGroupModifierItem? modifier,
    required int index1,
    required int index2,
    required _ModiType type,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: size.getH(6)),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.grey[300]!),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  horizontal: size.getW(12), vertical: size.getH(8)),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: Text(
                type == _ModiType.product
                    ? "Products"
                    : type == _ModiType.custom
                        ? "Custom"
                        : "Ingredients",
                style: TextStyle(
                  fontSize: size.getS(14),
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(size.getS(16)),
              child: Column(
                children: [
                  _buildTableHeader(size,
                      type: type, qtyTitle: modifier?.minMeasurementName),
                  Divider(color: Colors.grey[200]),
                  _buildTableRow(
                    size,
                    modifier: modifier,
                    index1: index1,
                    index2: index2,
                    type: type,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader(
    Ssize size, {
    required _ModiType type,
    String? qtyTitle,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Row(
            children: [
              Container(
                width: size.getS(8),
                height: size.getS(8),
                decoration: BoxDecoration(
                  color: kSecondaryColor,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: size.getW(8)),
              Text(
                'Item Name',
                style: TextStyle(
                  fontSize: size.getS(14),
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
        if (type == _ModiType.ingre || type == _ModiType.custom)
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Text(
                  GlobalCVP.storeInfo?.currencySymbol ?? '\$',
                  style: TextStyle(
                    fontSize: size.getS(18),
                    fontWeight: FontWeight.bold,
                    color: kSecondaryColor,
                  ),
                ),
                SizedBox(width: size.getW(8)),
                Text(
                  'Price',
                  style: TextStyle(
                    fontSize: size.getS(14),
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          flex: 2,
          child: Row(
            children: [
              Text(
                '#',
                style: TextStyle(
                  fontSize: size.getS(18),
                  fontWeight: FontWeight.bold,
                  color: kSecondaryColor,
                ),
              ),
              SizedBox(width: size.getW(8)),
              Text(
                'Max Threshold',
                style: TextStyle(
                  fontSize: size.getS(14),
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(width: size.getW(4)),
              Icon(
                Icons.info_outline,
                size: size.getS(16),
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
        if (type == _ModiType.ingre)
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Text(
                  '#',
                  style: TextStyle(
                    fontSize: size.getS(18),
                    fontWeight: FontWeight.bold,
                    color: kSecondaryColor,
                  ),
                ),
                SizedBox(width: size.getW(8)),
                Text(
                  'Quantity (${qtyTitle ?? ''})',
                  style: TextStyle(
                    fontSize: size.getS(14),
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.only(left: size.getW(12)),
            child: Text('Is Active',
                style: TextStyle(
                  fontSize: size.getS(14),
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.left),
          ),
        ),
        if (type == _ModiType.product) Expanded(child: Container())
      ],
    );
  }

  Widget _buildTableRow(
    Ssize size, {
    ProductVariationModifierGroupModifierItem? modifier,
    required int index1,
    required int index2,
    required _ModiType type,
  }) {
    final _modiItemTypeList = _modiItemInputList.isNotEmpty
        ? (type == _ModiType.product
            ? _modiItemInputList[index1].productTypeList
            : type == _ModiType.custom
                ? _modiItemInputList[index1].customTypeList
                : _modiItemInputList[index1].ingreItemTypeList)
        : <_ModiItemTypeInput>[];
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextFormWidget(
            isReq: type == _ModiType.ingre,
            readOnly: type == _ModiType.product,
            fillColor:
                type == _ModiType.product ? Colors.grey.shade200 : Colors.white,
            borderColor: Colors.black38,
            cltr: _modiItemTypeList.isNotEmpty
                ? _modiItemTypeList[index2].nameCltr
                : TextEditingController(text: modifier?.name),
            hintText: 'Enter name',
            onChanged: (val) {
              modifier?.name = val;
            },
          ),
        ),
        if (type == _ModiType.ingre || type == _ModiType.custom) ...[
          SizedBox(width: size.getW(12)),
          Expanded(
            flex: 2,
            child: TextFormWidget(
              borderColor: Colors.black38,
              cltr: _modiItemTypeList.isNotEmpty
                  ? _modiItemTypeList[index2].priceCltr
                  : TextEditingController(text: modifier?.price),
              hintText: 'Enter price',
              onChanged: (val) {
                modifier?.price = val;
              },
              textInputType: TextInputType.number,
            ),
          )
        ],
        SizedBox(width: size.getW(12)),
        Expanded(
          flex: 2,
          child: TextFormWidget(
            borderColor: Colors.black38,
            cltr: _modiItemTypeList.isNotEmpty
                ? _modiItemTypeList[index2].maxChildTQtyCltr
                : TextEditingController(text: modifier?.maxThresholdQuantity),
            hintText: '',
            onChanged: (val) {
              modifier?.maxThresholdQuantity = val;
            },
            textInputType: TextInputType.number,
          ),
        ),
        if (type == _ModiType.ingre &&
            _modiItemTypeList.isNotEmpty &&
            _modiItemTypeList[index2].qtyCltr != null) ...[
          SizedBox(width: size.getW(12)),
          Expanded(
            flex: 2,
            child: TextFormWidget(
              borderColor: Colors.black38,
              cltr: _modiItemTypeList.isNotEmpty
                  ? _modiItemTypeList[index2].qtyCltr!
                  : TextEditingController(
                      text: modifier?.rawLooseIngredientQuantity),
              hintText: '',
              onChanged: (val) {
                modifier?.rawLooseIngredientQuantity = val;
              },
              textInputType: TextInputType.number,
            ),
          )
        ],
        SizedBox(width: size.getW(12)),
        Expanded(
          flex: 2,
          child: Align(
            alignment: Alignment.centerLeft,
            child: SwitchAdap(
              size: size,
              value: modifier?.isActive ?? false,
              onChanged: (value) {
                modifier?.isActive = value;
                newProdPro.notify;
              },
            ),
          ),
        ),
        if (type == _ModiType.product) Expanded(child: Container())
      ],
    );
  }
}

class _ModiItemInput {
  final TextEditingController maxRootTQtyCltr;
  final List<_ModiItemTypeInput> productTypeList;
  final List<_ModiItemTypeInput> customTypeList;
  final List<_ModiItemTypeInput> ingreItemTypeList;

  _ModiItemInput({
    required this.maxRootTQtyCltr,
    required this.productTypeList,
    required this.customTypeList,
    required this.ingreItemTypeList,
  });
}

class _ModiItemTypeInput {
  final TextEditingController nameCltr;
  final TextEditingController priceCltr;
  final TextEditingController maxChildTQtyCltr;
  final TextEditingController? qtyCltr;

  _ModiItemTypeInput({
    required this.nameCltr,
    required this.priceCltr,
    required this.maxChildTQtyCltr,
    this.qtyCltr,
  });
}

enum _ModiType { product, ingre, custom }
