import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/model/home/setting/pos_device/kd/pos_device_detail_res.dart';
import 'package:pos_account/model/home/setting/pos_device/printer_product/printer_prod_detail_res.dart';
import 'package:pos_account/model/home/setting/pos_device/set_up/printer_add_sec.dart';
import 'package:pos_account/model/profile/assign_service_model.dart';
import 'package:pos_account/providers/setting/pos_device/kit_product_assign_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/user_manage/com/custom_select_view.dart';
import 'package:pos_account/widgets/switch_adap.dart';
import 'package:provider/provider.dart';

class KitAssignProduct extends StatefulWidget {
  final PrinterSetupAddSec? printerAddSec;
  final int index;
  const KitAssignProduct({
    super.key,
    this.printerAddSec,
    required this.index,
  });

  @override
  State<KitAssignProduct> createState() => _KitAssignProductState();
}

class _KitAssignProductState extends State<KitAssignProduct> {
  KitProdAssignPro? _prov;

  @override
  void initState() {
    super.initState();
    _prov = Provider.of<KitProdAssignPro>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) => _getData());
  }

  void _getData() {
    _prov?.printAddSec = widget.printerAddSec;
    _prov?.getData(index: widget.index);
  }

  @override
  void dispose() {
    _prov?.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final prov = Provider.of<KitProdAssignPro>(context);
    final currentPrintProdDetail = prov.selectedList.isNotEmpty
        ? prov.selectedList[widget.index]
        : PosDeviceDetailsRes();
    final _catVars = (currentPrintProdDetail.productCategoryVariationList?.any(
                (e) =>
                    e.categoryId?.toLowerCase() ==
                    prov.productList?.categoryId?.toLowerCase()) ??
            false)
        ? currentPrintProdDetail.productCategoryVariationList?.firstWhere((e) =>
            e.categoryId?.toLowerCase() ==
            prov.productList?.categoryId?.toLowerCase())
        : null;

    return CustomSelectView(
      servicesTypesList: List.generate(
        prov.printAddSec?.categories?.length ?? 0,
        (index) => ParentProductCategory(
          id: prov.printAddSec?.categories?[index].id,
          name: prov.printAddSec?.categories?[index].name,
          isSelected:
              prov.selectedCatId == prov.printAddSec?.categories?[index].id,
        ),
      ),
      showAssignedItems: true,
      onTapViewAssignedItems: () {
        prov.allAssignedItems = [];
        prov.getAllAssignedProd(pIndex: widget.index);
      },
      allAssignedList: prov.allAssignedItems,
      subCatServList: prov.subCatProdList,
      title: "POS Device Product Setup",
      type: "Product",
      topWidget: Column(children: [
        Card(
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: size.getW(12), vertical: size.getH(8)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SwitchAdap(
                    size: size,
                    value: prov.selectedList.isNotEmpty
                        ? prov.selectedList[widget.index]
                                .sendAllProductToKitchenDisplay ??
                            false
                        : false,
                    activeColor: kSecondaryColor,
                    onChanged: (va) {
                      prov.selectedList[widget.index]
                          .sendAllProductToKitchenDisplay = va;
                      prov.notify;
                    },
                    height: 36,
                  ),
                  SizedBox(width: size.getW(10)),
                  RichText(
                      text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Enable, if you are using this as only one",
                        style: TextStyle(
                          fontSize: size.getS(15),
                          color: Colors.black,
                          fontFamily: kFontFMedium,
                        ),
                      ),
                      TextSpan(
                        text:
                            " ${prov.printAddSec?.posDevices?[widget.index].name ?? 'Device'} ",
                        style: TextStyle(
                          fontSize: size.getS(15),
                          color: kSecondaryColor,
                          fontFamily: kFontFMedium,
                        ),
                      ),
                      TextSpan(
                        text: "to send products to kitchen.",
                        style: TextStyle(
                          fontSize: size.getS(15),
                          color: Colors.black,
                          fontFamily: kFontFMedium,
                        ),
                      ),
                    ],
                  )),
                ],
              ),
            ),
          ),
        ),
      ]),
      disable: prov.selectedList.isNotEmpty
          ? prov.selectedList[widget.index].sendAllProductToKitchenDisplay ??
              false
          : false,
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
        final currentDetail = prov.selectedList[widget.index];

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
        prov.addUpdate();
      },
      searchCltr: prov.searchCltr,
      filterCltr: prov.filterCltr,
      selectedCatId: prov.selectedCatId,
      selectedSubCatIndex: prov.selectedSubCatIndex,
      selectedList: prov.selectedList.isNotEmpty
          ? prov.selectedList[widget.index].productCategoryVariationList
          : [],
      catVars: _catVars,
      onTapCategory: (id) {
        prov.searchCltr.clear();
        prov.selectedSubCatIndex = 0;
        prov.selectedCatId = id;
        prov.getAllProd();
      },
      printerName: prov.printAddSec?.posDevices?[widget.index].name,
      onTapAssignedProduct: (productId, categoryId) {},
      onTapProduct: (id, isSelected) {
        final currentDetail = prov.selectedList[widget.index];
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
    );
  }
}
