import 'dart:async';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:ping_discover_network_forked/ping_discover_network_forked.dart';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/ui_model/print_invoice.dart';
import 'package:pos_account/repository/if_exception.dart';
import 'package:pos_account/widgets/dialog/msg_dialog.dart';
import "package:image/image.dart";

class PrinterService {
  // static Stream<NetworkAddress>? netWorkStream;
  // static bool isListening = false;
  static bool? isPrintSuccess;
  // printer setup

  static Future<bool?> checkDevice({
    String? ip,
    int port = 9100,
    Future Function({required NetworkPrinter printer})? run,
    String paperSize = 'mm80',

    /// [doPrint] true for invoice and stk | false for connection
    required bool doPrint,
    // StreamController<double>? streamCltr,
    bool showMsg = true,
  }) async {
    if (ip == null || ip.isEmpty) return null;

    isPrintSuccess = await _printerSet(
        ip: ip, paperSize: paperSize, doPrint: doPrint, run: run);

    return isPrintSuccess;

    // streamCltr?.close();

    // else {
    //   // print('-------------3');
    //   if (streamCltr != null && !streamCltr.isClosed)
    //     streamCltr.sink.add(0.002);
    //   if (!ip.contains('.')) return;

    //   if (!isListening)
    //     networkStream(ip, port)
    //       .onDone(() async {
    //         isListening = false;
    //         bool? _status;

    //         // print(
    //         //     "IP list of printer ${_printers.map((e) => e.ip)} ,------------- $ip");

    //         if (_printers.any((e) => e.ip == ip)) {
    //           // print('-------------5');
    //           _status = await _printerSet(
    //               ip: ip, paperSize: paperSize, doPrint: doPrint, run: run);
    //         }
    //         // else if (_printers.any((e) => e.available)) {
    //         //   // print('-------------4');
    //         //   _status = await _printerSet(
    //         //       ip: _printers.firstWhere((e) => e.available).ip,
    //         //       paperSize: paperSize,
    //         //       doPrint: doPrint,
    //         //       run: run);
    //         // }
    //         else {
    //           // print('-------------6');
    //           if (streamCltr != null && !streamCltr.isClosed)
    //             streamCltr.sink.add(-0.001);
    //           // print("--1------${LN.printerNotFound}");
    //           if (showMsg) IfException.showMessage(message: LN.printerNotFound);
    //         }
    //         if (context != null)
    //           try {
    //             Navigator.of(context).pop();
    //           } catch (e) {
    //             // print(e);
    //           }
    //         if (!doPrint && showMsg)
    //           _showPrinterConnected(
    //             status: _status,
    //             title: _status == null
    //                 ? LN.printerNotFound
    //                 : _status
    //                     ? LN.printerIsConnected
    //                     : LN.printerNotConnected,
    //           );
    //         isPrintSuccess = _status;
    //         streamCltr?.close();
    //       });
    // }
  }

  static Future<bool?> _printerSet({
    required String ip,
    Future Function({required NetworkPrinter printer})? run,
    String paperSize = 'mm80',
    bool doPrint = false,
    int port = 9100,
  }) async {
    // print("Set up printer $ip");
    final status = await _setUpPrinter(
      printerIp: ip,
      paperSize: paperSize.contains('58') ? PaperSize.mm58 : PaperSize.mm80,
      doPrint: doPrint,
      port: port,
    );
    if (status != null && run != null) {
      await run(
        printer: status,
      );
    }
    return status != null;
  }

  // static NetworkPrinter? connectedPrinter;

