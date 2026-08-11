import 'package:pos_account/providers/cus_val_pro.dart';
import 'package:pos_account/repository/if_exception.dart';
import '../../model/home/menu/place_order/place_order_res.dart';
import '../../screens/home_screen/com/items/sidebar/pay_receipt/com/stk.dart';
import 'bluetooth/blue_receipt.dart';
import 'bluetooth/bluetooth_service.dart';
import 'com/barcode_qr_print.dart';
import 'com/image_print.dart';
import 'com/send_to_kitchen_print.dart';
import 'printer_enum.dart';
import 'usb/usb_service.dart';

class StkPrintManager {
  final List<LanPrintModel> printerList;
  final PlaceOrderRes order;
  final Future<void> Function()? runSuccessFun;
  bool init;
  Function() load;

  StkPrintManager({
    required this.printerList,
    required this.order,
    required this.runSuccessFun,
    required this.load,
    this.init = true,
  });

  int _printLength = 0;
  int _printCount = 0;

  bool checkPrintingStatus() {
    // kPrint(
    //     "stk print: $_printLength == $_printCount ${_printLength == _printCount}");
    return _printLength == _printCount;
  }

  Future<void> setData() async {
    if (!init) return;

    for (final e in printerList) {
      if (e.type == PrinterTypeEnum.Ethernet.name) {
        e.isOnline = await ImagePrint.ethernetPrinterStatus(
            ip: e.ip ?? '',
            port: int.tryParse(e.port ?? '') ?? 9100,
            onStatusChanged: (msg, val) {});

        // print("--------INIT----------- : ${e.ip} ${e.printerStatus}");
        load();
      }
    }
    await _printStk();
  }

  Future<void> _printStk() async {
    _printLength = 0;
    for (final e in order.printingDetailsResponseViewModels!) {
      if ((e.orderItemsDetailsResponseViewModels?.isNotEmpty ?? false) ||
          (e.setMenuOrderOrderDetailsResponseViewModels?.isNotEmpty ?? false) ||
          (e.orderItemsDetailsResponseDocketGroupViewModels?.isNotEmpty ??
              false) ||
          (e.description?.isNotEmpty ?? false)) {
        final _printList = _splitPrintList(e: e);

        final _j = (e.orderPrintCopy ?? false) ? 2 : 1;

        final _printData = _printer(e.ipAddress);
        _printData?.printerStatus = PrinterStatus.Printing;
        load();

        for (int i = 0; i < _j; i++) {
          _printLength++;

          for (final b in _printList) {
            final _pi = SendToKitchenPrint.cISentToKitchen(
              b,
              url: order.url,
              stkRt: i == 0
                  ? SendToKitReceiptType.Normal
                  : SendToKitReceiptType.Waiter,
            );

            final _startTime = DateTime.now();

            final _img = await Stk.capture(pI: _pi);

            final _currentPrinter = _printer(b.ipAddress);
            _currentPrinter?.image = _img;

            pTime(e.ipAddress, "Captured")?.capture =
                TaskTiming(startTime: _startTime, endTime: DateTime.now());

          await print(
              data: _img,
              ip: b.ipAddress,
              port: b.port,
              printerType: b.printerType,
            );
          }
        }
      } else {
        final _currentPrinter = _printer(e.ipAddress);
        _currentPrinter?.printerStatus = PrinterStatus.NoData;
        _sendPrintStatus(
          curPrinter: _currentPrinter,
        );
      }
    }

    final _allPrinted = printerList.every((a) =>
        a.printerStatus == PrinterStatus.Success ||
        a.printerStatus == PrinterStatus.Failed ||
        a.printerStatus == PrinterStatus.NoData);
    final _allPrintSucess =
        printerList.every((a) => a.printerStatus == PrinterStatus.Success ||
            a.printerStatus == PrinterStatus.NoData);

    if (_allPrinted && _allPrintSucess && runSuccessFun != null) {
      await runSuccessFun!();
    }
  }

  LanPrintModel? _printer(String? _ip) {
    if (printerList.any((f) => f.ip == _ip)) {
      final _printModel = printerList.firstWhere((f) => f.ip == _ip);
      return _printModel;
    }
    return null;
  }

  Future<void> print({
    ImagePrintModel? data,
    String? ip,
    String? port,
    String? printerType,
  }) async {
    if (printerType == PrinterTypeEnum.Bluetooth.name) {
      await _bluePrint(data: data, ip: ip, port: port);
    } else if (printerType == PrinterTypeEnum.USB.name) {
      await _usbPrint(data: data, ip: ip, port: port);
    } else {
      await _etherNetPrint(data: data, ip: ip, port: port);
    }
  }

  // int _bluePrintRetryCount = 0;

