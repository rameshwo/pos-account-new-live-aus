import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/constant/date_format_keys.dart';
import 'dart:async';

import 'package:pos_account/widgets/header_logo.dart';

class TimeDateSec extends StatefulWidget {
  final Color? background;
  final double fontRatio;
  final bool isCenterAlign;
  final bool showDate;
  final bool showLogo;
  const TimeDateSec({
    super.key,
    this.background,
    this.fontRatio = 1,
    this.isCenterAlign = true,
    this.showDate = true,
    this.showLogo = false,
  });

  @override
  _TimeDateSecState createState() => _TimeDateSecState();
}

class _TimeDateSecState extends State<TimeDateSec> {
  late Timer _timer;
  // String _hr = "";
  // String _min = "";
  // String _sec = "";

  @override
  void initState() {
    super.initState();
    _updateTime(); // Initialize the time
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      _updateTime();
    });
  }

  void _updateTime() {
    // final _currentTime = GET_TIME.format(DateTime.now()).split(':');

    // _hr = _currentTime[0];
    // _min = _currentTime[1];
    // _sec = _currentTime[2];
    load();
  }

  void load() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final time = CAL_TIME_FORMAT.format(DateTime.now()).split(' ');
    return Container(
      // width: size.getW(100),
      decoration: BoxDecoration(
        color: widget.background ?? kSecondaryColor.withAlpha(50),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: widget.isCenterAlign
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          if (widget.showLogo) ...[Spacer(), HeaderLogo(height: 120), Spacer()],
          Text.rich(
            TextSpan(text: time.first, children: [
              // TextSpan(
              //   text: ':',
              //   style: TextStyle(
              //       fontSize: size.getS(84 * widget.fontRatio),
              //       letterSpacing: 16),
              // ),
              // TextSpan(text: _min),
              TextSpan(
                text: " ${time.last}",
                style: TextStyle(fontSize: size.getS(36 * widget.fontRatio)),
              )
            ]),
            style: TextStyle(
              color: kPrimaryColor,
              fontFamily: kFontFMedium,
              fontWeight: FontWeight.bold,
              fontSize: size.getS(80 * widget.fontRatio),
              height: 1,
            ),
          ),
          if (widget.showDate)
            Text(
              DATE_FORMAT.format(DateTime.now()),
              // "Tuesday, 29 Mar 2022",
              style: TextStyle(
                color: kPrimaryColor,
                fontFamily: kFontFMedium,
                fontSize: size.getS(28 * widget.fontRatio),
              ),
            ),
          if (widget.showLogo) Spacer(flex: 3),
        ],
      ),
    );
  }
}
