import 'package:grpc/grpc.dart';

extension GrpcErrorExtensions on GrpcError {
  String handle() {
    return switch (code) {
      StatusCode.deadlineExceeded => 'Request timed out, please try again',
      StatusCode.unauthenticated =>
        'You are not authorized to perform this action',
      StatusCode.permissionDenied => 'Access denied',
      StatusCode.notFound => 'Requested resource not found',
      StatusCode.unavailable => 'Service unavailable. Please try again later',
      _ => message ?? 'Unknown GRPC Error: $codeName',
    };
  }
}
