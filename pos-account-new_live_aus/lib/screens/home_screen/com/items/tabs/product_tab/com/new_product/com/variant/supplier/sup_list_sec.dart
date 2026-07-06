import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/providers/product/new_product_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/product_tab/com/new_product/com/variant/info_row.dart';
import 'package:pos_account/widgets/cus_expansion_tile.dart';
import 'package:provider/provider.dart';
import '../add_icon_b.dart';
import 'sup_sec.dart';

class SupplierListSec extends StatelessWidget {
  final Ssize size;
  final String title;
  final Function()? onAdd;
  final List<Supplier> supplierList;
  final int vIndex;
  final Function(int)? remove;
  final GlobalKey<AnimatedListState> supKey;

  SupplierListSec({
    super.key,
    required this.size,
    required this.title,
    this.onAdd,
    required this.vIndex,
    required this.supplierList,
    this.remove,
  }) : supKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    final newProdPro = Provider.of<NewProductPro>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InfoRowSec(
          title: "Suppliers",
          subTitle:
              ' (Link this variation to your suppliers. You can add multiple suppliers and specify their item codes.)',
          iconData: Icons.local_shipping_outlined,
        ),
        Container(
          // width: newProdPro.editData == null
          //     ? MediaQuery.of(context).size.width * 0.5
          //     : MediaQuery.of(context).size.width,
          // margin: EdgeInsets.only(
          //   top: size.getH(12),
          // ),
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
                  onExpansionChanged: (val) => newProdPro.supplierExpand = val,
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
                      AddIconB(
                        size: size,
                        onTap: onAdd,
                      )
                    ],
                  ),
                  children: [
                    if (supplierList.isNotEmpty)
                      AnimatedList(
                          key: newProdPro.supplierKeyList[vIndex],
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          initialItemCount: supplierList.length,
                          itemBuilder: (ctx, i, animation) {
                            if (i < supplierList.length) {
                              return VariantSupSec(
                                animation: animation,
                                remove:
                                    remove == null ? null : () => remove!(i),
                                supplier: supplierList[i],
                              );
                            } else {
                              return Container();
                            }
                          }),
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
