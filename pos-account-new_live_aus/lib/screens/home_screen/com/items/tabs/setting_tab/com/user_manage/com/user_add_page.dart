// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';

// import 'dart:math';

// import '../../../../../../../../../config/size_config.dart';
// import '../../../../../../../../../config/validator.dart';
// import '../../../../../../../../../constant/constant.dart';
// import '../../../../../../../../../constant/text_formatter.dart';
// import '../../../../../../../../../ln.dart';
// import '../../../../../../../../../model/ui_model/screen_time_model.dart';
// import '../../../../../../../../../providers/cus_val_pro.dart';
// import '../../../../../../../../../providers/profile/user_manage_pro.dart';
// import '../../../../../../../../../providers/screen_saver/screen_saver_pro.dart';
// import '../../../../../../../../../widgets/image/network_image_sec.dart';
// import '../../../../../../../../../widgets/image/profile_img_sec.dart';
// import '../../../../../../../../../widgets/input/dropdown/dropdown_with_text_form.dart';
// import '../../../../../../../../../widgets/input/dropdown/title_drop_down.dart';
// import '../../../../../../../../../widgets/input/text_form/title_text_form.dart';
// import '../../../../../../../../../widgets/load_btn.dart';
// import '../../../../../../../../../widgets/loading.dart';
// import '../../../../../../../../../widgets/switch_adap.dart';
// import '../../general/common/common_header.dart';

// class UserAddPage extends StatefulWidget {
//   final PageController pageController;
//   final UserManagePro pro;
//   const UserAddPage({
//     Key? key,
//     required this.pageController,
//     required this.pro,
//   }) : super(key: key);

//   @override
//   State<UserAddPage> createState() => _UserAddPageState();
// }

// class _UserAddPageState extends State<UserAddPage> {
//   @override
//   void initState() {
//     widget.pro.getUserData();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     widget.pro.clear();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = Ssize(context);

