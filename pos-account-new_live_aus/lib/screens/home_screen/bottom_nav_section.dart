// import 'package:flutter/material.dart';
// import 'package:pos_account/config/size_config.dart';
// import 'package:pos_account/providers/cus_val_pro.dart';
// import 'package:pos_account/providers/menu/place_order_pro.dart';
// import 'package:provider/provider.dart';
// import '../../config/responsive.dart';
// import '../../constant/constant.dart';

// class BottomNavSection extends StatefulWidget {
//   final PlaceOrderPro placeOrderPro;
//   final PageController pageCltr;
//   const BottomNavSection({
//     Key? key,
//     required this.placeOrderPro,
//     required this.pageCltr,
//   }) : super(key: key);

//   @override
//   State<BottomNavSection> createState() => _BottomNavSectionState();
// }

// class _BottomNavSectionState extends State<BottomNavSection> {
//   @override
//   Widget build(BuildContext context) {
//     final cvp = Provider.of<CusValuePro>(context);
//     // final _oNPro = Provider.of<OrderNotifyPro>(context);
//     final size = Ssize(context);

//     return cvp.PageCltr != null
//         ? Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black12,
//                   blurRadius: 4,
//                   offset: Offset(0, 2),
//                 ),
//               ],
//             ),
//             height: (Responsive.isDesktop(context)) ? 80 : 70,
//             child: LayoutBuilder(
//               builder: (context, constraints) {
//                 return Center(
//                   child: SizedBox(
//                     width: double.infinity,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: List.generate(GlobalCVP.tabs.length, (index) {
//                         final title = GlobalCVP.tabs[index].title;
//                         // final isNotificationTab = title == LN.notification;
//                         final isActive = GlobalCVP.currentPage == index;

//                         return Expanded(
//                           child: InkWell(
//                             onTap: () => _handleNavTap(index),
//                             child: Padding(
//                               padding: EdgeInsets.symmetric(vertical: 8.0),
//                               child: Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   GlobalCVP.tabs[index].icon ??
//                                       Icon(Icons.error),
//                                   SizedBox(height: 4),
//                                   Text(
//                                     title ?? '',
//                                     style: TextStyle(
//                                       fontSize: size.getS(14),
//                                       color: isActive
//                                           ? kSecondaryColor
//                                           : Colors.grey,
//                                       fontFamily:
//                                           isActive ? kFontFMedium : null,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       }),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           )
//         : Container(height: 0);
//   }

//   void _handleNavTap(int index) async {
//     final cvp = GlobalCVP;
//     widget.placeOrderPro.showManageTab = false;
//     widget.placeOrderPro.notify;
//     if (cvp.tabs[index].title == "Manage") {
//       cvp.setMainPage = MainPage.ManagePage;
//     } else {
//       cvp.setMainPage = MainPage.HomePage;
//     }
//     cvp.setCurrentPage(index);
//     GlobalCVP.notify;
//   }
// }
