import 'dart:async';
// ignore: deprecated_member_use
import 'dart:html';

import 'src/sse_client.dart';

class HtmlSseClient extends SseClient {
  HtmlSseClient(Stream stream) : super(stream: stream);

  factory HtmlSseClient.connect(Uri uri, {bool withCredentials = false}) {
    final incomingController = StreamController<String?>();
    final eventSource =
        EventSource(uri.toString(), withCredentials: withCredentials);

    // ignore: cascade_invocations
    eventSource.addEventListener('message', (Event message) {
      incomingController.add((message as MessageEvent).data as String?);
    });

    return HtmlSseClient(incomingController.stream);
  }
}
