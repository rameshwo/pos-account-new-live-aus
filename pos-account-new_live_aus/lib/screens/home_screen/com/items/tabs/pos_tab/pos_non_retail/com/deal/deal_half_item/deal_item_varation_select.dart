import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/model/home/menu/place_order/pos_res/com/feature_product.dart';
import 'package:pos_account/providers/menu/place_order_pro.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:provider/provider.dart';

class DealItemVariationSelectionDia extends StatelessWidget {
  final List<ModifierItem> modifierList;
  final Function(ModifierItem item) onUpdate;
  const DealItemVariationSelectionDia({
    super.key,
    required this.modifierList,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final _placeOrder = Provider.of<PlaceOrderPro>(context);
    return Container(
      width: size.width / 2,
      constraints: BoxConstraints(
        maxHeight: size.height / 1.2,
        minHeight: size.height / 5,
      ),
      child: Column(
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
              children: [
                Text(
                  modifierList.first.productName ?? '',
                  style: TextStyle(
                    fontSize: size.getS(18),
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Spacer(),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close))
              ],
            ),
          ),
          SizedBox(
            height: size.getH(24),
          ),
          // if (modifierList.length < 3)
          Column(
            children: [
              ...List.generate(modifierList.length, (index) {
                return SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: size.getW(6)),
                    child: _variationSec(
                      size,
                      modifierList[index],
                      curSym: _placeOrder.curSym ?? '',
                      onUpdate: () {
                        for (final e in modifierList) {
                          if (e.id?.toLowerCase() ==
                              modifierList[index].id?.toLowerCase()) {
                            e.isActive = !(e.isActive ?? false);
                          } else {
                            e.isActive = false;
                          }
                        }
                        onUpdate(modifierList[index]);
                        _placeOrder.notify;
                      },
                    ),
                  ),
                );
              }),
            ],
          ),
          // else
          //   GridView.count(
          //     shrinkWrap: true,
          //     physics: NeverScrollableScrollPhysics(),
          //     padding: EdgeInsets.symmetric(horizontal: size.getW(16)),
          //     crossAxisCount: 3,
          //     childAspectRatio: 3.5,
          //     crossAxisSpacing: 10,
          //     mainAxisSpacing: 10,
          //     children: [
          //       ...List.generate(modifierList.length, (index) {
          //         return _variationSec(
          //           size,
          //           modifierList[index],
          //           curSym: _placeOrder.curSym ?? '',
          //           onUpdate: () {
          //             for (final e in modifierList) {
          //               if (e.id?.toLowerCase() ==
          //                   modifierList[index].id?.toLowerCase()) {
          //                 e.isActive = !(e.isActive ?? false);
          //               } else {
          //                 e.isActive = false;
          //               }
          //             }
          //             onUpdate(modifierList[index]);
          //             _placeOrder.notify;
          //           },
          //         );
          //       }),
          //     ],
          //   ),
          SizedBox(
            height: size.getH(24),
          ),
          Padding(
            padding: EdgeInsets.all(size.getH(8)),
            child: LoadButton(
                width: double.infinity,
                btnText: "Confirm",
                onsave: () {
                  if (modifierList.any((a) => a.isActive ?? false)) {
                    onUpdate(
                        modifierList.firstWhere((a) => a.isActive ?? false));
                  }
                  Navigator.pop(context);
                }),
          ),
        ],
      ),
    );
  }

  Widget _variationSec(
    Ssize size,
    ModifierItem _modifier, {
    String curSym = "",
    required Function() onUpdate,
  }) {
    final _isDefault = _modifier.isActive ?? false;

    final _disPrice = _modifier.discountedPrice;
    final _actPrice = _modifier.actualPrice;

    return InkWell(
      onTap: onUpdate,
      child: Container(
        decoration: BoxDecoration(
            color: _isDefault ? kSecondaryColor : Colors.white,
            border: Border.all(
              color: _isDefault ? kSecondaryColor : Colors.black45,
            ),
            borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: size.getH(4), horizontal: size.getW(12)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  _modifier.variationName ?? '',
                  style: TextStyle(
                    fontSize: size.getS(17),
                    color: _isDefault ? Colors.white : Colors.black,
                    fontFamily: _isDefault ? kFontFMedium : null,
                  ),
                  maxLines: 1,
                  textAlign: TextAlign.center,
                ),
              ),
              Text(
                "$curSym${(_disPrice?.isNotEmpty ?? false) ? _disPrice : _actPrice}",
                style: TextStyle(
                  fontSize: size.getS(15),
                  fontFamily: kFontFMedium,
                  color: _isDefault ? Colors.white : Colors.black,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
