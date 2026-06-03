sealed class AppException implements Exception {
  const AppException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => 'AppException(message: $message, cause: $cause)';
}

final class NetworkException extends AppException {
  const NetworkException(super.message, {super.cause, this.statusCode});

  final int? statusCode;
}

final class StorageException extends AppException {
  const StorageException(super.message, {super.cause});
}

final class AuthException extends AppException {
  const AuthException(super.message, {super.cause});
}
