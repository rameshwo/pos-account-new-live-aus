import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/model/home/menu/place_order/pos_res/com/feature_product.dart';
import 'package:pos_account/providers/menu/place_order_pro.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:provider/provider.dart';

import '../variance_3/spice_sec.dart';

class SpiceSec2 extends StatelessWidget {
  final String title;
  final List<ModifierItem>? modifierItems;
  final Function() onUpdate;
  final Function()? onSave;
  const SpiceSec2(
      {super.key,
      required this.title,
      this.modifierItems,
      required this.onUpdate,
      this.onSave});

  @override
  Widget build(BuildContext context) {
    final _placePro = Provider.of<PlaceOrderPro>(context);
    final size = Ssize(context);
    return Flexible(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: double.infinity,
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
                    ],
                  ),
                ),
                const Divider(
                  color: Colors.black45,
                ),
                SizedBox(
                  height: size.getH(12),
                ),
                Flexible(
                  child: GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 4.5,
                    shrinkWrap: true,
                    // physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: size.getH(12),
                    crossAxisSpacing: size.getW(12),
                    padding: EdgeInsets.symmetric(horizontal: size.getW(12)),
                    children: [
                      ...List.generate(modifierItems!.length, (j) {
                        final _spice = modifierItems![j];
                        return SpiceWidget(
                          name: _spice.productName ?? '',
                          imgPath: _spice.imageUrl,
                          isChecked: _spice.isActive ?? false,
                          onChanged: (val) {
                            for (final e in modifierItems!) {
                              if (e.id?.toLowerCase() ==
                                  _spice.id?.toLowerCase()) {
                                e.isActive = !(e.isActive ?? false);
                              } else {
                                e.isActive = false;
                              }
                            }
                            onUpdate();
                            _placePro.notify;
                          },
                          size: size,
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: size.getH(12),
          ),
          Padding(
            padding: EdgeInsets.all(size.getS(8)),
            child: LoadButton(
                width: double.infinity,
                btnText: "Confirm",
                onsave: onSave ??
                    () {
                      Navigator.pop(context);
                    }),
          ),
        ],
      ),
    );
  }
}
