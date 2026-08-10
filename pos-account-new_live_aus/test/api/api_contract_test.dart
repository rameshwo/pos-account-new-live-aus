import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('API methods', () {
    test('GET returns success data and sends authentication headers', () async {
      final client = _TestApiClient(
        MockClient((request) async {
          expect(request.method, 'GET');
          expect(request.headers['Authorization'], 'Bearer token');
          return http.Response(jsonEncode({'data': 'ok'}), 200);
        }),
        tokenProvider: () async => 'token',
      );

      final response = await client.get('/products');

      expect(response.statusCode, 200);
      expect(response.body, {'data': 'ok'});
    });

    test('POST, PUT, PATCH, and DELETE send JSON bodies and parse success',
        () async {
      final seenMethods = <String>[];
      final client = _TestApiClient(
        MockClient((request) async {
          seenMethods.add(request.method);
          expect(request.headers['Content-Type'], contains('application/json'));
          if (request.method != 'DELETE') {
            expect(jsonDecode(request.body), containsPair('name', 'Coffee'));
          }
          return http.Response(jsonEncode({'ok': true}), 200);
        }),
      );

      await client.post('/products', {'name': 'Coffee'});
      await client.put('/products/1', {'name': 'Coffee'});
      await client.patch('/products/1', {'name': 'Coffee'});
      await client.delete('/products/1');

      expect(seenMethods, ['POST', 'PUT', 'PATCH', 'DELETE']);
    });
  });

  group('API errors and validation', () {
    test('maps server errors and validation errors', () async {
      final client = _TestApiClient(
        MockClient((request) async {
          if (request.url.path.endsWith('/validation')) {
            return http.Response(
              jsonEncode({
                'errors': {'name': 'Required'}
              }),
              422,
            );
          }
          return http.Response(jsonEncode({'message': 'Server error'}), 500);
        }),
      );

      final validation = await client.post('/validation', {});
      final server = await client.get('/server-error');

      expect(validation.statusCode, 422);
      expect(validation.body['errors']['name'], 'Required');
      expect(server.statusCode, 500);
      expect(server.body['message'], 'Server error');
    });

    test('returns offline error when transport fails', () async {
      final client = _TestApiClient(
        MockClient((request) async => throw Exception('No internet')),
      );

      final response = await client.get('/products');

      expect(response.statusCode, 503);
      expect(response.body['error'], 'offline');
    });
  });

  group('API retry, timeout, authentication, authorization, and rate limits',
      () {
    test('retries transient failures and eventually succeeds', () async {
      var calls = 0;
      final client = _TestApiClient(
        MockClient((request) async {
          calls++;
          if (calls < 3) {
            return http.Response(jsonEncode({'message': 'busy'}), 503);
          }
          return http.Response(jsonEncode({'data': 'recovered'}), 200);
        }),
        maxRetries: 2,
      );

      final response = await client.get('/retry');

      expect(calls, 3);
      expect(response.statusCode, 200);
      expect(response.body['data'], 'recovered');
    });

    test('returns timeout response when request exceeds timeout', () async {
      final client = _TestApiClient(
        MockClient((request) async {
          await Future<void>.delayed(const Duration(milliseconds: 50));
          return http.Response('{}', 200);
        }),
        timeout: const Duration(milliseconds: 1),
      );

      final response = await client.get('/slow');

      expect(response.statusCode, 408);
      expect(response.body['error'], 'timeout');
    });

    test('refreshes token on 401 and retries the original request', () async {
      var calls = 0;
      final client = _TestApiClient(
        MockClient((request) async {
          calls++;
          if (calls == 1) {
            expect(request.headers['Authorization'], 'Bearer expired');
            return http.Response(jsonEncode({'message': 'expired'}), 401);
          }
          expect(request.headers['Authorization'], 'Bearer fresh');
          return http.Response(jsonEncode({'data': 'authorized'}), 200);
        }),
        tokenProvider: () async => calls == 0 ? 'expired' : 'fresh',
        refreshToken: () async => 'fresh',
      );

      final response = await client.get('/secure');

      expect(calls, 2);
      expect(response.statusCode, 200);
      expect(response.body['data'], 'authorized');
    });

    test('does not retry forbidden authorization failures', () async {
      var calls = 0;
      final client = _TestApiClient(
        MockClient((request) async {
          calls++;
          return http.Response(jsonEncode({'message': 'forbidden'}), 403);
        }),
        maxRetries: 3,
      );

      final response = await client.delete('/admin-only');

      expect(calls, 1);
      expect(response.statusCode, 403);
    });

    test('honors rate limiting responses without retrying unsafe requests',
        () async {
      var calls = 0;
      final client = _TestApiClient(
        MockClient((request) async {
          calls++;
          return http.Response(
            jsonEncode({'message': 'Too many requests'}),
            429,
            headers: {'retry-after': '60'},
          );
        }),
        maxRetries: 2,
      );

      final response = await client.post('/checkout', {'total': 10});

      expect(calls, 1);
      expect(response.statusCode, 429);
      expect(response.retryAfter, const Duration(seconds: 60));
    });
  });
}

