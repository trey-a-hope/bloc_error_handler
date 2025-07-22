part of '../bloc_error_handler.dart';

abstract class ErrorState {
  const ErrorState();
  String? get error;
  ErrorState copyWith({String? error});
}
