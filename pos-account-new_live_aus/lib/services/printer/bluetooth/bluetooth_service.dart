import 'dart:async';
import 'dart:io';
import 'package:pos_account/constant/constant.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/ui_model/print_invoice.dart';
import 'package:pos_account/repository/if_exception.dart';
import 'package:pos_account/services/printer/com/barcode_qr_print.dart';
import 'package:thermal_printer_plus/thermal_printer.dart';
import '../usb/usb_service.dart';
import 'blue_receipt.dart';

class BluetoothService {
  // static BluetoothDevice? connectedDevice;
  static PrinterDevice? connectedDevice;

  static PrinterManager get _printerManager => UsbService.printerManager;

  static Future<bool> getConnectionStatus(
      {String? name, String? macAddress}) async {
    final _permission = await _bluetoothPermission();
    if (!_permission) return false;

    final _status = _printerManager.currentStatusBT == BTStatus.connected;
    if (_status) {
      return true;
    } else if (macAddress?.isNotEmpty ?? false) {
      // await _printerManager.disconnect(type: PrinterType.bluetooth);
      final _status = await _printerManager.connect(
          type: PrinterType.bluetooth,
          model: BluetoothPrinterInput(
            name: name,
            address: macAddress!,
            isBle: false,
            autoConnect: false,
          ));
      return _status;
    } else {
      return false;
    }
  }

  static Future<bool> _bluetoothPermission() async {
    final service = await Permission.bluetooth.serviceStatus;

    if (service != ServiceStatus.enabled) {
      IfException.showMessage(message: LN.enableBluetoothSetting);
      // await openAppSettings();
      return false;
    }

    if (Platform.isAndroid) {
      if (!(await Permission.bluetoothScan.isGranted)) {
        final status = await Permission.bluetoothScan.request();

        if (status != PermissionStatus.granted) {
          IfException.showMessage(message: LN.blueScanDenied);
          return false;
        }
      }

      if (!(await Permission.bluetoothConnect.isGranted)) {
        final status = await Permission.bluetoothConnect.request();

        if (status != PermissionStatus.granted) {
          IfException.showMessage(message: " ${LN.blueConnectDenied}");
          return false;
        }
      }
    }

    return true;
  }

  static List<PrinterDevice>? deviceList;

  static Future<void> getBluetoothDevices({Function()? fun}) async {
    // final _permission = await _bluetoothPermission();

    // if (!_permission) return;

    try {
      deviceList = [];
      kPrint('Bluetooth scan start');
      _printerManager.discovery(type: PrinterType.bluetooth).listen((_val) {
        if (!deviceList!
            .any((a) => a.name.toLowerCase() == _val.name.toLowerCase())) {
          deviceList!.add(_val);
        }
        if (fun != null) fun();
        kPrint("Bluetooth DEVICE LIST : ${deviceList?.length}");
      });

      // _printerManager.stateBluetooth.listen((_) {
      //   kPrint('stateBluetooth: ${_}');
      // });

      // final _bluetooths = await PrintBluetoothThermal.pairedBluetooths;

      // if (_bluetooths.isNotEmpty) {
      //   final _devices = <BluetoothDevice>[];
      //   for (final _e in _bluetooths) {
      //     _devices
      //         .add(BluetoothDevice(name: _e.name, macAddress: _e.macAdress));
      //   }
      //   return _devices;
      // }
    } catch (e) {
      IfException.showMessage(message: "${LN.blueScanError} $e");
    }
    return;
  }

  static Future<void> setConnect(PrinterDevice device) async {
    try {
      // print("connextion sttu ${device.name}");
      // await _printerManager.disconnect(type: PrinterType.bluetooth);

      final _status = await _printerManager.connect(
          type: PrinterType.bluetooth,
          model: BluetoothPrinterInput(
            name: device.name,
            address: device.address ?? '',
            isBle: false,
            autoConnect: false,
          ));
      if (_status) {
        connectedDevice = device;
        final bytes = await BlueReceipt.getPrinterConnect();
        if (bytes == null) return;

        await writeBytes(bytes);
        IfException.showMessage(message: LN.printerIsConnected, isError: false);
      } else {
        IfException.showMessage(message: LN.failedToConnect);
      }
    } catch (e) {
      // print("Error connecting printer: $e");
    }
  }

  static Future<void> disconnect() async {
    connectedDevice = null;
    await _printerManager.disconnect(type: PrinterType.bluetooth);
  }

