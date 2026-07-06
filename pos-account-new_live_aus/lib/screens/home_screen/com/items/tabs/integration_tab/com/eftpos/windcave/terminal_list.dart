import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/ui_model/payment_history.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/integration/terminal_pro.dart';
import 'package:pos_account/widgets/dialog/confirm_dialog.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import 'package:provider/provider.dart';
import '../mx_51/mx_pairing.dart';
import '../terminal_add_up.dart';

class TerminalList extends StatefulWidget {
  final String? id;
  final String merchantName;
  const TerminalList({super.key, this.id, required this.merchantName});

  @override
  State<TerminalList> createState() => _TerminalListState();
}

class _TerminalListState extends State<TerminalList> {
  @override
  void initState() {
    super.initState();
    setData();
  }

  TerminalPro? _terminalPro;

  setData() async {
    _terminalPro = Provider.of<TerminalPro>(context, listen: false);
    if (_terminalPro != null) {
      if (widget.merchantName == InteEnum.VisionPay.name) {
        // await USBServiceEFt.scanDevice();
      }
      await _terminalPro!.getData(platId: widget.id);

      if (widget.merchantName == InteEnum.Mx.name) {
        final _status = await _terminalPro?.pairingInfoCheck();
        if (_status ?? false) {
          MxPairingDia.updatePayTerminal();
        }
      }
    }
  }

