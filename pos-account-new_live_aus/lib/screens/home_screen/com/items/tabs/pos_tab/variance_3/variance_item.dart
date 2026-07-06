import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/menu/place_order/pos_res/com/feature_product.dart';
import 'package:pos_account/model/home/menu/place_order/product_filter_option.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/widgets/image/image_error.dart';
import 'package:pos_account/widgets/input/dropdown/drop_down.dart';

class VarianceItem extends StatelessWidget {
  final String? addOnName;
  final String? addOnimgPath;
  final String price;
  final double quantity;
  final Function(bool?)? update;
  //for adons variation only
  final bool showAdOnVar;
  final List<ProductVariation>? adVarList;
  final Function()? onChanged;
  final int? selectedVar;
  final String? outOfStockMessage;
  // final List<ProductFilterOption>? filterOptions;
  // final List<OrderItemSelectOptionsViewModels>? filterTypeList;
  final Function()? onTapPrice;
  final Function()? onAddAsHalfItem;
  final String? curSym;
  final String? discountedPrice;
  final String? disPercent;
  // final PromDiscount? promDiscount;
  // final String? estimatedTime;
  final List<String?>? serviceItemList;
  // final String? serviceGender;
  // final Function()? onBack;
  final double fr;
  final Function()? addOnAdd;
  final bool hasPromo;

