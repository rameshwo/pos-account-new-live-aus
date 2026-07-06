// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/setting/store/store_pro.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:pos_account/widgets/switch_adap.dart';
import 'package:provider/provider.dart';

class StoreCalenderSetting extends StatelessWidget {
  // final StorePro storePro;
  final void Function()? cancel;
  StoreCalenderSetting({
    super.key,
    // required this.storePro,
    this.cancel,
  });

  String? get _dateFormat =>
      storePro.storeRes?.dateFormats != null && storePro.dateForIndex != null
          ? (storePro.storeRes?.dateFormats?[storePro.dateForIndex!].value ??
              storePro.storeRes?.dateFormats?[storePro.dateForIndex!].name)
          : null;

  String? _dateData(String val) {
    if (val.isEmpty || !val.contains(' ')) return null;
    final lastIndex = val.lastIndexOf(' ');
    return val.substring(0, lastIndex);
  }

  late StorePro storePro;

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    storePro = Provider.of<StorePro>(context);
    return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: size.getH(12),
            ),
            //credit card surcharge
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: size.getH(24.0), horizontal: size.getW(24)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                              width: size.width * 0.2,
                              child: Text(LN.channel,
                                  style: TextStyle(
                                    fontSize: size.getS(20),
                                    fontFamily: kFontFMedium,
                                  ))),
                          SizedBox(
                            width: size.width * 0.2,
                            child: Text.rich(
                              TextSpan(
                                  text: "${LN.creditCardSurcharge}% :",
                                  style: TextStyle(
                                    fontSize: size.getS(20),
                                    color: Colors.black,
                                    fontFamily: kFontFMedium,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: " *",
                                      style: TextStyle(
                                        fontSize: size.getS(20),
                                        color: Colors.red,
                                      ),
                                    )
                                  ]),
                            ),
                          ),
                          SizedBox(width: size.getW(36)),
                          SizedBox(
                            width: size.width * 0.1,
                            child: Text(LN.autoEnable,
                                style: TextStyle(
                                  fontSize: size.getS(20),
                                  color: Colors.black,
                                  fontFamily: kFontFMedium,
                                )),
                          ),
                          SizedBox(
                            width: size.width * 0.1,
                            child: Text(LN.isActive,
                                style: TextStyle(
                                  fontSize: size.getS(20),
                                  color: Colors.black,
                                  fontFamily: kFontFMedium,
                                )),
                          ),
                        ],
                      ),
                      if (storePro
                              .editData
                              ?.channelCreditCardSurchargePercentageViewModels
                              ?.isNotEmpty ??
                          false)
                        ...List.generate(
                            storePro
                                .editData!
                                .channelCreditCardSurchargePercentageViewModels!
                                .length, (index) {
                          final data = storePro.editData!
                                  .channelCreditCardSurchargePercentageViewModels![
                              index];
                          return _credSurSection(
                            size,
                            title: data.channelName ?? '',
                            textCltr: data.creditCardSurchargePercentage,
                            isEnable: data.autoEnableCreditSurchargePercentage,
                            isActive: data.isActive,
                            onChanged: (bool val, int flag) {
                              if (flag == 1) {
                                data.autoEnableCreditSurchargePercentage = val;
                              } else {
                                data.isActive = val;
                              }
                              storePro.notify();
                            },
                          );
                        }),
                    ],
                  ),
                ),
              ),
            ),
            //if weekend day and public holiday day is same then public holiday surcharge will be applied

            //weekend surcharge
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    size.getW(24),
                    size.getH(12),
                    size.getW(12),
                    size.getH(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          "Note: If weekend day and public holiday day is same then public holiday surcharge will be applied",
                          style: TextStyle(
                            fontSize: size.getS(18),
                            color: kPrimaryColor,
                            fontFamily: kFontFItalic,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.getH(12),
                      ),
                      Text(
                        "${LN.weekendSur} :",
                        style: TextStyle(
                          fontSize: size.getS(20),
                          color: Colors.black,
                          fontFamily: kFontFMedium,
                        ),
                      ),
                      SizedBox(
                        height: size.getH(12),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: size.width * 0.16,
                            child: Text(LN.name,
                                style: TextStyle(
                                  fontSize: size.getS(16),
                                  color: Colors.black,
                                )),
                          ),
                          SizedBox(
                            width: size.getW(36),
                          ),
                          SizedBox(
                            width: size.width * 0.16,
                            child: Text("${LN.weekendSur}(%)",
                                style: TextStyle(
                                  fontSize: size.getS(16),
                                  color: Colors.black,
                                )),
                          ),
                          SizedBox(
                            width: size.getW(36),
                          ),
                          SizedBox(
                            width: size.getW(120),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(LN.autoEnable,
                                    style: TextStyle(
                                      fontSize: size.getS(16),
                                      color: Colors.black,
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                      ...List.generate(storePro.weekendList.length, (index) {
                        return Padding(
                          padding: EdgeInsets.only(top: size.getH(24.0)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: size.width * 0.16,
                                child: TextFormWidget(
                                  readOnly: true,
                                  cltr: storePro.weekendList[index].titleCltr,
                                  hintText: '',
                                  borderColor: Colors.black,
                                  borderRadius: 5,
                                  hPad: 16,
                                  errH: 0,
                                ),
                              ),
                              SizedBox(
                                width: size.getW(36),
                              ),
                              SizedBox(
                                width: size.width * 0.16,
                                child: TextFormWidget(
                                  cltr: storePro.weekendList[index].valueCltr,
                                  hintText: '',
                                  borderColor: Colors.black,
                                  borderRadius: 5,
                                  isReq: false,
                                  hPad: 16,
                                  errH: 0,
                                  textInputType: TextInputType.number,
                                  suffixIconWidth: 40,
                                  suffixIcon: storePro.weekendList[index]
                                          .valueCltr.text.isNotEmpty
                                      ? InkWell(
                                          onTap: () {
                                            storePro
                                                .weekendList[index].valueCltr
                                                .clear();
                                            storePro.notify();
                                          },
                                          child: Icon(Icons.close,
                                              size: size.getS(28)))
                                      : null,
                                ),
                              ),
                              SizedBox(
                                width: size.getW(36),
                              ),
                              SizedBox(
                                  width: size.getW(120),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: SwitchAdap(
                                      size: size,
                                      value:
                                          storePro.weekendList[index].isEnable,
                                      onChanged: (val) {
                                        storePro.weekendList[index].isEnable =
                                            val;
                                        storePro.notify();
                                      },
                                    ),
                                  )),
                              SizedBox(
                                width: size.getW(48),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: size.getH(24.0), horizontal: size.getW(24)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${LN.publicHolidaySc} :",
                        style: TextStyle(
                          fontSize: size.getS(20),
                          color: Colors.black,
                          fontFamily: kFontFMedium,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TitleTextForm(
                            fontSize: 16,
                            isReq: false,
                            pWidth: 0.16,
                            title: LN.name,
                            textCltr: storePro.holidayList[0].titleCltr,
                            errH: 0,
                            suffixIconWidth: 40,
                            suffixIcon: storePro
                                    .holidayList[0].titleCltr.text.isNotEmpty
                                ? InkWell(
                                    onTap: () {
                                      storePro.holidayList[0].titleCltr.clear();
                                      storePro.notify();
                                    },
                                    child:
                                        Icon(Icons.close, size: size.getS(28)))
                                : null,
                          ),
                          SizedBox(
                            width: size.getW(36),
                          ),
                          TitleTextForm(
                            pWidth: 0.16,
                            fontSize: 16,
                            isReq: false,
                            readOnly: true,
                            title: "Choose Date",
                            textCltr: TextEditingController(
                                text: _dateData(storePro.holidayList[0].date)),
                            errH: 0,
                            onTap: () {
                              Utils.datePick(context).then((date) {
                                if (date == null) return;

                                final dateTime = DateTime(
                                  date.year,
                                  date.month,
                                  date.day,
                                );

                                storePro.holidayList[0].date =
                                    DateFormat(_dateFormat).format(dateTime);
                                storePro.notify();
                              });
                            },
                            suffixIconWidth: 40,
                            suffixIcon: storePro.holidayList[0].date.isNotEmpty
                                ? InkWell(
                                    onTap: () {
                                      storePro.holidayList[0].date = "";
                                      storePro.notify();
                                    },
                                    child:
                                        Icon(Icons.close, size: size.getS(28)))
                                : null,
                          ),
                          SizedBox(
                            width: size.getW(36),
                          ),
                          TitleTextForm(
                            pWidth: 0.16,
                            fontSize: 16,
                            isReq: false,
                            title: "${LN.publicHolidaySc}(%)",
                            textCltr: storePro.holidayList[0].valueCltr,
                            errH: 0,
                            textInputType: TextInputType.number,
                            suffixIconWidth: 40,
                            suffixIcon: storePro
                                    .holidayList[0].valueCltr.text.isNotEmpty
                                ? InkWell(
                                    onTap: () {
                                      storePro.holidayList[0].valueCltr.clear();
                                      storePro.notify();
                                    },
                                    child:
                                        Icon(Icons.close, size: size.getS(28)))
                                : null,
                          ),
                          SizedBox(
                            width: size.getW(36),
                          ),
                          SizedBox(
                            width: size.getW(120),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(LN.autoEnable,
                                    style: TextStyle(
                                      fontSize: size.getS(16),
                                      color: Colors.black,
                                    )),
                                SizedBox(
                                  height: size.getH(16),
                                ),
                                SwitchAdap(
                                  size: size,
                                  value: storePro.holidayList[0].isEnable,
                                  onChanged: (val) {
                                    storePro.holidayList[0].isEnable = val;
                                    storePro.notify();
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: size.getW(48),
                          ),
                          Material(
                            color: kPrimaryColor,
                            type: MaterialType.circle,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(60),
                              onTap: storePro.addCalenderData,
                              child: Icon(
                                Icons.add,
                                size: size.getS(40),
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                      ...List.generate(storePro.holidayList.length, (index) {
                        if (index == 0) return SizedBox.shrink();
                        return Padding(
                          padding: EdgeInsets.only(top: size.getH(24.0)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: size.width * 0.16,
                                child: TextFormWidget(
                                  cltr: storePro.holidayList[index].titleCltr,
                                  hintText: '',
                                  borderColor: Colors.black,
                                  borderRadius: 5,
                                  vPad: 12,
                                  hPad: 16,
                                  errH: 0,
                                  suffixIconWidth: 40,
                                  suffixIcon: storePro.holidayList[index]
                                          .titleCltr.text.isNotEmpty
                                      ? InkWell(
                                          onTap: () {
                                            storePro
                                                .holidayList[index].titleCltr
                                                .clear();
                                            storePro.notify();
                                          },
                                          child: Icon(Icons.close,
                                              size: size.getS(28)))
                                      : null,
                                ),
                              ),
                              SizedBox(
                                width: size.getW(36),
                              ),
                              SizedBox(
                                width: size.width * 0.16,
                                child: TextFormWidget(
                                  cltr: TextEditingController(
                                      text: _dateData(
                                          storePro.holidayList[index].date)),
                                  hintText: '',
                                  readOnly: true,
                                  borderColor: Colors.black,
                                  borderRadius: 5,
                                  vPad: 12,
                                  hPad: 16,
                                  errH: 0,
                                  onTap: () {
                                    Utils.datePick(context).then((date) {
                                      if (date == null) return;

                                      final dateTime = DateTime(
                                        date.year,
                                        date.month,
                                        date.day,
                                      );

                                      storePro.holidayList[index].date =
                                          DateFormat(_dateFormat)
                                              .format(dateTime);
                                      storePro.notify();
                                    });
                                  },
                                  suffixIconWidth: 40,
                                  suffixIcon: storePro
                                          .holidayList[index].date.isNotEmpty
                                      ? InkWell(
                                          onTap: () {
                                            storePro.holidayList[index].date =
                                                "";
                                            storePro.notify();
                                          },
                                          child: Icon(Icons.close,
                                              size: size.getS(28)))
                                      : null,
                                ),
                              ),
                              SizedBox(
                                width: size.getW(36),
                              ),
                              SizedBox(
                                width: size.width * 0.16,
                                child: TextFormWidget(
                                  cltr: storePro.holidayList[index].valueCltr,
                                  hintText: '',
                                  isReq: false,
                                  borderColor: Colors.black,
                                  borderRadius: 5,
                                  vPad: 12,
                                  hPad: 16,
                                  errH: 0,
                                  textInputType: TextInputType.number,
                                  suffixIconWidth: 40,
                                  suffixIcon: storePro.holidayList[index]
                                          .valueCltr.text.isNotEmpty
                                      ? InkWell(
                                          onTap: () {
                                            storePro
                                                .holidayList[index].valueCltr
                                                .clear();
                                            storePro.notify();
                                          },
                                          child: Icon(Icons.close,
                                              size: size.getS(28)))
                                      : null,
                                ),
                              ),
                              SizedBox(
                                width: size.getW(36),
                              ),
                              SizedBox(
                                  width: size.getW(120),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: SwitchAdap(
                                      size: size,
                                      value:
                                          storePro.holidayList[index].isEnable,
                                      onChanged: (val) {
                                        storePro.holidayList[index].isEnable =
                                            val;
                                        storePro.notify();
                                      },
                                    ),
                                  )),
                              SizedBox(
                                width: size.getW(48),
                              ),
                              Material(
                                color: Colors.red.shade700,
                                type: MaterialType.circle,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(60),
                                  onTap: () {
                                    storePro.removeCalenderData(index: index);
                                  },
                                  child: Icon(
                                    Icons.remove,
                                    size: size.getS(40),
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(
              height: size.getH(24),
            ),
            // Row(
            //   mainAxisSize: MainAxisSize.min,
            //   children: [
            //     LoadButton(
            //         loading: storePro.updateLoad,
            //         onsave: storePro.updateLoad
            //             ? null
            //             : () => storePro.addData(context)),
            //     SizedBox(
            //       width: size.getW(24),
            //     ),
            //     ElevatedButton(
            //         style: ButtonStyle(
            //             backgroundColor:
            //                 MaterialStateProperty.all(Colors.red.shade800),
            //             padding: MaterialStateProperty.all(EdgeInsets.symmetric(
            //                 horizontal: size.getW(48),
            //                 vertical: size.getH(8)))),
            //         onPressed: cancel,
            //         child: Text(
            //           LN.cancel,
            //           style: TextStyle(
            //             fontSize: size.getS(16),
            //             color: Colors.white,
            //             fontWeight: FontWeight.bold,
            //           ),
            //         )),
            //   ],
            // ),
            SizedBox(
              height: size.getH(12),
            ),
          ],
        ));
  }

  Column _credSurSection(
    Ssize size, {
    required String title,
    required TextEditingController textCltr,
    bool isEnable = false,
    bool isActive = false,
    required Function(bool, int) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Divider(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
                width: size.width * 0.2,
                child: Text(title,
                    style: TextStyle(
                      fontSize: size.getS(18),
                      fontFamily: kFontFMedium,
                    ))),
            SizedBox(
              width: size.width * 0.2,
              child: TextFormWidget(
                isReq: true,
                textInputType: TextInputType.number,
                cltr: textCltr,
                hintText: "0",
                validator: (p0) {
                  if (p0 != null) {
                    final val = int.tryParse(p0);
                    if (val != null && val < 0 && val > 100) {
                      return LN.invalidNumber;
                    }
                  }
                  return null;
                },
                suffixIcon: Text(
                  "%",
                  style: TextStyle(
                    fontSize: size.getS(18),
                    color: Colors.black,
                    fontFamily: kFontFRegular,
                  ),
                ),
                suffixIconWidth: 24,
              ),
            ),
            SizedBox(
              width: size.width * 0.1,
              child: SwitchAdap(
                size: size,
                value: isEnable,
                onChanged: (val) => onChanged(val, 1),
              ),
            ),
            SizedBox(
              width: size.width * 0.1,
              child: SwitchAdap(
                size: size,
                value: isActive,
                onChanged: (val) => onChanged(val, 2),
              ),
            ),
            SizedBox(
              width: size.getW(48),
            ),
          ],
        ),
      ],
    );
  }
}
