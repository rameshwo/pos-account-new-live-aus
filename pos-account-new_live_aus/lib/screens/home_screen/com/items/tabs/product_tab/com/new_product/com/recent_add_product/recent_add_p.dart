import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/common/res_datum.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/product/new_product_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/product_tab/com/new_product/com/recent_add_product/assign_product.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/setting_tab/com/general/common/common_header.dart';
import 'package:pos_account/widgets/dialog/confirm_dialog.dart';
import 'package:pos_account/widgets/image/network_image_sec.dart';
import 'package:pos_account/widgets/input/dropdown/tree_dropdown/tree_dropdown.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import 'package:pos_account/widgets/refresh_btn.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../../../../../../../widgets/title_pop.dart';
import '../featured_prod/featured_product_set.dart';
import 'deactivate_icon.dart';
import '../price_v_section/price_section_dia.dart';

class RecentAddedProducts extends StatefulWidget {
  final ScrollController? scrollController;
  // final Function()? createNewSet;
  final Function()? addNewProduct;
  // final Function()? addNewRawIngre;
  final Function() onBack;

  const RecentAddedProducts({
    super.key,
    this.scrollController,
    // this.createNewSet,
    this.addNewProduct,
    // this.addNewRawIngre,
    required this.onBack,
  });

  @override
  State<RecentAddedProducts> createState() => _RecentAddedProductsState();

  static void openAssingProduct(context) {
    showDialog(
        context: context,
        builder: (builder) => SimpleDialog(
              backgroundColor: Colors.white,
              titlePadding: EdgeInsets.zero,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              children: [
                AssignPrinterProduct(),
              ],
            ));
  }
}

class _RecentAddedProductsState extends State<RecentAddedProducts> {
  final refreshCltr = RefreshController(initialRefresh: false);

  void paginate(int page) {
    // _newProdPro.productLoad = true;
    // _newProdPro.notify;
    _newProdPro.getAllProducts(page: page).then((_) {
      if (page == 1) {
        refreshCltr.refreshCompleted();
      } else {
        refreshCltr.loadComplete();
      }
    });
  }

  // showBarcodeGenDia() {
  //   return showDialog(
  //       context: context,
  //       builder: (builder) => SimpleDialog(
  //             backgroundColor: kBackgroundColor,
  //             titlePadding: EdgeInsets.zero,
  //             contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(15)),
  //             children: [BarCodeGenDia()],
  //           ));
  // }

  showTableDia() {
    return showDialog(
        context: context,
        builder: (builder) => SimpleDialog(
              backgroundColor: kBackgroundColor,
              titlePadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              children: [FeaturedProductSet()],
            ));
  }

  showPriceUpdateDia(BuildContext context, {required String id}) {
    return showDialog(
        context: context,
        builder: (builder) => SimpleDialog(
              backgroundColor: Colors.white,
              titlePadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              children: [
                PriceSectionDia(
                  productId: id,
                )
              ],
            ));
  }

  late NewProductPro _newProdPro;

