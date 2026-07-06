import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pos_account/config/dual_display/file_path_config.dart';
import 'package:pos_account/config/dual_display/dual_display_config.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/services/database/shared_pref.dart';
import 'package:pos_account/services/image/image_service.dart';

class CustomerDisplayPro extends ChangeNotifier {
  void get notify => notifyListeners();

  bool loading = true;

  //pattern
  DualDisPattern pattern = DualDisPattern.none;
  // local stored pattern
  DualDisPattern? _lsp;

  Future<void> getData() async {
    final lp = await SharedPrefs.dualDisPattern;
    if (lp != null && DualDisPattern.values.any((e) => e.name == lp)) {
      pattern = _lsp = DualDisPattern.values.firstWhere((e) => e.name == lp);
    }

    // files
    await getPatternData();
    loading = false;
    notify;
  }

  Future<void> setPrevData() async {
    if (_lsp == pattern) {
      await getPatternData();
      notify;
    }
  }

  // image picker
  List<String>? imagePathList;

  void getPhotoPick() async {
    final pathList = await ImageService.getMedia(FileType.image, count: 5);
    if (pathList != null) {
      imagePathList ??= [];

      imagePathList?.addAll(pathList);

      if (imagePathList!.length > 5) {
        imagePathList = imagePathList!.take(5).toList();
      }

      notify;
    }
  }

  // video picker
  String? videoPath;

  void getVideoPick() async {
    final path = await ImageService.getMedia(FileType.video, count: 1);
    if (path?.isNotEmpty ?? false) {
      videoPath = path?.first;
      notify;
    }
  }

  //clear data
  void clear() {
    imagePathList = null;
    videoPath = null;
  }

  /// save Data
  ///

  Future<void> saveData() async {
    final permission =
        await ImageService.getPermission(Permission.mediaLibrary);
    if (!permission) return;

    try {
      loading = true;
      notify;
      // image

      final imagePath = await FilePathConfig.getImagePath;
      if (imagePath != null) {
        final imagedir = Directory(imagePath);

        if (!await imagedir.exists()) {
          await imagedir.create(recursive: true);
        }

        for (int i = 0; i < 5; i++) {
          final fileName = '$imagePath/Image_${i + 1}.jpg';

          if ((imagePathList?.isNotEmpty ?? false) &&
              (pattern == DualDisPattern.style1 ||
                  pattern == DualDisPattern.style3)) {
            // print("${imagePathList!.length - 1} < $i");
            if (imagePathList!.length - 1 < i) {
              if (await File(fileName).exists()) {
                await File(fileName).delete(recursive: true);
              }
            } else if (imagePathList![i].isNotEmpty) {
              final byte = await File(imagePathList![i]).readAsBytes();
              // final _file =
              await File(fileName).writeAsBytes(byte);
              // print(
              //     'Image uploaded from ${imagePathList![i]} to temporary directory: ${_file.path}');
            }
          } else {
            final existFile = await File(fileName).exists();
            if (existFile) {
              await File(fileName).delete(recursive: true);
            }
          }
        }
      }

      // video

      final videoPath = await FilePathConfig.getVideoPath;

      if (videoPath != null) {
        final videodir = Directory(videoPath);

        if (!await videodir.exists()) {
          await videodir.create(recursive: true);
        }

        final fileName = '$videoPath/Video.mp4';

        if ((videoPath.isNotEmpty) &&
            (pattern == DualDisPattern.style2 ||
                pattern == DualDisPattern.style3)) {
          final byte = await File(videoPath).readAsBytes();
          await File(fileName).writeAsBytes(byte);
        } else {
          if (await File(fileName).exists()) {
            await File(fileName).delete(recursive: true);
          }
        }
      }

      // pattern save
      SharedPrefs.setDualDisPattern = pattern.name;

      await getData();

      // dual display send data
      if (DualDisplayConfig.displays.isEmpty) {
        await DualDisplayConfig.init();
      } else {
        await DualDisplayConfig.getSetPattern();
        DualDisplayConfig.sendData();
      }

      ///

      showToast(LN.updatedSuccessfully);
      notify;
    } catch (e) {
      showToast('Failed to apply setting');
      // print("Error saving image to temporary directory: $e");
      loading = false;
      notify;
      return;
    }
  }

  Future<void> getPatternData() async {
    // image
    imagePathList = await FilePathConfig.getImageData;

    // video
    videoPath = await FilePathConfig.getVideoData;
  }
}

class DualDisplayModel {
  final String title;
  final String? subTitle;
  final DualDisPattern pattern;

  DualDisplayModel({required this.title, this.subTitle, required this.pattern});
}
