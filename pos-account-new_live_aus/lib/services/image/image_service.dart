import 'dart:convert';
import 'dart:io';
import 'package:android_path_provider/android_path_provider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
// import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pos_account/config/utils/utils.dart';
import 'package:pos_account/constant/date_format_keys.dart';
import 'package:pos_account/constant/strings.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pos_account/constant/constant.dart';
import 'dart:ui' as ui;
import 'package:pos_account/ln.dart';
import 'package:pos_account/repository/if_exception.dart';
import 'image_crop.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageService {
  static Future<Uint8List?> capture({GlobalKey? key}) async {
    if (key == null) return null;
    final boundary =
        key.currentContext?.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 1.5);
    final byteData = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    final pngByte = byteData?.buffer.asUint8List();
    return pngByte;
  }

  // static Future<String?> downloadFile(
  //     {required Uint8List data,
  //     required String fileName,
  //     bool isForShare = false}) async {
  //   // PermissionStatus permissionStatus =
  //   //     await Permission.storage.status;
  //   // print("PermissionStatus === storage=========== $permissionStatus");

  //   // if (!permissionStatus.isGranted) {
  //   //   permissionStatus = await Permission.storage.request();
  //   // }

  //   // if (permissionStatus.isGranted) {
  //   if (!isForShare) showToast("Downloading .. ");
  //   final res = await ImageGallerySaver.saveImage(
  //     Uint8List.fromList(data),
  //     quality: 95,
  //     name: fileName,
  //     isReturnImagePathOfIOS: true,
  //   );

  //   final imageStatus = ImageSaveModel.fromJson(jsonDecode(jsonEncode(res)));

  //   if (Platform.isAndroid) {
  //     imageStatus.filePath = (await toFile(imageStatus.filePath)).path;
  //     imageStatus.filePath = '/storage/emulated/0/Pictures/' +
  //         imageStatus.filePath.split('/').last;
  //   }
  //   if (!isForShare) showToast("Download completed");
  //   return imageStatus.filePath;
  //   // }

  //   // return null;
  // }

  static Future<String?> saveFile(
    Uint8List bytes,
    String fileName, {
    ImageSaveType saveType = ImageSaveType.download,
  }) async {
    String? path;

    final permission = await getPermission(Permission.mediaLibrary);
    if (!permission) return null;

    if (saveType == ImageSaveType.share) {
      path = (await path_provider.getExternalStorageDirectory())?.path;
    } else if (saveType == ImageSaveType.download) {
      var downloadsPath = await AndroidPathProvider.downloadsPath;
      path = downloadsPath;
    } else {
      path = (await path_provider.getTemporaryDirectory()).path;
    }

    if (path == null) return null;

    if (saveType == ImageSaveType.download) path += "/${Strings.APP_NAME}";

    final dir = Directory(path);

    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    // Create a File instance with the desired path
    File file = File('$path/$fileName');

    // print("File Path ${file.path}");

    try {
      if (saveType == ImageSaveType.download)
        showToast("${LN.downloading} .. ");

      await file.writeAsBytes(Uint8List.fromList(bytes), flush: true);

      if (saveType == ImageSaveType.download) showToast(LN.downloadCmpt);

      return file.path;
    } catch (e) {
      // print("Issue on save image $e");
      return null;
      // rethrow;
    }

    // return null;
    // Write the bytes to the file
  }

  // static Future<void> openFile(String filePath) async {
  //   // Open the file with the gallery app
  //   // log("open file path : $filePath");
  //   // final permission = await getPermission(Permission.photos);
  //   // if (!permission) return;
  //   // final _status =
  //   try {
  //     await OpenFilex.open(filePath);
  //   } catch (e) {
  //     //
  //   }

  //   // log("open file : ${_status.message}");
  // }

  static Future<String?> filePick({
    bool showRemoveTile = false,
    ImgAspectRatio? imgAspectRatio,
  }) async {
    if (CUS_CTX == null) return null;
    final value = await showDialog(
      context: CUS_CTX!,
      builder: (ctx) => SimpleDialog(
        titlePadding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 0.0),
        title: Text(
          LN.addPhoto,
          style: TextStyle(
            fontFamily: kFontFMedium,
          ),
        ),
        children: [
          ListTile(
            title: Text(
              LN.takeCamera,
              style: TextStyle(
                fontFamily: kFontFRegular,
              ),
            ),
            onTap: () {
              Navigator.of(ctx).pop(ImageSource.camera);
            },
          ),
          ListTile(
            title: Text(
              LN.takeGallery,
              style: TextStyle(
                fontFamily: kFontFRegular,
              ),
            ),
            onTap: () {
              Navigator.of(ctx).pop(ImageSource.gallery);
            },
          ),
          if (showRemoveTile)
            ListTile(
              title: Text(
                LN.removePhoto,
                style: TextStyle(
                  fontFamily: kFontFRegular,
                ),
              ),
              onTap: () {
                Navigator.of(ctx).pop(true);
              },
            ),
        ],
      ),
    );
    if (value == null) return null;
    if (value is bool && value) {
      return "";
    }
    if (value is! ImageSource) return null;

    return await pickFile(value, imgAspectRatio: imgAspectRatio);
  }

  // static Future<List<int>> _compressImage(Uint8List originalBytes) async {
  //   int quality = 100;
  //   List<int> compressedBytes = [];

  //   if (originalBytes.length <= (200 * 1024)) {
  //     return originalBytes;
  //   }

  //   while (compressedBytes.length > (200 * 1024) || compressedBytes.isEmpty) {
  //     compressedBytes = await FlutterImageCompress.compressWithList(
  //       originalBytes,
  //       quality: quality,
  //     );
  //     quality -= 10;
  //   }

  //   return compressedBytes;
  // }

  static Future<String?> pickFile(
    ImageSource value, {
    ImgAspectRatio? imgAspectRatio,
  }) async {
    final ImagePicker picker = ImagePicker();

    // final permission = await getPermission(
    //     value == ImageSource.gallery ? Permission.photos : Permission.camera);
    // if (!permission) return null;

    final result = await picker.pickImage(source: value);
    if (result == null) return null;
    return result.path;
    // log("Original : ${(await result.length()) * 0.001} Kb");

    // final croppedImageBytes = await result.readAsBytes();
    // final croppedImageBytes = await Navigator.push(
    //     CUS_CTX!,
    //     MaterialPageRoute(
    //         builder: (_) => ImageCropSection(
    //               image: imgByte,
    //               imgAspectRatio: imgAspectRatio,
    //             )));

    // if (croppedImageBytes == null || croppedImageBytes is! Uint8List)
    //   return null;

    // log("Cropped : ${(_croppedImageBytes.length) * 0.001} Kb");
    // final compressedByte = croppedImageBytes;
    // await _compressImage(_croppedImageBytes);
    // log("Compressed : ${(_compressedByte.length) * 0.001} Kb");
    // final file = await File(result.path).writeAsBytes(compressedByte);
    // return file.path;
  }

  static Future<List<String>?> getMedia(FileType type, {int count = 1}) async {
    // final permission = await getPermission(Permission.photos);
    // if (!permission) return null;

    try {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(type: type, allowMultiple: count != 1);

      if (result != null) {
        // result.files.forEach((e) {
        //   print("${e.name} ${e.path} ${e.size}");
        // });
        final _listPath = <String>[];
        for (final a in result.files) {
          if (a.path != null) _listPath.add(a.path!);
        }
        return _listPath;
      }
    } on PlatformException catch (p) {
      IfException.showMessage(
          message: p.message ?? "Can't handle the provided file type.");
    } catch (e) {
      IfException.showMessage(message: "Failed to pick files");
    }

    return null;
  }

  static String? base64ImageString(String? filePath) {
    if (filePath == null || filePath.isEmpty) return null;
    return base64Encode(File(filePath).readAsBytesSync());
  }

  static Future<File?> base64ImageFile(String? base64) async {
    if (base64 == null || base64.isEmpty) return null;
    return await File('${Utils.getRandomString(5)}.jpg')
        .writeAsBytes(base64Decode(base64));
  }

  static Future<bool> getPermission(Permission per) async {
    double version = double.tryParse((await _getAndVer) ?? '') ?? 0;

    Permission permission = per;

    if ((per == Permission.photos ||
            per == Permission.videos ||
            per == Permission.mediaLibrary ||
            per == Permission.camera) &&
        version <= 12) {
      permission = Permission.storage;
    }

    PermissionStatus permissionStatus = await permission.status;
    // print("PermissionStatus === $_permission=========== $permissionStatus");

    if (!permissionStatus.isGranted) {
      permissionStatus = await permission.request();
    }

    if (permissionStatus.isGranted) {
      return true;
    } else {
      showToast("Permission denied");
      return false;
    }
  }

  static Future<String?> get _getAndVer async {
    String? version;

    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;

      version = androidInfo.version.release;
    }
    // else if (Platform.isIOS) {
    //   final iosInfo = await deviceInfo.iosInfo;
    //   _version = iosInfo.systemVersion;
    // } else if (Platform.isMacOS) {
    //   final macInfo = await deviceInfo.macOsInfo;
    //   _version = macInfo.kernelVersion;
    // }
    return version;
  }

  static Future<String?> compressFile(
    String oldpath, {
    int height = 300,
    int width = 300,
  }) async {
    final dir = await path_provider.getTemporaryDirectory();
    final targetPath = "${dir.absolute.path}/temp.jpg";

    var result = await FlutterImageCompress.compressAndGetFile(
      oldpath,
      targetPath,
      quality: 85, // Adjust the quality between 0-100
      minWidth: width, // Target width
      minHeight: height, // Target height
    );

    return result?.path;
  }

  static Future<String?> getTempImagePathFromKey({
    GlobalKey? globalKey,
    String title = "",
    ImageSaveType saveType = ImageSaveType.print,
  }) async {
    if (globalKey == null) return null;

    final byte = await capture(key: globalKey);

    // print("3 -- ${DateTime.now()}");

    if (byte == null) return null;

    final filePath = await ImageService.saveFile(
      byte,
      "${title.replaceAll('/', '')}_${YMD_T_FORMAT.format(DateTime.now())}.jpg",
      saveType: saveType,
    );

    // print("4 -- ${DateTime.now()}");

    return filePath;
  }

  static Future<String?> compressFileFors3(
    String oldpath, {
    CompressFormat compressFormat = CompressFormat.webp,
    int quality = 90,
  }) async {
    final dir = await path_provider.getTemporaryDirectory();
    final targetPath = "${dir.path}/temp_image.webp";

    var result = await FlutterImageCompress.compressAndGetFile(
      oldpath,
      targetPath,
      quality: quality, // Adjust the quality between 0-100
      format: compressFormat,
    );

    return result?.path;
  }
}

enum ImageSaveType { download, share, print }
