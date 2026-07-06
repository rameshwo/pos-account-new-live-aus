import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/constant/date_format_keys.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/dashboard/punch_pro.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/pin_lock/time_date_sec.dart';
import 'shift_break_end_sec.dart';
import 'time_section.dart';

class StartShiftSec extends StatelessWidget {
  final PunchPro punchPro;
  final Function() back;
  const StartShiftSec({super.key, required this.punchPro, required this.back});

  String convertInToTime(String? date) {
    if (date?.isNotEmpty ?? false)
      return CAL_TIME_FORMAT
          .format(GET_DATE_FORMAT(punchPro.dateFormat).parse(date ?? ''));
    return '';
  }

  String? _timeDiff(String? time1, String? time2) {
    if (time1 == null || time1.isEmpty || time2 == null || time2.isEmpty)
      return null;

    final timeDiff = GET_DATE_FORMAT(punchPro.dateFormat)
        .parse(time1)
        .difference(GET_DATE_FORMAT(punchPro.dateFormat).parse(time2));

    return TimeSection.formatDuration(timeDiff, showSecond: false);
  }

  bool _timeDiffShow(String? time1, String? time2) {
    if (time1 == null || time1.isEmpty || time2 == null || time2.isEmpty)
      return false;

    final timeDiff = GET_DATE_FORMAT(punchPro.dateFormat)
        .parse(time1)
        .difference(GET_DATE_FORMAT(punchPro.dateFormat).parse(time2));

    return timeDiff.inSeconds > 60;
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);

