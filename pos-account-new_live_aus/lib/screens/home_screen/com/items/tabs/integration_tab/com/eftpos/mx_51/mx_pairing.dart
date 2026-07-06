import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/utils/internet_utils.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/constant/strings.dart';
import 'package:pos_account/constant/text_formatter.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/integration/terminal_pro.dart';
import 'package:pos_account/providers/menu/payment_pro.dart';
import 'package:pos_account/repository/if_exception.dart';
import 'package:pos_account/repository/mx/model/pair_res.dart';
import 'package:pos_account/widgets/input/dropdown/title_drop_down.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:provider/provider.dart';

class MxPairingDia extends StatefulWidget {
  const MxPairingDia({super.key});

  @override
  State<MxPairingDia> createState() => _MxPairingDiaState();

  static void updatePayTerminal() {
    GlobalCVP.getAllAddSection(isServerCall: true).then((value) {
      if (CUS_CTX != null) {
        final _payPro = Provider.of<PaymentPro>(CUS_CTX!, listen: false);
        _payPro.getData();
      }
    });
  }
}

class _MxPairingDiaState extends State<MxPairingDia> {
  final _formKey = GlobalKey<FormState>();

  // mx
  MxPairResponse? mxPairResponse;

  @override
  void dispose() {
    _terPro.terminalCltr.clear();
    _terPro.serialCltr.clear();
    _terPro.buttonLoad = false;
    // _terPro.pageLoad = true;
    super.dispose();
  }

