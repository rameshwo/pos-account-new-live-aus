import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/model/home/menu/place_order/pos_res/com/feature_product.dart';
import 'package:pos_account/providers/menu/place_order_pro.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:provider/provider.dart';

class NewRawIngreSec extends StatelessWidget {
  final String title;
  final List<ModifierItem>? modifierItems;
  final Function() onUpdate;
  const NewRawIngreSec(
      {super.key,
      required this.title,
      this.modifierItems,
      required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final _placeOrder = Provider.of<PlaceOrderPro>(context);
    return Container(
      width: size.width / 2.5,
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
                  title,
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
            height: size.getH(8),
          ),
          ...List.generate(modifierItems!.length, (j) {
            final _isActive = modifierItems![j].isActive ?? false;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    modifierItems![j].isActive = !_isActive;
                    onUpdate();
                    _placeOrder.notify;
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: size.getW(16)),
                    child: SizedBox(
                      width: double.infinity,
                      height: size.getH(40),
                      child: Row(
                        children: [
                          Text(
                            modifierItems![j].productName ?? '',
                            style: TextStyle(
                              fontSize: size.getS(18),
                              color: _isActive ? Colors.black45 : Colors.black,
                              fontFamily: kFontFMedium,
                              fontStyle: _isActive ? FontStyle.italic : null,
                              decoration:
                                  _isActive ? TextDecoration.lineThrough : null,
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
                if (modifierItems!.length - 1 != j) Divider(),
              ],
            );
          }),
          Padding(
            padding: EdgeInsets.all(size.getH(8)),
            child: LoadButton(
                width: double.infinity,
                btnText: "Confirm",
                onsave: () {
                  Navigator.pop(context);
                }),
          ),
        ],
      ),
    );
  }
}
