import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/com/item_sec_tile.dart';
import 'package:pos_account/widgets/image/image_error.dart';
import 'package:pos_account/widgets/image/network_image_sec.dart';

class ItemTile extends StatelessWidget {
  final String name;
  final String? imgPath;
  final String vName;
  final String? price;
  final String? discountedPrice;
  final String? disPercent;
  final String? curSym;
  final String? outOfStockMessage;
  final String? stockMessage;
  final Function()? onTap;
  final Widget? topRight;
  final String? addText;
  final Ssize size;
  final Function()? refresh;
  final String? message;
  final bool hasPromo;

  const ItemTile({
    super.key,
    required this.name,
    this.imgPath,
    this.vName = "",
    this.price,
    this.outOfStockMessage,
    this.stockMessage,
    this.curSym,
    this.onTap,
    this.topRight,
    this.addText,
    this.discountedPrice,
    required this.size,
    this.refresh,
    this.disPercent,
    this.message,
    this.hasPromo = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(size.getS(2)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size.getS(10)),
      ),
      // elevation: 1,
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(5),
      // ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(size.getS(10)),
        highlightColor: kSecondaryColor.withAlpha(40),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(size.getS(0)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(size.getS(12)),
                    ),
                    // alignment: Alignment.topCenter,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(size.getS(10)),
                      child: imgPath != null && imgPath!.contains('assets')
                          ? Image.asset(
                              imgPath!,
                              height: size.getS(100),
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : NetworkImageSec(
                              image: imgPath,
                              height: size.getS(100),
                              width: double.infinity,
                              boxFit: BoxFit.cover,
                              placeHolder: ImageError.noItemImage(
                                  context, size.getS(100), double.infinity),
                              errWidget: ImageError.noItemImage(
                                  context, size.getS(100), double.infinity),
                            ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.getW(8), vertical: size.getH(4)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          name, // 17
                          style: TextStyle(
                            fontSize: size.getS(name.length > 32
                                ? 14.5
                                : name.length < 16
                                    ? 16
                                    : 15),
                            color: Colors.black,
                            fontFamily: kFontFMedium,
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      if (vName.isNotEmpty)
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            vName, //16
                            style: TextStyle(
                              fontSize: size.getS(name.length > 32 ? 14 : 15),
                              fontFamily: kFontFMedium,
                              color: Colors.black,
                              height: 0.7,
                            ),
                            // maxLines: 2,

                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      SizedBox(height: size.getH(4)),
                      if (price != null) ...[
                        // if (promDiscount?.isOfferStart ?? false)
                        //   Flexible(
                        //     flex: 3,
                        //     child: ItemPriceView(
                        //       size: size,
                        //       curSym: curSym,
                        //       initPrice: price,
                        //       priceAfterDiscount:
                        //           promDiscount?.discountedPrice,
                        //       fontRatio: 1.1,
                        //     ),
                        //   )
                        // else

                        ItemPriceView(
                          size: size,
                          curSym: curSym,
                          initPrice: price,
                          priceAfterDiscount: discountedPrice,
                          fontRatio: 1.1,
                        )
                      ] else if (topRight == null)
                        SizedBox(height: size.getH(40)),
                      // else if (hideAddBtn)
                      //   Flexible(child: Container())
                    ],
                  ),
                ),
                SizedBox(
                  height: size.getH(4),
                ),
                // if (stockMessage != null)
                //   Flexible(
                //     child: Container(
                //       margin: EdgeInsets.only(bottom: size.getH(4)),
                //       padding: EdgeInsets.symmetric(
                //           horizontal: size.getW(8), vertical: size.getH(2)),
                //       decoration: BoxDecoration(
                //           color: Colors.green.withOpacity(0.2),
                //           borderRadius: BorderRadius.circular(5)),
                //       child: Text(
                //         stockMessage ?? '',
                //         style: TextStyle(
                //           fontSize: size.getS(13),
                //           color: Colors.green.shade800,
                //           fontWeight: FontWeight.bold,
                //         ),
                //         maxLines: 2,
                //         textAlign: TextAlign.center,
                //       ),
                //     ),
                //   ),
                // Text(
                //   'GlobalCVP .viewWidget .viewAddToCartButton TextAlign FontWeight green',
                //   style: TextStyle(
                //     fontSize: size.getS(12),
                //     color: Colors.black,
                //   ),
                //   maxLines: 2,
                //   textAlign: TextAlign.center,
                // ),
                // if (GlobalCVP.stockExceedRestriction &&
                //     (outOfStockMessage?.isNotEmpty ?? false))
                //   Flexible(
                //     flex: 2,
                //     child: Container(
                //       padding: EdgeInsets.symmetric(
                //           horizontal: size.getW(8), vertical: size.getH(4)),
                //       decoration: BoxDecoration(
                //           color: Colors.red.withOpacity(0.2),
                //           borderRadius: BorderRadius.circular(5)),
                //       child: Text(
                //         outOfStockMessage!.isNotEmpty
                //             ? outOfStockMessage!
                //             : LN.outOfStock,
                //         style: TextStyle(
                //           fontSize: size.getS(12),
                //           color: Colors.red.shade800,
                //           fontWeight: FontWeight.bold,
                //         ),
                //         maxLines: 2,
                //         textAlign: TextAlign.center,
                //       ),
                //     ),
                //   )
                // else

                if (message?.isNotEmpty ?? false)
                  Center(
                    child: Text(
                      removeHtmlTags(message ?? ''),
                      style: TextStyle(
                        fontSize: size.getS(15),
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                  ),

                // Flexible(
                //   flex: 2,
                //   child: Container(
                //     padding: EdgeInsets.symmetric(
                //         horizontal: size.getW(8), vertical: size.getH(4)),
                //     decoration: BoxDecoration(
                //         color: Colors.green.withOpacity(0.2),
                //         borderRadius: BorderRadius.circular(5)),
                //     child: Text(
                //       message ?? '',
                //       style: TextStyle(
                //         fontSize: size.getS(12),
                //         color: Colors.green.shade800,
                //         fontWeight: FontWeight.bold,
                //       ),
                //       maxLines: 2,
                //       textAlign: TextAlign.center,
                //     ),
                //   ),
                // ),
                // if (hasPromo)
                //   Container(
                //     margin: EdgeInsets.only(
                //         top: size.getH(6), bottom: size.getH(4)),
                //     padding: EdgeInsets.symmetric(
                //         horizontal: size.getW(8), vertical: size.getH(2)),
                //     decoration: BoxDecoration(
                //         color: Colors.green.withOpacity(0.2),
                //         borderRadius: BorderRadius.circular(5)),
                //     child: Text.rich(
                //       TextSpan(
                //         text: "Promotion applied",
                //       ),
                //       style: TextStyle(
                //         fontSize: size.getS(15),
                //         color: Colors.green.shade800,
                //         fontWeight: FontWeight.bold,
                //       ),
                //       maxLines: 2,
                //       textAlign: TextAlign.center,
                //     ),
                //   )
                // else if (!hideAddBtn &&
                //     GlobalCVP.viewWidget.viewAddToCartButton)
                //   Flexible(
                //       flex: 2,
                //       child: Container(
                //           decoration: BoxDecoration(
                //               borderRadius: BorderRadius.circular(5),
                //               border: Border.all(color: Colors.red)),
                //           child: InkWell(
                //             onTap: onAdd,
                //             borderRadius: BorderRadius.circular(5),
                //             splashColor: kSecondaryColor.withOpacity(0.3),
                //             highlightColor: kSecondaryColor.withOpacity(0.15),
                //             child: Padding(
                //               padding: EdgeInsets.symmetric(
                //                   horizontal: size.getW(24),
                //                   vertical: size.getH(6)),
                //               child: Text(
                //                 addText ?? LN.add,
                //                 style: TextStyle(
                //                   fontSize: size.getS(15),
                //                   fontFamily: kFontFRegular,
                //                   color: Colors.red,
                //                 ),
                //               ),
                //             ),
                //           ))),
                // if (promDiscount != null)
                //   ItemTimerView(
                //     size: size,
                //     promDiscount: promDiscount!,
                //     refresh: refresh,
                //   ),
                // SizedBox(
                //   height:
                //       hideAddBtn || GlobalCVP.viewWidget.viewAddToCartButton
                //           ? size.getH(0)
                //           : size.getH(24),
                // ),
              ],
            ),
            if (GlobalCVP.stockExceedRestriction &&
                (outOfStockMessage?.isNotEmpty ?? false))
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: size.getW(8), vertical: size.getH(4)),
                decoration: BoxDecoration(
                    color: Colors.red.shade700,
                    borderRadius: BorderRadius.circular(20)),
                child: Text(
                  (outOfStockMessage?.isNotEmpty ?? false)
                      ? outOfStockMessage!
                      : LN.outOfStock,
                  style: TextStyle(
                    fontSize: size.getS(13),
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              )
            // else if ((promDiscount?.isOfferStart ?? false) &&
            //     (promDiscount?.offerStartsIn?.inSeconds ?? 0) < 300)
            //   _discountSec(
            //       title:
            //           "${hasPromo ? 'Upto ' : ''}${(promDiscount?.discountPercent ?? '').inQty}% OFF")
            else if ((discountedPrice?.isNotEmpty ?? false) &&
                disPercent != null &&
                disPercent.inDouble != 0)
              _discountSec(
                  title: "${hasPromo ? 'Upto ' : ''}${disPercent.inQty}% OFF"),
            if (topRight != null) topRight!,
          ],
        ),
      ),
    );
  }

  Widget _discountSec({
    required String title,
  }) {
    return Card(
      margin: EdgeInsets.zero,
      color: Colors.red.shade800,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: size.getH(4), horizontal: size.getS(8)),
        child: Text(
          title,
          style: TextStyle(
            fontSize: size.getS(16),
            color: Colors.white,
            fontFamily: kFontFMedium,
          ),
        ),
      ),
    );
  }

  String removeHtmlTags(String htmlText) {
    final RegExp exp =
        RegExp(r'<[^>]*>', multiLine: true, caseSensitive: false);
    return htmlText.replaceAll(exp, '').trim();
  }
}
