import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/ui_model/payment_history.dart';
import 'package:pos_account/providers/booking/table_resv_pro.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/screens/home_screen/com/show_status.dart';
import 'package:pos_account/widgets/dialog/confirm_dialog.dart';
import '../../booking_tab.dart';

class TableResvDetail extends StatelessWidget {
  final Ssize size;
  final TableResvPro tableResv;
  const TableResvDetail(
      {super.key, required this.size, required this.tableResv});

  onClickBtn(int btnId, String? resvId, BuildContext context) {
    if (resvId == null || tableResv.loadiing) return;

    if (btnId == 2) {
      tableResv.initDateSetup();
      tableResv
          .editReservation(id: resvId)
          .then((_) => BookingTab.showBookingDia(context, size: size));
    } else if (btnId == 4) {
      tableResv.arriveBooking(id: resvId);
    } else {
      var rsvType = _RsrvType.confirm;
      String title = "";
      String subtitle = "";

      if (btnId == 1) {
        rsvType = _RsrvType.cancel;
        title = LN.cancel;
        subtitle = LN.areYouSureCancel;
      } else if (btnId == 3) {
        rsvType = _RsrvType.confirm;
        title = LN.confirm;
        subtitle = LN.areYouSureOk;
      }

      showDialog(
          context: context,
          builder: (builder) => ConfirmDialog(
                title: title,
                subTitle: subtitle,
                actionText: LN.yes,
                cancelText: LN.no,
                onDelete: () async {
                  if (btnId == 1) {
                    tableResv.cancelBooking(type: rsvType.name, id: resvId);
                  } else {
                    tableResv.confirmTabRes(type: rsvType.name, id: resvId);
                  }
                  return null;
                },
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: size.getW(12),
          runSpacing: size.getH(24),
          children: [
            ...List.generate(tableResv.bookingList.length, (i) {
              final _data = tableResv.bookingList[i];
              final orderData = <PayHistory>[
                // PayHistory(
                //     title: LN.reserveNo,
                //     subtitle: _data.reservationNumber ?? ""),
                PayHistory(
                    title: LN.cusName, subtitle: _data.customerName ?? ""),
                if (_data.tableName?.isNotEmpty ?? false)
                  PayHistory(
                      title: LN.tableName, subtitle: _data.tableName ?? ''),
                PayHistory(title: LN.channel, subtitle: _data.channel ?? ''),
                if (_data.occasion?.isNotEmpty ?? false)
                  PayHistory(
                      title: LN.occasion, subtitle: _data.occasion ?? ''),
                PayHistory(
                    title: LN.dateTime, subtitle: _data.dateTimeFrom ?? ""),
                // PayHistory(
                //     title: LN.dateTimeTo, subtitle: _data.dateTimeTo ?? ''),
                PayHistory(title: LN.status, subtitle: _data.status ?? ""),
                PayHistory(title: LN.adult, subtitle: _data.adult ?? ''),
                PayHistory(title: LN.child, subtitle: _data.child ?? ''),
                // PayHistory(
                //     title: LN.total,
                //     subtitle:
                //         _data.total == null ? '' : _data.total.toString())
              ];
              return Container(
                width: size.getW(372),
                padding: EdgeInsets.symmetric(
                    horizontal: size.getW(12), vertical: size.getH(12)),
                decoration: BoxDecoration(
                    color: (_data.hasArrived ?? false)
                        ? Colors.green.withOpacity(0.25)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _data.reservationNumber ?? '',
                          style: TextStyle(
                            fontSize: size.getS(17),
                            color: Colors.black,
                            fontFamily: kFontFMedium,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (_data.message?.isNotEmpty ?? false)
                          InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (_) {
                                    return SimpleDialog(
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: size.getW(24),
                                            ),
                                            Text(
                                              "Message",
                                              style: TextStyle(
                                                fontSize: size.getS(16),
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Spacer(),
                                            SizedBox(
                                              width: size.getW(400),
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                icon: Icon(Icons.close))
                                          ],
                                        ),
                                        Divider(),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: size.getW(24),
                                              vertical: size.getH(12)),
                                          child: Text(
                                            _data.message ?? '',
                                            style: TextStyle(
                                              fontSize: size.getS(16),
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  });
                            },
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              decoration: BoxDecoration(
                                color: kSecondaryColor.withAlpha(60),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.getS(4),
                                  vertical: size.getS(4)),
                              child: Icon(
                                Icons.remove_red_eye,
                                size: size.getS(24),
                                color: kSecondaryColor,
                              ),
                            ),
                          )
                      ],
                    ),
                    SizedBox(
                      height: size.getH(4),
                    ),
                    ...List.generate(
                        orderData.length,
                        (index) => Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: size.getH(6.0)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          orderData[index].title,
                                          style: TextStyle(
                                            fontSize: size.getS(16),
                                            color: Colors.black,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      Status.values.any((e) =>
                                              e.name ==
                                              orderData[index].subtitle)
                                          ? ShowStatus(
                                              title: orderData[index].subtitle,
                                              size: size)
                                          : Flexible(
                                              child: Text(
                                                orderData[index].subtitle,
                                                style: TextStyle(
                                                  fontSize: size.getS(16),
                                                  color: Colors.black,
                                                  fontFamily: kFontFMedium,
                                                ),
                                                textAlign: TextAlign.right,
                                              ),
                                            )
                                    ],
                                  ),
                                ),
                              ],
                            )),
                    Builder(builder: (context) {
                      final btnList = _data.status?.toLowerCase() ==
                                  Status.Cancelled.name.toLowerCase() ||
                              _data.status?.toLowerCase() ==
                                  Status.Cancel.name.toLowerCase()
                          ? [
                              if (GlobalCVP
                                  .viewWidget.viewEditTableBookingButton)
                                _BtnModel(
                                  id: 2,
                                  title: LN.edit,
                                  color: kSecondaryColor,
                                ),
                            ]
                          : _data.status?.toLowerCase() ==
                                  Status.Confirmed.name.toLowerCase()
                              ? [
                                  if (GlobalCVP
                                      .viewWidget.viewCancelTableBookingButton)
                                    _BtnModel(
                                      id: 1,
                                      title: LN.cancel,
                                      color: Colors.red.shade700,
                                    ),
                                  if (GlobalCVP
                                      .viewWidget.viewEditTableBookingButton)
                                    _BtnModel(
                                      id: 2,
                                      title: LN.edit,
                                      color: kSecondaryColor,
                                    ),
                                  if (!(_data.hasArrived ?? false))
                                    _BtnModel(
                                      id: 4,
                                      title: "Arrive",
                                      color: Colors.green.shade700,
                                    ),
                                ]
                              : [
                                  if (GlobalCVP
                                      .viewWidget.viewCancelTableBookingButton)
                                    _BtnModel(
                                      id: 1,
                                      title: LN.cancel,
                                      color: Colors.red.shade700,
                                    ),
                                  if (GlobalCVP
                                      .viewWidget.viewEditTableBookingButton)
                                    _BtnModel(
                                      id: 2,
                                      title: LN.edit,
                                      color: kSecondaryColor,
                                    ),
                                  if (GlobalCVP
                                      .viewWidget.viewConfirmTableBookingButton)
                                    _BtnModel(
                                      id: 3,
                                      title: LN.confirm,
                                      color: kPrimaryColor,
                                    ),
                                ];
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: size.getH(8.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ...List.generate(
                              3,
                              (j) => Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: j < btnList.length
                                      ? ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  WidgetStateProperty.all(
                                                      btnList[j].color),
                                              padding: WidgetStateProperty.all(
                                                  EdgeInsets.symmetric(
                                                      horizontal: size.getW(8),
                                                      vertical:
                                                          size.getH(8.0)))),
                                          onPressed: tableResv.loadiing
                                              ? null
                                              : () => onClickBtn(btnList[j].id,
                                                  _data.id, context),
                                          child: Text(
                                            btnList[j].title,
                                            style: TextStyle(
                                              fontSize: size.getS(14),
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ))
                                      : SizedBox.shrink(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    })
                  ],
                ),
              );
            })
          ],
        ),
      ],
    );
  }
}

class _BtnModel {
  final int id;
  final String title;
  final Color color;

  _BtnModel({required this.id, required this.title, required this.color});
}

enum _RsrvType { cancel, confirm }
