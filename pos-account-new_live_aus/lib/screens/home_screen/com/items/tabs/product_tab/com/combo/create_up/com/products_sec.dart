import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/model/home/setting/pos_device/printer_product/printer_prod_detail_res.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/product/combo_pack_pro.dart';
import 'package:pos_account/repository/if_exception.dart';
import 'package:pos_account/widgets/input/dropdown/title_drop_down.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/switch_adap.dart';
import 'combo_product_dia.dart';

class ProductSection extends StatelessWidget {
  final ComboPackPro comboPro;
  const ProductSection({super.key, required this.comboPro});

  List<ComboGroupProduct> mergeLocations(
    List<ComboGroupProduct> original,
    List<ComboGroupProduct> newData,
  ) {
    final Map<String, ComboGroupProduct> mergedMap = {
      for (var item in original) item.productId.trim().toLowerCase(): item,
    };

    for (var item in newData) {
      mergedMap[item.productId.trim().toLowerCase()] = item;
    }

    return mergedMap.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: size.getW(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: size.getH(12)),
          ...List.generate(
            comboPro.comboGroupList.length,
            (i) => _groupSection(
              size,
              index: comboPro.comboGroupList.length == 1 ? "" : "${i + 1}",
              groupModel: comboPro.comboGroupList[i],
              remove: ({int? pIndex}) {
                if (pIndex == null) {
                  comboPro.comboGroupList.removeAt(i);
                } else {
                  comboPro.comboGroupList[i].productList.removeAt(pIndex);
                }
                comboPro.notify;
              },
              // selectProdItem: ({required int pIndex}) {
              //   comboPro.comboGroupList[i].productList[pIndex].isSelected =
              //       !comboPro.comboGroupList[i].productList[pIndex].isSelected;
              //   comboPro.notify;
              // },
              onSelectItem: () async {
                final _data = await showDialog(
                    context: context,
                    builder: (builder) => SimpleDialog(
                          backgroundColor: Colors.white,
                          titlePadding: EdgeInsets.zero,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          children: [
                            ComboProductDia(
                              catList: comboPro.comboAddSec?.productCategories,
                              selectedProducts:
                                  comboPro.comboGroupList[i].productList,
                            ),
                          ],
                        ));

                if (_data != null &&
                    _data is List<ProductCategoryVariationList>) {
                  final _original = comboPro.comboGroupList[i].productList
                      .map((e) => ComboGroupProduct(
                            name: e.name,
                            id: e.id,
                            productId: e.productId,
                            isActive: e.isActive,
                            qtyCltr: e.qtyCltr,
                            priceCltr: e.priceCltr,
                            isReq: e.isReq,
                            // catId: a.catId,
                          ))
                      .toList();

                  comboPro.comboGroupList[i].productList = [];

                  final _newList = <ComboGroupProduct>[];
                  for (final e in _data) {
                    if (e.modifierList?.isNotEmpty ?? false) {
                      final _newData = e.modifierList!
                          .map((a) => ComboGroupProduct(
                                name: a.name,
                                id: a.id,
                                productId: a.productId,
                                isActive: a.isActive,
                                qtyCltr: a.qtyCltr,
                                priceCltr: a.priceCltr,
                                isReq: a.isReq,
                                // catId: a.catId,
                              ))
                          .toList();
                      _newList.addAll(_newData);
                    }
                  }
                  comboPro.comboGroupList[i].productList
                      .addAll(mergeLocations(_original, _newList));

                  comboPro.notify;
                }
              },
            ),
          ),
          DottedBorder(
            borderType: BorderType.RRect,
            radius: Radius.circular(10),
            dashPattern: [12, 4],
            color: Colors.black45,
            child: LoadButton(
              width: double.infinity,
              hPad: 4,
              textColor: Colors.black,
              btnColor: Colors.white,
              btnText: "Add Another Combo/Deals Group",
              icon: Padding(
                padding: EdgeInsets.only(right: size.getW(12)),
                child: Icon(
                  Icons.add,
                  color: Colors.black,
                  size: size.getS(22),
                ),
              ),
              onsave: () {
                comboPro.addComboGroup();
              },
            ),
          ),
          SizedBox(height: size.getH(48)),
        ],
      ),
    );
  }

  Widget _groupSection(
    Ssize size, {
    String index = "",
    Function({int? pIndex})? remove,
    required ComboGroupModel groupModel,
    Function()? onSelectItem,
    Function({required int pIndex})? selectProdItem,
  }) {
    // final _itemCount = groupModel.productList.length;

    // final _isError =
    //     (double.tryParse(groupModel.maxThQtyCltr.text) ?? 0).floor() <
    //         _itemCount;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: size.getH(16)),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(
          horizontal: size.getW(24), vertical: size.getH(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.tag,
                size: size.getS(25),
                color: kSecondaryColor,
              ),
              SizedBox(width: size.getW(4)),
              Text(
                "Combo Group $index",
                style: TextStyle(
                  fontSize: size.getS(20),
                  // fontFamily: kFontFMedium,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Spacer(),
              if (index.isNotEmpty)
                TextButton(
                    onPressed: remove,
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_outline,
                          size: size.getS(25),
                          color: Colors.red.shade600,
                        ),
                        SizedBox(width: size.getW(12)),
                        Text(
                          "Remove Group",
                          style: TextStyle(
                            fontSize: size.getS(16),
                            fontFamily: kFontFMedium,
                            color: Colors.red.shade600,
                          ),
                        )
                      ],
                    ))
            ],
          ),
          Divider(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: TitleDropDown(
                title: "Combo Group Name",
                borderColor: Colors.black26,
                indexVal: groupModel.groupIndex,
                subTitle:
                    'Combo groups organize related options like "Toppings" or "Sides"',
                list: comboPro.comboAddSec?.modifierGroups == null
                    ? []
                    : comboPro.comboAddSec!.modifierGroups!
                        .map((e) => e.name ?? '')
                        .toSet()
                        .toList(),
                onChanged: (int? i) async {
                  groupModel.groupIndex = i;
                  comboPro.notify;
                  await Future.delayed(Duration(milliseconds: 300));

                  final _count = comboPro.comboGroupList.fold<int>(
                      0,
                      (pV, eV) =>
                          pV +
                          (eV.groupIndex != null && eV.groupIndex == i
                              ? 1
                              : 0));

                  if (_count > 1) {
                    groupModel.groupIndex = null;
                    IfException.showMessage(
                        message: "Group with this name already exists");
                  }

                  comboPro.notify;
                },
              )),
              SizedBox(width: size.getW(24)),
              Expanded(
                  child: TitleDropDown(
                title: "Selection Type",
                subTitle: 'Single: one option only, Multi: multiple options',
                borderColor: Colors.black26,
                indexVal: groupModel.typeIndex,
                list: comboPro.comboAddSec?.selectionTypes == null
                    ? []
                    : comboPro.comboAddSec!.selectionTypes!
                        .map((e) => e.name ?? '')
                        .toList(),
                onChanged: (int? i) {
                  groupModel.typeIndex = i;
                  comboPro.notify;
                },
              )),
              SizedBox(width: size.getW(24)),
              Expanded(
                child: TitleTextForm(
                  isReq: false, // _isError,
                  title: "Max Threshold Quantity",
                  subTitle: //_isError ? "Max Threshold Qyantity should be equal or greater than the selected item's count."   :
                      'Maximum quantity of modifiers from this modifier group in this product during order.',
                  borderColor: //_isError ? Colors.red.shade700 :
                      Colors.black26,
                  textCltr: groupModel.maxThQtyCltr,
                  // errH: _isError ? 0 : null,
                ),
              ),
              SizedBox(width: size.getW(24)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Required",
                      style: TextStyle(
                        fontSize: size.getS(18),
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(height: size.getH(4)),
                    SwitchAdap(
                      size: size,
                      height: 40,
                      value: groupModel.isRequired,
                      activeColor: kSecondaryColor,
                      onChanged: (val) {
                        groupModel.isRequired = val;
                        comboPro.notify;
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: size.getH(8)),
                      child: Text(
                        "Select this option to make this modifier group required for all products in this combo pack",
                        style: TextStyle(
                          fontSize: size.getS(16),
                          color: Colors.black,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: size.getH(12)),
          LoadButton(
            width: double.infinity,
            hPad: 4,
            textColor: Colors.black,
            btnColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Colors.black26),
            ),
            btnText: "Select Items",
            icon: Padding(
              padding: EdgeInsets.only(right: size.getW(12)),
              child: Icon(
                Icons.add,
                color: Colors.black,
                size: size.getS(22),
              ),
            ),
            onsave: onSelectItem,
          ),
          SizedBox(height: size.getH(12)),
          Row(
            children: [
              Icon(
                Icons.tag,
                size: size.getS(25),
                color: kSecondaryColor,
              ),
              SizedBox(width: size.getW(4)),
              Text(
                "Selected Products (${groupModel.productList.length})",
                style: TextStyle(
                  fontSize: size.getS(20),
                  // fontFamily: kFontFMedium,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              // SizedBox(width: size.getW(8)),
              // Text(
              //   "(Select a product to make it the default choice for this modifier group.)",
              //   style: TextStyle(
              //     fontSize: size.getS(16),
              //     fontFamily: kFontFMedium,
              //     color: Colors.black45,
              //   ),
              // ),
            ],
          ),
          SizedBox(height: size.getH(12)),
          if (groupModel.productList.isNotEmpty)
            Wrap(
              spacing: size.getW(16),
              runSpacing: size.getH(16),
              children: List.generate(groupModel.productList.length, (i) {
                return Container(
                  width: size.getW(320),
                  height: size.getH(250),
                  decoration: BoxDecoration(
                    color: null,
                    border: Border.all(color: Colors.black26),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InkWell(
                    onTap: selectProdItem == null
                        ? null
                        : () => selectProdItem(pIndex: i),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: size.getW(12), vertical: size.getH(8)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  groupModel.productList[i].name,
                                  style: TextStyle(
                                    fontSize: size.getS(18),
                                    fontFamily: kFontFMedium,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    if (remove != null) remove(pIndex: i);
                                  },
                                  icon: Icon(
                                    Icons.close,
                                    size: size.getS(25),
                                    color: Colors.black,
                                  ))
                            ],
                          ),
                          Spacer(),
                          TitleTextForm(
                            hPad: 2,
                            title: "Available Quantity",
                            fontSize: 15,
                            borderColor: Colors.black26,
                            hintText: 'Quantity',
                            isReq: false,
                            textInputType: TextInputType.number,
                            errH: 0,
                            textCltr: groupModel.productList[i].qtyCltr ??
                                TextEditingController(),
                            prefixText: Text(
                              "Qty. ",
                              style: TextStyle(
                                fontSize: size.getS(16),
                                color: Colors.black45,
                              ),
                            ),
                          ),
                          SizedBox(height: size.getH(12)),
                          TitleTextForm(
                            hPad: 2,
                            title: "Additional Price",
                            fontSize: 15,
                            isReq: false,
                            borderColor: Colors.black26,
                            hintText: '0.00',
                            textInputType: TextInputType.number,
                            errH: 0,
                            textCltr: groupModel.productList[i].priceCltr ??
                                TextEditingController(),
                            prefixText: Text(
                              "${GlobalCVP.storeInfo?.currencySymbol ?? '\$'} ",
                              style: TextStyle(
                                fontSize: size.getS(16),
                                color: Colors.black45,
                              ),
                            ),
                          ),
                          SizedBox(height: size.getH(12)),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "REQUIRED",
                                  style: TextStyle(
                                    fontSize: size.getS(14),
                                    color: Colors.black45,
                                    fontFamily: kFontFMedium,
                                  ),
                                ),
                              ),
                              SwitchAdap(
                                size: size,
                                value: groupModel.productList[i].isReq,
                                height: 20,
                                onChanged: (val) {
                                  groupModel.productList[i].isReq =
                                      !groupModel.productList[i].isReq;
                                  comboPro.notify;
                                },
                              ),
                            ],
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          SizedBox(height: size.getH(24)),
        ],
      ),
    );
  }
}
