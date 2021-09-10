import 'package:dotup_dart_logger/dotup_dart_logger.dart';
import 'package:flutter/widgets.dart';

import 'ILoggerController.dart';
import 'ListStack.dart';
import 'LogLevelFilter.dart';

typedef LogEntryReader = Future<List<LogEntry>> Function(int currentItemsCount, int parialItemsCount);

class LoggerListController with ChangeNotifier {
  bool liveMode = true;
  LogLevel? _levelFilter;
  final LogEntryReader logEntryReader;
  final int pageSize;
  late final ListStack<LogEntry> _entries;
  late final CallbackLogWriter logWriter;

  LoggerListController({
    required int stackSize,
    required this.logEntryReader,
    this.pageSize = 50,
  }) {
    _entries = ListStack(stackSize);
    logWriter = CallbackLogWriter(LogLevel.All, (newEntry) {
      _entries.add(newEntry);
      if (liveMode) notifyListeners();
    });
    LoggerManager.addLogWriter(logWriter);
  }

  set stackSize(int value) {
    _entries.setSize(value);
    if (liveMode) notifyListeners();
  }

  int get stackSize {
    return _entries.size;
  }

  List<LogEntry> get entries {
    final filter = _levelFilter ?? LogLevel.All;
    final filtered = _entries.where((element) => filter.isLevel(element.logLevel)).toList();
    return filtered;
  }

  @override
  Future<void> setLiveMode(bool isLive) async {
    _entries.clear();
    _entries.changeCheckSize(isLive);
    liveMode = isLive;
    await loadMore();
    notifyListeners();
  }

  @override
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
    if (liveMode) notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    LoggerManager.removeLogWriter(logWriter);
  }

  Future<void> loadMore() async {
    if (liveMode == true) {
      return;
    }
    final result = await logEntryReader(_entries.length, pageSize);
    if (result.isNotEmpty) {
      _entries.addAll(result);
      notifyListeners();
    }
  }
}
