import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_http_logger/flutter_http_logger.dart';
import 'package:pos_account/constant/constant.dart';
import 'package:pos_account/env.dart';
import 'package:pos_account/model/common/message.dart';
import 'package:pos_account/providers/auth/auth_pro.dart';
import 'package:pos_account/repository/handler.dart';
import 'package:pos_account/repository/if_exception.dart';
import 'package:pos_account/services/database/shared_pref.dart';
import 'package:signalr_core/signalr_core.dart';
import 'utils/data_sync_utils.dart';
import 'utils/stk_event_utils.dart';
import '../database/database/db_local_data.dart';
import 'model/heartbeat_res.dart';

class SignalRCore {
  static String? _deviceId; // Your unique identifier

  static final String _baseUrl = AppEnviro.socketUrl;

  static Future<void> _setDeviceId() async {
    // _deviceId = "963f2b21-9dc1-4e8e-afca-08dcf826ffa3";
    _deviceId = (await DbLocalData.getAllStores())?.id;

    if (_deviceId == null || _deviceId!.isEmpty) {
      final _serverStoreRes = await Handler.getStoreList();
      DbLocalData.updateAllStores(data: _serverStoreRes);
      _deviceId = _serverStoreRes?.id;
    }
  }

  static HubConnection? _hubConnection;

  static HubConnection? get hubConnection => _hubConnection;

  // ..serverTimeoutInMilliseconds = 3600000 // Increase from default 30s
  // ..keepAliveIntervalInMilliseconds = 2400000;

  static ConnectionStatus status = ConnectionStatus.Connecting;

  static bool doReconnecting = true;

  static Future<bool?> connectToSignalR({
    required Function() load,
    int retryCount = 0,
  }) async {
    final _authStatus = await SharedPrefs.isAuth;
    try {
      if (_authStatus != AuthStatus.AUTHENTICATE.name) return null;

      _showLogs("Getting device ID...");

      await _setDeviceId();

      final hubUrl = "$_baseUrl?deviceId=$_deviceId";

      _hubConnection = HubConnectionBuilder().withUrl(hubUrl, [
        HttpConnectionOptions(
          transport: HttpTransportType.webSockets,
          skipNegotiation: true, // directly start with WebSockets
          logging: (level, message) {
            _showLogs("hubUrl Logs ${level.name} :$message...");
          },
        )
      ]).withAutomaticReconnect(
        [0, 1000, 2000, 5000],
      ).build();
      // ..serverTimeoutInMilliseconds = 1000
      // ..keepAliveIntervalInMilliseconds = 5000;

      if (_deviceId == null || _deviceId!.isEmpty) {
        status = ConnectionStatus.Offline;
        _showLogs("Device ID  = null");
        load();
        return null;
      }

      if (_hubConnection?.state == HubConnectionState.connected) {
        status = ConnectionStatus.Online;
        _showLogs("ConnectionStatus Online");
        load();
        return true;
      }

      if (_hubConnection?.state == HubConnectionState.connecting ||
          _hubConnection?.state == HubConnectionState.reconnecting) {
        status = ConnectionStatus.Connecting;
        _showLogs("Already connecting or reconnecting...");
        load();
        return null;
      }

      _showLogs("Connecting... url: $hubUrl");

      await _hubConnection?.start();

      status = ConnectionStatus.Online;
      load();

      _showLogs("Started...");
    } on SocketException catch (_) {
      //
      status = ConnectionStatus.Offline;
      load();
    } catch (e) {
      _showLogs("Connection error: $e | Device ID: $_deviceId");
      status = ConnectionStatus.Connecting;
      load();
      await Future.delayed(Duration(seconds: 5));
      if (doReconnecting &&
          _authStatus == AuthStatus.AUTHENTICATE.name &&
          retryCount < 25) {
        return await connectToSignalR(
          load: load,
          retryCount: retryCount + 1,
        );
      } else
        return false;
    }

    await _registerDevice();
    _startHeartbeat();

    return true;
  }

  static Future<void> stop(
      // {required Function() load}
      ) async {
    doReconnecting = false;
    try {
      if (_hubConnection != null &&
          _deviceId != null &&
          _hubConnection!.state == HubConnectionState.connected) {
        _hubConnection!.off("ReceivePrintOrderDataEvent");
        await _hubConnection!.invoke("UnRegisterDevice", args: [_deviceId]);
      }
    } catch (e) {
      _showLogs("Exception UnRegisterDevice $e");
    }

    _stopHeartbeat();

    try {
      if (_hubConnection != null &&
          (_hubConnection!.state != HubConnectionState.disconnected ||
              _hubConnection!.state != HubConnectionState.disconnecting)) {
        await _hubConnection!.stop();
      }
    } catch (e) {
      _showLogs("_hubConnection Stop Error: $e");
    }

    _deviceId = null;

    status = ConnectionStatus.Offline;
    _showLogs("SignalR fully stopped.");
    // load();
  }