  Future<void> _bluePrint({
    ImagePrintModel? data,
    String? ip,
    String? port,
  }) async {
    final _currentPrinter = _printer(ip);

    _currentPrinter?.printerStatus = PrinterStatus.Printing;
    IfException.showMessage(message: "Connecting to print", isError: false);
    load();

    bool? _status;
    // _bluePrintRetryCount = 0;

    // do {
    _status = await BluetoothService.printImage(data: data, macAddress: ip);

    // _bluePrintRetryCount++;

    //   if (!(_status ?? false)) {
    //     _currentPrinter?.printerStatus = PrinterStatus.Retrying;
    //     load();

    //     // await Future.delayed(Duration(seconds: 1));
    //   } else {
    //     break;
    //   }
    // } while (_bluePrintRetryCount < 3 && _status != true);

    if (_status == true) {
      _currentPrinter?.isOnline = true;
      _currentPrinter?.printerStatus = PrinterStatus.Success;
    } else {
      _currentPrinter?.isOnline = false;
      _currentPrinter?.printerStatus = PrinterStatus.Failed;
    }

    _printCount++;

    load();
    _sendPrintStatus(
      curPrinter: _currentPrinter,
    );
  }

  // int _usbPrintRetryCount = 0;

  Future<void> _usbPrint({
    ImagePrintModel? data,
    String? ip,
    String? port,
  }) async {
    final _currentPrinter = _printer(ip);

    _currentPrinter?.printerStatus = PrinterStatus.Printing;
    IfException.showMessage(message: "Connecting to print", isError: false);
    load();
    bool? _status;
    // _usbPrintRetryCount = 0;

    // do {
    // _status = await compute(UsbService.printUsbIsolate, {
    //   'staticByte': data?.staticByte,
    //   'height': data?.height,
    //   'width': data?.width,
    //   'ip': ip ?? '',
    //   'port': int.tryParse(port ?? '') ?? 9100,
    //   'chunkSize': 2048, // optional, can be changed
    // });

    _status =
        await UsbService.printImage(data: data, vendorId: ip, productId: port);

    //   _usbPrintRetryCount++;

    //   if (!(_status ?? false)) {
    //     _currentPrinter?.printerStatus = PrinterStatus.Retrying;
    //     load();

    //     // await Future.delayed(Duration(seconds: 1));
    //   } else {
    //     break;
    //   }
    // } while (_usbPrintRetryCount < 3 && _status != true);

    if (_status == true) {
      _currentPrinter?.isOnline = true;
      _currentPrinter?.printerStatus = PrinterStatus.Success;
    } else {
      _currentPrinter?.isOnline = false;
      _currentPrinter?.printerStatus = PrinterStatus.Failed;
    }
    _printCount++;

    load();
    _sendPrintStatus(
      curPrinter: _currentPrinter,
    );
  }

  // int _lanPrintRetryCount = 0;

  Future<void> _etherNetPrint({
    ImagePrintModel? data,
    String? ip,
    String? port,
  }) async {
    if (data == null) return;

    final _currentPrinter = _printer(ip);

    _currentPrinter?.printerStatus = PrinterStatus.Printing;
    IfException.showMessage(message: "Connecting to print", isError: false);
    load();

    // final _startTime = DateTime.now();

    final bytes = await BlueReceipt.getByteDataServer(
      data: data,
    );

    // pTime(ip, "Image Data")?.imageData =
    //     TaskTiming(startTime: _startTime, endTime: DateTime.now());

    bool _status = true;
    // _lanPrintRetryCount = 0;

    if (bytes != null) {
      // log(json.encode(bytes));
      // do {
      // final _startTime2 = DateTime.now();
      // pTime(ip, "Print")?.print ??= [];

      // _status = await compute(ImagePrint.ethernetPrintIsolate, {
      //   'staticByte': data?.staticByte,
      //   'height': data?.height,
      //   'width': data?.width,
      //   'ip': ip ?? '',
      //   'port': int.tryParse(port ?? '') ?? 9100,
      //   'chunkSize': 2048, // optional, can be changed
      // });

      // _status = await compute(ethernetPrintIsolate, {
      //   'ip': ip ?? '',
      //   'port': int.tryParse(port ?? '') ?? 9100,
      //   'bytes': bytes,
      //   'chunkSize': 2048, // optional, can be changed
      // });
      // await Future.delayed(Duration(seconds: 2), () {
      //   _status = true;
      // });

      _status = await ImagePrint.sendToEthernetPrinter(
        bytes: bytes,
        port: int.tryParse(port ?? '') ?? 9100,
        ip: ip ?? '',
        // chunkSize: 512,
      );

      // pTime(ip, "Printed")
      //     ?.print
      //     ?.add(TaskTiming(startTime: _startTime2, endTime: DateTime.now()));
      // load();

      // _lanPrintRetryCount++;

      // if (!_status) {
      //   _currentPrinter?.printerStatus = PrinterStatus.Retrying;
      //   load();
      //   // await Future.delayed(Duration(seconds: 1));
      // }
      //  else {
      //   break;
      // }
      // } while (_lanPrintRetryCount < 3 && !_status);

      if (_status) {
        _currentPrinter?.isOnline = true;
        _currentPrinter?.printerStatus = PrinterStatus.Success;
      } else {
        // _currentPrinter?.isOnline = false;
        _currentPrinter?.printerStatus = PrinterStatus.Failed;
      }

      load();
    } else {
      _currentPrinter?.printerStatus = PrinterStatus.Failed;
      load();
    }
    _printCount++;

    _sendPrintStatus(
      curPrinter: _currentPrinter,
    );
  }

