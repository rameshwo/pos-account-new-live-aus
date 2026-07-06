// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/model/home/menu/place_order/place_order_res.dart';
import 'package:pos_account/services/printer/stk_print.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/no_items_sec.dart';

class PrinterListDia2 extends StatefulWidget {
  final StkPrintManager stkPrintManager;
  const PrinterListDia2({
    super.key,
    required this.stkPrintManager,
  });

  static bool isPrintDiaOpen = false;

  @override
  State<PrinterListDia2> createState() => _PrinterListDia2State();
}

class _PrinterListDia2State extends State<PrinterListDia2> {
  PlaceOrderRes get order => widget.stkPrintManager.order;
  Future<void> Function()? get runSuccessFun =>
      widget.stkPrintManager.runSuccessFun;

  void _load() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.stkPrintManager.load = _load;

    WidgetsBinding.instance
        .addPostFrameCallback((_) => widget.stkPrintManager.setData());
  }

  // void closeDia() {
  //   final _allPrinted = widget.stkPrintManager.printerList
  //       .every((a) => a.printerStatus == PrinterStatus.Success);
  //   if (_allPrinted &&
  //       PrinterListDia2.isPrintDiaOpen &&
  //       Navigator.canPop(context)) {
  //     Navigator.pop(context);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final printerList = widget.stkPrintManager.printerList;
    return Container(
      constraints: BoxConstraints(
        maxHeight: size.height / 1.2,
        minHeight: size.height / 4,
      ),
      width: size.width / 2.8,
      padding: EdgeInsets.symmetric(vertical: size.getH(8)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Available Printers",
                style: TextStyle(
                  fontSize: size.getS(22),
                  // fontFamily: ,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Spacer(),
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close),
              )
            ],
          ),
          Text(
            "Connection status of the printers",
            // "View and manage your connected printers. Click 'Connect' to establish a connection with an offline printer.",
            style: TextStyle(
              fontSize: size.getS(16),
              color: Colors.black54,
            ),
          ),
          SizedBox(height: size.getH(12)),
          if (printerList.isNotEmpty)
            Flexible(
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black38),
                    borderRadius: BorderRadius.circular(5)),
                padding: EdgeInsets.symmetric(
                    horizontal: size.getW(12), vertical: size.getH(12)),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...List.generate(printerList.length, (index) {
                        final _printModel = printerList[index];
                        return ListTile(
                          leading: Icon(
                            Icons.print,
                            size: size.getS(32),
                            color: _printModel.isOnline
                                ? Colors.green
                                : Colors.grey,
                          ),
                          minLeadingWidth: 0,
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            _printModel.title ??
                                ("${_printModel.ip ?? ''} [${_printModel.type ?? ''}]"),
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: kFontFMedium,
                              fontSize: size.getS(18),
                            ),
                          ),
                          subtitle: _printModel.printerStatus ==
                                  PrinterStatus.Success
                              ? _subTitle(size,
                                  message: " PRINT SUCCESS", status: true)
                              : _printModel.printerStatus ==
                                      PrinterStatus.Failed
                                  ? (_printModel.isOnline
                                      ? _subTitle(size,
                                          message: " FAILED TO PRINT",
                                          status: false)
                                      : _subTitle(size,
                                          message: " CONNECTION FAILED",
                                          status: false))
                                  : _printModel.printerStatus ==
                                              PrinterStatus.Printing &&
                                          _printModel.isOnline
                                      ? _subTitle(size,
                                          message: " PRINTING", status: true)
                                      : _printModel.printerStatus ==
                                              PrinterStatus.Retrying
                                          ? _subTitle(size,
                                              message:
                                                  " RETRYING", // ${widget.stkPrintManager.retryingCount(_printModel.type)}",
                                              status: true)
                                          : _printModel.printerStatus ==
                                                  PrinterStatus.NoData
                                              ? _subTitle(size,
                                                  message: " NO DATA TO PRINT",
                                                  status: false)
                                              : _subTitle(size,
                                                  message: " CONNECTING",
                                                  status: true),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Container(
                              //   decoration: BoxDecoration(
                              //     color: Colors.green.withOpacity(0.15),
                              //     borderRadius: BorderRadius.circular(5),
                              //   ),
                              //   padding: EdgeInsets.symmetric(
                              //       vertical: size.getH(8),
                              //       horizontal: size.getW(12)),
                              //   child: Text(
                              //     "Printed",
                              //     style: TextStyle(
                              //       color: Colors.green.shade700,
                              //       fontWeight: FontWeight.bold,
                              //       fontSize: size.getS(16),
                              //     ),
                              //   ),
                              // )
                              if (_printModel.printerStatus ==
                                  PrinterStatus.Failed)
                                LoadButton(
                                  vPad: 6,
                                  hPad: 4,
                                  width: 100,
                                  onsave: () async {
                                    widget.stkPrintManager.print(
                                      data: _printModel.image,
                                      ip: _printModel.ip,
                                      port: _printModel.port,
                                      printerType: _printModel.type,
                                    );
                                  },
                                  // btnColor: Colors.green.shade600,
                                  btnText: "RETRY",
                                )
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            )
          else
            NoItemsSec(size: size, title: "No Printer has items"),
          // ...List.generate(messageList.length, (i) {
          //   return Text(messageList[i]);
          // })
        ],
      ),
    );
  }

  Widget _subTitle(Ssize size,
      {required String message, required bool status}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          status ? Icons.check_circle_outline : Icons.cancel_outlined,
          size: size.getS(18),
          color: status ? Colors.green : Colors.red,
        ),
        Text(
          " $message",
          style: TextStyle(
            color: status ? Colors.green : Colors.red,
            fontSize: size.getS(16),
          ),
        ),
      ],
    );
  }
}
