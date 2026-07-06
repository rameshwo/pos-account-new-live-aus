import 'dart:io';
import 'package:http/http.dart';
import 'package:ping_discover_network_forked/ping_discover_network_forked.dart';
import 'phone_service.dart';

class LocalServer {
  // sender

  static const _port = 8080;
  static final _client = Client();

  static Future<String?> _myIp() async {
    try {
      final interfaces = await NetworkInterface.list(
          type: InternetAddressType.IPv4, includeLinkLocal: true);
      return interfaces
          .where((e) => e.addresses.first.address.indexOf('192.') == 0)
          .first
          .addresses
          .first
          .address;
    } catch (e) {
      // print('192.. IP is not found $e');
    }
    return null;
  }

  static void _listenIpAddress({
    String ip = "192.168.1.1",
    int port = 8080,
    Future<void> Function(List<String>)? run,
  }) {
    final String subnet = ip.substring(0, ip.lastIndexOf('.'));
    // print("'---------------subnet: $_subnet");
    final netWorkStream =
        NetworkAnalyzer.discover2(subnet, port, timeout: Duration(seconds: 2));

    final ipList = <String>[];

    netWorkStream.listen((event) {
      if (event.exists) {
        // print("'---------------IP: ${event.ip}");
        if (!ipList.any((e) => e == event.ip)) {
          ipList.add(event.ip);
        }
      }
    }).onDone(() {
      // print('---------------search ip done');
      if (run != null) run(ipList);
    });
  }

  static Future<void> sendData({String? number}) async {
    if (number == null) return;

    final ip = await _myIp();
    _listenIpAddress(
        ip: ip ?? "192.168.1.1",
        port: _port,
        run: (ipList) async {
          for (final e in ipList) {
            final uri = Uri.parse(
                "http://$e:$_port/pos-apt/incoming-call?number=$number");

            // print("url: $_uri");
            await _client.get(
              uri,
              headers: {
                'Content-type': 'application/json',
                'Accept': 'application/json',
              },
            );
          }
        });
  }

  // receiver

  static Future<void> initServer() async {
    try {
      final httpserver =
          await HttpServer.bind(InternetAddress.anyIPv4, _port, shared: true);
      // print(
      //     'Server Listening on ${httpserver.address.address}:${httpserver.port}');

      httpserver.listen((event) async {
        if (event.method == 'GET') {
          // print("'---------------path: ${event.uri.path}");
          // print("'---------------query: ${event.uri.query}");
          // print("'---------------data: ${event.uri.queryParameters}");

          if (event.uri.path == "/pos-apt/incoming-call") {
            final num = event.uri.queryParameters['number'];
            // print("'---------------_num: $_num");
            PhoneService.removeWidget(phoneNumber: num, serverUpdate: false);
            // remove pop up with num
          }
        }
        // else if (event.method == 'POST') {
        //   final _data = await event.first;
        //   final stringData = String.fromCharCodes(_data);
        // }
        event.response
          ..statusCode = HttpStatus.badRequest
          // ..write('')
          ..close();
      });
    } catch (e) {
      // print('Error in starting server $e');
    }
  }
}
