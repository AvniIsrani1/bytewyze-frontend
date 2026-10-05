import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiClient {
  // we dont have this set for now bc we are running locally (if we deploy or move it later, we can set this)
  static const String _configuredBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
  );

  static const Duration _connectTimeout = Duration(seconds: 10);
  static const Duration _receiveTimeout = Duration(seconds: 10);

  ApiClient._();

  static Dio? _dio;

  static Dio get instance => _dio ??= _build();

  static String get baseUrl {
    if (_configuredBaseUrl.isNotEmpty) {
      return _configuredBaseUrl;
    }
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8000';
    }
    return 'http://localhost:8000';
  }

  static Dio _build() {
    return Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: _connectTimeout,
        receiveTimeout: _receiveTimeout,
        responseType: ResponseType.json,
      ),
    );
  }

  @visibleForTesting
  static set instance(Dio dio) => _dio = dio;
}