  static Future<NetworkPrinter?> _setUpPrinter({
    required String printerIp,
    PaperSize paperSize = PaperSize.mm80,
    bool doPrint = false,
    int port = 9100,
  }) async {
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paperSize, profile);
    final res = await printer.connect(printerIp, port: port);
    if (res == PosPrintResult.success) {
      // connectedPrinter = printer;
      printer.setGlobalFont(PosFontType.fontA);

      if (!doPrint) {
        try {
          printer.beep(n: 1, duration: PosBeepDuration.beep50ms);
          printer.text(LN.printerIsConnected,
              styles: PosStyles(
                align: PosAlign.center,
              ));
          printer.feed(1);
          printer.cut();
          printer.disconnect(
            delayMs: 1,
          );
        } on ArgumentError catch (e) {
          printer.cut();
          printer.disconnect(delayMs: 1);
          printError(e);
        } catch (e) {
          printer.cut();
          printer.disconnect(delayMs: 1);
        }
      }
      IfException.showMessage(
          message: doPrint ? LN.printing : LN.printerIsConnected,
          isError: false);

      return printer;
    } else if (res == PosPrintResult.printerNotSelected ||
        res == PosPrintResult.ticketEmpty ||
        res == PosPrintResult.timeout) {
      // print("--3-----${LN.printerNotConnected}");
      // IfException.showMessage(message: LN.printerNotConnected);
    }
    return null;

