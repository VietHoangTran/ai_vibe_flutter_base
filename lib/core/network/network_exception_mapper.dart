import 'package:dio/dio.dart';

import '../error/app_exception.dart';

NetworkException mapDioException(DioException error) {
  final message = _extractMessage(error.response?.data) ?? _defaultMessage(error);

  return NetworkException(
    message,
    cause: error,
    statusCode: error.response?.statusCode,
  );
}

String? _extractMessage(Object? data) {
  if (data is Map) {
    final message = data['message'] ?? data['error'] ?? data['detail'];
    if (message is String && message.trim().isNotEmpty) return message;
  }

  if (data is String && data.trim().isNotEmpty) return data;

  return null;
}

String _defaultMessage(DioException error) {
  return switch (error.type) {
    DioExceptionType.connectionTimeout => 'Connection timed out',
    DioExceptionType.sendTimeout => 'Request timed out while sending data',
    DioExceptionType.receiveTimeout => 'Request timed out while receiving data',
    DioExceptionType.badCertificate => 'Invalid server certificate',
    DioExceptionType.badResponse => 'Server returned an invalid response',
    DioExceptionType.cancel => 'Request was cancelled',
    DioExceptionType.connectionError => 'Unable to connect to the server',
    DioExceptionType.unknown => error.message ?? 'Unknown network error',
  };
}
