// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:pos_account/config/size_config.dart';
// import 'package:pos_account/constant/constant.dart';
// import 'package:pos_account/providers/cus_val_pro.dart';
// import 'package:pos_account/widgets/load_btn.dart';

// import '../../../../ln.dart';

// class PunchInOutSec extends StatefulWidget {
//   final bool showButton;
//   final PageController? homeProfilePageCltr;
//   const PunchInOutSec({
//     Key? key,
//     this.showButton = true,
//     this.homeProfilePageCltr,
//   }) : super(key: key);

//   @override
//   State<PunchInOutSec> createState() => _PunchInOutSecState();
// }

// class _PunchInOutSecState extends State<PunchInOutSec> {
//   // Timer? _timer;

//   // void load() {
//   //   if (mounted) setState(() {});
//   // }

//   // final _timeManager = TimerManager();

//   @override
//   void initState() {
//     super.initState();
//     // _getData();
//   }

//   // Future<void> _getData() async {
//   //   final punchPro = Provider.of<PunchPro>(context, listen: false);
//   //   await punchPro.getPunchData(accessLocation: false);

//   //   DateTime? _currentDate;

//   //   if (punchPro.punchInOutData?.currentDate?.isNotEmpty ?? false) {
//   //     _currentDate = DateFormat(punchPro.dateFormat)
//   //         .parse(punchPro.punchInOutData?.currentDate ?? '');
//   //   }

//   //   DateTime? _dateTime;

//   //   if (punchPro.punchInOutData?.date?.isNotEmpty ?? false) {
//   //     _dateTime =
//   //         DateFormat(punchPro.dateFormat).parse(punchPro.punchInOutData!.date!);
//   //   }

//   //   int _timeDiff = 0;

//   //   if (_dateTime != null && _currentDate != null) {
//   //     _timeDiff = _currentDate.difference(_dateTime).inSeconds;

//   //     _timeManager.startTimer(initTime: _timeDiff);
//   //     _timer = Timer.periodic(const Duration(seconds: 1), (_) {
//   //       load();
//   //     });
//   //   }
//   // }

//   @override
//   void dispose() {
//     // if (_timer != null) _timer!.cancel();
//     // _timeManager.stopTimer();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = Ssize(context);
//     return SizedBox(
//       height: size.getH(54),
//       child: Row(
//         children: [
//           SizedBox(width: widget.showButton ? size.getW(12) : 0),
//           Flexible(
//             child: AnimatedContainer(
//               duration: Duration(milliseconds: 400),
//               width: widget.showButton ? size.getW(136) : 0,
//               padding: EdgeInsets.symmetric(horizontal: 2),
//               child: Opacity(
//                 opacity: widget.showButton ? 1 : 0,
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: LoadButton(
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(5)),
//                         btnColor: kSecondaryColor,
//                         hPad: 2,
//                         btnText: LN.punchInOut,
//                         onsave: () async {
//                           await Future.delayed(Duration(milliseconds: 300));
//                           if (GlobalCVP.getMainPage != MainPage.PunchInOutPage)
//                             GlobalCVP.setMainPage = MainPage.PunchInOutPage;
//                           else
//                             GlobalCVP.setMainPage = MainPage.HomePage;
//                           // PunchLockScreen.show();
//                           // _timeManager.stopTimer();
//                           // showDialog(
//                           //     context: context,
//                           //     builder: (builder) => SimpleDialog(
//                           //           backgroundColor: Colors.white,
//                           //           titlePadding: EdgeInsets.zero,
//                           //           shape: RoundedRectangleBorder(
//                           //               borderRadius:
//                           //                   BorderRadius.circular(15)),
//                           //           children: [
//                           //             PunchDia(),
//                           //           ],
//                           //         ));
//                         },
//                         // child: Text(
//                         //   LN.punchInOut,
//                         //   style: TextStyle(
//                         //     fontSize: size.getS(15),
//                         //     fontWeight: FontWeight.bold,
//                         //   ),
//                         //   maxLines: 1,
//                         //   overflow: TextOverflow.fade,
//                         // ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           // SizedBox(width: size.getW(12)),
//           // SizedBox(
//           //   width: size.getW(112),
//           //   child: Row(
//           //     children: [
//           //       Flexible(child: _timeSec(size, title: _timeManager.hours)),
//           //       _doubleDot(size),
//           //       Flexible(child: _timeSec(size, title: _timeManager.minutes)),
//           //       _doubleDot(size),
//           //       Flexible(child: _timeSec(size, title: _timeManager.seconds)),
//           //     ],
//           //   ),
//           // )
//         ],
//       ),
//     );
//   }

//   // Widget _doubleDot(Ssize size) {
//   //   return Text(
//   //     ":",
//   //     style: TextStyle(
//   //       fontSize: size.getS(24),
//   //       color: Colors.black,
//   //       fontWeight: FontWeight.bold,
//   //     ),
//   //   );
//   // }

//   // Widget _timeSec(Ssize size, {required String title}) {
//   //   return SizedBox(
//   //     width: size.getW(36),
//   //     child: Card(
//   //       color: Colors.grey.shade100,
//   //       elevation: 5,
//   //       child: Padding(
//   //         padding: EdgeInsets.all(size.getS(2)),
//   //         child: Text(
//   //           title,
//   //           style: TextStyle(
//   //             fontSize: size.getS(15),
//   //             color: Colors.black,
//   //             fontWeight: FontWeight.bold,
//   //           ),
//   //           textAlign: TextAlign.center,
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   // }
// }
