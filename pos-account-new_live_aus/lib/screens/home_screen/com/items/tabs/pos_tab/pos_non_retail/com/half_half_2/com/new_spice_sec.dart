import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/model/home/menu/place_order/pos_res/com/feature_product.dart';
import 'package:pos_account/providers/menu/place_order_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/pos_tab/variance_3/spice_sec.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:provider/provider.dart';

class NewSpiceSec extends StatelessWidget {
  final String title;
  final List<ModifierItem>? modifierItems;
  final Function() onUpdate;
  const NewSpiceSec(
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
          SizedBox(height: size.getH(12)),
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
          GridView.count(
            crossAxisCount: 4,
            childAspectRatio: 2,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            padding: EdgeInsets.symmetric(horizontal: size.getW(16)),
            children: [
              ...List.generate(modifierItems!.length, (j) {
                final _spice = modifierItems![j];
                return SizedBox(
                  width: size.getW(140),
                  child: SpiceWidget(
                    name: _spice.productName ?? '',
                    imgPath: _spice.imageUrl,
                    isChecked: _spice.isActive ?? false,
                    size: size,
                    onChanged: (val) {
                      for (final e in modifierItems!) {
                        if (e.id?.toLowerCase() == _spice.id?.toLowerCase()) {
                          e.isActive = !(e.isActive ?? false);
                        } else {
                          e.isActive = false;
                        }
                      }
                      onUpdate();
                      _placeOrder.notify;
                    },
                  ),
                );
              }),
            ],
          ),
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
