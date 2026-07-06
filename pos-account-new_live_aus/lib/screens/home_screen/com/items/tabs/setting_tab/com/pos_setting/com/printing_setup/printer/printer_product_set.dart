import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/model/home/setting/pos_device/set_up/printer_add_sec.dart';
import 'package:pos_account/providers/setting/pos_device/printer_product_pro.dart';
import 'package:pos_account/widgets/switch_adap.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../../../model/home/setting/pos_device/printer_product/printer_prod_detail_res.dart';
import '../../../../../../../../../../../model/profile/assign_service_model.dart';
import '../../../../user_manage/com/custom_select_view.dart';

class PrinterProductSet extends StatefulWidget {
  final PrinterSetupAddSec? printerAddSec;
  final int printerIndex;
  const PrinterProductSet({
    super.key,
    this.printerAddSec,
    required this.printerIndex,
  });

  @override
  State<PrinterProductSet> createState() => _PrinterProductSetState();
}

class _PrinterProductSetState extends State<PrinterProductSet> {
  PrinterProductPro? _prov;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() {
    _prov = Provider.of<PrinterProductPro>(context, listen: false);
    _prov?.printAddSec = widget.printerAddSec;
    _prov?.getData(printerIndex: widget.printerIndex);
  }

  @override
  void dispose() {
    _prov?.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final prov = Provider.of<PrinterProductPro>(context);
    final currentPrintProdDetail = prov.selectedList.isNotEmpty
        ? prov.selectedList[widget.printerIndex]
        : PrintProdDetailRes();
    final catVars = (currentPrintProdDetail.productCategoryVariationList?.any(
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
        prov.getAllAssignedProd(pIndex: widget.printerIndex);
      },
      allAssignedList: prov.allAssignedItems,
      subCatServList: prov.subCatProdList,
      title: "POS Printer Product Setup",
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
                        ? prov.selectedList[widget.printerIndex]
                                .printAllProductToKitchen ??
                            false
                        : false,
                    activeColor: kSecondaryColor,
                    onChanged: (va) {
                      prov.selectedList[widget.printerIndex]
                          .printAllProductToKitchen = va;
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
                            " ${prov.printAddSec?.posPrinters?[widget.printerIndex].name ?? 'Printer'} ",
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
          ? prov.selectedList[widget.printerIndex].printAllProductToKitchen ??
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
        final currentDetail = prov.selectedList[widget.printerIndex];

        if (catVars != null) {
          if (val == true) {
            for (var product in prov.subCatProdList!.productVariations!) {
              if (!catVars.productVariationIds!.contains(product.id)) {
                catVars.productVariationIds!.add(product.id!);
              }
            }
          } else {
            for (var product in prov.subCatProdList!.productVariations!) {
              catVars.productVariationIds!.removeWhere(
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
          ? prov.selectedList[widget.printerIndex].productCategoryVariationList
          : [],
      catVars: catVars,
      onTapCategory: (id) {
        prov.searchCltr.clear();
        prov.selectedSubCatIndex = 0;
        prov.selectedCatId = id;
        prov.getAllProd();
      },
      printerName: prov.printAddSec?.posPrinters?[widget.printerIndex].name,
      onTapAssignedProduct: (productId, categoryId) {
        // bool isRemoved = false;
        // prov.selectedList.forEach((element) {
        //   element.productCategoryVariationList?.forEach((e) {
        //     if (e.productVariationIds?.contains(productId) ?? false) {
        //       e.productVariationIds?.removeWhere(
        //           (id) => id.toLowerCase() == productId.toLowerCase());
        //       isRemoved = true;
        //     }
        //   });
        // });
        // if (!isRemoved) {
        //   final List<ProductCategoryVariationList> newVariations = [];
        //   prov.selectedList.forEach((element) {
        //     bool foundCategory = false;
        //     List<ProductCategoryVariationList>? variationsCopy =
        //         List.from(element.productCategoryVariationList ?? []);
        //     variationsCopy.forEach((e) {
        //       if (e.categoryId?.toLowerCase() == categoryId.toLowerCase()) {
        //         foundCategory = true;
        //         e.productVariationIds?.add(productId);
        //       }
        //     });
        //     if (!foundCategory) {
        //       newVariations.add(
        //         ProductCategoryVariationList(
        //           categoryId: categoryId,
        //           productVariationIds: [productId],
        //         ),
        //       );
        //     }
        //   });
        //   prov.selectedList.forEach((element) {
        //     element.productCategoryVariationList?.addAll(newVariations);
        //   });
        // }
        // prov.notify;
      },
      onTapProduct: (id, isSelected) {
        final currentDetail = prov.selectedList[widget.printerIndex];
        if (catVars != null) {
          catVars.productVariationIds ??= [];
          if (isSelected) {
            catVars.productVariationIds!.add(id);
          } else {
            catVars.productVariationIds!
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
