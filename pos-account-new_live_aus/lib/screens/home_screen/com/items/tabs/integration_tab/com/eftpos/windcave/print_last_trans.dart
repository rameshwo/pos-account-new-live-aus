import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/common/eftpro.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/integration/terminal_pro.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:provider/provider.dart';

class PrintLastTransReceipt extends StatefulWidget {
  final String? id;
  const PrintLastTransReceipt({super.key, this.id});

  @override
  State<PrintLastTransReceipt> createState() => _PrintLastTransReceiptState();
}

class _PrintLastTransReceiptState extends State<PrintLastTransReceipt> {
  @override
  void initState() {
    super.initState();
    _eftPro = Provider.of<EftPro>(context, listen: false);
    _terminalPro = Provider.of<TerminalPro>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) => setData());
  }

  TerminalPro? _terminalPro;
  EftPro? _eftPro;
  String? defaultPayId;

  setData() async {
    await _terminalPro?.getData(platId: widget.id);

    if (_terminalPro?.platInteConnById?.integrationPlatformConnectionCredentials
            ?.any((e) =>
                e.posDeviceId?.toLowerCase() ==
                GlobalCVP.userStoresRes?.id?.toLowerCase()) ??
        false) {
      final termi = _terminalPro!
          .platInteConnById!.integrationPlatformConnectionCredentials!
          .firstWhere((e) =>
              e.posDeviceId?.toLowerCase() ==
              GlobalCVP.userStoresRes?.id?.toLowerCase());
      defaultPayId = termi.id;
      _terminalPro!.notify;
    }
  }

  Future<void> _print(EftPro eftPro) async {
    if (_terminalPro?.platInteConnById?.integrationPlatformConnectionCredentials
            ?.any((e) => e.id?.toLowerCase() == defaultPayId?.toLowerCase()) ??
        false) {
      final termi = _terminalPro!
          .platInteConnById!.integrationPlatformConnectionCredentials!
          .firstWhere(
              (e) => e.id?.toLowerCase() == defaultPayId?.toLowerCase());

      final status = await eftPro.getReceipt(termiData: termi);
      if (status) {
        showToast(LN.receiptPrinting);
      }
    }
  }

  @override
  void dispose() {
    _terminalPro?.pageLoad = true;
    _terminalPro?.platInteConnById = null;
    _eftPro?.dupliReceipt = 0;
    _eftPro?.receiptType = 2;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final prov = Provider.of<TerminalPro>(context);
    final eftPro = Provider.of<EftPro>(context);
    return SimpleDialog(
      backgroundColor: kBackgroundColor,
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.symmetric(
          horizontal: size.getW(12), vertical: size.getH(12)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      children: [
        Processing(
          loading: prov.pageLoad || eftPro.buttonLoad,
          child: Container(
            constraints: BoxConstraints(
              maxHeight: size.height / 1.14,
              minHeight: size.height / 5,
            ),
            width: size.width / 2,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        LN.lastTransactionReceipt,
                        style: TextStyle(
                          fontSize: size.getS(22),
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          height: 1.7,
                        ),
                      ),
                      Spacer(),
                      Container(
                          decoration: BoxDecoration(
                            color: Colors.red.shade800,
                            shape: BoxShape.circle,
                          ),
                          child: InkWell(
                            onTap: () async {
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
                  SizedBox(
                    height: size.getH(24),
                    child: Divider(
                      color: Colors.black54,
                    ),
                  ),
                  if (prov.platInteConnById
                          ?.integrationPlatformConnectionCredentials !=
                      null)
                    ...List.generate(
                        prov
                            .platInteConnById!
                            .integrationPlatformConnectionCredentials!
                            .length, (index) {
                      final terminal = prov.platInteConnById!
                          .integrationPlatformConnectionCredentials![index];
                      final posName = (prov.posDevices
                                  ?.any((e) => e.id == terminal.posDeviceId) ??
                              false)
                          ? prov.posDevices
                              ?.firstWhere((e) => e.id == terminal.posDeviceId)
                              .name
                          : null;
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        horizontalTitleGap: 0,
                        onTap: () {
                          defaultPayId = terminal.id;

                          prov.notify;
                        },
                        leading: Radio(
                          groupValue: true,
                          onChanged: (bool? value) {
                            defaultPayId = terminal.id;
                            prov.notify;
                          },
                          value: defaultPayId?.toLowerCase() ==
                              terminal.id?.toLowerCase(),
                        ),
                        title: Text(
                          posName ?? '',
                          style: TextStyle(
                            fontSize: size.getS(18),
                            color: Colors.black,
                            height: 1.4,
                          ),
                        ),
                        subtitle: Text(
                          'S/N: ${terminal.serialNumber ?? ''}',
                          style: TextStyle(
                            fontSize: size.getS(16),
                            color: Colors.black54,
                            height: 1.4,
                          ),
                        ),
                      );
                    }),
                  SizedBox(
                    height: size.getH(24),
                    child: Divider(
                      color: Colors.black54,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LN.duplicateReceipt,
                        style: TextStyle(
                          fontSize: size.getS(18),
                          color: Colors.black,
                          height: 1.4,
                        ),
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: eftPro.dupliReceipt == 0,
                            onChanged: (va) {
                              eftPro.dupliReceipt = 0;
                              eftPro.notify;
                            },
                          ),
                          InkWell(
                              onTap: () {
                                eftPro.dupliReceipt = 0;
                                eftPro.notify;
                              },
                              child: Text(LN.no)),
                          SizedBox(width: size.getW(24)),
                          Checkbox(
                            value: eftPro.dupliReceipt == 1,
                            onChanged: (va) {
                              eftPro.dupliReceipt = 1;
                              eftPro.notify;
                            },
                          ),
                          InkWell(
                              onTap: () {
                                eftPro.dupliReceipt = 1;
                                eftPro.notify;
                              },
                              child: Text(LN.yes)),
                        ],
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LN.receiptType,
                        style: TextStyle(
                          fontSize: size.getS(18),
                          color: Colors.black,
                          height: 1.4,
                        ),
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: eftPro.receiptType == 2,
                            onChanged: (va) {
                              eftPro.receiptType = 2;
                              eftPro.notify;
                            },
                          ),
                          InkWell(
                              onTap: () {
                                eftPro.receiptType = 2;
                                eftPro.notify;
                              },
                              child: Text(LN.customerCopy)),
                          SizedBox(width: size.getW(24)),
                          Checkbox(
                            value: eftPro.receiptType == 1,
                            onChanged: (va) {
                              eftPro.receiptType = 1;
                              eftPro.notify;
                            },
                          ),
                          InkWell(
                              onTap: () {
                                eftPro.receiptType = 1;
                                eftPro.notify;
                              },
                              child: Text(LN.merchantCopy)),
                          SizedBox(width: size.getW(24)),
                          Checkbox(
                            value: eftPro.receiptType == 3,
                            onChanged: (va) {
                              eftPro.receiptType = 3;
                              eftPro.notify;
                            },
                          ),
                          InkWell(
                              onTap: () {
                                eftPro.receiptType = 3;
                                eftPro.notify;
                              },
                              child: Text(LN.merchantCopyWithSignature)),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: size.getH(24),
                  ),
                  LoadButton(
                    width: double.infinity,
                    btnText: LN.printReceipt,
                    loading: eftPro.buttonLoad,
                    onsave: prov.pageLoad || eftPro.buttonLoad
                        ? null
                        : () => _print(eftPro),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
