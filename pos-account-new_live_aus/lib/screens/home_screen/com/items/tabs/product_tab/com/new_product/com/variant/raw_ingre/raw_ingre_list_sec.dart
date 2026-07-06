import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/providers/product/new_product_pro.dart';
import 'package:pos_account/widgets/cus_expansion_tile.dart';
import 'package:provider/provider.dart';

import '../info_row.dart';
import 'raw_ingre_sec.dart';

class RawIngreListSec extends StatelessWidget {
  final Ssize size;
  final String title;
  final Function()? onAdd;
  final List<RawIngre> ingreList;
  final int vIndex;
  final Function(int)? remove;
  final GlobalKey<AnimatedListState> ingreKey;

  RawIngreListSec({
    super.key,
    required this.size,
    required this.title,
    this.onAdd,
    required this.ingreList,
    required this.vIndex,
    this.remove,
  }) : ingreKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    final newProdPro = Provider.of<NewProductPro>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InfoRowSec(
          title: "Ingredients",
          subTitle:
              ' (List all ingredients used in this product. This helps with inventory management and cost calculation.)',
          iconData: Icons.restaurant,
        ),
        Container(
          decoration: BoxDecoration(
            color: kBackgroundColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black12),
          ),
          padding: EdgeInsets.symmetric(
              vertical: size.getH(8), horizontal: size.getW(24)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Theme(
                data: ThemeData().copyWith(dividerColor: Colors.transparent),
                child: CusExpansionTile(
                  initiallyExpanded: true,
                  assignFunction: (val) {
                    newProdPro.ingreExFun = val;
                  },
                  onExpansionChanged: (val) => newProdPro.ingreExpand = val,
                  tilePadding: EdgeInsets.zero,
                  childrenPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  title: Row(
                    children: [
                      Text(
                        "Raw Ingredients",
                        style: TextStyle(
                          fontSize: size.getS(18),
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  children: [
                    // Row(
                    //   children: [
                    //     Text.rich(
                    //       TextSpan(
                    //         text: title,
                    //         style: TextStyle(
                    //           fontSize: size.getS(18),
                    //           color: Colors.black,
                    //         ),
                    //       ),
                    //     ),
                    //     SizedBox(
                    //       width: size.getW(18),
                    //     ),
                    //     AddIconB(
                    //       size: size,
                    //       onTap: onAdd,
                    //     )
                    //   ],
                    // ),
                    ingreList.isEmpty
                        ? Container()
                        : AnimatedList(
                            key: newProdPro.ingreKeyList[vIndex],
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            initialItemCount: ingreList.length,
                            itemBuilder: (ctx, i, animation) {
                              if (i < ingreList.length) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: size.getH(4),
                                    ),
                                    RawIngreSec(
                                      animation: animation,
                                      remove: remove == null
                                          ? null
                                          : () => remove!(i),
                                      rawIngre: ingreList[i],
                                      pro: newProdPro,
                                    ),
                                    if (ingreList.length - 1 > i)
                                      Divider(
                                        color: Colors.black38,
                                      ),
                                  ],
                                );
                              } else {
                                return Container();
                              }
                            }),
                    SizedBox(
                      height: size.getH(16),
                    ),
                    DottedBorder(
                        color: kSecondaryColor,
                        strokeWidth: 1.5,
                        dashPattern: [6, 4],
                        radius: Radius.circular(5),
                        borderType: BorderType.RRect,
                        padding: EdgeInsets.zero,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: onAdd,
                            borderRadius: BorderRadius.circular(5),
                            child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.getW(24),
                                    vertical: size.getH(6)),
                                child: Text(
                                  "+ Add Ingredients",
                                  style: TextStyle(
                                    fontSize: size.getS(16),
                                    color: kSecondaryColor,
                                    fontFamily: kFontFMedium,
                                  ),
                                )),
                          ),
                        )),
                    SizedBox(
                      height: size.getH(12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
