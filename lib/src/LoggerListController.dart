import 'package:dotup_dart_logger/dotup_dart_logger.dart';

import 'ILoggerController.dart';
import 'ListStack.dart';
import 'LogLevelFilter.dart';

typedef LogEntryReader = Future<List<LogEntry>> Function(int currentItemsCount, int parialItemsCount);

class LoggerListController extends ILoggerController {
  bool _notify = true;
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
      if (_notify) notifyListeners();
    });
    entries = ListStack(stackSize);
    LoggerManager.addLogWriter(logWriter);
  }

  @override
  set stackSize(int value) {
    entries.length = value;
  }

  @override
  int get stackSize {
    return entries.size;
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
  void toggleNotifier() {
    _notify = (!_notify);
  }

  @override
  bool get isNotifing => _notify;

  @override
  void dispose() {
    super.dispose();
    LoggerManager.removeLogWriter(logWriter);
  }

  Future<void> loadMore() async {
    final result = await logEntryReader(entries.length, pageSize);
    if (result.isNotEmpty) {
      entries.addAll(result);
      notifyListeners();
    }
  }
}
