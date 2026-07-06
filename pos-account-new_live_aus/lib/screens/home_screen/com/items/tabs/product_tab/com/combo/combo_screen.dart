import 'package:flutter/material.dart';

import 'combo_tab/combo_tab.dart';
import 'create_up/create_up_combo.dart';

class ComboScreen extends StatefulWidget {
  final Function()? onBackMain;
  const ComboScreen({
    super.key,
    this.onBackMain,
  });

  @override
  State<ComboScreen> createState() => _ComboScreenState();
}

class _ComboScreenState extends State<ComboScreen> {
  final _pageCltr = PageController();

  void _goToPage(int page) {
    _pageCltr.animateToPage(page,
        duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageCltr,
      physics: NeverScrollableScrollPhysics(),
      children: [
        AllComboTab(
          onBack: widget.onBackMain,
          onCreate: () {
            _goToPage(1);
          },
        ),
        CreateUpCombo(
          onBack: () {
            _goToPage(0);
          },
        ),
      ],
    );
  }
}
