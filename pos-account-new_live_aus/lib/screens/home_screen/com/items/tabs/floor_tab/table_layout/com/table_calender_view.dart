import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/constant/date_format_keys.dart';
import 'package:pos_account/services/database/shared_pref.dart';

class Event {
  final String? title;
  final String? adult;
  final String? child;
  String? startDate;
  String? endDate;

  Event({
    required this.title,
    this.adult,
    this.child,
    this.startDate,
    this.endDate,
  });
}

class TableCalenderView extends StatefulWidget {
  final List<Event> events;
  final String? tableName;
  const TableCalenderView({
    super.key,
    required this.events,
    this.tableName,
  });

  @override
  State<TableCalenderView> createState() => _TableCalenderViewState();
}

class _TableCalenderViewState extends State<TableCalenderView> {
  @override
  void initState() {
    setData();
    super.initState();
  }

  final eventController = EventController<Event>();
  String dateFormat = "";

  CalendarEventData<Event>? _getCalenderEventData(Event e,
      {required String description}) {
    final startDate = _getDateFromString(e.startDate);
    final endDate = _getDateFromString(e.endDate);

    if (startDate == null || endDate == null) return null;

    return CalendarEventData<Event>(
      date: startDate,
      endDate: endDate,
      startTime: startDate,
      endTime: endDate,
      event: e,
      title: e.title ?? '',
      description: description,
      titleStyle: TextStyle(
        fontSize: 16,
      ),
    );
  }

  Future<void> setData({bool isEventAdd = true}) async {
    dateFormat = await SharedPrefs.dateFormat;
    // print('date format $dateFormat');
    widget.events.forEach((e) {
      // print("${e.startDate} +++++++++++ ${e.endDate}");
      final startDate = _getDateFromString(e.startDate);
      final endDate = _getDateFromString(e.endDate);

      if (startDate == null || endDate == null) return;

      String description =
          "Adult: ${e.adult}${e.child == null || e.child == '0' ? '' : ',Child:  ${e.child}'}";

      if (startDate.getDayDifference(endDate).abs() >= 1) {
        description +=
            "\nTime:\n${CAL_DATE_TIME_FORMAT.format(startDate)} - ${CAL_DATE_TIME_FORMAT.format(endDate)}";
        // print("$_startDate ---------- $_endDate");
        final startDateEnd = DateTime(
            startDate.year, startDate.month, startDate.day, 23, 59, 59);
        final endDateStart =
            DateTime(endDate.year, endDate.month, endDate.day, 0, 0, 0);

        // print("$_startDate ------start---- $_startDateEnd");
        // print("$_endDateStart -----end----- $_endDate");

        final event1 = _getCalenderEventData(
            e
              ..startDate = GET_DATE_FORMAT(dateFormat).format(startDate)
              ..endDate = GET_DATE_FORMAT(dateFormat).format(startDateEnd),
            description: description);
        if (event1 != null) eventController.add(event1);

        final event2 = _getCalenderEventData(
            e
              ..startDate = GET_DATE_FORMAT(dateFormat).format(endDateStart)
              ..endDate = GET_DATE_FORMAT(dateFormat).format(endDate),
            description: description);
        if (event2 != null) eventController.add(event2);
      } else {
        description +=
            "\nTime:\n${CAL_TIME_FORMAT.format(startDate)} - ${CAL_TIME_FORMAT.format(endDate)}";
        final event = _getCalenderEventData(e, description: description);
        // Future.delayed(Duration(milliseconds: 200), () {
        if (event != null) eventController.add(event);
        // setState(() {});
        // });
      }
    });
  }

  @override
  void dispose() {
    eventController.dispose();
    super.dispose();
  }

