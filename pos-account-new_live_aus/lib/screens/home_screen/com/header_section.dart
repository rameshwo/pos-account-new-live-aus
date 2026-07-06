import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/auth/auth_pro.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/menu/place_order_pro.dart';
import 'package:pos_account/screens/custom_drawer/com/logo_sec.dart';
import 'package:pos_account/widgets/dialog/confirm_dialog.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:provider/provider.dart';

class HeaderSection extends StatelessWidget {
  final Function()? openDrawer;
  final Function()? openEndDrawer;
  final PlaceOrderPro? placeOrderPro;
  final CusValuePro cvp;
  final List<Widget>? kTabs;
  final PageController? homeProfilePageCltr;
  const HeaderSection({
    super.key,
    this.openDrawer,
    this.openEndDrawer,
    this.placeOrderPro,
    required this.cvp,
    this.kTabs,
    this.homeProfilePageCltr,
  });

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final _authProvider = Provider.of<AuthProvider>(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (!size.isProt)
          Expanded(
            flex: kFlexLeft,
            child: LogoSection(
              size: size,
            ),
          ),
        Expanded(
          flex: (cvp.tabs.isNotEmpty &&
                  (cvp.tabs[cvp.currentPage].title == LN.pos ||
                      cvp.tabs[cvp.currentPage].title == "Keypad")
                  // cvp.getHPTIndex == 1
                  &&
                  cvp.getMainPage == MainPage.HomePage &&
                  cvp.viewWidget.viewPosModule
              // &&
              // !cvp.showDashboard
              )
              ? kFlexMiddleLand
              : kFlexMiddleProt,
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, size.getH(8), size.getW(12), 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (size.isProt && openDrawer != null)
                        ? Padding(
                            padding: EdgeInsets.only(
                                right: size.getW(12.0), top: size.getH(3)),
                            child: InkWell(
                              onTap: openDrawer,
                              child: Icon(
                                Icons.menu,
                                color: kPrimaryColor,
                                size: size.getS(40),
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                    Flexible(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if ((cvp.getMainPage !=
                                  MainPage.SubscriptionPage))
                                LoadButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  btnColor: kSecondaryColor,
                                  hPad: 2,
                                  btnText: LN.punchInOut,
                                  onsave: () async {
                                    await Future.delayed(
                                        Duration(milliseconds: 300));
                                    if (GlobalCVP.getMainPage !=
                                        MainPage.PunchInOutPage)
                                      GlobalCVP.setMainPage =
                                          MainPage.PunchInOutPage;
                                    else
                                      GlobalCVP.setMainPage = MainPage.HomePage;
                                  },
                                ),
                              if (placeOrderPro != null &&
                                  ((cvp.getMainPage ==
                                          MainPage.SubscriptionPage &&
                                      cvp.pathOfSubsBills ==
                                          PathOfSubsBills.OnInit)))
                                Padding(
                                  padding: EdgeInsets.only(
                                      right: size.getW(16), top: size.getH(12)),
                                  child: InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (builder) => ConfirmDialog(
                                                title: LN.logout,
                                                subTitle: LN.sureToLogout,
                                                actionText: LN.logout,
                                                onDelete: () async {
                                                  _authProvider.logOut();
                                                  return null;
                                                },
                                              ));
                                    },
                                    borderRadius: BorderRadius.circular(10),
                                    child: Column(
                                      children: [
                                        SvgPicture.asset(
                                          "assets/svg/others/Logout.svg",
                                          height: size.getW(28),
                                          width: size.getW(28),
                                        ),
                                        Text(
                                          LN.logOut,
                                          style: TextStyle(
                                            color: kSecondaryColor,
                                            fontSize: size.getS(14),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
