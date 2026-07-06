import '../io.dart';
import 'sse_client.dart';

SseClient connect(Uri uri) => IOSseClient.connect(uri);
