import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/widgets/load_btn.dart';

import '../../../../../../../../ln.dart';

class ConsoleView extends StatelessWidget {
  final String consoleString;
  final ScrollController? scrollCltr;
  final Function()? onClear;

  const ConsoleView({
    super.key,
    required this.consoleString,
    this.scrollCltr,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.symmetric(
        vertical: size.getH(24),
        horizontal: size.getW(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: size.getW(16),
              vertical: size.getH(12),
            ),
            child: Row(
              children: [
                Text(
                  "Console Logs",
                  style: TextStyle(
                    fontFamily: kFontFMedium,
                    fontSize: size.getS(18),
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple.shade900,
                  ),
                ),
                Spacer(),
                LoadButton(
                  btnText: "Copy All",
                  vPad: 4,
                  hPad: 8,
                  fontSize: 14,
                  width: 100,
                  textColor: Colors.white,
                  btnColor: Colors.teal.shade600,
                  onsave: () {
                    Clipboard.setData(ClipboardData(text: consoleString));
                    showToast(LN.copiedToClip);
                  },
                ),
                SizedBox(width: size.getW(8)),
                LoadButton(
                  btnText: LN.clear,
                  vPad: 4,
                  hPad: 8,
                  fontSize: 14,
                  width: 100,
                  textColor: Colors.white,
                  btnColor: Colors.red,
                  onsave: onClear,
                ),
                SizedBox(width: size.getW(8)),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
          Flexible(
            child: Scrollbar(
              controller: scrollCltr,
              thumbVisibility: true,
              trackVisibility: true,
              thickness: 12,
              radius: Radius.circular(12),
              interactive: true,
              child: SingleChildScrollView(
                controller: scrollCltr,
                padding: EdgeInsets.zero,
                child: Container(
                  width: double.infinity,
                  color: Colors.grey.shade900,
                  padding: EdgeInsets.symmetric(
                    horizontal: size.getW(16),
                    vertical: size.getH(16),
                  ),
                  child: SelectableText(
                    consoleString,
                    style: TextStyle(
                      fontFamily: kFontFRegular,
                      fontSize: size.getS(15),
                      letterSpacing: 1.2,
                      color: Colors.greenAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