class _ApiResponse {
  final int statusCode;
  final Map<String, dynamic> body;
  final Duration? retryAfter;

  const _ApiResponse(this.statusCode, this.body, {this.retryAfter});
}

class _TestApiClient {
  final http.Client _client;
  final Future<String?> Function()? tokenProvider;
  final Future<String?> Function()? refreshToken;
  final int maxRetries;
  final Duration timeout;

  const _TestApiClient(
    this._client, {
    this.tokenProvider,
    this.refreshToken,
    this.maxRetries = 0,
    this.timeout = const Duration(seconds: 5),
  });

  Future<_ApiResponse> get(String path) => _send('GET', path);

  Future<_ApiResponse> post(String path, Map<String, Object?> body) =>
      _send('POST', path, body: body);

  Future<_ApiResponse> put(String path, Map<String, Object?> body) =>
      _send('PUT', path, body: body);

  Future<_ApiResponse> patch(String path, Map<String, Object?> body) =>
      _send('PATCH', path, body: body);

  Future<_ApiResponse> delete(String path) => _send('DELETE', path);

  Future<_ApiResponse> _send(
    String method,
    String path, {
    Map<String, Object?>? body,
    int attempt = 0,
    String? overrideToken,
  }) async {
    try {
      final token = overrideToken ?? await tokenProvider?.call();
      final request = http.Request(method, Uri.parse('https://pos.test$path'));
      request.headers.addAll({
        'Accept': 'application/json',
        if (body != null) 'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      });
      if (body != null) {
        request.body = jsonEncode(body);
      }

      final streamed = await _client.send(request).timeout(timeout);
      final response = await http.Response.fromStream(streamed);
      final parsed = _decode(response.body);

      if (response.statusCode == 401 && refreshToken != null && attempt == 0) {
        final fresh = await refreshToken!.call();
        return _send(method, path,
            body: body, attempt: 1, overrideToken: fresh);
      }

      if (_isRetryable(method, response.statusCode) && attempt < maxRetries) {
        return _send(method, path, body: body, attempt: attempt + 1);
      }

      return _ApiResponse(
        response.statusCode,
        parsed,
        retryAfter: _retryAfter(response.headers['retry-after']),
      );
    } on TimeoutException {
      return const _ApiResponse(408, {'error': 'timeout'});
    } catch (error) {
      return _ApiResponse(503, {'error': 'offline', 'message': '$error'});
    }
  }

  bool _isRetryable(String method, int statusCode) {
    if (method != 'GET') return false;
    return statusCode == 408 ||
        statusCode == 500 ||
        statusCode == 502 ||
        statusCode == 503;
  }

  Map<String, dynamic> _decode(String body) {
    if (body.isEmpty) return {};
    final decoded = jsonDecode(body);
    return decoded is Map<String, dynamic> ? decoded : {'data': decoded};
  }

  Duration? _retryAfter(String? value) {
    final seconds = int.tryParse(value ?? '');
    return seconds == null ? null : Duration(seconds: seconds);
  }
}
