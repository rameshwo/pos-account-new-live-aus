import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/ui_model/print_invoice.dart';
import 'package:pos_account/repository/if_exception.dart';
import 'package:pos_account/services/printer/bluetooth/blue_receipt.dart';
import 'package:pos_account/services/printer/com/barcode_qr_print.dart';
import 'package:thermal_printer_plus/thermal_printer.dart';
import '../stk_print.dart';

class UsbService {
  // static FlutterUsbPrinter get _flutterUsbPrinter => FlutterUsbPrinter();
  static final _printerManager = PrinterManager.instance;
  static PrinterManager get printerManager => _printerManager;

  static List<PrinterDevice>? deviceList;

  static PrinterDevice? get connectedDevice => __connectedDevice;

  static PrinterDevice? __connectedDevice;

  static Future<void> getDevicelist({Function()? fun}) async {
    deviceList = [];

    kPrint('usb -discover');

    _printerManager.discovery(type: PrinterType.usb).listen((_val) {
      if (!deviceList!
          .any((a) => a.name.toLowerCase() == _val.name.toLowerCase())) {
        deviceList!.add(_val);
      }
      if (fun != null) fun();
      kPrint("USB DEVICE LIST : ${deviceList?.length}");
    });

    // try {
    //   final res = await FlutterUsbPrinter.getUSBDeviceList();
    //   final resData =
    //       List<UsbDevice>.from(res.map((x) => UsbDevice.fromJson(x)));
    //   deviceList = [];

    //   for (final e in resData) {
    //     if (e.productName?.toLowerCase().contains('print') ?? false) {
    //       deviceList!.add(e);
    //     }
    //   }
    // } catch (e) {
    //   IfException.showMessage(message: LN.failedToGetUsbDevices);
    // }

    // print(" length: ${results?.length}");
    // showToast(" printer available: ${results?.length}");
  }

  static Future<bool?> connect({
    required PrinterDevice device,
    bool doPrint = true,
  }) async {
    if (device.vendorId == null || device.productId == null) return null;
    try {
      if (connectedDevice != null) {
        await close();
      }
      kPrint('usb -connect');
      final status = await _printerManager.connect(
          type: PrinterType.usb,
          model: UsbPrinterInput(
              name: device.name,
              productId: device.productId,
              vendorId: device.vendorId));

      // await _flutterUsbPrinter.connect(
      //     int.parse(device.vendorId!), int.parse(device.productId!));

      if (status) {
        __connectedDevice = device;

        if (!doPrint) return true;

        final bytes = await BlueReceipt.getPrinterConnect();

        if (bytes != null) {
          // await Future.delayed(Duration(seconds: 1));
          final _status = await printByte(bytes: bytes);

          if (_status ?? false) {
            IfException.showMessage(
                message: LN.printerIsConnected, isError: false);
          }
        }
      }
      return status;
    } catch (e) {
      // response = 'Failed to get platform version.';
      IfException.showMessage(message: LN.failedToConnect + LN.printer);
    }
    return null;
  }

  // static Future<bool?> usbprintIsolate(
  //   Map<String, dynamic> params,
  // ) async {
  //   final bytes = List<int>.from(params['bytes']);
  //   final int chunkSize = params['chunkSize'] ?? 1024;

  //   int offset = 0;

  //   while (offset < bytes.length) {
  //     final end = (offset + chunkSize > bytes.length)
  //         ? bytes.length
  //         : offset + chunkSize;
  //     final chunk = bytes.sublist(offset, end);

  //     try {
  //       var data = Uint8List.fromList(chunk);
  //       await _flutterUsbPrinter.write(data);
  //     } catch (e) {
  //       // print("Error sending chunk at offset $offset: $e");
  //       return null;
  //     }

  //     offset = end;

  //     // Optional: slight delay to prevent buffer overflows
  //     await Future.delayed(Duration(milliseconds: 50));
  //   }
  //   return true;
  // }

  static bool _isPrinting = false;

  static Future<bool?> printByte(
      {required List<int> bytes, int chunkSize = 512}) async {
    try {
      if (_isPrinting) {
        await Future.doWhile(() async {
          kPrint("USB Print Bytes $_isPrinting");
          await Future.delayed(Duration(seconds: 2));
          return _isPrinting;
        });
      }
      _isPrinting = true;

      // 🔹 Reset printer before printing
      // await _flutterUsbPrinter.write(Uint8List.fromList([27, 64]));

      final _status = await _printByte(bytes: bytes, chunkSize: chunkSize);

      _isPrinting = false;

      return _status;
    } catch (e) {
      _isPrinting = false;

      return null;
    }
  }

  static Future<bool?> _printByte(
      {required List<int> bytes, int chunkSize = 512}) async {
    final _status =
        await _printerManager.send(type: PrinterType.usb, bytes: bytes);

    if (_status) {
      await _printerManager.send(type: PrinterType.usb, bytes: [bytes.last]);
    }

    // bool _status = false;

    // for (int i = 0; i < bytes.length; i += chunkSize) {
    //   final end = (i + chunkSize < bytes.length) ? i + chunkSize : bytes.length;

    //   _status = await _printerManager.send(
    //     type: PrinterType.usb,
    //     bytes: bytes.sublist(i, end),
    //   );

    //   await Future.delayed(const Duration(milliseconds: 5)); // CRITICAL
    // }

    // if (_status) {
    //   await _printerManager.send(type: PrinterType.usb, bytes: [bytes.last]);
    // }

    // await Future.delayed(
    //     const Duration(milliseconds: 100)); // let printer finish

    return _status;
  }

