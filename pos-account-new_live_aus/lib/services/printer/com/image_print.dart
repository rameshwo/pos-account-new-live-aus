import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as image1;
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/home/product/barcode/barcode_print_res.dart';
import 'package:pos_account/services/image/image_service.dart';
import 'package:pos_account/widgets/dialog/confirm_dialog.dart';
import '../../../constant/constant.dart';
import '../printer_service.dart';

class ImagePrint {
  /// [BAR_CODE_PRINT]
  static void printBarcode(
    BuildContext context, {
    BarcodePrintRes? data,
    StreamController<double>? streamCltr,
  }) {
    if (data == null) return;

    showDialog(
        context: context,
        builder: (builder) => ConfirmDialog(
              title: LN.printBarcode,
              subTitle: LN.printBarcode,
              actionText: LN.print,
              onDelete: () async {
                _printBarcode(data: data, streamCltr: streamCltr);
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

  static Future<void> _printBarcode({
    required BarcodePrintRes data,
    StreamController<double>? streamCltr,
  }) async {
    if (data.image == null || data.image!.isEmpty) return;
    if (streamCltr != null && !streamCltr.isClosed) streamCltr.sink.add(0.001);
    for (int i = 0; i < data.image!.length; i++) {
      await PrinterService.checkDevice(
        ip: data.ipAddress,
        port: int.tryParse(data.port ?? '9100') ?? 9100,
        paperSize: 'mm80',
        doPrint: true,
        // streamCltr: streamCltr,
        run: ({required NetworkPrinter printer}) async {
          // print("run functio working");

          await printImage(
            printer: printer,
            imagePath: data.image![i],
          );
          if (streamCltr != null && !streamCltr.isClosed)
            streamCltr.sink.add(i + 1);
        },
      );
    }
  }

  static Future<void> printImage({
    required NetworkPrinter printer,
    String? imagePath,
    int height = 300,
    int width = 300,
  }) async {
    if (imagePath == null) return;

    Uint8List? bytes;

    if (imagePath.contains('http:')) {
      bytes = await getBytesFromUrl(imagePath);
    } else {
      final _newPath = await ImageService.compressFile(imagePath,
          height: height, width: width);
      // print("6 -- ${DateTime.now()}");
      if (_newPath == null) return;

      bytes = File(_newPath).readAsBytesSync();
    }

    if (bytes == null) return;

    final image = image1.decodeImage(bytes);

    if (image == null) return;

    printer.image(image);
    await Future.delayed(Duration(seconds: 1)); // give the printer time
    printer.feed(1);
    printer.cut();
    printer.disconnect(delayMs: 1);
  }

  static Future<Uint8List?> getBytesFromUrl(String url) async {
    final client = Client();
    final response = await client.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      return bytes.buffer.asUint8List();
    } else {
      showToast(LN.invalidBarcodeImg);
    }
    return null;
  }

  static bool _isPrinting = false;

  static Future<bool> sendToEthernetPrinter({
    required String ip,
    int port = 9100,
    required List<int> bytes,
    Duration delayBetweenChunks = const Duration(milliseconds: 5),
  }) async {
    try {
      if (_isPrinting) {
        await Future.doWhile(() async {
          kPrint("Ethernet Print Bytes $_isPrinting");
          await Future.delayed(Duration(seconds: 2));
          return _isPrinting;
        });
      }
      // kPrint("Ethernet Print Start Printing");
      _isPrinting = true;

      final _status = await _sendToEthernetPrinter(
        ip: ip,
        port: port,
        bytes: bytes,
        delayBetweenChunks: delayBetweenChunks,
      );

      _isPrinting = false;

      return _status;
    } catch (e) {
      _isPrinting = false;

      return false;
    }
  }

  /// Send raw bytes to a thermal printer over Ethernet
  static Future<bool> _sendToEthernetPrinter({
    required String ip,
    int port = 9100,
    required List<int> bytes,
    // int chunkSize = 512, // Optimal for speed, most printers can handle this
    Duration delayBetweenChunks = const Duration(milliseconds: 5),
  }) async {
    Socket? socket;

    try {
      socket =
          await Socket.connect(ip, port, timeout: const Duration(seconds: 3));

      socket.setOption(SocketOption.tcpNoDelay, true);

      socket.add(bytes);
      await socket.flush();

      // int offset = 0;

      // while (offset < bytes.length) {
      //   final end = (offset + chunkSize > bytes.length)
      //       ? bytes.length
      //       : offset + chunkSize;
      //   final chunk = bytes.sublist(offset, end);
      //   try {
      //     socket.add(chunk);
      //     await socket.flush();
      //   } on SocketException catch (_) {
      //     // debugPrint("Write failed during chunk: $e");
      //     return false;
      //   } catch (e) {
      //     return false;
      //   }

      //   // Optional delay - prevents buffer overflow on slower printers
      //   if (delayBetweenChunks.inMilliseconds > 0) {
      //     await Future.delayed(delayBetweenChunks);
      //   }

      //   offset = end;
      // }
      await Future.delayed(const Duration(milliseconds: 10));

      await socket.close();
      await socket.done;
      return true;
    } on SocketException catch (_) {
      // debugPrint("Printer connection error: $e");
      return false;
    } catch (e) {
      // print('❌ Printer socket error: $e');
      return false;
    } finally {
      socket?.destroy();
    }
  }

  static Future<bool> ethernetPrinterStatus({
    required String ip,
    int port = 9100,
    Function(String, bool)? onStatusChanged,
  }) async {
    try {
      // log('Printer testing');
      final socket =
          await Socket.connect(ip, port, timeout: Duration(milliseconds: 50));
      // log('Printer listening');
      // Send commands with delay to ensure each response comes separately
      List<List<int>> commands = [
        [0x10, 0x04, 0x01], // Drawer kick-out
        [0x10, 0x04, 0x02], // Offline status
        [0x10, 0x04, 0x04], // Paper status
      ];

      for (var cmd in commands) {
        socket.add(cmd);
        await socket.flush();
        await Future.delayed(Duration(milliseconds: 50));
      }

      socket.listen((List<int> data) {
        final printedStatuses = <String>{};

        for (int i = 0; i < data.length; i++) {
          final statusByte = data[i];
          // log('Received Status Byte [$i]: 0x${statusByte.toRadixString(16).padLeft(2, '0').toUpperCase()}');

          void logOnce(String msg, bool status) {
            if (!printedStatuses.contains(msg)) {
              printedStatuses.add(msg);
              // log(msg);
              if (onStatusChanged != null) onStatusChanged(msg, status);
            }
          }

          if (i == 0) {
            // Printer Status (0x01)
            // if ((statusByte & 0x04) != 0) logOnce('ONLINE', true);
            if ((statusByte & 0x08) != 0) logOnce('Paper is OUT', false);
            // if ((statusByte & 0x20) != 0) logOnce('Printer is OFFLINE', false);
          }

          if (i == 1) {
            // Offline Status (0x02)
            // if ((statusByte & 0x01) != 0) logOnce('Cover is OPEN', true);
            // if ((statusByte & 0x02) != 0) logOnce('Feed button is PRESSED');
            // if ((statusByte & 0x04) != 0) logOnce('OFFLINE', false);
            if ((statusByte & 0x08) != 0) logOnce('Printer is BUSY', false);
            // if ((statusByte & 0x20) != 0) logOnce('General ERROR', false);
            // if ((statusByte & 0x40) != 0) logOnce('ERROR occurred', false);
          }

          if (i == 2) {
            // Paper Status (0x04)
            if ((statusByte & 0x60) == 0x60) {
              logOnce('Paper is EMPTY', false);
            } else if ((statusByte & 0x60) == 0x00) {
              // logOnce('Paper is PRESENT', true);
            }
          }
        }

        socket.destroy();
        // log('✅ All printer statuses received and processed.');
      });

      // log('Printer testing complete');

      return true;
    } catch (e) {
      // log('Printer error : $e');
      return false;
    }
  }
}

// Must be top-level function to be used in compute()
Future<bool> ethernetPrintIsolate(Map<String, dynamic> params) async {
  final bytes = List<int>.from(params['bytes']);
  final ip = params['ip'] as String;
  final port = params['port'] as int;
  final int chunkSize = params['chunkSize'] ?? 1024;

  try {
    final socket =
        await Socket.connect(ip, port, timeout: const Duration(seconds: 2));
    int offset = 0;

    while (offset < bytes.length) {
      final end = (offset + chunkSize > bytes.length)
          ? bytes.length
          : offset + chunkSize;
      final chunk = bytes.sublist(offset, end);
      socket.add(chunk);
      await Future.delayed(
          const Duration(milliseconds: 1)); // avoid buffer overflow
      offset = end;
    }

    await socket.flush();
    await socket.close();
    return true;
  } catch (e) {
    // log("PrintError: $e");
    return false;
  }
}
