import 'package:dio/dio.dart';

extension DioExceptionExtensions on DioException {
  String handle() {
    final statusCode = response?.statusCode;
    return switch (statusCode) {
      401 => 'You are not authorized to perform this action',
      403 => 'Access denied',
      404 => 'Requested resource not found',
      500 => 'Server error occurred. Please try again later',
      _ => message ?? 'Network request failed',
    };
  }
}
