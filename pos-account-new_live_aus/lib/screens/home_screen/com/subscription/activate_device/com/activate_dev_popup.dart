// import 'package:flutter/material.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:lottie/lottie.dart';
// import 'package:pos_account/config/size_config.dart';
// import 'package:pos_account/constant/constant.dart';
// import 'package:pos_account/ln.dart';
// import 'package:pos_account/providers/auth/activate_device_pro.dart';
// import 'package:pos_account/providers/z_multi_pro.dart';
// import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
// import 'package:provider/provider.dart';

// class ActivateDevicePopup extends StatefulWidget {
//   final Ssize size;
//   final bool isPopup;

//   const ActivateDevicePopup({
//     super.key,
//     required this.size,
//     this.isPopup = false,
//   });

//   @override
//   State<ActivateDevicePopup> createState() => _ActivateDevicePopupState();
// }

// class _ActivateDevicePopupState extends State<ActivateDevicePopup> {
//   final formKey = GlobalKey<FormState>();

//   @override
//   void initState() {
//     getData();
//     super.initState();
//   }

//   ActDevPro? _actDevPro;

//   getData() {
//     _actDevPro = Provider.of<ActDevPro>(context, listen: false);
//     _actDevPro?.getLoginRes();
//   }

//   @override
//   void dispose() {
//     _actDevPro?.clear();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final actDevPro = Provider.of<ActDevPro>(context);
//     return SingleChildScrollView(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           if (widget.isPopup)
//             Align(
//               alignment: Alignment.topRight,
//               child: IconButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   icon: Icon(
//                     Icons.close,
//                     size: widget.size.getS(24),
//                   )),
//             ),
//           actDevPro.isActivated
//               ? Padding(
//                   padding: EdgeInsets.symmetric(vertical: widget.size.getH(24)),
//                   child: Column(
//                     children: [
//                       SizedBox(
//                         width: widget.size.getW(200),
//                         child: Lottie.asset(
//                           "assets/json/96957-lock.json",
//                           repeat: false,
//                         ),
//                       ),
//                       SizedBox(
//                         width: widget.size.getW(460),
//                         child: Text(
//                           widget.isPopup
//                               ? LN.deviceActivated
//                               : LN.deviceIsActivated,
//                           style: TextStyle(
//                             fontSize: widget.size.getS(18),
//                             fontFamily: kFontFRegular,
//                             color: Colors.black,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               : Card(
//                   color: widget.isPopup ? Colors.transparent : null,
//                   shadowColor: widget.isPopup ? Colors.transparent : null,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20)),
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(
//                         vertical: widget.size.getH(widget.isPopup ? 60 : 80),
//                         horizontal: widget.size.getW(60)),
//                     child: Form(
//                         key: formKey,
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             SizedBox(
//                               width: widget.size.getW(460),
//                               child: Text(
//                                 LN.deviceNotActive,
//                                 style: TextStyle(
//                                   fontSize: widget.size.getS(18),
//                                   fontFamily: kFontFRegular,
//                                   color: Colors.black,
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
//                             ),
//                             SizedBox(
//                               height: widget.size.getH(32),
//                             ),
//                             Text(LN.activePos,
//                                 style: TextStyle(
//                                   fontSize: widget.size.getS(36),
//                                   fontFamily: kFontFRegular,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black,
//                                 )),
//                             SizedBox(
//                               height: widget.size.getH(32),
//                             ),
//                             SizedBox(
//                               width: widget.size.getW(460),
//                               child: TitleTextForm(
//                                 pWidth: 0.5,
//                                 title: LN.enterActiveKey,
//                                 textCltr: actDevPro.keyCltr,
//                                 hintText: LN.activeKey,
//                                 borderColor: Colors.black26,
//                               ),
//                             ),
//                             SizedBox(
//                               height: widget.size.getH(32),
//                             ),
//                             SizedBox(
//                               width: widget.size.getW(460),
//                               child: TitleTextForm(
//                                 pWidth: 0.5,
//                                 title: LN.deviceNameLoc,
//                                 textCltr: actDevPro.deviceNoLCltr,
//                                 hintText: LN.deviceNameLoc,
//                                 borderColor: Colors.black26,
//                               ),
//                             ),
//                             SizedBox(
//                               height: widget.size.getH(32),
//                             ),
//                             SizedBox(
//                               width: widget.size.getW(460),
//                               child: TextButton(
//                                 onPressed: actDevPro.loading
//                                     ? null
//                                     : () async {
//                                         if (formKey.currentState!.validate()) {
//                                           final status =
//                                               await actDevPro.activate();
//                                           if (status ?? false) {
//                                             Future.delayed(Duration(seconds: 2),
//                                                 () {
//                                               MultiPro.reset;
//                                               Future.delayed(
//                                                   Duration(milliseconds: 200),
//                                                   () => Navigator
//                                                       .pushNamedAndRemoveUntil(
//                                                           context,
//                                                           '/screen-cltr',
//                                                           (route) => false));
//                                             });
//                                           }
//                                         }
//                                       },
//                                 style: ButtonStyle(
//                                     shape: WidgetStateProperty.all(
//                                         RoundedRectangleBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(10),
//                                             side: BorderSide(
//                                               color: Colors.black54,
//                                             ))),
//                                     padding: WidgetStateProperty.all(
//                                         EdgeInsets.symmetric(
//                                       vertical: widget.size.getH(12),
//                                     ))),
//                                 child: actDevPro.loading
//                                     ? Row(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           Text(
//                                             LN.activatingKey,
//                                             style: TextStyle(
//                                               fontSize: widget.size.getS(16),
//                                               color: Colors.black,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             width: widget.size.getW(12),
//                                           ),
//                                           LoadingAnimationWidget.waveDots(
//                                             color: Colors.black,
//                                             size: widget.size.getS(24),
//                                           ),
//                                         ],
//                                       )
//                                     : Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           Text(
//                                             LN.activateNow,
//                                             style: TextStyle(
//                                               fontSize: widget.size.getS(20),
//                                               color: Colors.black,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                               ),
//                             )
//                           ],
//                         )),
//                   ),
//                 ),
//           SizedBox(
//             height: widget.size.getH(60),
//           )
//         ],
//       ),
//     );
//   }
// }
