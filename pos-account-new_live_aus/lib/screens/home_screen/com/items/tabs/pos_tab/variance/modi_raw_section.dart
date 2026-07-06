import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';

import '../../../../../../../config/utils/order_utils.dart';
import '../../../../../../../model/home/menu/place_order/pos_res/com/feature_product.dart';
import 'new_modi_sec_2.dart';
import 'new_raw_sec_2.dart';
import 'new_spice_sec_2.dart';

enum ModiRawUpAction { Update, Save }

class ModiRawSection extends StatelessWidget {
  final ProductVariationModifier? proVarModifier;
  final Function(ModiRawUpAction?) onUpdate;
  const ModiRawSection({
    super.key,
    this.proVarModifier,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final _modifierType = OrderUtils.getModifierType(proVarModifier?.type);
    final size = Ssize(context);

    return Padding(
      padding: EdgeInsets.only(
          left: size.getW(12),
          right: size.getW(12),
          bottom: size.getW(16),
          top: size.getH(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Customize ${proVarModifier?.name ?? ""}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: size.getS(16),
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            'Adjust quantities for your perfect item.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: size.getS(14),
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: size.getH(12)),
          if (_modifierType == ModifierType.modifier)
            NewModiSec2(
              title: proVarModifier?.name ?? '',
              modifierItems: proVarModifier?.modifierItems,
              maxThresholdQuantity: proVarModifier?.maxThresholdQuantity,
              selectionType: proVarModifier?.selectionType,
              update: ({bool? isItemSelected}) {
                onUpdate(ModiRawUpAction.Update);
              },
              onSave: () {
                onUpdate(ModiRawUpAction.Save);
              },
            )
          else if (_modifierType == ModifierType.rawingre)
            RawIngreSec2(
              title: proVarModifier?.name ?? '',
              modifierItems: proVarModifier?.modifierItems,
              onUpdate: () {
                onUpdate(ModiRawUpAction.Update);
              },
              onSave: () {
                onUpdate(ModiRawUpAction.Save);
              },
            )
          else if (_modifierType == ModifierType.spice)
            SpiceSec2(
              title: proVarModifier?.name ?? '',
              modifierItems: proVarModifier?.modifierItems,
              onUpdate: () {
                onUpdate(ModiRawUpAction.Update);
              },
              onSave: () {
                onUpdate(ModiRawUpAction.Save);
              },
            ),
        ],
      ),
    );
  }
}
