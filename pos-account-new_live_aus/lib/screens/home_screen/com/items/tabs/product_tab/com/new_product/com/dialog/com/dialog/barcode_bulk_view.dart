import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/config/validator.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/menu/generate_barcode_pro.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/loading.dart';
import 'package:provider/provider.dart';
import '../barcode_view.dart';

class BulkBarCodeView extends StatelessWidget {
  const BulkBarCodeView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final genPro = Provider.of<GenBarcodePro>(context);
    return Processing(
      loading: genPro.pageLoad,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: size.height / 1.14,
          minHeight: size.height / 5,
        ),
        width: size.width / 1.15,
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
                    "Download Barcodes",
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
              if (genPro.bulkBarCode?.barcodeLabelPrintViewModels != null)
                _bulkView(size, genPro),
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
                            genPro.printBulkBarcode(context);
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
      ),
    );
  }

  Widget _bulkView(Ssize size, GenBarcodePro genPro) {
    return Wrap(
      spacing: size.getW(8),
      runSpacing: size.getH(16),
      children: List.generate(
          genPro.bulkBarCode!.barcodeLabelPrintViewModels!.length, (index) {
        final data = genPro.bulkBarCode!.barcodeLabelPrintViewModels![index];
        final _caputureWidget = BarCodeView(
          size: size,
          barcode: data.barCodeNumber ?? '',
          title: data.productName,
          code: data.productCode,
          curSym: genPro.curSym,
          price: data.actualPrice.inDouble.roundToNString(),
          discountPrice: data.discountPrice?.inDouble == 0
              ? null
              : data.discountPrice.inDouble.roundToNString(),
        );
        data.captureWidget = _caputureWidget;
        return _caputureWidget;
      }),
    );
  }
}
