import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/setting/table_layout/layout_design_model.dart';
import 'package:pos_account/providers/booking/table_arrange_pro.dart';
import 'package:pos_account/providers/booking/table_resv_pro.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/menu/place_order_pro.dart';
import 'package:pos_account/providers/menu/pos_retail_pro.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/floor_tab/booking_tab/booking_tab.dart';
import 'package:pos_account/widgets/dialog/msg_dialog.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:provider/provider.dart';
import 'com/add_cus_send_kitchen.dart';
import 'com/order_items.dart';

class SideBarSection extends StatelessWidget {
  final Future Function()? placeOrder;
  final PlaceOrderPro placeOrderPro;
  final GlobalKey<ScaffoldState>? scafKey;
  const SideBarSection({
    super.key,
    this.placeOrder,
    required this.placeOrderPro,
    this.scafKey,
  });

  static Future<bool?> addCustomer(
    BuildContext ctx, {
    bool isFromFloor = false,
  }) async {
    final val = await showDialog(
        context: ctx,
        builder: (builder) => SimpleDialog(
              // backgroundColor: kPrimaryColor,
              titlePadding: EdgeInsets.zero,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              children: [
                AddCusOnSentToKit(
                  isFromFloor: isFromFloor,
                )
              ],
            ));
    if (val != null && val is bool) {
      return val;
    }
    return null;
  }

  void _placeOrder(bool isSentToKt, {required BuildContext context}) async {
    final _isMandatory =
        (placeOrderPro.initAddSec?.orderTypes?.isNotEmpty ?? false) &&
            (placeOrderPro.initAddSec!.orderTypes!.length >
                placeOrderPro.orderTypeIndex) &&
            (placeOrderPro.initAddSec?.orderTypes?[placeOrderPro.orderTypeIndex]
                    .enableCustomerPopUpScreen ??
                false);

    if (context.mounted) {
      if (!GlobalCVP.isRetailStore &&
              GlobalCVP.isHospitality &&
              placeOrderPro.isDine &&
              (placeOrderPro.tableIdName == null ||
                  placeOrderPro.tableIdName!.isEmpty) &&
              (placeOrderPro.orderTabId == null ||
                  placeOrderPro.orderTabId!.isEmpty)
          // placeOrderPro.tableIndex == null
          ) {
        MsgDia.show(
          context,
          headerAnimation: false,
          diaType: DiaType.warning,
          title: LN.tableNotSelected,
          autoHideSecond: 1,
        );
        return;
      } else if (placeOrderPro.isPickUp &&
          placeOrderPro.cusNameCltr.text.isEmpty &&
          _isMandatory) {
        MsgDia.show(
          context,
          headerAnimation: false,
          diaType: DiaType.warning,
          title: "Please enter customer name",
          autoHideSecond: 1,
        );
        return;
      }

      if (placeOrderPro.isDelivery &&
          _isMandatory &&
          (placeOrderPro.cusNameCltr.text.isEmpty ||
              placeOrderPro.cusPhoneCltr.text.isEmpty ||
              placeOrderPro.selectedCusDeliveryIndex == null)) {
        MsgDia.show(
          context,
          headerAnimation: false,
          diaType: DiaType.warning,
          title: "Please enter customer details",
          autoHideSecond: 1,
        );
        return;
      }
    }

    if (isSentToKt)
      placeOrderPro.loadStKtBtn = true;
    else
      placeOrderPro.loadPlaceOr = true;
    placeOrderPro.notify;

    if (GlobalCVP.isHospitality &&
        placeOrderPro.isDine &&
        placeOrderPro.reOrder == null &&
        (placeOrderPro.tableIdName?.isNotEmpty ?? false)) {
      final _status = await placeOrderPro.checkTableStatus(
          tableId: placeOrderPro.tableIdName?.last.id);
      if (!_status) {
        placeOrderPro.loadStKtBtn = false;
        placeOrderPro.loadPlaceOr = false;
        placeOrderPro.notify;
        return;
      }
    }

    final _status = await placeOrderPro.onPlaceOrder(
      context,
      isSentToKt: isSentToKt,
      cusName: placeOrderPro.cusNameCltr.text,
    );

    // if (placeOrderPro.placeOrderRes != null &&
    //     placeOrder != null &&
    //     (_status ?? false)) {
    //   placeOrder!();
    // }

    if ( //!isSentToKt &&  // TODO: DONOT GO TO PAY SCREEN
        (_status ?? false)) {
      await placeOrder!();
      //

      // if (context.mounted) {
      //   final _orderPro = Provider.of<OrderPro>(context, listen: false);
      //   _orderPro.getData();
      // }
      GlobalCVP.pathOfPOS = PathOfPOS.Init;
    }

    await Future.delayed(Duration(milliseconds: 1000));

    if (_status ?? false) {
      placeOrderPro.clearCusData();
      // TODO: DONOT GO TO PAY SCREEN
      // placeOrderPro.reOrder = null;
      // placeOrderPro.clear();
    }

    placeOrderPro.loadStKtBtn = false;
    placeOrderPro.loadPlaceOr = false;

    placeOrderPro.notify;
  }

