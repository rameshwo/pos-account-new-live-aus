// import 'package:flutter/material.dart';
// import 'package:pos_account/config/size_config.dart';
// import 'package:pos_account/config/validator.dart';
// import 'package:pos_account/constant/constant.dart';
// import 'package:pos_account/ln.dart';
// import 'package:pos_account/model/home/booking/all_customer.dart';
// import 'package:pos_account/model/home/menu/payment/cus_loyal_res.dart';
// import 'package:pos_account/providers/menu/payment_pro.dart';
// import 'package:pos_account/screens/home_screen/com/dialogs/cus_list_dia.dart';
// import 'package:pos_account/widgets/image/network_image_sec.dart';
// import 'package:pos_account/widgets/input/dropdown/dropdown_with_text_form.dart';
// import 'package:pos_account/widgets/input/dropdown/title_drop_down.dart';
// import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
// import 'package:pos_account/widgets/load_btn.dart';
// import 'package:pos_account/widgets/loading.dart';
// import 'package:pos_account/widgets/switch_adap.dart';
// import 'package:provider/provider.dart';

// class AddCustomer extends StatefulWidget {
//   const AddCustomer({
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<AddCustomer> createState() => _AddCustomerState();
// }

// class _AddCustomerState extends State<AddCustomer> {
//   late PaymentPro _payPro;

//   @override
//   void initState() {
//     _payPro = Provider.of<PaymentPro>(context, listen: false);
//     _payPro.cusAddSec();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _payPro.cusAddSecPageLoading = false;
//     existingCusId = null;
//     super.dispose();
//   }

//   void clear() {
//     _payPro.searchCusCltr.clear();
//     _payPro.cusNameCltr.clear();
//     _payPro.cusEmailCltr.clear();
//     _payPro.cusPhoneCltr.clear();
//     _payPro.postalCodeCltr.clear();
//     _payPro.recieveMarketMat = false;
//     _payPro.loyalityEnable = true;
//     _payPro.cusForLoyalityRes = null;
//     existingCusId = null;
//     CusListDia.selectedId = null;
//     _payPro.notify;
//   }

//   String? existingCusId;

//   void setData(CusData value) {
//     existingCusId = value.id;
//     if (_payPro.customerAddSecRes?.customerType?.any((e) =>
//             value.customerType?.toLowerCase() == e.value?.toLowerCase()) ??
//         false) {
//       _payPro.customerTypeIndex = _payPro.customerAddSecRes!.customerType!
//           .indexWhere((e) =>
//               value.customerType?.toLowerCase() == e.value?.toLowerCase());
//     }

//     _payPro.cusNameCltr.text = value.name ?? '';
//     _payPro.cusEmailCltr.text = value.email ?? '';
//     _payPro.cusPhoneCltr.text = value.phoneNumber ?? '';
//     _payPro.postalCodeCltr.text = value.postalCode ?? '';

//     if (_payPro.customerAddSecRes?.countries?.any(
//             (e) => e.id?.toLowerCase() == value.countryId?.toLowerCase()) ??
//         false) {
//       _payPro.countryIndex = _payPro.customerAddSecRes!.countries!.indexWhere(
//           (e) => e.id?.toLowerCase() == value.countryId?.toLowerCase());
//     }

//     if (_payPro.customerAddSecRes?.countries?.any((e) =>
//             e.id?.toLowerCase() ==
//             value.countryPhoneNumberPrefixId?.toLowerCase()) ??
//         false) {
//       _payPro.phoneCodeIndex = _payPro.customerAddSecRes!.countries!.indexWhere(
//           (e) =>
//               e.id?.toLowerCase() ==
//               value.countryPhoneNumberPrefixId?.toLowerCase());
//     }
//     _payPro.recieveMarketMat = value.isMarketingPromotionEnabled ?? false;

