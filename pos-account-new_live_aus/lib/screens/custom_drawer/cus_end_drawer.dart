import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/common/review_pro.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/menu/payment_pro.dart';
import 'package:pos_account/providers/menu/place_order_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/sidebar/eod_report_view.dart';
import 'package:pos_account/screens/home_screen/com/items/sidebar/pay_receipt/pay_receipt_only.dart';
import 'package:provider/provider.dart';
import '../../model/home/menu/payment/make_pay_res.dart';
import '../../model/home/menu/signal_r/place_order_info.dart';
import '../../widgets/review_dialog.dart';
import '../home_screen/com/items/sidebar/order_section/order_section.dart';
import '../home_screen/com/items/sidebar/pay_receipt/pay_receipt.dart';
import '../home_screen/com/items/sidebar/sidebar_section/sidebar_section.dart';

class CusEndDrawer {
  final int currentIndex;
  final GlobalKey<ScaffoldState> scafKey;
  final CusValuePro cvp;
  final BuildContext context;
  final PlaceOrderPro placeOrderPro;
  const CusEndDrawer(
    this.context, {
    Key? key,
    this.currentIndex = 0,
    required this.scafKey,
    required this.cvp,
    required this.placeOrderPro,
  });

  Widget? get endDrawer {
    final size = Ssize(context);
    if (_build() == null)
      return null;
    else
      return GestureDetector(
        onHorizontalDragUpdate: (_) => {},
        child: Container(
          color: Colors.transparent,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (cvp.endDrawerValue != 1)
                Padding(
                  padding: EdgeInsets.only(
                      top: size.getH(24),
                      left: size.getW(25),
                      right: size.getW(4)),
                  child: Material(
                    color: Colors.red.shade500,
                    borderRadius: BorderRadius.circular(100),
                    child: InkWell(
                      onTap: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                        if (cvp.getOrPath == PathOfOrder.MENUPATH) {
                          cvp.jumpToTab();
                        }
                        if (GlobalCVP.showReview == true &&
                            GlobalCVP.isHospitality) {
                          final revPro =
                              Provider.of<ReviewPro>(context, listen: false);
                          revPro.addReviewSec =
                              ReviewQuestionUserViewModel.fromJson(GlobalCVP
                                      .reviewQuestionUserViewModel
                                      ?.toJson() ??
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
                          placeOrderPro.notify;
                        });
                      },
                      highlightColor: kPrimaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        padding: EdgeInsets.all(size.getS(6)),
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(100)),
                        child: Icon(
                          Icons.close,
                          size: size.getS(36),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(child: _build()!),
                    SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }

  Widget? _build() {
    final size = Ssize(context);

    if (cvp.getOrPath == PathOfOrder.ORDERPATH ||
        cvp.getOrPath == PathOfOrder.FLOORPATH ||
        ((cvp.tabs.any(((element) => element.title == LN.pos)) &&
            cvp.tabs.indexWhere((element) => element.title == LN.pos) ==
                cvp.currentPage)) ||
        ((cvp.tabs.any(((element) => element.title == "Keypad")) &&
            cvp.tabs.indexWhere((element) => element.title == "Keypad") ==
                cvp.currentPage))) {
      if (cvp.endDrawerValue == 0 && size.isProt)
        return SizedBox(
            width: size.getW(480),
            child: SafeArea(
                child: SideBarSection(
              scafKey: scafKey,
              placeOrder: () async {
                if (scafKey.currentState != null) {
                  if (Navigator.canPop(context) &&
                      scafKey.currentState!.isEndDrawerOpen)
                    Navigator.pop(context);
                  await Future.delayed(Duration(milliseconds: 300), () {
                    cvp.setOrPath = PathOfOrder.MENUPATH;
                    cvp.setEndDValue = 1;
                    scafKey.currentState!.openEndDrawer();
                  });
                }
              },
              placeOrderPro: placeOrderPro,
            )));
      else if (cvp.endDrawerValue == 1)
        return SizedBox(
            width: size.width, // size.getW(1100),
            child: SafeArea(
                child: OrderSection(
              pathOfOrder: cvp.getOrPath,
              payNow: (PaySummary? paySummary) {
                if (paySummary == null) return;
                PayReceiptOnly.paySummary = paySummary;

                if (scafKey.currentState != null) {
                  if (Navigator.canPop(context) &&
                      scafKey.currentState!.isEndDrawerOpen)
                    Navigator.pop(context);

                  Future.delayed(Duration(milliseconds: 300), () {
                    cvp.setEndDValue = 3;
                    scafKey.currentState!.openEndDrawer();

                    _sendToKitchen(paySummary: paySummary);
                  });
                }
              },
              placeOrderPro: placeOrderPro,
            )));
      else if (cvp.endDrawerValue == 2) {
        return SizedBox(
            width: size.getW(480), child: SafeArea(child: PayReceipt()));
      } else if (cvp.endDrawerValue == 3) {
        return SizedBox(
            width: size.getW(840), child: SafeArea(child: PayReceiptOnly()));
      } else if (scafKey.currentState != null &&
          scafKey.currentState!.isEndDrawerOpen) {
        return Builder(builder: (ctx) {
          Future.delayed(Duration(milliseconds: 200), () {
            if (Navigator.canPop(ctx)) Navigator.pop(ctx);
          });
          return Container();
        });
      } else
        return null;
    } else if (cvp.tabs.length > cvp.currentPage &&
        cvp.tabs[cvp.currentPage].title == "Manage" &&
        currentIndex == cvp.currentPage) {
      if (cvp.endDrawerValue == 11)
        return SizedBox(
            width: size.getW(480),
            child: SafeArea(
                child: EodReportView(
              curSym: placeOrderPro.curSym ?? '',
            )));
      // else if (cvp.endDrawerValue == 1)
      //   return SizedBox(
      //       width: size.getW(480), child: SafeArea(child: FinalizeReceipt()));
      // else
      return null;
    } else
      return null;
  }

  Future<void> _sendToKitchen({PaySummary? paySummary}) async {
    // await StkUtils.sendToKitchen(
    //   orderId: paySummary?.orderId,
    //   stkPrinter: true,
    //   stkDisplay: false,
    // );
    if (paySummary?.orderId == null) return;

    await placeOrderPro.orderSendToKitchen(
        plOrInfo: PlaceOrderInfo(
      orderId: paySummary?.orderId,
      posDeviceId: GlobalCVP.userStoresRes?.id,
      printAllItems: true,
      isSendToKitchenPrinter: GlobalCVP.storeInfo?.isSendToKitchenPrinter,
      isSendToKitchenDisplay: GlobalCVP.storeInfo?.isSendToKitchenDisplay,
    ));
  }
}
