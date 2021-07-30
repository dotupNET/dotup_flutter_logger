import 'package:dotup_dart_logger/dotup_dart_logger.dart';
import 'package:dotup_flutter_logger/src/LoggerView.dart';
import 'package:flutter/material.dart';

import 'ILoggerController.dart';
import 'ListStack.dart';
import 'LogLevelFilter.dart';

class LoggerLiveController extends ILoggerController {
  LogLevel _logLevel = LogLevel.All;

  bool _notify = true;

  late final ListStack<LogEntry> entries;
  late final CallbackLogWriter logWriter;

  LogLevel? _levelFilter;

  LoggerLiveController(int stackSize) {
    logWriter = CallbackLogWriter(_logLevel, (newEntry) {
      entries.add(newEntry);
      if (_notify) notifyListeners();
    });
    entries = ListStack(stackSize);
    LoggerManager.addLogWriter(logWriter);
  }

  set stackSize(int value) {
    entries.length = value;
  }

  int get stackSize {
    return entries.size;
  }

  void filter(List<LogLevelFilter> logLevelStates) {
    _levelFilter = logLevelStates
        .where(
          (element) => element.state,
        )
        .map(
          (e) => e.value,
        )
        .reduce(
      (
        value,
        element,
      ) {
        return value | element;
      },
    );
    logWriter.logLevel = _levelFilter!;
  }

  @override
  void toggleNotifier() {
    print('object');
    _notify = (!_notify);
  }

  @override
  bool get isNotifing => _notify;
}
