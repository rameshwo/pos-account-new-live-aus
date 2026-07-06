// import 'package:flutter/material.dart';
// import 'package:pos_account/config/size_config.dart';
// import 'package:pos_account/env.dart';
// import 'package:pos_account/ln.dart';
// import 'package:pos_account/model/common/res_datum.dart';
// import 'package:pos_account/model/common/table_location.dart';
// import 'package:pos_account/model/home/setting/general/category/restro_table_model.dart';
// import 'package:pos_account/model/home/setting/pos_device/eft_pos/all_eft_pos_devices.dart';
// import 'package:pos_account/model/home/setting/pos_device/eft_pos/eft_pos_addsec.dart';
// import 'package:pos_account/model/home/setting/pos_device/eft_pos/eft_pos_setup.dart';
// import 'package:pos_account/model/ui_model/tablelist_model.dart';
// import 'package:pos_account/repository/handler.dart';
// import 'package:pos_account/services/web_view/inapp_web_screen.dart';
// // import 'package:pos_account/services/web_view/webview_screen.dart';

// class EftPosPro extends ChangeNotifier {
//   void get notify => notifyListeners();
//   int pageIndex = 1;
//   int? tableIndex;
//   String itemId = "";
//   int selectedCount = 0;

//   static List<String> get _headerList => [
//         LN.eftposMer,
//         LN.paymentProvider,
//         LN.posName,
//         LN.serialNo,
//         LN.ipAddress,
//         LN.action,
//       ];
//   var tableData = <TLModel>[];
//   final tableList = RTableData(
//     headerList: [
//       LN.eftposMerPay,
//       LN.eftposMerPayPro,
//       LN.serialNo,
//       LN.ipAddress,
//       LN.action,
//     ],
//   );

//   EftPosAddSec? eftPosAddSec;
//   EftPosSetup? eftPosSetupData;
//   AllEfotPosDevices? allEfotPosDevices;

//   int? _merchantIndex;
//   int? _merchantProviderIndex;
//   int? get getmerchantIndex => _merchantIndex;
//   int? get getmerchantProviderIndex => _merchantProviderIndex;
//   set setMerchantindex(int? val) {
//     _merchantIndex = val;
//   }

//   set setMerchantProviderIndex(int? val) {
//     _merchantProviderIndex = val;
//   }

//   final List<EftPosMerchantWithPayment> _eftPosPaymentMerchantList = [];
//   final List<TableLocation> _eftPosPaymentProviderList = [];
//   List<EftPosMerchantWithPayment> get eftPosPaymentMerchantList =>
//       _eftPosPaymentMerchantList;
//   List<TableLocation> get eftPosPaymentProviderList =>
//       _eftPosPaymentProviderList;
//   bool loading = true;

//   void init() {
//     tableList.headerList = _headerList;
//     tableData = <TLModel>[
//       TLModel(
//         title: LN.posName,
//         isReq: true,
//         tableCltr: TextEditingController(),
//       ),
//       TLModel(
//         title: LN.serialNo,
//         isReq: true,
//         tableCltr: TextEditingController(),
//       ),
//       TLModel(
//         title: LN.ipAddress,
//         isReq: true,
//         tableCltr: TextEditingController(),
//       ),
//       TLModel(
//         title: LN.port,
//         tableCltr: TextEditingController(),
//         textInputType: TextInputType.number,
//       ),
//     ];
//   }

//   Future<void> getData({required int page}) async {
//     pageIndex = page;
//     allEfotPosDevices = await Handler.getAllEFTPosTerminalDevice(page: page);
//     if (allEfotPosDevices?.data != null) {
//       tableList.tableDataList = [];
//       for (var e in allEfotPosDevices!.data!) {
//         tableList.tableDataList.add(
//           TableDataList(id: e.id!, itemList: [
//             e.merchant ?? '',
//             e.merchantPaymentProvider ?? '',
//             e.eftposTerminalName ?? '',
//             e.serialNumber ?? '',
//             e.ipAddress ?? '',
//           ], statusList: []),
//         );
//       }
//     }
//     loading = false;
//     notify;
//   }

//   Future<void> getAddSec() async {
//     eftPosAddSec = await Handler.getEftPosAddSec();
//     if (eftPosAddSec?.eftPosMerchantWithPaymentProviderListViewModels != null)
//       for (final element
//           in eftPosAddSec!.eftPosMerchantWithPaymentProviderListViewModels!) {
//         _eftPosPaymentMerchantList.add(element);
//       }
//     notify;
//   }

//   Future<void> addUpdate() async {
//     String? _eftPosMerchantId = _eftPosPaymentMerchantList[_merchantIndex!].id;

