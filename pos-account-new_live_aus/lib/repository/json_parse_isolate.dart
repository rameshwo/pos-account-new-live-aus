import 'dart:convert';
import 'dart:isolate';
import 'package:flutter/foundation.dart';

/// Parses JSON on a background isolate to keep the UI thread jank-free.
///
/// Usage:
/// ```dart
/// final data = await JsonParseIsolate.decode(res.body);
/// final loginRes = LoginRes.fromJson(data);
/// ```
///
/// Falls back to synchronous [jsonDecode] on web platforms where isolates
/// are not available.
class JsonParseIsolate {
  /// Decodes [jsonString] on a background isolate.
  ///
  /// Returns the decoded [Map] or [List] result.
  /// On web (or if isolate creation fails), falls back to [jsonDecode].
  static Future<dynamic> decode(String jsonString) async {
    // Web does not support [Isolate.spawn] – fall back to sync decode.
    if (kIsWeb) {
      return jsonDecode(jsonString);
    }

    try {
      return await compute(_isolateDecode, jsonString);
    } catch (_) {
      // Fallback in case isolate creation fails for any reason.
      return jsonDecode(jsonString);
    }
  }

  /// Top-level function required by [compute]/[Isolate.spawn].
  static dynamic _isolateDecode(String jsonString) {
    return jsonDecode(jsonString);
  }
}