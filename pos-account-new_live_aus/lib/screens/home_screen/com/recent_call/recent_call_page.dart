import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/menu/payment/cus_loyal_res.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/notification/recent_call_pro.dart';
import 'package:pos_account/repository/handler.dart';
import 'package:pos_account/services/phone_service/widgets/com/customer_detail_sec.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../widgets/title_pop.dart';

class RecentCallPage extends StatefulWidget {
  const RecentCallPage({super.key});

  @override
  State<RecentCallPage> createState() => _RecentCallPageState();
}

class _RecentCallPageState extends State<RecentCallPage> {
  @override
  void initState() {
    _getData();
    super.initState();
  }

  RecentCallPro? _recentPro;

  void _getData() {
    _recentPro = Provider.of<RecentCallPro>(context, listen: false);
    _recentPro?.init();
    _recentPro?.getData();
  }

  @override
  void dispose() {
    _recentPro?.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final pro = Provider.of<RecentCallPro>(context);
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: size.getH(8.0), horizontal: size.getW(12)),
      child: Processing(
        loading: pro.dataLoad,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
              horizontal: size.getW(12), vertical: size.getH(12)),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              TitlePop(
                title: "Recent Phone Calls",
                size: size,
                onTap: () {
                  GlobalCVP.setMainPage = MainPage.HomePage;
                },
              ),
              Divider(),
              if (pro.refreshCltr != null)
                Expanded(
                    child: pro.loading
                        ? Loading()
                        : SmartRefresher(
                            controller: pro.refreshCltr!,
                            enablePullUp: true,
                            onLoading: () {
                              pro.getData(page: pro.pageIndex + 1);
                            },
                            onRefresh: () {
                              pro.getData(page: 1);
                            },
                            child: SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              child: Column(
                                children: [
                                  if (pro.recentCallList.isNotEmpty)
                                    ...List.generate(pro.recentCallList.length,
                                        (i) {
                                      return Card(
                                          elevation: 4,
                                          color: Colors.white,
                                          shadowColor: Colors.grey[200],
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: ListTile(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            onTap: () async {
                                              if (pro.recentCallList[i]
                                                      .number ==
                                                  null) return;

                                              pro.dataLoad = true;
                                              pro.notify;

                                              var cusData =
                                                  await Handler.searchCustomer(
                                                      phoneNumber: pro
                                                          .recentCallList[i]
                                                          .number);
                                              cusData ??= CusForLoyalityRes(
                                                  phoneNumber: pro
                                                      .recentCallList[i]
                                                      .number);

                                              CustomerDetailSection.showDia(
                                                  cusData: cusData);
                                              pro.dataLoad = false;
                                              pro.notify;
                                            },
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: size.getH(4),
                                                    horizontal: size.getW(20)),
                                            leading: CircleAvatar(
                                              radius: size.getS(24),
                                              backgroundColor: (pro
                                                          .recentCallList[i]
                                                          .isAccepted ??
                                                      false)
                                                  ? Colors.green
                                                  : Colors.red.shade700,
                                              child: Icon(
                                                (pro.recentCallList[i]
                                                            .isAccepted ??
                                                        false)
                                                    ? Icons.call_outlined
                                                    : Icons
                                                        .phone_missed_outlined,
                                                color: Colors.white,
                                                size: size.getS(25),
                                              ),
                                            ),
                                            title: Text(
                                              pro.recentCallList[i].number ??
                                                  LN.na,
                                              style: TextStyle(
                                                fontSize: size.getS(18),
                                                fontFamily: kFontFMedium,
                                                fontWeight: FontWeight.w300,
                                                color: Colors.black,
                                              ),
                                            ),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  pro.recentCallList[i]
                                                          .dateTime ??
                                                      '',
                                                  style: TextStyle(
                                                    fontSize: size.getS(16),
                                                    fontFamily: kFontFRegular,
                                                  ),
                                                ),
                                                // Text(
                                                //   "dateTime",
                                                //   style: TextStyle(
                                                //     fontSize: size.getS(16),
                                                //     fontFamily: kFontFRegular,
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          ));
                                    })
                                  else
                                    NoItemsSec(
                                        size: size,
                                        title: "No Recent Phone Calls")
                                ],
                              ),
                            ),
                          ))
            ],
          ),
        ),
      ),
    );
  }
}
