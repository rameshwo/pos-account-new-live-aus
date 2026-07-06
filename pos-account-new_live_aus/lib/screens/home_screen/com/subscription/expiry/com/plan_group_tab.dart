import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/providers/subs_billing/sub_billing_pro.dart';

import '../../../../../../constant/constant.dart';

class PlanGroupTab extends StatelessWidget {
  const PlanGroupTab({super.key, required this.subsBillingPro});

  final SubsBillingPro subsBillingPro;

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          subsBillingPro.subsPlanGroup.length,
          (index) => Padding(
            padding:
                EdgeInsets.only(right: size.getW(12.0), bottom: size.getH(12)),
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      subsBillingPro.subsPlanIndex == index
                          ? kSecondaryColor
                          : Colors.grey,
                    ),
                    padding: WidgetStateProperty.all(EdgeInsets.symmetric(
                        horizontal: size.getW(12), vertical: size.getH(8)))),
                onPressed: () {
                  subsBillingPro.subsPlanIndex = index;
                  subsBillingPro.notify;
                },
                child: Text(
                  subsBillingPro.subsPlanGroup[index],
                  style: TextStyle(
                    fontSize: size.getS(14),
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )),
          ),
        ));
  }
}