    // if (res == PosPrintResult.success) {
    // DEMO RECEIPT
    // await printDemoReceipt(printer);
    // TEST PRINT
    // await testReceipt(printer);
    // printer.disconnect();
    // }
  }

  // static StreamSubscription<NetworkAddress> networkStream(String ip, int port) {
  //   final String _subnet = ip.substring(0, ip.lastIndexOf('.'));
  //   netWorkStream = NetworkAnalyzer.discover2(_subnet, port);

  //   return netWorkStream!.listen((event) {
  //     // print("----------listening-------------$isListening");
  //     // print("${event.ip} ${event.exists}");
  //     if (event.exists) {
  //       // print("Found printer: ${event.ip}");
  //       if (!_printers.any((e) => e.ip == event.ip)) {
  //         _printers.add(_PrinterClass(ip: event.ip, available: true));
  //       }
  //     } else {
  //       if (_printers.any((e) => e.ip == event.ip && !e.available))
  //         _printers.removeWhere((e) => e.ip == event.ip && !e.available);
  //     }
  //   });
  // }

  static Future<void> printReceipt({
    required NetworkPrinter printer,
    PrintInvoice? pI,
    bool openCashDrawer = false,
  }) async {
    try {
      if (pI == null) return;
      // Print image
      // print('print starting');
      if (pI.image != null) {
        final ByteData data = await rootBundle.load(pI.image!);
        final Uint8List bytes = data.buffer.asUint8List();
        final image = decodeImage(bytes);
        printer.image(image!);
      }
      if (pI.title != null) {
        for (final t
            in Utils.splitBySpace(pI.title!, lineLength: 24, lineSpace: ''))
          printer.text(t,
              styles: PosStyles(
                align: PosAlign.center,
                height: PosTextSize.size2,
                width: PosTextSize.size2,
              ));
      }
      if (pI.subtitle != null) {
        for (final h
            in Utils.splitBySpace(pI.subtitle!, lineLength: 47, lineSpace: ''))
          printer.text(
            h,
            styles: PosStyles(
              align: PosAlign.center,
              height: PosTextSize.size1,
              width: PosTextSize.size1,
            ),
          );
      }
      if (pI.subtitleList != null) {
        for (final e in pI.subtitleList!) {
          printer.text(e.text,
              styles: PosStyles(
                align: PosAlign.center,
                bold: e.style == PrinterTextStyle.Bold,
                width: e.size == 2 ? PosTextSize.size2 : PosTextSize.size1,
                fontType: e.size == 2 ? PosFontType.fontB : PosFontType.fontA,
              ));
        }
      }

      printer.text("", linesAfter: 1);

      if (pI.body?.header != null) {
        for (final e in pI.body!.header!) {
          if (e.body1 != null && e.body1!.isNotEmpty) {
            printer.row([
              PosColumn(text: e.title ?? '', width: 6),
              PosColumn(
                  text: e.body1 ?? '',
                  width: 6,
                  styles: PosStyles(
                    align: PosAlign.right,
                  )),
            ]);
          } else {
            for (final g in Utils.splitBySpace(e.title ?? '',
                lineLength: e.size == 1 ? 48 : 23, lineSpace: '')) {
              printer.text(g,
                  styles: PosStyles(
                    align: PosAlign.left,
                    bold: e.bold,
                    width: e.size == 1
                        ? PosTextSize.size1
                        : e.size == 2
                            ? PosTextSize.size2
                            : PosTextSize.size3,
                    // height: e.size == 3 ? PosTextSize.size2 : PosTextSize.size1,
                    fontType:
                        e.size == 1 ? PosFontType.fontA : PosFontType.fontB,
                  ));
            }
          }
        }
      }
      printer.hr();

      if (pI.body?.item != null) {
        for (final a in pI.body!.item!) {
          final isBody2 =
              a.itemHeader?.body2 != null && a.itemHeader!.body2!.isNotEmpty;
          printer.row([
            PosColumn(
                text: a.itemHeader?.title ?? '',
                width: isBody2 ? 7 : 9,
                styles: PosStyles(bold: true)),
            if (isBody2)
              PosColumn(
                text: a.itemHeader?.body2 ?? '',
                width: 2,
                styles: PosStyles(align: PosAlign.right, bold: true),
              ),
            PosColumn(
              text: a.itemHeader?.body3 ?? '',
              width: 3,
              styles: PosStyles(align: PosAlign.right, bold: true),
            ),
          ]);

          if (a.groupItem != null) {
            for (final c in a.groupItem!) {
              if (c.itemHeader?.title?.isNotEmpty ?? false)
                printer.row([
                  PosColumn(
                      text: c.itemHeader?.title ?? '',
                      width: isBody2 ? 7 : 9,
                      styles: PosStyles(
                        bold: true,
                        height: PosTextSize.size2,
                        width: PosTextSize.size2,
                        fontType: PosFontType.fontB,
                      )),
                  if (isBody2)
                    PosColumn(
                      text: c.itemHeader?.body2 ?? '',
                      width: 2,
                      styles: PosStyles(align: PosAlign.right, bold: true),
                    ),
                  PosColumn(
                    text: c.itemHeader?.body3 ?? '',
                    width: 3,
                    styles: PosStyles(align: PosAlign.right, bold: true),
                  ),
                ]);

              final posCols = _getBodyData(item: c, isDocket: pI.isDocket);
              for (final d in posCols) printer.row(d);

              // printer.hr(ch: '=', linesAfter: 1);
              printer.row([
                PosColumn(
                  text:
                      '======================================================================================',
                  width: 12,
                  styles: PosStyles(bold: true, width: PosTextSize.size2),
                )
              ]);
            }
          }

          if (a.itemBody != null) {
            final posCols = _getBodyData(item: a, isDocket: pI.isDocket);
            for (final b in posCols) printer.row(b);
            if (posCols.isNotEmpty) printer.hr();
          }
        }
      }
      if (pI.body?.itemFooter != null)
        printer.text(
            "${pI.body?.itemFooter?.title != null ? pI.body!.itemFooter!.title! : ''}: ${pI.body?.itemFooter?.body2 != null ? pI.body!.itemFooter!.body2! : ''}",
            styles: PosStyles(
              align: PosAlign.left,
              fontType: PosFontType.fontB,
              height: PosTextSize.size2,
              width: PosTextSize.size2,
            ));
      // printer.row([
      //   PosColumn(
      //       text: pI.body?.itemFooter?.title ?? '',
      //       width: pI.body?.itemFooter?.body2 != null ? 6 : 12,
      //       styles: PosStyles(
      //         height: PosTextSize.size1,
      //         width: PosTextSize.size1,
      //       )),
      //   if (pI.body?.itemFooter?.body2 != null)
      //     PosColumn(
      //         text: pI.body?.itemFooter?.body2 ?? '',
      //         width: 6,
      //         styles: PosStyles(
      //           align: PosAlign.right,
      //           height: PosTextSize.size1,
      //           width: PosTextSize.size1,
      //         )),
      // ]);
      printer.feed(1);
      if (pI.body?.itemFooter != null) printer.hr(ch: '=', linesAfter: 1);

      if (pI.body?.footer != null)
        for (final e in pI.body!.footer!) {
          if (e.isDivider)
            printer.hr(ch: '-', linesAfter: 1);
          else
            printer.row([
              PosColumn(
                  text: e.title ?? '',
                  width: 8,
                  styles: PosStyles(
                    align: e.alignRight ? PosAlign.right : PosAlign.left,
                    bold: e.bold,
                  )),
              PosColumn(
                  text: e.body1 ?? '',
                  width: 4,
                  styles: PosStyles(
                    align: PosAlign.right,
                    bold: e.bold,
                  )),
            ]);
        }

      printer.text("");

      if (pI.footerList != null)
        for (final e in pI.footerList!) {
          if (e != null && e.isNotEmpty) {
            if (e.length < 46) {
              printer.text(e,
                  styles: PosStyles(
                    align: PosAlign.center,
                    bold: true,
                  ));
            } else {
              final _textList =
                  Utils.splitBySpace(e, lineLength: 47, lineSpace: '');

              for (final f in _textList) {
                printer.text(f,
                    styles: PosStyles(
                      align: PosAlign.center,
                      bold: true,
                    ));
              }
            }
          }
        }

      // print('printing');

      printer.feed(2);
      printer.cut();
      if (openCashDrawer) {
        printer.drawer();
        // imin device cashDrawer open
        await Utils.openIminDrawer();
      }
      printer.disconnect(delayMs: 1);
    } on ArgumentError catch (e) {
      printer.cut();
      printer.disconnect(delayMs: 1);
      printError(e);
    } catch (e) {
      printer.cut();
      printer.disconnect(delayMs: 1);
    }
  }

  static Future<void> cashDrawerOpenFromPrinter({
    required String printerIp,
    PaperSize paperSize = PaperSize.mm80,
    int port = 9100,
  }) async {
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paperSize, profile);
    final res = await printer.connect(
      printerIp,
      port: port,
      timeout: const Duration(seconds: 5),
    );
    if (res == PosPrintResult.success) {
      try {
        // printer.setGlobalFont(PosFontType.fontA);

        // printer.text(LN.openingCashDrawer,
        //     styles: PosStyles(
        //       align: PosAlign.center,
        //     ));
        // printer.feed(1);
        // printer.cut();

        printer.drawer();
        await Future.delayed(const Duration(milliseconds: 200));
        printer.disconnect(delayMs: 1);
      } on ArgumentError catch (e) {
        // printer.cut();
        await Future.delayed(const Duration(milliseconds: 200));
        printer.disconnect(delayMs: 1);
        printError(e);
      } catch (e) {
        // printer.cut();
        await Future.delayed(const Duration(milliseconds: 200));
        printer.disconnect(delayMs: 1);
      } finally {
        try {
          printer.disconnect(); // ✅ always safe
        } catch (_) {}
      }
    } else if (res == PosPrintResult.printerNotSelected ||
        res == PosPrintResult.ticketEmpty ||
        res == PosPrintResult.timeout) {
      // print("--4-----${LN.printerNotConnected}");
      IfException.showMessage(message: LN.printerNotConnected);
    }
  }

  static List<List<PosColumn>> _getBodyData({
    required Item item,
    required bool isDocket,
  }) {
    final posColList = <List<PosColumn>>[];

    int i = 0;

    for (final b in item.itemBody!) {
      final isItemBody2 =
          item.itemHeader?.body2 != null && item.itemHeader!.body2!.isNotEmpty;

      if (b.isFirstLine == true) {
        i++;
      }

      b.title = (b.isFirstLine == true ? (isDocket ? '* ' : '$i.') : '') +
          (b.title ?? '');

      ////////////// method 1 ////////////////

      final splitText = (b.title?.trim().isNotEmpty ?? false)
          ? Utils.splitBySpace(b.title!,
              lineLength: isItemBody2 ? (isDocket ? 12 : 27) : 23,
              lineSpace: isItemBody2 ? (isDocket ? ' ' : '   ') : '  ')
          : [' '];

      for (int g = 0; g < splitText.length; g++) {
        posColList.add(_getPosColData(
          isItemBody2: isItemBody2,
          isDocket: isDocket,
          firstText: splitText[g],
          isFirstLine: g == 0,
          isBold: b.bold,
          isReverseText: b.isReverseText,
          middleText: b.body2,
          lastText: b.body3,
          size: b.size,
        ));
      }

      ////////////// method 2 ////////////////

//       final int _lineLength = _isItemBody2 ? 27 : 23;
//       final String _lineSpace = _isItemBody2 ? '    ' : '  ';
//       //
//       int startIndex = 0;
//       // print(b.title!);
//       String _title = b.title ?? '';

//       final _oldcount = (b.title!.length / _lineLength).ceil();
//       final int _textLength = b.title!.length +
//           (_oldcount - 1) * _lineSpace.length; // add space in front
//       final _newcount = (_textLength / _lineLength).ceil();

//       for (int i = 1; i <= _newcount; i++) {
//         if (startIndex != 0) {
//           _title = _title.substring(0, startIndex - 1) +
//               _lineSpace +
//               _title.substring(startIndex, _title.length);
// //       print('--------------');
//         }

//         if (_title.length - startIndex < _lineLength) {
//           // print(_title.substring(startIndex) + '-1');
//           _posColList.add(_getPosColData(
//             isItemBody2: _isItemBody2,
//             firstText: _title.substring(startIndex),
//             isFirstLine: startIndex == 0,
//             isBold: b.bold,
//             isReverseText: b.isReverseText,
//             middleText: b.body2,
//             lastText: b.body3,
//           ));
//         } else {
//           int _endIndex = _lineLength * (i) > _title.length
//               ? _title.length
//               : _lineLength * (i);

//           int spaceIndex = _title.lastIndexOf(' ', _endIndex);

//           if (spaceIndex != -1 && spaceIndex != startIndex) {
//             if (spaceIndex != _lineLength) {
//               // print(_title.substring(startIndex, spaceIndex));
//               _posColList.add(_getPosColData(
//                 isItemBody2: _isItemBody2,
//                 firstText: _title.substring(startIndex, spaceIndex),
//                 isFirstLine: startIndex == 0,
//                 isBold: b.bold,
//                 isReverseText: b.isReverseText,
//                 middleText: b.body2,
//                 lastText: b.body3,
//               ));
//               startIndex = spaceIndex + 1;
//             } else {
//               // print(_title.substring(startIndex, startIndex + _lineLength));
//               _posColList.add(_getPosColData(
//                 isItemBody2: _isItemBody2,
//                 firstText:
//                     _title.substring(startIndex, startIndex + _lineLength),
//                 isFirstLine: startIndex == 0,
//                 isBold: b.bold,
//                 isReverseText: b.isReverseText,
//                 middleText: b.body2,
//                 lastText: b.body3,
//               ));
//               startIndex += _lineLength;
//             }
//           } else {
//             // print(_title.substring(startIndex, _endIndex));
//             _posColList.add(_getPosColData(
//               isItemBody2: _isItemBody2,
//               firstText: _title.substring(startIndex, _endIndex),
//               isFirstLine: startIndex == 0,
//               isBold: b.bold,
//               isReverseText: b.isReverseText,
//               middleText: b.body2,
//               lastText: b.body3,
//             ));
//             startIndex += _lineLength;
//           }
//         }
//       }

      ////////////// method 3 ////////////////

      // _posColList.add([
      //   PosColumn(
      //     text: b.title ?? '',
      //     width: _isItemBody2 ? 7 : 9,
      //     styles: _isItemBody2
      //         ? PosStyles(bold: b.bold)
      //         : PosStyles(
      //             fontType: PosFontType.fontB,
      //             height: b.size == 2 ? PosTextSize.size2 : PosTextSize.size1,
      //             width: PosTextSize.size2,
      //             reverse: b.isReverseText ?? false,
      //             bold: b.bold,
      //           ),
      //   ),
      //   if (_isItemBody2)
      //     PosColumn(
      //         text: b.body2 ?? '',
      //         width: 2,
      //         styles: PosStyles(align: PosAlign.right)),
      //   PosColumn(
      //       text: b.body3 ?? '',
      //       width: 3,
      //       styles: _isItemBody2
      //           ? PosStyles(align: PosAlign.right)
      //           : PosStyles(
      //               align: PosAlign.right,
      //               fontType: PosFontType.fontB,
      //               height: b.size == 2 ? PosTextSize.size2 : PosTextSize.size1,
      //               width: PosTextSize.size2,
      //             )),
      // ]);

      // final int _textLength = _isItemBody2 ? 27 : 23;
      // for (int i = 1; i <= (b.title!.length / _textLength).round(); i++) {
      //   if (b.title != null && b.title!.length > _textLength) {
      //     _posColList.add([
      //       PosColumn(
      //         text: //(_isItemBody2 ? '' : '   ') +
      //             b.title!.substring(b.title!.length > _textLength * i
      //                 ? i * _textLength
      //                 : b.title!.length),
      //         width: _isItemBody2 ? 7 : 9,
      //         styles: _isItemBody2
      //             ? PosStyles(bold: b.bold)
      //             : PosStyles(
      //                 fontType: PosFontType.fontB,
      //                 height:
      //                     b.size == 2 ? PosTextSize.size2 : PosTextSize.size1,
      //                 width: PosTextSize.size2,
      //                 bold: b.bold,
      //               ),
      //       ),
      //       PosColumn(
      //         text: '',
      //         width: _isItemBody2 ? 5 : 3,
      //         styles: _isItemBody2
      //             ? PosStyles(align: PosAlign.right)
      //             : PosStyles(
      //                 align: PosAlign.right,
      //                 fontType: PosFontType.fontB,
      //                 height:
      //                     b.size == 2 ? PosTextSize.size2 : PosTextSize.size1,
      //                 width: PosTextSize.size2,
      //               ),
      //       ),
      //     ]);
      //   }
      // }
    }
    return posColList;
  }

  static List<PosColumn> _getPosColData({
    bool isItemBody2 = false,
    required bool isDocket,
    required String firstText,
    //
    bool isFirstLine = false,
    bool isBold = false,
    bool? isReverseText,
    String? middleText,
    String? lastText,
    int size = 1,
  }) {
    // print(
    //     "title: $firstText | size: $size | hasQty: $isItemBody2 | qty: $middleText | firstLine: $isFirstLine | bold: $isBold | lastText: $lastText");
    return [
      PosColumn(
        text: // (isFirstLine
            // ? ''
            // :
            //  (isItemBody2 ? '   ' :
            // '   ') +
            firstText,
        width: isItemBody2 ? 7 : 9,
        styles: isDocket
            ? PosStyles(
                fontType: isItemBody2 ? PosFontType.fontA : PosFontType.fontB,
                height: (isItemBody2 || size == 1)
                    ? PosTextSize.size1
                    : PosTextSize.size2,
                width: PosTextSize.size2,
                reverse: isFirstLine && (isReverseText ?? false),
                bold: isBold,
              )
            : PosStyles(bold: isBold),
      ),
      if (isItemBody2)
        PosColumn(
            text: isFirstLine ? (middleText ?? ' ') : ' ',
            width: 2,
            styles: isDocket
                ? PosStyles(
                    align: PosAlign.right,
                    fontType: PosFontType.fontA,
                    height: size == 1 ? PosTextSize.size1 : PosTextSize.size2,
                    width: middleText != null && middleText.length > 3
                        ? PosTextSize.size1
                        : PosTextSize.size2,
                    bold: isBold,
                  )
                : PosStyles(align: PosAlign.right)),
      PosColumn(
        text: isFirstLine ? (lastText ?? ' ') : ' ',
        width: 3,
        styles: isDocket
            ? PosStyles(
                align: PosAlign.right,
                fontType: isItemBody2 ? PosFontType.fontA : PosFontType.fontB,
                height: (isItemBody2 || size == 1)
                    ? PosTextSize.size1
                    : PosTextSize.size2,
                width: lastText != null && lastText.length > 5
                    ? PosTextSize.size1
                    : PosTextSize.size2,
              )
            : PosStyles(align: PosAlign.right),
      ),
    ];
  }

  static Future<void> printError(ArgumentError e) async {
    await Future.delayed(Duration(milliseconds: 200));
    MsgDia.show(
      CUS_CTX,
      title: "Print Error",
      diaType: DiaType.warning,
      desc:
          "`${e.invalidValue}` ${e.message} \n Please remove invalid character, and try to re-print again",
      onOkay: () {},
      btnText: "Okay",
      btnOkColor: Colors.amber.shade700,
    );
  }
}

// class _PrinterClass {
//   final String ip;
//   final bool available;

//   _PrinterClass({required this.ip, this.available = false});
// }

// final _printers = <_PrinterClass>[];
