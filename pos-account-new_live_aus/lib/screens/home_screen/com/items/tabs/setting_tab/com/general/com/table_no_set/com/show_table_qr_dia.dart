import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pos_account/config/size_config.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/constant/date_format_keys.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/providers/setting/general/all_table_no_pro.dart';
import 'package:pos_account/services/printer/com/barcode_qr_print.dart';
import 'package:pos_account/widgets/image/image_error.dart';
import 'package:pos_account/widgets/load_btn.dart';
import 'package:pos_account/widgets/no_items_sec.dart';
import 'package:provider/provider.dart';

class ShowTableQRDia extends StatelessWidget {
  const ShowTableQRDia({super.key});

  Future<void> _downloadQR(BuildContext context,
      {Widget? captureWidget, required String name}) async {
    await BarcodeQrPrint.capture(
        captureWidget: captureWidget,
        isBarcode: false,
        fileName: "${name}_${YMD_T_FORMAT.format(DateTime.now())}.jpg");

    // final byte = await ImageService.capture(key: imageKey);
    // if (byte != null) {
    //   final filePath = await ImageService.saveFile(
    //       byte, "${name}_${YMD_T_FORMAT.format(DateTime.now())}.jpg");
    //   if (filePath != null)
    //     IfException.showMessage(message: LN.downloadCmpt, isError: false);
    // await showDialog(
    //     context: context,
    //     builder: (builder) => SuggestDia(
    //           description: "Do you want to open Table QR?",
    //           // oK: () async {
    //           //   await ImageService.openFile(filePath);
    //           //   Navigator.pop(context);
    //           // },
    //         ));
    // }
  }

  Future<void> _printQR(
    BuildContext context, {
    Widget? captureWidget,
    required String name,
    required AllTableNumPro atnp,
  }) async {
    final imageModel = await BarcodeQrPrint.capture(
        captureWidget: captureWidget, isBarcode: false);

    // final filePath = await ImageService.getTempImagePathFromKey(
    //     globalKey: imageKey, title: name);

    if (imageModel != null) {
      // final barcodeModel = ImagePrintModel(
      //   filePath: filePath,
      //   height: 400,
      //   width: 400,
      //   printCount: 1,
      // );

      // atnp.printerDetails = [
      //   InvoicePrinterDetail(
      //       ipAddress: "192.168.1.100", port: "9100", printerType: "Ethernet")
      // ];

      await BarcodeQrPrint.print(
        context,
        data: [imageModel],
        printerDetail: atnp.printerDetails,
        title: "Print QR CODE",
        subTitle: "Print QR CODE",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = Ssize(context);
    final atnp = Provider.of<AllTableNumPro>(context);
    return Container(
      constraints: BoxConstraints(
        maxHeight: size.height / 1.14,
        minHeight: size.height / 5,
      ),
      width: size.width / 1.4,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: size.getH(24),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LN.tableQr,
                style: TextStyle(
                  fontSize: size.getS(24),
                  // fontFamily: ,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close))
            ],
          ),
          SizedBox(
            height: size.getH(18),
          ),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (atnp.tableQrList != null && atnp.tableQrList!.isNotEmpty)
                    Wrap(
                      children: [
                        ...List.generate(atnp.tableQrList!.length, (index) {
                          final tableName =
                              "${atnp.tableQrList![index].tableName ?? ''} (${atnp.tableQrList![index].tableLocation ?? ''})";

                          final _captureWidget = Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              // borderRadius: BorderRadius.circular(5),
                            ),
                            child: Column(
                              children: [
                                CachedNetworkImage(
                                  imageUrl:
                                      atnp.tableQrList![index].qrImageUrl ?? '',
                                  height: size.getS(220),
                                  width: size.getS(220),
                                  fit: BoxFit.cover,
                                  placeholder: ImageError.load,
                                  errorWidget: ImageError.notSupportIcon,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      // top: size.getH(0),
                                      bottom: size.getH(6)),
                                  child: Text(
                                    tableName,
                                    style: TextStyle(
                                      fontSize: size.getS(17),
                                      color: Colors.black,
                                      fontFamily: kFontFMedium,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          );

                          atnp.tableQrList![index].captureWidget =
                              _captureWidget;
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.getW(12),
                                vertical: size.getW(16)),
                            child: SizedBox(
                              width: size.getS(224),
                              child: Column(
                                children: [
                                  _captureWidget,

                                  // Text(
                                  //   atnp.tableQrList![index]
                                  //           .tableLocation ??
                                  //       '',
                                  //   style: TextStyle(
                                  //     fontSize: size.getS(18),
                                  //     color: Colors.black,
                                  //   ),
                                  //   textAlign: TextAlign.center,
                                  // ),
                                  SelectableText(
                                    atnp.tableQrList![index].url ?? '',
                                    style: TextStyle(
                                      fontSize: size.getS(14),
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      LoadButton(
                                        vPad: 4,
                                        hPad: 8,
                                        btnText: 'Download',
                                        width: 100,
                                        onsave: () {
                                          _downloadQR(
                                            context,
                                            captureWidget: atnp
                                                .tableQrList![index]
                                                .captureWidget,
                                            name: tableName,
                                          );
                                        },
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            _printQR(
                                              context,
                                              captureWidget: atnp
                                                  .tableQrList![index]
                                                  .captureWidget,
                                              name: tableName,
                                              atnp: atnp,
                                            );
                                          },
                                          icon: Icon(
                                            Icons.print,
                                            size: size.getS(25),
                                            color: kPrimaryColor,
                                          ))
                                    ],
                                  ),
                                  // SizedBox(height: size.getH(12)),
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.center,
                                  //   children: [
                                  //     Container(
                                  //       decoration: BoxDecoration(
                                  //         shape: BoxShape.circle,
                                  //         color: kSecondaryColor,
                                  //       ),
                                  //       child: InkWell(
                                  //         borderRadius:
                                  //             BorderRadius.circular(50),
                                  //         onTap: () {
                                  //           _downloadQR(
                                  //             context,
                                  //             imageKey: atnp.tableQrList![index]
                                  //                 .globalKey,
                                  //             name: _tableName,
                                  //           );
                                  //         },
                                  //         child: Padding(
                                  //           padding: EdgeInsets.all(8),
                                  //           child: Icon(
                                  //             Icons.download,
                                  //             color: Colors.white,
                                  //             size: size.getS(24),
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //     SizedBox(width: size.getW(16)),
                                  //     Container(
                                  //       decoration: BoxDecoration(
                                  //         shape: BoxShape.circle,
                                  //         color: kSecondaryColor,
                                  //       ),
                                  //       child: InkWell(
                                  //         borderRadius:
                                  //             BorderRadius.circular(50),
                                  //         onTap: () {},
                                  //         child: Padding(
                                  //           padding: EdgeInsets.all(8),
                                  //           child: Icon(
                                  //             Icons.print,
                                  //             color: Colors.white,
                                  //             size: size.getS(24),
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     )
                                  //   ],
                                  // ),
                                ],
                              ),
                            ),
                          );
                        })
                      ],
                    )
                  else
                    NoItemsSec(size: size, title: "No table QR found")
                ],
              ),
            ),
          ),
          SizedBox(
            height: size.getH(18),
          ),
        ],
      ),
    );
  }
}