  Future<void> onClickBtn({required int index, required int btnId}) async {
    InteEnum? inteEnum;
    if (widget.merchantName == InteEnum.WindCave.name) {
      inteEnum = InteEnum.WindCave;
    } else if (widget.merchantName == InteEnum.Mx.name) {
      inteEnum = InteEnum.Mx;
    } else if (widget.merchantName == InteEnum.VisionPay.name) {
      inteEnum = InteEnum.VisionPay;
    }

    if (inteEnum == null) return;

    final _data = _terminalPro
        ?.platInteConnById?.integrationPlatformConnectionCredentials?[index];

    if (btnId == 1) {
      _terminalPro?.windSetup(index);
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => TerminalAddUpDia(inteEnum: inteEnum!));
    } else if (btnId == 2) {
      showDialog(
          context: CUS_CTX!,
          builder: (_) {
            if (inteEnum == InteEnum.Mx) {
              return ConfirmDialog(
                title: "Unpair ${_data?.name ?? ''} ?",
                subTitle: "",
                actionText: "Yes",
                cancelText: "No",
                onDelete: () async {
                  final _status = await _terminalPro?.unPairMx(index);
                  if (_status ?? false) {
                    MxPairingDia.updatePayTerminal();
                    // update the data
                    // final _sta = await _terminalPro?.deleteTerminal(index);

                    // if (_sta ?? false) {
                    //   _terminalPro?.platInteConnById
                    //       ?.integrationPlatformConnectionCredentials
                    //       ?.removeAt(index);
                    //   _terminalPro!.notify;
                    // }
                  }

                  return true;
                },
              );
            } else {
              return ConfirmDialog(
                title: "Remove ${_data?.customerId ?? ''} ?",
                subTitle: "",
                actionText: "Yes",
                cancelText: "No",
                onDelete: () async {
                  final _sta = await _terminalPro?.deleteTerminal(index);

                  if (_sta ?? false) {
                    _terminalPro?.platInteConnById
                        ?.integrationPlatformConnectionCredentials
                        ?.removeAt(index);
                    _terminalPro!.notify;
                  }

                  return true;
                },
              );
            }
          });
    } else if (btnId == 3) {
      if (inteEnum == InteEnum.Mx) {
        // for pairing
        _terminalPro?.windSetup(index);
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (_) => MxPairingDia());
        // showDialog(
        //     barrierDismissible: false,
        //     context: context,
        //     builder: (_) => Mx51Pairing(
        //           pairModel: MxPairModel(
        //               posId: _data?.name?.replaceAll(' ', ''),
        //               serialNumber: _data?.serialNumber),
        //         ));
      } else if (inteEnum == InteEnum.VisionPay) {
        // final pId = int.tryParse(data?.serialNumber ?? '');

        // final isConnected =
        //     pId != null && pId == USBServiceEFt.connectedUsb?.pid;

        // if (isConnected) {
        //   await USBServiceEFt.disconnectDevice();
        // } else if (USBServiceEFt.usbDevices.any((e) => e.pid == pId)) {
        //   final usbIndex =
        //       USBServiceEFt.usbDevices.indexWhere((e) => e.pid == pId);

        //   await USBServiceEFt.connectDevice(usbIndex);
        // }
        // _terminalPro!.notify;
      }
      // showDialog(
      //     barrierDismissible: false,
      //     context: context,
      //     builder: (_) => VisionPayPair());
    }
  }

  @override
  void dispose() {
    _terminalPro?.pageLoad = true;
    _terminalPro?.terminalStausChecking = false;
    _terminalPro?.platInteConnById = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<TerminalPro>(context);
    final size = Ssize(context);
    return SimpleDialog(
      backgroundColor: kBackgroundColor,
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.symmetric(
          horizontal: size.getW(12), vertical: size.getH(12)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      children: [
        Processing(
          loading: prov.pageLoad,
          child: Container(
            constraints: BoxConstraints(
              maxHeight: size.height / 1.14,
              minHeight: size.height / 5,
            ),
            width: size.width / 1.12,
            child: SingleChildScrollView(
              // controller: _scrollCltr,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "${InteEnum.Mx.name == widget.merchantName ? "Simple Cloud Integration" : widget.merchantName} Terminals",
                        style: TextStyle(
                          fontSize: size.getS(18),
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      if (widget.merchantName == InteEnum.Mx.name &&
                          prov.terminalStausChecking)
                        Padding(
                          padding: EdgeInsets.only(left: size.getW(12)),
                          child: Text(
                            "Checking Terminals Status ...",
                            style: TextStyle(
                              fontSize: size.getS(16),
                              fontFamily: kFontFMedium,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ),
                      Spacer(),
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.close))
                    ],
                  ),
                  SizedBox(
                    height: size.getH(24),
                  ),
                  if (prov
                          .platInteConnById
                          ?.integrationPlatformConnectionCredentials
                          ?.isNotEmpty ??
                      false)
                    Wrap(
                      spacing: size.getW(12),
                      runSpacing: size.getH(24),
                      children: [
                        ...List.generate(
                            prov
                                .platInteConnById!
                                .integrationPlatformConnectionCredentials!
                                .length, (i) {
                          final data = prov.platInteConnById!
                              .integrationPlatformConnectionCredentials![i];
                          final _posDevice = (prov.posDevices?.any((e) =>
                                      e.id?.toLowerCase() ==
                                      data.posDeviceId?.toLowerCase()) ??
                                  false)
                              ? prov.posDevices?.firstWhere((e) =>
                                  e.id?.toLowerCase() ==
                                  data.posDeviceId?.toLowerCase())
                              : null;
                          final orderData = <PayHistory>[
                            if (widget.merchantName == InteEnum.VisionPay.name)
                              PayHistory(
                                  title: "Device Name:",
                                  subtitle: data.customerId ?? "")
                            else
                              PayHistory(
                                  title: widget.merchantName == InteEnum.Mx.name
                                      ? "TID:"
                                      : "S/N:",
                                  subtitle: data.serialNumber ?? ""),
                            // if (_posName != null)
                            PayHistory(
                                title: "Pos Name",
                                subtitle: data.posNameOrId ?? ''),
                            PayHistory(
                                title: "Device Type",
                                subtitle:
                                    _posDevice?.additionalValue?.toString() ??
                                        ''),
                          ];
                          return Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Container(
                                width: size.getW(400),
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.getW(12),
                                    vertical: size.getH(12)),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data.name ?? '',
                                      style: TextStyle(
                                        fontSize: size.getS(17),
                                        color: Colors.black,
                                        fontFamily: kFontFMedium,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: size.getH(4),
                                    ),
                                    ...List.generate(
                                        orderData.length,
                                        (index) => Column(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: size.getH(6.0)),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          orderData[index]
                                                              .title,
                                                          style: TextStyle(
                                                            fontSize:
                                                                size.getS(16),
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 2,
                                                        child: Text(
                                                          orderData[index]
                                                              .subtitle,
                                                          style: TextStyle(
                                                            fontSize:
                                                                size.getS(16),
                                                            color: Colors.black,
                                                            fontFamily:
                                                                kFontFMedium,
                                                          ),
                                                          textAlign:
                                                              TextAlign.right,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )),
                                    Builder(builder: (context) {
                                      final sn =
                                          int.tryParse(data.serialNumber ?? '');
                                      final isVConnected =
                                          widget.merchantName ==
                                                  InteEnum.VisionPay.name &&
                                              sn != null;
                                      // &&
                                      // sn == USBServiceEFt.connectedUsb?.pid;

                                      final btnList = [
                                        _BtnModel(
                                          id: 1,
                                          title: LN.edit,
                                          color: kSecondaryColor,
                                        ),
                                        if (widget.merchantName ==
                                            InteEnum.Mx.name) ...[
                                          if (data.keyOrId == null ||
                                              data.keyOrId!.isEmpty)
                                            _BtnModel(
                                              id: 3,
                                              title: "Pair",
                                              color: Colors.green.shade500,
                                            )
                                        ] else if (widget.merchantName ==
                                            InteEnum.VisionPay.name)
                                          _BtnModel(
                                            id: 3,
                                            title: isVConnected
                                                ? LN.disconnected
                                                : LN.connect,
                                            color: isVConnected
                                                ? Colors.red.shade600
                                                : Colors.green.shade500,
                                          ),
                                        if (data.keyOrId?.isNotEmpty ?? false)
                                          _BtnModel(
                                            id: 2,
                                            title: widget.merchantName ==
                                                    InteEnum.Mx.name
                                                ? "Unpair"
                                                : LN.delete,
                                            color: kTempColor,
                                          ),
                                      ];

                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: size.getH(8.0)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            ...List.generate(
                                              3,
                                              (j) => Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 4.0),
                                                  child: j < btnList.length
                                                      ? ElevatedButton(
                                                          style: ButtonStyle(
                                                              backgroundColor:
                                                                  WidgetStateProperty.all(
                                                                      btnList[j]
                                                                          .color),
                                                              padding: WidgetStateProperty.all(EdgeInsets.symmetric(
                                                                  horizontal: size
                                                                      .getW(8),
                                                                  vertical:
                                                                      size.getH(
                                                                          8.0)))),
                                                          onPressed: prov.pageLoad
                                                              ? null
                                                              : () => onClickBtn(
                                                                  index: i,
                                                                  btnId:
                                                                      btnList[j]
                                                                          .id),
                                                          child: Text(
                                                            btnList[j].title,
                                                            style: TextStyle(
                                                              fontSize:
                                                                  size.getS(14),
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ))
                                                      : SizedBox.shrink(),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    })
                                  ],
                                ),
                              ),
                              if (data.posDeviceId?.toLowerCase() ==
                                  GlobalCVP.userStoresRes?.id?.toLowerCase())
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade700,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: size.getW(12),
                                      vertical: size.getH(4)),
                                  child: Text(
                                    LN.defaultText,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: size.getS(16)),
                                  ),
                                )
                            ],
                          );
                        })
                      ],
                    )
                  else if (!prov.pageLoad)
                    NoItemsSec(size: size, title: "No Terminals Found")
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BtnModel {
  final int id;
  final String title;
  final Color color;

  _BtnModel({required this.id, required this.title, required this.color});
}
