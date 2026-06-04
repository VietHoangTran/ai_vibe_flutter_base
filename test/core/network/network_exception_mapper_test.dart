import 'package:ai_vibe_flutter_base/core/error/app_exception.dart';
import 'package:ai_vibe_flutter_base/core/network/network_exception_mapper.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final requestOptions = RequestOptions(path: '/users');

  group('mapDioException', () {
    test('uses the message field from a JSON error body', () {
      final error = DioException(
        requestOptions: requestOptions,
        response: Response<Object?>(
          requestOptions: requestOptions,
          statusCode: 422,
          data: {'message': 'Email already taken'},
        ),
        type: DioExceptionType.badResponse,
      );

      final result = mapDioException(error);

      expect(result, isA<NetworkException>());
      expect(result.message, 'Email already taken');
      expect(result.statusCode, 422);
      expect(result.cause, error);
    });

    test('falls back to error and detail keys', () {
      final withError = mapDioException(
        DioException(
          requestOptions: requestOptions,
          response: Response<Object?>(
            requestOptions: requestOptions,
            data: {'error': 'Boom'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );
      expect(withError.message, 'Boom');

      final withDetail = mapDioException(
        DioException(
          requestOptions: requestOptions,
          response: Response<Object?>(
            requestOptions: requestOptions,
            data: {'detail': 'Not allowed'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );
      expect(withDetail.message, 'Not allowed');
    });

    test('uses a plain string body when present', () {
      final result = mapDioException(
        DioException(
          requestOptions: requestOptions,
          response: Response<Object?>(
            requestOptions: requestOptions,
            data: 'Service unavailable',
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(result.message, 'Service unavailable');
    });

    test('maps timeouts to friendly default messages', () {
      final connectTimeout = mapDioException(
        DioException(
          requestOptions: requestOptions,
          type: DioExceptionType.connectionTimeout,
        ),
      );
      expect(connectTimeout.message, 'Connection timed out');

      final connectionError = mapDioException(
        DioException(
          requestOptions: requestOptions,
          type: DioExceptionType.connectionError,
        ),
      );
      expect(connectionError.message, 'Unable to connect to the server');
    });

    test('ignores blank message fields and uses the default', () {
      final result = mapDioException(
        DioException(
          requestOptions: requestOptions,
          response: Response<Object?>(
            requestOptions: requestOptions,
            data: {'message': '   '},
          ),
          type: DioExceptionType.cancel,
        ),
      );

      expect(result.message, 'Request was cancelled');
    });
  });
}
