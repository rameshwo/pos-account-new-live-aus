import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/menu/orders_pro.dart';
import 'package:provider/provider.dart';

class AllOrderButton extends StatelessWidget {
  const AllOrderButton({super.key});

  @override
  Widget build(BuildContext context) {
    final showButton = GlobalCVP.isServiceStore
        ? GlobalCVP.viewWidget.viewServicesButton
        : GlobalCVP.viewWidget.viewOrdersButton;
    if (showButton) {
      final size = Ssize(context);
      final cvp = GlobalCVP;
      final isNull = cvp.getMainPage == MainPage.OrderPage &&
          Provider.of<OrderPro>(context).orderDetailSecRes == null;
      return SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.getW(0)),
          child: ElevatedButton(
              style: ButtonStyle(
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5))),
                  backgroundColor: WidgetStateProperty.all(
                    cvp.getMainPage != MainPage.HomePage
                        ? kSecondaryColor
                        : (isNull ? Colors.grey : kTempColor),
                  ),
                  padding: WidgetStateProperty.all(
                      EdgeInsets.symmetric(vertical: size.getH(8)))),
              onPressed: isNull
                  ? null
                  : () {
                      if (cvp.getMainPage == MainPage.OrderPage) {
                        cvp.setMainPage = MainPage.HomePage;
                      } else if (cvp.getMainPage == MainPage.HomePage) {
                        cvp.setMainPage = MainPage.OrderPage;
                      } else {
                        cvp.setMainPage = MainPage.HomePage;
                      }
                      if (size.isProt) Navigator.pop(context);
                    },
              child: Text(
                cvp.getMainPage == MainPage.HomePage
                    ? (cvp.isServiceStore ? LN.allServices : LN.allOrders)
                    : LN.home,
                style: TextStyle(
                  fontSize: size.getS(14),
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.visible,
                ),
              )),
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }
}
