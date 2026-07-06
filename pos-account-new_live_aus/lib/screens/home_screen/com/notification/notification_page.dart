import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/notification/order_notify_pro.dart';
import 'package:pos_account/widgets/dialog/msg_dialog.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'com/notification_tile.dart';
import 'home_notify_btn.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({
    super.key,
  });

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  OrderNotifyPro? _notiPro;

  void getData() {
    _notiPro = Provider.of<OrderNotifyPro>(context, listen: false);
    _notiPro?.initNotificationScreen();
    _notiPro?.getAllNotification();
  }

  @override
  void dispose() {
    _notiPro?.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final notiPro = Provider.of<OrderNotifyPro>(context);
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: size.getH(8.0), horizontal: size.getW(12)),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
            horizontal: size.getW(12), vertical: size.getH(12)),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LN.recentNotifications,
                  style: TextStyle(
                    fontSize: size.getS(18),
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                LoadButton(
                  btnText: LN.markRead,
                  hPad: 8,
                  width: 200,
                  loading: notiPro.loadMarkAll,
                  onsave: () {
                    notiPro.markAllAsSeen().then((value) {
                      if (value ?? false) {
                        MsgDia.show(
                          context,
                          headerAnimation: false,
                          diaType: DiaType.success,
                          // title: LN.success,
                          title: "Success",
                          autoHideSecond: 2,
                        );
                      }
                    });
                  },
                ),
                // StatusSwitch(
                //   status: true,
                //   title: 'See All Notifications',
                // ),
              ],
            ),
            Divider(),
            if (notiPro.refreshCltr != null)
              Expanded(
                child: notiPro.pageLoad
                    ? Loading()
                    : SmartRefresher(
                        controller: notiPro.refreshCltr!,
                        enablePullUp: true,
                        onLoading: () {
                          notiPro.getAllNotification(
                              page: notiPro.pageIndex + 1);
                        },
                        onRefresh: () {
                          notiPro.getAllNotification(page: 1);
                        },
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            children: List.generate(
                              notiPro.notificationList.length,
                              (index) {
                                final message = notiPro
                                    .notificationList[index].message
                                    ?.split("- ");
                                final first =
                                    message != null && message.isNotEmpty
                                        ? message.first
                                        : "";
                                final status =
                                    message != null && message.length > 1
                                        ? message.last
                                        : "";
                                return NotificationTile(
                                  title:
                                      'New ${notiPro.notificationList[index].type ?? ''}',
                                  description: first,
                                  dateTime:
                                      notiPro.notificationList[index].date ??
                                          '',
                                  readStatus:
                                      notiPro.notificationList[index].isSeen ??
                                          false,
                                  status: status,
                                  onTap: () {
                                    HomeNotifyBtn(
                                      cvp: GlobalCVP,
                                    ).onTapNotification(
                                      CUS_CTX ?? context,
                                      onPro: notiPro,
                                      notifi: notiPro.notificationList[index],
                                    );
                                  },
                                  onChanged: notiPro
                                          .notificationList[index].loading
                                      ? null
                                      : (p0) {
                                          notiPro.notificationList[index]
                                              .loading = true;
                                          notiPro.notificationList[index]
                                              .isSeen = !(notiPro
                                                  .notificationList[index]
                                                  .isSeen ??
                                              false);
                                          notiPro.notify;
                                          notiPro
                                              .updateSeenStatus(
                                                  id: notiPro
                                                      .notificationList[index]
                                                      .id)
                                              .then((value) {
                                            notiPro.notificationList[index]
                                                .loading = false;
                                            if (value == null) {
                                              notiPro.notificationList[index]
                                                  .isSeen = !(notiPro
                                                      .notificationList[index]
                                                      .isSeen ??
                                                  false);
                                            }
                                            notiPro.notify;
                                          });
                                        },
                                );
                              },
                            ),
                          ),
                        ),
                      ),
              )
          ],
        ),
      ),
    );
  }
}