  late TerminalPro _terPro;

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    _terPro = Provider.of<TerminalPro>(context);
    return SimpleDialog(
      backgroundColor: kBackgroundColor,
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.symmetric(
          horizontal: size.getW(12), vertical: size.getH(24)),
      children: [
        Processing(
            loading: _terPro.pageLoad,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: size.height / 1.14,
                minHeight: size.height / 5,
              ),
              width: size.width / 2.5,
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: size.getW(12), vertical: size.getH(12)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(
                              TextSpan(
                                text: "Simple Cloud Integration Pairing",
                                children: [
                                  TextSpan(
                                      text: "\nEnter Terminal pairing code",
                                      style: TextStyle(
                                        fontSize: size.getS(16),
                                        color: Colors.black54,
                                      )),
                                ],
                              ),
                              style: TextStyle(
                                fontSize: size.getS(22),
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                height: 1.4,
                              ),
                            ),
                            Spacer(),
                            Container(
                                decoration: BoxDecoration(
                                  color: Colors.red.shade800,
                                  shape: BoxShape.circle,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: size.getS(8),
                                        vertical: size.getS(8)),
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: size.getW(12)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TitleTextForm(
                              title: "Pairing nickname",
                              hintText: "Enter pairing nickname",
                              textCltr: _terPro.terminalCltr,
                              borderColor: Colors.black26,
                              vPad: 16,
                              isReq: false,
                              pWidth: 0.4,
                              readOnly: mxPairResponse != null,
                            ),
                            SizedBox(
                              height: size.getH(16),
                            ),
                            TitleDropDown(
                              pWidth: 0.4,
                              isReq: true,
                              vPad: 14,
                              title: "POS Device",
                              hintText: "Choose POS Device",
                              borderColor: mxPairResponse != null
                                  ? Colors.grey.shade200
                                  : Colors.black26,
                              fillColor: mxPairResponse != null
                                  ? Colors.grey.shade200
                                  : Colors.white,
                              indexVal: _terPro.posNameIndex,
                              list: _terPro.posDevices == null
                                  ? []
                                  : _terPro.posDevices!
                                      .map((e) =>
                                          "${e.name ?? ''} (${e.additionalValue?.toString() ?? ''})")
                                      .toList(),
                              onChanged: mxPairResponse == null
                                  ? (p0) {
                                      if (p0 == null) return;
                                      _terPro.posNameIndex = p0;
                                      _terPro.notify;
                                    }
                                  : null,
                            ),
                            SizedBox(
                              height: size.getH(16),
                            ),
                            TitleTextForm(
                              title: "Pairing code",
                              hintText: "Pairing code",
                              textCltr: _terPro.serialCltr,
                              borderColor: Colors.black26,
                              textInputType: TextInputType.number,
                              vPad: 16,
                              pWidth: 0.4,
                              readOnly: mxPairResponse != null,
                              inputFormatters: [
                                NonNegativeTextInputFormatter(),
                                FilteringTextInputFormatter.digitsOnly
                              ],
                            ),
                            SizedBox(height: size.getH(4)),
                            Text(
                              "You can get the pairing code from the terminals pairing setup",
                              style: TextStyle(
                                fontSize: size.getS(14),
                                color: Colors.black54,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: size.getH(12)),
                      if (mxPairResponse != null)
                        _buildPairingConfirmation(size,
                            confirmCode:
                                mxPairResponse?.data?.confirmationCode ?? ''),
                      SizedBox(height: size.getH(24)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          LoadButton(
                            btnText: 'Cancel',
                            btnColor: Colors.red.shade700,
                            onsave: () {
                              Navigator.pop(context);
                            },
                          ),
                          SizedBox(width: size.getW(16)),
                          if (mxPairResponse != null)
                            LoadButton(
                              btnText: LN.confirm,
                              btnColor: Colors.green.shade700,
                              loading: _terPro.buttonLoad,
                              onsave: () async {
                                _terPro.pageLoad = true;
                                _terPro.buttonLoad = true;
                                _terPro.notify;

                                final _internetStatus =
                                    await InternetUtils.getInterNetStatus;
                                if (_internetStatus) {
                                  await _terPro
                                      .saveWind(
                                          diaCtx: context,
                                          checkMxTerminal: true)
                                      .then((_status) {
                                    if (_status) {
                                      MxPairingDia.updatePayTerminal();
                                    }
                                    // Navigator.pop(context);
                                  });
                                } else {
                                  _terPro.buttonLoad = false;
                                  _terPro.pageLoad = false;
                                  _terPro.notify;
                                  IfException.showMessage(
                                    msg: Msg.Dialog,
                                    seconds: 0,
                                    autoHideSecond: 3,
                                    message:
                                        Strings.noInternetOnTerminalConnection,
                                  );
                                }
                              },
                            )
                          else
                            LoadButton(
                              btnText: LN.pair,
                              btnColor: Colors.green.shade700,
                              loading: _terPro.buttonLoad,
                              onsave: () async {
                                if (_formKey.currentState!.validate()) {
                                  mxPairResponse = await _terPro.pairMx();
                                  FocusManager.instance.primaryFocus?.unfocus();
                                }
                              },
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ))
      ],
    );
  }

  Widget _buildPairingConfirmation(Ssize size, {String confirmCode = ""}) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Color(0xFFE5E7EB)),
      ),
      margin: EdgeInsets.symmetric(
          horizontal: size.getW(12), vertical: size.getH(8)),
      child: Padding(
        padding: EdgeInsets.all(size.getS(12)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: size.getS(48),
              height: size.getS(48),
              decoration: BoxDecoration(
                color: Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width: size.getW(6),
                        height: size.getW(6),
                        decoration: BoxDecoration(
                            color: Color(0xFFF59E0B),
                            borderRadius: BorderRadius.circular(3))),
                    SizedBox(width: 2),
                    Container(
                        width: size.getW(6),
                        height: size.getW(6),
                        decoration: BoxDecoration(
                            color: Color(0xFFF59E0B),
                            borderRadius: BorderRadius.circular(3))),
                    SizedBox(width: 2),
                    Container(
                        width: size.getW(6),
                        height: size.getW(6),
                        decoration: BoxDecoration(
                            color: Color(0xFFF59E0B),
                            borderRadius: BorderRadius.circular(3))),
                  ],
                ),
              ),
            ),
            SizedBox(width: size.getS(16)),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Pairing',
                    style: TextStyle(
                      fontSize: size.getS(20),
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  SizedBox(height: size.getH(8)),
                  Text(
                    'Confirm that the following Code is showing on the Terminal',
                    style: TextStyle(
                      fontSize: size.getS(16),
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  SizedBox(height: size.getH(12)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Code:',
                        style: TextStyle(
                          fontSize: size.getS(16),
                          fontFamily: kFontFMedium,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF374151),
                        ),
                      ),
                      SizedBox(width: size.getW(24)),
                      Text(
                        confirmCode,
                        // mxPairResponse?.data?.confirmationCode ?? '',
                        style: TextStyle(
                          fontSize: size.getS(48),
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
