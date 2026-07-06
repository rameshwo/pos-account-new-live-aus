import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/menu/place_order/po_pay_sec_list_res.dart';
import 'package:pos_account/providers/common/eftpro.dart';
import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/repository/windcave/model/tran_req.dart';
import 'package:pos_account/repository/windcave/model/tran_res.dart';
import 'package:pos_account/repository/windcave/windcave_handler.dart';
import 'package:pos_account/screens/home_screen/com/items/sidebar/order_section/com/pay_method/com/choose_eft_pay_dia.dart';
import 'package:pos_account/widgets/dialog/confirm_dialog.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:provider/provider.dart';

enum WindcavePayType { Purchase, Refund, None }

class WindcaveEftPayDia extends StatefulWidget {
  final WcTransactionReq req;
  final WindcavePayType type;
  final bool askToCancel;
  final List<EftposMerchant>? terminal;
  final String? orderId;
  const WindcaveEftPayDia({
    super.key,
    required this.req,
    this.type = WindcavePayType.None,
    this.askToCancel = false,
    this.terminal,
    this.orderId,
  });

  static Future<WcTransactionRes?> showDia(
    BuildContext context, {
    required WcTransactionReq req,
    required WindcavePayType type,
    bool askToCancel = false,
    List<EftposMerchant>? terminal,
    String? orderId,
  }) async {
    WindcaveHandler.wCConsoleData = "";
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return SimpleDialog(
            backgroundColor: kBackgroundColor,
            titlePadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            children: [
              WindcaveEftPayDia(
                req: req,
                type: type,
                askToCancel: askToCancel,
                terminal: terminal,
                orderId: orderId,
              )
            ],
          );
        });
  }

  @override
  State<WindcaveEftPayDia> createState() => _WindcaveEftPayDiaState();
}

class _WindcaveEftPayDiaState extends State<WindcaveEftPayDia> {
  @override
  void initState() {
    super.initState();
    _eftPro = Provider.of<EftPro>(context, listen: false);
    _eftPro?.windcavePayDiaOn = true;
    WidgetsBinding.instance.addPostFrameCallback((_) => _get());
  }

  EftPro? _eftPro;

  void _get() {
    if (widget.orderId?.isNotEmpty ?? false)
      WindcaveHandler.wCConsoleData += "Order ID: ${widget.orderId}\n\n";
    final _terminals = widget.terminal;
    if (_terminals?.isNotEmpty ?? false) {
      if (_terminals?.length == 1) {
        _terminals?.first.isSelected = true;
        _pay();
      } else if (_terminals?.any((a) =>
              a.posDeviceId?.toLowerCase() ==
              GlobalCVP.userStoresRes?.id?.toLowerCase()) ??
          false) {
        final _ter = _terminals?.firstWhere((a) =>
            a.posDeviceId?.toLowerCase() ==
            GlobalCVP.userStoresRes?.id?.toLowerCase());
        _ter?.isSelected = true;

        _pay();
      }
    }

    // _eftPro?.pinPairStatus();
  }

  @override
  void dispose() {
    if (_eftPro != null) _eftPro!.windcaveEftClear();
    super.dispose();
  }

