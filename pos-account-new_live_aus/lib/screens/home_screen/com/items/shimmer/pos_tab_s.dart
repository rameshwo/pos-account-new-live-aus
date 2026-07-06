// import 'package:fade_shimmer/fade_shimmer.dart';
// import 'package:flutter/material.dart';

// import '../../../../../config/responsive.dart';
// import '../../../../../config/size_config.dart';

// class PosShimmer extends StatelessWidget {
//   const PosShimmer({super.key}) ;

//   @override
//   Widget build(BuildContext context) {
//     final size = Ssize(context);
//     return Column(
//       children: [
//         // SearchSection(),
//         SizedBox(
//           height: size.getH(12),
//         ),
//         Flexible(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               FadeShimmer(
//                 height: 8,
//                 width: 150,
//                 radius: 4,
//                 highlightColor: Color(0xffF9F9FB),
//                 baseColor: Color(0xffE6E8EB),
//               ),
//               GridView.count(
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 crossAxisCount: Responsive.isDesktop(context)
//                     ? 4
//                     : Responsive.isTablet(context)
//                         ? 5
//                         : 3,
//                 mainAxisSpacing: 10,
//                 padding:
//                     EdgeInsets.only(top: size.getH(12), bottom: size.getH(24)),
//                 children: List.generate(
//                     12,
//                     (i2) => Card(
//                           elevation: 1,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Padding(
//                             padding: EdgeInsets.symmetric(
//                                 vertical: size.getH(4.0),
//                                 horizontal: size.getW(12)),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 FadeShimmer(
//                                   height: size.getW(60),
//                                   width: size.getW(60),
//                                   radius: size.getW(40),
//                                   highlightColor: Color(0xffF9F9FB),
//                                   baseColor: Color(0xffE6E8EB),
//                                 ),
//                                 SizedBox(height: 12),
//                                 FadeShimmer(
//                                   height: size.getW(12),
//                                   width: size.getW(140),
//                                   radius: 4,
//                                   highlightColor: Color(0xffF9F9FB),
//                                   baseColor: Color(0xffE6E8EB),
//                                 ),
//                                 SizedBox(height: 12),
//                                 FadeShimmer(
//                                   height: size.getW(12),
//                                   width: size.getW(60),
//                                   radius: 4,
//                                   highlightColor: Color(0xffF9F9FB),
//                                   baseColor: Color(0xffE6E8EB),
//                                 ),
//                                 SizedBox(height: 12),
//                                 FadeShimmer(
//                                   height: size.getW(24),
//                                   width: size.getW(60),
//                                   radius: 4,
//                                   highlightColor: Color(0xffF9F9FB),
//                                   baseColor: Color(0xffE6E8EB),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         )),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
