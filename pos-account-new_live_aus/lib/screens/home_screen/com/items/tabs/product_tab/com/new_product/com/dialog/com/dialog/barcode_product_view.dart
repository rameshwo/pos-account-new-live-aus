import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/product/gen_barcode/combo/combo_barcode_print_req.dart';
import 'package:pos_account/providers/menu/generate_barcode_pro.dart';
import 'package:pos_account/widgets/input/text_form/title_text_form.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:provider/provider.dart';
import '../barcode_view.dart';

class GenBarCodeProductDia extends StatefulWidget {
  final BarcodePrintReq? req;
  final BarCodeType type;
  const GenBarCodeProductDia({
    super.key,
    this.req,
    required this.type,
  });

  static List<Widget>? actionWidget({
    BarcodePrintReq? req,
    required BarCodeType type,
  }) {
    return [
      Builder(builder: (context) {
        final size = Ssize(context);
        return InkWell(
            borderRadius: BorderRadius.circular(5),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (builder) => SimpleDialog(
                        backgroundColor: kBackgroundColor,
                        titlePadding: EdgeInsets.zero,
                        contentPadding: EdgeInsets.symmetric(horizontal: 24),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        children: [
                          GenBarCodeProductDia(req: req, type: type),
                        ],
                      ));
            },
            child: Container(
              decoration: BoxDecoration(
                color: kSecondaryColor.withAlpha(50),
                borderRadius: BorderRadius.circular(5),
              ),
              padding: EdgeInsets.all(size.getS(5)),
              child: Icon(
                Icons.print_outlined,
                color: kSecondaryColor,
                size: size.getS(24),
              ),
            ));
      })
    ];
  }

  @override
  State<GenBarCodeProductDia> createState() => _GenBarCodeProductDiaState();
}

class _GenBarCodeProductDiaState extends State<GenBarCodeProductDia> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  GenBarcodePro? _genBarPro;

  void getData() {
    _genBarPro = Provider.of<GenBarcodePro>(context, listen: false);
    _genBarPro?.barcodePrint(req: widget.req, type: widget.type);
  }

  @override
  void dispose() {
    _genBarPro?.clearProd();
    super.dispose();
  }

  // GlobalKey? _globalKey;
  Widget? _printWidget;

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final genPro = Provider.of<GenBarcodePro>(context);

    _printWidget = genPro.barcodeCltr.text.isNotEmpty
        ? BarCodeView(
            size: size,
            barcode: genPro.barcodeCltr.text,
            title: genPro.nameCltr.text,
            code: genPro.codeCltr.text,
            curSym: genPro.curSym,
            price: genPro.priceCltr.text.inDouble.roundToNString(),
            discountPrice: genPro.printData?.discountPrice?.inDouble == 0
                ? null
                : genPro.printData?.discountPrice.inDouble.roundToNString(),
          )
        : null;
    return Processing(
        loading: genPro.productBarLoad,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: size.height / 1.14,
            minHeight: size.height / 5,
          ),
          width: size.width / 1.2,
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: size.getH(12),
                ),
                Row(
                  children: [
                    Text(
                      LN.generateBarcode,
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
                SizedBox(
                  height: size.getH(12),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: kPrimaryColor.withAlpha(60),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: size.getW(24), vertical: size.getH(24)),
                  child: Column(
                    children: [
                      if (_printWidget != null) _printWidget!,
                      SizedBox(
                        height: size.getH(12),
                      ),
                      Wrap(
                        spacing: size.getW(16),
                        runSpacing: size.getH(16),
                        children: [
                          TitleTextForm(
                            pWidth: 0.12,
                            isReq: false,
                            readOnly: true,
                            title: LN.productCode,
                            textCltr: genPro.codeCltr,
                            textInputType: TextInputType.number,
                            borderColor: Colors.black26,
                            fillColor: Colors.grey.shade100,
                          ),
                          TitleTextForm(
                            pWidth: 0.16,
                            isReq: false,
                            readOnly: true,
                            title: LN.productName,
                            textCltr: genPro.nameCltr,
                            borderColor: Colors.black26,
                            fillColor: Colors.grey.shade100,
                          ),
                          TitleTextForm(
                            pWidth: 0.12,
                            isReq: false,
                            prefixText: Text(genPro.curSym),
                            title: LN.price,
                            textCltr: genPro.priceCltr,
                            readOnly: true,
                            textInputType: TextInputType.number,
                            borderColor: Colors.black26,
                            fillColor: Colors.grey.shade100,
                          ),
                          TitleTextForm(
                            pWidth: 0.16,
                            isReq: false,
                            title: "Barcode Number",
                            readOnly: true,
                            textCltr: genPro.barcodeCltr,
                            textInputType: TextInputType.number,
                            borderColor: Colors.black26,
                            fillColor: Colors.grey.shade100,
                          ),
                          TitleTextForm(
                            pWidth: 0.14,
                            isReq: false,
                            title: "No. of Print",
                            textCltr: genPro.noOfPrintCltr,
                            textInputType: TextInputType.number,
                            borderColor: Colors.black26,
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: size.getH(16),
                ),
                Row(
                  children: [
                    LoadButton(
                      btnText: LN.print,
                      vPad: 8,
                      btnColor: kSecondaryColor,
                      loading: genPro.printButtonLoad,
                      onsave: genPro.printButtonLoad
                          ? null
                          : () {
                              genPro.printBarcode(context,
                                  captureWidget: _printWidget);
                            },
                    ),
                    SizedBox(
                      width: size.getW(12),
                    ),
                    LoadButton(
                      btnText: LN.cancel,
                      vPad: 8,
                      btnColor: Colors.red.shade700,
                      onsave: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
                SizedBox(
                  height: size.getH(12),
                ),
              ],
            ),
          ),
        ));
  }
}