    return Container(
      // width: size.getW(400),
      padding: EdgeInsets.symmetric(horizontal: size.getW(6)),
      // decoration: BoxDecoration(
      //   color: kSecondaryColor.withAlpha(50),
      //   borderRadius: BorderRadius.circular(20),
      // ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          punchPro.pageLoad
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.getW(24)),
                  child: LinearProgressIndicator(),
                )
              : SizedBox(height: 4),
          if (punchPro.employeByCodeRes != null) ...[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: () {
                        punchPro.clearAll();
                        back();
                      },
                      icon: Icon(Icons.arrow_back)),
                  // SizedBox(height: size.getH(40)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: size.getW(48)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                              text:
                                  "Hello, ${punchPro.employeByCodeRes?.fullName ?? 'Unknown'}",
                              children: [
                                if (punchPro.employeByCodeRes?.jobTitle
                                        ?.isNotEmpty ??
                                    false)
                                  TextSpan(
                                    text:
                                        " (${punchPro.employeByCodeRes?.jobTitle ?? ''})",
                                    style: TextStyle(
                                      color: kPrimaryColor,
                                      fontFamily: kFontFMedium,
                                      fontSize: size.getS(16),
                                      height: 1,
                                    ),
                                  )
                              ]),
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontFamily: kFontFMedium,
                            fontSize: size.getS(28),
                          ),
                        ),
                        // Text(
                        //   punchPro.employeByCodeRes?.jobTitle ?? '',
                        //   style: TextStyle(
                        //     color: kPrimaryColor,
                        //     fontFamily: kFontFMedium,
                        //     fontSize: size.getS(18),
                        //     height: 1,
                        //   ),
                        // ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: size.getW(48)),
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // SizedBox(height: size.getH(12)),
                          if (punchPro.shiftStatus?.breakId?.isNotEmpty ??
                              false) ...[
                            Text(
                              "${convertInToTime(punchPro.shiftStatus?.checkInTime)}-${CAL_TIME_FORMAT.format(DateTime.now())}",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: kFontFMedium,
                                fontWeight: FontWeight.bold,
                                fontSize: size.getS(18),
                              ),
                            ),
                            // if (!(punchPro.shiftStatus?.isShiftInToday ??
                            //     false))
                            Text(
                              LN.onBreak,
                              style: TextStyle(
                                color: Colors.black87,
                                fontFamily: kFontFMedium,
                                fontSize: size.getS(24),
                              ),
                            ),
                            if (punchPro.shiftStatus?.takenBreaks?.any(
                                    (e) => e.end == null || e.end!.isEmpty) ??
                                false)
                              Builder(builder: (_) {
                                final breakTitle = punchPro
                                    .shiftStatus?.takenBreaks
                                    ?.firstWhere(
                                        (e) => e.end == null || e.end!.isEmpty)
                                    .name;

                                final isPaid = punchPro.shiftStatus?.storeBreaks
                                            ?.any(
                                                (e) => e.name == breakTitle) ??
                                        false
                                    ? punchPro.shiftStatus?.storeBreaks
                                        ?.firstWhere(
                                            (e) => e.name == breakTitle)
                                        .isPaid
                                    : null;
                                return fadeBack(
                                  size,
                                  child: Text(
                                    "$breakTitle${isPaid == null ? '' : " (${isPaid ? LN.paid : LN.unpaid})"}",
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontFamily: kFontFMedium,
                                      fontSize: size.getS(24),
                                    ),
                                  ),
                                );
                              }),
                            SizedBox(height: 4),
                            fadeBack(
                              size,
                              child: TimeSection(
                                dateFormat: punchPro.dateFormat,
                                time: punchPro.shiftStatus?.breakInTime,
                                textColor: Colors.red.shade700,
                              ),
                            ),
                            SizedBox(height: size.getH(48)),
                            Align(
                              alignment: Alignment.centerRight,
                              child: LoadButton(
                                btnText: LN.endBreak,
                                btnColor: Colors.white,
                                textColor: kSecondaryColor,
                                loading: punchPro.buttonLoad,
                                width: 200,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: BorderSide(color: kSecondaryColor)),
                                onsave: punchPro.pageLoad
                                    ? null
                                    : () {
                                        punchPro.endBreak();
                                      },
                              ),
                            ),
                          ] else if (punchPro
                                  .shiftStatus?.attendanceId?.isNotEmpty ??
                              false) ...[
                            if (punchPro.shiftStatus?.isShiftInToday ??
                                false) ...[
                              Text(
                                "${convertInToTime(punchPro.shiftStatus?.shiftStartTime)}-${convertInToTime(punchPro.shiftStatus?.shiftEndTime)}",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: kFontFMedium,
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.getS(18),
                                ),
                              ),
                              if (_timeDiffShow(
                                  punchPro.shiftStatus?.checkInTime,
                                  punchPro.shiftStatus?.shiftStartTime)) ...[
                                if (punchPro.shiftStatus?.isLate ?? false)
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: size.getH(12)),
                                    child: Text(
                                      "${_timeDiff(punchPro.shiftStatus?.checkInTime, punchPro.shiftStatus?.shiftStartTime)} Late",
                                      style: TextStyle(
                                        color: Colors.red.shade700,
                                        fontFamily: kFontFMedium,
                                        fontWeight: FontWeight.bold,
                                        fontSize: size.getS(22),
                                      ),
                                    ),
                                  )
                                else if (punchPro.shiftStatus?.isEarly ?? false)
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: size.getH(12)),
                                    child: Text(
                                      "${_timeDiff(punchPro.shiftStatus?.shiftStartTime, punchPro.shiftStatus?.checkInTime)} Early",
                                      style: TextStyle(
                                        color: Colors.green.shade700,
                                        fontFamily: kFontFMedium,
                                        fontWeight: FontWeight.bold,
                                        fontSize: size.getS(22),
                                      ),
                                    ),
                                  )
                              ]
                            ] else ...[
                              Text(
                                "${convertInToTime(punchPro.shiftStatus?.checkInTime)}-${CAL_TIME_FORMAT.format(DateTime.now())}",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: kFontFMedium,
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.getS(18),
                                ),
                              ),
                              Text(
                                LN.onUnscheduledShift,
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontFamily: kFontFMedium,
                                  fontSize: size.getS(20),
                                ),
                              )
                            ],
                            fadeBack(
                              size,
                              width: 600,
                              child: TimeSection(
                                dateFormat: punchPro.dateFormat,
                                time: punchPro.shiftStatus?.checkInTime,
                                totalBreakTime: punchPro.totalBreakTime,
                              ),
                            ),
                            ShiftUpdateSec(punchPro: punchPro, back: back)
                          ] else
                            _startShift(size),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget _startShift(Ssize size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (punchPro.shiftStatus?.isShiftInToday ?? false) ...[
          TimeSection(
            dateFormat: punchPro.dateFormat,
            time: punchPro.shiftStatus?.shiftStartTime,
            // textWith: (punchPro.shiftStatus?.isLate ?? false)
            //     ? ' Late'
            //     : (punchPro.shiftStatus?.isEarly ?? false)
            //         ? ' Early'
            //         : '',
            // textColor: (punchPro.shiftStatus?.isLate ?? false)
            //     ? Colors.red.shade700
            //     : kPrimaryColor,
            textWithColor: TextWithColor(
              text1: ' ${LN.late}',
              text2: ' ${LN.early}',
              color1: Colors.red.shade700,
              color2: kPrimaryColor,
            ),
          ),
          if (punchPro.shiftStatus?.shiftStartTime != null &&
              punchPro.shiftStatus?.shiftEndTime != null)
            Text.rich(
              TextSpan(
                text: "${LN.shiftTime} : ",
                children: [
                  TextSpan(
                    text:
                        "${convertInToTime(punchPro.shiftStatus?.shiftStartTime)}-${convertInToTime(punchPro.shiftStatus?.shiftEndTime)}",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: kFontFMedium,
                      fontWeight: FontWeight.bold,
                      fontSize: size.getS(18),
                    ),
                  )
                ],
              ),
              style: TextStyle(
                color: Colors.black,
                fontSize: size.getS(18),
              ),
              // textAlign: TextAlign.center,
            ),
        ] else ...[
          Text(
            LN.noScheduledShifts,
            style: TextStyle(
              color: kPrimaryColor,
              fontFamily: kFontFMedium,
              fontWeight: FontWeight.bold,
              fontSize: size.getS(20),
            ),
          )
        ],
        ...[
          SizedBox(height: size.getH(12)),
          Row(
            children: [
              Icon(
                Icons.access_time_filled,
                color: kSecondaryColor,
                size: size.getS(24),
              ),
              SizedBox(width: size.getW(4)),
              Text(
                LN.startingAt,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: kFontFMedium,
                  fontSize: size.getS(18),
                  // height: 1,
                ),
              ),
            ],
          ),
          fadeBack(size,
              child: TimeDateSec(
                background: Colors.transparent,
                fontRatio: 0.8,
                isCenterAlign: false,
                showDate: false,
              ))
        ],
        if (punchPro.shiftStatus?.shiftBreaks?.isNotEmpty ?? false) ...[
          SizedBox(height: size.getH(12)),
          Row(
            children: [
              Icon(
                Icons.coffee,
                color: kSecondaryColor,
                size: size.getS(24),
              ),
              SizedBox(width: size.getW(4)),
              Text(
                LN.scheduledBreaks,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: kFontFMedium,
                  fontSize: size.getS(18),
                  // height: 1,
                ),
              ),
            ],
          ),
          ...List.generate(punchPro.shiftStatus!.shiftBreaks!.length, (index) {
            // ignore: no_leading_underscores_for_local_identifiers
            final _break = punchPro.shiftStatus!.shiftBreaks![index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StartShiftSec.fadeBack(
                  size,
                  child: Text(
                    "${_break.name}${(_break.isPaid ?? false) ? ' (${LN.paid})' : ' (${LN.unpaid})'}",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: kFontFMedium,
                      fontSize: size.getS(18),
                    ),
                  ),
                ),
                SizedBox(height: size.getH(4)),
              ],
            );
          })
        ],
        SizedBox(height: size.getH(24)),
        TextFormWidget(
          borderColor: Colors.white,
          maxLines: 5,
          cltr: punchPro.noteCltr,
          hintText: LN.addNote,
        ),
        // SizedBox(height: size.getH(24)),
        // Text(
        //   'Once you clock in, you won\'t be able to edit this time. Please double-check your hours before proceeding.',
        //   style: TextStyle(
        //     color: Colors.black54,
        //     // fontFamily: kFontFMedium,
        //     fontSize: size.getS(16),
        //     // height: 1,
        //   ),
        // ),
        SizedBox(height: size.getH(24)),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            LoadButton(
              btnText: LN.cancel,
              btnColor: Colors.white,
              textColor: Colors.red,
              width: 200,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Colors.red)),
              onsave: punchPro.pageLoad
                  ? null
                  : () {
                      punchPro.clearAll();
                      back();
                    },
            ),
            SizedBox(width: size.getW(16)),
            LoadButton(
              loading: punchPro.buttonLoad,
              btnText: (punchPro.shiftStatus?.isShiftInToday ?? false)
                  ? LN.startShift
                  : LN.startUnscheduledShift,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              width:
                  (punchPro.shiftStatus?.isShiftInToday ?? false) ? 200 : 240,
              hPad: 4,
              onsave: punchPro.pageLoad
                  ? null
                  : () {
                      punchPro.checkIn();
                    },
            ),
          ],
        )
      ],
    );
  }

  static Widget fadeBack(
    Ssize size, {
    required Widget child,
    double width = 400,
  }) {
    return Container(
      width: size.getW(width),
      padding: EdgeInsets.symmetric(
          horizontal: size.getW(16), vertical: size.getH(16)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        // border: Border.all(color: Colors.black.withAlpha(60)),
        gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              //begin color
              kSecondaryColor.withAlpha(45),
              //end color
              kSecondaryColor.withAlpha(0),
            ]),
      ),
      child: child,
    );
  }

  // Widget _listWidget(Ssize size) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: kSecondaryColor,
  //       borderRadius: BorderRadius.circular(5),
  //     ),
  //     child: Container(
  //       margin: EdgeInsets.only(left: size.getW(4)),
  //       decoration: BoxDecoration(
  //         color: Colors.white70,
  //         borderRadius: BorderRadius.circular(5),
  //       ),
  //       padding: EdgeInsets.symmetric(
  //           horizontal: size.getW(16), vertical: size.getH(12)),
  //       child: Row(
  //         children: [
  //           Expanded(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   "Total Hours",
  //                   style: TextStyle(
  //                     color: kPrimaryColor,
  //                     fontFamily: kFontFMedium,
  //                     fontSize: size.getS(15),
  //                   ),
  //                 ),
  //                 Text(
  //                   "08:00:00 hrs",
  //                   style: TextStyle(
  //                     color: kPrimaryColor,
  //                     fontFamily: kFontFMedium,
  //                     fontWeight: FontWeight.bold,
  //                     fontSize: size.getS(15),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           Expanded(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   "Check In & Out",
  //                   style: TextStyle(
  //                     color: kPrimaryColor,
  //                     fontFamily: kFontFMedium,
  //                     fontSize: size.getS(15),
  //                   ),
  //                 ),
  //                 Text(
  //                   "08:00 AM - 08:00 PM",
  //                   style: TextStyle(
  //                     color: kPrimaryColor,
  //                     fontFamily: kFontFMedium,
  //                     fontWeight: FontWeight.bold,
  //                     fontSize: size.getS(15),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