  @override
  void initState() {
    super.initState();
    _newProdPro = Provider.of<NewProductPro>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _newProdPro.getData();
      _newProdPro.getAllProducts(page: 1);
    });
  }

  @override
  void dispose() {
    _newProdPro.productLoad = true;
    refreshCltr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final newProductPro = Provider.of<NewProductPro>(context);
    return Processing(
      loading: newProductPro.productLoad,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // SizedBox(
          //   height: size.getH(12),
          // ),
          CommonHeader(
            child: Row(
              children: [
                Expanded(
                  child: TitlePop(
                    onTap: widget.onBack,
                    title: "Inventory",
                    size: size,
                  ),
                ),
                if (GlobalCVP.viewWidget.viewRecentlyAddedProductButton) ...[
                  LoadButton(
                    vPad: 8,
                    hPad: 4,
                    width: 220,
                    btnColor: kTempColor,
                    btnText: (GlobalCVP.isServiceStore)
                        ? "Add New Service"
                        : LN.addNewProducts,
                    icon: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: size.getS(24),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    onsave: () {
                      newProductPro.productLoad = true;
                      newProductPro.selectedCatId = null;
                      widget.addNewProduct != null
                          ? widget.addNewProduct!()
                          : () {};
                    },
                  ),
                  SizedBox(
                    width: size.getW(12),
                  )
                ],
                // if (!GlobalCVP.isServiceStore)
                // if (GlobalCVP.isHospitality) ...[
                //   Flexible(
                //     child: LoadButton(
                //       vPad: 8,
                //       hPad: 4,
                //       width: 220,
                //       btnColor: Colors.white,
                //       textColor: kSecondaryColor,
                //       btnText: "Combo/Deals",
                //       icon: Icon(
                //         Icons.add,
                //         color: kSecondaryColor,
                //         size: size.getS(24),
                //       ),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(5),
                //         side: BorderSide(color: kSecondaryColor),
                //       ),
                //       onsave: widget.createNewSet,
                //     ),
                //   ),
                //   SizedBox(
                //     width: size.getW(12),
                //   )
                // ],
                // if (!GlobalCVP.isServiceStore)
                //   Flexible(
                //     child: LoadButton(
                //       vPad: 8,
                //       hPad: 2,
                //       width: 240,
                //       btnColor: Colors.white,
                //       textColor: kSecondaryColor,
                //       btnText: "${LN.add} ${LN.rawIngre}",
                //       icon: Icon(
                //         Icons.add,
                //         color: kSecondaryColor,
                //         size: size.getS(24),
                //       ),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(5),
                //         side: BorderSide(color: kSecondaryColor),
                //       ),
                //       onsave: widget.addNewRawIngre,
                //     ),
                //   ),
                // SizedBox(
                //   width: size.getW(12),
                // ),
                // if (!GlobalCVP.isServiceStore)
                //   LoadButton(
                //     vPad: 8,
                //     hPad: 4,
                //     width: 220,
                //     btnColor: Colors.white,
                //     textColor: kUserColor,
                //     btnText: LN.generateBarcode,
                //     icon: Icon(
                //       Icons.bar_chart,
                //       color: kUserColor,
                //       size: size.getS(24),
                //     ),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(5),
                //       side: BorderSide(color: kUserColor),
                //     ),
                //     onsave: () {
                //       showBarcodeGenDia();
                //     },
                //   ),
                // SizedBox(
                //   width: size.getW(12),
                // ),
                // if (!GlobalCVP.isServiceStore)
                //   Flexible(
                //     child: LoadButton(
                //       vPad: 8,
                //       hPad: 4,
                //       width: 220,
                //       btnColor: Colors.white,
                //       textColor: kPrimaryColor,
                //       btnText: LN.featuredProduct,
                //       icon: Padding(
                //         padding: EdgeInsets.only(right: size.getW(4)),
                //         child: Icon(
                //           Icons.star_outline,
                //           color: kPrimaryColor,
                //           size: size.getS(24),
                //         ),
                //       ),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(5),
                //         side: BorderSide(color: kPrimaryColor),
                //       ),
                //       onsave: () => showTableDia(),
                //     ),
                //   ),
              ],
            ),
          ),
          SizedBox(height: size.getH(12)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.getW(12)),
            child: Row(
              children: [
                Expanded(
                  // width: size.getW(400),
                  child: TextFormWidget(
                    isReq: false,
                    vPad: 12,
                    suffixIcon: newProductPro.searchProdCltr.text.isNotEmpty
                        ? InkWell(
                            onTap: () {
                              newProductPro.searchProdCltr.clear();
                              newProductPro.productLoad = true;
                              newProductPro.notify;
                              newProductPro.getAllProducts(page: 1);
                            },
                            child: Icon(
                              Icons.close,
                              size: size.getS(32),
                            ),
                          )
                        : Icon(
                            Icons.search,
                            size: size.getS(32),
                          ),
                    borderRadius: 5,
                    borderColor: Colors.black12,
                    cltr: newProductPro.searchProdCltr,
                    hintText: GlobalCVP.isServiceStore
                        ? "Search Service"
                        : LN.searchProduct,
                    onChanged: (p0) {
                      Utils.handleSearch(callback: () async {
                        newProductPro.productLoad = true;
                        newProductPro.notify;
                        await newProductPro.getAllProducts(page: 1);
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: size.getW(12),
                ),
                SizedBox(
                  width: size.width * 0.24,
                  child: TreeDropWidget(
                    isReq: false,
                    width: size.width * 0.24,
                    vPad: 12,
                    dialogWidth: size.width / 2,
                    mode: Mode.DIALOG,
                    selectedColor: kSecondaryColor,
                    borderColor: Colors.black12,
                    hintText: LN.chooseCategory,
                    dropdownTitle: LN.chooseCategory,
                    categoryList: newProductPro.categoryList,
                    selectedId: newProductPro.selectedCatId,
                    onChanged: (p0) {
                      newProductPro.selectedCatId = p0;
                      newProductPro.productLoad = true;
                      newProductPro.notify;
                      newProductPro.getAllProducts(page: 1);
                    },
                  ),
                ),
                SizedBox(
                  width: size.getW(24),
                ),
                RefreshBtn(
                  size: size,
                  onTap: newProductPro.productLoad
                      ? null
                      : () {
                          newProductPro.productLoad = true;
                          newProductPro.clearRecentAddSec();
                          newProductPro.getAllProducts(page: 1);
                        },
                ),
                if (!GlobalCVP.isServiceStore)
                  Padding(
                    padding: EdgeInsets.only(left: size.getW(24.0)),
                    child: LoadButton(
                      hPad: 4,
                      width: 260,
                      btnColor: Colors.white,
                      textColor: Colors.black,
                      btnText: "Assign Printer Products",
                      icon: Padding(
                        padding: EdgeInsets.only(right: size.getW(8)),
                        child: Icon(
                          Icons.print,
                          color: Colors.black,
                          size: size.getS(24),
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(color: Colors.black26),
                      ),
                      onsave: () {
                        RecentAddedProducts.openAssingProduct(context);
                      },
                    ),
                  ),
                // SizedBox(
                //   width: size.getW(24),
                // ),
              ],
            ),
          ),
          // AnimatedContainer(
          //   height: newProductPro.isMultipleSelected ? size.getH(52) : 0,
          //   duration: Duration(milliseconds: 600),
          //   child: Padding(
          //     padding: EdgeInsets.only(bottom: size.getH(12.0)),
          //     child: Row(
          //       // mainAxisAlignment: MainAxisAlignment.end,
          //       children: [
          //         ElevatedButton(
          //             onPressed: () {
          //               showDialog(
          //                   context: context,
          //                   builder: (builder) => ConfirmDialog(
          //                         title:
          //                             "${LN.deactivate} ${newProductPro.selectedProduct.length} ${LN.products}",
          //                         subTitle:
          //                             "${LN.wannaDeactivate} ${newProductPro.selectedProduct.length}  ${LN.products}}?",
          //                         onDelete: () {
          //                           final _data = List.generate(
          //                               newProductPro.selectedProduct.length,
          //                               (index) => SRDatum(
          //                                     id: newProductPro
          //                                         .selectedProduct[index],
          //                                   ));

          //                           newProductPro.deactivateData(dataList: _data);
          //                         },
          //                         actionText: LN.deactivate,
          //                       ));
          //             },
          //             style: ButtonStyle(
          //                 backgroundColor:
          //                     MaterialStateProperty.all(Colors.red.shade700)),
          //             child: Text(
          //               LN.deactivate,
          //               style: TextStyle(
          //                 fontSize: size.getS(16),
          //                 color: Colors.white,
          //                 fontWeight: FontWeight.bold,
          //               ),
          //             )),
          //         SizedBox(
          //           width: size.getW(12),
          //         ),
          //         ElevatedButton(
          //             onPressed: () {
          //               newProductPro.isMultipleSelected = false;
          //               for (var e in newProductPro.getAllProductRes!.data!) {
          //                 e.isSelected = false;
          //               }
          //               newProductPro.selectedProduct.clear();
          //               newProductPro.notify;
          //             },
          //             style: ButtonStyle(
          //                 backgroundColor:
          //                     MaterialStateProperty.all(Colors.grey.shade300)),
          //             child: Text(
          //               LN.cancel,
          //               style: TextStyle(
          //                 fontSize: size.getS(16),
          //                 color: Colors.black,
          //                 fontWeight: FontWeight.bold,
          //               ),
          //             )),
          //       ],
          //     ),
          //   ),
          // ),
          SizedBox(
            height: size.getH(12),
          ),
          Flexible(
            child: SmartRefresher(
              controller: refreshCltr,
              enablePullUp: true,
              onLoading: () {
                paginate(newProductPro.getPage + 1);
              },
              onRefresh: () {
                paginate(1);
              },
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: size.getW(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: size.getH(12),
                    ),
                    if (!newProductPro.productLoad &&
                        (newProductPro.productList.isEmpty))
                      NoItemsSec(size: size, title: LN.noProductAdded)
                    else
                      GridView.count(
                        mainAxisSpacing: size.getW(8),
                        crossAxisSpacing: size.getW(8),
                        shrinkWrap: true,
                        crossAxisCount: 6,
                        childAspectRatio: 0.88,
                        physics: NeverScrollableScrollPhysics(),
                        children: List.generate(
                            newProductPro.productList.length, (index) {
                          final product = newProductPro.productList[index];
                          return Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: newProductPro.isMultipleSelected &&
                                    product.isSelected
                                ? kSecondaryColor.withOpacity(0.15)
                                : null,
                            shadowColor: newProductPro.isMultipleSelected &&
                                    product.isSelected
                                ? Colors.transparent
                                : null,
                            child: SizedBox(
                              height: size.getH(270),
                              width: size.getW(208),
                              child: InkWell(
                                // onTap: () {
                                // if (newProductPro.isMultipleSelected) {
                                //   product.isSelected = !product.isSelected;
                                //   if (product.isSelected &&
                                //       !newProductPro.selectedProduct
                                //           .contains(product.orderTypeProductPriceId)) {
                                //     newProductPro.selectedProduct
                                //         .add(product.orderTypeProductPriceId!);
                                //   }
                                //   newProductPro.notify;
                                // }
                                // },
                                // onLongPress: () {
                                // if (!newProductPro.isMultipleSelected) {
                                //   newProductPro.selectedProduct.clear();
                                // }
                                // newProductPro.isMultipleSelected = true;
                                // product.isSelected = true;
                                // newProductPro.selectedProduct
                                //     .add(product.orderTypeProductPriceId!);
                                // newProductPro.notify;
                                // },
                                borderRadius: BorderRadius.circular(5),
                                highlightColor: newProductPro.isMultipleSelected
                                    ? kSecondaryColor.withOpacity(0.3)
                                    : null,
                                child: Stack(
                                  alignment: Alignment.topCenter,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: Container(
                                            color: Colors.grey.shade100,
                                            child: NetworkImageSec(
                                              image: product.image,
                                              height: size.isProt ? 100 : 124,
                                              width: 228,
                                              //                    height: size.getH(270),
                                              // width: size.getW(208),
                                              boxFit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: size.getH(4.0),
                                                horizontal: size.getW(12)),
                                            child: Column(
                                              children: [
                                                Text(
                                                  product.name ?? '',
                                                  style: TextStyle(
                                                    fontSize: size.getS(15),
                                                    color: Colors.black,
                                                    fontFamily: kFontFMedium,
                                                    // height: 1.2,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Flexible(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      SizedBox(
                                                        height: size.getH(4),
                                                      ),
                                                      if (GlobalCVP.viewWidget
                                                          .viewUpdatePriceButton)
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          alignment:
                                                              Alignment.center,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            border: Border.all(
                                                                color: Colors
                                                                    .black26),
                                                          ),
                                                          child: InkWell(
                                                            onTap: () {
                                                              FocusScope.of(
                                                                      context)
                                                                  .unfocus();
                                                              newProductPro
                                                                      .priceLoad =
                                                                  true;
                                                              newProductPro
                                                                  .notify;
                                                              showPriceUpdateDia(
                                                                context,
                                                                id: product
                                                                        .id ??
                                                                    '',
                                                              );
                                                            },
                                                            child: Padding(
                                                              padding: EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      size.getW(
                                                                          4.0),
                                                                  vertical: size
                                                                      .getH(6)),
                                                              child: Text(
                                                                LN.updatePrice,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: size
                                                                      .getS(15),
                                                                  color: Colors
                                                                      .black,
                                                                  fontFamily:
                                                                      kFontFMedium,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      SizedBox(
                                                        height: size.getH(8),
                                                      ),
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          if (GlobalCVP
                                                              .viewWidget
                                                              .viewEditProductButton) ...[
                                                            Expanded(
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .black26),
                                                                ),
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    if (product
                                                                            .id ==
                                                                        null)
                                                                      return;
                                                                    // Navigator.pop(
                                                                    //     context);
                                                                    // scrollCltr.scrollTo(
                                                                    //   index: 0,
                                                                    //   duration:
                                                                    //       Duration(milliseconds: 700),
                                                                    //   curve: Curves.easeInOutCubic,
                                                                    // );
                                                                    widget.addNewProduct !=
                                                                            null
                                                                        ? widget
                                                                            .addNewProduct!()
                                                                        : () {};

                                                                    newProductPro
                                                                        .getEditData(
                                                                      id: product
                                                                          .id!,
                                                                      scrollController:
                                                                          widget
                                                                              .scrollController,
                                                                    );
                                                                  },
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            size.getW(
                                                                                4.0),
                                                                        vertical:
                                                                            size.getH(6)),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Icon(
                                                                            Icons
                                                                                .edit_note,
                                                                            size:
                                                                                size.getS(22)),
                                                                        SizedBox(
                                                                            width:
                                                                                size.getW(4)),
                                                                        Text(
                                                                          LN.edit,
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                size.getS(15),
                                                                            color:
                                                                                Colors.black,
                                                                            fontFamily:
                                                                                kFontFMedium,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width:
                                                                  size.getW(8),
                                                            )
                                                          ],
                                                          if (GlobalCVP
                                                              .viewWidget
                                                              .viewDeactivateProductButton)
                                                            Expanded(
                                                              child:
                                                                  DeactivateIcon<
                                                                      bool>(
                                                                size: size,
                                                                isActive:
                                                                    product
                                                                        .status,
                                                                onTap:
                                                                    product.status !=
                                                                            true
                                                                        ? null
                                                                        : () {
                                                                            showDialog(
                                                                                context: context,
                                                                                builder: (builder) => ConfirmDialog(
                                                                                      title: "${LN.deactivate} ${product.name ?? ''}",
                                                                                      subTitle: "${LN.wannaDeactivate} ${product.name ?? ''}?",
                                                                                      onDelete: () async {
                                                                                        final _data = SRDatum(
                                                                                          id: product.id,
                                                                                        );
                                                                                        newProductPro.deactivateData(dataList: [_data]);
                                                                                        return null;
                                                                                      },
                                                                                      actionText: LN.deactivate,
                                                                                    ));
                                                                          },
                                                              ),
                                                            ),

                                                          // Card(
                                                          //   elevation: 4,
                                                          //   margin: EdgeInsets.zero,
                                                          //   shadowColor: Colors.grey[200],
                                                          //   color: kIconBackColor,
                                                          //   shape: RoundedRectangleBorder(
                                                          //       borderRadius:
                                                          //           BorderRadius.circular(5)),
                                                          //   child: InkWell(
                                                          //     borderRadius:
                                                          //         BorderRadius.circular(5),
                                                          //     onTap: () {
                                                          //       final _deletedData = SRDatum(
                                                          //         id: product.id,
                                                          //         name: product.name,
                                                          //       );
                                                          //       showDialog(
                                                          //           context: context,
                                                          //           builder: (builder) =>
                                                          //               ConfirmDialog(
                                                          //                 title:
                                                          //                     _deletedData.name ??
                                                          //                         '',
                                                          //                 onDelete: () {
                                                          //                   newProductPro
                                                          //                       .deleteData(
                                                          //                           dataList: [
                                                          //                         _deletedData
                                                          //                       ]);
                                                          //                 },
                                                          //               ));
                                                          //     },
                                                          //     child: Padding(
                                                          //       padding:
                                                          //           EdgeInsets.all(size.getS(8)),
                                                          //       child: SvgPicture.asset(
                                                          //         "assets/svg/icons/Delete.svg",
                                                          //         height: size.getS(18),
                                                          //         width: size.getS(18),
                                                          //         color: Colors.red,
                                                          //       ),
                                                          //     ),
                                                          //   ),
                                                          // )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                // SizedBox(
                                                //   height: size.getH(4),
                                                // ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Positioned(
                                      right: 2,
                                      top: 2,
                                      child: (product.status ?? false)
                                          ? Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.green
                                                      .withOpacity(1),
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: size.getW(8),
                                                  vertical: size.getH(4)),
                                              child: Text(
                                                LN.active,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: size.getS(14)),
                                              ))
                                          : Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.red
                                                      .withOpacity(0.15),
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: size.getW(8),
                                                  vertical: size.getH(4)),
                                              child: Text(
                                                LN.inActive,
                                                style: TextStyle(
                                                    color: Colors.red.shade700,
                                                    fontSize: size.getS(14)),
                                              )),
                                    )
                                    // if (newProductPro.isMultipleSelected)
                                    // Positioned(
                                    //   right: 0,
                                    //   top: 0,
                                    //   child: Checkbox(
                                    //     value: newProductPro.isMultipleSelected &&
                                    //         product.isSelected,
                                    //     fillColor:
                                    //         MaterialStateProperty.all(kSecondaryColor),
                                    //     onChanged: (val) {},
                                    //   ),
                                    // )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                  ],
                ),
              ),
            ),
          )
          // if (newProductPro.getAllProductRes != null)
          //   PaginateButton(
          //     total: newProductPro.getAllProductRes!.total ?? 0,
          //     pageIndex: newProductPro.getPage,
          //     pageSize: newProductPro.pageSize,
          //     next: () => paginate(newProductPro.getPage + 1),
          //     prev: () => paginate(newProductPro.getPage - 1),
          //   ),
        ],
      ),
    );
  }
}