//     _payPro.loyalityEnable = value.isLoyaltyEnabled ?? true;
//     _payPro.notify;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = Ssize(context);
//     final paymentPro = Provider.of<PaymentPro>(context);
//     return Processing(
//       loading: paymentPro.cusAddSecPageLoading,
//       child: Container(
//         constraints: BoxConstraints(
//           maxHeight: size.height / 1.14,
//           minHeight: size.height / 5,
//         ),
//         width: size.width / 1.2,
//         child: Form(
//           key: paymentPro.formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(LN.addCustomer,
//                       style: TextStyle(
//                         fontSize: size.getS(20),
//                         color: Colors.black,
//                         fontFamily: kFontFMedium,
//                         fontWeight: FontWeight.bold,
//                       )),
//                   IconButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       icon: Icon(
//                         Icons.close,
//                         size: size.getS(28),
//                       ))
//                 ],
//               ),
//               Flexible(
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Flexible(
//                       flex: 3,
//                       child: SingleChildScrollView(
//                         physics: BouncingScrollPhysics(),
//                         keyboardDismissBehavior:
//                             ScrollViewKeyboardDismissBehavior.onDrag,
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             SizedBox(
//                               height: size.getH(12),
//                             ),
//                             TitleTextForm(
//                               title: LN.name,
//                               textCltr: paymentPro.cusNameCltr,
//                               pWidth: 0.24,
//                               borderColor: Colors.black26,
//                             ),
//                             SizedBox(
//                               height: size.getH(12),
//                             ),
//                             DropDownWiTextForm(
//                               title: LN.phoneNumber,
//                               isReq: true,
//                               pWidth: 0.24,
//                               indexVal: paymentPro.phoneCodeIndex,
//                               list: paymentPro.customerAddSecRes?.countries ==
//                                       null
//                                   ? []
//                                   : paymentPro.customerAddSecRes!.countries!
//                                       .map((e) => Row(
//                                             mainAxisSize: MainAxisSize.min,
//                                             children: [
//                                               NetworkImageSec(
//                                                 image: e.image,
//                                                 height: size.isProt
//                                                     ? size.getW(12)
//                                                     : size.getW(16),
//                                                 width: size.isProt
//                                                     ? size.getW(12)
//                                                     : size.getW(16),
//                                               ),
//                                               if (e.additionalValue is String)
//                                                 Flexible(
//                                                   child: Align(
//                                                     alignment:
//                                                         Alignment.centerRight,
//                                                     child: Text(
//                                                       e.additionalValue,
//                                                       style: TextStyle(
//                                                         fontSize: size.isProt
//                                                             ? size.getW(12)
//                                                             : size.getS(16),
//                                                         color: Colors.black,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 )
//                                             ],
//                                           ))
//                                       .toList(),
//                               onChanged: (p0) {
//                                 paymentPro.phoneCodeIndex = p0;
//                                 paymentPro.notify;
//                               },
//                               textCltr: paymentPro.cusPhoneCltr,
//                               borderColor: Colors.black26,
//                             ),
//                             SizedBox(
//                               height: size.getH(12),
//                             ),
//                             TitleTextForm(
//                               title: LN.email,
//                               textCltr: paymentPro.cusEmailCltr,
//                               isReq: false,
//                               pWidth: 0.24,
//                               borderColor: Colors.black26,
//                               validator: emailValidator,
//                               textInputType: TextInputType.emailAddress,
//                             ),
//                             SizedBox(
//                               height: size.getH(12),
//                             ),
//                             SearchTitleDropDown(
//                               pWidth: 0.24,
//                               title: LN.country,
//                               isReq: true,
//                               list: paymentPro.customerAddSecRes?.countries ==
//                                       null
//                                   ? []
//                                   : paymentPro.customerAddSecRes!.countries!
//                                       .map((e) => e.name ?? '')
//                                       .toList(),
//                               indexVal: paymentPro.countryIndex,
//                               onChanged: (p0) {
//                                 paymentPro.countryIndex = p0;
//                                 paymentPro.phoneCodeIndex = p0;
//                                 paymentPro.notify;
//                               },
//                               borderColor: Colors.black26,
//                             ),
//                             SizedBox(
//                               height: size.getH(12),
//                             ),
//                             TitleTextForm(
//                               title: LN.postalCode,
//                               textCltr: paymentPro.postalCodeCltr,
//                               isReq: false,
//                               pWidth: 0.24,
//                               borderColor: Colors.black26,
//                               textInputType: TextInputType.number,
//                             ),
//                             SizedBox(
//                               height: size.getH(12),
//                             ),
//                             TitleDropDown(
//                               pWidth: 0.24,
//                               title: LN.customerType,
//                               hintText: LN.customerType,
//                               isReq: true,
//                               list: paymentPro
//                                           .customerAddSecRes?.customerType ==
//                                       null
//                                   ? []
//                                   : paymentPro.customerAddSecRes!.customerType!
//                                       .map((e) => e.name ?? '')
//                                       .toSet()
//                                       .toList(),
//                               indexVal: paymentPro.customerTypeIndex,
//                               onChanged: (p0) {
//                                 paymentPro.customerTypeIndex = p0;
//                                 paymentPro.notify;
//                               },
//                               borderColor: Colors.black26,
//                             ),
//                             SizedBox(
//                               height: size.getH(24),
//                             ),
//                             InkWell(
//                               onTap: () {
//                                 paymentPro.recieveMarketMat =
//                                     !paymentPro.recieveMarketMat;
//                                 paymentPro.notify;
//                               },
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                     color: paymentPro.recieveMarketMat
//                                         ? kSecondaryColor.withOpacity(0.2)
//                                         : null,
//                                     borderRadius: BorderRadius.circular(5),
//                                     border: Border.all(
//                                         color: paymentPro.recieveMarketMat
//                                             ? kSecondaryColor.withOpacity(0.2)
//                                             : Colors.black26)),
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: size.getW(24),
//                                     vertical: size.getH(4)),
//                                 child: Row(
//                                   // mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     IgnorePointer(
//                                       ignoring: true,
//                                       child: Checkbox(
//                                         value: paymentPro.recieveMarketMat,
//                                         activeColor: kSecondaryColor,
//                                         onChanged: (val) {
//                                           // if (val == null) return;
//                                           // paymentPro.recieveMarketMat = val;
//                                           // paymentPro.notify;
//                                         },
//                                       ),
//                                     ),
//                                     Text(
//                                       LN.receiveMarMat,
//                                       style: TextStyle(
//                                         fontSize: size.getS(16),
//                                         color: Colors.black,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             SizedBox(
//                               height: size.getH(24),
//                             ),
//                             InkWell(
//                               onTap: () {
//                                 paymentPro.loyalityEnable =
//                                     !paymentPro.loyalityEnable;
//                                 if (paymentPro.cusForLoyalityRes != null)
//                                   paymentPro.cusForLoyalityRes!.loyaltyEnabled =
//                                       paymentPro.loyalityEnable;
//                                 paymentPro.notify;
//                               },
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   IgnorePointer(
//                                     ignoring: true,
//                                     child: SwitchAdap(
//                                         activeColor: kSecondaryColor,
//                                         value: paymentPro.loyalityEnable,
//                                         size: size,
//                                         onChanged: (val) {
//                                           // paymentPro.loyalityEnable = val;
//                                           // if (paymentPro.cusForLoyalityRes != null)
//                                           //   paymentPro.cusForLoyalityRes!
//                                           //       .loyaltyEnabled = val;
//                                           // paymentPro.notify;
//                                         }),
//                                   ),
//                                   Text(
//                                     LN.enableLoyal,
//                                     style: TextStyle(
//                                       fontSize: size.getS(16),
//                                       color: paymentPro.loyalityEnable
//                                           ? kSecondaryColor
//                                           : Colors.black,
//                                       fontFamily: kFontFMedium,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             SizedBox(
//                               height: size.getH(24),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: size.getW(12)),
//                     Flexible(
//                         flex: 8,
//                         child: CusListDia(
//                           isSingleWidget: false,
//                           onTap: setData,
//                         )),
//                   ],
//                 ),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   LoadButton(
//                     btnText: LN.clear,
//                     btnColor: Colors.red.shade600,
//                     onsave: () {
//                       clear();
//                     },
//                   ),
//                   SizedBox(
//                     width: size.getW(12),
//                   ),
//                   LoadButton(
//                     btnText: existingCusId != null ? LN.confirm : LN.addCus,
//                     onsave: () async {
//                       if (paymentPro.formKey.currentState!.validate()) {
//                         paymentPro.cusAddSecPageLoading = true;
//                         paymentPro.notify;
//                         if (existingCusId != null) {
//                           if (paymentPro.cusEmailCltr.text.isNotEmpty) {
//                             await _payPro
//                                 .searchCustomer(paymentPro.cusEmailCltr.text);
//                           } else if (paymentPro.cusPhoneCltr.text.isNotEmpty) {
//                             await _payPro
//                                 .searchCustomer(paymentPro.cusPhoneCltr.text);
//                           }
//                         }

//                         paymentPro.cusForLoyalityRes ??= CusForLoyalityRes();

//                         paymentPro.cusForLoyalityRes?.loyaltyEnabled =
//                             paymentPro.cusForLoyalityRes?.loyaltyEnabled ??
//                                 paymentPro.loyalityEnable;

//                         paymentPro.cusForLoyalityRes!.customerName =
//                             paymentPro.cusNameCltr.text;
//                         paymentPro.cusForLoyalityRes!.phoneNumber =
//                             paymentPro.cusPhoneCltr.text;
//                         paymentPro.cusForLoyalityRes!.email =
//                             paymentPro.cusEmailCltr.text;
//                         paymentPro.cusForLoyalityRes!.postalCode =
//                             paymentPro.postalCodeCltr.text;
//                         paymentPro.cusAddSecPageLoading = false;
//                         paymentPro.notify;
//                         Navigator.pop(context);
//                       }
//                     },
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: size.getH(24),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
