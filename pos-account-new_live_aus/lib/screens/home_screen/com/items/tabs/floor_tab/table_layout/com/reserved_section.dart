import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/constant/text_formatter.dart';
import 'package:pos_account/model/home/booking/all_customer.dart';
import 'package:pos_account/model/home/setting/table_layout/layout_design_model.dart';
import 'package:pos_account/providers/booking/table_arrange_pro.dart';
import 'package:pos_account/providers/menu/place_order_pro.dart';
import 'package:pos_account/screens/home_screen/com/dialogs/cus_list_dia.dart';
import 'package:pos_account/screens/home_screen/com/items/com/price_update_dia.dart';
import 'package:pos_account/screens/home_screen/com/items/sidebar/sidebar_section/sidebar_section.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:pos_account/widgets/load_btn.dart';
import '../../../../../../../../ln.dart';
import 'order_detail_floor.dart';

enum PopUpAction {
  Reserve,
  PlaceOrder,
  ViewOrder,
  Pay,
  UpdateOrder,
  MakeItFree,
  Occupy,
  ViewCalender,
  SwitchTable,
  MergeTable,
}

class ReservationAction {
  final String title;
  final Color backColor;
  final PopUpAction popUpAction;
  final bool buttonLoad;
  final String? buttonLoadText;

  ReservationAction({
    required this.title,
    this.backColor = kSecondaryColor,
    required this.popUpAction,
    this.buttonLoad = false,
    this.buttonLoadText,
  });
}