  const VarianceItem({
    super.key,
    this.addOnName,
    this.addOnimgPath,
    required this.price,
    required this.quantity,
    this.update,
    this.showAdOnVar = false,
    this.adVarList,
    this.onChanged,
    this.selectedVar,
    this.outOfStockMessage,
    // this.filterOptions,
    // this.filterTypeList,
    this.onTapPrice,
    this.onAddAsHalfItem,
    this.curSym,
    this.discountedPrice,
    // this.promDiscount,
    this.disPercent,
    // this.estimatedTime,
    this.serviceItemList,
    // this.serviceGender,
    // this.onBack,
    this.fr = 1,
    this.addOnAdd,
    this.hasPromo = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (addOnName != null)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (addOnimgPath != null)
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: CachedNetworkImage(
                                      imageUrl: addOnimgPath!,
                                      height: size.getW(60 * fr),
                                      width: size.getW(60 * fr),
                                      fit: BoxFit.fitHeight,
                                      placeholder: ImageError.load,
                                      errorWidget: ImageError.notSupportIcon)),
                            SizedBox(
                              width: size.getW(16),
                            ),
                            Flexible(
                              child: Text(
                                addOnName!,
                                style: TextStyle(
                                  fontSize: size.getS(32 * fr),
                                  color: Colors.black,
                                  fontFamily: kFontFMedium,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      // Row(
                      //   mainAxisSize: MainAxisSize.min,
                      //   // crossAxisAlignment: CrossAxisAlignment.end,
                      //   children: [
                      //     ItemPriceView(
                      //       size: size,
                      //       curSym: curSym,
                      //       title: "Price: ",
                      //       initPrice: price,
                      //       priceAfterDiscount: (promDiscount?.isOfferStart ??
                      //                   false) &&
                      //               (promDiscount?.offerStartsIn?.inSeconds ??
                      //                       0) <
                      //                   300
                      //           ? promDiscount?.discountedPrice
                      //           : discountedPrice,
                      //       fontRatio: 1.4,
                      //     ),
                      //     if (onAddAsHalfItem == null && update != null) ...[
                      //       Spacer(),
                      //       Row(
                      //         mainAxisSize: MainAxisSize.min,
                      //         children: [
                      //           SizedBox(width: size.getW(16)),
                      //           Text(
                      //             'Quantity : ',
                      //             style: TextStyle(
                      //               fontSize: size.getS(18),
                      //               // fontFamily: kFontFMedium,
                      //               fontWeight: FontWeight.bold,
                      //               color: Colors.black,
                      //             ),
                      //           ),
                      //           QuantitySection(
                      //             quantity: quantity,
                      //             size: size,
                      //             update: update,
                      //             fr: 1.2,
                      //           ),
                      //           SizedBox(width: size.getW(12)),
                      //         ],
                      //       )
                      //     ],
                      //     if ((discountedPrice != null &&
                      //             disPercent.inDouble != 0) ||
                      //         ((promDiscount?.isOfferStart ?? false) &&
                      //             (promDiscount?.offerStartsIn?.inSeconds ??
                      //                     0) <
                      //                 300))
                      //       Container(
                      //         margin: EdgeInsets.symmetric(
                      //             horizontal: size.getW(8)),
                      //         decoration: BoxDecoration(
                      //           color: Colors.green.shade800,
                      //           borderRadius: BorderRadius.circular(5),
                      //         ),
                      //         padding: EdgeInsets.symmetric(
                      //             vertical: size.getS(4),
                      //             horizontal: size.getS(8)),
                      //         child: Text(
                      //           ((promDiscount?.isOfferStart ?? false) &&
                      //                       (promDiscount?.offerStartsIn
                      //                                   ?.inSeconds ??
                      //                               0) <
                      //                           300
                      //                   ? "${(promDiscount?.discountPercent ?? '').inQty}%"
                      //                   : "${disPercent.inQty}%") +
                      //               ' OFF',
                      //           style: TextStyle(
                      //             fontSize: size.getS(15),
                      //             color: Colors.white,
                      //             // fontFamily: kFontFMedium,
                      //             fontWeight: FontWeight.bold,
                      //           ),
                      //         ),
                      //       ),
                      //     // if (onTapPrice != null) ...[
                      //     //   SizedBox(
                      //     //     width: size.getW(8),
                      //     //   ),
                      //     //   InkWell(
                      //     //     onTap: onTapPrice,
                      //     //     child: Container(
                      //     //       decoration: BoxDecoration(
                      //     //         borderRadius: BorderRadius.circular(8),
                      //     //         border: Border.all(
                      //     //           color: kSecondaryColor.withOpacity(0.5),
                      //     //         ),
                      //     //       ),
                      //     //       padding: EdgeInsets.symmetric(
                      //     //           horizontal: size.getW(8),
                      //     //           vertical: size.getH(4)),
                      //     //       child: Text(
                      //     //         LN.changePrice,
                      //     //         style: TextStyle(
                      //     //           fontSize: size.getS(16),
                      //     //           color: kSecondaryColor,
                      //     //           fontFamily: kFontFMedium,
                      //     //           // decoration: TextDecoration.underline,
                      //     //         ),
                      //     //       ),
                      //     //     ),
                      //     //   )
                      //     // ],
                      //   ],
                      // ),
                      // SizedBox(height: size.getH(12)),
                      // if (!GlobalCVP.stockExceedRestriction &&
                      //     (outOfStockMessage?.isNotEmpty ?? false))
                      //   AnimatedContainer(
                      //       margin: EdgeInsets.only(top: size.getH(4)),
                      //       duration: Duration(milliseconds: 400),
                      //       height:
                      //           outOfStockMessage != null ? size.getH(28) : 0,
                      //       decoration: BoxDecoration(
                      //         color: Colors.red.withOpacity(0.1),
                      //         border: Border.all(
                      //             color: Colors.red.withOpacity(0.2)),
                      //         borderRadius: BorderRadius.circular(8),
                      //       ),
                      //       padding: EdgeInsets.symmetric(
                      //           horizontal: size.getW(12),
                      //           vertical: size.getH(4)),
                      //       child: Text(
                      //         outOfStockMessage ?? 'Out of Stock',
                      //         style: TextStyle(
                      //           color: Colors.red.shade800,
                      //           fontSize: size.getS(14),
                      //           fontFamily: kFontFMedium,
                      //         ),
                      //         textAlign: TextAlign.center,
                      //       )),
                      // if (GlobalCVP.isServiceStore &&
                      //     (estimatedTime?.isNotEmpty ?? false)) ...[
                      //   SizedBox(height: size.getH(2)),
                      //   Container(
                      //     margin: EdgeInsets.only(top: size.getH(6)),
                      //     padding: EdgeInsets.symmetric(
                      //         horizontal: size.getW(16),
                      //         vertical: size.getH(2)),
                      //     decoration: BoxDecoration(
                      //         color: Colors.green.withOpacity(0.15),
                      //         borderRadius: BorderRadius.circular(10)),
                      //     child: Text(
                      //       "$estimatedTime minutes",
                      //       style: TextStyle(
                      //         fontSize: size.getS(18),
                      //         fontWeight: FontWeight.bold,
                      //         color: Colors.green.shade700,
                      //       ),
                      //     ),
                      //   )
                      // ]
                    ],
                  ),
                  if (GlobalCVP.isServiceStore && serviceItemList != null)
                    Wrap(
                      children: List.generate(serviceItemList!.length, (index) {
                        final _serviceItem = serviceItemList![index];
                        return SizedBox(
                          // color: Colors.amber,
                          width: size.getW(180),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "● ",
                                style: TextStyle(
                                  fontSize: size.getS(18),
                                  fontFamily: kFontFMedium,
                                  color: Colors.green.shade700,
                                  height: 1.2,
                                ),
                                maxLines: 1,
                              ),
                              Expanded(
                                child: Text(
                                  _serviceItem?.trim() ?? '',
                                  style: TextStyle(
                                    fontSize: size.getS(28),
                                    fontFamily: kFontFMedium,
                                    height: 1.3,
                                    color: Colors.green.shade700,
                                  ),
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  // if (promDiscount != null) ...[
                  //   ItemTimerView(
                  //     size: size,
                  //     promDiscount: promDiscount!,
                  //     refresh: onChanged,
                  //   ),
                  //   if ((promDiscount?.offerStartsIn?.inSeconds ?? 0) < 300)
                  //     Container(
                  //       margin: EdgeInsets.only(top: size.getH(6)),
                  //       padding: EdgeInsets.symmetric(
                  //           horizontal: size.getW(8), vertical: size.getH(2)),
                  //       decoration: BoxDecoration(
                  //           color: Colors.green.withOpacity(0.15),
                  //           borderRadius: BorderRadius.circular(5)),
                  //       child: Text(
                  //         promDiscount?.message ?? '',
                  //         style: TextStyle(
                  //           fontSize: size.getS(17),
                  //           fontFamily: kFontFMedium,
                  //           color: Colors.green.shade900,
                  //         ),
                  //       ),
                  //     ),
                  //   if ((promDiscount?.offerStartsIn?.inSeconds ?? 0) < 300)
                  //     Container(
                  //       margin: EdgeInsets.only(top: size.getH(6)),
                  //       padding: EdgeInsets.symmetric(
                  //           horizontal: size.getW(8), vertical: size.getH(2)),
                  //       decoration: BoxDecoration(
                  //           color: Colors.green.withOpacity(0.15),
                  //           borderRadius: BorderRadius.circular(5)),
                  //       child: Text(
                  //         "${LN.minPurchaseQty}: ${promDiscount?.tsCount}",
                  //         style: TextStyle(
                  //           fontSize: size.getS(17),
                  //           fontFamily: kFontFMedium,
                  //           color: Colors.green.shade900,
                  //         ),
                  //       ),
                  //     ),
                  // ],
                  if (addOnAdd != null)
                    Row(
                      children: [
                        if (showAdOnVar &&
                            adVarList != null &&
                            adVarList!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: SizedBox(
                              width: size.getW(200),
                              child: DropDownList(
                                borderRadius: 5,
                                borderColor: kSecondaryColor,
                                textColor: kSecondaryColor,
                                iconEnableColor: kSecondaryColor,
                                vPad: 14,
                                list: adVarList == null
                                    ? []
                                    : adVarList!
                                        .map((e) => e.name ?? '')
                                        .toList(),
                                onChange: (p0) {
                                  if (p0 == null || adVarList == null) return;
                                  for (final e in adVarList!) {
                                    e.isDefault = false;
                                  }
                                  adVarList![p0].isDefault = true;
                                  if (onChanged != null) onChanged!();
                                },
                                indexValue: selectedVar,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        Spacer(),
                        textButton(
                          size,
                          sideColor: Colors.green.shade700,
                          // width: 200,
                          backColor:
                              MaterialStateProperty.all(Colors.green.shade700),
                          title: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.shopping_cart_outlined,
                                  size: size.getS(24)),
                              SizedBox(width: size.getW(12)),
                              Flexible(
                                child: Text(
                                  LN.addToCart,
                                  style: TextStyle(
                                    fontSize: size.getS(18),
                                    fontFamily: kFontFMedium,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          onPressed: addOnAdd,
                        )
                      ],
                    ),
                ],
              ),
            ),
            // if (onBack != null)
            //   ElevatedButton(
            //       style: ButtonStyle(
            //         backgroundColor: MaterialStateProperty.all(kSecondaryColor),
            //         minimumSize: MaterialStateProperty.all(Size(0, 0)),
            //         shape: MaterialStateProperty.all(RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(100))),
            //         padding: MaterialStateProperty.all(EdgeInsets.symmetric(
            //             horizontal: size.getW(18), vertical: size.getH(10))),
            //       ),
            //       onPressed: onBack,
            //       child: Text("X", style: TextStyle(fontSize: size.getS(16)))
            //       // Icon(
            //       //   Icons.close,
            //       //   size: size.getS(24),
            //       //   color: Colors.white,
            //       // )s
            //       ),
          ],
        ),
      ],
    );
  }

  static Widget textButton(
    Ssize size, {
    Function()? onPressed,
    required Color sideColor,
    MaterialStateProperty<Color?>? backColor,
    required Widget title,
  }) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
          horizontal: size.getW(6), vertical: size.getH(6)),
      child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
              padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                vertical: size.getH(11.0),
                horizontal: size.getW(4),
              )),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(
                    color: sideColor,
                  ))),
              backgroundColor: backColor),
          child: title),
    );
  }

  static Widget filterSection(
    Ssize size, {
    final ProductFilterOption? filterType,
    Function()? onChanged,
  }) {
    if (filterType?.filterCategoryName == null ||
        filterType?.filterTypeOptions == null) return SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.15),
          ),
          padding: EdgeInsets.symmetric(
              horizontal: size.getW(24), vertical: size.getH(12)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Text(
                  filterType!.filterCategoryName ?? '',
                  style: TextStyle(
                    fontSize: size.getS(18),
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(width: size.getW(8)),
              if (filterType.childernCategories?.isNotEmpty ?? false)
                Padding(
                  padding: EdgeInsets.only(top: size.getH(0)),
                  child: SizedBox(
                      width: size.getW(200),
                      child: DropDownList(
                          hPad: 4,
                          vPad: 8,
                          fontSize: 16,
                          borderColor: Colors.black38,
                          list: filterType.childernCategories!
                              .map((e) => e.filterCategoryName ?? '')
                              .toList(),
                          indexValue: filterType.childSelectedIndex,
                          onChange: (p0) {
                            filterType.childSelectedIndex = p0;
                            if (onChanged != null) onChanged();
                          },
                          sufIcon: filterType.childSelectedIndex == null
                              ? null
                              : InkWell(
                                  onTap: () {
                                    filterType.childSelectedIndex = null;
                                    if (onChanged != null) onChanged();
                                  },
                                  child:
                                      Icon(Icons.close, size: size.getS(24))))),
                )
            ],
          ),
        ),
        SizedBox(
          height: size.getH(8),
        ),
        if ((filterType.childernCategories?.isNotEmpty ?? false) &&
            filterType.childSelectedIndex != null)
          Builder(builder: (context) {
            final _option =
                filterType.childernCategories![filterType.childSelectedIndex!];
            return Padding(
              padding: EdgeInsets.only(top: size.getH(4)),
              child: _optionSection(
                size,
                filterTypeOptions: _option.filterTypeOptions!,
                isMultiSelected: _option.selectionType ==
                    "1", // filterType.selectionType == "1": may be
                onChanged: () {
                  if (onChanged != null) onChanged();
                },
              ),
            );
          })
        else
          _optionSection(
            size,
            filterTypeOptions: filterType.filterTypeOptions!,
            isMultiSelected: filterType.selectionType == "1",
            onChanged: () {
              if (onChanged != null) onChanged();
            },
          ),
        // SizedBox(
        //   height: size.getH(12),
        // ),
        // Divider(
        //   height: 1,
        //   color: Colors.black54,
        // ),
      ],
    );
  }

  static Widget _optionSection(
    Ssize size, {
    required final List<FilterTypeOption> filterTypeOptions,
    final bool isMultiSelected = false,
    final Function()? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(filterTypeOptions.length, (index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  if (!isMultiSelected) {
                    for (int i = 0; i < filterTypeOptions.length; i++)
                      if (index != i) filterTypeOptions[i].isSelected = false;
                  }
                  filterTypeOptions[index].isSelected =
                      !filterTypeOptions[index].isSelected;
                  if (onChanged != null) onChanged();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.getW(16)),
                  child: SizedBox(
                    width: double.infinity,
                    height: size.getH(40),
                    child: Row(
                      children: [
                        Text(
                          filterTypeOptions[index].filterCategoryOptionName ??
                              '',
                          style: TextStyle(
                            fontSize: size.getS(18),
                            color: filterTypeOptions[index].isSelected
                                ? kSecondaryColor
                                : Colors.black,
                            fontFamily: kFontFMedium,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        if (filterTypeOptions[index].isSelected)
                          Padding(
                            padding: EdgeInsets.only(left: size.getW(12)),
                            child: Icon(
                              Icons.check,
                              color: kSecondaryColor,
                              size: size.getS(22),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              ),
              if (filterTypeOptions.length - 1 != index) Divider(),
            ],
          );
        }),
      ],
    );
  }

  static Widget header(
    Ssize size, {
    String? imageUrl,
    String? name,
    String? estimatedTime,
    String? serviceGender,
    Function()? onBack,
    bool hasPromo = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: size.getS(16), vertical: size.getH(12)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // if (imageUrl != null)
                //   ClipRRect(
                //       borderRadius: BorderRadius.circular(100),
                //       child: CachedNetworkImage(
                //           imageUrl: imageUrl,
                //           height: size.getW(60),
                //           width: size.getW(60),
                //           fit: BoxFit.fitHeight,
                //           placeholder: ImageError.load,
                //           errorWidget: ImageError.notSupportIcon)),
                // SizedBox(
                //   width: size.getW(16),
                // ),
                Expanded(
                  child: Text(
                    name ?? '',
                    style: TextStyle(
                      fontSize: size.getS(18),
                      color: Colors.white,
                      fontFamily: kFontFMedium,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (hasPromo) ...[
                  Container(
                    margin: EdgeInsets.only(left: size.getW(12)),
                    padding: EdgeInsets.symmetric(
                        horizontal: size.getW(16), vertical: size.getH(2)),
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      "● Promotion applied",
                      style: TextStyle(
                        fontSize: size.getS(18),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: size.getW(12))
                ],
                if (GlobalCVP.isServiceStore &&
                    (estimatedTime?.isNotEmpty ?? false)) ...[
                  if (serviceGender?.isNotEmpty ?? false)
                    Text(
                      "  ● ${serviceGender ?? ''}",
                      style: TextStyle(
                        fontSize: size.getS(16),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  Container(
                    margin: EdgeInsets.only(left: size.getW(12)),
                    padding: EdgeInsets.symmetric(
                        horizontal: size.getW(16), vertical: size.getH(2)),
                    decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      "● Estimated Time : ${Utils.convertMinutesToHours(estimatedTime, false)}",
                      style: TextStyle(
                        fontSize: size.getS(16),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: size.getW(12)),
                ],
              ],
            ),
          ),
          if (onBack != null)
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  minimumSize: MaterialStateProperty.all(Size(0, 0)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100))),
                  padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                      horizontal: size.getW(14), vertical: size.getH(6))),
                ),
                onPressed: onBack,
                child: Text("X",
                    style: TextStyle(
                        fontSize: size.getS(18), color: kSecondaryColor))
                // Icon(
                //   Icons.close,
                //   size: size.getS(24),
                //   color: Colors.white,
                // )s
                ),
        ],
      ),
    );
  }

  static Widget qtyIcon(
    Ssize size, {
    bool isDefault = false,
    required String title,
    Function()? onTap,
    double hw = 44,
    EdgeInsetsGeometry? margin,
  }) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      width: isDefault ? size.getW(hw) : 0,
      height: size.getH(hw),
      curve: Curves.easeInOut,
      child: Card(
        color: Colors.white,
        margin: margin,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: isDefault ? Colors.black38 : Colors.white)),
        child: InkWell(
          borderRadius: BorderRadius.circular(5),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: size.getH(2), horizontal: size.getW(2)),
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                    fontSize: size.getS((hw / 40) * 18),
                    color: isDefault ? Colors.black : Colors.white),
                overflow: TextOverflow.fade,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
