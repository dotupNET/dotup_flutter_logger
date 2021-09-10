import 'package:dotup_dart_logger/dotup_dart_logger.dart';

import 'ILoggerController.dart';
import 'ListStack.dart';
import 'LogLevelFilter.dart';

typedef LogEntryReader = Future<List<LogEntry>> Function(int currentItemsCount, int parialItemsCount);

class LoggerListController extends ILoggerController {
  bool liveMode = true;
  LogLevel? _levelFilter;
  final LogEntryReader logEntryReader;
  final int pageSize;

  LoggerListController({
    required int stackSize,
    required this.logEntryReader,
    this.pageSize = 50,
  }) {
    logWriter = CallbackLogWriter(LogLevel.All, (newEntry) {
      entries.add(newEntry);
      if (liveMode) notifyListeners();
    });
    entries = ListStack(stackSize);
    LoggerManager.addLogWriter(logWriter);
  }

  @override
  set stackSize(int value) {
    entries.setSize(value);
  }

  @override
  int get stackSize {
    return entries.size;
  }

  @override
  Future<void> setLiveMode(bool isLive) async {
    entries.clear();
    entries.changeCheckSize(isLive);
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
    final result = await logEntryReader(entries.length, pageSize);
    if (result.isNotEmpty) {
      entries.addAll(result);
      notifyListeners();
    }
  }
}
