import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/providers/setting/pos_device/printer_product_pro.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/switch_adap.dart';
import 'package:provider/provider.dart';

import '../../../../../../../../../../model/home/setting/pos_device/printer_product/printer_prod_detail_res.dart';
import '../../../../../../../../../../model/profile/assign_service_model.dart';
import '../../../../../setting_tab/com/user_manage/com/custom_select_view.dart';

class AssignPrinterProduct extends StatefulWidget {
  const AssignPrinterProduct({
    super.key,
  });

  @override
  State<AssignPrinterProduct> createState() => AssignPrinterProductState();
}

class AssignPrinterProductState extends State<AssignPrinterProduct>
    with SingleTickerProviderStateMixin {
  PrinterProductPro? _prov;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() {
    _prov = Provider.of<PrinterProductPro>(context, listen: false);
    _prov
        ?.getData(
          printerIndex: 0,
          isFromRecent: true,
        )
        .then((value) => _initTabController());
  }

  void _initTabController() {
    if (mounted) {
      _tabController = TabController(
        length: _prov?.printAddSec?.posPrinters?.length ?? 0,
        vsync: this,
      );
      _tabController.addListener(() {
        _prov?.printerIndex = _tabController.index;
        _prov?.getPrinterProdDetails(
          printerIndex: _tabController.index,
          isFromRecent: true,
        );
      });
    }
  }

  @override
  void dispose() {
    _prov?.clear();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final prov = Provider.of<PrinterProductPro>(context);
    final currentPrintProdDetail = prov.selectedList.isNotEmpty
        ? prov.selectedList[prov.printerIndex]
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

    return Processing(
      loading: prov.loading,
      child: CustomSelectView(
        allAssignedList: prov.allAssignedItems,
        showAssignedItems: true,
        onTapViewAssignedItems: () {
          prov.allAssignedItems = [];
          prov.getAllAssignedProd();
        },
        noSecFound: (prov.printAddSec?.posPrinters?.isEmpty ?? true) &&
            prov.loading == false,
        noSecFoundText: "No Printer Found",
        servicesTypesList: List.generate(
          prov.printAddSec?.categories?.length ?? 0,
          (index) => ParentProductCategory(
            id: prov.printAddSec?.categories?[index].id,
            name: prov.printAddSec?.categories?[index].name,
            isSelected:
                prov.selectedCatId == prov.printAddSec?.categories?[index].id,
          ),
        ),
        subCatServList: prov.subCatProdList,
        title: "POS Printer Product Setup",
        type: "Product",
        topWidget:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (prov.printAddSec?.posPrinters?.isNotEmpty ?? false)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   "Select Printer:",
                //   style: TextStyle(
                //     fontSize: size.getS(16),
                //     color: Colors.black,
                //     fontFamily: kFontFMedium,
                //   ),
                // ),
                Visibility(
                  visible: _tabController.length > 0,
                  child: TabBar(
                    tabAlignment: TabAlignment.start,
                    controller: _tabController,
                    isScrollable: true,
                    labelColor: kSecondaryColor,
                    unselectedLabelColor: Colors.black,
                    padding: EdgeInsets.zero,
                    indicatorColor: kSecondaryColor,
                    tabs: List.generate(
                      prov.printAddSec?.posPrinters?.length ?? 0,
                      (index) => Tab(
                        child: Text(
                          prov.printAddSec?.posPrinters?[index].name ?? "",
                          style: TextStyle(
                            fontSize: size.getS(15),
                            color: _tabController.index == index
                                ? kSecondaryColor
                                : Colors.black,
                            fontFamily: kFontFMedium,
                          ),
                        ),
                      ),
                    ),
                    onTap: (index) {
                      prov.printerIndex = index;
                      prov.notify;
                      prov.getPrinterProdDetails(
                          printerIndex: index, isFromRecent: true);
                    },
                  ),
                ),
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
                                ? prov.selectedList[prov.printerIndex]
                                        .printAllProductToKitchen ??
                                    false
                                : false,
                            activeColor: kSecondaryColor,
                            onChanged: (va) {
                              prov.selectedList[prov.printerIndex]
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
                                text:
                                    "Enable, if you are using this as only one",
                                style: TextStyle(
                                  fontSize: size.getS(15),
                                  color: Colors.black,
                                  fontFamily: kFontFMedium,
                                ),
                              ),
                              TextSpan(
                                text:
                                    " ${prov.printAddSec?.posPrinters?[prov.printerIndex].name ?? 'Printer'} ",
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
              ],
            )
        ]),
        disable: (prov.printAddSec?.posPrinters?.isNotEmpty ?? false) &&
                prov.selectedList.isNotEmpty
            ? prov.selectedList[prov.printerIndex].printAllProductToKitchen ??
                false
            : false,
        printerName: prov.printAddSec?.posPrinters != null &&
                (prov.printAddSec?.posPrinters?.isNotEmpty ?? false)
            ? prov.printAddSec?.posPrinters![prov.printerIndex].name
            : "",
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
          final currentDetail = prov.selectedList[prov.printerIndex];

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
            ? prov.selectedList[prov.printerIndex].productCategoryVariationList
            : [],
        catVars: catVars,
        onTapCategory: (id) {
          prov.searchCltr.clear();
          prov.selectedSubCatIndex = 0;
          prov.selectedCatId = id;
          prov.getAllProd();
        },
        onTapAssignedProduct: (productId, categoryId) {
          // bool isRemoved = false;

          // // Access the selected printer's category variation list
          // final printer = prov.selectedList[prov.printerIndex];
          // final variations = printer.productCategoryVariationList;

          // if (variations != null) {
          //   // Find the category variation for the given categoryId
          //   final categoryVariation = variations.firstWhere(
          //     (element) =>
          //         element.categoryId?.toLowerCase() == categoryId.toLowerCase(),
          //     orElse: () => ProductCategoryVariationList(),
          //   );
          //   if (categoryVariation.productVariationIds?.contains(productId) ==
          //       true) {
          //     categoryVariation.productVariationIds?.removeWhere(
          //         (e) => e.toLowerCase() == productId.toLowerCase());
          //     isRemoved = true;
          //   }
          // }
          // if (!isRemoved) {
          //   final categoryVariation = variations?.firstWhere(
          //     (element) =>
          //         element.categoryId?.toLowerCase() == categoryId.toLowerCase(),
          //     orElse: () => ProductCategoryVariationList(),
          //   );

          //   if (categoryVariation != null) {
          //     categoryVariation.productVariationIds ??= [];
          //     categoryVariation.productVariationIds?.add(productId);
          //   } else {
          //     printer.productCategoryVariationList ??= [];
          //     printer.productCategoryVariationList?.add(
          //       ProductCategoryVariationList(
          //         categoryId: categoryId,
          //         productVariationIds: [productId],
          //       ),
          //     );
          //   }
          // }
          // prov.notify;
        },
        onTapProduct: (id, isSelected) {
          final currentDetail = prov.selectedList[prov.printerIndex];
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
      ),
    );
  }
}
