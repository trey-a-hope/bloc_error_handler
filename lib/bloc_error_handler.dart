import 'package:bloc_error_handler/extensions/_extensions.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grpc/grpc.dart';
import 'dart:async';

part 'entities/error_state.dart';

Future<void> catchError<T extends ErrorState>({
  required Future<void> Function() action,
  required Emitter<T> emit,
  required T state,
}) async {
  try {
    return await action();
  } catch (e) {
    final errorMessage = _getErrorMessage(e);
    emit(state.copyWith(error: errorMessage) as T);
  }
}

// Default error message mapping - can be overridden
String _getErrorMessage(dynamic error) {
  return switch (error.runtimeType) {
    DioException _ => (error as DioException).handle(),
    GrpcError _ => (error as GrpcError).handle(),
    TimeoutException _ => 'Request timed out, please try again',
    _ => error.toString(),
  };
}
