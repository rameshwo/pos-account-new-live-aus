import 'package:flutter/material.dart';
import 'package:pos_account/model/common/table_location.dart';
import 'package:pos_account/model/home/setting/pos_device/printer_product/printer_prod_detail_res.dart';
import 'package:pos_account/model/profile/assign_service_model.dart';
import 'package:pos_account/providers/setting/pos_device/printer_product_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/user_manage/com/custom_select_view.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:provider/provider.dart';

class ComboProductDia extends StatefulWidget {
  final List<TableLocation>? catList;
  final List<ComboGroupProduct>? selectedProducts;
  const ComboProductDia({super.key, this.catList, this.selectedProducts});

  @override
  State<ComboProductDia> createState() => _ComboProductDiaState();
}

class _ComboProductDiaState extends State<ComboProductDia> {
  PrinterProductPro? _prov;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  final _catVarsList = <ProductCategoryVariationList>[];

  void _getData() {
    _prov = Provider.of<PrinterProductPro>(context, listen: false);
    if ((widget.catList?.isNotEmpty ?? false) &&
        (widget.catList?.first.id?.isNotEmpty ?? false))
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        _prov?.selectedSubCatIndex = 0;
        _prov?.selectedCatId = widget.catList?.first.id;
        await _prov?.getAllProd2(id: widget.catList?.first.id ?? '');

        //
        if (widget.catList != null) {
          for (final e in widget.catList!) {
            _catVarsList.add(ProductCategoryVariationList(
              categoryId: e.id,
              productVariationIds: [],
              modifierList: [],
            ));
          }
          _setData();
        }

        _prov!.notify;
      });
  }

  void _setData() {
    if (widget.selectedProducts != null) {
      for (final a in widget.selectedProducts!) {
        if (_prov?.productList?.productVariations?.any(
                (c) => c.id?.toLowerCase() == a.productId.toLowerCase()) ??
            false) {
          final _catVarData = _catVarsList.any((b) =>
                  b.categoryId?.toLowerCase() ==
                  _prov?.productList?.categoryId?.toLowerCase())
              ? _catVarsList.firstWhere((b) =>
                  b.categoryId?.toLowerCase() ==
                  _prov?.productList?.categoryId?.toLowerCase())
              : null;

          _catVarData?.productVariationIds ??= [];
          _catVarData?.modifierList ??= [];

          _catVarData?.productVariationIds?.add(a.productId);
          _catVarData?.modifierList?.add(ComboGroupProduct(
            id: a.id,
            productId: a.productId,
            name: a.name,
            isActive: a.isActive,
            qtyCltr: a.qtyCltr,
            priceCltr: a.priceCltr,
            isReq: a.isReq,
          ));
        }
      }
    }
  }

  @override
  void dispose() {
    _prov?.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<PrinterProductPro>(context);
    final _catVars = _catVarsList.any((e) =>
            e.categoryId?.toLowerCase() ==
            prov.productList?.categoryId?.toLowerCase())
        ? _catVarsList.firstWhere((e) =>
            e.categoryId?.toLowerCase() ==
            prov.productList?.categoryId?.toLowerCase())
        : null;

    return Processing(
      loading: prov.loading,
      child: CustomSelectView(
        noSecFound: false,
        noSecFoundText: "No Product Found",
        servicesTypesList: List.generate(
          widget.catList?.length ?? 0,
          (index) => ParentProductCategory(
            id: widget.catList?[index].id,
            name: widget.catList?[index].name,
            isSelected: prov.selectedCatId == widget.catList?[index].id,
          ),
        ),
        subCatServList: prov.subCatProdList,
        title: "Select Product as Modifier",
        type: "Product",
        catTitle: "Categories",
        topWidget: SizedBox.shrink(),
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
          if (_catVars != null) {
            if (val == true) {
              for (var product in prov.subCatProdList!.productVariations!) {
                if (!_catVars.productVariationIds!.contains(product.id)) {
                  _catVars.productVariationIds!.add(product.id!);
                  _catVars.modifierList!.add(ComboGroupProduct(
                    productId: product.id!,
                    name: product.name!,
                    qtyCltr: TextEditingController(text: '1'),
                    priceCltr: TextEditingController(text: '0.00'),
                    isReq: false,
                    // catId: _catVars.categoryId,
                  ));
                }
              }
            } else {
              for (var product in prov.subCatProdList!.productVariations!) {
                _catVars.productVariationIds!.removeWhere(
                    (e) => e.toLowerCase() == product.id?.toLowerCase());
                _catVars.modifierList!.removeWhere(
                    (e) => e.id.toLowerCase() == product.id?.toLowerCase());
              }
            }
          }
          prov.notify;
        },
        onSave: () {
          Navigator.pop(context, _catVarsList);
        },
        searchCltr: prov.searchCltr,
        filterCltr: prov.filterCltr,
        selectedCatId: prov.selectedCatId,
        selectedSubCatIndex: prov.selectedSubCatIndex,
        selectedList: prov.selectedList.isNotEmpty
            ? prov.selectedList[prov.printerIndex].productCategoryVariationList
            : [],
        catVars: _catVars,
        onTapCategory: (id) async {
          prov.searchCltr.clear();
          prov.selectedSubCatIndex = 0;
          prov.selectedCatId = id;
          await prov.getAllProd2(id: id);
          _setData();
          prov.notify;
        },
        onTapProduct: (id, isSelected) {
          if (_catVars != null) {
            _catVars.productVariationIds ??= [];
            if (isSelected) {
              _catVars.productVariationIds!.add(id);
              if (prov.subCatProdList?.productVariations
                      ?.any((e) => e.id?.toLowerCase() == id.toLowerCase()) ??
                  false) {
                final _data = prov.subCatProdList?.productVariations
                    ?.firstWhere(
                        (e) => e.id?.toLowerCase() == id.toLowerCase());
                _catVars.modifierList!.add(ComboGroupProduct(
                  productId: id,
                  name: _data?.name ?? "",
                  qtyCltr: TextEditingController(text: '1'),
                  priceCltr: TextEditingController(text: '0.00'),
                  isReq: false,
                  // catId: _catVars.categoryId,
                ));
              }
            } else {
              _catVars.productVariationIds!
                  .removeWhere((e) => e.toLowerCase() == id.toLowerCase());
              _catVars.modifierList!
                  .removeWhere((e) => e.id.toLowerCase() == id.toLowerCase());
            }
          }
          prov.notify;
        },
      ),
    );
  }
}
