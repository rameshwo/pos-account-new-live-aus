import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/switch_adap.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../../providers/setting/store/store_pro_v2.dart';
import '../../../../../../../../../widgets/input/text_form/text_form_widget.dart';
import '../../general/common/common_header.dart';
import 'widgets/store_card.dart';

class ExChargeStoreV2 extends StatefulWidget {
  final PageController pageController;
  const ExChargeStoreV2({super.key, required this.pageController});

  @override
  State<ExChargeStoreV2> createState() => _ExChargeStoreV2State();
}

class _ExChargeStoreV2State extends State<ExChargeStoreV2> {
  @override
  void initState() {
    super.initState();
    setData();
  }

  void setData() {
    final _storePro = Provider.of<StoreProV2>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _storePro.getAddSec();
      _storePro.getExtChargeData();
    });
  }

  @override
  void dispose() {
    storePro.loading = true;
    super.dispose();
  }

  String? _dateData(String val) {
    if (val.isEmpty || !val.contains(' ')) return null;
    final lastIndex = val.lastIndexOf(' ');
    return val.substring(0, lastIndex);
  }

  late StoreProV2 storePro;

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    storePro = Provider.of<StoreProV2>(context);
    return Processing(
      loading: storePro.updateLoadExtraCharge || storePro.loading,
      child: Column(
        children: [
          CommonHeader(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () {
                      widget.pageController.jumpToPage(0);
                    },
                    icon: Icon(Icons.arrow_back)),
                Text(
                  "Extra Charge",
                  style: TextStyle(
                    fontSize: size.getS(18),
                    fontFamily: kFontFMedium,
                  ),
                ),
                Spacer(),
                // if (GlobalCVP.viewWidget.viewStorec)
                LoadButton(
                  vPad: 10,
                  hPad: 4,
                  loading: storePro.updateLoadExtraCharge,
                  btnText: "Update",
                  loadingText: "Updating",
                  onsave: storePro.updateLoadExtraCharge
                      ? null
                      : () {
                          FocusScope.of(context).unfocus();
                          storePro.updateExtCharge();
                        },
                ),
                SizedBox(width: size.getW(12)),
              ],
            ),
          ),
          SizedBox(
            height: size.getH(12),
          ),
          Expanded(
            child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: size.getH(12),
                      ),
                      StoreCardUI(
                          title: 'Credit Card Surcharge',
                          iconData: Icons.credit_card,
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: size.getH(24),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  // crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                        // width: size.width * 0.2,
                                        child: Text(LN.channel,
                                            style: TextStyle(
                                              fontSize: size.getS(18),
                                              fontFamily: kFontFMedium,
                                            ))),
                                    Expanded(
                                      flex: 2,
                                      // width: size.width * 0.2,
                                      child: Text.rich(
                                        TextSpan(
                                            text:
                                                "${LN.creditCardSurcharge}(%)",
                                            style: TextStyle(
                                              fontSize: size.getS(18),
                                              color: Colors.black,
                                              fontFamily: kFontFMedium,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: " *",
                                                style: TextStyle(
                                                  fontSize: size.getS(18),
                                                  color: Colors.red,
                                                ),
                                              )
                                            ]),
                                      ),
                                    ),
                                    SizedBox(width: size.getW(36)),
                                    Expanded(
                                      // width: size.width * 0.1,
                                      child: Text(LN.autoEnable,
                                          style: TextStyle(
                                            fontSize: size.getS(18),
                                            color: Colors.black,
                                            fontFamily: kFontFMedium,
                                          )),
                                    ),
                                    Expanded(
                                      // width: size.width * 0.1,
                                      child: Text(LN.isActive,
                                          style: TextStyle(
                                            fontSize: size.getS(18),
                                            color: Colors.black,
                                            fontFamily: kFontFMedium,
                                          )),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: size.getH(6),
                                ),
                                if (storePro
                                        .extChargeData
                                        ?.posCreditCardSurchargeAddViewModels
                                        ?.isNotEmpty ??
                                    false)
                                  ...List.generate(
                                      storePro
                                          .extChargeData!
                                          .posCreditCardSurchargeAddViewModels!
                                          .length, (index) {
                                    final data = storePro.extChargeData!
                                            .posCreditCardSurchargeAddViewModels![
                                        index];
                                    return _credSurSection(
                                      size,
                                      title: data.channelName ?? '',
                                      textCltr:
                                          data.creditCardSurchargePercentage,
                                      isEnable: data
                                          .autoEnableCreditSurchargePercentage,
                                      isActive: data.isActive,
                                      onChanged: (bool val, int flag) {
                                        if (flag == 1) {
                                          data.autoEnableCreditSurchargePercentage =
                                              val;
                                        } else {
                                          data.isActive = val;
                                        }
                                        storePro.notify;
                                      },
                                    );
                                  }),
                              ],
                            ),
                          )),
                      SizedBox(
                        height: size.getH(12),
                      ),
                      if (storePro.extChargeData?.serviceChargeAddViewModel !=
                          null)
                        StoreCardUI(
                            title: 'Service Charge',
                            iconData: Icons.attach_money,
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: size.getH(24),
                              ),
                              child: Row(
                                // crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    width: size.width * 0.2,
                                    child: TitleTextForm(
                                      title: "Service Charge (%)",
                                      isReq: true,
                                      textInputType: TextInputType.number,
                                      textCltr: storePro
                                          .extChargeData!
                                          .serviceChargeAddViewModel!
                                          .serviceChargePercentage,
                                      borderColor: Colors.black38,
                                      hintText: "0",
                                      validator: (p0) {
                                        if (p0 != null) {
                                          final val = int.tryParse(p0);
                                          if (val != null &&
                                              val < 0 &&
                                              val > 100) {
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
                                      suffixIconWidth: 24, //textCltr: null,
                                    ),
                                  ),
                                  SizedBox(
                                    width: size.getW(120),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Auto Enable",
                                        style:
                                            TextStyle(fontSize: size.getS(18)),
                                      ),
                                      SizedBox(height: size.getH(12)),
                                      SwitchAdap(
                                        size: size,
                                        value: storePro
                                            .extChargeData!
                                            .serviceChargeAddViewModel!
                                            .autoEnableServiceChargePercentage,
                                        onChanged: (val) {
                                          storePro
                                                  .extChargeData!
                                                  .serviceChargeAddViewModel!
                                                  .autoEnableServiceChargePercentage =
                                              val;
                                          storePro.notify;
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: size.getW(120),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Active",
                                        style:
                                            TextStyle(fontSize: size.getS(18)),
                                      ),
                                      SizedBox(height: size.getH(12)),
                                      SwitchAdap(
                                        size: size,
                                        value: storePro
                                                .extChargeData!
                                                .serviceChargeAddViewModel!
                                                .isActive ??
                                            false,
                                        onChanged: (val) {
                                          storePro
                                              .extChargeData!
                                              .serviceChargeAddViewModel!
                                              .isActive = val;
                                          storePro.notify;
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: size.getW(120),
                                  ),
                                ],
                              ),
                            )),
                      StoreCardUI(
                          title: 'Holiday Surcharge',
                          iconData: Icons.credit_card,
                          child: Column(
                            children: [
                              ...List.generate(storePro.holidayList.length,
                                  (index) {
                                return Padding(
                                  padding:
                                      EdgeInsets.only(top: size.getH(24.0)),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.16,
                                        child: TitleTextForm(
                                          title: "Holiday Name",
                                          textCltr: storePro
                                              .holidayList[index].titleCltr,
                                          hintText: '',
                                          isReq: false,
                                          borderRadius: 5,
                                          hPad: 16,
                                          errH: 0,
                                          suffixIconWidth: 40,
                                          suffixIcon: storePro
                                                  .holidayList[index]
                                                  .titleCltr
                                                  .text
                                                  .isNotEmpty
                                              ? InkWell(
                                                  onTap: () {
                                                    storePro.holidayList[index]
                                                        .titleCltr
                                                        .clear();
                                                    storePro.notify;
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
                                        child: TitleTextForm(
                                          title: "Date",
                                          textCltr: TextEditingController(
                                              text: _dateData(storePro
                                                  .holidayList[index].date)),
                                          hintText: '',
                                          isReq: false,
                                          readOnly: true,
                                          borderRadius: 5,
                                          hPad: 16,
                                          errH: 0,
                                          onTap: () {
                                            Utils.datePick(context)
                                                .then((date) {
                                              if (date == null) return;

                                              final dateTime = DateTime(
                                                date.year,
                                                date.month,
                                                date.day,
                                              );

                                              storePro.holidayList[index].date =
                                                  DateFormat(
                                                          storePro.dateFormat)
                                                      .format(dateTime);
                                              storePro.notify;
                                            });
                                          },
                                          suffixIconWidth: 40,
                                          suffixIcon: storePro
                                                  .holidayList[index]
                                                  .date
                                                  .isNotEmpty
                                              ? InkWell(
                                                  onTap: () {
                                                    storePro.holidayList[index]
                                                        .date = "";
                                                    storePro.notify;
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
                                        child: TitleTextForm(
                                          title: "Surcharge (%)",
                                          textCltr: storePro
                                              .holidayList[index].valueCltr,
                                          hintText: '',
                                          isReq: false,
                                          borderRadius: 5,
                                          hPad: 16,
                                          errH: 0,
                                          textInputType: TextInputType.number,
                                          suffixIconWidth: 40,
                                          suffixIcon: storePro
                                                  .holidayList[index]
                                                  .valueCltr
                                                  .text
                                                  .isNotEmpty
                                              ? InkWell(
                                                  onTap: () {
                                                    storePro.holidayList[index]
                                                        .valueCltr
                                                        .clear();
                                                    storePro.notify;
                                                  },
                                                  child: Icon(Icons.close,
                                                      size: size.getS(28)))
                                              : null,
                                        ),
                                      ),
                                      SizedBox(
                                        width: size.getW(48),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Auto Enable",
                                            style: TextStyle(
                                                fontSize: size.getS(18)),
                                          ),
                                          SizedBox(height: size.getH(12)),
                                          SizedBox(
                                              width: size.getW(120),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: SwitchAdap(
                                                  size: size,
                                                  value: storePro
                                                      .holidayList[index]
                                                      .isEnable,
                                                  onChanged: (val) {
                                                    storePro.holidayList[index]
                                                        .isEnable = val;
                                                    storePro.notify;
                                                  },
                                                ),
                                              )),
                                        ],
                                      ),
                                      SizedBox(
                                        width: size.getW(48),
                                      ),
                                      Material(
                                        color: Colors.red.shade700,
                                        type: MaterialType.circle,
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(60),
                                          onTap: () {
                                            storePro.removeHoliday(
                                                index: index);
                                          },
                                          child: Icon(
                                            Icons.remove,
                                            size: size.getS(36),
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }),
                              SizedBox(
                                height: size.getH(24),
                              ),
                              LoadButton(
                                width: 300,
                                hPad: 4,
                                vPad: 8,
                                textColor: kSecondaryColor,
                                btnColor: Colors.white,
                                fontSize: 14,
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: kSecondaryColor.withOpacity(0.2),
                                    ),
                                    borderRadius:
                                        BorderRadiusGeometry.circular(5)),
                                btnText: "Add Holiday",
                                icon: Padding(
                                  padding:
                                      EdgeInsets.only(right: size.getW(12)),
                                  child: Icon(
                                    Icons.add,
                                    color: kSecondaryColor,
                                    size: size.getS(22),
                                  ),
                                ),
                                onsave: () {
                                  storePro.addHoliday();
                                },
                              ),
                            ],
                          )),
                      StoreCardUI(
                          title: 'Weekend Surcharge',
                          iconData: Icons.credit_card,
                          child: Column(
                            children: [
                              ...List.generate(storePro.weekendList.length,
                                  (index) {
                                return Padding(
                                  padding:
                                      EdgeInsets.only(top: size.getH(24.0)),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.16,
                                        child: TitleTextForm(
                                          title: "Week Day",
                                          readOnly: true,
                                          isReq: false,
                                          textCltr: storePro
                                              .weekendList[index].titleCltr,
                                          hintText: '',
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
                                        child: TitleTextForm(
                                          title: "Surcharge (%)",
                                          textCltr: storePro
                                              .weekendList[index].valueCltr,
                                          hintText: '',
                                          borderRadius: 5,
                                          isReq: false,
                                          hPad: 16,
                                          errH: 0,
                                          textInputType: TextInputType.number,
                                          suffixIconWidth: 40,
                                          suffixIcon: storePro
                                                  .weekendList[index]
                                                  .valueCltr
                                                  .text
                                                  .isNotEmpty
                                              ? InkWell(
                                                  onTap: () {
                                                    storePro.weekendList[index]
                                                        .valueCltr
                                                        .clear();
                                                    storePro.notify;
                                                  },
                                                  child: Icon(Icons.close,
                                                      size: size.getS(28)))
                                              : null,
                                        ),
                                      ),
                                      SizedBox(
                                        width: size.getW(36),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Auto Enable",
                                            style: TextStyle(
                                                fontSize: size.getS(18)),
                                          ),
                                          SizedBox(height: size.getH(12)),
                                          SizedBox(
                                              width: size.getW(120),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: SwitchAdap(
                                                  size: size,
                                                  value: storePro
                                                      .weekendList[index]
                                                      .isEnable,
                                                  onChanged: (val) {
                                                    storePro.weekendList[index]
                                                        .isEnable = val;
                                                    storePro.notify;
                                                  },
                                                ),
                                              )),
                                        ],
                                      ),
                                      SizedBox(
                                        width: size.getW(48),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          )),
                      SizedBox(height: size.getH(48)),
                    ])),
          )
        ],
      ),
    );
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
        SizedBox(height: size.getH(12)),
        Row(
          // crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
                // width: size.width * 0.2,
                child: Text(title,
                    style: TextStyle(
                      fontSize: size.getS(18),
                      fontFamily: kFontFMedium,
                    ))),
            Expanded(
              flex: 2,
              // width: size.width * 0.2,
              child: TextFormWidget(
                isReq: true,
                textInputType: TextInputType.number,
                cltr: textCltr,
                borderColor: Colors.black38,
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
            Expanded(
              // width: size.width * 0.1,
              child: SwitchAdap(
                size: size,
                value: isEnable,
                onChanged: (val) => onChanged(val, 1),
              ),
            ),
            Expanded(
              // width: size.width * 0.1,
              child: SwitchAdap(
                size: size,
                value: isActive,
                onChanged: (val) => onChanged(val, 2),
              ),
            ),
            SizedBox(
              width: size.getW(120),
            ),
          ],
        ),
      ],
    );
  }
}
