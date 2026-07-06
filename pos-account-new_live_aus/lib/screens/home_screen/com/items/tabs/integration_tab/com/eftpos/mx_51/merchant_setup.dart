// import 'package:flutter/material.dart';
// import 'package:pos_account/config/size_config.dart';
// import 'package:pos_account/constant/constant.dart';
// import 'package:pos_account/providers/cus_val_pro.dart';
// import 'package:pos_account/providers/integration/terminal_pro.dart';
// import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
// import 'package:pos_account/widgets/load_btn.dart';
// import 'package:pos_account/widgets/loading.dart';
// import 'package:provider/provider.dart';

// class MxMerchantSetup extends StatefulWidget {
//   const MxMerchantSetup({Key? key}) : super(key: key);

//   @override
//   State<MxMerchantSetup> createState() => _MxMerchantSetupState();
// }

// class _MxMerchantSetupState extends State<MxMerchantSetup> {
//   final _formKey = GlobalKey<FormState>();

//   @override
//   void initState() {
//     super.initState();
//     _get();
//   }

//   TerminalPro? terPro;

//   void _get() {
//     terPro = Provider.of<TerminalPro>(context, listen: false);
//     // _initPairingCodeMx = terPro?.serialCltr.text ?? '';

//     WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
//       terPro?.getMxMerchantCred();
//     });
//   }

//   @override
//   void dispose() {
//     terPro?.mxMerchatClear();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = Ssize(context);
//     final _terPro = Provider.of<TerminalPro>(context);

//     return SimpleDialog(
//       backgroundColor: kBackgroundColor,
//       titlePadding: EdgeInsets.zero,
//       contentPadding: EdgeInsets.symmetric(
//           horizontal: size.getW(12), vertical: size.getH(12)),
//       children: [
//         Processing(
//           loading: _terPro.pageLoad,
//           child: Container(
//             constraints: BoxConstraints(
//               maxHeight: size.height / 1.14,
//               minHeight: size.height / 5,
//             ),
//             width: size.width / 2,
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.symmetric(
//                         horizontal: size.getW(24), vertical: size.getH(24)),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text.rich(
//                           TextSpan(
//                             text: "MX Merchant Setup",
//                             children: [
//                               TextSpan(
//                                   text:
//                                       "\nConfigure Simple Cloud Integration Settings",
//                                   style: TextStyle(
//                                     fontSize: size.getS(16),
//                                     color: Colors.black54,
//                                   )),
//                             ],
//                           ),
//                           style: TextStyle(
//                             fontSize: size.getS(22),
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black,
//                             height: 1.4,
//                           ),
//                         ),
//                         Spacer(),
//                         Container(
//                             decoration: BoxDecoration(
//                               color: Colors.red.shade800,
//                               shape: BoxShape.circle,
//                             ),
//                             child: InkWell(
//                               onTap: () {
//                                 Navigator.pop(context);
//                               },
//                               child: Padding(
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: size.getS(8),
//                                     vertical: size.getS(8)),
//                                 child: Icon(
//                                   Icons.close,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             )),
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: size.getW(24)),
//                     child: TitleTextForm(
//                       title: "Pairing API key",
//                       hintText: "Pairing api key",
//                       isReq: true,
//                       textCltr: _terPro.mxApiKeyCltr,
//                       borderColor: Colors.black26,
//                       vPad: 16,
//                       pWidth: 0.5,
//                       suffixIcon: InkWell(
//                         onTap: () {
//                           _terPro.showMxApi = !_terPro.showMxApi;
//                           _terPro.notify;
//                         },
//                         child: Icon(
//                           _terPro.showMxApi
//                               ? Icons.visibility
//                               : Icons.visibility_off_outlined,
//                           size: size.getS(24),
//                         ),
//                       ),
//                       obsecure: !_terPro.showMxApi,
//                     ),
//                   ),
//                   SizedBox(
//                     height: size.getH(24),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: size.getW(24)),
//                     child: TitleTextForm(
//                       title: "Signing secret part A",
//                       hintText: "Signing secret part A",
//                       isReq: true,
//                       textCltr: _terPro.mxScretCltr,
//                       borderColor: Colors.black26,
//                       vPad: 16,
//                       pWidth: 0.5,
//                       suffixIcon: InkWell(
//                         onTap: () {
//                           _terPro.showMxSecret = !_terPro.showMxSecret;
//                           _terPro.notify;
//                         },
//                         child: Icon(
//                           _terPro.showMxSecret
//                               ? Icons.visibility
//                               : Icons.visibility_off_outlined,
//                           size: size.getS(24),
//                         ),
//                       ),
//                       obsecure: !_terPro.showMxSecret,
//                     ),
//                   ),
//                   SizedBox(
//                     height: size.getH(48),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: size.getW(24)),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         LoadButton(
//                           btnText: "Cancel",
//                           btnColor: Colors.red.shade700,
//                           onsave: () {
//                             Navigator.pop(context);
//                           },
//                         ),
//                         SizedBox(
//                           width: size.getW(24),
//                         ),
//                         LoadButton(
//                           btnText: "Save",
//                           btnColor: Colors.green.shade700,
//                           loading: _terPro.buttonLoad,
//                           onsave: () async {
//                             if (_formKey.currentState!.validate()) {
//                               await _terPro.updateMxMerchantCred((val, _data) {
//                                 if (val) {
//                                   GlobalCVP.updateAddSection(
//                                     data: {
//                                       "paymentIntegrationCredentials":
//                                           _data?.toJson()
//                                     },
//                                   );
//                                   Navigator.pop(context, true);
//                                 }
//                               });
//                             }
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: size.getH(24),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }
