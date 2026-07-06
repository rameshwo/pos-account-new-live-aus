import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/constant/date_format_keys.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/booking/table_resv_pro.dart';
import 'package:pos_account/screens/home_screen/com/dialogs/cus_list_dia.dart';
import 'package:pos_account/widgets/dialog/confirm_dialog.dart';
import 'package:pos_account/widgets/image/network_image_sec.dart';
import 'package:pos_account/widgets/input/dropdown/dropdown_with_text_form.dart';
import 'package:pos_account/widgets/input/dropdown/title_drop_down.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:provider/provider.dart';

const _timeFormat = "h:mm a";

class BookCustomer extends StatefulWidget {
  const BookCustomer({
    super.key,
    this.onTapTable,
    this.isQuick = false,
  });

  final Function(TableResvPro pro)? onTapTable;
  final bool isQuick;

  @override
  State<BookCustomer> createState() => _BookCustomerState();
}

class _BookCustomerState extends State<BookCustomer> {
  String formatTime(String time24) {
    // Parse the input string "16:30" as a DateTime object
    DateTime? dateTime =
        time24.isNotEmpty ? DateFormat("HH:mm").parse(time24) : null;

    // Format the DateTime object to "h:mm a" for 12-hour format with AM/PM
    String formattedTime =
        dateTime != null ? DateFormat(_timeFormat).format(dateTime) : '';

    return formattedTime;
  }

  List<String> generateUpcomingTimes({DateTime? now}) {
    now ??= DateTime.now();

    // Start from the next 30-minute interval
    DateTime nextTime = DateTime(
        now.year,
        now.month,
        now.day,
        now.minute >= 30 && now.hour < 24 ? now.hour + 1 : now.hour,
        (now.minute == 0 || now.minute >= 30) ? 0 : 30);

    List<String> timeSlots = [];

    int nextHour = nextTime.hour;
    int nextMin = nextTime.minute;

    if (nextMin == 30) {
      timeSlots.add(formatTime("$nextHour:$nextMin"));
      nextHour += 1;
      nextMin = 0;
    }

    while (nextHour <= 23) {
      for (int i = 0; i < 2; i++) {
        timeSlots.add(formatTime("$nextHour:${i == 0 ? '00' : '30'}"));
      }
      nextHour++;
    }

    return timeSlots;
  }

  late TableResvPro initPro;

  final _searchDateFormat = RESERVE_DATE_FORMAT;

