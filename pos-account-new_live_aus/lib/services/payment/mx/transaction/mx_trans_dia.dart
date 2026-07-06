import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/menu/place_order/po_pay_sec_list_res.dart';
import 'package:pos_account/providers/common/eftpro.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/providers/integration/terminal_pro.dart';
import 'package:pos_account/providers/menu/payment_pro.dart';
import 'package:pos_account/repository/mx/model/mx_pay_data.dart';
import 'package:pos_account/repository/mx/model/trans_res.dart';
import 'package:pos_account/widgets/dialog/confirm_dialog.dart';
import 'package:pos_account/widgets/input/text_form/text_form_widget.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:provider/provider.dart';

class MxTransDia extends StatefulWidget {
  final List<EftposMerchant> merchantList;
  final MxPayData payData;
  final bool askToCancel;
  const MxTransDia({
    super.key,
    required this.merchantList,
    required this.payData,
    this.askToCancel = false,
  });

  static bool isDiaOpen = false;
  static BuildContext? context;

  static Future<MxTransRes?> show(
    BuildContext context, {
    required List<EftposMerchant> merchantList,
    required MxPayData payData,
  }) async {
    return await showDialog(
        context: context,
        builder: (_) {
          return SimpleDialog(
            backgroundColor: kBackgroundColor,
            titlePadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            children: [
              MxTransDia(
                merchantList: merchantList,
                payData: payData,
              )
            ],
          );
        });
  }

  @override
  State<MxTransDia> createState() => _MxTransDiaState();
}

class _MxTransDiaState extends State<MxTransDia> {
  late EftPro eftPro;

  List<EftposMerchant>? merchantList;

  bool _pairingInfoCheckLoad = true;

  EftPro? _initEftPro;

