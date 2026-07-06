import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/model/home/menu/payment/make_pay_res.dart';
import 'package:pos_account/providers/common/review_pro.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/menu/payment_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/sidebar/order_section/com/customer_info/com/search_cus_sec.dart';
import 'package:pos_account/screens/home_screen/com/items/sidebar/order_section/com/customer_info/com/new_cus_sec.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/review_dialog.dart';
import 'package:provider/provider.dart';

class CustomerInfoSec extends StatelessWidget {
  const CustomerInfoSec({super.key});

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final payPro = Provider.of<PaymentPro>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // IconButton(
            //   visualDensity: VisualDensity.compact,
            //   padding: EdgeInsets.zero,
            //   onPressed: () {
            //     Navigator.pop(context);
            //     if (GlobalCVP.getOrPath == PathOfOrder.MENUPATH) {
            //       GlobalCVP.jumpToTab();
            //     }
            //     if (GlobalCVP.showReview == true && GlobalCVP.isHospitality) {
            //       final revPro = Provider.of<ReviewPro>(context, listen: false);
            //       revPro.addReviewSec = ReviewQuestionUserViewModel.fromJson(
            //           GlobalCVP.reviewQuestionUserViewModel?.toJson() ?? {});
            //       GlobalCVP.showReview = false;
            //       GlobalCVP.reviewQuestionUserViewModel = null;
            //       showDialog(
            //           barrierDismissible: false,
            //           context: context,
            //           builder: (context) {
            //             return ShowReviewDialog();
            //           });
            //     }
            //     Future.delayed(Duration(milliseconds: 500), () {
            //       GlobalCVP.notify;
            //     });
            //   },
            //   icon: Icon(
            //     Icons.arrow_back_outlined,
            //     size: size.getS(28),
            //   ),
            // ),
            SizedBox(width: size.getW(12)),
            Text(
              "Customer Information",
              style: TextStyle(
                fontSize: size.getS(20),
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Divider(
          color: Colors.black38,
          thickness: 1,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.getW(12)),
          child: Row(
            children: [
              _cusTab(
                size,
                title: "Search Customers",
                onTap: () {
                  payPro.customerTab = 0;
                  payPro.notify;
                },
                isSelected: payPro.customerTab == 0,
                iconData: Icons.person_search_outlined,
              ),
              SizedBox(width: size.getW(12)),
              _cusTab(
                size,
                title: "New Customers",
                onTap: () {
                  payPro.customerTab = 1;
                  payPro.notify;
                },
                isSelected: payPro.customerTab == 1,
                iconData: Icons.person_add_alt_1_outlined,
              ),
            ],
          ),
        ),
        SizedBox(height: size.getH(12)),
        Flexible(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.getW(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (payPro.customerTab == 1)
                  NewCusSec(payPro: payPro, size: size)
                else
                  SearchCusSec(payPro: payPro, size: size)
              ],
            ),
          ),
        ),
        Divider(color: Colors.black54),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: size.getW(6), vertical: size.getH(6)),
                child: LoadButton(
                  width: double.infinity,
                  btnColor: kSecondaryColor,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  icon: Icon(
                    Icons.arrow_back,
                    size: size.getS(25),
                    color: Colors.white,
                  ),
                  vPad: 10,
                  btnText: "   Back",
                  fontSize: 18,
                  textColor: Colors.white,
                  onsave: () {
                    Navigator.pop(context);
                    // if (GlobalCVP.getOrPath == PathOfOrder.MENUPATH) {
                    //   GlobalCVP.jumpToTab();
                    // }
                    if (GlobalCVP.showReview == true &&
                        GlobalCVP.isHospitality) {
                      final revPro =
                          Provider.of<ReviewPro>(context, listen: false);
                      revPro.addReviewSec =
                          ReviewQuestionUserViewModel.fromJson(
                              GlobalCVP.reviewQuestionUserViewModel?.toJson() ??
                                  {});
                      GlobalCVP.showReview = false;
                      GlobalCVP.reviewQuestionUserViewModel = null;
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return ShowReviewDialog();
                          });
                    }
                    Future.delayed(Duration(milliseconds: 500), () {
                      GlobalCVP.notify;
                    });
                  },
                ),
              ),
            ),
            // Expanded(
            //   child: Padding(
            //     padding: EdgeInsets.symmetric(
            //         horizontal: size.getW(6), vertical: size.getH(6)),
            //     child: LoadButton(
            //       width: double.infinity,
            //       btnColor: kSecondaryColor,
            //       shape: RoundedRectangleBorder(
            //         side: BorderSide(color: kSecondaryColor),
            //         borderRadius: BorderRadius.circular(5),
            //       ),
            //       // icon: Icon(
            //       //   Icons.arrow_back,
            //       //   size: size.getS(25),
            //       //   color: Colors.white,
            //       // ),
            //       vPad: 10,
            //       btnText: "New Order",
            //       fontSize: 18,
            //       textColor: Colors.white,
            //       onsave: () {
            //         Navigator.pop(context);
            //         GlobalCVP.setCurrentPage(0);
            //         GlobalCVP.setMainPage = MainPage.HomePage;
            //         GlobalCVP.jumpToTab();
            //         Future.delayed(Duration(milliseconds: 500), () {
            //           GlobalCVP.notify;
            //         });
            //       },
            //     ),
            //   ),
            // ),
          ],
        )
      ],
    );
  }

  Widget _cusTab(
    Ssize size, {
    required String title,
    Function()? onTap,
    bool isSelected = false,
    required IconData iconData,
  }) {
    return Expanded(
      child: LoadButton(
        btnText: title,
        hPad: 4,
        icon: Padding(
          padding: EdgeInsets.only(right: size.getW(8)),
          child: Icon(
            iconData,
            color: isSelected ? Colors.white : kSecondaryColor,
            size: size.getS(24),
          ),
        ),
        textColor: isSelected ? Colors.white : kSecondaryColor,
        btnColor: isSelected ? kSecondaryColor : Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: kSecondaryColor)),
        onsave: onTap,
      ),
    );
  }
}