  // static Future<bool?> printByte({required List<int> bytes}) async {
  //   try {
  //     var data = Uint8List.fromList(bytes);
  //     final _status = await flutterUsbPrinter.write(data);

  //     return _status;
  //   } catch (e) {
  //     IfException.showMessage(message: "Failed to print");
  //   }

  //   return null;
  // }

  static Future<bool?> close() async {
    __connectedDevice = null;
    // return await _flutterUsbPrinter.close();
    return _printerManager.disconnect(type: PrinterType.usb);
  }

  //// print section
  ///
  static Future<bool?> printInvoice({
    PrintInvoice? pI,
    bool openCashDrawer = false,
  }) async {
    if (connectedDevice != null && connectedDevice?.vendorId == pI?.ipAddress) {
      final bytes = await BlueReceipt.getTicket(
        pI: pI,
        openCashDrawer: openCashDrawer,
      );
      if (bytes == null) return null;

      final status = await printByte(bytes: bytes);

      if (openCashDrawer) {
        await Utils.openIminDrawer();
      }

      return status;

      // showToast("$result");
    } else {
      final status =
          await checkConnection(vendorId: pI?.ipAddress, productId: pI?.port);
      if (status) {
        return printInvoice(pI: pI, openCashDrawer: openCashDrawer);
      }
      return null;
    }
  }

  static Future<bool?> printText({
    String? data,
    String? vendorId,
    required String? productId,
  }) async {
    if (connectedDevice != null && connectedDevice?.vendorId == vendorId) {
      final bytes = await BlueReceipt.getText(
        data: data,
      );
      if (bytes == null) return null;

      final status = await printByte(bytes: bytes);
      return status;
    } else {
      final status =
          await checkConnection(vendorId: vendorId, productId: productId);
      if (status) {
        return printText(data: data, vendorId: vendorId, productId: productId);
      }
      return null;
    }
  }

  // static Future<bool> printUsbIsolate(Map<String, dynamic> params) async {
  //   final ip = params['ip'] as String;
  //   final port = params['port'] as int;
  //   // final int chunkSize = params['chunkSize'] ?? 1024;
  //   final staticByte = params['staticByte'] as Uint8List;
  //   final height = params['height'] as int;
  //   final width = params['width'] as int;
  //   final _status = await printImage(
  //     data:
  //         ImagePrintModel(height: height, width: width, staticByte: staticByte),
  //     vendorId: ip,
  //     productId: port.toString(),
  //   );

  //   return _status ?? false;
  // }

  static Future<bool?> printImage({
    ImagePrintModel? data,
    String? vendorId,
    required String? productId,
  }) async {
    if (connectedDevice != null && connectedDevice?.vendorId == vendorId) {
      final _startTime = DateTime.now();
      final bytes = await BlueReceipt.getByteDataServer(
        data: data,
      );

      StkPrintManager.pTime(vendorId, "Image Data")?.imageData =
          TaskTiming(startTime: _startTime, endTime: DateTime.now());

      if (bytes == null) return null;
      // await Future.delayed(Duration(milliseconds: 200));

      // final _status = await compute(usbprintIsolate, {
      //   'bytes': bytes,
      //   'chunkSize': 1024,
      // });

      final _startTime2 = DateTime.now();

      final _status = await printByte(
          bytes: bytes, chunkSize: (data?.isBarcode ?? false) ? 1024 : 512);

      StkPrintManager.pTime(vendorId, "Print")?.print ??= [];

      StkPrintManager.pTime(vendorId, "Printed")
          ?.print
          ?.add(TaskTiming(startTime: _startTime2, endTime: DateTime.now()));

      return _status;
    } else {
      final status =
          await checkConnection(vendorId: vendorId, productId: productId);
      if (status) {
        return printImage(data: data, vendorId: vendorId, productId: productId);
      }
      return null;
    }
  }

  // static Future<bool?> showDeviceList(
  //     {Future<bool?> Function()? function}) async {
  //   final _status = await UsbPrinterSet.showDeviceList(CUS_CTX!);
  //   if (_status != null && _status is bool && _status && function != null)
  //     return function();
  //   else
  //     return null;
  // }

  static Future<bool?> usbPrint(
      {PrintInvoice? pI, bool openCashDrawer = false}) async {
    if (connectedDevice != null && connectedDevice?.vendorId == pI?.ipAddress) {
      return await printInvoice(
        pI: pI,
        openCashDrawer: openCashDrawer,
      );
    } else {
      final status =
          await checkConnection(vendorId: pI?.ipAddress, productId: pI?.port);
      if (status) {
        return usbPrint(pI: pI, openCashDrawer: openCashDrawer);
      }
      return null;
    }
  }

  static Future<bool?> cashDrawerOpenFromPrinter() async {
    final bytes = await BlueReceipt.getCashDrawerText();
    final status = await printByte(bytes: bytes);
    return status;
  }

  static Future<bool> checkConnection({
    String? vendorId,
    required String? productId,
  }) async {
    if (vendorId != null && productId != null) {
      bool? _status = false;
      await getDevicelist(fun: () async {
        if ((deviceList?.isNotEmpty ?? false) &&
            (deviceList?.any((e) =>
                    e.vendorId == vendorId && e.productId == productId) ??
                false)) {
          final serverDevice = deviceList?.firstWhere(
              (e) => e.vendorId == vendorId && e.productId == productId);

          if (serverDevice != null) {
            _status = await connect(device: serverDevice, doPrint: false);
          }
        }
      });

      int _count = 0;

      await Future.doWhile(() async {
        _count++;

        await Future.delayed(const Duration(seconds: 1));

        return !_status! && _count < 5;
      });

      return _status ?? false;
    }
    // showToast(LN.usbNotFound);
    return false;
  }
}
