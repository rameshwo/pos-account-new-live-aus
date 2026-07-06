import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/product/gen_barcode/invoice_printer_detail.dart';
import 'package:pos_account/repository/if_exception.dart';
import 'package:pos_account/services/image/image_service.dart';
import 'package:pos_account/services/printer/bluetooth/blue_receipt.dart';
import 'package:pos_account/services/printer/bluetooth/bluetooth_service.dart';
import 'package:pos_account/services/printer/com/image_print.dart';
import 'package:pos_account/services/printer/printer_enum.dart';
import 'package:pos_account/services/printer/usb/usb_service.dart';
import 'package:pos_account/widgets/dialog/confirm_dialog.dart';
import 'package:screenshot/screenshot.dart';

class BarcodeQrPrint {
  static final _screenshotController = ScreenshotController();

  static Future<ImagePrintModel?> capture({
    Widget? captureWidget,
    int printCount = 1,
    bool isBarcode = true,
    String? fileName,
  }) async {
    if (captureWidget == null) return null;

    double _width = 0.0;
    double _height = 0.0;

    final _widget = LayoutBuilder(builder: (context, constr) {
      _width = constr.maxWidth;
      _height = constr.maxHeight;

      // print("${constr.maxHeight} ${constr.maxWidth}");
      return captureWidget;
    });

    final _bytes = await _screenshotController.captureFromLongWidget(
      _widget,
      pixelRatio: 2,
      delay: Duration(milliseconds: 50),
    );

    if (fileName != null) {
      await _captureAndSave(bytes: _bytes, fileName: fileName);
      return null;
    }

    return ImagePrintModel(
      // filePath: '',
      staticByte: _bytes,
      width: _width.floor(),
      height: _height.floor(),
      printCount: printCount, // int.tryParse(noOfPrintCltr.text) ?? 1,
      isBarcode: isBarcode,
    );
  }

  static Future<void> _captureAndSave(
      {required Uint8List bytes, required String fileName}) async {
    final _status = await ImageService.saveFile(bytes, fileName);
    // final permission =
    //     await ImageService.getPermission(Permission.mediaLibrary);
    // if (!permission) return;

    // final path = await AndroidPathProvider.downloadsPath;

    // final _bytes = await _screenshotController.captureAndSave(
    //   path,
    //   fileName: fileName,
    //   pixelRatio: 2,
    //   delay: Duration(milliseconds: 50),
    // );
    if (_status != null) {
      IfException.showMessage(message: LN.downloadCmpt, isError: false);
    }
  }

  static Future<void> print(
    BuildContext context, {
    List<ImagePrintModel>? data,
    InvoicePrinterDetail? printerDetail,
    String? title,
    String? subTitle,
  }) async {
    if (data == null || printerDetail == null) return;

    await showDialog(
        context: context,
        builder: (builder) => ConfirmDialog(
              title: title ?? LN.printBarcode,
              subTitle: subTitle ?? LN.printBarcode,
              actionText: LN.print,
              onDelete: () async {
                await _printStart(
                  input: data,
                  printerDetail: printerDetail,
                );
                return null;
              },
              onCancel: () async {
                Navigator.pop(context);
                await Future.delayed(Duration(milliseconds: 300));
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
            ));
  }

  static Future<void> _printStart({
    required List<ImagePrintModel> input,
    required InvoicePrinterDetail printerDetail,
  }) async {
    for (int i = 0; i < input.length; i++) {
      for (int j = 0; j < input[i].printCount; j++) {
        if (printerDetail.printerType == PrinterTypeEnum.Bluetooth.name) {
          await BluetoothService.printImage(
              data: input[i], macAddress: printerDetail.ipAddress);
        } else if (printerDetail.printerType == PrinterTypeEnum.USB.name) {
          if (input[i].isBarcode) input[i].width = 550;

          await UsbService.printImage(
              data: input[i],
              vendorId: printerDetail.ipAddress,
              productId: printerDetail.port);
        } else {
          final bytes = await BlueReceipt.getByteDataServer(
            data: input[i],
          );
          if (bytes != null) {
            await ImagePrint.sendToEthernetPrinter(
              bytes: bytes,
              port: int.tryParse(printerDetail.port ?? '') ?? 9100,
              ip: printerDetail.ipAddress ?? '',
              // chunkSize: 512,
            );
          }
          // await PrinterService.checkDevice(
          //   ip: printerDetail[k].ipAddress,
          //   port: int.tryParse(printerDetail[k].port ?? '9100') ?? 9100,
          //   paperSize: 'mm80',
          //   doPrint: true,
          //   run: ({required NetworkPrinter printer}) async {
          //     // print("run functio working");
          //     await ImagePrint.printImage(
          //       printer: printer,
          //       imagePath: input[i].filePath,
          //       height: input[i].height,
          //       width: input[i].width,
          //     );
          //   },
          // );
        }
      }
    }
  }
}

class ImagePrintModel {
  final String filePath;
  final int printCount;
  int height;
  int width;
  final Uint8List? staticByte;
  bool isBarcode;

  ImagePrintModel({
    this.filePath = '',
    this.printCount = 1,
    this.height = 300,
    this.width = 300,
    this.staticByte,
    this.isBarcode = false,
  });
}
