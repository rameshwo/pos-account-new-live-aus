import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/setting/store/store_pro_v2.dart';
import 'package:pos_account/widgets/input/dropdown/title_drop_down.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:provider/provider.dart';

import '../../widgets/store_card.dart';

class TaxTab extends StatelessWidget {
  const TaxTab({super.key});

  @override
  Widget build(BuildContext context) {
    final storePro = Provider.of<StoreProV2>(context);
    final size = Ssize(context);
    return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: size.getH(12),
            ),
            StoreCardUI(
                title: "System Tax Settings",
                iconData: Icons.settings_outlined,
                child: Padding(
                  padding: EdgeInsets.only(top: size.getH(12)),
                  child: GridView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: size.getW(24),
                      mainAxisSpacing: size.getH(16),
                      childAspectRatio: 4.5,
                    ),
                    children: [
                      TitleDropDown(
                        pWidth: 0.20,
                        list: (storePro.storeRes == null ||
                                storePro.storeRes!.taxExclusiveInclusiveTypes ==
                                    null)
                            ? []
                            : storePro.storeRes!.taxExclusiveInclusiveTypes!
                                .map((e) => e.value ?? '')
                                .toList(),
                        indexVal: storePro.taxInExIndex,
                        title: LN.tax,
                        onChanged: (int? p0) {
                          storePro.taxInExIndex = p0;
                          storePro.notify;
                        },
                      ),
                      TitleTextForm(
                        title: "Tax Percentage (%)",
                        pWidth: 0.24,
                        isReq: true,
                        hintText: "Tax Percentage",
                        textCltr: storePro.taxPercentCltr,
                        textInputType: TextInputType.number,
                        suffixIcon: Text(
                          "%",
                          style: TextStyle(
                            fontSize: size.getS(18),
                            color: Colors.black,
                            fontFamily: kFontFRegular,
                          ),
                        ),
                        suffixIconWidth: 24,
                        validator: (p0) {
                          if (p0 != null) {
                            final val = int.tryParse(p0);
                            if (val != null && val >= 0 && val >= 100) {
                              return LN.invalidNumber;
                            }
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                )),
          ],
        ));
  }
}