  @override
  void initState() {
    super.initState();
    initPro = Provider.of<TableResvPro>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      initPro.timeList.addAll(generateUpcomingTimes());
      final time = initPro.timeList.first.isNotEmpty
          ? DateFormat(_timeFormat).parse(initPro.timeList.first)
          : null;
      final now = DateTime.now();

      initPro.searchDate = _searchDateFormat.format(DateTime(
        now.year,
        now.month,
        now.day,
        time?.hour ?? 0,
        time?.minute ?? 0,
      ));
      initPro.getReservNumber();
      initPro.getTableSlot();
      initPro.notify;
    });
  }

  @override
  void dispose() {
    initPro.timeList.clear();
    initPro.slotClear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final tableResv = Provider.of<TableResvPro>(context);
    return Processing(
      loading: tableResv.loadiing || tableResv.findLoad,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: size.height / 1.2,
          minHeight: size.height / 5,
        ),
        width: size.width / 1.17,
        child: Form(
          key: tableResv.formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: size.getH(8.0), horizontal: size.getW(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      LN.tableBookResv,
                      style: TextStyle(
                        fontSize: size.getS(18),
                        fontFamily: kFontFMedium,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          final _data = tableResv.addableData();
                          if (tableResv.resvId.isNotEmpty &&
                              _data != tableResv.initEditData) {
                            showDialog(
                                context: context,
                                builder: (builder) => ConfirmDialog(
                                      title: "${LN.update} ${LN.tableBooking}",
                                      subTitle: LN.sureToDiscardChanges,
                                      actionText: LN.yes,
                                      cancelText: LN.no,
                                      onDelete: () async {
                                        Navigator.pop(context);
                                        return null;
                                      },
                                    ));
                          } else {
                            Navigator.pop(context);
                          }
                        },
                        icon: Icon(
                          Icons.close,
                          color: Colors.black,
                          size: size.getS(25),
                        ))
                  ],
                ),
                Flexible(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: size.getH(12),
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: kSecondaryColor),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: size.getW(12),
                              vertical: size.getH(8)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Wrap(
                                  spacing: size.getW(32),
                                  runSpacing: size.getH(16),
                                  crossAxisAlignment: WrapCrossAlignment.end,
                                  children: [
                                    TitleDropDown(
                                      pWidth: 0.20,
                                      isReq: true,
                                      title: "No. of People",
                                      borderColor: Colors.black54,
                                      indexVal: tableResv.noPeopleIndex,
                                      list: tableResv.noOfPeopleList
                                          .map((e) => "$e People")
                                          .toList(),
                                      onChanged: (p0) {
                                        if (p0 == null) return;
                                        tableResv.slotClear();

                                        tableResv.noPeopleIndex = p0;
                                        tableResv.adultCltr.text = tableResv
                                            .noOfPeopleList[p0]
                                            .toString();

                                        tableResv.notify;
                                        tableResv.getTableSlot();
                                      },
                                    ),
                                    TitleTextForm(
                                      pWidth: 0.20,
                                      title: LN.date,
                                      borderColor: Colors.black54,
                                      textCltr: TextEditingController(
                                          text:
                                              tableResv.searchDate.contains(' ')
                                                  ? tableResv.searchDate
                                                      .split(' ')
                                                      .first
                                                  : ''),
                                      readOnly: true,
                                      onTap: () {
                                        if (tableResv.searchDate.isNotEmpty)
                                          Utils.datePick(
                                            context,
                                            initDate: _searchDateFormat
                                                .parse(tableResv.searchDate),
                                          ).then((_date) {
                                            if (_date == null) return;

                                            if (_date
                                                    .difference(DateTime.now())
                                                    .inDays <
                                                0) {
                                              showToast(
                                                  "Reservations cannot be made for the past");

                                              return;
                                            }

                                            initPro.timeList.clear();

                                            initPro.timeList.addAll(
                                                generateUpcomingTimes(
                                                    now: _date.day ==
                                                                DateTime.now()
                                                                    .day &&
                                                            _date.month ==
                                                                DateTime.now()
                                                                    .month
                                                        ? DateTime.now()
                                                        : DateTime(
                                                            _date.year,
                                                            _date.month,
                                                            _date.day,
                                                          )));
                                            initPro.timeIndex = 0;

                                            final time = tableResv
                                                    .timeList[initPro.timeIndex]
                                                    .isNotEmpty
                                                ? DateFormat(_timeFormat).parse(
                                                    tableResv.timeList[
                                                        initPro.timeIndex])
                                                : null;

                                            final _dateTime = DateTime(
                                              _date.year,
                                              _date.month,
                                              _date.day,
                                              time?.hour ?? 0,
                                              time?.minute ?? 0,
                                            );

                                            tableResv.searchDate =
                                                _searchDateFormat
                                                    .format(_dateTime);

                                            tableResv.notify;

                                            tableResv.getTableSlot();
                                          });
                                      },
                                      suffixIcon: Icon(Icons.calendar_month),
                                    ),
                                    TitleDropDown(
                                      pWidth: 0.20,
                                      isReq: true,
                                      title: "Time",
                                      borderColor: Colors.black54,
                                      indexVal: tableResv.timeIndex,
                                      list: tableResv.timeList
                                          .map((e) => e)
                                          .toList(),
                                      onChanged: (p0) {
                                        if (p0 == null) return;

                                        tableResv.timeIndex = p0;
                                        final _date =
                                            tableResv.searchDate.isNotEmpty
                                                ? _searchDateFormat
                                                    .parse(tableResv.searchDate)
                                                : null;

                                        final _time = tableResv
                                                .timeList[p0].isNotEmpty
                                            ? DateFormat(_timeFormat)
                                                .parse(tableResv.timeList[p0])
                                            : null;

                                        final _dateTime =
                                            _date != null && _time != null
                                                ? DateTime(
                                                    _date.year,
                                                    _date.month,
                                                    _date.day,
                                                    _time.hour,
                                                    _time.minute,
                                                  )
                                                : null;

                                        if (_dateTime != null &&
                                            _dateTime
                                                    .difference(DateTime.now())
                                                    .inMinutes <
                                                0) {
                                          showToast(
                                              "Reservations cannot be made for the past");

                                          return;
                                        }

                                        if (_dateTime != null)
                                          tableResv.searchDate =
                                              _searchDateFormat
                                                  .format(_dateTime);

                                        tableResv.notify;
                                        tableResv.getTableSlot();
                                      },
                                    ),
                                    // TitleTextForm(
                                    //   pWidth: 0.20,
                                    //   title: LN.time,
                                    //   borderColor: Colors.black54,
                                    //   textCltr: TextEditingController(
                                    //       text: tableResv.searchDate.contains(' ')
                                    //           ? tableResv.searchDate.split(' ').last
                                    //           : ''),
                                    //   readOnly: true,
                                    //   onTap: () {
                                    //     Utils.timePick(context).then((_time) {
                                    //       if (_time == null) return;
                                    //       final _date = DateFormat(tableResv.dateFormat)
                                    //           .parse(tableResv.searchDate);

                                    //       final _dateTime = DateTime(
                                    //         _date.year,
                                    //         _date.month,
                                    //         _date.day,
                                    //         _time.hour,
                                    //         _time.minute,
                                    //       );
                                    //       if (_dateTime
                                    //               .difference(DateTime.now())
                                    //               .inMinutes <
                                    //           0) {
                                    //         showToast(
                                    //             "Reservations cannot be made for the past");

                                    //         return;
                                    //       }

                                    //       tableResv.searchDate =
                                    //           DateFormat(tableResv.dateFormat)
                                    //               .format(_dateTime);

                                    //       tableResv.notify;
                                    //     });
                                    //   },
                                    //   suffixIcon: Icon(Icons.watch_later_outlined),
                                    // ),
                                    LoadButton(
                                      btnText: "Find Time",
                                      loading: tableResv.findLoad,
                                      vPad: 10,
                                      onsave: () {
                                        tableResv.getTableSlot();
                                      },
                                    ),
                                  ]),
                              if (tableResv.tableSlotAvaiRes
                                      ?.bookingSlotsAvailable?.isNotEmpty ??
                                  false)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: size.getH(24),
                                    ),
                                    Text(
                                      "Available Time Slots",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: kFontFMedium,
                                        fontSize: size.getS(16),
                                      ),
                                    ),
                                    SizedBox(
                                      height: size.getH(8),
                                    ),
                                    Wrap(
                                      spacing: size.getW(16),
                                      runSpacing: size.getH(16),
                                      children: List.generate(
                                          tableResv
                                              .tableSlotAvaiRes!
                                              .bookingSlotsAvailable!
                                              .length, (i) {
                                        final _timeText = formatTime(tableResv
                                            .tableSlotAvaiRes!
                                            .bookingSlotsAvailable![i]);
                                        final _selected =
                                            tableResv.selectedSlot == i;
                                        return Material(
                                            color: _selected
                                                ? kTempColor
                                                : kSecondaryColor,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: InkWell(
                                              onTap: () {
                                                tableResv.selectedSlot = i;

                                                final _date = tableResv
                                                        .searchDate.isNotEmpty
                                                    ? _searchDateFormat.parse(
                                                        tableResv.searchDate)
                                                    : null;

                                                final _time = _timeText
                                                        .isNotEmpty
                                                    ? DateFormat(_timeFormat)
                                                        .parse(_timeText)
                                                    : null;

                                                final _dateTime =
                                                    _date != null &&
                                                            _time != null
                                                        ? DateTime(
                                                            _date.year,
                                                            _date.month,
                                                            _date.day,
                                                            _time.hour,
                                                            _time.minute,
                                                          )
                                                        : null;

                                                if (_dateTime != null) {
                                                  tableResv.dateTimeFromCltr
                                                      .text = DateFormat(
                                                          tableResv.dateFormat)
                                                      .format(_dateTime);

                                                  tableResv.dateTimeToCltr
                                                      .text = DateFormat(
                                                          tableResv.dateFormat)
                                                      .format(_dateTime.add(
                                                          Duration(
                                                              minutes: 30)));
                                                }
                                                tableResv.notify;
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: size.getW(12),
                                                    vertical: size.getH(6)),
                                                child: Text(
                                                  _timeText,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: kFontFMedium,
                                                    fontSize: size.getS(16),
                                                  ),
                                                ),
                                              ),
                                            ));
                                      }),
                                    ),
                                  ],
                                ),
                              SizedBox(
                                height: size.getH(12),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: size.getH(12),
                        ),
                        Wrap(
                          spacing: size.getW(30),
                          runSpacing: size.getH(16),
                          children: [
                            TitleTextForm(
                              pWidth: 0.24,
                              title: LN.reserveNo,
                              borderColor: Colors.black54,
                              textCltr: TextEditingController(
                                  text: tableResv.tableRsvNo),
                              readOnly: true,
                              isReq: false,
                            ),
                            TitleTextForm(
                              pWidth: 0.24,
                              title: LN.dateTimeFrom,
                              borderColor: Colors.black54,
                              textCltr: tableResv.dateTimeFromCltr,
                              readOnly: true,
                              onTap: () {
                                Utils.datePick(context).then((_date) {
                                  if (_date == null) return;
                                  Utils.timePick(context).then((_time) {
                                    if (_time == null) return;
                                    final _dateTime = DateTime(
                                      _date.year,
                                      _date.month,
                                      _date.day,
                                      _time.hour,
                                      _time.minute,
                                    );
                                    if (_dateTime.isBefore(DateTime.now())) {
                                      showToast(
                                          "Reservations cannot be made for the past");
                                      tableResv.dateTimeFromCltr.clear();
                                      return;
                                    }

                                    tableResv.dateTimeFromCltr.text =
                                        DateFormat(tableResv.dateFormat)
                                            .format(_dateTime);

                                    if (tableResv.dateTimeToCltr.text.isEmpty ||
                                        DateFormat(tableResv.dateFormat)
                                            .parse(
                                                tableResv.dateTimeToCltr.text)
                                            .isBefore(_dateTime)) {
                                      tableResv.dateTimeToCltr.text =
                                          DateFormat(tableResv.dateFormat)
                                              .format(_dateTime
                                                  .add(Duration(minutes: 30)));
                                    }
                                  });
                                });
                              },
                            ),
                            TitleTextForm(
                              pWidth: 0.24,
                              title: LN.dateTimeTo,
                              borderColor: Colors.black54,
                              textCltr: tableResv.dateTimeToCltr,
                              readOnly: true,
                              onTap: () {
                                Utils.datePick(context).then((_date) {
                                  if (_date == null) return;
                                  Utils.timePick(context).then((_time) {
                                    if (_time == null) return;
                                    final _dateTime = DateTime(
                                      _date.year,
                                      _date.month,
                                      _date.day,
                                      _time.hour,
                                      _time.minute,
                                    );

                                    if (tableResv
                                            .dateTimeFromCltr.text.isNotEmpty &&
                                        DateFormat(tableResv.dateFormat)
                                            .parse(
                                                tableResv.dateTimeFromCltr.text)
                                            .isAfter(_dateTime)) {
                                      showToast(LN.reservCantEndBefStartDate);
                                      tableResv.dateTimeToCltr.clear();
                                      return;
                                    }
                                    tableResv.dateTimeToCltr.text =
                                        DateFormat(tableResv.dateFormat)
                                            .format(_dateTime);
                                  });
                                });
                              },
                            ),

                            TitleTextForm(
                              pWidth: 0.24,
                              title: LN.name,
                              textCltr: tableResv.nameCltr,
                              borderColor: Colors.black54,
                              suffix: InkWell(
                                onTap: () =>
                                    CustomerList.show(context).then((value) {
                                  tableResv.setCustomerData(value);
                                }),
                                child: Icon(
                                  Icons.search,
                                  size: size.getS(24),
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            // TitleTextForm(
                            //   pWidth: 0.24,
                            //   title: LN.phoneNumber,
                            //   textCltr: tableResv.phoneCltr,
                            //   textInputType: TextInputType.number,
                            // ),

                            TitleTextForm(
                              pWidth: 0.24,
                              title: LN.email,
                              isReq: false, //!isQuick,
                              borderColor: Colors.black54,
                              textCltr: tableResv.emailCltr,
                              textInputType: TextInputType.emailAddress,
                              validator: emailValidator,
                            ),
                            SearchTitleDropDown(
                              pWidth: 0.24,
                              isReq: true,
                              title: LN.country,
                              borderColor: Colors.black54,
                              indexVal: tableResv.countryIndex,
                              list: tableResv.tableResvAddSec?.countries == null
                                  ? []
                                  : tableResv.tableResvAddSec!.countries!
                                      .map((e) => e.name ?? '')
                                      .toList(),
                              onChanged: (p0) {
                                if (p0 == null) return;
                                tableResv.countryIndex = p0;
                                tableResv.phoneCodeIndex = p0;
                                tableResv.notify;
                              },
                            ),
                            DropDownWiTextForm(
                              title: LN.phoneNumber,
                              isReq: !widget.isQuick,
                              pWidth: 0.24,
                              borderColor: Colors.black54,
                              indexVal: tableResv.phoneCodeIndex,
                              list: tableResv.tableResvAddSec?.countries == null
                                  ? []
                                  : tableResv.tableResvAddSec!.countries!
                                      .map((e) => Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              NetworkImageSec(
                                                image: e.image,
                                                height: size.isProt
                                                    ? size.getW(12)
                                                    : size.getW(16),
                                                width: size.isProt
                                                    ? size.getW(12)
                                                    : size.getW(16),
                                              ),
                                              if (e.additionalValue is String)
                                                Flexible(
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Text(
                                                      e.additionalValue,
                                                      style: TextStyle(
                                                        fontSize: size.isProt
                                                            ? size.getW(12)
                                                            : size.getS(16),
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                            ],
                                          ))
                                      .toList(),
                              onChanged: (p0) {
                                tableResv.phoneCodeIndex = p0;
                                tableResv.notify;
                              },
                              textCltr: tableResv.phoneCltr,
                            ),
                            // TitleTextForm(
                            //   pWidth: 0.24,
                            //   isReq: false,
                            //   readOnly: true,
                            //   title: LN.tableNo,
                            //   borderColor: Colors.black54,
                            //   textCltr: TextEditingController(
                            //       text: tableResv.tables.any((e) =>
                            //               tableResv.tableIdName?.any((f) =>
                            //                   f.id?.toLowerCase() ==
                            //                   e.id?.toLowerCase()) ??
                            //               false)
                            //           ? (tableResv.tables
                            //                   .firstWhere((e) =>
                            //                       tableResv.tableIdName?.any(
                            //                           (f) =>
                            //                               f.id?.toLowerCase() ==
                            //                               e.id?.toLowerCase()) ??
                            //                       false)
                            //                   .value ??
                            //               '')
                            //           : null
                            //       // tableResv.tableNoIndex == null ? null : tableResv.tables[tableResv.tableNoIndex!].value
                            //       ),
                            //   onTap: widget.onTapTable == null
                            //       ? null
                            //       : () => widget.onTapTable!(tableResv),
                            // ),
                            TitleDropDown(
                              pWidth: 0.24,
                              title: LN.occasion,
                              borderColor: Colors.black54,
                              indexVal: tableResv.ocassionIndex,
                              list: tableResv.ocassionList.isEmpty
                                  ? []
                                  : tableResv.ocassionList
                                      .map((e) => e.value ?? '')
                                      .toList(),
                              onChanged: (p0) {
                                if (p0 == null) return;
                                tableResv.ocassionIndex = p0;
                                tableResv.notify;
                              },
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text.rich(
                                  TextSpan(
                                      text: LN.noOfCus,
                                      style: TextStyle(
                                        fontSize: size.getS(18),
                                        color: Colors.black,
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
                                SizedBox(
                                  height: size.getH(8),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: size.width * 0.13,
                                      child: TextFormWidget(
                                        cltr: tableResv.adultCltr,
                                        hintText: LN.adult,
                                        borderColor: Colors.black54,
                                        borderRadius: 5,
                                        hPad: 8,
                                        isReq: true,
                                        textInputType: TextInputType.number,
                                      ),
                                    ),
                                    SizedBox(
                                      width: size.width * 0.01,
                                    ),
                                    SizedBox(
                                      width: size.width * 0.1,
                                      child: TextFormWidget(
                                        cltr: tableResv.childCltr,
                                        hintText: LN.child,
                                        borderColor: Colors.black54,
                                        borderRadius: 5,
                                        hPad: 8,
                                        isReq: false,
                                        errH: 0,
                                        textInputType: TextInputType.number,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),

                            TitleDropDown(
                              pWidth: 0.24,
                              isReq: true,
                              title: LN.orderChannel,
                              borderColor: Colors.black54,
                              indexVal: tableResv.orderChannelIndex,
                              list: tableResv.orderChannels.isEmpty
                                  ? []
                                  : tableResv.orderChannels
                                      .map((e) => e.value ?? '')
                                      .toList(),
                              onChanged: (p0) {
                                if (p0 == null) return;
                                tableResv.orderChannelIndex = p0;
                                tableResv.notify;
                              },
                            ),

                            // TitleDropDown(
                            //   pWidth: 0.24,
                            //   isReq: true,
                            //   title: LN.tableNo,

                            //   borderColor: Colors.black54,
                            //   indexVal: tableResv.tableNoIndex,
                            //   list: tableResv.tables.isEmpty
                            //       ? []
                            //       : tableResv.tables.map((e) => e.value ?? '').toList(),
                            // onChanged: (p0) {
                            //   if (p0 == null) return;
                            //   tableResv.tableNoIndex = p0;
                            //   tableResv.notify;
                            // },

                            // ),
                          ],
                        ),
                        SizedBox(
                          height: size.getH(16),
                        ),
                        TitleTextForm(
                          pWidth: double.infinity,
                          title: "Message",
                          borderColor: Colors.black54,
                          textCltr: tableResv.messageCltr,
                          isReq: false,
                          maxLines: 4,
                        ),
                        SizedBox(
                          height: size.getH(16),
                        ),
                        Row(
                          children: [
                            LoadButton(
                              onsave: tableResv.loadiing
                                  ? null
                                  : () {
                                      if (tableResv.formKey.currentState!
                                          .validate()) {
                                        showDialog(
                                            context: context,
                                            builder: (builder) => ConfirmDialog(
                                                  title: tableResv
                                                          .resvId.isNotEmpty
                                                      ? "${LN.update} ${LN.tableBooking}"
                                                      : LN.newBooking,
                                                  subTitle: tableResv
                                                          .resvId.isNotEmpty
                                                      ? LN.sureToUpTableBook
                                                      : LN.sureToBookTable,
                                                  actionText: LN.confirm,
                                                  onDelete: () async {
                                                    tableResv
                                                        .addUpData(
                                                      diaCtx: context,
                                                    )
                                                        .then((_status) {
                                                      if (_status ?? false) {
                                                        tableResv
                                                            .getCountryList();
                                                      }
                                                    });
                                                    return null;
                                                  },
                                                ));
                                      }
                                    },
                              loading: tableResv.loadiing,
                              btnText: tableResv.resvId.isNotEmpty
                                  ? LN.update
                                  : LN.bookNow,
                              width: 180,
                            ),
                            SizedBox(
                              width: size.getW(16),
                            ),
                            if (tableResv.resvId.isNotEmpty)
                              ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.red.shade700),
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.symmetric(
                                              horizontal: size.getW(24),
                                              vertical: size.getH(8)))),
                                  onPressed: () {
                                    tableResv.clear();
                                  },
                                  child: Text(
                                    LN.clear,
                                    style: TextStyle(
                                      fontSize: size.getS(16),
                                      color: Colors.white,
                                    ),
                                  ))
                          ],
                        ),
                        SizedBox(
                          height: size.getH(12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
