import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/profile/profile_pro.dart';
import 'package:pos_account/screens/home_screen/com/profile/com/user_header_sec.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:provider/provider.dart';
import '../../../../widgets/title_pop.dart';
import 'com/user_body_sec.dart';

class ProfileScreen extends StatefulWidget {
  final PageController homePageCltr;
  final CusValuePro cvp;
  const ProfileScreen({
    super.key,
    required this.cvp,
    required this.homePageCltr,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _pageCltr = PageController();

  @override
  void initState() {
    setData();
    super.initState();
  }

  ProfilePro? _profilePro;

  setData() {
    _profilePro = Provider.of<ProfilePro>(context, listen: false);
    if (_profilePro != null) {
      _profilePro?.getData();
    }
  }

  @override
  void dispose() {
    _profilePro?.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final _kTabString = <String>[LN.personalInfo, LN.passAndSec];
    final profilePro = Provider.of<ProfilePro>(context);
    return Processing(
      loading: profilePro.loading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: EdgeInsets.all(size.getW(12)),
              child: TitlePop(
                title: LN.profile,
                size: size,
                onTap: () {
                  GlobalCVP.setMainPage = MainPage.ManagePage;
                },
              ),
            ),
          ),
          SizedBox(
            height: size.getH(12),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TextButton(
                  //     onPressed: () async {
                  //       if (cvp.getMainPage == MainPage.ProfilePage ||
                  //           cvp.getMainPage == MainPage.SubscriptionPlanPage) {
                  //         widget.homePageCltr.animateToPage(0,
                  //             duration: Duration(milliseconds: 350),
                  //             curve: Curves.easeInOut);
                  //         Future.delayed(Duration(milliseconds: 300), () {
                  //           cvp.setMainPage = MainPage.HomePage;
                  //         });
                  //       }
                  //     },
                  //     child: Padding(
                  //       padding: const EdgeInsets.only(left: 20.0),
                  //       child: Row(
                  //         children: [
                  //           Icon(
                  //             Icons.arrow_back,
                  //             size: size.getS(24),
                  //             color: Colors.black,
                  //           ),
                  //           SizedBox(
                  //             width: size.getW(8),
                  //           ),
                  //           Text(
                  //             LN.back,
                  //             style: TextStyle(
                  //               fontSize: size.getS(16),
                  //               color: Colors.black,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     )),
                  UserHeaderSec(
                    pro: profilePro,
                  ),
                  SizedBox(
                    height: size.getH(12),
                  ),
                  UserBodySec(
                    kTabs: _kTabString,
                    pro: profilePro,
                    pageCltr: _pageCltr,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
