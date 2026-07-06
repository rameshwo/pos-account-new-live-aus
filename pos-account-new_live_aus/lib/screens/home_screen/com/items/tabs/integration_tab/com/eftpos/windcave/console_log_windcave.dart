import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pos_account/repository/windcave/windcave_handler.dart';

import '../console_view.dart';

class ConsoleLogsWindCave extends StatefulWidget {
  const ConsoleLogsWindCave({super.key});

  @override
  State<ConsoleLogsWindCave> createState() => _ConsoleLogsWindCaveState();
}

class _ConsoleLogsWindCaveState extends State<ConsoleLogsWindCave> {
  final _cltr = ScrollController();

  void get load {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    _animateToEnd();

    super.initState();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConsoleView(
      consoleString: WindcaveHandler.wCConsoleData,
      scrollCltr: _cltr,
      onClear: () {
        WindcaveHandler.wCConsoleData = "";

        load;
      },
    );
  }
}
