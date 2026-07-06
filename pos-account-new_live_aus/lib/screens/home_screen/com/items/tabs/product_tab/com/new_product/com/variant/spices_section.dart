import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/model/common/table_location.dart';
import 'package:pos_account/providers/product/new_product_pro.dart';
import 'package:pos_account/widgets/cus_expansion_tile.dart';
import 'package:provider/provider.dart';

import 'info_row.dart';

class SpicesSection extends StatelessWidget {
  final Ssize size;
  final String title;
  final Function()? onAdd;
  final List<TableLocation> spicesList;
  final int vIndex;
  final Function(int)? remove;
  final GlobalKey<AnimatedListState> supKey;
  final Function(int) onTap;

  SpicesSection({
    super.key,
    required this.size,
    required this.title,
    this.onAdd,
    required this.vIndex,
    required this.spicesList,
    this.remove,
    required this.onTap,
  }) : supKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    final newProdPro = Provider.of<NewProductPro>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InfoRowSec(
          title: "Spices",
          subTitle:
              ' (Add spice preferences like "Mild", "Hot", or "Extra Hot" that customers can select when ordering this product.)',
          iconData: Icons.local_fire_department_outlined,
        ),
        Container(
          // width: newProdPro.editData == null
          //     ? MediaQuery.of(context).size.width * 0.5
          //     : MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(
            right: size.getW(2),
          ),
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
                      newProdPro.supExFun = val;
                    },
                    onExpansionChanged: (val) =>
                        newProdPro.supplierExpand = val,
                    tilePadding: EdgeInsets.zero,
                    childrenPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Row(
                      children: [
                        Text.rich(
                          TextSpan(
                            text: title,
                            style: TextStyle(
                              fontSize: size.getS(18),
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: size.getW(18),
                        ),
                      ],
                    ),
                    children: [
                      spicesList.isNotEmpty
                          ? Align(
                              alignment: Alignment.centerLeft,
                              child: Wrap(
                                  alignment: WrapAlignment.start,
                                  spacing: size.getW(8),
                                  runSpacing: size.getH(8),
                                  children: [
                                    for (int i = 0; i < spicesList.length; i++)
                                      InkWell(
                                        onTap: () {
                                          onTap(i);
                                        },
                                        child: Container(
                                          width: size.getW(200),
                                          decoration: BoxDecoration(
                                            color: spicesList[i].isSelected ??
                                                    false
                                                ? kSecondaryColor
                                                : Colors.white,
                                            border: Border.all(
                                              color: spicesList[i].isSelected ??
                                                      false
                                                  ? kSecondaryColor
                                                  : Colors.white,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          height: 50,
                                          child: Center(
                                            child: Text(
                                              spicesList[i].name ?? '',
                                              style: TextStyle(
                                                fontSize: size.getS(16),
                                                color:
                                                    spicesList[i].isSelected ??
                                                            false
                                                        ? Colors.white
                                                        : Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                  ]),
                            )
                          : SizedBox(),
                    ],
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