  Future<void> _pay() async {
    _eftPro?.cancelForceTranButtonTimer();

    final _terminal = widget.terminal?.any(
              (e) => e.isSelected,
            ) ??
            false
        ? widget.terminal?.firstWhere(
            (e) => e.isSelected,
          )
        : null;

    if (_terminal == null) return;

    widget.req
      ..user = _terminal.customerId
      ..key = _terminal.keyOrId
      ..station = _terminal.serialNumber
      ..cur = _terminal.currency
      ..posName = _terminal.posNameOrId;

    if (widget.type == WindcavePayType.Purchase) {
      _eftPro?.onPayClicked(eftMerchantType: EftPayMethod.WindcavePay.name);
    } else if (widget.type == WindcavePayType.Refund) {
      _eftPro?.onRefundClicked(eftMerchantType: EftPayMethod.WindcavePay.name);
    }
    _eftPro?.isPaymentStart = true;

    _eftPro?.setWindCaveReq(req: widget.req);
    final status = await _eftPro?.windpay(windRequest: widget.req);
    if (status != null) {
      _eftPro?.setWindCaveReq();
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context, status);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final eftPro = Provider.of<EftPro>(context);
    return PopScope(
      canPop: false,
      child: Container(
          constraints: BoxConstraints(
            maxHeight: size.height / 1.14,
            minHeight: size.height / 4,
          ),
          width: size.width / 2,
          padding: EdgeInsets.symmetric(
              horizontal: size.getW(12), vertical: size.getH(12)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (eftPro.pageLoad) ...[
                _header(size, context),
                SizedBox(
                  height: size.getH(100),
                  child: Loading(),
                )
              ] else if ((eftPro.payloading &&
                      (eftPro.windTranRes == null ||
                          eftPro.windTranRes?.complete == "0")) ||
                  (!eftPro.payloading &&
                      (eftPro.windTranRes?.statusId == "4" ||
                          eftPro.windTranRes?.statusId == "5")))
                _transcationProcess(size, eftPro: eftPro)
              else if (!eftPro.payloading &&
                  eftPro.windTranRes != null &&
                  eftPro.windTranRes?.complete == "1")
                _transationResult(size, eftPro: eftPro)
              else if (!eftPro.payloading)
                _initPayment(size, eftPro: eftPro),
              SizedBox(
                height: size.getH(12),
              )
            ],
          )),
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
                                Navigator.of(context).pop();

                                return null;
                              },
                              actionText: LN.ok,
                              cancelText: LN.no,
                            );
                          });
                    else {
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

  Widget _initPayment(
    Ssize size, {
    required EftPro eftPro,
  }) {
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
        if (widget.terminal != null)
          ...List.generate(widget.terminal!.length, (index) {
            final _terminal = widget.terminal![index];
            return ListTile(
              contentPadding: EdgeInsets.zero,
              horizontalTitleGap: 0,
              onTap: () {
                widget.terminal!.forEach((e) {
                  e.isSelected = false;
                });

                _terminal.isSelected = true;
                eftPro.notify;
              },
              leading: Radio(
                groupValue: true,
                onChanged: (bool? value) {
                  widget.terminal!.forEach((e) {
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
                'S/N: ${_terminal.serialNumber ?? ''}',
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
        ),
        LoadButton(
          width: double.infinity,
          btnText: LN.initiatePayment,
          loading: eftPro.payloading,
          onsave:
              eftPro.payloading || widget.terminal!.every((a) => !a.isSelected)
                  ? null
                  : _pay,
        ),
      ],
    );
  }

  Widget _transcationProcess(
    Ssize size, {
    required EftPro eftPro,
  }) {
    final _b1NotEmpty = eftPro.windTranRes?.b1?.text?.isNotEmpty ?? false;
    final _b2NotEmpty = eftPro.windTranRes?.b2?.text?.isNotEmpty ?? false;
    final _txnStatusId = eftPro.windTranRes?.txnStatusId?.inDouble.toInt(); //5
    final _statusId = eftPro.windTranRes?.statusId.inDouble.toInt(); //4
    // log('processing: $_txnStatusId $_statusId');
    return Column(
      children: [
        _header(
          size,
          context,
          title: widget.type == WindcavePayType.Purchase
              ? LN.purchaseCap
              : widget.type == WindcavePayType.Refund
                  ? LN.refundCap
                  : "",
          centerTitle: true,
          showCloseBn:
              false, //!(eftPro.windTranRes?.rcpt?.isNotEmpty ?? false),
        ),
        SizedBox(
          height: size.getH(24),
        ),
        Loading(),
        // SizedBox(
        //   height: size.getH(8),
        // ),
        // Text(
        //   widget.type == WindcavePayType.Purchase
        //       ? "PURCHASE"
        //       : widget.type == WindcavePayType.Refund
        //           ? "REFUND"
        //           : "",
        //   style: TextStyle(
        //     fontSize: size.getS(22),
        //     fontFamily: kFontFMedium,
        //     color: Colors.black,
        //   ),
        // ),
        SizedBox(
          height: size.getH(8),
        ),
        Text(
          eftPro.windTranRes?.dl1 ?? "Processing",
          style: TextStyle(
            fontSize: size.getS(22),
            fontFamily: kFontFMedium,
            color: Colors.black,
          ),
        ),
        SizedBox(
          height: size.getH(32),
        ),
        if (_b1NotEmpty || _b2NotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_b1NotEmpty) ...[
                _textButton(
                  size,
                  title: eftPro.windTranRes?.b1?.text?.toUpperCase() ?? '',
                  onTap: () {
                    eftPro.clickWindpayButton(
                      windRequest: widget.req,
                      bn: eftPro.windTranRes?.b1,
                      bnName: "B1",
                    );
                  },
                ),
                SizedBox(width: size.getW(24))
              ],
              if (_b2NotEmpty)
                _textButton(
                  size,
                  title: eftPro.windTranRes?.b2?.text?.toUpperCase() ?? '',
                  onTap: () {
                    eftPro.clickWindpayButton(
                      windRequest: widget.req,
                      bn: eftPro.windTranRes?.b2,
                      bnName: "B2",
                    );
                  },
                ),
            ],
          ),

        if (eftPro.windTranRes?.dl2?.isNotEmpty ?? false) ...[
          SizedBox(
            height: size.getH(24),
          ),
          Text(
            eftPro.windTranRes?.dl2 ?? '',
            style: TextStyle(
              fontSize: size.getS(20),
              color: Colors.black,
              fontFamily: kFontFMedium,
              height: 1.4,
            ),
          )
        ],

        if (_txnStatusId == 5 &&
            (_statusId == 3 || _statusId == 4) &&
            eftPro.showForceTranButton)
          Padding(
            padding: EdgeInsets.only(top: size.getH(12)),
            child: _textButton(
              size,
              title: "Complete Transaction",
              color: Colors.green.shade700,
              onTap: () {
                _eftPro?.setWindCaveReq();
                Navigator.pop(context, eftPro.windTranRes);
              },
            ),
          )
        else if (eftPro.windTranRes == null)
          Padding(
            padding: EdgeInsets.only(top: size.getH(12)),
            child: _textButton(
              size,
              title: "Cancel",
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),

        // if (eftPro.windTranRes?.b2?.text?.isNotEmpty ?? false)
        //   _textButton(size, title: "CANCEL TRANSCATION", onTap: () {
        //     eftPro.clickWindpayButton(
        //       windRequest: widget.req,
        //       bn: eftPro.windTranRes?.b2,
        //       bnName: "B2",
        //     );
        //   })
      ],
    );
  }

  Widget _transationResult(
    Ssize size, {
    required EftPro eftPro,
  }) {
    // log('transation result');
    final _b1NotEmpty = eftPro.windTranRes?.b1?.text?.isNotEmpty ?? false;
    final _b2NotEmpty = eftPro.windTranRes?.b2?.text?.isNotEmpty ?? false;
    return Column(
      children: [
        _header(
          size,
          context,
          title: widget.type == WindcavePayType.Purchase
              ? "PURCHASE"
              : widget.type == WindcavePayType.Refund
                  ? "REFUND"
                  : "",
          centerTitle: true,
          showCloseBn: !(eftPro.windTranRes?.rcpt?.isNotEmpty ?? false) ||
              (eftPro.windTranRes?.result?.rt?.contains("DECLINED") ?? false),
        ),
        SizedBox(
          height: size.getH(24),
        ),
        if (eftPro.windTranRes?.rcpt == null ||
            eftPro.windTranRes!.rcpt!.isEmpty ||
            (eftPro.windTranRes?.result?.rt?.contains("DECLINED") ?? false))
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
              ))
        else
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
        SizedBox(
          height: size.getH(8),
        ),
        if (eftPro.windTranRes?.dl1?.isNotEmpty ?? false)
          Text(
            eftPro.windTranRes?.dl1 ?? '',
            style: TextStyle(
              fontSize: size.getS(18),
              color: Colors.black,
              fontFamily: kFontFMedium,
              height: 1.4,
            ),
          )
        else if (eftPro.windTranRes?.result?.rt?.isNotEmpty ?? false)
          Text(
            eftPro.windTranRes?.result?.rt ?? '',
            style: TextStyle(
              fontSize: size.getS(18),
              color: Colors.black,
              fontFamily: kFontFMedium,
              height: 1.4,
            ),
          ),
        SizedBox(
          height: size.getH(32),
        ),
        if (_b1NotEmpty || _b2NotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_b1NotEmpty) ...[
                _textButton(
                  size,
                  title: eftPro.windTranRes?.b1?.text?.toUpperCase() ?? '',
                  onTap: () {
                    eftPro.clickWindpayButton(
                      windRequest: widget.req,
                      bn: eftPro.windTranRes?.b1,
                      bnName: "B1",
                    );
                  },
                ),
                SizedBox(width: size.getW(24))
              ],
              if (_b2NotEmpty)
                _textButton(
                  size,
                  title: eftPro.windTranRes?.b2?.text?.toUpperCase() ?? '',
                  onTap: () {
                    eftPro.clickWindpayButton(
                      windRequest: widget.req,
                      bn: eftPro.windTranRes?.b2,
                      bnName: "B2",
                    );
                  },
                ),
            ],
          )
        else if (eftPro.windTranRes?.rcpt == null ||
            eftPro.windTranRes!.rcpt!.isEmpty ||
            (eftPro.windTranRes?.result?.rt?.contains("DECLINED") ?? false))
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _textButton(
                size,
                title: LN.retry,
                onTap: eftPro.payloading ||
                        (widget.terminal?.every((a) => !a.isSelected) ?? false)
                    ? null
                    : _pay,
              ),
              SizedBox(width: size.getW(16)),
              _textButton(
                size,
                title: LN.cancel,
                color: Colors.red,
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          )
        else
          SizedBox(
            height: size.getH(24),
          ),
        if (eftPro.windTranRes?.dl2?.isNotEmpty ?? false)
          Text(
            eftPro.windTranRes?.dl2 ?? '',
            style: TextStyle(
              fontSize: size.getS(20),
              color: Colors.black,
              fontFamily: kFontFMedium,
              height: 1.4,
            ),
          ),
      ],
    );
  }

  Widget _textButton(
    Ssize size, {
    Function()? onTap,
    required String title,
    Color color = kSecondaryColor,
  }) {
    return TextButton(
      onPressed: onTap,
      style: ButtonStyle(
          side: MaterialStateProperty.all(BorderSide(color: color)),
          padding: MaterialStateProperty.all(EdgeInsets.symmetric(
              horizontal: size.getW(24), vertical: size.getH(8)))),
      child: Text(
        title,
        style: TextStyle(
          fontSize: size.getS(18),
          color: color,
        ),
      ),
    );
  }
}
