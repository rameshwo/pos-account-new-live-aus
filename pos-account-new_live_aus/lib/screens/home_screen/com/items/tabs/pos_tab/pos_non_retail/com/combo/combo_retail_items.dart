import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/providers/menu/place_order_pro.dart';

class ComboRetailItems extends StatelessWidget {
  final PlaceOrderPro placePro;
  const ComboRetailItems({super.key, required this.placePro});

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final catList =
        placePro.comboDetailById?.setMenuProductListViewModelWithCategory ?? [];
    return Card(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: size.getW(12), vertical: size.getH(8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Product List",
                style: TextStyle(
                  fontSize: size.getS(20),
                  color: Colors.black,
                  fontFamily: kFontFMedium,
                ),
              ),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  children: List.generate(
                    catList.length,
                    (i) {
                      final itemList =
                          catList[i].setMenuProductListViewModels ?? [];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${i + 1}. ${catList[i].categoryName ?? ''}",
                            style: TextStyle(
                              fontSize: size.getS(18),
                              color: Colors.black,
                              fontFamily: kFontFMedium,
                            ),
                          ),
                          ...List.generate(itemList.length, (j) {
                            return Padding(
                              padding: EdgeInsets.only(left: size.getW(15)),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '> ',
                                    style: TextStyle(
                                      fontSize: size.getS(18),
                                      color: Colors.black,
                                      fontFamily: kFontFRegular,
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      itemList[j].name ?? '',
                                      style: TextStyle(
                                        fontSize: size.getS(18),
                                        color: Colors.black,
                                        fontFamily: kFontFRegular,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                          if (catList.length - 1 != i)
                            Divider(
                              color: Colors.black87,
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
