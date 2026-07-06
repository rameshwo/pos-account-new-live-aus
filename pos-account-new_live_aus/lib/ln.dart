import 'package:flutter/material.dart';

import 'services/language/lang_model.dart';

LangModel get LN => LnPro._ln;

late LNProvider LnPro;

class LNProvider extends ChangeNotifier {
  LangModel _ln = DEFAULT_LANG_ENG;
  bool loading = true;

  set setLang(LangModel lang) {
    _ln = lang;
    loading = false;
    notifyListeners();
  }
}

final GlobalKey<NavigatorState> NAV_KEY = GlobalKey<NavigatorState>();

// BuildContext? _buildContext;

BuildContext? get CUS_CTX => NAV_KEY.currentContext;

// set SET_CUS_CTX(BuildContext? ctx) => _buildContext = ctx;
