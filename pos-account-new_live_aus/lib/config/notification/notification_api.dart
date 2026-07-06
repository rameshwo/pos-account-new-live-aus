import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_http_logger/flutter_http_logger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/firebase_options.dart';
import 'package:pos_account/ln.dart';
import 'package:pos_account/screens/home_screen/com/dialogs/enable_notification.dart';
import 'package:rxdart/rxdart.dart';
import 'notification_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:dart_ping_ios/dart_ping_ios.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // WidgetsFlutterBinding.ensureInitialized();

  // kPrint("received : background/Foreground notification");

  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  // await NotificationApi.setUp();
  // // AppEnviro.setupEnv(Enviroment.UAT);
  // AppEnviro.setupEnv(Enviroment.PROD); //TODO

  // try {
  //   // final _data = SyncNotiData(actiontype: "PrintOrder").toJson();
  //   await NotificationHandler.syncInBackground(
  //       // _data
  //       message.data);
  //   kPrint("background/Foreground notification: ${json.encode(message.data)} ");
  // } catch (e) {
  //   kPrint("Error: background/Foreground notification: $e");
  // }
}

final _notifications = FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel _channel = AndroidNotificationChannel(
  // 'id',
  // 'All',
  'sync_channel',
  'Sync Channel',
  importance: Importance.high,
  playSound: true,
  sound: RawResourceAndroidNotificationSound('delay'),
);

class NotificationApi {
  static final onNotifications = BehaviorSubject<String?>();

  static Future<void> init() async {
    if (Platform.isIOS) {
      DartPingIOS.register();
    }
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
  }

  static bool notifcationEnable = false;

  static void askPermission() async {
    notifcationEnable = await Permission.notification.isGranted;
    // kPrint("notifcationEnable: $notifcationEnable");

    if (!notifcationEnable) {
      final _status = await Permission.notification.request();
      // kPrint("_status $_status");
      if ((_status == PermissionStatus.permanentlyDenied ||
              _status == PermissionStatus.denied) &&
          CUS_CTX != null) {
        await Future.delayed(Duration(seconds: 2));
        await NotificationPopup.show(CUS_CTX!, onEnable: () async {
          await openAppSettings();
          Navigator.pop(CUS_CTX!);
        });
      }
      notifcationEnable = _status == PermissionStatus.granted;
    }
  }

  static Future setUp(
      // {  Function(String?)? onSelect,
      //   Function(int, String?, String?, String?)? onDidReceive,}
      ) async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = DarwinInitializationSettings();

    final settings = InitializationSettings(
      android: android,
      iOS: iOS,
    );

    final details = await _notifications.getNotificationAppLaunchDetails();

    if (details != null && details.didNotificationLaunchApp) {}

    _notifications.initialize(settings);
  }

  static Future onFirebaseMessage() async {
    // await FirebaseMessaging.instance.getInitialMessage();
    // await NotificationApi.init();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      // AndroidNotification? android = message.notification?.android;
      // if (notification != null) {
      //   notiId = notification.hashCode;
      //   showNotification(
      //       id: notiId!,
      //       title: notification.title,
      //       body: notification.body,
      //       payload: jsonEncode(message.data));
      // }
      NotificationHandler.sync(message.data,
          title: notification?.title, body: notification?.body);
      kPrint("notification data: ${json.encode(message.data)}");
      HttpLog.sendLog(
        id: DateTime.now().millisecondsSinceEpoch,
        method: "FIREBASE",
        url: 'sync',
        header: {},
        request: {
          "title": notification?.title ?? '',
          "body": notification?.body ?? '',
        },
        duration: 0,
        statusCode: 200,
        response: message.data,
      );
    });
  }

  static Future<void> onStartApp() async {
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      kPrint(
          "${event.data} --- onMessageOpenedApp : getting notification while app is on background/foreground or app was terminated & on notification tap");
      NotificationHandler.onClickNotification(
        json.encode(event.data),
      );
    });

    FirebaseMessaging.instance.getInitialMessage().then((event) {
      kPrint(
          '${event?.notification?.title} message ${event?.data} --- getInitialMessage : when app is launched');
      if (event != null) {
        NotificationHandler.onClickNotification(
          json.encode(event.data),
        );
      }
    });
    onNotifications.stream.listen((String? payload) {
      kPrint(
          '--$payload -- onNotifications stream | getting notification while app is on screen & on notification tap');
      NotificationHandler.onClickNotification(
        payload,
      );
    });
  }

  static Future showNotification({
    required int id,
    String? title,
    String? body,
    String? payload,
  }) async =>
      _notifications.show(
          id, title, body, await _notificationDetails(payload: payload),
          payload: payload);

  static Future _notificationDetails({String? payload}) async {
    final _data = json.decode(payload ?? '');
    final _image = _data['image'];

    final _imageInfo =
        _image != null ? await _getImageInfo(imageUrl: _image) : null;
    return NotificationDetails(
        android: AndroidNotificationDetails(
          // _channel.id,
          // _channel.name,
          'sync_channel',
          'Sync Channel',
          channelDescription: 'Background sync',
          importance: Importance.high,
          styleInformation: _imageInfo,
          sound: RawResourceAndroidNotificationSound('delay'),
        ),
        iOS: const DarwinNotificationDetails(
          sound: 'delay.wav',
        ));
  }

  static Future<void> showSyncNotification({
    required int id,
    String? title,
    String? body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'sync_channel',
      'Sync Channel',
      channelDescription: 'Background sync',
      importance: Importance.high,
      priority: Priority.high,
      playSound: false,
      enableVibration: false,
      showWhen: false,
      ongoing: true,
    );

    const details = NotificationDetails(android: androidDetails);

    await _notifications.show(
      id,
      title,
      body,
      details,
    );
  }

  static int? notiId;

  static Future cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  static Future cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  static Future<BigPictureStyleInformation> _getImageInfo(
      {String? title, String? body, required String imageUrl}) async {
    // Download image
    final response = await http.get(Uri.parse(imageUrl));
    final bytes = response.bodyBytes;

    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/notification_image.jpg';
    final file = File(filePath);
    await file.writeAsBytes(bytes);

    return BigPictureStyleInformation(
      FilePathAndroidBitmap(filePath),
      contentTitle: title,
      summaryText: body,
    );
  }

  // static void onSelectNotification(String? payload, BuildContext ctx) async {
  //   if (payload != null) {}
  //   // await Navigator.push(
  //   //   ctx,
  //   //   MaterialPageRoute<void>(builder: (context) => const NotifyScreen()),
  //   // );
  // }

  // static void onDidReceiveLocalNotification(int id, String? title, String? body,
  //     String? payload, BuildContext ctx) async {
  //   // display a dialog with the notification details, tap ok to go to another page
  //   showDialog(
  //     context: ctx,
  //     builder: (BuildContext context) => CupertinoAlertDialog(
  //       title: Text(title ?? ''),
  //       content: Text(body ?? ''),
  //       actions: [
  //         CupertinoDialogAction(
  //           isDefaultAction: true,
  //           child: Text('Ok'),
  //           onPressed: () async {
  //             Navigator.of(context, rootNavigator: true).pop();
  //             // await Navigator.push(
  //             //   context,
  //             //   MaterialPageRoute(
  //             //     builder: (context) => const NotifyScreen(),
  //             //   ),
  //             // );
  //           },
  //         )
  //       ],
  //     ),
  //   );
  // }
}
