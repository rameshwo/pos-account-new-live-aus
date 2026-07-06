import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/model/home/menu/place_order/pos_res/com/feature_product.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/menu/payment_pro.dart';
import 'package:pos_account/providers/menu/place_order_pro.dart';
import 'package:pos_account/providers/menu/pos_retail_pro.dart';
import 'package:pos_account/providers/subs_billing/sub_billing_pro.dart';
import 'package:pos_account/screens/home_screen/com/subscription/change_plan/com/choose_plan_dia.dart';
import 'package:provider/provider.dart';
import 'pos_non_retail/pos_tab.dart';
import 'pos_retail/pos_retail_section.dart';

class PosTabPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> scafKey;
  const PosTabPage({
    super.key,
    required this.scafKey,
  });

  void showDia(BuildContext context) async {
    final subBillPro = Provider.of<SubsBillingPro>(context, listen: false);
    await subBillPro.getAllBillAndSubs();
    subBillPro.clearListData();
    subBillPro.subPlanListLoad = true;
    subBillPro.notify;
    subBillPro.getSubPlans();
    return showDialog(
        context: context,
        builder: (builder) => SimpleDialog(
              backgroundColor: kPrimaryColor,
              titlePadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              children: [ChoosePlanDia()],
            ));
  }

  @override
  Widget build(BuildContext context) {
    final placeOrderPro = Provider.of<PlaceOrderPro>(context);
    final posPro = Provider.of<PosRetailPro>(context);
    final payPro = Provider.of<PaymentPro>(context);
    return BarcodeKeyboardListener(
      bufferDuration: Duration(milliseconds: 400),
      onBarcodeScanned: (String val) async {
        if (FocusManager.instance.primaryFocus?.hasFocus ?? false) {
          SystemChannels.textInput.invokeMethod('TextInput.hide');
        }
        // print("--$val ${_payPro.isOnPaymentScreen}");
        if (payPro.isOnPaymentScreen) return;

        if (GlobalCVP.isRetailStore) {
          await posPro.getProductFromBarCode(val, context);
        } else if (GlobalCVP.isHospitality) {
          await placeOrderPro.getProductFromBarCode(val,
              openVariance: ({FeaturedProduct? featuredProduct}) {
            if (featuredProduct == null) return;

            placeOrderPro.productDetailView = null;
            PosTab.selectVarience(
              context,
              placeOrderPro: placeOrderPro,
              // curSym: placeOrderPro.curSym ?? '',
              featuredProduct: featuredProduct,
            );
          });
        }
      },
      child: GlobalCVP.isRetailStore
          ? POSRetailSection(
              placeOrderPro: placeOrderPro,
              onTapSubs: () => showDia(context),
            )
          : PosTab(
              placeOrderPro: placeOrderPro,
              cvp: GlobalCVP,
              scafKey: scafKey,
              onTapSubs: () => showDia(context),
            ),
    );
  }
}
