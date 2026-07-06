import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/menu/place_order_pro.dart';
import 'package:provider/provider.dart';
import '../../constant/constant.dart';

class BottomNavSection2 extends StatefulWidget {
  final PlaceOrderPro placeOrderPro;
  final PageController pageCltr;
  const BottomNavSection2({
    super.key,
    required this.placeOrderPro,
    required this.pageCltr,
  });

  @override
  State<BottomNavSection2> createState() => _BottomNavSection2State();
}

class _BottomNavSection2State extends State<BottomNavSection2> {
  double getResponsiveHeight(BuildContext context) {
    final padding = MediaQuery.of(context).padding.bottom;
    return padding;
  }

  @override
  Widget build(BuildContext context) {
    final cvp = Provider.of<CusValuePro>(context);
    final size = Ssize(context);

    if (GlobalCVP.tabs.isEmpty ||
        GlobalCVP.tabs.length <= cvp.currentPage ||
        GlobalCVP.tabs.length < 2) {
      return Container(height: 0);
    }

    return Container(
      // height: size.getH(80) + getResponsiveHeight(context),
      // height: size.getH(Responsive.isDesktop(context) ? 125 : 140),
      // height: size.getH(85),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            spreadRadius: 1,
            offset: Offset(0, -2),
          ),
        ],
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16), topRight: Radius.circular(16)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16), topRight: Radius.circular(16)),
        child: BottomNavigationBar(
          elevation: 0,
          backgroundColor: Colors.white,
          currentIndex: cvp.currentPage,
          onTap: (index) => _handleNavTap(index),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: kSecondaryColor,
          unselectedItemColor: Colors.black87,
          selectedLabelStyle: TextStyle(
            fontSize: size.getS(18),
            fontFamily: kFontFMedium,
            fontWeight: FontWeight.w600,
            height: 1.5,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: size.getS(16),
            fontWeight: FontWeight.w500,
          ),
          items: GlobalCVP.tabs.map((tab) {
            bool isSelected = cvp.currentPage ==
                GlobalCVP.tabs
                    .indexWhere((element) => element.title == tab.title);

            return BottomNavigationBarItem(
              icon: Container(
                margin: EdgeInsets.zero,
                padding: EdgeInsets.symmetric(
                    horizontal: size.getS(12), vertical: size.getS(4)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: isSelected
                      ? kSecondaryColor.withOpacity(0.1)
                      : Colors.transparent,
                ),
                child: Stack(
                  children: [
                    Icon(
                      tab.icon?.icon,
                      size: size.getS(24),
                      color: isSelected ? kSecondaryColor : Colors.black87,
                    ),
                    if (isSelected)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: size.getS(8),
                          height: size.getS(8),
                          decoration: BoxDecoration(
                            color: kSecondaryColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              label: tab.title,
            );
          }).toList(),
        ),
      ),
    );
  }

  void _handleNavTap(int index) async {
    final cvp = GlobalCVP;
    widget.placeOrderPro.showManageTab = false;
    widget.placeOrderPro.notify;

    if (cvp.tabs.length > index && cvp.tabs[index].title == "Manage") {
      cvp.setMainPage = MainPage.ManagePage;
    } else {
      cvp.setMainPage = MainPage.HomePage;
    }
    cvp.setCurrentPage(index);
    GlobalCVP.notify;
  }
}