  // String retryingCount(String? printerType) {
  //   if (printerType == PrinterTypeEnum.Bluetooth.name) {
  //     return '$_bluePrintRetryCount';
  //   } else if (printerType == PrinterTypeEnum.USB.name) {
  //     return '$_usbPrintRetryCount';
  //   } else {
  //     return '$_lanPrintRetryCount';
  //   }
  // }

  static List<PrintingDetailsResponseViewModel> _splitPrintList({
    required PrintingDetailsResponseViewModel e,
  }) {
    final _isSplitDocket =
        GlobalCVP.storeInfo?.enableDocketGroupSplitPrint ?? false;

    if (_isSplitDocket) {
      List<PrintingDetailsResponseViewModel> _splitByDocketGroup() {
        final _listData = <PrintingDetailsResponseViewModel>[];

        if (e.orderItemsDetailsResponseDocketGroupViewModels != null)
          for (var item in e.orderItemsDetailsResponseDocketGroupViewModels!) {
            _listData.add(PrintingDetailsResponseViewModel.fromJson(e.toJson())
              ..orderItemsDetailsResponseViewModels = []
              ..orderItemsDetailsResponseDocketGroupViewModels = [
                OrderItemsDetailsResponseDocketGroupViewModel.fromJson(
                    item.toJson())
              ]);
          }

        if (e.orderItemsDetailsResponseViewModels?.isNotEmpty ?? false)
          _listData.add(
            PrintingDetailsResponseViewModel.fromJson(e.toJson())
              ..orderItemsDetailsResponseDocketGroupViewModels = [],
          );

        return _listData;
      }

      // List<PrintingDetailsResponseViewModel> _splitByDocketGroup() {
      //   final Map<String, List<OrderItemsDetailsResponseViewModel>> grouped =
      //       {};
      //   if (e.orderItemsDetailsResponseViewModels != null)
      //     for (var item in e.orderItemsDetailsResponseViewModels!) {
      //       final key =
      //           (item.docketGroupName == null || item.docketGroupName!.isEmpty)
      //               ? "Others"
      //               : item.docketGroupName!;

      //       grouped.putIfAbsent(key, () => []);
      //       grouped[key]!.add(item);
      //     }

      //   return grouped.entries.map((entry) {
      //     return PrintingDetailsResponseViewModel.fromJson(e.toJson())
      //       ..orderItemsDetailsResponseViewModels = entry.value;
      //   }).toList();
      // }

      return _splitByDocketGroup();
    } else {
      return [e];
    }
  }

  void _sendPrintStatus({
    LanPrintModel? curPrinter,
  }) {
    if (curPrinter == null) return;

    // final req = PrintStatusReq(
    //   name: curPrinter.title ?? '',
    //   ipAddress: curPrinter.ip,
    //   port: curPrinter.port,
    //   status:
    //       "${curPrinter.printerStatus.name}-${curPrinter.isOnline ? 'Online' : 'Offline'}",
    //   requestData: json.encode(curPrinter.e.toJson()),
    //   orderNumber: curPrinter.e.orderNumber,
    // );
    // Handler.sendPrintStatus(req: req);

    // closeDia(); //TODO
  }

  static PrinterTiming? pTime(String? _ip, String message) {
    // messageList.add("$message ${DateTime.now()}");

    // if (PrintTiming.any((f) => f.printerName == _ip)) {
    //   final _printTime = PrintTiming.firstWhere((f) => f.printerName == _ip);
    //   return _printTime;
    // }
    return null;
  }
}

class LanPrintModel {
  final String? title;
  String? subTitle;
  final String? ip;
  final String? port;
  final String? type;
  PrinterStatus printerStatus;
  ImagePrintModel? image;
  bool hasItem;
  String? message;
  bool isOnline;
  final PrintingDetailsResponseViewModel e;

  LanPrintModel({
    this.title,
    this.subTitle,
    this.ip,
    this.port,
    this.type,
    this.printerStatus = PrinterStatus.None,
    this.image,
    this.hasItem = true,
    this.message,
    this.isOnline = false,
    required this.e,
  });
}

enum PrinterStatus {
  // Online,
  // Offline,
  Printing,
  Success,
  Failed,
  Retrying,
  NoData,
  None,
  // Busy,
  // PaperOut,
  // PaperEmpty,
}

class PrinterTiming {
  final String? printerType;
  final String? printerName;
  TaskTiming? statusCheck;
  TaskTiming? capture;
  TaskTiming? imageData;
  List<TaskTiming>? print;

  PrinterTiming({
    this.printerType,
    this.printerName,
    this.statusCheck,
    this.capture,
    this.imageData,
    this.print,
  });
}

class TaskTiming {
  final DateTime startTime;
  final DateTime endTime;

  TaskTiming({
    required this.startTime,
    required this.endTime,
  });
}