  // static Future<void> showNoOfCus(
  //   BuildContext context, {
  //   required PlaceOrderPro placeOrderPro,
  // }) async {
  //   final size = Ssize(context);
  //   await showDialog(
  //       context: context,
  //       builder: (builder) => SimpleDialog(
  //             titlePadding: EdgeInsets.zero,
  //             contentPadding: EdgeInsets.symmetric(
  //                 horizontal: size.getW(24), vertical: size.getH(24)),
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(15)),
  //             children: [
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Text(
  //                     "No. of Customers",
  //                     style: TextStyle(
  //                       fontSize: size.getS(18),
  //                       fontWeight: FontWeight.bold,
  //                       color: Colors.black,
  //                     ),
  //                   ),
  //                   InkWell(
  //                       onTap: () {
  //                         Navigator.pop(context);
  //                       },
  //                       child: Icon(Icons.close))
  //                 ],
  //               ),
  //               SizedBox(
  //                 height: size.getH(32),
  //               ),
  //               TextFormWidget(
  //                 isReq: false,
  //                 hintText: "0",
  //                 cltr: placeOrderPro.noOfCustomer,
  //                 textInputType: TextInputType.number,
  //                 inputFormatters: [NonNegativeTextInputFormatter()],
  //               ),
  //               SizedBox(
  //                 height: size.getH(24),
  //               ),
  //               Row(
  //                 children: [
  //                   Expanded(
  //                     child: LoadButton(
  //                       btnColor: Colors.red,
  //                       btnText: "Clear",
  //                       hPad: 12,
  //                       vPad: 8,
  //                       onsave: () {
  //                         placeOrderPro.noOfCustomer.clear();
  //                         placeOrderPro.notify;
  //                       },
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     width: size.getW(8),
  //                   ),
  //                   Expanded(
  //                     child: LoadButton(
  //                       btnText: "Confirm",
  //                       hPad: 12,
  //                       vPad: 8,
  //                       onsave: () {
  //                         Navigator.pop(context);
  //                       },
  //                     ),
  //                   ),
  //                 ],
  //               )
  //             ],
  //           ));
  // }

  // static Future<void> showOrderType(BuildContext context) async {
  //   final size = Ssize(context);
  //   await showDialog(
  //       context: context,
  //       builder: (builder) {
  //         final placeOrderPro = Provider.of<PlaceOrderPro>(builder);
  //         return SimpleDialog(
  //           titlePadding: EdgeInsets.zero,
  //           contentPadding: EdgeInsets.symmetric(
  //               horizontal: size.getW(24), vertical: size.getH(24)),
  //           shape:
  //               RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
  //           children: [
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Text(
  //                   "Choose Order Type",
  //                   style: TextStyle(
  //                     fontSize: size.getS(18),
  //                     fontWeight: FontWeight.bold,
  //                     color: Colors.black,
  //                   ),
  //                 ),
  //                 InkWell(
  //                     onTap: () {
  //                       Navigator.pop(context);
  //                     },
  //                     child: Icon(Icons.close))
  //               ],
  //             ),
  //             SizedBox(
  //               height: size.getH(32),
  //             ),
  //             Wrap(
  //               children: [
  //                 if (placeOrderPro.initAddSec?.orderTypes != null)
  //                   ...List.generate(
  //                       placeOrderPro.initAddSec!.orderTypes!.length,
  //                       (index) => Card(
  //                             color: (placeOrderPro.orderTypeIndex) == index
  //                                 ? (placeOrderPro.loading
  //                                     ? kPrimaryColor.withOpacity(0.5)
  //                                     : kPrimaryColor)
  //                                 : Colors.grey,
  //                             shape: RoundedRectangleBorder(
  //                                 borderRadius: BorderRadius.circular(15)),
  //                             margin: EdgeInsets.only(
  //                                 right: size.getW(16), bottom: size.getH(8)),
  //                             child: InkWell(
  //                               onTap: placeOrderPro.loading
  //                                   ? null
  //                                   : () {
  //                                       placeOrderPro.orderTypeIndex = index;
  //                                       placeOrderPro.loading = true;
  //                                       placeOrderPro.notify;
  //                                       placeOrderPro.getInitData();
  //                                     },
  //                               child: Padding(
  //                                 padding: EdgeInsets.symmetric(
  //                                     vertical: size.getH(8.0),
  //                                     horizontal: size.getW(16)),
  //                                 child: Text(
  //                                   placeOrderPro.initAddSec!.orderTypes![index]
  //                                           .value ??
  //                                       '',
  //                                   style: TextStyle(
  //                                     fontSize: size.getS(18),
  //                                     color: Colors.white,
  //                                     fontFamily: kFontFMedium,
  //                                     fontWeight: FontWeight.bold,
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                           )),
  //               ],
  //             ),
  //             SizedBox(
  //               height: size.getH(24),
  //             ),
  //             LoadButton(
  //               btnText: "Confirm",
  //               hPad: 12,
  //               vPad: 12,
  //               onsave: () {
  //                 Navigator.pop(context);
  //               },
  //             ),
  //           ],
  //         );
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final _isNoTable = !(placeOrderPro.tableIdName?.isNotEmpty ?? false);
    final _zeroCus = placeOrderPro.noOfCustomer.text.inDouble == 0;
    final _posRetailPro = Provider.of<PosRetailPro>(context);
    return Card(
      elevation: 4,
      color: Colors.white,
      shadowColor: Colors.grey[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: size.getH(2), horizontal: size.getW(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // if (!GlobalCVP.isRetailStore && !GlobalCVP.isRetailScreen) ...[
            Row(
              children: [
                if (!GlobalCVP.isServiceStore && !GlobalCVP.isRetailStore) ...[
                  Expanded(
                    child: LoadButton(
                      vPad: 8,
                      hPad: 4,
                      btnText: _isNoTable
                          ? LN.selectTable
                          : (placeOrderPro.tableIdName?.first.name ?? ''),
                      textColor: _isNoTable ? Colors.black : Colors.white,
                      btnColor: _isNoTable ? Colors.white : kTempColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: BorderSide(
                            color: _isNoTable ? Colors.black : kTempColor,
                          )),
                      onsave: () {
                        BookingTab.showTableLayoutDia(
                          context,
                          size: size,
                          selectedTableLayId: placeOrderPro.tableIdName,
                          scafKey: scafKey,
                          dialogFrom: DialogFrom.PosPage,
                        ).then((value) {
                          if (value != null && value is bool && value) {
                            // final _val = value;
                            placeOrderPro.tableIdName ??= [];

                            // if (!(placeOrderPro.tableIdName?.any((a) =>
                            //         a.id?.toLowerCase() ==
                            //         value.id?.toLowerCase()) ??
                            //     false)) {
                            //   placeOrderPro.tableIdName?.add(TableIdName(
                            //       id: _val.id,
                            //       name: _val.title,
                            //       orderId: _val.pElements.isNotEmpty &&
                            //               (_val.pElements.first.orderId
                            //                       ?.isNotEmpty ??
                            //                   false)
                            //           ? _val.pElements.first.orderId
                            //           : null,
                            //       mergeId: _val.pElements.isNotEmpty &&
                            //               (_val.pElements.first.mergeId
                            //                       ?.isNotEmpty ??
                            //                   false)
                            //           ? _val.pElements.first.mergeId
                            //           : null));
                            // }
                            // placeOrderPro.tableName = value.title ?? '';
                            //   placeOrderPro.tableId = value.id;

                            placeOrderPro.notify;
                            // final _tablePro = Provider.of<TableResvPro>(context,
                            //     listen: false);
                            // if (_tablePro.tableResvAddSec?.tables?.any((e) =>
                            //         e.id?.toLowerCase() ==
                            //         value.id?.toLowerCase()) ??
                            //     false) {
                            //   final _tableNa = _tablePro.tableResvAddSec?.tables
                            //       ?.firstWhere((e) =>
                            //           e.id?.toLowerCase() ==
                            //           value.id?.toLowerCase());

                            //   print(_tableNa?.value);

                            //   placeOrderPro.tableName =
                            //       _tableNa?.value ?? _tableNa?.name ?? '';
                            // }
                          } else {
                            final tableResv = Provider.of<TableResvPro>(context,
                                listen: false);
                            final taPro = Provider.of<TableArrangePro>(context,
                                listen: false);
                            if (!(taPro.editPData?.any((e) =>
                                    tableResv.tableIdName?.any((a) =>
                                        a.id?.toLowerCase() ==
                                        e.id?.toLowerCase()) ??
                                    false) ??
                                false)) {
                              placeOrderPro.tableIdName = null;
                              GlobalCVP.pathOfPOS = PathOfPOS.Init;

                              // placeOrderPro.tableId = null;
                              // placeOrderPro.tableName = "";
                              placeOrderPro.notify;
                            }
                          }
                        });
                      },
                    ),
                    //      TextFormWidget(
                    //   vPad: 12,
                    //   isReq: false,
                    //   readOnly: true,
                    //   hPad: 4,
                    //   borderRadius: 5,
                    //   hintText: LN.selectTable,
                    //   cltr: TextEditingController(
                    //     text: placeOrderPro.tableName,
                    //   ),
                    //   textStyle: TextStyle(
                    //     color: _isNoTable ? Colors.black : Colors.white,
                    //     fontWeight: FontWeight.bold,
                    //     fontSize: size.getS(14),
                    //   ),
                    //   hintStyle: TextStyle(
                    //     fontSize: size.getS(14),
                    //     color: _isNoTable ? Colors.black : Colors.white,
                    //   ),
                    //   textAlign: TextAlign.center,
                    //   fillColor: _isNoTable ? Colors.white : kTempColor,
                    //   borderColor: _isNoTable ? Colors.black87 : kTempColor,
                    //   onTap: () {

                    //   },
                    // )
                  ),
                  SizedBox(
                    width: size.getW(12),
                  )
                ],
                Expanded(
                  child: LoadButton(
                    btnText: ((placeOrderPro.cusNameCltr.text.isNotEmpty
                            ? placeOrderPro.cusNameCltr.text
                            : (_zeroCus ? 'Add Customer' : 'Customers')) +
                        (_zeroCus
                            ? ''
                            : '(${placeOrderPro.noOfCustomer.text})')),
                    btnColor: placeOrderPro.cusNameCltr.text.isNotEmpty
                        ? kTempColor
                        : Colors.white,
                    hPad: 4,
                    vPad: 8,
                    textColor: placeOrderPro.cusNameCltr.text.isNotEmpty
                        ? Colors.white
                        : Colors.black,
                    shape: placeOrderPro.cusNameCltr.text.isNotEmpty
                        ? null
                        : RoundedRectangleBorder(
                            side: BorderSide(color: Colors.black87),
                            borderRadius: BorderRadius.circular(5),
                          ),
                    onsave: () async {
                      await addCustomer(context);
                      // showNoOfCus(
                      //   context,
                      //   placeOrderPro: placeOrderPro,
                      // );
                    },
                  ),
                ),
              ],
            ),
            Divider(
              color: Colors.black87,
              thickness: 0.6,
              height: 10,
            ),
            SizedBox(height: size.getH(4)),

            // ],
            Flexible(
              child: KeyboardListener(
                focusNode: FocusNode(),
                autofocus: true,
                onKeyEvent: (event) {
                  if (event is KeyDownEvent) {
                    if (event.physicalKey == PhysicalKeyboardKey.f1) {
                      _placeOrder(true, context: context);
                    } else if (event.physicalKey == PhysicalKeyboardKey.f2) {
                      _placeOrder(false, context: context);
                    }
                  }
                },
                child: OrderItems(
                  onClickBtn: placeOrder == null ||
                          (placeOrderPro.orderList.isEmpty &&
                              placeOrderPro.setMenuList.isEmpty &&
                              placeOrderPro.ingreList.isEmpty)
                      ? null
                      : (bool isSentToKt) =>
                          _placeOrder(isSentToKt, context: context),
                  placeOrderPro: placeOrderPro,
                  posRetailPro: _posRetailPro,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
