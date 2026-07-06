import 'package:flutter/material.dart';
import 'package:pos_account/model/home/setting/pos_device/kd/pos_device_detail_res.dart';
import 'package:pos_account/model/home/setting/pos_device/printer_product/printer_prod_detail_res.dart';
import 'package:pos_account/model/profile/assign_service_model.dart';
import 'package:pos_account/providers/setting/general/docket_group_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/user_manage/com/custom_select_view.dart';

import 'package:provider/provider.dart';

class DocketAssignProduct extends StatefulWidget {
  final String id;
  const DocketAssignProduct({super.key, required this.id});

  @override
  State<DocketAssignProduct> createState() => _DocketAssignProductState();
}

class _DocketAssignProductState extends State<DocketAssignProduct> {
  DocketGroupPro? _docketPro;

  @override
  void initState() {
    super.initState();
    setData();
  }

  setData() async {
    _docketPro = Provider.of<DocketGroupPro>(context, listen: false);
    if (_docketPro != null) {
      _docketPro!.tagProductAddSec(widget.id);
    }
  }

  @override
  void dispose() {
    if (_docketPro != null) _docketPro!.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<DocketGroupPro>(context);
    final currentProdDetail = prov.selectedList.isNotEmpty
        ? prov.selectedList.first
        : PosDeviceDetailsRes();
    final _catVars = (currentProdDetail.productCategoryVariationList?.any((e) =>
                e.categoryId?.toLowerCase() ==
                    prov.productList?.categoryId?.toLowerCase() ||
                (prov.productList?.subCategories?.any((f) =>
                        e.categoryId?.toLowerCase() == f.id?.toLowerCase()) ??
                    false)) ??
            false)
        ? currentProdDetail.productCategoryVariationList?.firstWhere((e) =>
            e.categoryId?.toLowerCase() ==
                prov.productList?.categoryId?.toLowerCase() ||
            ((prov.productList?.subCategories?.any((f) =>
                    e.categoryId?.toLowerCase() == f.id?.toLowerCase()) ??
                false)))
        : null;

    return CustomSelectView(
      servicesTypesList: List.generate(
        prov.catList?.length ?? 0,
        (index) => ParentProductCategory(
          id: prov.catList?[index].id,
          name: prov.catList?[index].name,
          isSelected: prov.selectedCatId == prov.catList?[index].id,
        ),
      ),
      // showAssignedItems: true,
      // onTapViewAssignedItems: () {
      //   prov.productList = null;
      //   prov.getAllAssignedProd(catId: prov.selectedCatId);
      // },
      // allAssignedList: prov.productList?.productVariations,
      subCatServList: prov.subCatProdList,
      title: "Choose Products to Tag",
      type: "Product",
      disable: false,
      catServList: prov.productList,
      onChangeFilter: () {
        prov.notify;
      },
      onChangeSearch: () {
        prov.notify;
      },
      onTapSubCategory: (index) {
        prov.onTapSubCategory(index);
      },
      loading: prov.loading,
      selectAll: (val) {
        // Get the current printer's detail from selectedList.
        final currentDetail = prov.selectedList.first;

        if (_catVars != null) {
          if (val == true) {
            for (var product in prov.subCatProdList!.productVariations!) {
              if (!_catVars.productVariationIds!.contains(product.id)) {
                _catVars.productVariationIds!.add(product.id!);
              }
            }
          } else {
            for (var product in prov.subCatProdList!.productVariations!) {
              _catVars.productVariationIds!.removeWhere(
                  (e) => e.toLowerCase() == product.id?.toLowerCase());
            }
          }
        } else {
          // If no category variation exists for this category, create one.
          currentDetail.productCategoryVariationList ??= [];
          if (val == true) {
            currentDetail.productCategoryVariationList!.add(
              ProductCategoryVariationList(
                categoryId: prov.subCatProdList!.categoryId,
                productVariationIds: prov.subCatProdList?.productVariations
                    ?.map((e) => e.id!)
                    .toList(),
              ),
            );
          } else {
            currentDetail.productCategoryVariationList!.clear();
          }
        }
        prov.notify;
      },
      onSave: () {
        prov.updateDocketProducts();
      },
      searchCltr: prov.searchCltr,
      filterCltr: prov.filterCltr,
      selectedCatId: prov.selectedCatId,
      selectedSubCatIndex: prov.selectedSubCatIndex,
      selectedList: prov.selectedList.isNotEmpty
          ? prov.selectedList.first.productCategoryVariationList
          : [],
      catVars: _catVars,
      onTapCategory: (id) {
        prov.searchCltr.clear();
        prov.selectedSubCatIndex = 0;
        prov.selectedCatId = id;
        prov.getAllAssignedProd(catId: id);
      },
      // printerName: prov.printAddSec?.posDevices?[widget.index].name,
      // onTapAssignedProduct: (productId, categoryId) {},
      onTapProduct: (id, isSelected) {
        final currentDetail = prov.selectedList.first;

        if (_catVars != null) {
          _catVars.productVariationIds ??= [];
          if (isSelected) {
            _catVars.productVariationIds!.add(id);
          } else {
            _catVars.productVariationIds!
                .removeWhere((e) => e.toLowerCase() == id.toLowerCase());
          }
        } else {
          currentDetail.productCategoryVariationList ??= [];
          currentDetail.productCategoryVariationList!.add(
            ProductCategoryVariationList(
              categoryId: prov.subCatProdList!.categoryId,
              productVariationIds: [id],
            ),
          );
        }
        prov.notify;
      },
      topWidget: Container(),
    );
  }
}
