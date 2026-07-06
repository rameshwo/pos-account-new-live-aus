import 'package:flutter/material.dart';
import 'package:pos_account/config/responsive.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/providers/profile/profile_pro.dart';
import '../../cus_button_tabs.dart';
import 'password_sec.dart';
import 'profile_info.dart';

class UserBodySec extends StatelessWidget {
  final List<String> kTabs;
  final ProfilePro pro;
  final PageController pageCltr;
  const UserBodySec(
      {super.key,
      required this.kTabs,
      required this.pro,
      required this.pageCltr});

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return Card(
      margin: EdgeInsets.symmetric(
          horizontal: size.getW(0), vertical: size.getH(12)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: size.getW(48), vertical: size.getH(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: size.getH(24),
              ),
              CusButtonTabs(
                kTabs: kTabs,
                size: size,
                selectedIndex: pro.selectedTab,
                selectedTextColor: Colors.white,
                onTap: (p0) {
                  pro.selectedTab = p0;
                  pro.notify;
                  pageCltr.animateToPage(p0,
                      duration: Duration(milliseconds: 400),
                      curve: Curves.easeInOut);
                },
              ),
              SizedBox(
                height: size.getH(16),
              ),
              SizedBox(
                height: size.getH(Responsive.isDesktop(context) ? 620 : 760),
                child: PageView(
                  controller: pageCltr,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    ProfileInfoSec(
                      size: size,
                      pro: pro,
                    ),
                    PasswordSec(
                      is2faEnabled: pro.userInfo?.isTwoFaEnabled,
                      refreshInfo: () => pro.getData(loadAddSec: false),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
