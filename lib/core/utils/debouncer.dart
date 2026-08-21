import 'dart:async';

import 'package:flutter/foundation.dart';

class Debouncer {
  Debouncer({this.milliseconds = 400});

  final int milliseconds;
  VoidCallback? _callback;
  Timer? _timer;

  void run(VoidCallback callback) {
    _callback = callback;
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), _execute);
  }

  void _execute() {
    _callback?.call();
  }

  void dispose() {
    _timer?.cancel();
  }
}
