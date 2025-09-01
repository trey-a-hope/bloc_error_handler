import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grpc/grpc.dart';
import 'dart:async';

import 'package:logger/logger.dart';

part 'entities/error_state.dart';

final Logger _logger = Logger(
  printer: PrefixPrinter(
    PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      noBoxingByDefault: false,
    ),
  ),
  output: null,
);

Future<void> runWithErrorHandling<T extends ErrorState>({
  required Future<void> Function() action,
  required Emitter<T> emit,
  required T state,
}) async {
  try {
    return await action();
  } on DioException catch (e) {
    final errorMessage = e.message ?? 'Unknown DioException has occurred.';
    _logger.e(errorMessage);
    emit(state.copyWith(error: errorMessage) as T);
  } on GrpcError catch (e) {
    final errorMessage = e.message ?? 'Unknown GRPC Error: ${e.codeName}';
    _logger.e(errorMessage);
    emit(state.copyWith(error: errorMessage) as T);
  } catch (e) {
    final errorMessage = 'Unexpected error: ${e.toString()}';
    _logger.e(errorMessage);
    emit(state.copyWith(error: errorMessage) as T);
  }
}
