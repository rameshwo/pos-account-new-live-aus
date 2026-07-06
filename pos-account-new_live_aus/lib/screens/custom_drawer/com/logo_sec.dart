import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/constant/date_format_keys.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/widgets/header_logo.dart';
import '../../../config/utils/internet_utils.dart';
import '../../../services/signal_core/signalr_core.dart';

class LogoSection extends StatefulWidget {
  final Ssize size;
  final Function()? onTap;
  final double radius;
  final bool isAuth;
  const LogoSection({
    super.key,
    required this.size,
    this.onTap,
    this.radius = 72,
    this.isAuth = true,
  });

  @override
  State<LogoSection> createState() => _LogoSectionState();
}

class _LogoSectionState extends State<LogoSection> {
  Widget get errorImage => Image.asset(
        "assets/png/pos-logo.png",
        width: widget.size.getS(widget.radius),
        height: widget.size.getS(widget.radius),
        // fit: BoxFit.cover,
      );

  DateTime _now = DateTime.now();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _alignToNextMinute();
  }

  void _alignToNextMinute() {
    final now = DateTime.now();

    final int msToNextMinute = (60 - now.second) * 1000 - now.millisecond;

    // First alignment using Future.delayed
    Future.delayed(Duration(milliseconds: msToNextMinute), () {
      if (!mounted) return;

      setState(() {
        _now = DateTime.now();
      });

      // Start ONE periodic timer after alignment
      _timer = Timer.periodic(const Duration(minutes: 1), (_) {
        if (!mounted) return;

        setState(() {
          _now = DateTime.now();
        });
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: Duration(milliseconds: 400),
        // margin: EdgeInsets.symmetric(vertical: size.getH(20)),
        width: widget.size.getW(200), // size.getS(radius),
        height: widget.size.getH(82.85), // size.getS(radius),
        color: Colors.transparent,
        child: Center(
          child: InkWell(
              // highlightColor: Colors.transparent,
              // splashColor: Colors.transparent,
              borderRadius: BorderRadius.circular(5),
              onTap: widget.isAuth
                  ? () {
                      if (widget.onTap != null) widget.onTap!();
                      GlobalCVP.setMainPage = MainPage.HomePage;
                      GlobalCVP.setCurrentPage(0);
                      GlobalCVP.notify;
                    }
                  : null,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Image.asset(
                        //   "assets/png/pos-logo.png",
                        //   width: widget.size.getS(48),
                        //   height: widget.size.getS(48),
                        // ),
                        // SizedBox(width: widget.size.getW(8)),
                        Flexible(child: HeaderLogo()),
                      ],
                    ),
                  ),
                  Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          DATE_TIME_FORMAT.format(_now),
                          // "Tuesday, 29 Mar 2022",
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontFamily: kFontFMedium,
                            fontSize: widget.size.getS(15),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      if (widget.isAuth) _status(),
                    ],
                  )
                ],
              )),
        ));
  }

  Widget _status() {
    final _status = SignalRCore.status == ConnectionStatus.Online;
    final _isNetSlow = InternetUtils.status == InternetStatus.Slow;
    return Padding(
      padding: EdgeInsets.only(left: widget.size.getW(12)),
      child: Text(
        "●",
        style: TextStyle(
          fontSize: widget.size.getS(28),
          color: _status
              ? (_isNetSlow ? Colors.amber.shade700 : Colors.green)
              : Colors.grey,
          height: 0, //-0.1,
        ),
      ),
    );
  }
}
