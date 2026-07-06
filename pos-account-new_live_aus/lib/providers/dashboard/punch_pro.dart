import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:pos_account/config/utils/map_utils.dart';
import 'package:pos_account/constant/date_format_keys.dart';
import 'package:pos_account/model/home/employee/break_end_req.dart';
import 'package:pos_account/model/home/employee/break_start_req.dart';
import 'package:pos_account/model/home/employee/check_in_req.dart';
import 'package:pos_account/model/home/employee/check_out_req.dart';
import 'package:pos_account/model/home/employee/employee_by_code_res.dart';
import 'package:pos_account/model/home/employee/shift_status.dart';
import 'package:pos_account/repository/handler.dart';
import 'package:pos_account/services/database/shared_pref.dart';

class PunchPro extends ChangeNotifier {
  void get notify => notifyListeners();
  String dateFormat = "";
  bool buttonLoad = false;
  // Position? _location;
  LocData? _locData;

  // final codeCltr = TextEditingController();
  // String dateTime = "";

  // bool loading = true;

  // void clear() {
  //   loading = true;
  //   buttonLoad = false;
  //   dateTime = "";
  //   codeCltr.clear();
  //   punchInOutData = null;
  // }

  // PunchInOutReq? punchInOutData;

  // Future<void> getPunchData({
  //   bool refresh = false,
  //   bool accessLocation = true,
  // }) async {
  //   if (refresh) {
  //     loading = true;
  //     notify;
  //   }

  //   dateFormat = await SharedPrefs.dateFormat;

  //   if (accessLocation) {
  //     _location = await MapUtils.getCurrentLocation();
  //   }

  //   punchInOutData = await Handler.getEmpPunchData(code: codeCltr.text);
  //   punchInOutData?.timeDiff = _calculateTimeDifference;

  //   // codeCltr.text = punchInOutData?.code ?? '';
  //   dateTime = punchInOutData?.currentDate ?? '';

  //   loading = false;
  //   notify;
  // }

  // Future<bool?> punch() async {
  //   loading = true;
  //   buttonLoad = true;
  //   notify;

  //   String _code = codeCltr.text;

  //   if (_code.isEmpty) {
  //     _code = punchInOutData?.code ?? '';
  //   }

  //   _location ??= await MapUtils.getCurrentLocation();

  //   final _status = await Handler.punchInOut(
  //     code: _code,
  //     lat: _location?.latitude,
  //     long: _location?.longitude,
  //   );

  //   loading = false;
  //   buttonLoad = false;
  //   notify;

  //   return _status;
  // }

  // String? get _calculateTimeDifference {
  //   DateTime? _currentDate;

  //   if (punchInOutData?.currentDate?.isNotEmpty ?? false) {
  //     _currentDate =
  //         DateFormat(dateFormat).parse(punchInOutData?.currentDate ?? '');
  //   }

  //   DateTime? _dateTime;

  //   if (punchInOutData?.date?.isNotEmpty ?? false) {
  //     _dateTime = DateFormat(dateFormat).parse(punchInOutData!.date!);
  //   }

  //   if (_currentDate != null && _dateTime != null) {
  //     final difference = _currentDate.difference(_dateTime);

  //     final int hours = difference.inHours;
  //     final int minutes = difference.inMinutes % 60;

  //     return (hours > 0 ? '$hours hours ' : '') +
  //         (minutes > 0 ? '$minutes minutes' : '');
  //   }
  //   return null;
  // }

  /// new

  bool pageLoad = false;

  void clearAll() {
    pageLoad = false;
    employeByCodeRes = null;
    shiftStatus = null;
    noteCltr.clear();
  }

  EmployeByCodeRes? employeByCodeRes;
  EmployeShiftStatus? shiftStatus;

  final noteCltr = TextEditingController();
  String curSym = "";

  Future<bool> getEmployeeByCode({String? code}) async {
    dateFormat = await SharedPrefs.dateFormat;
    curSym = await SharedPrefs.curSym;
    if (code == null) return false;

    pageLoad = true;
    notify;

    employeByCodeRes = await Handler.getEmployeeByCode(code: code);

    if (employeByCodeRes != null) {
      await checkStatus();
    }

    MapUtils.getCurrentLocation().then((value) => _locData = value);

    pageLoad = false;
    notify;

    return employeByCodeRes != null;
  }

