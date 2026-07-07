import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:pos_account/ln.dart';
import 'phone_service.dart';

abstract class ServiceCallbacks {
  void display(String message);
}

class UDPListen {
  final ServiceCallbacks? serviceCallbacks;
  final String host;
  final int port;

  RawDatagramSocket? _socket;

  UDPListen({
    required this.serviceCallbacks,
    required this.host,
    required this.port,
  });

  Future<void> startListening() async {
    try {
      _socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, port);
      _socket?.broadcastEnabled = true;

      _socket?.listen((RawSocketEvent event) {
        if (event == RawSocketEvent.read) {
          Datagram? packet = _socket?.receive();
          if (packet != null) {
            String message = String.fromCharCodes(packet.data);
            serviceCallbacks?.display(message);
          }
        }
      });
    } catch (e, s) {
      log("Exception on UDP startListening: $e", stackTrace: s);
    }
  }

  void stopListening() {
    _socket?.close();
    _socket = null;
  }
}

class CallerIdService {
  static late UDPListen _udpListen;

  static void init() {
    _udpListen = UDPListen(
      serviceCallbacks: MyServiceCallbacks(),
      host: '255.255.255.255',
      port: 3520,
    );
    _udpListen.startListening();
  }

  static void stop() {
    _udpListen.stopListening();
  }

  // static void sendData(String data) {
  //   // You can call this function to send data
  //   _udpListen._socket
  //       ?.send(data.codeUnits, InternetAddress.anyIPv4, _udpListen.port);
  // }
}

class MyServiceCallbacks implements ServiceCallbacks {
  @override
  void display(String message) {
    // Handle received message here, e.g., update UI
    final callData = _getCallInfo(message);

    if (callData.isCallStart ?? false) {
      PhoneService.showWidget(
          phoneNumber: callData.number, line: callData.line);
    } else {
      if (CUS_CTX != null) {
        PhoneService.removeWidget(phoneNumber: callData.number);
      }
    }
  }

  CallerIdData _getCallInfo(String myData) {
    final myPattern = RegExp(
        r'.*(?<line>\d{2}) (?<type>[IO]) (?<indicator>[ES]) (?<duration>\d{4}) (?<checksum>[GB]) (?<ringCount>.)(\d) (?<dateTime>\d{2}/\d{2} \d{2}:\d{2} [AP]M) (?<number>.{8,15})(?<name>.*)');
    final Match? matcher = myPattern.firstMatch(myData);

    final callData = CallerIdData();

    if (matcher != null) {
      callData.line = matcher.namedGroup('line');

      // final String myType = matcher.namedGroup('type') ?? ''; // I => known call | O => Unknown call
      final String myIndicator = matcher.namedGroup('indicator') ?? '';
      if (myIndicator == "S") {
        callData.isCallStart = true;
      } else if (myIndicator == "E") {
        callData.isCallStart = false;
      }

      callData.duration = matcher.namedGroup('duration');
      callData.ringCount = matcher.namedGroup('ringCount');
      callData.dateTime = matcher.namedGroup('dateTime');
      callData.number = matcher.namedGroup('number');
      callData.name = matcher.namedGroup('name');
    }

    return callData;
  }
}

class CallerIdData {
  String? line;
  bool? isCallStart;
  String? number;
  String? dateTime;
  String? duration;
  String? ringCount;
  String? name;

  CallerIdData({
    this.line,
    this.isCallStart,
    this.number,
    this.dateTime,
    this.duration,
    this.ringCount,
    this.name,
  });
}

// .*: Matches any character (except for line terminators) zero or more times. This is a wildcard that matches any characters before the pattern.
// (\\d\\d): Matches exactly two digits (0-9).
// ([IO]): Matches either the character "I" or "O".
// ([ES]): Matches either the character "E" or "S".
// (\\d{4}): Matches exactly four digits (0-9).
// ([GB]): Matches either the character "G" or "B".
// (.): Matches any single character except for line terminators.
// (\\d): Matches exactly one digit (0-9).
// (\\d\\d/\\d\\d \\d\\d:\\d\\d [AP]M): Matches a date and time in the format "MM/DD HH:MM AM/PM".
// (.{8,15}): Matches any character (except for line terminators) between 8 and 15 times.
// (.*): Matches any character (except for line terminators) zero or more times. This
