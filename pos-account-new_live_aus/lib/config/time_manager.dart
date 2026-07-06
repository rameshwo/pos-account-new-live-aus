import 'dart:async';

class TimerManager {
  static final TimerManager _instance = TimerManager._internal();

  factory TimerManager() => _instance;

  Timer? _timer;
  int _elapsedSeconds = 0;
  bool _isRunning = false;

  TimerManager._internal();

  void startTimer({int initTime = 0}) {
    if (_isRunning) return;
    _isRunning = true;
    _elapsedSeconds = initTime;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _elapsedSeconds++;
    });
  }

  void stopTimer() {
    _elapsedSeconds = 0;
    if (_timer != null) _timer!.cancel();
    _isRunning = false;
  }

  int get elapsedSeconds => _elapsedSeconds;

  void resetTimer() {
    // stopTimer();
    _elapsedSeconds = -1;
  }

  String get hours {
    final int hours = _elapsedSeconds ~/ 3600;
    return _padZero(hours);
  }

  String get minutes {
    final int minutes = (_elapsedSeconds % 3600) ~/ 60;
    return _padZero(minutes);
  }

  String get seconds {
    final int seconds = _elapsedSeconds % 60;
    return _padZero(seconds);
  }

  String _padZero(int number) => number.toString().padLeft(2, '0');
}