  static Future<bool?> printInvoice({
    PrintInvoice? pI,
    bool openCashDrawer = false,
  }) async {
    if (await getConnectionStatus(macAddress: pI?.ipAddress)) {
      final bytes = await BlueReceipt.getTicket(
        pI: pI,
        openCashDrawer: openCashDrawer,
      );
      if (bytes == null) return null;

      final result = await writeBytes(bytes);

      if (openCashDrawer) {
        await Utils.openIminDrawer();
      }

      return result;

      // showToast("$result");
    }
    return false;
  }

  static Future<bool?> printText({String? macAddress, String? data}) async {
    if (await getConnectionStatus(macAddress: macAddress)) {
      final bytes = await BlueReceipt.getText(
        data: data,
      );
      if (bytes == null) return null;

      final _status = await writeBytes(bytes);
      return _status;
    } else {
      return null;
      // return await showDeviceList(
      //   function: () async => await printText(data: data),
      // );
    }
  }

  static Future<bool?> printImage(
      {ImagePrintModel? data, String? macAddress}) async {
    if (await getConnectionStatus(macAddress: macAddress)) {
      final bytes = await BlueReceipt.getByteDataServer(
        data: data,
      );
      if (bytes == null) return null;

      final _status = await writeBytes(bytes);
      return _status;
    } else {
      return null;
      // return await showDeviceList(
      //   function: () async => await printImage(data: data),
      // );
    }
  }

  // static Future<bool?> showDeviceList(
  //     {Future<bool?> Function()? function}) async {
  //   final status = await BluetoothPrinterSetup().showDeviceList(CUS_CTX!);
  //   if (status != null && status is bool && status && function != null)
  //     return function();
  //   else
  //     return null;
  // }

  static Future<bool?> bluetoothPrint(
      {PrintInvoice? pI, bool openCashDrawer = false}) async {
    final blueStatus = await getConnectionStatus(macAddress: pI?.ipAddress);

    if (blueStatus
        // && connectedDevice != null
        ) {
      return await printInvoice(
        pI: pI,
        openCashDrawer: openCashDrawer,
      );
    } else {
      return null;
      // return await showDeviceList(
      //   function: () async =>
      //       await bluetoothPrint(pI: pI, openCashDrawer: openCashDrawer),
      // );
    }
  }

  static Future<bool?> cashDrawerOpenFromPrinter() async {
    final _bytes = await BlueReceipt.getCashDrawerText();
    final _status = await writeBytes(_bytes);
    return _status;
  }

  static bool _isPrinting = false;

  static Future<bool> writeBytes(List<int> bytes) async {
    try {
      if (_isPrinting) {
        await Future.doWhile(() async {
          kPrint("Bluetooth Print Bytes $_isPrinting");
          await Future.delayed(Duration(seconds: 2));
          return _isPrinting;
        });
      }
      _isPrinting = true;

      // final _status =
      //     await _printerManager.send(type: PrinterType.bluetooth, bytes: bytes);
      // if (_status) {
      //   await _printerManager
      //       .send(type: PrinterType.bluetooth, bytes: [bytes.last]);
      // }

      bool _status = true;
      const int chunkSize = 512;

      for (int i = 0; i < bytes.length; i += chunkSize) {
        final chunk = bytes.sublist(
          i,
          i + chunkSize > bytes.length ? bytes.length : i + chunkSize,
        );

        final result = await _printerManager.send(
          type: PrinterType.bluetooth,
          bytes: chunk,
        );

        if (!result) {
          _status = false;
          break;
        }

        // 👇 VERY IMPORTANT: let UI breathe
        await Future.delayed(const Duration(milliseconds: 5));
      }

      _isPrinting = false;

      return _status;
    } catch (e) {
      _isPrinting = false;
      return false;
    }
  }

  // static Future<bool> _printBytes(
  //     {required List<int> bytes, int chunkSize = 512}) async {
  //   // kPrint("_status: $_status");

  //   for (int i = 0; i < bytes.length; i += chunkSize) {
  //     final end = (i + chunkSize < bytes.length) ? i + chunkSize : bytes.length;

  //     final chunk = bytes.sublist(i, end);

  //     await _printerManager.send(
  //       type: PrinterType.bluetooth,
  //       bytes: chunk,
  //     );
  //   }

  //   return true;
  // }
}

class BluetoothDevice {
  final String name;
  final String macAddress;
  bool isConnecting;

  BluetoothDevice({
    required this.name,
    required this.macAddress,
    this.isConnecting = false,
  });
}
