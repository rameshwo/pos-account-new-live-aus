// import 'package:flutter/material.dart';
// import 'package:pos_account/ln.dart';
// import 'package:pos_account/model/auth/login_res.dart';
// import 'package:pos_account/repository/handler.dart';
// import 'package:pos_account/services/database/database/db_local_data.dart';
// import 'package:pos_account/services/database/shared_pref.dart';
// import 'package:pos_account/widgets/dialog/msg_dialog.dart';

// class ActDevPro extends ChangeNotifier {
//   final keyCltr = TextEditingController();
//   final deviceNoLCltr = TextEditingController();

//   bool loading = false;

//   void get notify => notifyListeners();

//   LoginRes? loginRes;
//   String? storeId;

//   Future<void> getLoginRes() async {
//     loginRes = await DbLocalData.getLoginRes();
//     storeId = await SharedPrefs.storeId;
//     notify;
//   }

//   bool get isActivated {
//     if (loginRes != null &&
//         loginRes!.storeDetailsLoginResponseViewModels!
//             .any((e) => e.storeId?.toLowerCase() == storeId?.toLowerCase())) {
//       return loginRes!.storeDetailsLoginResponseViewModels!
//               .firstWhere(
//                   (e) => e.storeId?.toLowerCase() == storeId?.toLowerCase())
//               .isDeviceActivated ??
//           false;
//     } else
//       return false;
//   }

//   Future<bool?> activate() async {
//     loading = true;
//     notify;

//     final status = await Handler.activateDevice(
//       key: keyCltr.text,
//       nameOrLoc: deviceNoLCltr.text,
//     );

//     if (status?.isActivated ?? false) {
//       if (loginRes?.storeDetailsLoginResponseViewModels != null &&
//           loginRes!.storeDetailsLoginResponseViewModels!
//               .any((e) => e.storeId?.toLowerCase() == storeId?.toLowerCase())) {
//         loginRes!.storeDetailsLoginResponseViewModels!
//             .firstWhere(
//                 (e) => e.storeId?.toLowerCase() == storeId?.toLowerCase())
//             .isDeviceActivated = true;
//         await DbLocalData.updateLoginRes(loginRes: loginRes!);
//         getLoginRes();
//       }
//     } else if (status?.message != null) {
//       MsgDia.show(
//         CUS_CTX,
//         headerAnimation: false,
//         diaType: DiaType.warning,
//         title: status?.message ?? '',
//         autoHideSecond: 3,
//       );
//     }

//     loading = false;
//     notify;

//     return (status?.isActivated ?? false);
//   }

//   void clear() {
//     keyCltr.clear();
//     deviceNoLCltr.clear();
//     loading = false;
//   }
// }