  static void listen({
    required Function() load,
  }) {
    _showLogs("Listening .... ");

    try {
      _hubConnection?.on("ReceivePrintOrderDataEvent", (message) {
        _showLogs(
          "ReceivePrintOrderDataEvent: ${json.encode(message)}",
          sendLogs: false,
        );

        HttpLog.sendLog(
          method: "SIGNALR",
          url: '/ReceivePrintOrderDataEvent',
          header: {"deviceId": '$_deviceId'},
          statusCode: 200,
          duration: 0,
          response: message,
        );
        if (message?.isNotEmpty ?? false) {
          StkEventUtils.newOrder(payload: message);
        }
      });

      _hubConnection?.on("ReceiveDataChangeSyncEvent", (message) {
        _showLogs(
          "ReceiveDataChangeSyncEvent: ${json.encode(message)}",
          sendLogs: false,
        );

        HttpLog.sendLog(
          method: "SIGNALR",
          url: '/ReceiveDataChangeSyncEvent',
          header: {"deviceId": '$_deviceId'},
          statusCode: 200,
          duration: 0,
          response: message,
        );
        if (message?.isNotEmpty ?? false) {
          DataSyncUtils.event(payload: message);
        }
      });

      _hubConnection?.on("heartbeat-ack", (message) {
        HttpLog.sendLog(
          method: "SIGNALR",
          url: '/heartbeat-ack',
          header: {"deviceId": '$_deviceId'},
          statusCode: 200,
          duration: 0,
          response: message,
        );

        if (message?.isNotEmpty ?? false) {
          final _res = List<HeartbeatRes>.from(
              message!.map((x) => HeartbeatRes.fromJson(x)));

          final _timeDiff =
              ((_res.first.serverTime ?? 0) - (_res.first.timestamp ?? 0))
                  .abs();
          _showLogs(
            "heartbeat-ack: $_timeDiff ms",
            sendLogs: false,
          );

          // if (_timeDiff > 3000) {
          //   IfException.showMessage(
          //       message: "Slow Internet Connection", isWarn: true);
          // }
        }
      });

      _hubConnection?.on("info", (message) {
        _showLogs(
          "info: ${json.encode(message)}",
          sendLogs: false,
        );

        HttpLog.sendLog(
          method: "SIGNALR",
          url: '/info',
          header: {"deviceId": '$_deviceId'},
          statusCode: 200,
          duration: 0,
          response: message,
        );

        if (message?.isNotEmpty ?? false) {
          final _res =
              List<Message>.from(message!.map((x) => Message.fromJson(x)));
          IfException.showMessage(
              message: _res.first.message ?? '', isError: false);
        }
      });

      _hubConnection?.on("error", (message) {
        _showLogs(
          "Error: ${json.encode(message)}",
          sendLogs: false,
        );

        HttpLog.sendLog(
          method: "SIGNALR",
          url: '/info',
          header: {"deviceId": '$_deviceId'},
          statusCode: 200,
          duration: 0,
          response: message,
        );
        if (message?.isNotEmpty ?? false) {
          final _res =
              List<Message>.from(message!.map((x) => Message.fromJson(x)));
          IfException.showMessage(message: _res.first.message ?? '');
        }
      });

      _hubConnection?.onreconnecting((error) {
        _showLogs("Reconnecting: $error");
        status = ConnectionStatus.Reconnecting;
        load();
      });

      _hubConnection?.onreconnected((connectionId) async {
        _showLogs("Reconnected: $connectionId");
        status = ConnectionStatus.Online;

        load();
        await _registerDevice();
        _startHeartbeat();
      });

      _hubConnection?.onclose((error) async {
        _showLogs("Disconnected!! ${error ?? ''}");
        if (!doReconnecting) return;

        status = ConnectionStatus.Connecting;
        load();
        _stopHeartbeat();
        // Manual retry loop
        final _authStatus1 = await SharedPrefs.isAuth;
        if (doReconnecting && _authStatus1 == AuthStatus.AUTHENTICATE.name)
          while (true) {
            final _authStatus2 = await SharedPrefs.isAuth;
            if (doReconnecting &&
                _authStatus2 == AuthStatus.AUTHENTICATE.name &&
                (_hubConnection?.state == HubConnectionState.disconnected ||
                    _hubConnection!.state ==
                        HubConnectionState.disconnecting)) {
              try {
                await _hubConnection?.start();
                _showLogs("Manually reconnected.");
                status = ConnectionStatus.Online;
                load();
                await _registerDevice();
                break;
              } catch (e) {
                status = ConnectionStatus.Connecting;
                load();
                _showLogs("Manual reconnect failed. Retrying in 5s... $e");
                await Future.delayed(const Duration(seconds: 5));
              }
            } else {
              await Future.delayed(const Duration(seconds: 3));
              if (_hubConnection?.state != HubConnectionState.connected) {
                status = ConnectionStatus.Offline;
                load();
              }
              _showLogs("Not in disconnected state");
              break;
            }
          }
      });
    } catch (e) {
      _showLogs("Connection error: $e");
    }
  }

  /// ==============================
  /// REGISTER
  /// ==============================
  static Future<void> _registerDevice() async {
    // try {
    //   if (_deviceId != null) {
    //     await _hubConnection?.invoke(
    //       "RegisterDevice",
    //       args: [_deviceId],
    //     );
    //     _showLogs("Device Registered");
    //   }
    // } catch (e) {
    //   _showLogs("_registerDevice error: $e");
    // }
  }

  /// ==============================
  /// HEARTBEAT (Prevents ALB timeout)
  /// ==============================

  // static final _stopwatch = Stopwatch();

  static Future<void> heartbeat() async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    await _hubConnection?.invoke("Heartbeat", args: [_deviceId, timestamp]);
  }

  static Timer? _heartbeatTimer;

  static void _startHeartbeat() {
    _stopHeartbeat();
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (_hubConnection?.state == HubConnectionState.connected) {
        heartbeat();
      }
    });
  }

  static void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  static void _showLogs(String message, {bool sendLogs = true}) {
    kPrint(message);
    if (sendLogs)
      HttpLog.sendLog(
        method: "SIGNALR",
        url: '/logs',
        header: {"deviceId": '$_deviceId'},
        statusCode: 200,
        duration: 0,
        response: message,
      );
  }

  //   void requestIgnoreBatteryOptimization() async {
  //   await Permission.ignoreBatteryOptimizations.request();
  // }
}

enum ConnectionStatus { Online, Offline, Connecting, Reconnecting }
