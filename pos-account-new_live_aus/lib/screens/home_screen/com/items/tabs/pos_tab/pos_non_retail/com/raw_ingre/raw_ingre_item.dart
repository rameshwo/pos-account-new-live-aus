import 'package:flutter/material.dart';
import 'package:pos_account/config/responsive.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/menu/place_order/pos_res/pos_ingre_res.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/pos_tab/pos_non_retail/com/raw_ingre/raw_ingre_dia.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import '../item_tile.dart';

class RawIngreItems extends StatelessWidget {
  final List<RawLooseIngredientProduct>? dataList;
  final String? curSym;
  const RawIngreItems({super.key, this.dataList, this.curSym});

  Future<void> dia(BuildContext context,
      {RawLooseIngredientProduct? rawIngredient}) async {
    await showDialog(
        context: context,
        builder: (_) {
          return SimpleDialog(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            children: [
              RawIngreDia(
                rawIngredient: rawIngredient,
                curSym: curSym,
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (dataList?.isNotEmpty ?? false)
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisExtent:
                  size.getH(Responsive.isDesktop(context) ? 224 : 196),
              crossAxisCount: size.isProt ? 3 : 4,
              crossAxisSpacing: size.getW(2),
              mainAxisSpacing: size.getH(4),
            ),
            itemCount: dataList?.length ?? 0,
            itemBuilder: (context, i) {
              final unit = dataList![i].maxMeasurementName ?? '';
              final unitText = unit.isNotEmpty ? ('/$unit') : '';

              final outOfStock = !GlobalCVP.isHospitality &&
                  (dataList?[i].availiableStock == null ||
                      dataList![i].availiableStock!.isEmpty ||
                      (double.tryParse(dataList![i].availiableStock!) ?? 0) ==
                          0);

              return SizedBox(
                height: size.getH(240),
                width: size.getW(190),
                child: ItemTile(
                  name: dataList![i].name ?? '',
                  size: size,
                  // hideAddBtn: true,
                  curSym: curSym,

                  price: "${dataList![i].sellingPricePerUnit}$unitText",
                  // () =>
                  //     "$curSym${dataList![i].sellingPricePerUnit}$_unitText",
                  onTap: () {
                    dia(context, rawIngredient: dataList![i]);
                  },
                  stockMessage: outOfStock
                      ? null
                      : "${LN.stock} ${Utils.abbreviateNumber(dataList![i].availiableStock)} $unit",
                  outOfStockMessage: outOfStock ? LN.outOfStock : null,
                ),
              );
            },
          )
        else
          NoItemsSec(size: size, title: "No Raw Ingredients Found"),

        // Wrap(
        //   spacing: size.getW(2),
        //   runSpacing: size.getH(4),
        //   children: List.generate(
        //     dataList!.length,
        //     (i) {
        //       final _unit = dataList![i].maxMeasurementName ?? '';
        //       final _unitText = _unit.isNotEmpty ? ('/' + _unit) : '';

        //       final _outOfStock = dataList?[i].availiableStock == null ||
        //           dataList![i].availiableStock!.isEmpty ||
        //           (double.tryParse(dataList![i].availiableStock!) ?? 0) == 0;

        //       return SizedBox(
        //         height: size.getH(240),
        //         width: size.getW(size.isProt ? 188 : 190),
        //         child: ItemTile(
        //           name: dataList![i].name ?? '',
        //           size: size,
        //           hideAddBtn: true,
        //           curSym: curSym,

        //           price: "${dataList![i].sellingPricePerUnit}$_unitText",
        //           // () =>
        //           //     "$curSym${dataList![i].sellingPricePerUnit}$_unitText",
        //           onTap: () {
        //             dia(context, rawIngredient: dataList![i]);
        //           },
        //           stockMessage: _outOfStock
        //               ? null
        //               : "${LN.inStock} : ${dataList![i].availiableStock} $_unit",
        //           outOfStockMessage: _outOfStock ? LN.outOfStock : null,
        //         ),
        //       );
        //     },
        //   ),
        // ),
        SizedBox(
          height: size.getH(16),
        )
      ],
    );
  }
}