class ReservedSection extends StatelessWidget {
  final List<PData>? pData;
  final DialogFrom? isDialog;
  final PlaceOrderPro placeOrderPro;
  final TableArrangePro taPro;
  final Function(PopUpAction action, PDataElements? pDataElements)? onTapAction;
  // final bool showReservation;
  const ReservedSection({
    super.key,
    this.pData,
    this.isDialog,
    this.onTapAction,
    required this.placeOrderPro,
    required this.taPro,
    // this.showReservation = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final _pData = pData?.first;

    final hasNoOrder = _pData == null ||
        _pData.pElements.isEmpty ||
        _pData.pElements.first.orderId == null ||
        _pData.pElements.first.orderId!.isEmpty;

    final List<ReservationAction>? _newActionButton = (_pData
                ?.pElements.isNotEmpty ??
            false)
        ? (isDialog == DialogFrom.BookingPage ||
                (isDialog == DialogFrom.PosPage &&
                    _pData?.pElements.first.status != FloorTblStatus.Occupied)
            ? [
                ReservationAction(
                  title: LN.selectTable,
                  backColor: Colors.blue.shade600,
                  popUpAction: PopUpAction.Reserve,
                )
              ]
            : isDialog == null &&
                    _pData?.pElements.first.status == FloorTblStatus.Occupied
                    //
                    &&
                    hasNoOrder
                ? [
                    if (hasNoOrder)
                      ReservationAction(
                        title: LN.makeFree,
                        backColor: Colors.green,
                        popUpAction: PopUpAction.MakeItFree,
                        buttonLoad: taPro.makeItFreeBtnLoad,
                      ),
                    ReservationAction(
                      title: hasNoOrder ? LN.placeOrder : LN.placeNewOrder,
                      backColor: kSecondaryColor,
                      popUpAction: PopUpAction.PlaceOrder,
                    ),
                  ]
                : null)
        : null;

    final List<String> mergeOrderIdCount = [];

    if (pData != null)
      for (final a in pData!) {
        for (final b in a.pElements) {
          final id = b.orderId;

          if (id != null && !(mergeOrderIdCount.contains(id))) {
            mergeOrderIdCount.add(id);
          }
        }
      }

    final _showMergeTable = (pData?.isNotEmpty ?? false) &&
        (!(pData?.every((a) =>
                    a.pElements.isNotEmpty &&
                    a.pElements.first.mergeId ==
                        _pData!.pElements.first.mergeId) ??
                false) ||
            (pData!.length > 1 &&
                ((pData?.any((a) => a.pElements.isNotEmpty && a.pElements.first.status == FloorTblStatus.Available) ??
                        false) ||
                    (pData?.every((a) =>
                            a.pElements.isNotEmpty &&
                            (a.pElements.first.status ==
                                    FloorTblStatus.Occupied &&
                                (a.pElements.first.orderId == null ||
                                    a.pElements.first.orderId!.isEmpty) &&
                                (a.pElements.first.mergeId == null ||
                                    a.pElements.first.mergeId!.isEmpty))) ??
                        false))) ||
            mergeOrderIdCount.length > 1);

    final _mergeTableAct = _showMergeTable
        ? ReservationAction(
            title: // mergeOrderIdCount.length > 1 ? "Merge Order" :
                "Merge Table",
            backColor: Colors.amber.shade900,
            popUpAction: PopUpAction.MergeTable,
          )
        : null;

    return Column(
      children: [
        Flexible(
          child: ListView(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            // mainAxisSize: MainAxisSize.max,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if ((_pData?.pElements.isNotEmpty ?? false) &&
                  // _pData?.pElements.first.status != FloorTblStatus.Occupied &&
                  (placeOrderPro.initAddSec?.orderTypes?.any((element) =>
                          element.additionalValue
                              .toString()
                              .toLowerCase()
                              .contains('dine')) ??
                      false))
                _orderType(
                  size,
                  isSelected: true,
                  title: placeOrderPro.initAddSec!.orderTypes!
                      .firstWhere((element) => element.additionalValue
                          .toString()
                          .toLowerCase()
                          .contains('dine'))
                      .name,
                )
              else if (_pData == null &&
                  (placeOrderPro.initAddSec?.orderTypes?.isNotEmpty ??
                      false)) ...[
                if (placeOrderPro.initAddSec!.orderTypes!.length < 4)
                  Row(
                    children: List.generate(
                        placeOrderPro.initAddSec!.orderTypes!.length,
                        (index) => placeOrderPro
                                .initAddSec!.orderTypes![index].additionalValue
                                .toString()
                                .toLowerCase()
                                .contains('dine')
                            ? SizedBox.shrink()
                            : Expanded(
                                child: _orderType(
                                size,
                                isSelected:
                                    placeOrderPro.orderTypeIndex == index,
                                title: placeOrderPro
                                    .initAddSec!.orderTypes![index].name,
                                onTap: () {
                                  placeOrderPro.orderTypeIndex = index;
                                  placeOrderPro.notify;
                                  placeOrderPro.getInitData();
                                },
                              ))),
                  )
                else
                  Wrap(
                    children: List.generate(
                        placeOrderPro.initAddSec!.orderTypes!.length,
                        (index) => _orderType(
                              size,
                              isSelected: placeOrderPro.orderTypeIndex == index,
                              title: placeOrderPro
                                  .initAddSec!.orderTypes![index].name,
                              onTap: () {
                                placeOrderPro.orderTypeIndex = index;
                                placeOrderPro.notify;
                                placeOrderPro.getInitData();
                              },
                            )),
                  )
              ],

              if (_pData == null ||
                  (_pData.pElements.isNotEmpty &&
                      _pData.pElements.first.status !=
                          FloorTblStatus.Occupied)) ...[
                SizedBox(height: size.getH(8)),
                if (placeOrderPro.isDine)
                  SizedBox(
                    width: size.getW(100),
                    child: TitleTextForm(
                      isReq: false,
                      title: "No. of Customers",
                      hintText: "0",
                      pWidth: 0.24,
                      borderColor: Colors.black26,
                      textCltr: placeOrderPro.noOfCustomer,
                      textInputType: TextInputType.number,
                      inputFormatters: [NonNegativeTextInputFormatter()],
                      readOnly: true,
                      onTap: () {
                        PriceUpdateDia.showDia<int>(
                          context,
                          title: LN.noOfCustomers,
                          number: placeOrderPro.noOfCustomer.text.inDouble,
                          max: 1000,
                        ).then((value) {
                          placeOrderPro.noOfCustomer.text = value.formatDouble;
                          placeOrderPro.notify;
                        });
                      },
                    ),
                  ),
                SizedBox(height: size.getH(12)),
                if (placeOrderPro.isDelivery)
                  SizedBox(
                    width: size.getW(100),
                    child: TitleTextForm(
                      pWidth: 0.5,
                      isReq: placeOrderPro.isDelivery,
                      title: LN.cusName,
                      readOnly: true,
                      hintText: '',
                      textCltr: placeOrderPro.cusNameCltr,
                      borderColor: Colors.black26,
                      onTap: () {
                        SideBarSection.addCustomer(context, isFromFloor: true);
                      },
                      suffix: InkWell(
                        onTap: () {
                          SideBarSection.addCustomer(context,
                              isFromFloor: true);
                        },
                        child: Container(
                          // margin: EdgeInsets.only(left: size.getW(8)),
                          decoration: BoxDecoration(
                            color: kSecondaryColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: size.getH(4),
                              horizontal: size.getW(12)),
                          child: Text("+ ${LN.add}",
                              style: TextStyle(
                                fontSize: size.getS(15),
                                fontFamily: kFontFMedium,
                                color: Colors.white,
                              )),
                        ),
                      ),
                    ),
                  )
                else
                  SizedBox(
                    width: size.getW(100),
                    child: TitleTextForm(
                      pWidth: 0.5,
                      isReq: placeOrderPro.isPickUp,
                      title: LN.cusName,
                      textCltr: placeOrderPro.cusNameCltr,
                      borderColor: Colors.black26,
                      suffix: InkWell(
                        onTap: () {
                          SideBarSection.addCustomer(context,
                              isFromFloor: true);
                        },
                        child: Container(
                          // margin: EdgeInsets.only(left: size.getW(8)),
                          decoration: BoxDecoration(
                            color: kSecondaryColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: size.getH(4),
                              horizontal: size.getW(12)),
                          child: Text("+ ${LN.add}",
                              style: TextStyle(
                                fontSize: size.getS(15),
                                fontFamily: kFontFMedium,
                                color: Colors.white,
                              )),
                        ),
                      ),
                      prefix: InkWell(
                        onTap: () => CustomerList.show(context).then((value) {
                          if (value != null && value is CusData) {
                            final _val = value;
                            placeOrderPro.clearCusData(clearNoCus: false);
                            placeOrderPro.setCustomerData(_val);
                            placeOrderPro.getCusDeliveryAddress(
                                id: _val.id, name: _val.name);
                          }
                        }),
                        child: Padding(
                          padding: EdgeInsets.only(left: size.getW(8)),
                          child: Icon(
                            Icons.search,
                            size: size.getS(24),
                          ),
                        ),
                      ),
                    ),
                  ),
                SizedBox(height: size.getH(12))
              ],
              // ],
              if (pData != null &&
                  (_pData?.title?.isNotEmpty ?? false) &&
                  (_pData?.pElements.isNotEmpty ?? false)) ...[
                if (pData!.length > 1)
                  Text("Selected Tables",
                      style: TextStyle(
                        fontSize: size.getS(18),
                        decoration: TextDecoration.underline,
                      )),
                ...List.generate(pData!.length, (index) {
                  return ReservedDataSection(
                      isBold: true,
                      title: (pData![index].title ?? ''),
                      textSpan: TextSpan(
                        text: ' (${pData![index].pElements.first.status.name})',
                        style: TextStyle(
                          fontSize: size.getS(16),
                          color: pData![index].pElements.first.statusColor,
                        ),
                      ),
                      subTitle: pData![index].pElements.first.cusName);
                }),
                // ReservedDataSection(
                //     isBold: true,
                //     title: (_pData?.title ?? ''),
                //     textSpan: TextSpan(
                //       text: ' (${_pData?.pElements.first.status.name ?? ''})',
                //       style: TextStyle(
                //         fontSize: size.getS(16),
                //         color: _pData?.pElements.first.statusColor,
                //       ),
                //     ),
                //     subTitle: _pData?.pElements.first.cusName),
                // if (_pData?.adult?.isNotEmpty ?? false)
                //   ReservedDataSection(title: LN.adultCap, subTitle: _pData?.adult),
                // if (_pData?.child?.isNotEmpty ?? false)
                //   ReservedDataSection(
                //       title: LN.childCapacity, subTitle: _pData?.child),
                // if (_pData!.pElements.isNotEmpty //&& showReservation
                // // && _pData.pElements.first.status == FloorTblStatus.Reserved
                // )
                //   Row(
                //     mainAxisAlignment: MainAxisAlignment.end,
                //     children: [
                //       if (isDialog == null || isDialog == DialogFrom.BookingPage)
                //         InkWell(
                //           onTap: () => onTapAction!(
                //               PopUpAction.ViewCalender, _pData.pElements.first),
                //           child: Text(
                //             LN.viewReserve,
                //             style: TextStyle(
                //                 fontSize: size.getS(16),
                //                 color: Colors.blue,
                //                 decoration: TextDecoration.underline),
                //           ),
                //         ),
                //     ],
                //   ),
              ],
              if (_pData?.pElements != null && _pData!.pElements.isNotEmpty)
                // ...List.generate(
                //     _pData.pElements.length,
                //     (index) =>
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ReservedDataSection(
                            title: _pData.pElements[0].reservedType,
                            isBold: true,
                          ),
                        ),
                        // Expanded(
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.end,
                        //     children: [
                        //       if (isDialog == null ||
                        //           isDialog == DialogFrom.BookingPage)
                        //         InkWell(
                        //           onTap: () => onTapAction!(
                        //               PopUpAction.ViewCalender,
                        //               _pData.pElements.first),
                        //           child: Text(
                        //             LN.viewReserve,
                        //             style: TextStyle(
                        //                 fontSize: size.getS(16),
                        //                 color: Colors.blue,
                        //                 decoration: TextDecoration.underline),
                        //           ),
                        //         ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                    // Divider(
                    //   thickness: 1.5,
                    //   color: Colors.black45,
                    //   height: 24,
                    // ),
                    if (_pData.pElements[0].orderNo?.isNotEmpty ?? false)
                      ReservedDataSection(
                        title: "Order No.",
                        subTitle: _pData.pElements[0].orderNo,
                      ),
                    if (_pData.pElements[0].status !=
                        FloorTblStatus.Available) ...[
                      // if (_pData.pElements[index].reservedType?.isNotEmpty ??
                      //     false)
                      //   ReservedDataSection(
                      //       title: LN.reseravtionType,
                      //       subTitle: _pData.pElements[index].reservedType),
                      // if (_pData.pElements[index].cusName?.isNotEmpty ??
                      //     false)
                      //   ReservedDataSection(
                      //       title: LN.cusName,
                      //       subTitle: _pData.pElements[index].cusName)
                    ],
                    if ((_pData.pElements[0].status ==
                                FloorTblStatus.Occupied ||
                            _pData.pElements[0].status ==
                                FloorTblStatus.Reserved) &&
                        (_pData.pElements[0].amount?.isNotEmpty ?? false) &&
                        (_pData.pElements[0].orderId?.isNotEmpty ?? false))
                      ReservedDataSection(
                          title: LN.amount,
                          subTitle: _pData.pElements[0].amount),
                    // if (_pData.pElements[0].reservedTime != null &&
                    //     _pData.pElements[0].reservedTime! > 0 &&
                    //     (_pData.pElements[0].status ==
                    //             FloorTblStatus.Occupied ||
                    //         _pData.pElements[0].status ==
                    //             FloorTblStatus.Reserved))
                    //   ReserveTimerSection(
                    //     reservedTime: _pData.pElements[0].reservedTime,
                    //   ),
                    // SizedBox(height: size.getH(8)),
                    if (_pData.pElements[0].orderId?.isNotEmpty ?? false) ...[
                      Divider(
                        thickness: 1.5,
                        color: Colors.black45,
                        height: 24,
                      ),
                      FloorOrderDetail(),
                    ],
                    //

                    // ...List.generate(
                    //     10,
                    //     (index) => Container(
                    //           margin: EdgeInsets.all(10),
                    //           height: 100,
                    //           width: 300,
                    //           color: Colors.orange,
                    //         )),
                  ],
                ),
              // ),
              if (_newActionButton != null)
                Row(
                  children: List.generate(
                      _newActionButton.length,
                      (i) => Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: i == 0 ? 0 : 2,
                                  right:
                                      _newActionButton.length - 1 == i ? 0 : 2),
                              child: LoadButton(
                                vPad: 4,
                                hPad: 0,
                                btnText: _newActionButton[i].title,
                                btnColor: _newActionButton[i].backColor,
                                onsave: onTapAction == null
                                    ? null
                                    : () => onTapAction!(
                                        _newActionButton[i].popUpAction,
                                        _pData?.pElements.first),
                                fontSize: 14,
                              ),
                            ),
                          )),
                ),
            ],
          ),
        ),
        Builder(builder: (context) {
          final List<ReservationAction> _action = _pData != null &&
                  _pData.pElements.isNotEmpty
              ? (isDialog != null
                  ? []
                  : _pData.pElements[0].status == FloorTblStatus.Available
                      ? [
                          // ReservationAction(
                          //   title: LN.reserve,
                          //   backColor: Colors.amber.shade900,
                          //   popUpAction: PopUpAction.Reserve,
                          // ),
                          if (pData?.length == 1)
                            ReservationAction(
                              title: LN.occupy,
                              backColor: Colors.red.shade700,
                              popUpAction: PopUpAction.Occupy,
                              buttonLoad: taPro.occupyBtnLoad,
                              buttonLoadText: "Occupying",
                            ),
                          ReservationAction(
                            title: LN.placeOrder,
                            backColor: kSecondaryColor,
                            popUpAction: PopUpAction.PlaceOrder,
                          ),
                        ]
                      : _pData.pElements[0].status == FloorTblStatus.Reserved
                          ? [
                              if (_pData.pElements[0].status ==
                                  FloorTblStatus.Reserved)
                                ReservationAction(
                                  title: LN.makeFree,
                                  backColor: Colors.green,
                                  popUpAction: PopUpAction.MakeItFree,
                                  buttonLoad: taPro.makeItFreeBtnLoad,
                                ),
                              ReservationAction(
                                title: LN.placeOrder,
                                backColor: kSecondaryColor,
                                popUpAction: PopUpAction.PlaceOrder,
                              ),
                            ]
                          : (_pData.pElements[0].orderId == null ||
                                  _pData.pElements[0].orderId!.isEmpty ||
                                  _mergeTableAct != null
                              ? []
                              : [
                                  ReservationAction(
                                    title: LN.viewOrder,
                                    backColor: kPrimaryColor,
                                    popUpAction: PopUpAction.ViewOrder,
                                  ),
                                  ReservationAction(
                                    title: LN.pay,
                                    backColor: Colors.green,
                                    popUpAction: PopUpAction.Pay,
                                  ),
                                  ReservationAction(
                                    title: LN.updateOrder,
                                    backColor: kSecondaryColor,
                                    popUpAction: PopUpAction.UpdateOrder,
                                  ),
                                  if (pData?.length == 1)
                                    ReservationAction(
                                      title: "Switch Table",
                                      backColor: Colors.amber.shade900,
                                      popUpAction: PopUpAction.SwitchTable,
                                    ),
                                  // else
                                  ReservationAction(
                                    title: LN.makeFree,
                                    backColor: Colors.green.shade400,
                                    popUpAction: PopUpAction.MakeItFree,
                                    buttonLoad: taPro.makeItFreeBtnLoad,
                                  )
                                ]))
              : [
                  ReservationAction(
                    title: LN.placeOrder,
                    backColor: kSecondaryColor,
                    popUpAction: PopUpAction.PlaceOrder,
                  )
                ];
          return Column(
            children: [
              Row(
                children:
                    List.generate(_action.length > 3 ? 3 : _action.length, (i) {
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: i == 0 ? 0 : 2,
                          right: _action.length - 1 == i ? 0 : 2),
                      child: LoadButton(
                        vPad: 8,
                        hPad: 0,
                        btnText: _action[i].title,
                        btnColor: _action[i].backColor,
                        loading: _action[i].buttonLoad,
                        loadingText: _action[i].buttonLoadText,
                        onsave: onTapAction != null
                            ? () => onTapAction!(
                                _action[i].popUpAction,
                                (_pData?.pElements.isNotEmpty ?? false)
                                    ? _pData?.pElements[0]
                                    : null)
                            : null,
                        fontSize: _action.length > 2 ? 14 : 16,
                      ),
                    ),
                  );
                }),
              ),
              if (_mergeTableAct != null)
                Padding(
                  padding: EdgeInsets.only(top: size.getH(4)),
                  child: Row(
                    children: [
                      if (mergeOrderIdCount.length > 1)
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(
                                top: size.getH(4), bottom: size.getH(4)),
                            padding: EdgeInsets.symmetric(
                                horizontal: size.getW(12),
                                vertical: size.getH(6)),
                            decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(40)),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info,
                                  size: size.getS(25),
                                  color: Colors.blue.shade700,
                                ),
                                SizedBox(width: size.getW(12)),
                                Expanded(
                                  child: Text(
                                    "Tables with different order can't be merged. Please select 'Available' Tables.",
                                    style: TextStyle(
                                      fontSize: size.getS(14),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue.shade700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        Expanded(
                          child: LoadButton(
                            vPad: 8,
                            hPad: 0,
                            btnText: _mergeTableAct.title,
                            btnColor: _mergeTableAct.backColor,
                            loading: taPro.mergeTableBtnLoad,
                            loadingText: "Merging",
                            onsave: onTapAction != null
                                ? () => onTapAction!(
                                    _mergeTableAct.popUpAction,
                                    (_pData?.pElements.isNotEmpty ?? false)
                                        ? _pData?.pElements[0]
                                        : null)
                                : null,
                            fontSize: 14,
                          ),
                        )
                    ],
                  ),
                )
              else if (_action.length > 3)
                Padding(
                  padding: EdgeInsets.only(top: size.getH(4)),
                  child: Row(
                    children: List.generate(_action.length - 3, (i) {
                      final _actionData = _action[i + 3];
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: i == 0 ? 0 : 2,
                              right: _action.length - 1 == i ? 0 : 2),
                          child: LoadButton(
                            vPad: 8,
                            hPad: 0,
                            btnText: _actionData.title,
                            btnColor: _actionData.backColor,
                            onsave: onTapAction == null
                                ? null
                                : () => onTapAction!(_actionData.popUpAction,
                                    _pData?.pElements[0]),
                            fontSize: 14,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
            ],
          );
        })
      ],
    );
  }

  Widget _orderType(
    Ssize size, {
    bool isSelected = false,
    Function()? onTap,
    String? title,
  }) {
    return Card(
      color: isSelected ? kPrimaryColor : Colors.grey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      margin: EdgeInsets.only(right: size.getW(6), bottom: size.getH(8)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: size.getH(6.0), horizontal: size.getW(4)),
          child: Text(
            title ?? '',
            style: TextStyle(
              fontSize: size.getS(16),
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.visible,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

// class ReserveTimerSection extends StatefulWidget {
//   final int? reservedTime;
//   const ReserveTimerSection({super.key, this.reservedTime});

//   @override
//   State<ReserveTimerSection> createState() => _ReserveTimerSectionState();
// }

// class _ReserveTimerSectionState extends State<ReserveTimerSection> {
//   void load() {
//     if (mounted) setState(() {});
//   }

//   Timer? _timer;

//   int hour = 0;
//   int minute = 0;
//   int second = 0;

//   void formatTime(int remainingSeconds) {
//     hour = remainingSeconds ~/ 3600;
//     minute = (remainingSeconds % 3600) ~/ 60;
//     second = remainingSeconds % 60;
//     load();
//   }

//   @override
//   void initState() {
//     setData();
//     super.initState();
//   }

//   void setData() {
//     final time = widget.reservedTime;
//     if (time == null || time < 1) return;

//     int remainingSecond = time * 60;

//     _timer = Timer.periodic(Duration(seconds: 1), (_) {
//       remainingSecond--;

//       if (remainingSecond < 1) {
//         _timer?.cancel();
//       } else {
//         formatTime(remainingSecond);
//       }
//     });
//   }

//   @override
//   void dispose() {
//     // widget.pData?.reservedTime = (hour * 60 + minute + second / 60).round();
//     _timer?.cancel();
//     super.dispose();
//   }

//   String _getTime(int time) {
//     if (time > 9)
//       return "$time";
//     else
//       return "0$time";
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.max,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         ReservedDataSection(
//           title: LN.reservedIn,
//           subTitle: second != 0 || minute != 0 || hour != 0
//               ? "${_getTime(hour)}:${_getTime(minute)}:${_getTime(second)}"
//               : "${LN.loading} ...",
//         ),
//         Divider(
//           thickness: 1,
//           color: Colors.black26,
//           height: 8,
//         ),
//         if (second != 0 || minute != 0 || hour != 0)
//           ReservedDataSection(
//               title:
//                   '${LN.tableAvailable} ${hour < 1 ? '' : '$hour ${hour > 1 ? LN.hours : LN.hour}'} $minute ${minute > 1 ? LN.minutes : LN.minute}'),
//       ],
//     );
//   }
// }

class ReservedDataSection extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final bool isBold;
  final bool isStatus;
  final Color? statusColor;
  final TextSpan? textSpan;
  const ReservedDataSection({
    super.key,
    this.title,
    this.subTitle,
    this.statusColor,
    this.isBold = false,
    this.isStatus = false,
    this.textSpan,
  });

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (title != null)
          Expanded(
            flex: 13,
            child: Text.rich(
              TextSpan(
                  text: title ?? '',
                  children: [if (textSpan != null) textSpan!]),
              style: TextStyle(
                fontSize: size.getS(isBold ? 18 : 16),
                fontWeight: isBold ? FontWeight.bold : null,
              ),
            ),
          ),
        if (subTitle != null)
          Expanded(
            flex: 12,
            child: isStatus
                ? Align(
                    alignment: title == null
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: Container(
                      margin: EdgeInsets.only(
                          top: size.getH(4), bottom: size.getH(4)),
                      padding: EdgeInsets.symmetric(
                          horizontal: size.getW(12), vertical: size.getH(6)),
                      decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        subTitle!,
                        style: TextStyle(
                          fontSize: size.getS(14),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : Text(
                    subTitle!,
                    style: TextStyle(
                      fontSize: size.getS(isBold ? 18 : 17),
                      fontWeight: FontWeight.bold,
                      fontFamily: isBold ? kFontFBold : null,
                    ),
                    textAlign: TextAlign.right,
                  ),
          )
      ],
    );
  }
}
