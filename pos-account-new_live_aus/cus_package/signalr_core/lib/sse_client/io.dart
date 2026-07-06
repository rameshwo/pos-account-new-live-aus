import 'dart:async';
import 'dart:io';

import 'package:http/http.dart';

import 'src/event_source_transformer.dart';
import 'src/sse_client.dart';

bool _isConnectionDropError(Object error) =>
    error is SocketException ||
    (error is ClientException &&
        (error.message.contains('Connection closed') ||
            error.message.contains('connection abort') ||
            error.message.contains('Connection reset') ||
            error.message.contains('Connection refused') ||
            error.message.contains('Failed host lookup') ||
            error.message.contains('Connection timed out') ||
            error.message.contains('Network is unreachable')));

class IOSseClient extends SseClient {
  IOSseClient(Stream stream) : super(stream: stream);

  factory IOSseClient.connect(Uri uri) {
    late StreamController<String?> incomingController;
    final client = Client();

    incomingController = StreamController<String?>.broadcast(onListen: () {
      var request = Request('GET', uri)
        ..headers['Accept'] = 'text/event-stream';

      client.send(request).then((response) {
        if (response.statusCode == 200) {
          response.stream.transform(EventSourceTransformer()).listen(
            (event) {
              incomingController.sink.add(event.data);
            },
            onError: (error) {
              if (_isConnectionDropError(error)) {
                if (!incomingController.isClosed) {
                  incomingController.close();
                }
                return;
              }
              if (!incomingController.isClosed) {
                incomingController.addError(error);
              }
            },
            onDone: () {
              if (!incomingController.isClosed) {
                incomingController.close();
              }
            },
            cancelOnError: false,
          );
        } else {
          incomingController
              .addError(Exception('Failed to connect to ${uri.toString()}'));
        }
      }).catchError((error) {
        if (!incomingController.isClosed) {
          if (_isConnectionDropError(error)) {
            incomingController.close();
          } else {
            incomingController.addError(error);
          }
        }
      });
    }, onCancel: () {
      if (!incomingController.isClosed) {
        incomingController.close();
      }
    });

    return IOSseClient(incomingController.stream);
  }
}
