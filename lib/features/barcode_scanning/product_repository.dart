import 'package:dio/dio.dart';
import 'package:local_fork/core/models/product.dart';
import 'package:local_fork/core/network/api_client.dart';

class ProductLookupException implements Exception {
  final String message;

  const ProductLookupException(this.message);

  @override
  String toString() => 'ProductLookupException: $message';
}

abstract class ProductRepository {
  Future<Product> lookup(String barcode);
}

// looks products up through the backend
class ApiProductRepository implements ProductRepository {
  final Dio _dio;

  ApiProductRepository({Dio? dio}) : _dio = dio ?? ApiClient.instance;

  @override
  Future<Product> lookup(String barcode) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/products/$barcode',
      );

      final data = response.data;
      if (data == null) {
        throw const ProductLookupException('Empty response from the server.');
      }

      return Product.fromJson(data);
    } on DioException catch (e) {
      throw ProductLookupException(_describe(e));
    }
  }

  String _describe(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return 'The lookup timed out.';
      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        return 'Could not reach the server. Check your connection.';
      case DioExceptionType.badResponse:
        return 'Lookup failed (${e.response?.statusCode}).';
      case DioExceptionType.cancel:
        return 'The lookup was canceled.';
      case DioExceptionType.badCertificate:
        return 'The server certificate was rejected.';
    }
  }
}
