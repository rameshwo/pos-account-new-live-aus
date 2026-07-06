import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';

class PromoTImerSection extends StatefulWidget {
  final Function() onTimeStop;
  final Duration duration;
  const PromoTImerSection({
    super.key,
    required this.onTimeStop,
    required this.duration,
  });

  @override
  State<PromoTImerSection> createState() => _PromoTImerSectionState();
}

class _PromoTImerSectionState extends State<PromoTImerSection> {
  Timer? _timer;
  int hours = 0;
  int minutes = 0;
  int seconds = 0;

  void formatDuration() {
    final totalSeconds = widget.duration.inSeconds;

    hours = totalSeconds ~/ 3600;
    minutes = (totalSeconds % 3600) ~/ 60;
    seconds = totalSeconds % 60;
  }

  @override
  void initState() {
    super.initState();

    startTimer();
  }

  void load() {
    if (mounted) setState(() {});
  }

  void startTimer() {
    formatDuration();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds > 0) {
        seconds--;
      } else if (minutes > 0) {
        minutes--;
        seconds = 59;
      } else if (hours > 0) {
        hours--;
        minutes = 59;
        seconds = 59;
      } else {
        widget.onTimeStop();
        _timer?.cancel();
      }

      load();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String formatTime(int value) {
    return value.toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return _buildTimerCard(size);
  }

  Widget _buildTimerCard(Ssize size) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
            color: Colors.grey[300]!,
            width: size.getW(2),
            style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Spacer(),
          Text(
            'Promotion will start in',
            style: TextStyle(
                fontSize: size.getS(32),
                fontWeight: FontWeight.w600,
                color: Colors.grey[700]),
          ),
          SizedBox(height: size.getH(32)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTimeBlock(size, hours, 'Hours'),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.getH(12)),
                child: Text(':',
                    style: TextStyle(
                        fontSize: size.getS(76),
                        fontWeight: FontWeight.bold,
                        color: Colors.grey)),
              ),
              _buildTimeBlock(size, minutes, 'Minutes'),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.getH(12)),
                child: Text(':',
                    style: TextStyle(
                        fontSize: size.getS(76),
                        fontWeight: FontWeight.bold,
                        color: Colors.grey)),
              ),
              _buildTimeBlock(size, seconds, 'Seconds'),
            ],
          ),
          Spacer(flex: 2),
        ],
      ),
    );
  }

  Widget _buildTimeBlock(Ssize size, int value, String label) {
    return Column(
      children: [
        Container(
          width: size.getS(120),
          height: size.getS(120),
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              formatTime(value),
              style: TextStyle(
                fontSize: size.getS(50),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(height: size.getH(8)),
        Text(
          label,
          style: TextStyle(
              fontSize: size.getS(24),
              fontWeight: FontWeight.w500,
              color: Colors.grey[700]),
        ),
      ],
    );
  }
}
