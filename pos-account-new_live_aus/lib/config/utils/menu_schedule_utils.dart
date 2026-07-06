import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/menu/place_order/menu_schedule_res.dart';
import 'package:pos_account/repository/handler.dart';
import 'package:pos_account/widgets/loading.dart';

class MenuScheduleUtils {
  static List<MenuScheduleRes>? _menuScheduleList;
  static List<MenuScheduleRes>? get menuScheduleList => _menuScheduleList;
  static String? lastActiveKey;

  static Future<void> _getServerData({bool isServerCall = true}) async {
    stopChecking();
    lastActiveKey = null;

    if (isServerCall) {
      _menuScheduleList = await Handler.getMenuSchedule();
    } else {
      _menuScheduleList ??= await Handler.getMenuSchedule();
    }
  }

  static Timer? _timer;

  // static DateTime? _lastListenTime;

  static Future<void> runFun(
    Future<void> Function(List<MenuSchedule> slot) hit, {
    bool enableCloseTimeCheck = true,
  }) async {
    await _checkCurrentSchedule((List<MenuSchedule> slot) async {
      for (final a in slot)
        kPrint("New time range started: ${a.timeFrom} - ${a.timeTo}");

      final _showAutoRefresh = !enableCloseTimeCheck;

      if (_showAutoRefresh)
        Loading.dialog(
          CUS_CTX!,
          title: "Updating Menu",
          width: 200,
          height: 200,
        );

      await hit(slot);

      if (_showAutoRefresh && Navigator.canPop(CUS_CTX!)) {
        Navigator.pop(CUS_CTX!);
      }
    });
  }

  static Future<void> listen(
    Future<void> Function(List<MenuSchedule> slot) hit, {
    bool enableCloseTimeCheck = true,
    bool isServerCall = true,
  }) async {
    // _lastListenTime = DateTime.now();

    await _getServerData(isServerCall: isServerCall);

    // Check every 10 seconds
    _timer = Timer.periodic(const Duration(seconds: 10), (_) {
      // kPrint("Time Checking ${DateTime.now()}");
      runFun(hit, enableCloseTimeCheck: enableCloseTimeCheck);
    });
    runFun(hit, enableCloseTimeCheck: enableCloseTimeCheck);
  }

  static void stopChecking() {
    _timer?.cancel();
  }

  static Future<void> _checkCurrentSchedule(
      Future Function(List<MenuSchedule> slot) onRangeChange) async {
    final now = DateTime.now();
    final weekDayName = _getWeekdayName(now.weekday);

    final _unScheduledKey =
        "un-scheduled-key-${now.year}-${now.month}-${now.day}";

    MenuScheduleRes? dayData;
    if (_menuScheduleList?.any(
          (d) => d.weekDayName == weekDayName,
        ) ??
        false) {
      dayData = _menuScheduleList?.firstWhere(
        (d) => d.weekDayName == weekDayName,
      );
    }

    if (dayData?.menuSchedule == null) {
      if (lastActiveKey != _unScheduledKey) {
        // 👇 Only call when entering new range
        lastActiveKey = _unScheduledKey;
        await onRangeChange([MenuSchedule()]);
      }
      return;
    }

    final _slotList = <MenuSchedule>[];

    String _slotKeys = "";

    for (var slot in dayData!.menuSchedule!) {
      final fromParts = slot.timeFrom?.split(':') ?? [];
      final toParts = slot.timeTo?.split(':') ?? [];

      final fromTime = fromParts.length == 2
          ? DateTime(now.year, now.month, now.day, int.parse(fromParts[0]),
              int.parse(fromParts[1]))
          : null;

      final toTime = toParts.length == 2
          ? DateTime(now.year, now.month, now.day, int.parse(toParts[0]),
              int.parse(toParts[1]))
          : null;

      final isInRange = fromTime != null &&
          toTime != null &&
          now.isAfter(fromTime) &&
          now.isBefore(toTime);

      final key = '$weekDayName-${slot.timeFrom}-${slot.timeTo}';

      // kPrint("1 .$isInRange..$key");

      // if (isInRange) {
      //   if (lastActiveKey != key) {
      //     // 👇 Only call when entering new range
      //     lastActiveKey = key;
      //     await onRangeChange([slot]);
      //   }
      //   return; // stop checking further slots
      // }

      if (isInRange) {
        _slotKeys += key;
        _slotList.add(slot);
      }
    }

    // kPrint(
    //     "lastActiveKey: $lastActiveKey  |  _slotKeys: $_slotKeys ${lastActiveKey == _slotKeys}");

    if (_slotKeys.isNotEmpty) {
      if (lastActiveKey != _slotKeys) {
        lastActiveKey = _slotKeys;
        await onRangeChange(_slotList);
      }
      return; // stop checking further slots
    }

    if (lastActiveKey != _unScheduledKey) {
      // 👇 Only call when entering new range
      lastActiveKey = _unScheduledKey;
      await onRangeChange([MenuSchedule()]);
    }
    return;

    // Not in any range
    // lastActiveKey = null;
  }

  static String _getWeekdayName(int weekday) {
    const names = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return names[weekday - 1];
  }
}
