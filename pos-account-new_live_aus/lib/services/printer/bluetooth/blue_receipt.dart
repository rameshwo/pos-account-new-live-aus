import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as image1;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/model/ui_model/print_invoice.dart';
import 'package:image/image.dart';
import 'package:pos_account/repository/handler.dart';
import 'package:pos_account/repository/if_exception.dart';
import 'package:pos_account/services/printer/com/barcode_qr_print.dart';
import 'package:pos_account/widgets/dialog/msg_dialog.dart';

/// ======== ISOLATE PARAMS =========
class _ImageProcessParams {
  final Uint8List bytes;
  final int width;
  final int height;
  final CapabilityProfile profile;
  final PaperSize paperSize;

  _ImageProcessParams({
    required this.bytes,
    required this.width,
    required this.height,
    required this.profile,
    required this.paperSize,
  });
}

/// ======== TOP-LEVEL ISOLATE FUNCTION =========
/// Runs inside background isolate
Future<List<int>?> _processImageIsolate(_ImageProcessParams params) async {
  final image1.Image? decoded = image1.decodeImage(params.bytes);
  if (decoded == null) return null;

  // Resize
  final resized = image1.copyResize(
    decoded,
    width: params.width,
    height: params.height,
    interpolation: image1.Interpolation.nearest,
  );

  final generator = Generator(params.paperSize, params.profile);

  final List<int> bytes = [];

  // This is the heavy CPU task that was freezing your app
  bytes.addAll(generator.image(resized));

  bytes.addAll(generator.feed(2));
  bytes.addAll(generator.cut());

  return bytes;
}

class BlueReceipt {
  static Future<List<int>?> getPrinterConnect({
    PaperSize paperSize = PaperSize.mm80,
  }) async {
    List<int> bytes = [];

    final profile = await CapabilityProfile.load();
    final printer = Generator(paperSize, profile);

    bytes += printer.setGlobalFont(PosFontType.fontA);

    bytes += printer.beep(n: 1, duration: PosBeepDuration.beep50ms);
    bytes += printer.feed(3);

    bytes += printer.text(LN.printerIsConnected,
        styles: PosStyles(
          align: PosAlign.center,
        ));
    bytes += printer.feed(2);
    bytes += printer.cut();

    return bytes;
  }