  Duration? totalBreakTime;

  Future<void> checkStatus() async {
    totalBreakTime = null;

    shiftStatus =
        await Handler.checkShiftStatus(employeeId: employeByCodeRes?.id);

    try {
      if (shiftStatus?.takenBreaks?.isNotEmpty ?? false) {
        for (final e in shiftStatus!.takenBreaks!) {
          final end = e.end?.isNotEmpty ?? false
              ? GET_DATE_FORMAT(dateFormat).parse(e.end ?? '')
              : null;
          final start = e.start?.isNotEmpty ?? false
              ? GET_DATE_FORMAT(dateFormat).parse(e.start ?? '')
              : null;
          if (start != null && end != null) {
            totalBreakTime = Duration(
                seconds: (totalBreakTime?.inSeconds ?? 0) +
                    end.difference(start).inSeconds);
          }
        }
      }
    } catch (e) {
      //
    }
  }

  Future<void> checkIn() async {
    final checkInTime = GET_DATE_FORMAT(dateFormat).format(DateTime.now());

    pageLoad = true;
    buttonLoad = true;
    notify;

    _locData = await MapUtils.getCurrentLocation();

    final req = EmployeeCheckInReq(
      employeeId: employeByCodeRes?.id,
      checkInTime: checkInTime,
      notes: noteCltr.text,
      shiftId: shiftStatus?.shiftId,
      // latitude: "27.6980699",
      // longitude: "85.3318085",
      latitude: _locData?.latitude.toString(),
      longitude: _locData?.longitude.toString(),
    );
    final status = await Handler.employeeCheckIn(req: req);

    if (status != null) {
      SharedPrefs.setemployeeId = employeByCodeRes?.id ?? '';
      await checkStatus();
    }

    pageLoad = false;
    buttonLoad = false;
    notify;
  }

  Future<void> checkOut({
    bool isComplete = true,
  }) async {
    final checkOutTime = GET_DATE_FORMAT(dateFormat).format(DateTime.now());

    pageLoad = true;
    buttonLoad = true;
    notify;

    _locData = await MapUtils.getCurrentLocation();

    final req = EmployeeCheckOutReq(
      attendanceId: shiftStatus?.attendanceId,
      checkOutTime: checkOutTime,
      isCompleted: isComplete,
      shiftId: isComplete ? shiftStatus?.shiftId : null,
      // latitude: "27.6980699",
      // longitude: "85.3318085",
      latitude: _locData?.latitude.toString(),
      longitude: _locData?.longitude.toString(),
    );
    final status = await Handler.employeeCheckOut(req: req);

    if (status ?? false) {
      await checkStatus();
    }

    pageLoad = false;
    buttonLoad = false;
    notify;
  }

  Future<void> startBreak({String? breakId}) async {
    final breakTime = GET_DATE_FORMAT(dateFormat).format(DateTime.now());

    pageLoad = true;
    buttonLoad = true;
    notify;

    _locData = await MapUtils.getCurrentLocation();

    final req = EmployeeBreakStartReq(
      employeeId: employeByCodeRes?.id,
      attendanceId: shiftStatus?.attendanceId,
      notes: noteCltr.text,
      breakStartTime: breakTime,
      storeBreakId: breakId,
      // latitude: "27.6980699",
      // longitude: "85.3318085",
      latitude: _locData?.latitude.toString(),
      longitude: _locData?.longitude.toString(),
    );
    final status = await Handler.employeeBreakStart(req: req);

    if (status != null) {
      await checkStatus();
    }

    pageLoad = false;
    buttonLoad = false;
    notify;
  }

  Future<void> endBreak() async {
    final breakTime = GET_DATE_FORMAT(dateFormat).format(DateTime.now());

    pageLoad = true;
    buttonLoad = true;
    notify;

    _locData = await MapUtils.getCurrentLocation();

    final req = EmployeBreakEndReq(
      breakId: shiftStatus?.breakId,
      breakEndTime: breakTime,
      // latitude: "27.6980699",
      // longitude: "85.3318085",
      latitude: _locData?.latitude.toString(),
      longitude: _locData?.longitude.toString(),
    );
    final status = await Handler.employeeBreakEnd(req: req);

    if (status != null) {
      await checkStatus();
    }

    pageLoad = false;
    buttonLoad = false;
    notify;
  }
}
