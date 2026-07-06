import 'dart:io';
// import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class FilePathConfig {
  static Future<String?> get _tempDirPath async =>
      // (await DownloadsPathProvider.downloadsDirectory)?.path;
      (await path_provider.getExternalStorageDirectory())?.path;

  /// // image

  static String? _tempImagePath;

  static Future<String?> get getImagePath async {
    if (_tempImagePath != null) return _tempImagePath;

    final path = await _tempDirPath;
    if (path == null) return null;
    _tempImagePath = "$path/SecondScreen/slideshow";
    return _tempImagePath;
  }

  static Future<List<String>?> get getImageData async {
    final imageList = <String>[];

    final imagePath = await getImagePath;
    if (imagePath != null) {
      for (int i = 0; i < 5; i++) {
        final pathName = '$imagePath/Image_${i + 1}.jpg';
        final file = File(pathName);
        if (await file.exists()) {
          imageList.add(pathName);
        }
      }
    }
    return imageList;
  }

  ///// // video

  static String? _tempVideoPath;

  static Future<String?> get getVideoPath async {
    if (_tempVideoPath != null) return _tempVideoPath;

    final path = await _tempDirPath;
    if (path == null) return null;
    _tempVideoPath = "$path/SecondScreen/video";
    return _tempVideoPath;
  }

  static Future<String?> get getVideoData async {
    final videoPath = await getVideoPath;
    if (videoPath != null) {
      final pathName = '$videoPath/Video.mp4';
      final file = File(pathName);
      if (await file.exists()) {
        return pathName;
      }
    }
    return null;
  }
}
