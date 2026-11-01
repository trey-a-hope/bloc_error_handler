# bloc_error_handler

A small helper that removes the try/catch boilerplate from [flutter_bloc](https://pub.dev/packages/flutter_bloc) event handlers. Wrap your handler's work in `runWithErrorHandling` and any Dio, gRPC or other exception is logged and emitted as an error state for you.

[pub.dev/packages/bloc_error_handler](https://pub.dev/packages/bloc_error_handler)

## Features

- `runWithErrorHandling<T extends ErrorState>({action, emit, state})` runs your async `action` and catches failures.
- Understands `DioException` (uses its message), `GrpcError` (message or code name) and falls back to `toString()` for anything else.
- Logs every error with [`logger`](https://pub.dev/packages/logger) before emitting `state.copyWith(error: message)`.
- `ErrorState` is the tiny contract your states implement: an `error` getter and `copyWith({String? error})`.

## Installation

```yaml
dependencies:
  bloc_error_handler: ^0.0.6
```

## Usage

```dart
import 'package:bloc_error_handler/bloc_error_handler.dart';

class ItemsState extends ErrorState {
  const ItemsState({this.items = const [], this.error});
  final List<String> items;
  @override
  final String? error;

  @override
  ItemsState copyWith({List<String>? items, String? error}) =>
      ItemsState(items: items ?? this.items, error: error);
}

on<LoadItems>((event, emit) => runWithErrorHandling(
      emit: emit,
      state: state,
      action: () async {
        final items = await repository.fetchItems();
        emit(state.copyWith(items: items));
      },
    ));
```

## Project structure

```
lib/
├── bloc_error_handler.dart   # runWithErrorHandling and the logger
└── entities/error_state.dart # ErrorState contract
```

## Development

```sh
flutter pub get
flutter test
```

Requires Dart `^3.8.1`. Dependencies: `flutter_bloc`, `dio`, `grpc`, `logger`. See `CHANGELOG.md` for version history.

## License

The `LICENSE` file currently contains placeholder text, so no license has been chosen yet.