  static Future<List<int>?> getTicket({
    PrintInvoice? pI,
    PaperSize paperSize = PaperSize.mm80,
    bool openCashDrawer = false,
  }) async {
    try {
      if (pI == null) return null;

      List<int> _bytes = [];
      final profile = await CapabilityProfile.load();
      final _generator = Generator(paperSize, profile);

      if (pI.image != null) {
        final ByteData data = await rootBundle.load(pI.image!);
        final Uint8List bytes = data.buffer.asUint8List();
        final image = decodeImage(bytes);
        _bytes += _generator.image(image!);
      }

      if (pI.title != null) {
        for (final t
            in Utils.splitBySpace(pI.title!, lineLength: 24, lineSpace: ''))
          _bytes += _generator.text(t,
              styles: PosStyles(
                align: PosAlign.center,
                height: PosTextSize.size2,
                width: PosTextSize.size2,
              ));
      }
      if (pI.subtitle != null) {
        for (final h
            in Utils.splitBySpace(pI.subtitle!, lineLength: 47, lineSpace: ''))
          _bytes += _generator.text(
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
          _bytes += _generator.text(e.text,
              styles: PosStyles(
                align: PosAlign.center,
                bold: e.style == PrinterTextStyle.Bold,
                width: e.size == 2 ? PosTextSize.size2 : PosTextSize.size1,
                fontType: e.size == 2 ? PosFontType.fontB : PosFontType.fontA,
              ));
        }
      }

      _bytes += _generator.text("", linesAfter: 1);

      if (pI.body?.header != null) {
        for (final e in pI.body!.header!) {
          if (e.body1 != null && e.body1!.isNotEmpty) {
            _bytes += _generator.row([
              PosColumn(text: e.title ?? '', width: 6),
              PosColumn(
                  text: e.body1 ?? '',
                  width: 6,
                  styles: PosStyles(align: PosAlign.right)),
            ]);
          } else {
            for (final g in Utils.splitBySpace(e.title ?? '',
                lineLength: e.size == 1 ? 48 : 23, lineSpace: '')) {
              _bytes += _generator.text(g,
                  styles: PosStyles(
                    align: PosAlign.left,
                    bold: e.bold,
                    width: e.size == 1 ? PosTextSize.size1 : PosTextSize.size2,
                    fontType:
                        e.size == 1 ? PosFontType.fontA : PosFontType.fontB,
                  ));
            }
          }
        }
      }
      _bytes += _generator.hr();

      if (pI.body?.item != null) {
        for (final a in pI.body!.item!) {
          final isBody2 =
              a.itemHeader?.body2 != null && a.itemHeader!.body2!.isNotEmpty;
          _bytes += _generator.row([
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
                _bytes += _generator.row([
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
              for (final d in posCols) _bytes += _generator.row(d);

              // printer.hr(ch: '=', linesAfter: 1);
              _bytes += _generator.row([
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
            final _posCols = _getBodyData(item: a, isDocket: pI.isDocket);
            for (final b in _posCols) _bytes += _generator.row(b);
            if (_posCols.isNotEmpty) _bytes += _generator.hr();
          }

          // if (a.itemBody != null) {
          //   for (final b in a.itemBody!) {
          //     final _isItemBody2 =
          //         a.itemHeader?.body2 != null && a.itemHeader!.body2!.isNotEmpty;
          //     _bytes += _generator.row([
          //       PosColumn(
          //         text: b.title ?? '',
          //         width: _isItemBody2 ? 7 : 9,
          //         styles: _isItemBody2
          //             ? PosStyles()
          //             : PosStyles(
          //                 fontType: PosFontType.fontB,
          //                 height: PosTextSize.size1,
          //                 width: PosTextSize.size2,
          //               ),
          //       ),
          //       if (_isItemBody2)
          //         PosColumn(
          //             text: b.body2 ?? '',
          //             width: 2,
          //             styles: PosStyles(align: PosAlign.right)),
          //       PosColumn(
          //           text: b.body3 ?? '',
          //           width: 3,
          //           styles: _isItemBody2
          //               ? PosStyles(align: PosAlign.right)
          //               : PosStyles(
          //                   align: PosAlign.right,
          //                   fontType: PosFontType.fontA,
          //                   height: PosTextSize.size1,
          //                   width: PosTextSize.size2,
          //                 )),
          //     ]);
          //     final int _textLength = _isItemBody2 ? 27 : 23;
          //     for (int i = 1;
          //         i <= (b.title!.length / (_isItemBody2 ? 27 : 23)).round();
          //         i++) {
          //       if (b.title != null && b.title!.length > _textLength) {
          //         _bytes += _generator.row([
          //           PosColumn(
          //             text: b.title!.substring(b.title!.length > _textLength * i
          //                 ? i * _textLength
          //                 : b.title!.length),
          //             width: _isItemBody2 ? 7 : 9,
          //             styles: _isItemBody2
          //                 ? PosStyles()
          //                 : PosStyles(
          //                     fontType: PosFontType.fontB,
          //                     height: PosTextSize.size1,
          //                     width: PosTextSize.size2,
          //                   ),
          //           ),
          //           PosColumn(
          //             text: '',
          //             width: _isItemBody2 ? 5 : 3,
          //             styles: _isItemBody2
          //                 ? PosStyles(align: PosAlign.right)
          //                 : PosStyles(
          //                     align: PosAlign.right,
          //                     fontType: PosFontType.fontB,
          //                     height: PosTextSize.size1,
          //                     width: PosTextSize.size2,
          //                   ),
          //           ),
          //         ]);
          //       }
          //     }
          //   }
          // }
          // _bytes += _generator.hr();
        }
      }
      if (pI.body?.itemFooter != null)
        _bytes += _generator.text(
            "${pI.body?.itemFooter?.title != null ? pI.body!.itemFooter!.title! : ''}: ${pI.body?.itemFooter?.body2 != null ? pI.body!.itemFooter!.body2! : ''}",
            styles: PosStyles(
              align: PosAlign.left,
              fontType: PosFontType.fontB,
              height: PosTextSize.size2,
              width: PosTextSize.size2,
            ));
      _bytes += _generator.feed(1);
      if (pI.body?.itemFooter != null)
        _bytes += _generator.hr(ch: '=', linesAfter: 1);

      if (pI.body?.footer != null)
        for (final e in pI.body!.footer!) {
          if (e.isDivider)
            _bytes += _generator.hr(ch: '-', linesAfter: 1);
          else
            _bytes += _generator.row([
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

      _bytes += _generator.text("");

      if (pI.footerList != null)
        for (final e in pI.footerList!) {
          if (e != null && e.isNotEmpty) {
            if (e.length < 46) {
              _bytes += _generator.text(e,
                  styles: PosStyles(
                    align: PosAlign.center,
                    bold: true,
                  ));
            } else {
              final _textList =
                  Utils.splitBySpace(e, lineLength: 47, lineSpace: '');

              for (final f in _textList) {
                _bytes += _generator.text(f,
                    styles: PosStyles(
                      align: PosAlign.center,
                      bold: true,
                    ));
              }
            }
          }
        }

      // print('printing');

      if (openCashDrawer) {
        _bytes += _generator.drawer(pin: PosDrawer.pin2);
        _bytes += _generator.drawer(pin: PosDrawer.pin5);
      }

      _bytes += _generator.feed(2);
      _bytes += _generator.cut();

      return _bytes;
    } on ArgumentError catch (e) {
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
    } catch (e) {
      IfException.showMessage(message: "Error: $e");
    }

    return null;
  }

  static Future<List<int>> getCashDrawerText({
    PaperSize paperSize = PaperSize.mm80,
  }) async {
    final profile = await CapabilityProfile.load();
    final gen = Generator(paperSize, profile);

    List<int> bytes = [];

    // _bytes += _gen.setGlobalFont(PosFontType.fontA);

    // _bytes += _gen.text(LN.openingCashDrawer,
    //     styles: PosStyles(
    //       align: PosAlign.center,
    //     ));

    bytes += gen.drawer();

    bytes += gen.feed(1);
    // _bytes += _gen.cut();

    return bytes;
  }

  static Future<List<int>?> getText({
    PaperSize paperSize = PaperSize.mm80,
    String? data,
  }) async {
    List<int> bytes = [];

    final profile = await CapabilityProfile.load();
    final printer = Generator(paperSize, profile);

    if (data == null) return null;
    bytes += printer.text(data, styles: PosStyles(align: PosAlign.center));
    bytes += printer.feed(1);
    bytes += printer.cut();

    return bytes;
  }

  // static CapabilityProfile? _profile;

  // static Future<List<int>?> getImageData({
  //   PaperSize paperSize = PaperSize.mm80,
  //   ImagePrintModel? data,
  // }) async {
  //   try {
  //     _profile ??= await CapabilityProfile.load();

  //     if (_profile == null || data == null) return null;

  //     // 2. Load raw image bytes
  //     Uint8List? rawBytes;

  //     if (data.staticByte != null) {
  //       rawBytes = data.staticByte;
  //     } else if (data.filePath.toLowerCase().startsWith("http")) {
  //       rawBytes = await ImagePrint.getBytesFromUrl(data.filePath);
  //     } else if (data.filePath.isNotEmpty) {
  //       rawBytes = await File(data.filePath).readAsBytes();
  //     }

  //     if (rawBytes == null) return null;

  //     // 3. PROCESS IMAGE IN ISOLATE
  //     final printerBytes = await compute(
  //       _processImageIsolate,
  //       _ImageProcessParams(
  //         bytes: rawBytes,
  //         width: data.width,
  //         height: data.height,
  //         paperSize: paperSize,
  //         profile: _profile!,
  //       ),
  //     );

  //     if (printerBytes == null) return null;

  //     return printerBytes;
  //   } catch (e, st) {
  //     kPrint("Print Error: $e\n$st");
  //     return null;
  //   }
  // }

  static Future<List<int>?> _getFileImage({
    PaperSize paperSize = PaperSize.mm80,
    ImagePrintModel? data,
  }) async {
    try {
      final _profile = await CapabilityProfile.load();

      if (data?.filePath == null || data!.filePath.isEmpty) return null;

      // 2. Load raw image bytes
      Uint8List? rawBytes = await File(data.filePath).readAsBytes();

      // 3. PROCESS IMAGE IN ISOLATE
      final printerBytes = await compute(
        _processImageIsolate,
        _ImageProcessParams(
          bytes: rawBytes,
          width: data.width,
          height: data.height,
          paperSize: paperSize,
          profile: _profile,
        ),
      );

      if (printerBytes == null) return null;

      return printerBytes;
    } catch (e) {
      // kPrint("Print Error: $e\n$st");
      return null;
    }
  }

  // static Future<List<int>?> getImageDataServer({
  //   PaperSize paperSize = PaperSize.mm80,
  //   ImagePrintModel? data,
  // }) async {
  //   final dir = await path_provider.getTemporaryDirectory();
  //   final targetPath = "${dir.path}/docket_temp.png";
  //   await File(targetPath).writeAsBytes(data!.staticByte!, flush: true);

  //   kPrint(targetPath);

  //   final bytes = <int>[];

  //   final _bytes = await Handler.getDocketImage(filePath: targetPath);

  //   if (_bytes == null) return null;

  //   bytes.addAll(_bytes);

  //   final _profile = await CapabilityProfile.load();

  //   final generator = Generator(paperSize, _profile);

  //   bytes.addAll(generator.cut());

  //   return bytes;
  // }

  static Future<List<int>?> getByteDataServer({
    PaperSize paperSize = PaperSize.mm80,
    ImagePrintModel? data,
  }) async {
    if (data?.staticByte != null) {
      final _bytes = await Handler.getDocketByte(data: data?.staticByte);

      if (_bytes == null) return null;

      final bytes = <int>[];

      bytes.addAll([27, 64]); // reset

      bytes.addAll(_bytes);

      final _profile = await CapabilityProfile.load();

      final generator = Generator(paperSize, _profile);
      bytes.addAll(generator.feed(2));
      bytes.addAll(generator.cut());

      return bytes;
    } else if (data?.filePath.isNotEmpty ?? false) {
      return await _getFileImage(data: data, paperSize: paperSize);
    } else {
      return null;
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

      b.title = (b.isFirstLine == true ? '$i.' : '') + (b.title ?? '');

      final splitText = (b.title?.trim().isNotEmpty ?? false)
          ? Utils.splitBySpace(b.title!,
              lineLength: isItemBody2 ? (isDocket ? 12 : 27) : 23,
              lineSpace: isItemBody2 ? (isDocket ? '  ' : '   ') : '  ')
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

      // _posColList.add([
      //   PosColumn(
      //     text: b.title ?? '',
      //     width: _isItemBody2 ? 7 : 9,
      //     styles: _isItemBody2
      //         ? PosStyles()
      //         : PosStyles(
      //             fontType: PosFontType.fontB,
      //             height: PosTextSize.size1,
      //             width: PosTextSize.size2,
      //             reverse: b.isReverseText ?? false,
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
      //               fontType: PosFontType.fontA,
      //               height: PosTextSize.size1,
      //               width: PosTextSize.size2,
      //             )),
      // ]);
      // final int _textLength = _isItemBody2 ? 27 : 23;
      // for (int i = 1; i <= (b.title!.length / _textLength).round(); i++) {
      //   if (b.title != null && b.title!.length > _textLength) {
      //     _posColList.add([
      //       PosColumn(
      //         text: (_isItemBody2 ? '' : '   ') +
      //             b.title!.substring(b.title!.length > _textLength * i
      //                 ? i * _textLength
      //                 : b.title!.length),
      //         width: _isItemBody2 ? 7 : 9,
      //         styles: _isItemBody2
      //             ? PosStyles()
      //             : PosStyles(
      //                 fontType: PosFontType.fontB,
      //                 height: PosTextSize.size1,
      //                 width: PosTextSize.size2,
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
      //                 height: PosTextSize.size1,
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
                    reverse: isFirstLine && (isReverseText ?? false),
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
}
