import 'dart:async';

import 'package:flutter/foundation.dart';

/// Debouncer is a lazy runner for dart
///
/// API:
///   - run(VoidCallback)
///   - dispose()
///
/// [action] passed in run method will be excecuted after [miliseconds] miliseconds (passed in constructor).
/// But if there are multiple call of run method then previous calls will be canceled and only last call will be excecuted.
/// [dispose] method can help to cancel the task.
class Debouncer {
  final int miliseconds;
  Timer? _timer;

  Debouncer(this.miliseconds);

  void run(VoidCallback action) {
    if (_timer != null) _timer!.cancel();
    _timer = Timer(Duration(milliseconds: miliseconds), action);
  }

  void dispose() {
    if (_timer != null) _timer!.cancel();
  }
}
