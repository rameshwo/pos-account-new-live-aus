// import 'package:flutter/material.dart';
// import 'package:pos_account/constant/strings.dart';
// import 'package:pos_account/ln.dart';
// import 'package:pos_account/providers/cus_val_pro.dart';
// import 'booking_tab/booking_tab.dart';
// import 'dashboard/dashboard.dart';
// import 'end_of_day_tab/end_of_day_tab.dart';
// import 'integration_tab/integration_tab.dart';
// import 'pos_tab/pos_tab_page.dart';
// import 'product_tab/product_tab.dart';
// import 'setting_tab/setting_tab.dart';
// import 'short_term_cash_flow_set/short_term_cash_flow_tab.dart';
// import 'sync_tab.dart';

// class TabWidget {
//   int? id;
//   Tab? tab;
//   Widget? widget;

//   TabWidget({this.id, this.tab, this.widget});

//  static List<TabWidget> get tabs {
//     final cvp = GlobalCVP;
//     return <TabWidget>[
//       if (cvp.viewWidget.viewDashBoardModule))
//         TabWidget(
//             id: 0,
//             tab: Tab(
//               child: Text(LN.dashboard),
//             ),
//             widget: Dashboard()),
//       if (cvp.viewWidget("ViewPOSModule"))
//         TabWidget(
//             id: 1,
//             tab: Tab(
//               child: Text(LN.pos),
//             ),
//             widget: PosTabPage()),
//       if (cvp.viewWidget("ViewProductModule"))
//         TabWidget(
//             id: 2,
//             tab: Tab(
//               child: Text(LN.productsTab),
//             ),
//             widget: ProductTab()),
//       if (cvp.viewWidget("ViewSyncModule"))
//         TabWidget(
//             id: 3,
//             tab: Tab(
//               child: Text(LN.sync),
//             ),
//             widget: SyncTab()),
//       TabWidget(
//           id: 4,
//           tab: Tab(
//             child: Text(LN.eod),
//           ),
//           widget: EndOfDayTab()),
//       if (cvp.viewWidget("ViewTableBookingModule"))
//         TabWidget(
//             id: 5,
//             tab: Tab(
//               child: Text(LN.booking),
//             ),
//             widget: BookingTab()),
//       if (cvp.viewWidget("ViewSettingsModule"))
//         TabWidget(
//             id: 6,
//             tab: Tab(
//               child: Text(LN.settings),
//             ),
//             widget: SettingTab()),
//       TabWidget(
//           id: 7,
//           tab: Tab(
//             child: Text(LN.integration),
//           ),
//           widget: IntegrationTab()),
//       TabWidget(
//           id: 8,
//           tab: Tab(
//             child: Text(LN.shortTCashFlow),
//           ),
//           widget: ShortTermCashFlow()),
//     ];
//   }
// }
