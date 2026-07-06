// import 'package:flutter/material.dart';
// import 'package:pos_account/config/size_config.dart';
// import 'package:pos_account/constant/constant.dart';
// import 'package:pos_account/providers/cus_val_pro.dart';

// class RecentCallBtn extends StatelessWidget {
//   final CusValuePro cvp;
//   final PageController? pageCltr;
//   const RecentCallBtn({super.key, required this.cvp, this.pageCltr})
//       ;

//   @override
//   Widget build(BuildContext context) {
//     final size = Ssize(context);
//     return Card(
//       margin: EdgeInsets.zero,
//       elevation: 4,
//       shadowColor: Colors.grey[200],
//       color: kIconBackColor,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       child: InkWell(
//         onTap: () {
//           if (cvp.getMainPage != MainPage.RecentCallPage)
//             cvp.setMainPage = MainPage.RecentCallPage;
//           if (pageCltr != null && pageCltr!.page != 0) {
//             pageCltr!.animateToPage(0,
//                 duration: Duration(milliseconds: 350), curve: Curves.easeInOut);
//           }
//         },
//         child: Padding(
//           padding: EdgeInsets.all(size.getW(8.0)),
//           child: Icon(
//             Icons.phone_callback_outlined,
//             size: size.getS(28),
//           ),
//         ),
//       ),
//     );
//   }
// }