  DateTime? _getDateFromString(String? date) {
    // print('Date Format : $dateFormat --------- Date : $date');
    if (date == null || date.isEmpty) return DateTime.now();

    try {
      return GET_DATE_FORMAT(dateFormat).parse(date);
    } catch (e) {
      // print('Error: Date Format :: $e');
      String newDateFormat = dateFormat.substring(0, date.length);
      // print(
      //     'Error Solve Date Format : $dateFormat to $_newDateFormat on $date');
      try {
        return GET_DATE_FORMAT(newDateFormat).parse(date);
      } catch (f) {
        // print('Double Error: Date Format :: $f');
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return Container(
      constraints: BoxConstraints(
        maxHeight: size.height / 1.3,
        minHeight: size.height / 5,
      ),
      width: size.width / 1.4,
      child: Column(
        children: [
          // Row(
          //   children: [
          //     Text('Month'),
          //     Text('Week'),
          //     Text('Day'),
          //   ],
          // ),
          Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 12),
                child: Text(
                  widget.tableName ?? '',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: kFontFMedium,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close)),
              )
            ],
          ),
          Expanded(child: _weekView()),
        ],
      ),
    );
  }

  Widget _weekView() {
    return WeekView<Event>(
      controller: eventController,
      headerStringBuilder: (time1, {DateTime? secondaryDate}) =>
          "${CAL_WEEK_FORMAT1.format(time1)}${secondaryDate == null ? '' : CAL_WEEK_FORMAT2.format(secondaryDate)}",
      headerStyle: HeaderStyle(
          headerTextStyle: TextStyle(fontSize: 18, fontFamily: kFontFMedium)),
      timeLineBuilder: (ctx) {
        return Text(
          CAL_TIME_FORMAT1.format(ctx),
          style: TextStyle(
            fontSize: 16,
            // color:
            //     _.hour > 8 && _.hour < 24 ? Colors.blue.shade600 : Colors.grey,
            // fontFamily: kFontFMedium,
          ),
          textAlign: TextAlign.right,
        );
      },
      timeLineOffset: 10,
      timeLineWidth: 80,
      // heightPerMinute: 1.1,
      eventTileBuilder: (date, events, boundry, start, end) {
        return PopupMenuButton(
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                  padding: EdgeInsets.zero,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                    // color: Colors.blue,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text.rich(TextSpan(text: "Customer: ", children: [
                          TextSpan(
                            text: events.first.title,
                            style: TextStyle(
                                color: Colors.blue.shade700,
                                fontFamily: kFontFMedium,
                                fontSize: 16),
                          )
                        ])),
                        // Text(
                        //   "Customer: ${events.first.title}",
                        //   style: TextStyle(
                        //       color: Colors.blue.shade700,
                        //       fontFamily: kFontFMedium,
                        //       fontSize: 16),
                        //   textAlign: TextAlign.center,
                        // ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          events.first.description ?? "",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: kFontFMedium,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ))
            ];
          },
          child: Container(
            color: Colors.blue,
            child: Column(
              children: [
                Text(
                  events.first.title,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: kFontFMedium,
                      fontSize: 14),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
                Flexible(
                  child: Text(
                    events.first.description ?? "",
                    style: TextStyle(color: Colors.white, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      // showLiveTimeLineInAllDays: true,
      minDay: DateTime.now().subtract(Duration(days: 7)),
      maxDay: DateTime.now().add(Duration(days: 10000)),
      initialDay: DateTime.now(),
      // heightPerMinute: 1, // height occupied by 1 minute time span.
      // eventArranger:
      //     SideEventArranger(), // To define how simultaneous events will be arranged.
      // onEventTap: (events, date) => print(events),
      // onDateLongPress: (date) => print(date),
      startDay: WeekDays.sunday,
    );
  }

  // Widget _monthView() {
  //   return MonthView<Event>(
  //     controller: eventController,
  //     // cellBuilder: (date, events, isToday, isInMonth) {
  //     //   if (events.isNotEmpty)
  //     //     return Container(
  //     //       // height: 40,
  //     //       color: Colors.blue,
  //     //       child: Text(
  //     //         events.first.title,
  //     //         style: TextStyle(color: Colors.white),
  //     //       ),
  //     //     );
  //     //   else
  //     //     return SizedBox.shrink();
  //     // },
  //     minMonth: DateTime.now().subtract(Duration(days: 7)),
  //     maxMonth: DateTime.now().add(Duration(days: 10000)),
  //     initialMonth: DateTime.now(),
  //     cellAspectRatio: 1.25,
  //     onPageChange: (date, pageIndex) => print("$date, $pageIndex"),
  //     onCellTap: (events, date) {
  //       // Implement callback when user taps on a cell.
  //       print(events);
  //     },
  //     startDay: WeekDays.sunday, // To change the first day of the week.
  //     // This callback will only work if cellBuilder is null.
  //     onEventTap: (event, date) => print(event),
  //     onDateLongPress: (date) => print(date),
  //   );
  // }
}
