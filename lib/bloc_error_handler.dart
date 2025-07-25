import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grpc/grpc.dart';
import 'dart:async';

part 'entities/error_state.dart';

Future<void> runWithErrorHandling<T extends ErrorState>({
  required Future<void> Function() action,
  required Emitter<T> emit,
  required T state,
}) async {
  try {
    return await action();
  } on DioException catch (e) {
    final errorMessage = e.message ?? 'Unknown DioException has occurred.';
    emit(state.copyWith(error: errorMessage) as T);
  } on GrpcError catch (e) {
    final errorMessage = e.message ?? 'Unknown GRPC Error: ${e.codeName}';
    emit(state.copyWith(error: errorMessage) as T);
  } catch (e) {
    final errorMessage = 'Unexpected error: ${e.toString()}';
    emit(state.copyWith(error: errorMessage) as T);
  }
}
