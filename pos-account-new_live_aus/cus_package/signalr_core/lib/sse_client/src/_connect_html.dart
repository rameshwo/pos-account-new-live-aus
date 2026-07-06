import 'package:signalr_core/sse_client/html.dart';
import 'sse_client.dart';

SseClient connect(Uri uri) => HtmlSseClient.connect(uri);