//     return Processing(
//       loading: widget.pro.loading,
//       align: Alignment.topLeft,
//       child: Form(
//         key: widget.pro.formKey,
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               CommonHeader(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     IconButton(
//                         onPressed: () {
//                           widget.pageController.animateToPage(0,
//                               duration: Duration(milliseconds: 200),
//                               curve: Curves.easeInOut);
//                         },
//                         icon: Icon(Icons.arrow_back, size: size.getS(24))),
//                     SizedBox(width: size.getW(8)),
//                     Text(
//                       widget.pro.userId.isNotEmpty
//                           ? "Update User Information"
//                           : LN.addUser,
//                       style: TextStyle(
//                         fontSize: size.getS(18),
//                         // fontFamily: ,ph
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: size.getH(8)),
//               Card(
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10)),
//                 child: SizedBox(
//                   width: double.infinity,
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(
//                         vertical: size.getH(12.0), horizontal: size.getW(12)),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Wrap(
//                                     spacing: size.getW(24),
//                                     runSpacing: size.getH(16),
//                                     children: [
//                                       TitleTextForm(
//                                         title: LN.fullName,
//                                         isReq: true,
//                                         hintText: LN.fullName,
//                                         textCltr: widget.pro.nameCltr,
//                                         borderColor: Colors.black12,
//                                         pWidth: 0.24,
//                                       ),
//                                       DropDownWiTextForm(
//                                         title: LN.phoneNumber,
//                                         isReq: true,
//                                         pWidth: 0.24,
//                                         borderColor: Colors.black12,
//                                         indexVal: widget.pro.phoneCodeIndex,
//                                         list: widget.pro.userAddSec == null ||
//                                                 widget.pro.userAddSec!
//                                                         .countryCityStates ==
//                                                     null
//                                             ? []
//                                             : widget.pro.userAddSec!
//                                                 .countryCityStates!
//                                                 .map((e) => Row(
//                                                       mainAxisSize:
//                                                           MainAxisSize.min,
//                                                       children: [
//                                                         NetworkImageSec(
//                                                           image: e.image,
//                                                           height: size.isProt
//                                                               ? size.getW(12)
//                                                               : size.getW(16),
//                                                           width: size.isProt
//                                                               ? size.getW(12)
//                                                               : size.getW(16),
//                                                         ),
//                                                         if (e.additionalValue
//                                                             is String)
//                                                           Flexible(
//                                                             child: Align(
//                                                               alignment: Alignment
//                                                                   .centerRight,
//                                                               child: Text(
//                                                                 e.additionalValue ??
//                                                                     '',
//                                                                 style:
//                                                                     TextStyle(
//                                                                   fontSize: size
//                                                                           .isProt
//                                                                       ? size
//                                                                           .getW(
//                                                                               12)
//                                                                       : size.getS(
//                                                                           16),
//                                                                   color: Colors
//                                                                       .black,
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           )
//                                                       ],
//                                                     ))
//                                                 .toList(),
//                                         onChanged: (p0) {
//                                           widget.pro.phoneCodeIndex = p0;
//                                           widget.pro.notify;
//                                         },
//                                         textCltr: widget.pro.phoneCltr,
//                                       ),
//                                       TitleTextForm(
//                                         title: LN.email,
//                                         isReq: true,
//                                         hintText: LN.emailAddress,
//                                         textCltr: widget.pro.emailCltr,
//                                         borderColor: Colors.black12,
//                                         pWidth: 0.24,
//                                         validator: emailValidator,
//                                       ),
//                                       SearchTitleDropDown(
//                                         title: LN.country,
//                                         isReq: true,
//                                         list: widget.pro.userAddSec
//                                                     ?.countryCityStates ==
//                                                 null
//                                             ? []
//                                             : widget.pro.userAddSec!
//                                                 .countryCityStates!
//                                                 .map((e) => e.name ?? '')
//                                                 .toList(),
//                                         indexVal: widget.pro.countryIndex,
//                                         onChanged: (p0) {
//                                           widget.pro.countryIndex = p0;
//                                           widget.pro.phoneCodeIndex = p0;
//                                           widget.pro.stateIndex = null;
//                                           widget.pro.cityIndex = null;
//                                           // widget.pro.suburbIndex = null;
//                                           widget.pro.notify;
//                                         },
//                                         borderColor: Colors.black12,
//                                         pWidth: 0.24,
//                                       ),
//                                       SearchTitleDropDown(
//                                         title: LN.state,
//                                         pWidth: 0.24,
//                                         isReq: true,
//                                         borderColor: Colors.black12,
//                                         indexVal: widget.pro.stateIndex,
//                                         list: widget.pro.countryIndex == null ||
//                                                 widget
//                                                         .pro
//                                                         .userAddSec
//                                                         ?.countryCityStates?[
//                                                             widget.pro
//                                                                 .countryIndex!]
//                                                         .states ==
//                                                     null ||
//                                                 widget
//                                                     .pro
//                                                     .userAddSec!
//                                                     .countryCityStates![widget
//                                                         .pro.countryIndex!]
//                                                     .states!
//                                                     .isEmpty
//                                             ? []
//                                             : widget
//                                                 .pro
//                                                 .userAddSec!
//                                                 .countryCityStates![
//                                                     widget.pro.countryIndex!]
//                                                 .states!
//                                                 .map((e) => e.name ?? '')
//                                                 .toList(),
//                                         onChanged: (p0) {
//                                           widget.pro.stateIndex = p0;
//                                           widget.pro.cityIndex = null;
//                                           // widget.pro.suburbIndex = null;
//                                           widget.pro.notify;
//                                         },
//                                       ),
//                                       SearchTitleDropDown(
//                                         title: LN.city,
//                                         pWidth: 0.24,
//                                         isReq: true,
//                                         borderColor: Colors.black12,
//                                         indexVal: widget.pro.cityIndex,
//                                         list: widget.pro.countryIndex == null ||
//                                                 widget.pro.stateIndex == null ||
//                                                 widget
//                                                         .pro
//                                                         .userAddSec
//                                                         ?.countryCityStates?[
//                                                             widget.pro
//                                                                 .countryIndex!]
//                                                         .states?[widget
//                                                             .pro.stateIndex!]
//                                                         .cities ==
//                                                     null ||
//                                                 widget
//                                                     .pro
//                                                     .userAddSec!
//                                                     .countryCityStates![widget
//                                                         .pro.countryIndex!]
//                                                     .states![
//                                                         widget.pro.stateIndex!]
//                                                     .cities!
//                                                     .isEmpty
//                                             ? []
//                                             : widget
//                                                 .pro
//                                                 .userAddSec!
//                                                 .countryCityStates![
//                                                     widget.pro.countryIndex!]
//                                                 .states![widget.pro.stateIndex!]
//                                                 .cities!
//                                                 .map((e) => e.name ?? '')
//                                                 .toList(),
//                                         onChanged: (p0) {
//                                           widget.pro.cityIndex = p0;
//                                           // widget.pro.suburbIndex = null;
//                                           widget.pro.notify;
//                                         },
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             ProfileImageSec(
//                               size: size,
//                               radius: 144,
//                               pickImage: () => widget.pro.getFilePick(),
//                               filePath: widget.pro.getFilePath,
//                             ),
//                             SizedBox(width: size.getW(100)),
//                           ],
//                         ),
//                         SizedBox(
//                           height: size.getH(16),
//                         ),
//                         Wrap(
//                           spacing: size.getW(24),
//                           runSpacing: size.getH(16),
//                           children: [
//                             TitleTextForm(
//                               title: LN.postalCode,
//                               isReq: true,
//                               hintText: "",
//                               textCltr: widget.pro.postalCltr,
//                               borderColor: Colors.black12,
//                               pWidth: 0.24,
//                             ),
//                             TitleDropDown(
//                               isReq: true,
//                               title: LN.userType,
//                               list: widget.pro.userAddSec == null ||
//                                       widget.pro.userAddSec!.userTypes == null
//                                   ? []
//                                   : widget.pro.userAddSec!.userTypes!
//                                       .map((e) => e.value ?? '')
//                                       .toList(),
//                               indexVal: widget.pro.userTypeIndex,
//                               onChanged: (p0) {
//                                 widget.pro.userTypeIndex = p0;
//                                 widget.pro.notify;
//                               },
//                               borderColor: Colors.black12,
//                               pWidth: 0.24,
//                             ),
//                             TitleDropDown(
//                               // isReq: true,
//                               title: LN.userRole,
//                               list: widget.pro.userAddSec?.roles == null
//                                   ? []
//                                   : widget.pro.userAddSec!.roles!
//                                       .map((e) => e.value ?? '')
//                                       .toList(),
//                               indexVal: widget.pro.userRoleIndex,
//                               onChanged: (p0) {
//                                 widget.pro.userRoleIndex = p0;
//                                 widget.pro.notify;
//                               },
//                               borderColor: Colors.black12,
//                               pWidth: 0.24,
//                             ),
//                             // SearchTitleDropDown(
//                             //   title: "Suburb",
//                             //   pWidth: 0.24,
//                             //   isReq: true,
//                             //   borderColor: Colors.black12,
//                             //   indexVal: widget.pro.suburbIndex,
//                             //   list: widget.pro.countryIndex == null ||
//                             //           widget.pro.stateIndex == null ||
//                             //           widget.pro.cityIndex == null ||
//                             //           widget.pro
//                             //                   .userAddSec
//                             //                   ?.countryCityStates?[
//                             //                       widget.pro.countryIndex!]
//                             //                   .states?[widget.pro.stateIndex!]
//                             //                   .cities?[widget.pro.cityIndex!]
//                             //                   .suburbs ==
//                             //               null ||
//                             //           widget.pro
//                             //               .userAddSec!
//                             //               .countryCityStates![
//                             //                   widget.pro.countryIndex!]
//                             //               .states![widget.pro.stateIndex!]
//                             //               .cities![widget.pro.cityIndex!]
//                             //               .suburbs!
//                             //               .isEmpty
//                             //       ? []
//                             //       : widget.pro
//                             //           .userAddSec!
//                             //           .countryCityStates![
//                             //               widget.pro.countryIndex!]
//                             //           .states![widget.pro.stateIndex!]
//                             //           .cities![widget.pro.cityIndex!]
//                             //           .suburbs!
//                             //           .map((e) => e.name ?? '')
//                             //           .toList(),
//                             //   onChanged: (p0) {
//                             //     widget.pro.suburbIndex = p0;
//                             //     widget.pro.notify;
//                             //   },
//                             // ),

//                             // AutoCompleteText(
//                             //   title: LN.address,
//                             //   textCltr: widget.pro.addressCltr,
//                             //   hintText: LN.address,
//                             //   borderColor: Colors.black12,
//                             //   isReq: true,
//                             //   onChanged: (String val) {
//                             //     if (val.length > 2)
//                             //       Future.delayed(
//                             //           Duration(milliseconds: 500), () {
//                             //         widget.pro.getPlaces(
//                             //           input: val,
//                             //           country: widget.pro.countryIndex == null
//                             //               ? null
//                             //               : widget.pro
//                             //                   .userAddSec
//                             //                   ?.countryCityStates?[
//                             //                       widget.pro.countryIndex!]
//                             //                   .name,
//                             //         );
//                             //       });
//                             //   },
//                             //   suggestion: (widget.pro.getAutoPlaces == null ||
//                             //           widget.pro.getAutoPlaces!.predictions ==
//                             //               null)
//                             //       ? []
//                             //       : widget.pro.getAutoPlaces!.predictions!
//                             //           .map((e) => e.description!)
//                             //           .toSet()
//                             //           .toList(),
//                             //   onSubmit: (val) {
//                             //     if (widget.pro.getAutoPlaces!.predictions!
//                             //         .any((e) => e.description == val)) {
//                             //       final _pId = widget.pro
//                             //           .getAutoPlaces!.predictions!
//                             //           .firstWhere(
//                             //               (e) => e.description == val)
//                             //           .placeId;
//                             //       widget.pro.setPlaceId = _pId;
//                             //     }
//                             //   },
//                             // ),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(LN.status,
//                                     style: TextStyle(
//                                       fontSize: size.getS(18),
//                                       color: Colors.black,
//                                     )),
//                                 SizedBox(
//                                   height: size.getH(12),
//                                 ),
//                                 Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     SwitchAdap(
//                                         height: 32,
//                                         size: size,
//                                         value: widget.pro.isActive,
//                                         onChanged: (val) {
//                                           widget.pro.isActive = val;
//                                           widget.pro.notify;
//                                         }),
//                                     SizedBox(
//                                       width: size.getW(12),
//                                     ),
//                                     Text(
//                                       widget.pro.isActive
//                                           ? LN.active
//                                           : LN.inActive,
//                                       style: TextStyle(
//                                         color: widget.pro.isActive
//                                             ? Colors.green.shade600
//                                             : Colors.red.shade600,
//                                         fontFamily: kFontFMedium,
//                                         fontSize: size.getS(16),
//                                       ),
//                                     ),
//                                     if (widget.pro.userAddSec != null &&
//                                         widget.pro.userAddSec!.userTypes !=
//                                             null &&
//                                         widget.pro.userTypeIndex != null &&
//                                         widget
//                                             .pro
//                                             .userAddSec!
//                                             .userTypes![
//                                                 widget.pro.userTypeIndex!]
//                                             .value!
//                                             .contains("Admin"))
//                                       Row(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           SizedBox(
//                                             width: size.getW(24),
//                                           ),
//                                           SwitchAdap(
//                                               size: size,
//                                               height: 32,
//                                               value: widget
//                                                   .pro.pushNotificationEnable,
//                                               onChanged: (val) {
//                                                 widget.pro
//                                                         .pushNotificationEnable =
//                                                     val;
//                                                 widget.pro.notify;
//                                               }),
//                                           SizedBox(
//                                             width: size.getW(12),
//                                           ),
//                                           Text(
//                                             LN.pushNoti,
//                                             style: TextStyle(
//                                               color: Colors.black,
//                                               fontFamily: kFontFMedium,
//                                               fontSize: size.getS(16),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                         SizedBox(
//                           height: size.getH(16),
//                         ),
//                         Card(
//                           elevation: 2,
//                           shape: RoundedRectangleBorder(
//                               side: BorderSide(color: Colors.black12),
//                               borderRadius: BorderRadius.circular(5)),
//                           child: SizedBox(
//                             width: double.infinity,
//                             child: Padding(
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: size.getW(16),
//                                   vertical: size.getH(24)),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     "Account Information",
//                                     style: TextStyle(
//                                       fontSize: size.getS(18),
//                                       // fontFamily: ,ph
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.black,
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     height: size.getH(16),
//                                   ),
//                                   Wrap(
//                                     spacing: size.getW(32),
//                                     runSpacing: size.getH(16),
//                                     children: [
//                                       TitleDropDown(
//                                           title: "POS Tab Default Screen Name",
//                                           list: widget.pro.userAddSec
//                                                       ?.posTabDefaultScreens ==
//                                                   null
//                                               ? []
//                                               : widget.pro.userAddSec!
//                                                   .posTabDefaultScreens!
//                                                   .map((e) => e.name ?? '')
//                                                   .toList(),
//                                           borderColor: Colors.black12,
//                                           pWidth: 0.24,
//                                           indexVal:
//                                               widget.pro.defaultScreenIndex,
//                                           onChanged: (p0) {
//                                             widget.pro.defaultScreenIndex = p0;
//                                             widget.pro.notify;
//                                           },
//                                           sufIcon: InkWell(
//                                               onTap: () {
//                                                 widget.pro.defaultScreenIndex =
//                                                     null;
//                                                 widget.pro.notify;
//                                               },
//                                               child: Icon(Icons.close,
//                                                   size: size.getS(24)))),
//                                       TitleTextForm(
//                                         title: "Login Pin",
//                                         isReq: false,
//                                         hintText: "Pin code",
//                                         textCltr: widget.pro.pinCltr,
//                                         borderColor: Colors.black12,
//                                         pWidth: 0.24,
//                                         textInputType: TextInputType.number,
//                                         inputFormatters: [
//                                           NonNegativeTextInputFormatter(),
//                                           FilteringTextInputFormatter
//                                               .digitsOnly,
//                                           LengthLimitingTextInputFormatter(4),
//                                         ],
//                                         suffix: InkWell(
//                                           onTap: () {
//                                             Random random = Random();
//                                             final int randomNumber =
//                                                 1000 + random.nextInt(9000);
//                                             widget.pro.pinCltr.text =
//                                                 randomNumber.toString();
//                                             widget.pro.notify;
//                                           },
//                                           child: Row(
//                                             children: [
//                                               Icon(Icons.key,
//                                                   size: size.getS(18)),
//                                               Text(
//                                                 "Generate random 4 digit",
//                                                 style: TextStyle(
//                                                   fontSize: size.getS(14),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                       TitleDropDown(
//                                         title: LN.screenTime,
//                                         list: ScreenTimeOut.map((e) => e.title)
//                                             .toList(),
//                                         indexVal: widget.pro.intervalIndex,
//                                         onChanged: (p0) {
//                                           widget.pro.intervalIndex = p0;
//                                           widget.pro.notify;
//                                         },
//                                         borderColor: Colors.black12,
//                                         pWidth: 0.24,
//                                       ),
//                                       Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           Text("Login Pin Code Popup Screen",
//                                               style: TextStyle(
//                                                 fontSize: size.getS(18),
//                                                 color: Colors.black,
//                                               )),
//                                           SizedBox(
//                                             height: size.getH(12),
//                                           ),
//                                           SwitchAdap(
//                                               height: 32,
//                                               size: size,
//                                               value: widget.pro.enablePinCode,
//                                               onChanged: (val) {
//                                                 widget.pro.enablePinCode = val;
//                                                 widget.pro.notify;
//                                               }),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           height: size.getH(24),
//                         ),
//                         Row(
//                           children: [
//                             if (GlobalCVP.viewWidget.viewAddUserTabSaveButton)
//                               IgnorePointer(
//                                 ignoring: widget.pro.loading,
//                                 child: LoadButton(
//                                   btnText: LN.save,
//                                   btnColor: kUserColor,
//                                   loading: widget.pro.updateLoad,
//                                   onsave: () async {
//                                     FocusScope.of(context).unfocus();
//                                     if (widget.pro.formKey.currentState!
//                                         .validate()) {
//                                       final _status =
//                                           await widget.pro.addUpUser();
//                                       if (_status) {
//                                         await GlobalCVP.getStoreDetails();
//                                         final _screenSavPro =
//                                             Provider.of<ScreenSaverPro>(context,
//                                                 listen: false);
//                                         _screenSavPro.setInterval(GlobalCVP
//                                             .currentStore
//                                             ?.loginPinAutoLogOffInterval);
//                                       }
//                                     }
//                                   },
//                                 ),
//                               ),
//                             SizedBox(
//                               width: size.getW(12),
//                             ),
//                             if (widget.pro.userId.isNotEmpty &&
//                                 GlobalCVP.viewWidget.viewAddUserTabCancelButton)
//                               LoadButton(
//                                 btnText: LN.cancel,
//                                 btnColor: Colors.red.shade600,
//                                 onsave: () {
//                                   widget.pro.clear();
//                                   widget.pageController.jumpToPage(0);
//                                 },
//                               ),
//                           ],
//                         ),
//                         SizedBox(
//                           height: size.getH(24),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
