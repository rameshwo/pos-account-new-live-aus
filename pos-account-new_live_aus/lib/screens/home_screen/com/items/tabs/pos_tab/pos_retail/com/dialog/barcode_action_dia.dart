import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/menu/pos_retail_pro.dart';
import 'package:pos_account/services/printer/com/image_print.dart';
import 'package:pos_account/widgets/input/dropdown/title_drop_down.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:provider/provider.dart';

enum BarcodeAction { Generate, Print }

class BarcodeActionDia extends StatefulWidget {
  final BarcodeAction barcodeAction;
  final String variationId;
  const BarcodeActionDia({
    super.key,
    required this.barcodeAction,
    required this.variationId,
  });

  @override
  State<BarcodeActionDia> createState() => _BarcodeActionDiaState();
}

class _BarcodeActionDiaState extends State<BarcodeActionDia> {
  final _streamCltr = StreamController<double>();
  final _formKey = GlobalKey<FormState>();

  StreamSubscription<double>? _streamSubscription;

  int imageLength = 1;
  double progress = 0;
  String printingMessage = LN.printing;

  load() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() {
    _streamSubscription = _streamCltr.stream.listen((event) {
      if (imageLength == 0) return;
      if (event > 0 && event < 1) {
        printingMessage = LN.searchPrinter;
      } else {
        printingMessage = LN.printing;
      }
      if (event > 0) {
        progress = event / imageLength;
      } else {
        progress = event;
      }
      load();
    });
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    _streamCltr.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final posPro = Provider.of<PosRetailPro>(context);
    final isPrinting = progress > 0 && progress < 1;
    return Container(
      constraints: BoxConstraints(
        maxHeight: size.height / 2,
        minHeight: size.height / 5,
      ),
      width: size.width / 2.1,
      child: Form(
        key: _formKey,
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: size.getH(12),
            ),
            Row(
              children: [
                Text(
                  widget.barcodeAction == BarcodeAction.Generate
                      ? LN.generateBarcode
                      : LN.printBarcode,
                  style: TextStyle(
                    fontSize: size.getS(18),
                    // fontFamily: ,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Spacer(),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.close,
                      size: size.getS(24),
                    ))
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: TitleDropDown(
                    isReq: true,
                    title: "Pos Printer",
                    borderColor: Colors.black26,
                    list: posPro.barcodeAddSec?.posPrinters == null
                        ? []
                        : posPro.barcodeAddSec!.posPrinters!
                            .map((e) => e.name ?? '')
                            .toList(),
                    indexVal: posPro.printerIndex,
                    onChanged: (p0) {
                      posPro.printerIndex = p0;
                      posPro.notify;
                    },
                  ),
                ),
                SizedBox(
                  width: size.getW(16),
                ),
                if (widget.barcodeAction == BarcodeAction.Generate)
                  Flexible(
                    child: TitleDropDown(
                      title: "Barcode Type",
                      isReq: true,
                      borderColor: Colors.black26,
                      list: posPro.barcodeAddSec?.barCodeTypes == null
                          ? []
                          : posPro.barcodeAddSec!.barCodeTypes!
                              .map((e) => e.name ?? '')
                              .toList(),
                      indexVal: posPro.barcodeTypeIndex,
                      onChanged: (p0) {
                        posPro.barcodeTypeIndex = p0;
                        posPro.notify;
                      },
                    ),
                  )
                else
                  Flexible(
                      child: TitleTextForm(
                    title: LN.numOfBarcode,
                    textCltr: posPro.numBarcodeCltr,
                    textInputType: TextInputType.number,
                    borderColor: Colors.black26,
                  ))
              ],
            ),
            SizedBox(
              height: size.getH(32),
            ),
            AnimatedContainer(
              height: isPrinting ? 32 : 0,
              duration: Duration(milliseconds: 200),
              child: Row(
                children: [
                  Expanded(
                      child: LinearProgressIndicator(
                    value: progress,
                  )),
                  SizedBox(
                    width: size.getW(12),
                  ),
                  Text(
                    "${(progress * 100).round()}%",
                    style: TextStyle(
                      fontSize: size.getS(18),
                      // fontFamily: ,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            if (widget.barcodeAction == BarcodeAction.Generate)
              LoadButton(
                width: 240,
                hPad: 12,
                btnText: LN.generate,
                btnColor: kPrimaryColor,
                loading: posPro.generateLoading,
                onsave: () {
                  if (_formKey.currentState!.validate())
                    posPro.generateBarcode(
                      variationId: widget.variationId,
                      diaCtx: context,
                    );
                },
              )
            else
              LoadButton(
                width: 240,
                hPad: 12,
                btnText: LN.print,
                btnColor: kSecondaryColor,
                loadingText: isPrinting ? printingMessage : null,
                loading: posPro.generateLoading || isPrinting,
                onsave: () {
                  if (_formKey.currentState!.validate()) {
                    posPro
                        .printBarcode(
                      variationId: widget.variationId,
                      diaCtx: context,
                    )
                        .then((value) {
                      if (value != null) {
                        // final value = BarcodePrintRes.fromJson({
                        //   "image": [
                        //     "https://fileserver.posapt.au/Production/POS/Resources/BarCodeImages/4ea69b89-9486-40b1-8a75-4876d4ca3231/cUSDSHcs43-Smederevka Nikolas White wine 10.5%25 vol. Alcohol 1L(Regular).png",
                        //     "https://fileserver.posapt.au/Production/POS/Resources/BarCodeImages/4ea69b89-9486-40b1-8a75-4876d4ca3231/cUSDSHcs43-Smederevka Nikolas White wine 10.5%25 vol. Alcohol 1L(Regular).png",
                        //     "https://fileserver.posapt.au/Production/POS/Resources/BarCodeImages/4ea69b89-9486-40b1-8a75-4876d4ca3231/cUSDSHcs43-Smederevka Nikolas White wine 10.5%25 vol. Alcohol 1L(Regular).png"
                        //   ],
                        //   "ipAddress": "192.168.1.87",
                        //   "port": "9100"
                        // });
                        if (value.image != null) {
                          imageLength = value.image!.length;
                        }
                        ImagePrint.printBarcode(
                          context,
                          data: value,
                          streamCltr: _streamCltr,
                        );
                      }
                    });
                  }
                },
              ),
            SizedBox(
              height: size.getH(24),
            ),
          ],
        ),
      ),
    );
  }
}