//     String? _eftPosMerchantPaymentProviderId = _merchantProviderIndex == null
//         ? ""
//         : (_merchantProviderIndex! >= 0)
//             ? _eftPosPaymentMerchantList[_merchantIndex!]
//                     .eFtPosPaymentProviders![_merchantProviderIndex!]
//                     .id ??
//                 ""
//             : "";

//     loading = true;
//     notify;
//     final _data = EftPosSetup(
//       id: itemId,
//       eftPosMerchantId: _eftPosMerchantId,
//       eftPosMerchantPaymentProviderId: _eftPosMerchantPaymentProviderId,
//       name: tableData[0].tableCltr.text,
//       serialNumber: tableData[1].tableCltr.text,
//       ipAddress: tableData[2].tableCltr.text,
//       port: tableData[3].tableCltr.text,
//     );

//     final _status = await Handler.addUpEftPosSetup(setUp: _data);
//     if (_status ?? false) {
//       clear();
//       getData(page: pageIndex);
//     }
//     loading = false;
//     notify;
//   }

//   Future<void> editData() async {
//     if (itemId.isEmpty) return;
//     loading = true;
//     notify;
//     final _editData = await Handler.editPosEftDevice(id: itemId);
//     if (_editData != null) {
//       tableData[0].tableCltr.text = _editData.name ?? '';
//       tableData[1].tableCltr.text = _editData.serialNumber ?? '';
//       tableData[2].tableCltr.text = _editData.ipAddress ?? '';
//       tableData[3].tableCltr.text = _editData.port ?? '';
//       if (_eftPosPaymentMerchantList.any((e) =>
//           e.id!.toLowerCase() == _editData.eftPosMerchantId?.toLowerCase())) {
//         _merchantIndex = _eftPosPaymentMerchantList.indexWhere((e) =>
//             e.id?.toLowerCase() == _editData.eftPosMerchantId?.toLowerCase());

//         _merchantProviderIndex = _eftPosPaymentMerchantList[_merchantIndex!]
//             .eFtPosPaymentProviders
//             ?.indexWhere((e) =>
//                 e.id?.toLowerCase() ==
//                 _editData.eftPosMerchantPaymentProviderId?.toLowerCase());
//       }
//     }

//     loading = false;
//     notify;
//   }

//   Future<void> deleteData({required List<SRDatum> dataList}) async {
//     final status = await Handler.deleteEftPosDevice(dataList: dataList);
//     if (status != null && status) {
//       for (var e in dataList) {
//         tableList.tableDataList.removeWhere((f) => e.id == f.id);
//       }
//       notifyListeners();
//     }
//   }

//   Future<void> pair({
//     required BuildContext context,
//     EftPosData? data,
//     // String eftUrl = "${Strings.eftposPay}hasPairing",
//   }) async {
//     if (data == null) return;

//     final _eftPosUrl =
//         "${AppEnviro.eftposPay}pair-terminal-mx51?acquirerCode=${data.merchantPaymentProviderIdentifier}&serialNumber=${data.serialNumber}&posId=${data.eftposTerminalName}";

//     final size = Ssize(context);
//     await showDialog(
//         context: context,
//         builder: (builder) => SimpleDialog(
//               backgroundColor: Colors.transparent,
//               elevation: 0,
//               titlePadding: EdgeInsets.zero,
//               contentPadding: EdgeInsets.zero,
//               insetPadding: EdgeInsets.zero,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(0)),
//               children: [
//                 SizedBox(
//                   width: size.width,
//                   height: size.height,
//                   child: InAppWebViewScreen(
//                     webContent: WebContent(
//                       title: "EFTPOS Pairing",
//                       url: _eftPosUrl,
//                     ),
//                     onPageStart: ({webCltr}) async {
//                       if (webCltr == null) return;
//                       final _uri = await webCltr.getUrl();

//                       final _parameter = _uri?.queryParameters;

//                       // log("page start $url");
//                       // final _eftPosUrl =
//                       //     "${Strings.eftposPay}pair-terminal-mx51?acquirerCode=${data.merchantPaymentProviderIdentifier}&serialNumber=${data.serialNumber}&posId=${data.eftposTerminalName}";

//                       if (_parameter?['isWebClosed'] == 'true' ||
//                           _parameter?['isPaired'] == 'true') {
//                         Navigator.pop(context);
//                       }
//                       // else if (url.contains("hasPairing=false")) {
//                       //   await webCltr.clearCache();
//                       //   await webCltr.loadUrl(_eftPosUrl);
//                       // } else if (url.contains("hasPairing=true")) {
//                       //   await webCltr.loadUrl(_eftPosUrl);
//                       // }
//                     },
//                   ),
//                 )
//               ],
//             ));
//   }

//   void clear() {
//     itemId = "";
//     _merchantIndex = null;
//     _merchantProviderIndex = null;
//     tableIndex = null;
//     for (var e in tableData) {
//       e.tableCltr.clear();
//     }
//   }
// }
