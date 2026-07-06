import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:pos_account/repository/handler.dart';
import 'package:pos_account/services/printer/bluetooth/bluetooth_service.dart';
import 'package:pos_account/services/printer/printer_enum.dart';
import 'package:pos_account/services/printer/printer_service.dart';
import 'package:pos_account/services/printer/usb/usb_service.dart';

class SignaturePrint {
  static Future<void> printSignature({
    String? data,
    required String? orderId,
  }) async {
    if (orderId == null) return;

    final signatureRes = await Handler.printSignatureReceipt(orderId: orderId);

    if (signatureRes?.posPrinterResponseViewModels == null ||
        signatureRes!.posPrinterResponseViewModels!.isEmpty) return;

    for (final e in signatureRes.posPrinterResponseViewModels!) {
      if (e.printEftPosSignature ?? false) {
        if (e.printerType == PrinterTypeEnum.Bluetooth.name) {
          await BluetoothService.printText(macAddress: e.ipAddress, data: data
              //  Utils.decodeAndFormatData(data)
              );
        } else if (e.printerType == PrinterTypeEnum.USB.name) {
          await UsbService.printText(
              data: data, // Utils.decodeAndFormatData(data),
              vendorId: e.ipAddress,
              productId: e.port);
        } else {
          await PrinterService.checkDevice(
            ip: e.ipAddress,
            port: int.tryParse(e.port ?? '') ?? 9100,
            paperSize: 'mm80',
            doPrint: true,
            run: ({required NetworkPrinter printer}) async {
              // print("run functio working");

              await _printData(
                printer: printer,
                data: data, // Utils.decodeAndFormatData(data),
              );
            },
          );
        }
      }
    }
  }

  static Future<void> _printData(
      {required NetworkPrinter printer, String? data}) async {
    if (data == null) return;
    try {
      printer.text(data, styles: PosStyles(align: PosAlign.center));
      printer.feed(1);
      printer.cut();
      printer.disconnect(delayMs: 1);
    } on ArgumentError catch (e) {
      printer.cut();
      printer.disconnect(delayMs: 1);
      PrinterService.printError(e);
    } catch (e) {
      printer.cut();
      printer.disconnect(delayMs: 1);
    }
  }
}
