import 'dart:async';
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
          //  else {
          //   showToast("packet == null",
          //       duration: Duration(seconds: 10), backgroundColor: Colors.red);
          // }
        }
      });
    } catch (e) {
      // print("Exception on UDP calls : $e");
      // showToast("Something went wrong with listening incoming calls.",
      //     backgroundColor: Colors.red);
    }
  }

  void stopListening() {
    _socket?.close();
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
    RegExp myPattern = RegExp(
        ".*(\\d\\d) ([IO]) ([ES]) (\\d{4}) ([GB]) (.)(\\d) (\\d\\d/\\d\\d \\d\\d:\\d\\d [AP]M) (.{8,15})(.*)");
    Match? matcher = myPattern.firstMatch(myData);

    final callData = CallerIdData();

    if (matcher != null) {
      callData.line = matcher.group(1);

      // String myType = matcher.group(2) ?? ''; // I => known call | O => Unknown call

      String myIndicator = matcher.group(3) ?? '';
      if (myIndicator == "S") {
        callData.isCallStart = true;
      } else if (myIndicator == "E") {
        callData.isCallStart = false;
      }

      // Unused in this app but available for other custom apps
      callData.duration = matcher.group(4);
      // String myCheckSum = matcher.group(5)!;
      callData.ringCount = matcher.group(6);

      //------------------------------------------------------

      callData.dateTime = matcher.group(8);

      callData.number = matcher.group(9);

      callData.name = matcher.group(10);

      // Clipboard.setData(ClipboardData(
      //     text:
      //         "Indicator :$myIndicator, myDuration :$myDuration, myCheckSum :$myCheckSum, myNumber :$myNumber, myDateTime :$myDateTime, myRings :$myRings"));
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
