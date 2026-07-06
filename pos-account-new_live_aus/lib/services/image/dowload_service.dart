// import 'dart:isolate';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
// import 'package:oktoast/oktoast.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:path_provider/path_provider.dart';

// class DownloadSection extends StatefulWidget {
//   final Widget child;
//   final String? url;
//   final Color? onTapHighlightColor;
//   final double onTapBorderRadius;
//   const DownloadSection({
//     super.key,
//     required this.child,
//     this.url,
//     this.onTapHighlightColor,
//     this.onTapBorderRadius = 100,
//   }) ;

//   @override
//   State<DownloadSection> createState() => _DownloadSectionState();
// }

// class _DownloadSectionState extends State<DownloadSection> {
//   final service = DownloadService();

//   Future<void> download() async {
//     if (widget.url == null || widget.url!.isEmpty) return;

//     PermissionStatus permissionStatus = await Permission.storage.status;
//     if (!permissionStatus.isGranted) {
//       permissionStatus = await Permission.storage.request();
//     }
//     if (!permissionStatus.isGranted) {
//       showToast("Storage permission is not allowed");
//       return;
//     }
//     final _baseStorage = await getExternalStorageDirectory();
//     if (_baseStorage == null) return;

//     await FlutterDownloader.enqueue(
//       url: widget.url!,
//       savedDir: _baseStorage.path,
//       showNotification: true,
//       openFileFromNotification: true,
//       saveInPublicStorage: true,
//     );
//   }

//   @override
//   void initState() {
//     service.init();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     service.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//         onTap: download,
//         highlightColor: widget.onTapHighlightColor,
//         borderRadius: BorderRadius.circular(widget.onTapBorderRadius),
//         child: widget.child);
//   }
// }

// class DownloadService {
//   final _port = ReceivePort();

//   void init() {
//     IsolateNameServer.registerPortWithName(
//         _port.sendPort, 'downloader_send_port');
//     // _port.listen((dynamic data) {
//     // String id = data[0];
//     // DownloadTaskStatus status = DownloadTaskStatus(data[1]);
//     // int progress = data[2];
//     // setState((){ });
//     // });

//     FlutterDownloader.registerCallback(_downloadCallback);
//   }

//   void close() {
//     IsolateNameServer.removePortNameMapping('downloader_send_port');
//   }

//   @pragma('vm:entry-point')
//   static void _downloadCallback(
//       String id, DownloadTaskStatus status, int progress) {
//     final SendPort? send =
//         IsolateNameServer.lookupPortByName('downloader_send_port');
//     send?.send([id, status, progress]);
//   }
// }
