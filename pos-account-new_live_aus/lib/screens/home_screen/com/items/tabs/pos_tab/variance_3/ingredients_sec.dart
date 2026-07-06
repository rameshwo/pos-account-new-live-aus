import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/model/home/menu/place_order/pos_res/com/feature_product.dart';

class IngredientSec extends StatelessWidget {
  final List<ProductVariationModifier> productIngredients;
  final Function() onUpdate;
  const IngredientSec({
    super.key,
    required this.productIngredients,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);

    // productIngredients.sort((x, y) =>
    //     (x.name ?? '').toLowerCase().compareTo((y.name ?? '').toLowerCase()));
    return Column(
      children: List.generate(productIngredients.length, (i) {
        if (productIngredients[i].modifierItems?.isNotEmpty ?? false)
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
                child: Text(
                  productIngredients[i].name ?? '',
                  style: TextStyle(
                    fontSize: size.getS(18),
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                height: size.getH(8),
              ),
              ...List.generate(productIngredients[i].modifierItems!.length,
                  (j) {
                final _isActive =
                    productIngredients[i].modifierItems![j].isActive ?? false;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {
                        productIngredients[i].modifierItems![j].isActive =
                            !_isActive;
                        onUpdate();
                      },
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: size.getW(16)),
                        child: SizedBox(
                          width: double.infinity,
                          height: size.getH(40),
                          child: Row(
                            children: [
                              Text(
                                productIngredients[i]
                                        .modifierItems![j]
                                        .productName ??
                                    '',
                                style: TextStyle(
                                  fontSize: size.getS(18),
                                  color:
                                      _isActive ? Colors.black45 : Colors.black,
                                  fontFamily: kFontFMedium,
                                  fontStyle:
                                      _isActive ? FontStyle.italic : null,
                                  decoration: _isActive
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              if (_isActive)
                                Padding(
                                  padding: EdgeInsets.only(left: size.getW(12)),
                                  child: Text(
                                    'x',
                                    style: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontSize: size.getS(20),
                                    ),
                                  ),
                                )
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (productIngredients[i].modifierItems!.length - 1 != j)
                      Divider(),
                  ],
                );
              }),
            ],
          );
        else
          return SizedBox.shrink();
      }),
    );
  }
}
