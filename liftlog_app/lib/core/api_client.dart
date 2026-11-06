import 'package:dio/dio.dart';
import 'token_storage.dart';

/// Ganti saat run: --dart-define=API_URL=http://192.168.1.5:8000/api
const String kApiBaseUrl = String.fromEnvironment(
  'API_URL',
  defaultValue: 'http://10.0.2.2:8000/api', // emulator Android
);

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, List<String>> errors;

  ApiException(this.message, {this.statusCode, this.errors = const {}});

  @override
  String toString() => message;
}

class ApiClient {
  ApiClient(this._tokens, {this.onUnauthorized}) {
    dio = Dio(BaseOptions(
      baseUrl: kApiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Accept': 'application/json'},
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _tokens.read();
        if (token != null) options.headers['Authorization'] = 'Bearer $token';
        handler.next(options);
      },
      onError: (e, handler) {
        if (e.response?.statusCode == 401) onUnauthorized?.call();
        handler.next(e);
      },
    ));
  }

  final TokenStorage _tokens;
  void Function()? onUnauthorized;
  late final Dio dio;

  Future<dynamic> get(String path, {Map<String, dynamic>? query}) =>
      _send(() => dio.get(path, queryParameters: query));

  Future<dynamic> post(String path, {Object? data}) =>
      _send(() => dio.post(path, data: data));

  Future<dynamic> put(String path, {Object? data}) =>
      _send(() => dio.put(path, data: data));

  Future<dynamic> delete(String path) => _send(() => dio.delete(path));

  Future<dynamic> _send(Future<Response> Function() call) async {
    try {
      final res = await call();
      return res.data;
    } on DioException catch (e) {
      throw _toApiException(e);
    }
  }

  ApiException _toApiException(DioException e) {
    final status = e.response?.statusCode;
    final body = e.response?.data;

    if (body is Map) {
      final errors = <String, List<String>>{};
      final raw = body['errors'];
      if (raw is Map) {
        raw.forEach((k, v) => errors[k.toString()] = List<String>.from(v));
      }
      final message = errors.isNotEmpty
          ? errors.values.first.first
          : (body['message']?.toString() ?? 'Terjadi kesalahan');
      return ApiException(message, statusCode: status, errors: errors);
    }

    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      return ApiException('Tidak dapat terhubung ke server. Periksa koneksi.');
    }
    return ApiException('Terjadi kesalahan', statusCode: status);
  }
}