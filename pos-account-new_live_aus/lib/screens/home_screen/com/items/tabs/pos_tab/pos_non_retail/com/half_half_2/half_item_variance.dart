import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pos_account/config/utils/order_utils.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/providers/menu/place_order_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/pos_tab/variance_3/ingredients_sec.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/pos_tab/variance_3/modifier_section.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/pos_tab/variance_3/spice_sec.dart';
import 'package:pos_account/widgets/image/image_error.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import 'package:provider/provider.dart';

class HalfItemVariance extends StatelessWidget {
  const HalfItemVariance({super.key});

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final placeOrderPro = Provider.of<PlaceOrderPro>(context);
    return Container(
      constraints: BoxConstraints(
        maxHeight: size.height / 1.15,
        minHeight: size.height / 5,
      ),
      width: size.width / 2.4,
      padding: EdgeInsets.symmetric(
          horizontal: size.getS(16), vertical: size.getH(12)),
      child: placeOrderPro.currentSelectedModifier != null
          ? Column(
              children: [
                Row(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: CachedNetworkImage(
                            imageUrl: placeOrderPro
                                    .currentSelectedModifier?.imageUrl ??
                                '',
                            height: size.getW(48),
                            width: size.getW(48),
                            fit: BoxFit.fitHeight,
                            placeholder: ImageError.load,
                            errorWidget: ImageError.notSupportIcon)),
                    SizedBox(
                      width: size.getW(12),
                    ),
                    Expanded(
                      child: Text(
                        (placeOrderPro.currentSelectedModifier?.productName ??
                            ''),
                        style: TextStyle(
                          fontSize: size.getS(20),
                          color: Colors.black,
                          fontFamily: kFontFMedium,
                        ),
                      ),
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red),
                          minimumSize: MaterialStateProperty.all(Size(0, 0)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100))),
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                  horizontal: size.getW(14),
                                  vertical: size.getH(6))),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("X",
                            style: TextStyle(
                                fontSize: size.getS(18), color: Colors.white))),
                  ],
                ),
                SizedBox(height: size.getH(8)),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        if (placeOrderPro.currentSelectedModifier
                                ?.modifierItemModifiers?.isNotEmpty ??
                            false)
                          AnimatedSwitcher(
                            duration: Duration(milliseconds: 300),
                            child: ModifierSection(
                              width: 300,
                              key: ValueKey(placeOrderPro.varianceLoading),
                              curSym: placeOrderPro.curSym ?? '',
                              productPriceModifiers: placeOrderPro
                                      .currentSelectedModifier
                                      ?.modifierItemModifiers
                                      ?.whereModiType(ModifierType.modifier) ??
                                  [],
                              update: ({bool? isItemSelected}) =>
                                  placeOrderPro.notify,
                            ),
                          )
                        else
                          NoItemsSec(
                            size: size,
                            title: "No Modifier found",
                            iconHeight: 140,
                          ),
                        SizedBox(height: size.getH(12)),
                        IngredientSec(
                          productIngredients: placeOrderPro
                                  .currentSelectedModifier
                                  ?.modifierItemModifiers
                                  ?.whereModiType(ModifierType.rawingre) ??
                              [],
                          onUpdate: () {
                            placeOrderPro.notify;
                          },
                        ),
                        SpiceSection(
                          isItem: false,
                          spiceList: placeOrderPro
                              .currentSelectedModifier?.modifierItemModifiers
                              ?.whereModiType(ModifierType.spice),
                          onChanged: () {
                            placeOrderPro.notify;
                          },
                        ),
                        SizedBox(height: size.getH(24)),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: size.getH(12),
                ),
                LoadButton(
                  width: double.infinity,
                  btnText: "+ Add",
                  onsave: () {
                    Navigator.pop(context);
                  },
                )
              ],
            )
          : NoItemsSec(size: size, title: "No items has been selected"),
    );
  }
}
