import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pos_account/screens/home_screen/com/items/tabs/integration_tab/com/eftpos/console_view.dart';
import 'package:pos_account/services/web_view/inapp_web_screen.dart';

class ConsoleLogsEft extends StatefulWidget {
  const ConsoleLogsEft({super.key});

  @override
  State<ConsoleLogsEft> createState() => _ConsoleLogsEftState();
}

class _ConsoleLogsEftState extends State<ConsoleLogsEft> {
  final _cltr = ScrollController();

  String _consoleString = "";

  void get load {
    if (mounted) setState(() {});
  }

  Timer? _timer;

  @override
  void initState() {
    setData();
    _timer = Timer.periodic(Duration(seconds: 2), (_) {
      setData();
    });
    super.initState();
  }

  void setData() {
    _consoleString = "";
    for (final e in CONSOLE_lOGS) {
      _consoleString += '$e\n\n\n';
    }

    _animateToEnd();
  }

  double _scroollOffset = 0.0;

  void _animateToEnd() async {
    await Future.delayed(Duration(milliseconds: 200), () {});

    // print("${_cltr.position.pixels} ===$_scroollOffset====");
    if (_cltr.hasClients && _cltr.position.pixels == _scroollOffset) {
      load;
      await Future.delayed(Duration(milliseconds: 200), () {});

      _cltr.animateTo(_cltr.position.maxScrollExtent,
          duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
    }
    _scroollOffset = _cltr.position.maxScrollExtent;
  }

  @override
  void dispose() {
    _scroollOffset = 0.0;
    if (_timer != null) _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConsoleView(
      consoleString: _consoleString,
      scrollCltr: _cltr,
      onClear: () {
        _consoleString = "";
        CONSOLE_lOGS.clear();
        load;
      },
    );
  }
}
