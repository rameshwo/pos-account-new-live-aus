import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/constant/strings.dart';
import 'package:pos_account/env.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/notification/new_order_notifi.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/menu/orders_pro.dart';
import 'package:pos_account/providers/notification/order_notify_pro.dart';
import 'package:provider/provider.dart';

class HomeNotifyBtn extends StatelessWidget {
  final CusValuePro cvp;
  final PageController? pageCltr;
  const HomeNotifyBtn({
    super.key,
    required this.cvp,
    this.pageCltr,
  });

  void onTapNotification(BuildContext context,
      {required OrderNotifyPro onPro, NewOrderNotifi? notifi}) {
    // final _selectedNoti = onPro.databaseOrders?.newOrders?[index];
    // if (cvp.getMainPage != MainPage.HomePage) {
    //   cvp.setMainPage = MainPage.HomePage;
    // }
    if (notifi != null) {
      onPro.updateSeenStatus(id: notifi.id ?? '');
      Future.delayed(Duration(milliseconds: 350), () async {
        if (pageCltr != null && pageCltr!.page != 0) {
          await pageCltr!.animateToPage(0,
              duration: Duration(milliseconds: 350), curve: Curves.easeInOut);
        }

        if (notifi.type?.toLowerCase() == Strings.order) {
          cvp.setMainPage = MainPage.OrderPage;
          final orderP = Provider.of<OrderPro>(context, listen: false);
          Future.delayed(Duration(milliseconds: 350), () {
            orderP.viewOrder(context, orderId: notifi.typeId ?? '');
          });
        } else if (notifi.type?.toLowerCase() == Strings.tablereservation) {
          if (cvp.getMainPage != MainPage.HomePage) {
            cvp.setMainPage = MainPage.HomePage;
          }
          // if (cvp.showDashboard) {
          //   cvp.setDashboard = false;
          // }
          if (cvp.PageCltr != null &&
              cvp.tabs.any((element) => element.title == LN.booking)) {
            final _index =
                cvp.tabs.indexWhere((element) => element.title == LN.booking);
            cvp.PageCltr!.jumpToPage(_index);
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final oNPro = Provider.of<OrderNotifyPro>(context);
    final popUpMenuItems = oNPro.databaseOrders != null &&
            oNPro.databaseOrders!.newOrders != null &&
            oNPro.databaseOrders!.newOrders!.isNotEmpty
        ? List.generate(
            oNPro.databaseOrders!.newOrders!.length,
            (index) => PopupMenuItem(
                  value: oNPro.databaseOrders!.newOrders![index],
                  enabled: false,
                  padding: EdgeInsets.symmetric(
                      horizontal: size.getW(4), vertical: size.getH(4)),
                  height: size.getH(40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (index == 0)
                        Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Text(LN.notifications,
                              style: TextStyle(
                                color: kSecondaryColor,
                                fontFamily: kFontFMedium,
                                fontSize: size.getS(18),
                              )),
                        ),
                      index == 0 ||
                              oNPro.databaseOrders!.newOrders![index - 1]
                                      .date !=
                                  oNPro.databaseOrders!.newOrders![index].date
                          ? Padding(
                              padding: EdgeInsets.only(top: 4.0),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Divider(
                                    color: kSecondaryColor,
                                  )),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: size.getW(4)),
                                    child: Text(
                                        oNPro.databaseOrders?.newOrders?[index]
                                                .date
                                                ?.split(' ')
                                                .first ??
                                            '',
                                        style: TextStyle(
                                          color: kSecondaryColor,
                                          fontFamily: kFontFMedium,
                                          fontSize: size.getS(14),
                                        )),
                                  ),
                                  Expanded(
                                      child: Divider(
                                    color: kSecondaryColor,
                                  )),
                                ],
                              ),
                            )
                          : index != 0 &&
                                  !oNPro.countOrderId.contains(oNPro
                                      .databaseOrders!.newOrders![index].id)
                              ? SizedBox(
                                  height: size.getH(8),
                                  child: Divider(
                                    color: Colors.black54,
                                  ),
                                )
                              : SizedBox.shrink(),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          onTapNotification(context,
                              onPro: oNPro,
                              notifi: oNPro.databaseOrders?.newOrders?[index]);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: oNPro.countOrderId.contains(
                                    oNPro.databaseOrders!.newOrders![index].id)
                                ? kSecondaryColor.withAlpha(24)
                                : null,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: size.getW(8), vertical: size.getH(4)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  oNPro.databaseOrders!.newOrders![index]
                                          .message ??
                                      '',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: kFontFMedium,
                                    fontSize: size.getS(16),
                                  )),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Builder(builder: (context) {
                                  final date = oNPro
                                      .databaseOrders?.newOrders?[index].date;
                                  return Text(
                                      date?.substring(date.indexOf(' ')) ?? '',
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontFamily: kFontFRegular,
                                        fontSize: size.getS(13),
                                      ));
                                }),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (index == oNPro.databaseOrders!.newOrders!.length - 1)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Divider(
                              color: kSecondaryColor,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                if (cvp.getMainPage !=
                                    MainPage.NotificationPage)
                                  cvp.setMainPage = MainPage.NotificationPage;
                                if (pageCltr != null && pageCltr!.page != 0) {
                                  pageCltr!.animateToPage(0,
                                      duration: Duration(milliseconds: 350),
                                      curve: Curves.easeInOut);
                                }
                              },
                              child: Text(LN.seeNotifications,
                                  style: TextStyle(
                                    color: kSecondaryColor,
                                    fontFamily: kFontFMedium,
                                    fontSize: size.getS(16),
                                  )),
                            ),
                          ],
                        ),
                    ],
                  ),
                ))
        : <PopupMenuItem<NewOrderNotifi>>[
            PopupMenuItem(
              child: Center(
                child: Text("${LN.no} ${LN.notification}",
                    style: TextStyle(
                      color: kSecondaryColor,
                      fontFamily: kFontFMedium,
                      fontSize: size.getS(18),
                    )),
              ),
            )
          ];
    return StreamBuilder(
        stream: Stream.periodic(Duration(
                seconds: AppEnvironment.environment == Environment.UAT ? 600 : 10))
            .asyncMap((_) => oNPro.getData()),
        builder: (context, snap) {
          return Stack(
            alignment: Alignment.topRight,
            children: [
              Padding(
                padding:
                    EdgeInsets.only(right: size.getW(8), top: size.getH(4)),
                child: PopupMenuButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  itemBuilder: (context) {
                    // if (_oNPro.countOrderId.isNotEmpty) _oNPro.storeInLocalDB();
                    return popUpMenuItems;
                  },
                  tooltip: LN.notification,
                  offset: Offset(0, size.getH(60)),
                  child: Card(
                    margin: EdgeInsets.zero,
                    elevation: 4,
                    shadowColor: Colors.grey[200],
                    color: kIconBackColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: EdgeInsets.all(size.getW(8.0)),
                      child: SvgPicture.asset(
                        "assets/svg/others/notification.svg",
                        height: size.getW(28),
                        width: size.getW(28),
                      ),
                    ),
                  ),
                ),
              ),
              // if (_oNPro.countOrderId.isNotEmpty)
              if (oNPro.databaseOrders?.newOrders != null &&
                  oNPro.databaseOrders!.newOrders!.isNotEmpty &&
                  oNPro.databaseOrders!.newOrders!.first.total != null &&
                  oNPro.databaseOrders!.newOrders!.first.total != 0)
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: size.getW(8), vertical: size.getW(6)),
                  child: Text(
                    // _oNPro.countOrderId.length < 99
                    //     ? _oNPro.countOrderId.length.toString()
                    //     : "99+",

                    "${oNPro.databaseOrders!.newOrders!.first.total!}",

                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: kFontFMedium,
                      // fontWeight: FontWeight.bold,
                      fontSize: size.getS(13),
                    ),
                  ),
                ),
            ],
          );
        });
  }
}