  @override
  void initState() {
    super.initState();
    MxTransDia.isDiaOpen = true;
    MxTransDia.context = context;
    _initEftPro = Provider.of<EftPro>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) => _getData());
  }

  bool get _isAutoPayOnSingle =>
      (merchantList?.isNotEmpty ?? false) &&
      merchantList?.length == 1 &&
      // (merchantList?.first.posDeviceId?.toLowerCase() ==
      //     GlobalCVP.deviceDetailRes?.id?.toLowerCase()) &&
      (merchantList?.first.keyOrId?.isNotEmpty ?? false);

  bool _autoInitPay = true;

  void _getData() {
    _initEftPro?.mxTransRes = null;

    merchantList = List.generate(widget.merchantList.length,
        (i) => EftposMerchant.fromJson((widget.merchantList[i].toJson())));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // _initEftPro.notify;

      EftposMerchant? _initMerchant;

      if (_isAutoPayOnSingle) {
        merchantList!.first.isSelected = true;
        _initMerchant = merchantList!.first;
      } else if ((merchantList?.isNotEmpty ?? false) &&
          (merchantList?.any((a) =>
                  a.posDeviceId?.toLowerCase() ==
                  GlobalCVP.userStoresRes?.id?.toLowerCase()) ??
              false)) {
        final _merDevice = merchantList?.firstWhere((a) =>
            a.posDeviceId?.toLowerCase() ==
            GlobalCVP.userStoresRes?.id?.toLowerCase());

        if (_merDevice?.keyOrId?.isNotEmpty ?? false) {
          _merDevice?.isSelected = true;
          _initMerchant = _merDevice;
        }
      }

      _autoInitPay = _initMerchant != null;
      _initEftPro!.notify;

      if (_initMerchant != null) {
        final _status = await _isTerminalUnpaired(_initMerchant);

        if (_status != null && !_status) {
          _pay();
        }
      } else {
        _pairingInfoCheckLoad = false;
        _initEftPro!.notify;
      }
    });
  }

  EftposMerchant? _terminal;

  Future<void> _pay() async {
    _terminal = merchantList?.any(
              (e) => e.isSelected,
            ) ??
            false
        ? merchantList?.firstWhere(
            (e) => e.isSelected,
          )
        : null;

    if (_terminal == null) return;

    if (!mounted) return;

    await eftPro.mxPurchase(merchant: _terminal!, payData: widget.payData);

    if (eftPro.mxTransRes?.data?.message.isApproved ?? false) {
      eftPro.setMxReqDb();

      // Navigator.pop(context, eftPro.mxTransRes?..terminal = _terminal);
    }
  }

  Future<bool?> _isTerminalUnpaired(EftposMerchant _terminal) async {
    _terminal.statusCheck = true;
    eftPro.pageLoad = true;
    final _status = await eftPro.pairingInfoCheck(mxMerchant: _terminal);

    if (_status != null && _status) {
      eftPro.notify;
      await GlobalCVP.getAllAddSection(isServerCall: true);
      _terminal.statusCheck = false;
      if (mounted) {
        final _payPro = Provider.of<PaymentPro>(context, listen: false);
        await _payPro.getData();

        final _merchants = _payPro.paySecListRes?.eftposMerchantList;

        final _mx = (_merchants?.any((e) =>
                    e.merchantType == InteEnum.Mx.name &&
                    (e.keyOrId?.isNotEmpty ?? false)) ??
                false)
            ? _merchants
                ?.where((e) =>
                    e.merchantType == InteEnum.Mx.name &&
                    (e.keyOrId?.isNotEmpty ?? false))
                .toList()
            : null;
        if (_mx != null) {
          merchantList = List.generate(
              _mx.length, (i) => EftposMerchant.fromJson(_mx[i].toJson()));
        }
      }
    }
    _terminal.statusCheck = false;
    _pairingInfoCheckLoad = false;
    eftPro.pageLoad = false;
    eftPro.notify;

    return _status;
  }

  void clearDB() {
    eftPro.clearMXDbData();
  }

  @override
  void dispose() {
    MxTransDia.isDiaOpen = false;
    MxTransDia.context = null;
    eftPro.mxEftClear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    eftPro = Provider.of<EftPro>(context);
    final _padding = EdgeInsets.symmetric(vertical: size.getH(48));

    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: size.height / 1.14,
          minHeight: size.height / 4,
        ),
        width: size.width / 1.4,
        padding: EdgeInsets.symmetric(
            horizontal: size.getW(24), vertical: size.getH(24)),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (eftPro.payloading &&
                  ((eftPro.mxTransRes?.data?.status?.isPending ?? false) ||
                      (eftPro.mxTransRes?.data?.status?.isAwaiting ?? false)))
                Padding(
                  padding: _padding,
                  child: _transactionProcess(size),
                )
              else if (eftPro.mxTransRes?.data?.message.isApproved ?? false)
                Padding(
                  padding: _padding,
                  child: _buildApprovedContent(size),
                )
              else if ((eftPro.mxTransRes?.data?.message.isCancelled ??
                      false) ||
                  (eftPro.mxTransRes?.data?.message.isDeclined ?? false) ||
                  (eftPro.mxTransRes?.data?.message.isBusy ?? false) ||
                  (eftPro.mxTransRes?.data?.message.isInvalid ?? false) ||
                  (eftPro.mxTransRes?.data?.resultFinancialStatus.isDeclined ??
                      false))
                Padding(
                  padding: _padding,
                  child: _buildCancelContent(size),
                )
              else if (eftPro.payloading && _autoInitPay)
                _buildProcessingContent(size)
              else if (eftPro.mxPayTimeOut)
                _buildTimeout(size)
              else if (_pairingInfoCheckLoad)
                _buildProcessingContent(size,
                    message: "Verifying Terminal Status")
              else
                _initPayment(size)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProcessingContent(
    Ssize size, {
    String message = 'In progress',
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _header(
          size,
          context,
          title: widget.payData.mxPayType == MxPayType.Purchase
              ? "PURCHASE"
              : widget.payData.mxPayType == MxPayType.Refund
                  ? "REFUND"
                  : '',
          centerTitle: true,
          showCloseBn: true,
        ),
        SizedBox(height: size.getH(24)),
        Loading(),
        SizedBox(height: size.getH(24)),
        Text(
          message,
          style: TextStyle(
            fontSize: size.getS(20),
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
        SizedBox(height: size.getH(48)),
      ],
    );
  }

  Widget _initPayment(Ssize size) {
    // log('init payment');
    // log(json.encode(eftPro.windTranRes?.toJson()));
    return Column(
      children: [
        _header(size, context),
        SizedBox(
          height: size.getH(24),
          child: Divider(
            color: Colors.black54,
          ),
        ),
        if (merchantList != null)
          ...List.generate(merchantList!.length, (index) {
            final _terminal = merchantList![index];
            return ListTile(
              contentPadding: EdgeInsets.zero,
              horizontalTitleGap: 0,
              onTap: _terminal.statusCheck
                  ? null
                  : () async {
                      final _status = await _isTerminalUnpaired(_terminal);
                      if (_status != null && _status) return;

                      merchantList!.forEach((e) {
                        e.isSelected = false;
                      });

                      _terminal.isSelected = true;
                      eftPro.notify;
                    },
              leading: Radio(
                groupValue: true,
                onChanged: _terminal.statusCheck
                    ? null
                    : (bool? value) async {
                        final _status = await _isTerminalUnpaired(_terminal);
                        if (_status != null && _status) return;

                        merchantList!.forEach((e) {
                          e.isSelected = false;
                        });

                        _terminal.isSelected = true;
                        eftPro.notify;
                      },
                value: _terminal.isSelected,
              ),
              title: Text(
                _terminal.name ?? '',
                style: TextStyle(
                  fontSize: size.getS(18),
                  color: Colors.black,
                  height: 1.4,
                ),
              ),
              subtitle: Text(
                'TID: ${_terminal.serialNumber ?? ''}',
                style: TextStyle(
                  fontSize: size.getS(16),
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
              trailing: _terminal.statusCheck && eftPro.pageLoad
                  ? LoadButton(
                      loading: true,
                      width: 240,
                      hPad: 12,
                      loadingText: "Verifying Status",
                      btnText: "Verifying Status",
                      btnColor: Colors.green.withOpacity(0.15),
                      textColor: Colors.green.shade700,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(60)),
                    )
                  : null,
              // trailing: (_terminal.keyOrId?.isNotEmpty ?? false)
              //     ? LoadButton(
              //         btnText: "Unpair",
              //         // width: 120,
              //         btnColor: Colors.white,
              //         textColor: Colors.black,
              //         shape: RoundedRectangleBorder(
              //             side: BorderSide(color: Colors.black54),
              //             borderRadius: BorderRadius.circular(5)),
              //         vPad: 8,
              //         onsave: () async {
              //           final _terminalPro =
              //               Provider.of<TerminalPro>(context, listen: false);
              //           _terminalPro.pageLoad = true;

              //           int? _mxIndex;

              //           _terminalPro
              //               .getData(platId: _terminal.integrationPlatformId)
              //               .then((value) {
              //             if (_terminalPro.platInteConnById
              //                     ?.integrationPlatformConnectionCredentials
              //                     ?.any((a) =>
              //                         a.id?.toLowerCase() ==
              //                         merchantList?[index].id?.toLowerCase()) ??
              //                 false) {
              //               _mxIndex = _terminalPro.platInteConnById
              //                   ?.integrationPlatformConnectionCredentials
              //                   ?.indexWhere((a) =>
              //                       a.id?.toLowerCase() ==
              //                       merchantList?[index].id?.toLowerCase());

              //               _terminalPro.windSetup(_mxIndex!);
              //             }
              //           });

              //           final _status = await showDialog(
              //               barrierDismissible: false,
              //               context: context,
              //               builder: (_) => ConfirmDialog(
              //                     title: "Unpair ${_terminal.name ?? ''} ?",
              //                     subTitle: "",
              //                     actionText: "Yes",
              //                     cancelText: "No",
              //                     onDelete: () async {
              //                       final _status =
              //                           await _terminalPro.unPairMx(index);

              //                       return _status;
              //                     },
              //                   ));

              //           if (_status) {
              //             _terminal.keyOrId = "";
              //             _terminal.customerId = "";
              //             _terminal.secret = "";
              //             _terminal.serialNumber = "";

              //             eftPro.notify;

              //             _updateEFtData(_terminal, null);
              //           }
              //         },
              //       )
              //     : LoadButton(
              //         btnText: LN.pair,
              //         // width: 120,
              //         btnColor: Colors.green.shade700,
              //         vPad: 8,
              //         onsave: () async {
              //           final _terminalPro =
              //               Provider.of<TerminalPro>(context, listen: false);
              //           _terminalPro.pageLoad = true;

              //           int? _mxIndex;

              //           _terminalPro
              //               .getData(platId: _terminal.integrationPlatformId)
              //               .then((value) {
              //             if (_terminalPro.platInteConnById
              //                     ?.integrationPlatformConnectionCredentials
              //                     ?.any((a) =>
              //                         a.id?.toLowerCase() ==
              //                         merchantList?[index].id?.toLowerCase()) ??
              //                 false) {
              //               _mxIndex = _terminalPro.platInteConnById
              //                   ?.integrationPlatformConnectionCredentials
              //                   ?.indexWhere((a) =>
              //                       a.id?.toLowerCase() ==
              //                       merchantList?[index].id?.toLowerCase());

              //               _terminalPro.windSetup(_mxIndex!);
              //             }
              //           });

              //           await showDialog(
              //               barrierDismissible: false,
              //               context: context,
              //               builder: (_) => MxPairingDia());

              //           if (_mxIndex != null) {
              //             final _mxTer = _terminalPro.platInteConnById
              //                     ?.integrationPlatformConnectionCredentials?[
              //                 _mxIndex!];

              //             _terminal.keyOrId = _mxTer?.keyOrId;
              //             _terminal.customerId = _mxTer?.customerId;
              //             _terminal.secret = _mxTer?.secret;
              //             _terminal.serialNumber = _mxTer?.serialNumber;

              //             eftPro.notify;

              //             _updateEFtData(_terminal, _mxTer);
              //           }
              //         },
              //       ),
            );
          }),
        SizedBox(
          height: size.getH(24),
        ),
        LoadButton(
          width: double.infinity,
          btnText: LN.initiatePayment,
          loading: eftPro.payloading,
          btnColor: (merchantList?.any((a) => a.statusCheck) ?? false)
              ? Colors.grey.shade400
              : (merchantList?.any((a) => a.isSelected) ?? false)
                  ? kSecondaryColor
                  : Colors.grey.shade400,
          onsave: eftPro.payloading ||
                  (merchantList?.every((a) => !a.isSelected) ?? false)
              ? null
              : _pay,
        ),
      ],
    );
  }

  Widget _transactionProcess(Ssize size) {
    return Column(
      children: [
        _header(
          size,
          context,
          title: widget.payData.mxPayType == MxPayType.Purchase
              ? "PURCHASE"
              : widget.payData.mxPayType == MxPayType.Refund
                  ? "REFUND"
                  : '',
          centerTitle: true,
          showCloseBn: false, //TODO
        ),
        SizedBox(height: size.getH(24)),
        Loading(),
        SizedBox(height: size.getH(24)),
        Text(
          'In progress',
          style: TextStyle(
            fontSize: size.getS(20),
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
        SizedBox(height: size.getH(16)),
        Text(
          eftPro.mxTransRes?.data?.message ?? '',
          style: TextStyle(
            fontSize: size.getS(20),
            color: Colors.black,
            fontFamily: kFontFMedium,
            height: 1.4,
          ),
        ),
        SizedBox(height: size.getH(24)),
        _actionLayout(
          size,
          onTap: (String? action) {
            if (action == 'TEST_ACTION') {
              showApiPayloadDialog(context, eftPro.testPayloadData);
            } else {
              eftPro.printReceipt(action);
            }
          },
        ),
        SizedBox(height: size.getH(16)),
        _pairDetails(size),
        SizedBox(height: size.getH(16)),
      ],
    );
  }

  Widget _buildApprovedContent(Ssize size) {
    // final _status = _checkStatus(eftPro.mxTransRes?.data?.message ?? '');
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _header(
          size,
          context,
          title: widget.payData.mxPayType == MxPayType.Purchase
              ? "PURCHASE"
              : widget.payData.mxPayType == MxPayType.Refund
                  ? "REFUND"
                  : '',
          centerTitle: true,
          showCloseBn: false,
        ),
        SizedBox(height: size.getH(24)),
        Container(
            decoration: BoxDecoration(
              color: Colors.green.shade700,
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: size.getS(8), vertical: size.getS(8)),
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: size.getS(42),
              ),
            )),
        SizedBox(height: size.getH(24)),
        Text(
          eftPro.mxTransRes?.data?.message ?? '',
          style: TextStyle(
            fontSize: size.getS(24),
            fontWeight: FontWeight.bold,
            color: Colors.green.shade600,
            fontFamily: kFontFMedium,
          ),
        ),
        SizedBox(height: size.getH(24)),
        _actionLayout(
          size,
          onTap: (String? action) {
            if (action == 'TRANSACTION_COMPLETE') {
              Navigator.pop(context, eftPro.mxTransRes?..terminal = _terminal);
            } else {
              eftPro.printReceipt(action);
            }
          },
          isTransSuccess: true,
        ),
        SizedBox(height: size.getH(16)),
        _pairDetails(size),
        SizedBox(height: size.getH(16)),
      ],
    );
  }

  Widget _buildCancelContent(Ssize size) {
    // final _status = _checkStatus(eftPro.mxTransRes?.data?.message ?? '');
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _header(
          size,
          context,
          title: widget.payData.mxPayType == MxPayType.Purchase
              ? "PURCHASE"
              : widget.payData.mxPayType == MxPayType.Refund
                  ? "REFUND"
                  : '',
          centerTitle: true,
          showCloseBn: false, //TODO
        ),
        SizedBox(height: size.getH(24)),
        Container(
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: size.getS(8), vertical: size.getS(8)),
              child: Icon(
                Icons.close,
                color: Colors.white,
                size: size.getS(42),
              ),
            )),
        SizedBox(height: size.getH(16)),
        Text(
          eftPro.mxTransRes?.data?.message ?? '',
          // '(TRANSACTION_CANCELLED)\nTransaction user cancelled',
          style: TextStyle(
            fontSize: size.getS(20),
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: size.getH(24)),
        _actionLayout(
          size,
          onTap: (String? action) {
            if (action == 'RETRY_TRANSACTION') {
              _pay();
            } else if (action == 'TRANSACTION_COMPLETE') {
              clearDB();
              Navigator.pop(context);
            } else {
              eftPro.printReceipt(action);
            }
          },
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     _cancelButton(
        //       size,
        //       title: "Done",
        //       onTap: () {
        //         clearDB();
        //         Navigator.pop(context);
        //       },
        //     ),
        //     SizedBox(width: size.getW(16)),
        //     _confirmButton(size, title: "Retry", onTap: _pay),
        //   ],
        // ),
        SizedBox(height: size.getH(16)),
        _pairDetails(size),
        SizedBox(height: size.getH(16)),
      ],
    );
  }

  Widget _buildTimeout(Ssize size) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _header(
          size,
          context,
          title: widget.payData.mxPayType == MxPayType.Purchase
              ? "PURCHASE"
              : widget.payData.mxPayType == MxPayType.Refund
                  ? "REFUND"
                  : '',
          centerTitle: true,
          showCloseBn: true, //TODO
        ),
        SizedBox(height: size.getH(16)),
        Icon(
          Icons.info,
          color: Colors.amber,
          size: size.getS(72),
        ),
        SizedBox(height: size.getH(16)),
        Text(
          'Unknown transaction status',
          style: TextStyle(
            fontSize: size.getS(20),
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: size.getH(4)),
        Text(
          'Was the transaction successful on the Eftpos terminal?',
          style: TextStyle(
            fontSize: size.getS(18),
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: size.getH(12)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _cancelButton(
              size,
              width: size.getW(110),
              title: 'Yes',
              onTap: () async {
                Navigator.pop(
                    context, eftPro.mxTransRes?..terminal = _terminal);
              },
            ),
            SizedBox(width: size.getW(12)),
            _cancelButton(
              size,
              width: size.getW(110),
              title: 'No',
              onTap: () async {
                eftPro.mxPayTimeOut = false;
                eftPro.notify;
              },
            ),
            // _actionLayout(
            //   size,
            //   onTap: (String? action) {
            //     eftPro.mxPayTimeOut = false;
            //     eftPro.notify;
            //   },
            // ),
          ],
        ),
        SizedBox(height: size.getH(16)),
        _pairDetails(size),
        SizedBox(height: size.getH(16)),
      ],
    );
  }

  Widget _header(
    Ssize size,
    BuildContext context, {
    String title = 'Choose Terminal',
    bool centerTitle = true,
    bool showCloseBn = true,
  }) {
    return Stack(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: centerTitle ? Alignment.topCenter : Alignment.topLeft,
          child: Text.rich(
            TextSpan(
              text: title,
            ),
            style: TextStyle(
              fontSize: size.getS(28),
              fontWeight: FontWeight.bold,
              color: Colors.black,
              height: 1.7,
            ),
          ),
        ),
        if (showCloseBn)
          Align(
            alignment: Alignment.topRight,
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.red.shade800,
                  shape: BoxShape.circle,
                ),
                child: InkWell(
                  onTap: () async {
                    if (widget.askToCancel)
                      await showDialog(
                          context: context,
                          builder: (_) {
                            return ConfirmDialog(
                              title: "Transaction Aborted?",
                              subTitle:
                                  "Transaction Incomplete! Clicking 'OK' will result in losing this transaction.",
                              onDelete: () async {
                                await Future.delayed(
                                    Duration(milliseconds: 500));
                                clearDB();
                                Navigator.of(context).pop();

                                return null;
                              },
                              actionText: LN.ok,
                              cancelText: LN.no,
                            );
                          });
                    else {
                      clearDB();
                      Navigator.pop(context);
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.getS(8), vertical: size.getS(8)),
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                )),
          ),
      ],
    );
  }

  Widget _actionLayout(
    Ssize size, {
    Function(String? action)? onTap,
    bool isTransSuccess = false,
  }) {
    final _actionForm = eftPro.mxTransRes?.data?.posInstructions?.actionForm;

    if (_actionForm?.layout == null)
      return SizedBox.shrink();
    else
      return FittedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: _actionForm!.layout!.map<Widget>((layout) {
            final type = layout.type;
            final elements = layout.elements;

            // Convert elements to button widgets
            final buttons = elements?.map<Widget>((el) {
              final key = el.key;
              final label = el.label;
              // print("key: $key \n ${_actionForm.properties?.toJson()[key]}");
              final props = _actionForm.properties?[key];
              //  PrintCustomerReceipt.fromJson(
              //     _actionForm.properties?.toJson()[key]);

              if (props['type'] == "input") {
                el.textCltr ??= TextEditingController();
              }

              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.getW(
                      12), // type == 'horizontal_layout' ? size.getW(12) : 0,
                  vertical: size
                      .getH(8), // type == 'vertical_layout' ? size.getH(8) : 0,
                ),
                child: props['type'] == "button"
                    ? _cancelButton(
                        size,
                        title: label ?? '',
                        isTransSuccess: isTransSuccess,
                        onTap: () async {
                          if (props['submit_url']?.toString() != null) {
                            await eftPro.onClickButtonMx(
                              submitUrl: props['submit_url']?.toString(),
                              payData: widget.payData,
                            );
                          }
                          if (onTap != null) onTap(props['action']?.toString());
                        },
                      )
                    : props['type'] == "text"
                        ? Text(
                            "${(label?.isNotEmpty ?? false) ? '$label: ' : ''}${props['text'] ?? ''}"
                                .trim(),
                            style: TextStyle(
                              fontSize: size.getS(16),
                              color: Colors.black,
                              fontFamily: kFontFMedium,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          )
                        : props['type'] == "image" &&
                                props['encoding'] == "base64"
                            ? Image.memory(
                                base64Decode(props['data'].toString()),
                                fit: BoxFit.cover,
                                height: size.getH(100),
                              )
                            : props['type'] == "input"
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(label ?? '',
                                          style: TextStyle(
                                            fontSize: size.getS(16),
                                            color: Colors.black,
                                            fontFamily: kFontFMedium,
                                            height: 1.4,
                                          )),
                                      SizedBox(
                                        width: size.getW(12),
                                      ),
                                      SizedBox(
                                          width: size.getW(200),
                                          child: TextFormWidget(
                                            vPad: 6,
                                            borderColor: Colors.black26,
                                            cltr: el.textCltr ??
                                                TextEditingController(),
                                            hintText: '',
                                            onChanged: (val) {
                                              props['data'] = val;
                                            },
                                          ))
                                    ],
                                  )
                                : SizedBox.shrink(),
              );
            }).toList();

            if (buttons != null) {
              if (type == 'horizontal_layout') {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: buttons,
                );
              } else if (type == 'vertical_layout') {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: buttons,
                );
              }
            }
            return const SizedBox.shrink();
          }).toList(),
        ),
      );
  }

  Widget _cancelButton(
    Ssize size, {
    String title = "Cancel",
    required Function() onTap,
    double? width,
    bool isTransSuccess = false,
  }) {
    final _isDone = isTransSuccess && title.toLowerCase().contains('done');
    return SizedBox(
      width: width,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: _isDone ? Colors.green.shade700 : null,
          padding: EdgeInsets.symmetric(
              horizontal: size.getW(_isDone ? 48 : 24),
              vertical: size.getH(_isDone ? 12 : 8)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          side: BorderSide(
              color: _isDone ? Colors.green.shade700 : Colors.black54),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: _isDone ? Colors.white : Colors.black,
            fontSize: size.getS(_isDone ? 24 : 18),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Widget _confirmButton(
  //   Ssize size, {
  //   String title = "Confirm",
  //   required Function() onTap,
  // }) {
  //   return ElevatedButton(
  //     onPressed: onTap,
  //     style: ElevatedButton.styleFrom(
  //       padding: EdgeInsets.symmetric(
  //           horizontal: size.getW(24), vertical: size.getH(8)),
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(8),
  //       ),
  //     ),
  //     child: Text(
  //       title,
  //       style: TextStyle(color: Colors.white, fontSize: size.getS(16)),
  //     ),
  //   );
  // }

  Widget _pairDetails(Ssize size) {
    final _details =
        eftPro.mxTransRes?.data?.posInstructions?.actionForm?.details;

    final _output =
        _details?.entries.map((e) => "${e.key} : ${e.value}").join(", ");

    return Text(
      _output ?? '',
      // "Pairing ID: ${_d?.pairingId ?? ''}, TID: ${_d?.tid ?? ''}, Transaction ID: ${_d?.transactionId ?? ''}, Transaction Version: ${_d?.transactionVersion ?? ''}",
      style: TextStyle(
        fontSize: size.getS(15),
        fontWeight: FontWeight.w500,
        color: Colors.black45,
      ),
    );
  }

  void showApiPayloadDialog(
    BuildContext context,
    Map<String, dynamic>? payload,
  ) {
    final size = Ssize(context);
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          titlePadding: EdgeInsets.fromLTRB(
              size.getW(24), size.getH(24), size.getW(24), size.getH(8)),
          contentPadding: EdgeInsets.fromLTRB(
              size.getW(24), size.getH(8), size.getW(24), 0),
          actionsPadding: EdgeInsets.fromLTRB(
              size.getW(16), 0, size.getW(16), size.getH(16)),
          title: Text(
            'API Payload',
            style: TextStyle(
              fontSize: size.getS(24),
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payload submitted to API',
                style: TextStyle(
                  fontSize: size.getS(13),
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: size.getH(16)),

              // Payload container
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxHeight: 250),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: SingleChildScrollView(
                  child: SelectableText(
                    JsonEncoder.withIndent('  ').convert(payload),
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: size.getS(18),
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.getH(12)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Close',
                style: TextStyle(fontSize: size.getS(20)),
              ),
            ),
          ],
        );
      },
    );
  }

  // void _updateEFtData(
  //   EftposMerchant _terminal,
  //   IntegrationPlatformConnectionCredential? _mxTer,
  // ) {
  //   final _payPro = Provider.of<PaymentPro>(context, listen: false);

  //   if (_payPro.paySecListRes?.eftposMerchantList
  //           ?.any((a) => a.id?.toLowerCase() == _terminal.id?.toLowerCase()) ??
  //       false) {
  //     final _rootTerminal = _payPro.paySecListRes?.eftposMerchantList
  //         ?.firstWhere(
  //             (a) => a.id?.toLowerCase() == _terminal.id?.toLowerCase());
  //     _rootTerminal?.keyOrId = _mxTer?.keyOrId ?? '';
  //     _rootTerminal?.customerId = _mxTer?.customerId ?? '';
  //     _rootTerminal?.secret = _mxTer?.secret ?? '';
  //     _rootTerminal?.serialNumber = _mxTer?.serialNumber ?? '';
  //     GlobalCVP.updateAddSection(data: {
  //       "eftPosMerchants": _payPro.paySecListRes?.eftposMerchantList
  //           ?.map((b) => b.toJson())
  //           .toList()
  //     });
  //   }
  // }

  // String? _checkStatus(String text) {
  //   final _data = utf8.decode(latin1.encode(text));

  //   if (_data.contains('❌')) {
  //     return _data.replaceAll('❌', '');
  //   } else if (_data.contains('✅')) {
  //     return _data.replaceAll('✅', '');
  //   }
  //   return null;
  // }
}
