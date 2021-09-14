import 'package:dotup_dart_logger/dotup_dart_logger.dart';
import 'package:flutter/widgets.dart';

import 'SizeLimitedList.dart';
import 'LogLevelFilter.dart';
import 'Utils.dart';

class LoggerListController with ChangeNotifier {
  late bool liveMode;
  LogLevel? _levelFilter;
  final LogEntryReader? logEntryReader;
  final int pageSize;
  late final SizeLimitedList<LogEntry> _entries;
  late final CallbackLogWriter logWriter;

  LoggerListController({
    required int stackSize,
    this.logEntryReader,
    this.pageSize = 50,
    this.liveMode = false,
  }) {
    _entries = SizeLimitedList(size: stackSize, reverse: false);
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
    filtered.sort((a, b) => b.timeStamp.compareTo(a.timeStamp));
    return filtered;
  }

  Future<void> setLiveMode(bool isLive) async {
    _entries.clear();
    _entries.changeCheckSize(isLive);
    liveMode = isLive;
    await loadMore();
    notifyListeners();
  }

  void setFilter(List<LogLevelFilter> logLevelStates) {
    _levelFilter = logLevelStates
        .where(
          (element) => element.levelEnabled,
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
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    LoggerManager.removeLogWriter(logWriter);
  }

  Future<void> loadMore({reset = false}) async {
    // Exit on live mode or if log entry provider is missing
    if (liveMode == true || logEntryReader == null) {
      return;
    }

    // Remove already loaded entries. Usually with RefreshIndicator.
    if (reset == true) {
      _entries.clear();
    }

    final result = await logEntryReader!(_entries.length, pageSize);
    if (result.isNotEmpty) {
      _entries.addAll(result);
      notifyListeners();
    }
  }
}
