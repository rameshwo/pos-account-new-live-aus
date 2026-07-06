import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/constant/date_format_keys.dart';

class TextWithColor {
  final String? text1;
  final Color? color1;
  final String? text2;
  final Color? color2;

  TextWithColor({this.text1, this.color1, this.text2, this.color2});
}

class TimeSection extends StatefulWidget {
  final String dateFormat;
  final String? time;
  final Color? textColor;
  // final String? textWith;
  final TextWithColor? textWithColor;
  final Duration? totalBreakTime;
  const TimeSection({
    super.key,
    required this.dateFormat,
    this.time,
    this.textColor,
    // this.textWith,
    this.totalBreakTime,
    this.textWithColor,
  });

  @override
  State<TimeSection> createState() => _TimeSectionState();

  static String formatDuration(Duration duration, {bool showSecond = true}) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    // String sign = duration.isNegative ? "-" : "";
    Duration absDuration = duration.abs();
    String days = absDuration.inDays > 0 ? "${absDuration.inDays} day(s) " : "";
    int hours = absDuration.inHours.remainder(24);
    String minutes = twoDigits(absDuration.inMinutes.remainder(60));
    String seconds = twoDigits(absDuration.inSeconds.remainder(60));
    return "$days${hours > 0 ? '${twoDigits(hours)}h ' : ''}${minutes}m${showSecond ? " ${seconds}s" : ""}";
  }
}

class _TimeSectionState extends State<TimeSection> {
  late Timer _timer;

  void load() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      load();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get _remainTime {
    if (widget.time == null || widget.time!.isEmpty) return '';

    final startTime = GET_DATE_FORMAT(widget.dateFormat).parse(widget.time!);

    final currentTime = DateTime.now();

    if (widget.totalBreakTime != null) {
      return TimeSection.formatDuration(
          currentTime.subtract(widget.totalBreakTime!).difference(startTime));
    } else {
      return TimeSection.formatDuration(currentTime.difference(startTime));
    }
  }

  bool get _isLate {
    if (widget.time == null || widget.time!.isEmpty) return false;

    final startTime = GET_DATE_FORMAT(widget.dateFormat).parse(widget.time!);

    final currentTime = DateTime.now();

    return startTime.isBefore(currentTime);
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final textWith = widget.textWithColor != null
        ? (_isLate ? widget.textWithColor?.text1 : widget.textWithColor?.text2)
        : '';
    final textColor = widget.textWithColor != null
        ? (_isLate
            ? widget.textWithColor?.color1
            : widget.textWithColor?.color2)
        : null;
    return Text(
      _remainTime + (textWith ?? ''),
      style: TextStyle(
        color: textColor ?? widget.textColor ?? kPrimaryColor,
        fontFamily: kFontFMedium,
        fontWeight: FontWeight.bold,
        fontSize: size.getS(48),
      ),
    );
  }
}
