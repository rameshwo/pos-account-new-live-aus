import 'dart:typed_data';
import 'dart:ui' as ui;

class PrintUtils {
  static Future<Uint8List?> getDocketRasterByteData(
      Uint8List imageBytes) async {
    try {
      final ui.Image image = await _decodeImage(imageBytes);

      final resized = await _resizeImage(image, targetWidth: 576);

      return _convertRawToEscPos(resized);
    } catch (e) {
      return null;
    }
  }

  static Future<ui.Image> _decodeImage(Uint8List bytes) async {
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    return frame.image;
  }

  static Future<ui.Image> _resizeImage(ui.Image image,
      {required int targetWidth}) async {
    final ratio = targetWidth / image.width;
    final targetHeight = (image.height * ratio).toInt();

    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);

    final paint = ui.Paint();

    canvas.drawImageRect(
      image,
      ui.Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      ui.Rect.fromLTWH(0, 0, targetWidth.toDouble(), targetHeight.toDouble()),
      paint,
    );

    final picture = recorder.endRecording();
    return await picture.toImage(targetWidth, targetHeight);
  }

  static Future<Uint8List> _convertRawToEscPos(ui.Image image) async {
    final byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);

    final pixels = byteData!.buffer.asUint8List();

    final width = image.width;
    final height = image.height;
    final bytesPerLine = (width + 7) ~/ 8;

    List<int> bytes = [];

    const maxChunkHeight = 256;

    for (int offsetY = 0; offsetY < height; offsetY += maxChunkHeight) {
      int chunkHeight = (offsetY + maxChunkHeight > height)
          ? height - offsetY
          : maxChunkHeight;

      List<int> data = List.filled(chunkHeight * bytesPerLine, 0);

      for (int y = 0; y < chunkHeight; y++) {
        for (int x = 0; x < width; x++) {
          int index = ((offsetY + y) * width + x) * 4;

          int r = pixels[index];
          int g = pixels[index + 1];
          int b = pixels[index + 2];

          bool isBlack = ((r + g + b) ~/ 3) < 128;

          if (isBlack) {
            int byteIndex = y * bytesPerLine + (x ~/ 8);
            data[byteIndex] |= (0x80 >> (x % 8));
          }
        }
      }

      // ESC/POS header
      bytes.addAll([
        0x1D,
        0x76,
        0x30,
        0x00,
        bytesPerLine & 0xFF,
        (bytesPerLine >> 8) & 0xFF,
        chunkHeight & 0xFF,
        (chunkHeight >> 8) & 0xFF,
      ]);

      bytes.addAll(data);
    }

    return Uint8List.fromList(bytes);
  }
}
